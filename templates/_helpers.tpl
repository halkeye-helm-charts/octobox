{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "octobox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "octobox.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "octobox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Join With http and https
*/}}
{{- define "octobox.joinHttpHttps" -}}
{{- $lastHost := last . -}}
{{- range $idx, $host := . -}}
http://{{ $host }},https://{{ $host }}{{ if ne $host $lastHost }},{{ end }}
{{- end -}}
{{- end -}}

{{/*
All the environmental variables
*/}}
{{- define "octobox.env" -}}
- name: GITHUB_CLIENT_ID
  value: {{ .Values.octobox.github.client_id | quote }}
- name: GITHUB_CLIENT_SECRET
  value: {{ .Values.octobox.github.client_secret | quote }}
{{- if .Values.octobox.github.domain }}
- name: GITHUB_DOMAIN
  value: {{ .Values.octobox.github.domain | quote }}
{{- end }}
{{- if .Values.octobox.github.admin_ids }}
- name: ADMIN_GITHUB_IDS
  value: {{ join "," .Values.octobox.github.admin_ids | quote }}
{{- end }}
{{- if .Values.octobox.ga_analytics_id }}
- name: GA_ANALYTICS_ID
  value: {{ .Values.octobox.ga_analytics_id | quote }}
{{- end }}
- name: FETCH_SUBJECT
  value: "true"
- name: RAILS_SERVE_STATIC_FILES
  value: "true"
- name: RAILS_LOG_TO_STDOUT
  value: "true"
- name: OCTOBOX_SIDEKIQ_SCHEDULE_ENABLED
  value: "true"
- name: RAILS_ENV
  value: "production"
- name: SECRET_KEY_BASE
  value: {{ .Values.octobox.secret_key | quote }}
- name: OCTOBOX_DATABASE_USERNAME
  value: {{ .Values.octobox.database.username | quote }}
- name: OCTOBOX_DATABASE_PASSWORD
  value: {{ .Values.octobox.database.password | quote }}
- name: OCTOBOX_DATABASE_NAME
  value: {{ .Values.octobox.database.name | quote }}
- name: OCTOBOX_DATABASE_HOST
  value: {{ .Values.octobox.database.host | quote }}
- name: REDIS_URL
  value: {{ .Values.octobox.redis.url | quote }}
- name: PERSONAL_ACCESS_TOKENS_ENABLED
  value: "1"
- name: MINIMUM_REFRESH_INTERVAL
  value: "1"
{{- if .Values.ingress.enabled }}
- name: PUSH_NOTIFICATIONS
  value: "true"
- name: WEBSOCKET_ALLOWED_ORIGINS
  value: {{ include "octobox.joinHttpHttps" .Values.ingress.hosts | quote }}
{{- end }}
{{- if .Values.octobox.restricted.enabled }}
- name: RESTRICTED_ACCESS_ENABLED
  value: "true"
{{- if .Values.octobox.restricted.github_organization_id }}
- name: GITHUB_ORGANIZATION_ID
  value: {{ .Values.octobox.restricted.github_organization_id | quote }}
{{- end }}
{{- if .Values.octobox.restricted.github_team_id }}
- name: GITHUB_TEAM_ID
  value: {{ .Values.octobox.restricted.github_team_id | quote }}
{{- end }}
{{- end }}
{{- end -}}
