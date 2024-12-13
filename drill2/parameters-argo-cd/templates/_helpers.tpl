{{/*
Expand the name of the chart.
*/}}
{{- define "parameters-argo-cd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "parameters-argo-cd.fullname" -}}
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
{{- define "parameters-argo-cd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "parameters-argo-cd.labels" -}}
helm.sh/chart: {{ include "parameters-argo-cd.chart" . }}
{{ include "parameters-argo-cd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create ArgoCD-specific labels for WP.
Usage: {{ include "mychart.argocd.labels" . }}
*/}}
{{- define "mychart.argocd.wp.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-wp
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/namespace: "argocd"
{{- end }}

{{/*
Create ArgoCD-specific labels for DB.
Usage: {{ include "mychart.argocd.labels" . }}
*/}}
{{- define "mychart.argocd.db.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}-db
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.Version }}
app.kubernetes.io/namespace: "argocd"
{{- end }}


{{/*
Selector labels
*/}}
{{- define "parameters-argo-cd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "parameters-argo-cd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "parameters-argo-cd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "parameters-argo-cd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
