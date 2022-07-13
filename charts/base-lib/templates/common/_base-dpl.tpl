{{- define "charts.base.deployment" -}}
{{- $unitName := .Release.Name -}}
{{- range $channelName, $channel := .Values.channels -}}
{{- range $serviceName, $service := $channel.services -}}
{{- if default $channel.enable true -}}
{{/*
  Deployment
*/}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}-dpl
  labels:
    app.kubernetes.io/name: {{ $unitName }}
    app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}
spec:
  replicas: {{ $service.replicas | default 1 }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ $unitName }}
      app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ $unitName }}
        app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}
    spec:
      serviceAccountName: ""
      containers:
        - name: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}
          image: {{ $service.container.repo }}:{{ $service.container.tag | default "latest" }}
          imagePullPolicy: {{ $service.container.imagePullPolicy | default "Always" }}

          {{- if kindIs "slice" $service.container.port }}
          ports:
            {{ range $port := $service.container.port }}
            - name: port-{{ $port }}
              protocol: TCP
              containerPort: {{ $port }}
            {{- end }}
          {{- else if kindIs "float64" $service.container.port }}
          ports:
            - name: port-{{ $service.container.port }}
              protocol: TCP
              containerPort: {{ $service.container.port | default 80 }}
          {{- end }}

          resources:
            {{- if $service.resources }}
              {{- toYaml $service.resources | nindent 12 }}
            {{- else }}
            limits:
              cpu: 1000m
              memory: 1024Mi
            requests:
              cpu: 50m
              memory: 512Mi
            {{- end }}

          env:
          {{- range $key, $value := $service.env }}
            - name: {{ $key }}
              value: {{ $value | quote }}
          {{- end }}

          volumeMounts:
            {{- range $service.configMaps -}}
            {{- $configMap := . }}
            - name: {{ printf "%s-%s-%s-%s-cmv" $unitName $channelName $serviceName $configMap.name }}
              subPath: {{ $configMap.subPath | default "." }}
              mountPath: {{ $configMap.mountPath }}
              readOnly: {{ $configMap.readOnly | default true }}
            {{- end }}
            {{- range $service.storages -}}
            {{- $storage := . }}
            - name: {{ $storage.name }}-volume
              subPath: {{ $storage.subPath | default "." }}
              mountPath: {{ $storage.mountPath }}
              readOnly: {{ $storage.readOnly | default true }}
            {{- end }}
      volumes:
        {{- range $service.configMaps -}}
        {{- $configMap := . }}
        - name: {{ printf "%s-%s-%s-%s-cmv" $unitName $channelName $serviceName $configMap.name }}
          configMap:
            name: {{ printf "%s-%s-%s-%s-cm" $unitName $channelName $serviceName $configMap.name }}
        {{- end }}
        {{- range $service.storages -}}
        {{- $storage := . }}
        - name: {{ $unitName }}-{{ $channelName }}-{{ $storage.name }}-pv
          persistentVolumeClaim:
            claimName: {{ $unitName }}-{{ $channelName }}-{{ $storage.name }}-pvc
        {{- end }}

      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 100
              podAffinityTerm:
                topologyKey: kubernetes.io/hostname
                labelSelector:
                  matchExpressions:
                    - key: app.kubernetes.io/name
                      operator: In
                      values:
                        - {{ $unitName }}
                    - key: app.kubernetes.io/instance
                      operator: In
                      values:
                        - {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}

---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}