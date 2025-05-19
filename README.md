# DevOps Pipeline with GitHub Actions, GKE & GitOps

This project implements a complete **GitOps CI/CD workflow** for deploying a containerized application to **Google Kubernetes Engine (GKE)** using **GitHub Actions**, **Artifact Registry**, and plain Kubernetes YAML manifests.

---

##  What’s Included

- GitHub Actions for CI/CD automation  
- Dockerized application  
- Push to **Artifact Registry** with Git tags and commit hashes  
- Deployment to GKE using **kubectl**  
- Horizontal Pod Autoscaling  
- Resource constraints for reliability  
- Public exposure via **LoadBalancer**

---

## CI/CD Workflow

| Event in GitHub         | Action                                                                 |
|-------------------------|------------------------------------------------------------------------|
| Commit to `main`        | Build Docker image, tag with **commit hash**, and **push** to registry |
| Pull Request to `main`  | Build Docker image (**do not push**) – for validation only             |
| Git Tag (e.g. `v1.0.0`) | Build image, tag with **git tag**, and **push** to registry            |

Workflows are managed using GitHub Actions in `.github/workflows/`.

---

## Kubernetes on Google Cloud (GKE)

- **Cluster type:** Zonal  
- **Machine type:** `n1-standard-1`  
- **Node type:** Preemptible (for low cost)  
- **Initial size:** 1 node  
- **Autoscaling:** Enabled (2–3 replicas via HPA)

---

## Autoscaling & Resource Limits

Defined in `deployments/app-deployment.yaml`:
- **CPU/Memory Requests and Limits**
- **Horizontal Pod Autoscaler** scales pods between 2 and 3 replicas based on CPU utilization.

---

## Public Access

The application is exposed via a `Service` of type `LoadBalancer`, which automatically provisions a public external IP.

---

## Docker & Artifact Registry

Docker images are:
- **Built** in GitHub Actions  
- **Tagged** with either:  
  - Git commit SHA (for `main` commits)  
  - Git tag (for releases)  
- **Pushed** to Google **Artifact Registry**

---

## Secrets and Authentication

GitHub Secrets store credentials securely:
- `GCP_SA_KEY`: Base64-encoded GCP Service Account JSON  
- `GCP_PROJECT`: Your GCP project ID  
- `GCP_REGION`: e.g. `us-central1`  
- `GCP_CLUSTER`: Name of your GKE cluster  
- `GCP_ZONE`: e.g. `us-central1-a`

These secrets are used in GitHub Actions to authenticate with GCP and Artifact Registry.

---

## 🚀 How to Deploy This Project Yourself

### 1. Clone the Repository

``bash
git clone https://github.com/[USERNAME]/[YOUR_REPO].git
cd [YOUR_REPO]

### 2. Enable GCP Services

gcloud services enable containerregistry.googleapis.com \
    container.googleapis.com \
    artifactregistry.googleapis.com

### 3. Create a GKE Cluster

gcloud container clusters create [CLUSTER_NAME] \
    --zone [ZONE] \

### 4. Create an Artifact Registry Repository

gcloud artifacts repositories create [REPO_NAME] \
    --repository-format=docker \
    --location=[ZONE] \
    --description="[DESCRIPTION]"

### 5. Configure GitHub Secrets


In your GitHub repo, go to **Settings > Secrets and variables > Actions**, and add:

| Secret Name     | Description                                 |
|------------------|---------------------------------------------|
| `GCP_SA_KEY`     | Base64 of GCP Service Account JSON          |
| `GCP_PROJECT`    | Your Google Cloud Project ID                |
| `GCP_REGION`     | GCP region (e.g. `us-central1`)             |
| `GCP_CLUSTER`    | Your GKE cluster name                       |
| `GCP_ZONE`       | GCP compute zone (e.g. `us-central1-a`)     |

### 6. Push Code and Let CI/CD Run

Once everything is in place:

- Push to main to trigger build + deploy.

- Open a PR to test image build.

- Push a Git tag to release and deploy a specific version.



