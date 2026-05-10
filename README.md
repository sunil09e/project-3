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
- git
- Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Give execute permission:

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

Verify installation:

```bash
docker-compose --version
```
 
**Jenkins & Monitoring Server**
  
- AWS EC2 Instance (Ubuntu)
- Jenkins
- Docker
- Prometheus
- Grafana
- Git
   
**Common Requirements**
  
- GitHub Repository
- Docker Hub Account
- Security Group Configuration
# ⚙️ Setup Instructions

Clone the repository:

git clone https://github.com/sriram-R-krishnan/devops-build.git

cd devops-build
# 🐳 Docker Setup
### Dockerfile
Defines the instructions to build the Docker image for the React application.

### docker-compose.yml
Defines and manages multi-container deployment configuration, including container image, ports, container name, and restart policies.

### build.sh
Automates the Docker image build process, including image creation and tagging for Docker Hub deployment.

### deploy.sh
Automates application deployment by pulling the latest Docker image and starting the containerized application on the server.
# 🐙 Docker Hub Repositories

Two repositories created:

### Development Repository (Public)

dockerhub-username/dev


### Production Repository (Private)


dockerhub-username/prod
# Docker Permission Configuration

Add users to Docker group to run Docker commands without sudo.

### Application Server (Amazon Linux - ec2-user)
Grant Docker permission to the application server user to deploy and manage containers without sudo.

```bash
sudo usermod -aG docker ec2-user
```

Apply changes:

```bash
newgrp docker
```
or

```bash
logout & login
```

### Jenkins Server (Ubuntu - Jenkins Service User)
Grant Docker permission to the Jenkins user so the CI/CD pipeline can build, push, and manage Docker images.

```bash
sudo usermod -aG docker jenkins
```

Restart Jenkins:

```bash
sudo systemctl restart jenkins
```

### Jenkins Server (Ubuntu - ubuntu User) [Optional]
If Docker commands are executed manually on the Jenkins server using the Ubuntu user:

```bash
sudo usermod -aG docker ubuntu
```

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

### Installed Required Plugins

We added plugins needed for DevOps pipeline:

Git plugin → to connect GitHub

Docker plugin → to build images

Pipeline plugin → to create CI/CD

SSH Agent plugin → To securely deploy the application to the remote EC2 server using SSH

### Configured Credentials

Added credentials in Jenkins:

- **GitHub Credentials** → For repository integration and branch discovery in Multibranch Pipeline
- **Docker Hub Credentials** → For authenticating and pushing Docker images
- **SSH Private Key Credentials** → For secure deployment to the application server

**Configured webhook in GitHub repo**

Connected GitHub (Webhook)

URL: http://JENKINS-IP:8080/github-webhook/

So whenever code is pushed → Jenkins triggers automatically

### Create Multibranch Pipeline Job

`Jenkins Dashboard → New Item → Multibranch Pipeline`

**Repository Source:** GitHub

**Repository URL:** https://github.com/your-username/your-repo.git

**Credentials:** Select configured GitHub credentials

**Discover Branches (All Branches)** → Automatically scans and builds all repository branches

**Property Strategy:** All branches get the same properties

**Build Configuration**

**Mode:** by Jenkinsfile

**Script Path:** Jenkinsfile


 Jenkinsfile Detection
 
Jenkins automatically detects the `Jenkinsfile` in each branch and executes the defined pipeline stages.

# Pipeline Workflow

**Dev Branch**
```bash
Code Push → Jenkins Trigger → Build Docker Image → Push to Docker Hub Dev Repo → Deploy to App Server
```

**Master Branch**
```bash
Merge to Master → Jenkins Trigger → Build Production Image → Push to Docker Hub Prod Repo → Deploy to Production Server
```
# 📊 Monitoring

Application monitoring is implemented using **Prometheus** and **Grafana** to continuously track the health and performance of the deployed application.

## Prometheus (Jenkins Server)

Create configuration file:

```bash
vi prometheus.yml
```

Run Prometheus container:

```bash
docker run -d -p 9090:9090 --name prometheus \
-v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
prom/prometheus
```

Access:
```bash
http://<jenkins-server-public-ip>:9090
```

---

## Grafana (Jenkins Server)

Run Grafana container with email alert configuration:

```bash
docker run -d -p 3000:3000 --name grafana \
-e GF_SMTP_ENABLED=true \
-e GF_SMTP_HOST=smtp.gmail.com:587 \
-e GF_SMTP_USER=your-email@gmail.com \
-e GF_SMTP_PASSWORD=your-app-password \
-e GF_SMTP_FROM_ADDRESS=your-email@gmail.com \
grafana/grafana
```

Access:
```bash
http://<jenkins-server-public-ip>:3000
```

Default login:
```bash
Username: admin
Password: admin
```

---

## Node Exporter (Application Server)

Run Node Exporter container:

```bash
docker run -d -p 9100:9100 --name node-exporter prom/node-exporter
```

Access:
```bash
http://<app-server-public-ip>:9100/metrics
```

---

## Prometheus Target Configuration

Example `prometheus.yml`:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'app-server'
    static_configs:
      - targets: ['<app-server-public-ip>:9100']
```

Restart Prometheus:

```bash
docker restart prometheus
```
### Configure Alert in Grafana UI

1. Login to Grafana
```bash
http://<jenkins-server-public-ip>:3000
```

2. Add Prometheus data source

```text
Connections → Data Sources → Add Data Source → Prometheus
```

3. Create dashboard panel

```text
Dashboards → New Dashboard → Add Visualization
```
4. Create alert rule
   
 **Alert Name**
```bash
project-3
```

**Query Configuration**
```bash
Data Source : Prometheus
Metric      : up
Condition   : WHEN QUERY IS ABOVE 1
```

**Folder & Labels**
```bash
Folder : alerts
```

**Evaluation Settings**
```bash
Evaluation Interval : 30s
Pending Period      : 30s
Keep Firing For     : 0s
```

**No Data / Error Handling**
```bash
No Data State        : Alerting
Execution Error      : Alerting
Missing Series Eval  : Default (2)
```

**Notification Configuration**
- Contact Point: Email
- Notification Method: SMTP (Gmail)
- Recipient: Configured email address

### Alert Workflow
```text
Application Server Down → Node Exporter Unreachable → Prometheus Detects Failure → Grafana Triggers Alert → Email Notification Sent
```  
# 🌐 Access Application

## Application URL
Access the deployed React application using:

```bash
http://<application-server-public-ip>
```

Example:
```bash
http://3.110.xxx.xxx
```

The application is exposed on **HTTP Port 80** and is publicly accessible through the configured AWS Security Group.
# ✅ Conclusion

This project successfully implements an end-to-end DevOps CI/CD pipeline with automated build, deployment, monitoring, and alerting for a production-ready React application.
