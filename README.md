<!-- Source: https://helm.sh/docs/howto/chart_releaser_action/ -->
## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add <alias> https://gwright99.github.io/charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
<alias>` to see the charts.

To install the <chart-name> chart:

    helm search repo gwright99
    helm install my-<chart-name> <alias>/<chart-name>

To uninstall the chart:

    helm delete my-<chart-name>

## Installing MySQL As Pod
```bash
# In this folder
k apply -f mysql-standalone.yaml

# Verify access -- login
k exec -it mysql8-0 -- /bin/bash
mysql -u root -proot
mysql -u tower -ptower tower
mysql> SELECT CURRENT_USER();

# Confirm tower user is empowered
mysql> SHOW GRANTS FOR 'tower'@'%';
+--------------------------------------------------+
| Grants for tower@%                               |
+--------------------------------------------------+
| GRANT USAGE ON *.* TO `tower`@`%`                |
| GRANT ALL PRIVILEGES ON `tower`.* TO `tower`@`%` |
+--------------------------------------------------+ 
```

NOTE (Mar 9/26): Adding text to fix a branch problem I didnt notice (made changes in gwright99/oracle instead of branching from main. oops)


# Installation commands
```bash
cd ~/Project/ci_cd_for_k8s

# Dry run
# =====================================================
helm template tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham

# Real deployment
# =====================================================
helm install tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham --create-namespace

helm upgrade --install tower25-3-4 ./charts/tower_25.3.4 -f values_tower_25_3_4.yaml -n graham

helm upgrade --install wave ./charts/wave_1_32_7/ -f values_wave_1_32_7.yaml


# Uninstall
# =====================================================
helm uninstall tower25-3-4 -n graham
helm uninstall tower25-3-4 -n graham --no-hooks  # If deployment failed midway

helm uninstall wave -n graham --no-hooks

# List
helm list -A
helm list -n <namespace>

# Templated Output
# =====================================================
helm template ./charts/wave_1_32_7/ -f my_values.yaml > manifests_rendered.yaml
```