# Birthdays - Django App
App that accepts username and date of birth.

Shows Simple Happy Birthday Message or How many days to Birthday.

# **How to Use:**
### **1. Add User Data:**
    POST: { "username": "string", date_of_birth: "YYYY-mm-dd"}

### **2. Get All Users Data:**
    GET: /hello/

### **3. Get Message For Specific User:**
    GET: /hello/<usermane>


# **Infrastructure Overview**
![System Diagram](/images/system_diagram.png)

## Resources:

1. Git + Google Cloud Source Repository:
    - Code Collaboration and Versioning

2. GCS (Google Cloud Storage):
    - Kubernetes Yamls (deployments, services, ingress, secrets)

3. Cloud Build:
    - Build and Deploy images to GKE

4. Container Registry
    - Docker Image Repository

5. GKE (Google Kubernetes Engine):
    - Application Container Cluster

6. CloudSQL:
    - Private Network Application Database runnung Postgres

7. Ingress:
    - External Exposure, LoadBalancing and SSL Termination

8. Stackdriver:
    - Logging and future alerts

9. VPC:
    - Internal conmmunication between cluster and database

# Requirements
- Docker Runtime Environment
- Docker Compose

# Run Unit Tests
There are 9 Tests in total under `api/tests.py`
### Commamnd
    python manage.py tests

# Run App Locally
### Pre-Requisites
- Rename `.env.example` to `.env` and update with necessary database details
- Update `.env` file with correct database details

### Run Command
    docker-compose up

### Acess in Browser
- Application will be accessible on http://localhost:8000

### Shutdown Command
    docker-compose down

# Run in Production
Assumes you're using Cloud Source Respository otherwise:
-  Connect Repositoy to Cloud Source Repository https://source.cloud.google.com/repo/connect

## Flow
---
1. Merge/Push Code to master
2. Trigger Build (CloudBuild) 
3. Image stored in Container Registry
4. CloudBuild Runs migration Job. 
5. CloudBuild image to pods in kubernetes cluster

`Recommendation: Prefer Git Tags for Production instead on Branch`

## New Cluster 
---
1. Create Secrets:

        kubetcl apply -f .kubernetes/secrets.yaml

2. Create the Migration Job
        
        kubectl apply -f .kubernetes/migration-job.yaml

3. Create the  Deployment

        kubectl apply -f .kubernetes/deployment.yaml

4. Create the Service

        kubectl apply -f .kubernetes/service.yaml

4. Create the LoadBalancer

        kubectl apply -f .kubernetes/ingress.yaml

5. Point DNS to LoadBalancer IP Address.

---
# Happy Birthday? - Thank You!


Feel free to drop a feedback (kudos and critics are welcome): emmanuel.stroem@gmail.com