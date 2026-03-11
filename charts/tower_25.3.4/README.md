# README

## Setting up MYSQL DB
See [private notes](../README.md) for commands on how to deploy and verify.

## Values
See [private values](../../values_tower_25_3_4.yaml) for configuration.

# Installation commands
```bash
cd ~/Project/ci_cd_for_k8s

# Dry run
helm template tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham

# Real deployment
helm install tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham --create-namespace
helm upgrade --install tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham

# Uninstall
helm uninstall tower25-3-4 -n graham
helm uninstall tower25-3-4 -n graham --no-hooks  # If deployment failed midway
```