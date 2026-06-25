# Design: split del módulo `infrastructure/aws/iam/agent` en rol agente + rol de permisos

Fecha: 2026-06-19

## Contexto

Hoy el módulo `infrastructure/aws/iam/agent` crea un único rol IRSA
(`nullplatform_agent_role`) confiado por el OIDC provider del cluster, con todas
las políticas pegadas directamente:

- `nullplatform_route53_policy`
- `nullplatform_eks_policy`
- `nullplatform_elb_policy`
- `nullplatform_avp_policy`
- `nullplatform_assume_role_policy` (condicional, solo si `assume_role_arns` no está vacío)
- `var.additional_policies`

El token IRSA del service account, por lo tanto, tiene acceso directo a todos
esos permisos.

## Objetivo

Aplicar separación de privilegios (*role chaining*):

- El rol IRSA (Rol A) queda solo con capacidad de `sts:AssumeRole`.
- Un nuevo rol de permisos (Rol B) concentra las políticas reales y confía en
  el Rol A.

Esto reduce el blast radius del token IRSA: el token por sí solo no puede tocar
Route53/EKS/ELB/AVP; primero tiene que asumir el Rol B.

## Arquitectura resultante

```
Service Account (K8s)
   │ OIDC / IRSA
   ▼
Rol A: nullplatform-{cluster}-agent-role            ← rol agente (IRSA)
   │  política única: sts:AssumeRole → [ Rol B, *assume_role_arns ]
   │  + additional_policies (sin cambios)
   ▼ (assume)
Rol B: nullplatform-{cluster}-agent-permissions-role ← rol de permisos (NUEVO)
      trust: principal AWS = ARN de Rol A
      políticas pegadas: route53, eks, elb, avp
```

## Decisiones de diseño

1. **Qué políticas se mueven al Rol B:** solo las 4 gestionadas (route53, eks,
   elb, avp). `additional_policies` se siguen pegando al Rol A.
2. **`assume_role_arns`:** el permiso se otorga en el Rol A. El Rol A puede
   asumir tanto el Rol B como los `assume_role_arns` externos (se mantiene el
   comportamiento actual de a quién apunta el agente).
3. **Outputs:** se mantiene `nullplatform_agent_role_arn` (Rol A) y se agrega
   `nullplatform_agent_permissions_role_arn` (Rol B). No rompe consumidores.

## Romper la dependencia circular

El Rol A necesita el ARN del Rol B (en su policy de assume) y el Rol B necesita
el ARN del Rol A (en su trust policy). Para evitar el ciclo en el grafo de
Terraform, ambos ARNs se construyen como `locals` a partir de
`data.aws_caller_identity.current` + los nombres (que ya son `locals`
deterministas, con `use_name_prefix = false`), sin referenciar el recurso del
otro rol.

## Cambios por archivo

- **`data.tf`**: agregar `data.aws_caller_identity.current`.
- **`main.tf`**:
  - `locals`: agregar `permissions_role_name`
    (default `nullplatform-{cluster}-agent-permissions-role`),
    `permissions_role_arn` y `agent_role_arn` (computados desde caller identity).
  - Módulo `nullplatform_agent_role` (Rol A): el mapa `policies` pasa a ser solo
    `nullplatform_assume_role_policy` + `var.additional_policies`. Se quitan
    route53/eks/elb/avp.
  - `aws_iam_policy.nullplatform_assume_role_policy`: deja de ser condicional
    (siempre se crea). `Resource = concat([local.permissions_role_arn], var.assume_role_arns)`.
    Se elimina el `count`. Se agrega `moved` block para migrar
    `nullplatform_assume_role_policy[0]` → `nullplatform_assume_role_policy`.
  - Nuevo `aws_iam_role.nullplatform_agent_permissions` (Rol B), con
    `assume_role_policy` cuyo principal AWS = `local.agent_role_arn`.
  - Nuevos 4 `aws_iam_role_policy_attachment` que pegan route53/eks/elb/avp al
    Rol B. Los `aws_iam_policy` de esas 4 se mantienen iguales (mismo contenido y
    nombres).
- **`variables.tf`**: agregar `permissions_role_name` (override, default `""`).
- **`outputs.tf`**: agregar `nullplatform_agent_permissions_role_arn`.
- **`tests/agent.tftest.hcl`**: la `assume_role_policy` ahora siempre existe (ya
  no es `[0]`); agregar el nuevo Rol B y attachments en los mocks; actualizar
  `assume_role_policy_not_created_by_default` (ahora sí se crea por defecto,
  apuntando al rol de permisos).
- **`README.md`**: regenerar descripción/arquitectura/features/inputs/outputs
  (bloques `BEGIN_TF_DOCS` y `BEGIN_AI_METADATA`).

## Extensión: múltiples roles de permisos

Además del rol de permisos default (fijo, con las 4 políticas), el módulo permite
crear N roles de permisos adicionales vía `var.permissions_roles` (mapa
`logical_name => { name?, policy_arns }`), resueltos con `for_each`:

- Cada entrada crea un `aws_iam_role.extra_permissions[key]` cuyo trust permite
  solo al rol agente asumirlo, y le pega los `policy_arns` provistos mediante
  `aws_iam_role_policy_attachment.extra_permissions` (clave `"role::arn"`).
- Los nombres y ARNs de los roles extra se computan en `locals`
  (`extra_permissions_role_names` / `extra_permissions_role_arns`) desde el nombre
  + account id, igual que el rol default, para mantener la política de assume del
  agente determinista y sin dependencias circulares.
- La política `sts:AssumeRole` del rol agente concatena:
  `[permissions_role_arn] + extra_permissions_role_arns + var.assume_role_arns`.
- Nuevo output `nullplatform_agent_extra_permissions_role_arns` (mapa
  `logical_name => arn`).

Roles que ya existen fuera del módulo siguen cubiertos por `var.assume_role_arns`
(no los crea el módulo, solo se permite asumirlos).

## Testing

`tofu test` sobre el módulo con el provider mockeado. Se verifica:
- Nombres de las 4 políticas (sin cambios).
- JSON válido de todas las políticas.
- El rol de permisos existe y tiene los 4 attachments.
- La assume policy del rol agente referencia el ARN del rol de permisos por
  defecto, y suma `assume_role_arns` cuando se proveen.
- El trust del rol de permisos referencia el ARN del rol agente.
