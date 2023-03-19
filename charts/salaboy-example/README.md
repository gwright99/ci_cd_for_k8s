# Simple Helm Chart Example

This chart uses the following docker image to start a simple monolith application: [salaboy/fmtok8s-monolith:v0.1.0](https://hub.docker.com/r/salaboy/fmtok8s-monolith)

# Pre requisites

- Have a Kubernetes Cluster, you can use KinD or K3s or a real Kubernetes Cluster in a Cloud Provider. 
- Install [Helm](https://helm.sh/docs/intro/install/)
- Clone this repo with: `git clone https://github.com/salaboy/helm-chart-example.git`


# Working with Helm

Common Helm Operations that you might want to run for your charts (from inside the chart directory): 

This will apply the `values.yaml` file values into the tempaltes and render the output without deploying to Kubernetes.
```
helm template .
```

This will create a new Helm Release with the name specified in `RELEASE NAME`, applying the `values.yaml` file values into the templates and finally deploying to Kubernetes. 
```
helm install <RELEASE NAME> .
```

You can list all Releases in the current namespace with: 

```
helm list
```

Package your chart to distribute, this will generate a `tgz` (compressed) file with the name of the chart in the same directory. 
```
helm package . 
```

# Dependencies

Helm allows you to define Chart dependencies using the `dependencies` section inside the `Charts.yaml` file. You can see that this section is [commented in this example chart](https://github.com/salaboy/helm-chart-example/blob/main/Chart.yaml#L19). You can uncomment this section to install PostgreSQL along side your application. 
If you want to use dependencies with your charts, you need to make sure to run the following command before running `helm package .`

```
helm dependency build
```

This command will fetch all the dependencies to be packaged with your chart in a single and standalone package.

# References

- [Inspecting Helm Releases that are stored in secrets](https://dbafromthecold.com/2020/08/10/decoding-helm-secrets/)


For more information visit: [From Monolith To K8s](http://github.com/salaboy/from-monolith-to-k8s)