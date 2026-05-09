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
## Application Server
- AWS EC2 Instance (Amazon Linux)
- Docker
- Docker Compose
- git
## Jenkins & Monitoring Server
- AWS EC2 Instance (Ubuntu)
- Jenkins
- Docker
- Prometheus
- Grafana
- Git
  ## Common Requirements
- GitHub Repository
- Docker Hub Account
- Security Group Configuration
## ⚙️ Setup Instructions

Clone the repository:

```bash
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

```bash
dockerhub-username/dev
```

### Production Repository (Private)

```bash
dockerhub-username/prod
```

