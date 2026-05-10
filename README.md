# 🚀 Application Deployment using CI/CD (Jenkins + Docker + AWS + Monitoring)

# 📌 Project Overview


This project demonstrates an end-to-end DevOps pipeline to deploy a React application into a production-ready environment using:

- Jenkins (CI/CD Automation)
- Docker (Containerization)
- Docker Compose (Container Management)
- AWS EC2 (Cloud Deployment)
- Docker Hub (Image Repository)
- Prometheus & Grafana (Monitoring)
 
# 🏗️ Architecture
  GitHub → Jenkins → Docker Build → Docker Hub → AWS EC2 Deployment → Monitoring
  
# ⚙️ Prerequisites

Make sure you have:

**Application Server**

- AWS EC2 Instance (Amazon Linux)
- Docker
- Docker Compose
- git
 
**Jenkins & Monitoring Server**
  
- AWS EC2 Instance (Ubuntu)
- Jenkins
- Docker
- Prometheus
- Grafana
- Git
- 
**Common Requirements**
  
- GitHub Repository
- Docker Hub Account
- Security Group Configuration
## ⚙️ Setup Instructions

Clone the repository:

git clone https://github.com/sriram-R-krishnan/devops-build.git
cd devops-build
# 🐳 Docker Setup
## Dockerfile
Defines the instructions to build the Docker image for the React application.

## docker-compose.yml
Defines and manages multi-container deployment configuration, including container image, ports, container name, and restart policies.

## build.sh
Automates the Docker image build process, including image creation and tagging for Docker Hub deployment.

## deploy.sh
Automates application deployment by pulling the latest Docker image and starting the containerized application on the server.
# 🐙 Docker Hub Repositories

Two repositories created:

### Development Repository (Public)

dockerhub-username/dev


### Production Repository (Private)

```bash
dockerhub-username/prod

# 🤖 Jenkins CI/CD Pipeline

## Jenkins Workflow

### Dev Branch Pipeline

When code is pushed to `dev` branch:

✅ Jenkins pulls source code  
✅ Builds Docker image  
✅ Pushes image to Docker Hub dev repository  
✅ Deploys application to AWS server

### Master Branch Pipeline

When `dev` is merged to `master`:

✅ Jenkins triggers production build  
✅ Creates production Docker image  
✅ Pushes image to Docker Hub prod repository  
✅ Deploys production application

# 🌐 Access Jenkins 
Get EC2 public IP (from AWS console)

Open in browser

http://EC2-PUBLIC-IP:8080

🔑 Get Initial Admin Password

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Installed Required Plugins

We added plugins needed for DevOps pipeline:

Git plugin → to connect GitHub

Docker plugin → to build images

Pipeline plugin → to create CI/CD

SSH Agent plugin → To securely deploy the application to the remote EC2 server using SSH

Configured Credentials

Added credentials in Jenkins:

- **GitHub Credentials** → For repository integration and branch discovery in Multibranch Pipeline
- **Docker Hub Credentials** → For authenticating and pushing Docker images
- **SSH Private Key Credentials** → For secure deployment to the application server
Connected GitHub (Webhook)

Configured webhook in GitHub repo

URL: http://JENKINS-IP:8080/github-webhook/

So whenever code is pushed → Jenkins triggers automatically

Create Multibranch Pipeline Job
`Jenkins Dashboard → New Item → Multibranch Pipeline`
```bash
Repository Source: GitHub
Repository URL: https://github.com/your-username/your-repo.git
Credentials: Select configured GitHub credentials
```
- **Discover Branches (All Branches)** → Automatically scans and builds all repository branches
- Property Strategy: All branches get the same properties
**Build Configuration**
- Mode: by Jenkinsfile
- Script Path: Jenkinsfile
 Jenkinsfile Detection**
Jenkins automatically detects the `Jenkinsfile` in each branch and executes the defined pipeline stages.

### Pipeline Workflow

**Dev Branch**
```bash
Code Push → Jenkins Trigger → Build Docker Image → Push to Docker Hub Dev Repo → Deploy to App Server
```

**Master Branch**
```bash
Merge to Master → Jenkins Trigger → Build Production Image → Push to Docker Hub Prod Repo → Deploy to Production Server
```

