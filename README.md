# che-gcp-gke
This repository hosts my customized hardened GKE terraform code and is based on [Google's terraform module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/)

## Links
1. [Hardened GKE Cluster](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/examples/safer_cluster_iap_bastion)
2. [GKE Private Cluster Beta Module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-private-cluster)
3. [Project Factory](https://github.com/terraform-google-modules/terraform-google-project-factory)
4. [Networking](https://github.com/terraform-google-modules/terraform-google-network)
5. [GKE Address Management](https://cloud.google.com/architecture/gke-address-management-options)
6. [Optimizing GKE IP address allocation](https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr)
7. [IP address calculator](https://github.com/GoogleCloudPlatform/gke-ip-address-management)

## Private GKE cluster

This is a hardened private GKE cluster which is accessible through a bastion host utilizing [Identity Awareness Proxy](https://cloud.google.com/iap/) without an external ip address. Access to this cluster's control plane is restricted to the bastion host's internal IP using [authorized networks](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks#overview).

Additionally we deploy a [tinyproxy](https://tinyproxy.github.io/) daemon which allows kubectl commands to be piped through the bastion host allowing ease of development from a local machine with the security of GKE Private Clusters.

## Accessing the cluster

1. After apply is complete, generate kubeconfig for the private cluster. The command with the right parameters will displayed as the Terraform output get_credentials_command.

```
gcloud container clusters get-credentials --project $PROJECT_ID --zone $ZONE --internal-ip $CLUSTER_NAME

```

2. SSH to the Bastion Host while port forwarding to the bastion host through an IAP tunnel. The command with the right parameters will displayed by running terraform output bastion_ssh_command.

```
gcloud beta compute ssh $BASTION_VM_NAME --tunnel-through-iap --project $PROJECT_ID --zone $ZONE -- -L8888:127.0.0.1:8888

```

3. You can now run kubectl commands though the proxy. An example command will displayed as the Terraform output bastion_kubectl_command.

```
HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces

```
