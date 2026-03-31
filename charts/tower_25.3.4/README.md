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

# GCP deployment
helm upgrade --install tower25-3-4 ./charts/tower_25.3.4 -f values_tower_gcp_25_3_4.yaml -n graham
```

## GCP Gateway API: URLRewrite for /api

When moving from AWS ALB Ingress to GCP Gateway API (HTTPRoute), the `/api` route broke with 404s.

**Root cause:** The ALB Ingress and the frontend's nginx config both proxy `/api/*` requests to the backend and strip the `/api` prefix. The backend serves endpoints at the root (e.g. `/service-info`, `/health`), not under `/api/`. With Gateway API, the full path `/api/service-info` is forwarded as-is to the backend, which returns 404 because it has no `/api/*` routes.

**Fix:** Added a `URLRewrite` filter to the HTTPRoute's `/api` rule that strips the prefix before forwarding:

```yaml
filters:
  - type: URLRewrite
    urlRewrite:
      path:
        type: ReplacePrefixMatch
        replacePrefixMatch: /
```

This rewrites `/api/service-info` to `/service-info` before it reaches the backend, matching what ALB Ingress did implicitly.

**Also required for GCP:**
- `HealthCheckPolicy` targeting the backend-api Service (GCP probes `/` by default; backend only responds on `/health`)
- Backend-api Service type must be `ClusterIP` (not `NodePort` as used with ALB)

```bash
# Uninstall
helm uninstall tower25-3-4 -n graham
helm uninstall tower25-3-4 -n graham --no-hooks  # If deployment failed midway
```