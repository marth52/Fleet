{{/* Expand the name of the chart. */}}
{{- define "demoapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Create a default fully qualified app name. */}}
{{- define "demoapp.fullname" -}}
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

{{/* Create chart name and version as used by the chart label. */}}
{{- define "demoapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels. */}}
{{- define "demoapp.labels" -}}
helm.sh/chart: {{ include "demoapp.chart" . }}
{{ include "demoapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels. */}}
{{- define "demoapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "demoapp.name" . }}
{{- end }}

{{/* Create the name of the service account to use. */}}
{{- define "demoapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "demoapp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Whether the LoadBalancer service variant is selected. */}}
{{- define "demoapp.service.isLoadBalancer" -}}
{{- eq (.Values.service.type | default "ClusterIP") "LoadBalancer" -}}
{{- end }}

{{/* Exposed service port for the active variant. */}}
{{- define "demoapp.service.port" -}}
{{- if eq (include "demoapp.service.isLoadBalancer" .) "true" -}}
{{- .Values.service.loadBalancer.port | default 443 -}}
{{- else -}}
{{- .Values.service.clusterIP.port | default 80 -}}
{{- end -}}
{{- end }}

{{/* Container target port for the active variant. */}}
{{- define "demoapp.service.targetPort" -}}
{{- if eq (include "demoapp.service.isLoadBalancer" .) "true" -}}
{{- .Values.service.loadBalancer.targetPort | default 8443 -}}
{{- else -}}
{{- .Values.service.clusterIP.targetPort | default 8080 -}}
{{- end -}}
{{- end }}