{{/*
Expand the name of the chart.
*/}}
{{- define "agent.name" -}}
{{- default "nullplatform-agent" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agent.labels" -}}
helm.sh/chart: {{ include "agent.chart" . }}
{{ include "agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Join a map into "k1=v1,k2=v2" for the agent's NP_WORKER_* env vars.
*/}}
{{- define "agent.kvJoin" -}}
{{- $pairs := list -}}
{{- range $k, $v := . -}}{{- $pairs = append $pairs (printf "%s=%s" $k $v) -}}{{- end -}}
{{- join "," $pairs -}}
{{- end -}}

{{/*
Render the worker orchestrator config as NP_WORKER_* env for the agent container.
The agent reads these (os.Getenv) to pick the backend and shape worker pods.
*/}}
{{- define "agent.workerEnv" -}}
{{- with .Values.worker }}
- name: NP_WORKER_BACKEND
  value: {{ .backend | default "kubernetes" | quote }}
- name: NP_WORKER_SECURITY
  value: {{ .security | default "mtls" | quote }}
- name: NP_WORKER_NAMESPACE
  value: {{ .namespace | default $.Values.namespace | quote }}
{{- if .allowedRegistries }}
- name: NP_ALLOWED_REGISTRIES
  value: {{ join "," .allowedRegistries | quote }}
{{- end }}
{{- if .pins }}
- name: NP_WORKERS
  value: {{ .pins | toJson | quote }}
{{- end }}
{{- if .rules }}
- name: NP_WORKER_RULES
  value: {{ .rules | toJson | quote }}
{{- end }}
{{- with .defaults }}
{{- if .serviceAccount }}
- name: NP_WORKER_SERVICE_ACCOUNT
  value: {{ .serviceAccount | quote }}
{{- end }}
{{- if .nodeSelector }}
- name: NP_WORKER_NODE_SELECTOR
  value: {{ include "agent.kvJoin" .nodeSelector | quote }}
{{- end }}
{{- if .labels }}
- name: NP_WORKER_LABELS
  value: {{ include "agent.kvJoin" .labels | quote }}
{{- end }}
{{- if .imagePullSecrets }}
- name: NP_WORKER_IMAGE_PULL_SECRETS
  value: {{ join "," .imagePullSecrets | quote }}
{{- end }}
{{- if .env }}
- name: NP_WORKER_ENV
  value: {{ include "agent.kvJoin" .env | quote }}
{{- end }}
{{- with .resources }}
{{- with .requests }}
{{- if .cpu }}
- name: NP_WORKER_CPU_REQUEST
  value: {{ .cpu | quote }}
{{- end }}
{{- if .memory }}
- name: NP_WORKER_MEM_REQUEST
  value: {{ .memory | quote }}
{{- end }}
{{- end }}
{{- with .limits }}
{{- if .cpu }}
- name: NP_WORKER_CPU_LIMIT
  value: {{ .cpu | quote }}
{{- end }}
{{- if .memory }}
- name: NP_WORKER_MEM_LIMIT
  value: {{ .memory | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}{{/* end with .defaults */}}
{{- end }}{{/* end with .Values.worker */}}
{{- end -}}
