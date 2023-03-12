{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.sidecar.busybox.values" -}}
image:
  registry: docker.io
  repository: busybox
  tag: latest
command:
  - "busybox"
  - "wget"
args:
  - ""
volumes:
  - emptyDir: {}
    name: /opt
{{- end -}}


{{- define "v1.workload.sidecar.busybox" -}}
{{- include "v1.workload.application.container" (include "v1.workload.sidecar.busybox.values" . | fromYaml ) }}
{{- end -}}