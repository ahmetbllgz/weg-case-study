# Wingie Group Enuygun Kubernetes Case Study

This repository contains a case study demonstrating Kubernetes cluster deployment and configuration on Google Kubernetes Engine (GKE) for Wingie Group Enuygun. The project showcases Infrastructure as Code (IaC) principles, utilizing YAML manifests for Kubernetes application deployment, cluster scaling, and monitoring setup.

---

## Requirements: Setting up the System

To ensure successful execution of this project, the following software/tools must be installed on your system:

1. **Google Cloud SDK (gcloud)**  
   Download and install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) to interact with GCP services.
   
2. **kubectl**  
   Kubernetes command-line tool for deployment and management. Install it by following [kubectl installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
   
3. **Helm**  
   Helm simplifies Prometheus/Grafana installation. Install it by following [Helm documentation](https://helm.sh/docs/intro/install/).

4. **Terraform**  
   Project is using Terraform for IaC, install [Terraform](https://developer.hashicorp.com/terraform/downloads).

---

### a. Authenticate Google Cloud Account  
Before provisioning resources on GCP, authenticate your account:  
```bash
gcloud auth application-default login
```  

### b. Set the Project  
Configure Google Cloud to use the desired project:  
```bash
gcloud config set project weg-case-study
```

---
**Important:**  
Before starting the Terraform deployment, you may want to edit `variables.tf` file with your required variable changes. Espescially in grafana password and credential file location.


## Terraform Lifecycle Commands  

Follow these steps for Terraform provisioning:

### a. Initialize the Terraform Directory  
Run `terraform init` to download required plugins and initialize the directory:  
```bash
terraform init
```

### b. Preview the Plan  
Inspect the changes Terraform intends to make with `terraform plan`:  
```bash
terraform plan
```

### c. Apply the Terraform Configurations  
Use `terraform apply` to provision resources. Note that if the command errors due to cluster resource dependencies, additional intervention is required.  
```bash
terraform apply
```

**Important:**  
During `terraform apply`, Terraform tries to:
1. Provision infrastructure (Kubernetes cluster and node pools).
2. Deploy applications and services to the cluster.

Since some applications (e.g., Kubernetes deployments, Prometheus/Grafana) rely on the cluster being ready first, an error will likely occur during the first `terraform apply` execution.

---

## Resolving Terraform Apply Errors  

### a. Authenticate Kubernetes (`kubectl`) Context  
After the initial `terraform apply`, ensure the Kubernetes cluster has credentials:  
```bash
gcloud container clusters get-credentials gke-cluster --region europe-west1 --project weg-case-study
```

### b. Re-run Terraform Apply  
Once the cluster credentials are set up, re-run the `terraform apply` command to complete the application and service deployment:  
```bash
terraform apply
```

## Access Grafana  

Once Prometheus and Grafana are deployed, access the Grafana dashboard:  

### a. Port Forward Grafana Service  
Forward the Grafana service port:  
```bash
kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 6363:80
```

### b. Access Grafana Dashboard  
Visit [http://localhost:6363](http://localhost:6363) in your browser to access the dashboard.

---

## Managing Kubernetes Resources  

### a. Switch `kubectl` Context to GKE Cluster  
Ensure you’re managing resources within the intended cluster:  
```bash
gcloud container clusters get-credentials gke-cluster --region europe-west1 --project weg-case-study
```

### b. View the Status of Kubernetes Pods  
Monitor running pods in the cluster:  
```bash
kubectl get pods
```

### c. Simulate a Pod Crash Restart  
To test behaviors like pod auto-scaling or log monitoring, simulate a pod crash:  
```bash
kubectl exec -it <pod-name> -- /bin/sh
kill 1
```