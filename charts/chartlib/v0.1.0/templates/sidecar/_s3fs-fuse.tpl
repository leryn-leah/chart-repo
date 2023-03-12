{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.sidecar.s3fs.values" -}}
image:
  registry: docker.io/leryn
  repository: infra/s3fs
  tag: v1.89
env:
  - name: MNT_POINT
    value: {{ .vars.mountPath }}
  - name: AWS_KEY
    value: {{ .vars.accessKey }}
  - name: AWS_SECRET_KEY
    value: {{ .vars.accessSecretKey }}
  - name: S3_ENDPOINT
    value: {{ .vars.entrypoint }}
  - name: S3_BUCKET
    value: {{ .vars.bucket }}
resources:
  limits:
    cpu: 100m
    memory: 256Mi
lifecycle:
  preStop:
    exec:
      command:
        - /bin/sh
        - -c
        - umount -f ${MNT_POINT}
{{- /*
  Linux capabilities references on
    https://man7.org/linux/man-pages/man7/capabilities.7.html
*/}}
securityContext:
  capabilities:
    add:
      - SYS_ADMIN
  privileged: true
volumes:
  - name: dev-fuse
    hostPath:
      path: /dev/fuse
{{- end -}}


{{- define "v1.workload.sidecar.s3fs" -}}
{{- include "v1.workload.application.container" (include "v1.workload.sidecar.s3fs.values" . | fromYaml ) }}
{{- end -}}
