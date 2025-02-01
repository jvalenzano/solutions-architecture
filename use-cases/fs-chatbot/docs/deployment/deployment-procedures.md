# Deployment Procedures

## 1. Deployment Prerequisites

### Environment Setup
```bash
# Required environment variables
export PROJECT_ID="fs-chatbot-prod"
export REGION="us-central1"
export ENV="production"
```

### Access Requirements
- GCP Project Owner/Editor
- DialogFlow Admin
- Cloud Build Service Account
- Deployment Manager access

## 2. Infrastructure Deployment

### VPC Setup
```terraform
resource "google_compute_network" "vpc" {
  name                    = "vpc-fs-chatbot"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-fs-chatbot"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc.id
  region        = var.region
}
```

### Cloud Run Configuration
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: chatbot-service
spec:
  template:
    spec:
      containers:
      - image: gcr.io/${PROJECT_ID}/chatbot:${VERSION}
        resources:
          limits:
            memory: "256Mi"
            cpu: "1"
```

## 3. Application Deployment

### DialogFlow CX Deployment
```bash
# Export agent from staging
gcloud dialogflow cx agents export \
  --location=us-central1 \
  --agent=staging-agent \
  --output-file=agent.blob

# Import to production
gcloud dialogflow cx agents restore \
  --location=us-central1 \
  --agent=prod-agent \
  --agent-content-file=agent.blob
```

### Cloud Functions Deployment
```yaml
steps:
- name: 'gcr.io/cloud-builders/gcloud'
  args:
  - functions
  - deploy
  - ${FUNCTION_NAME}
  - --runtime=python39
  - --trigger-http
  - --region=${REGION}
  - --service-account=${SERVICE_ACCOUNT}
```

## 4. Deployment Stages

### 1. Development Deployment
- Feature testing
- Integration testing
- Performance testing

### 2. Staging Deployment
- UAT testing
- Load testing
- Security testing

### 3. Production Deployment
- Blue/Green deployment
- Traffic migration
- Monitoring verification

## 5. Rollback Procedures

### Quick Rollback
```bash
# Revert to previous version
gcloud run services update-traffic chatbot-service \
  --to-revisions=PREVIOUS_REVISION=100
```

### Full Rollback
1. Stop traffic to new version
2. Restore previous configuration
3. Verify system health
4. Update DNS/routing

## 6. Post-Deployment Verification

### Health Checks
```bash
# Check service health
curl -X GET https://${SERVICE_URL}/health

# Verify metrics
gcloud monitoring metrics list \
  --filter="metric.type=custom.googleapis.com/chatbot"
```

### Monitoring Setup
```yaml
monitoring:
  metrics:
    - response_time
    - error_rate
    - request_count
  alerts:
    - type: error_rate
      threshold: 1%
      duration: 5m
```

## 7. Maintenance Procedures

### Regular Updates
- Security patches
- Dependency updates
- Configuration updates
- Performance optimization

### Emergency Procedures
1. Incident response
2. Communication plan
3. Recovery steps
4. Post-mortem analysis

## 8. Documentation Requirements

### Deployment Documentation
- Configuration changes
- Version information
- Dependencies updated
- Known issues

### Operational Documentation
- Monitoring dashboards
- Alert configurations
- Backup schedules
- Contact information

## Version Control

### Release Tags
```bash
# Tag release
git tag -a v1.0.0 -m "Production release 1.0.0"
git push origin v1.0.0
```

### Change Management
- Change request process
- Approval workflow
- Implementation plan
- Validation steps