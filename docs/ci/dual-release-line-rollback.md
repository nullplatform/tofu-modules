# Rollback runbook: dual release line (`package` → 7.x, resto → 6.x)

> **Para un agente (Claude u otro) que llega a este archivo sin contexto previo de la conversación en la que se creó:** este documento es autosuficiente. Seguí los pasos en orden. Antes de ejecutar CUALQUIER paso marcado como destructivo o visible para otros (push, merge, borrar una rama), **confirmá explícitamente con la persona que te pidió el rollback** — no asumas autorización solo por la existencia de este archivo.

## Qué es esto y por qué existe

En 2026-08 se introdujo un esquema temporal de doble línea de versión en este
repo:
- Ramas `package/*` → mergean a `main` → tagean sobre la línea `7.x`.
- Cualquier otra rama (`feat/*`, `fix/*`, `docs/*`, etc.) → mergean a una
  rama larga `6.x` (forkeada del tag `v6.11.2`) → tagean sobre la línea
  `6.x`.
- Breaking changes bloqueados en ambas líneas (sin excepción).

El motivo: `main` ya tenía publicado `v7.0.0` con un breaking change real
(PR #491), y se necesitaba seguir dando soporte/lanzando fixes y features
normales sin forzar a esos consumidores a saltar de major, mientras el
trabajo que sí requería la nueva major avanzaba de forma aislada en
`package/*`.

**Esto es temporal por diseño.** Este runbook describe cómo desarmarlo
cuando el equipo decida que ya no hace falta.

## Lo que este rollback SÍ hace y lo que NO hace

- **SÍ**: elimina los checks y triggers de CI agregados (el chequeo de base
  branch, el chequeo de que la rama realmente forkeó de la línea correcta,
  el bloqueo de breaking changes, el `package` en el pattern de
  branch-validation, los triggers extra de `6.x` en todos los workflows).
- **NO**: borra la rama `6.x` ni ninguno de sus commits/tags/releases. Todo
  el trabajo real (fixes, features, releases 6.x.x) que se haya mergeado a
  `6.x` mientras este esquema estuvo activo queda intacto — revertir la
  infraestructura de CI no revierte el trabajo de producto hecho sobre esa
  línea.
- La decisión de **qué hacer con la rama `6.x` en sí** (archivarla, seguir
  manteniéndola, mergearla hacia `main`, promoverla a nuevo `main`, etc.) es
  una decisión de negocio/arquitectura que este runbook NO toma por vos —
  ver la sección "Decisión pendiente: destino de `6.x`" al final.

## Paso 1: Encontrar el commit que introdujo este esquema

El PR que introdujo esto se tituló `"ci: temporary dual release line
(package -> 7.x, resto -> 6.x)"` y se mergeó con `--squash`, por lo que en
`main` quedó como un único commit con ese texto. El mismo commit se
propagó a `6.x` vía `cherry-pick` (mismo mensaje, otro SHA).

Run:
```bash
git fetch origin -q
git log --oneline --all --grep="dual release line"
```
Esto debería mostrar dos commits: uno alcanzable desde `main`, otro desde
`6.x`. Anotá ambos SHAs.

## Paso 2: Revertir en `main`

Run:
```bash
git checkout main && git pull origin main -q
git revert --no-edit <sha-en-main>
```
Si el revert aplica limpio, seguí al Paso 4. Si hay conflictos (porque
alguno de estos archivos se modificó después por otro motivo), resolvelos
usando la sección "Fallback manual" de abajo como referencia de qué
contenido final se espera en cada archivo, y después:
```bash
git add <archivos resueltos>
git revert --continue
```

## Paso 3: Revertir en `6.x`

Run:
```bash
git checkout 6.x && git pull origin 6.x -q
git revert --no-edit <sha-en-6.x>
```
Mismo criterio que el Paso 2 si hay conflictos.

## Paso 4: Push (requiere confirmación explícita antes de ejecutar)

```bash
git push origin main
git push origin 6.x
```

## Fallback manual (si `git revert` no aplica limpio)

Si por conflictos preferís revertir a mano, estos son los cambios exactos a
deshacer, archivo por archivo:

### `.github/workflows/commitlint.yml`
- Volver `on.pull_request.branches` a `[ main ]` (sacar `6.x`).
- Sacar el bloque `with: pattern: ...` del job `branch-name` (que vuelva a
  usar el pattern default de la reusable workflow, sin `package`).
- Borrar los jobs `base-branch-check`, `fork-point-check` y
  `no-breaking-changes` completos.

### `.husky/pre-commit`
- Volver `PATTERN` a:
  `"^(feat|feature|fix|docs|style|refactor|perf|test|build|ci|chore|revert)/.+$"`
  (sacar `|package`).
- Volver la condición a:
  `if [ "$BRANCH" != "main" ] && ! echo "$BRANCH" | grep -Eq "$PATTERN"; then`
  (sacar `&& [ "$BRANCH" != "6.x" ]`).
- Sacar `package` de la lista impresa de "Valid types".

### `.github/workflows/release.yml`
- Volver el trigger a:
  ```yaml
  on:
    push:
      branches:
        - main
  ```
- Volver la concurrency a:
  ```yaml
  concurrency:
    group: main-branch-push
    cancel-in-progress: false
  ```
- Volver las 3 referencias `release-please--branches--${{ github.ref_name }}`
  a `release-please--branches--main` (literal).

### `.github/workflows/auto-merge-release.yml`
- Volver `-f "head=${REPO_OWNER}:release-please--branches--${{ github.event.workflow_run.head_branch }}"`
  a `-f "head=${REPO_OWNER}:release-please--branches--main"` (literal).

### `.github/workflows/linter.yml`, `.github/workflows/tofu-test.yml`, `.github/workflows/tflint-unused.yml`
- Volver `branches: [ main, 6.x ]` a `branches: [ main ]` en cada uno.

### `.github/workflows/trivy.yml`
- Volver ambos triggers (`pull_request.branches` y `push.branches`) de
  `[main, 6.x]` a `[main]`.

### Este mismo archivo y su compañero de diseño
- Este runbook puede borrarse del repo una vez completado el rollback, o
  dejarse como registro histórico — a criterio del equipo.

## Decisión pendiente: destino de la rama `6.x`

Este runbook deliberadamente NO incluye pasos automáticos para esto, porque
depende de una decisión de producto/arquitectura que no se puede inferir
del código:

- **Si `7.x`/`package` convergió y es la única línea futura**: comunicar al
  equipo que `6.x` queda congelada/deprecada. Evaluar si conviene mergear
  el historial de `6.x` hacia `main` primero (para no perder fixes que solo
  existan ahí) antes de archivar o borrar la rama. Borrar una rama con
  historial real requiere confirmación explícita — no lo hagas sin
  preguntar.
- **Si se decide mantener `6.x` como línea de soporte de largo plazo**: este
  rollback de CI puede no ser lo que se quiere — replantear con quien pidió
  el rollback si realmente quiere sacar el mecanismo o solo ajustarlo.
- **Si se decide que `6.x` pasa a ser la línea principal** (descartando el
  trabajo de `7.x`/`package`): esto es un cambio mucho más invasivo
  (reescribir qué rama es el default branch del repo, qué pasa con los
  tags `7.x` ya publicados, etc.) — fuera del alcance de este runbook,
  pedir instrucciones explícitas antes de tocar nada.
