{{/*
  PersistentVolume
==============================
Rendored when persistence is enabled.
*/}}
{{- define "api.storage.persistence.volume" -}}
{{- if .Values.persistence.enabled -}}
{{- range $persistenceName, $persistence := .Values.persistence.persistentVolumeClaim }}
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ $persistenceName }}-pv
spec:
  accessModes:
  {{- toYaml $persistence.accessModes | nindent 2 }}
  capacity:
    storage: {{ $persistence.capacity | default "1Gi" }}
  {{- if $persistence.mountOptions }}
  mountOptions:
    {{- toYaml $persistence.mountOptions | nindent 4 }}
  {{- end }}
  persistentVolumeReclaimPolicy: Retain
  storageClassName: {{ $persistence.storageClass | default "" | quote }}
  volumeMode: Filesystem
  {{- if eq "nfs" ($persistence.provisioner | default "x") }}
    nfs:
    path: {{ $persistence.nfs.path }}
  {{- end }}
  {{- if eq "host" ($persistence.provisioner | default "x") }}
  local:
    path: {{ $persistence.local.path }}
  {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}

---

{{/*
  PersistentVolumeClaim
==============================
*/}}
{{- define "api.storage.persistence.claim" -}}
{{- if .Values.persistence.enabled -}}
{{- range $persistenceName, $persistence := .Values.persistence.persistentVolumeClaim }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ $persistenceName }}-pvc
  namespace: {{ include "api.namespace.name" $ }}
spec:
  accessModes:
  {{- toYaml $persistence.accessModes | nindent 2 }}
  resources:
    requests:
      storage: {{ $persistence.capacity }}
  storageClassName: {{ $persistence.storageClass | default "" | quote }}
  volumeMode: Filesystem
  volumeName: {{ $persistenceName }}-pv
---
{{- end -}}
{{- end -}}
{{- end -}}