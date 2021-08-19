{{- define "commonLabels" }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end }}

{{- define "imageFullName" -}}
{{ .image.registry }}/{{ .image.repository }}
{{- end -}}

