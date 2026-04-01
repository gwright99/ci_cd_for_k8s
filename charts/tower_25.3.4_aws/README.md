# README

## Installation commands
```bash
cd ~/Project/ci_cd_for_k8s

# Dry run
# ====================
helm template tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham


# Real deployment
# ====================
# NOTE: Currently secrets live on local instance (not checked into source control). Plan is to
# eventually change this command to pull secrets from a cloud-based Secret object (via subshell).
helm upgrade --install tower25-3-4 ./charts/tower_25.3.4_aws -f values_tower_aws_25_3_4.yaml -f secrets_tower_aws_25_3_4.yaml -n graham --create-namespace 


# Uninstall
# ====================
helm uninstall tower25-3-4 -n graham
helm uninstall tower25-3-4 -n graham --no-hooks  # If deployment failed midway
```

## TODO
- [] Add values file.
- [] Add template for secrets file.
- [] Align `connect-*` naming convention.
- [] Align `redis` pod naming convention
- [] Figure out if privileged pod is still supported
- [] Add Seqera Platform TF provider assets to populate deployed instance.
- [] Figure out how to backup container DB state.