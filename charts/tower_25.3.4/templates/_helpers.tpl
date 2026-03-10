((/* NOTE: 
While I could remove whole blocks of configuration from the 
resutling manifests, I find this makes it harder to keep track
of what I'm changing. 
I feel like it's better to repeat myself a bit more in 
return for much easier and clearer manifest reading.
*/))

{{/* Populate Image Secret */}}
{{- define "ktower.imagepullsecret" }}
{{- if .Values.image.pullSecret }}
imagePullSecrets: 
  - name: "{{ .Values.image.pullSecret }}"
{{- else }}
imagePullSecrets:
  - name: "cr.seqera.io"
{{- end }}
{{- end }}

{{/* Define Volume from CM with TOWER_* settings */}}
{{- define "ktower.definetowercmvolume" }}
volumes:
  - name: "config-volume"
    configMap:
      name: tower-yml
{{- end }}

{{/* Mount  CM with TOWER_* settings */}}
{{- define "ktower.mounttowerconfig" }}
{{- end }}
