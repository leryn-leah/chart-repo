{{- define "charts.base.persistentVolume" -}}
{{- $unitName := .Release.Name -}}
{{- range $channelName, $channel := .Values.channels -}}
{{- range $storageName, $storage := $channel.storages -}}
{{- if default $channel.enable true -}}
{{/*
  PersistentVolume
*/}}
apiVersion: v1
kind: PersistentVolume
metadata:
  name: {{ $unitName }}-{{ $channelName }}-{{ $storageName }}-pv
  labels:
    app.kubernetes.io/name: {{ $unitName }}
    app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $storageName }}
spec:
  accessModes:
  {{- if default $storage.readOnly true }}
  - ReadOnlyMany
  {{- else }}
  - ReadWriteMany
  {{- end }}

  capacity:
    storage: {{ $storage.capacity }}
  {{- if eq (default $storage.provisioner "nfs") "nfs" }}
  nfs:
    path: {{ $storage.nfs.path }}
  {{- end }}
  mountOptions:
    {{- toYaml $storage.mountOptions | nindent 4 }}

  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  volumeMode: Filesystem

---
{{/*
  PersistentVolumeClaim
*/}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ $channelName }}-{{ $storageName }}-pvc
  labels:
    app.kubernetes.io/name: {{ $channelName }}-{{ $storageName }}
    app.kubernetes.io/instance: {{ $channelName }}-{{ $storageName }}
spec:
  accessModes:
    {{- if $storage.readOnly}}
    - ReadOnlyMany
    {{- else }}
    - ReadWriteMany
    {{- end }}
  resources:
    requests:
      storage: {{ $storage.capacity }}
  storageClassName: {{ default $storage.class "" }}
  volumeMode: Filesystem
  volumeName: {{ $channelName }}-{{ $storageName }}-pvc

---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}