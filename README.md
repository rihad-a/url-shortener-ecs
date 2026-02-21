# Project Blue-Green 

Automated deployment of a **URL Shortener Application** using **AWS ECS Fargate**, **CodeDeploy Blue-Green Deployments**, **Terraform**, **Docker**, and **CI/CD pipelines**. Provides zero-downtime deployments with automatic health checks, traffic switching, and rollback capabilities.

The application is a containerised Python FastAPI service with DynamoDB persistence. CodeDeploy Blue-Green strategy ensures seamless updates, while GitHub Actions CI/CD pipelines handle Docker builds, security scanning, and automated deployment.

<br>

## Architecture Diagram

![AD](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/architecture-diagram.png)

<br>

## Key Components

- **Application**: Python FastAPI service that creates and resolves shortened URLs
- **Containerisation**: Multi-stage Docker build for optimised production images
- **Infrastructure as Code**: Terraform for provisioning VPC, ALB, ECS, DynamoDB, Route 53, CodeDeploy, and WAF
- **Zero-Downtime Deployments**: CodeDeploy blue-green deployments with automatic rollback
- **Security**: Trivy vulnerability scanning and AWS WAF protection
- **State Management**: Remote state backend with S3

<br>

## Directory Structure

```
./
├── app/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── src/
│   └── tests/
├── terraform/
│   ├── backend/
│   └── infra/
│       └── modules/
│           ├── vpc/
│           ├── alb/
│           ├── ecs/
│           ├── dynamodb/
│           ├── route53/
│           ├── codedeploy/
│           └── waf/
└── .github/workflows/
```

<br>

## API Endpoints

- **`POST /shorten`**: Creates a shortened URL
  - Body: `{"url": "https://example.com/path"}`
  - Response: `{"short": "abc12345", "url": "https://example.com/path"}`

- **`GET /{short_id}`**: Redirects to original URL (HTTP 302)
- **`GET /healthz`**: Health check - `{"status": "ok", "ts": <unix_timestamp>}`

<br>

## Prerequisites

- **AWS Account** with appropriate IAM permissions
- **AWS CLI** 2.13+ installed and configured
- **Docker** 24.0+ installed locally
- **Terraform** 1.14.3 installed
- **Python** 3.13+ (for local development)
- **Cloudflare** account with registered domain
- **Cloudflare API Token** and Zone ID
- **GitHub OIDC** configured with IAM role for automated deployments

**Required Terraform Providers:**
- AWS Provider: 6.27.0
- Cloudflare Provider: 5.15.0+

<br>

## Terraform Configuration

**Backend Phase** (`terraform/backend/`): Creates Route 53 hosted zone, S3 state bucket, artifact bucket, ECR repository, and Cloudflare DNS records linking Route 53 nameservers.

Before deploying, export your Cloudflare credentials as environment variables:
```bash
export CLOUDFLARE_API_TOKEN="your-api-token"
export CLOUDFLARE_ZONE_ID="your-zone-id"
```

Update the domain name in `main.tf` before running `terraform apply`.

**Infrastructure Phase** (`terraform/infra/`): Provisions application resources via modules. Configure variables in `terraform.tfvars` with your domain name, VPC CIDR, ECS task allocation, and application port.

Update `provider.tf` backend configuration with the S3 bucket name and DynamoDB table created by backend phase.

<br>

## Deployment Workflow

### Step 1: Backend Infrastructure

```bash
cd terraform/backend
terraform init
terraform apply
```

**Note outputs:**
- S3 bucket name (for infra backend config)
- ECR repository URL (for GitHub Secrets)

### Step 2: GitHub Actions Secrets

Add to **Settings → Secrets and variables → Actions**:
- `GitHubActionsRole`: GitHub OIDC IAM role ARN
- `ECR_REPOSITORY`: ECR registry URL from Step 1
- `GIT_TOKEN`: GitHub personal access token

### Step 3: Build & Push Docker Image

1. Update `terraform/infra/provider.tf` backend with S3 bucket from Step 1
2. Make changes to the `app/` directory and push to `main` branch
3. GitHub Actions automatically builds, scans with Trivy, and pushes to ECR

### Step 4: Deploy Infrastructure

1. Update `terraform/infra/terraform.tfvars` with your domain and settings
2. Navigate to **GitHub Actions** → **Running a Terraform Plan**
3. Click **Run workflow** to preview changes
4. Verify plan, then run **Terraform Apply** workflow to deploy

### Step 5: Create AppSpec in AWS

The `appspec.yaml` file must be created manually in your AWS CodeDeploy console as a deployment specification. It defines the ECS task definition, container name, and port for blue-green deployments. Reference the template in `terraform/infra/modules/codedeploy/appspec.yaml` and update the task definition ARN before deploying.

<br>

## CodeDeploy Blue-Green Strategy

- **Blue**: Current production task set receiving traffic
- **Green**: New task set with updated Docker image
- **Process**: Health checks → Traffic switch → 5-min rollback window → Cleanup
- **Rollback**: Automatic on deployment or health check failure

<br>

## Access the Application

Once deployed:
- **Health Check**: `curl https://your-domain.com/healthz`
- **Shorten URL**:
```bash
curl -X POST "https://your-domain.com/shorten" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```
- **Resolve**: 
```bash
curl -Ls -o /dev/null -w "%{url_effective}\n" https://your-domain.com/<short_id>
```

<br>

|Here are pictures of the operating app:|
|-------|
| ![URL Shortener Health Check](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/health-check.png) |
| ![URL Shortener Shorten](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/shorten.png) |
| ![URL Shortener Get](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/get.png) |

|VPC Endpoints:|
|-------|
| ![VPC Endpoints](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/vpc-endpoints.png) |

|CodeDeploy Deployment:|
|-------|
| ![CodeDeploy Deployment1](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/codedeploy-deployment.png) |
| ![CodeDeploy Deployment2](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/codedeploy-deployment2.png) |


|Docker Image Pipeline:|
|-------|
| ![Docker Image Pipeline](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/docker-image-pipeline.png) |

|Terraform Plan Pipeline:|
|-------|
| ![Terraform Plan Pipeline](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/terraform-plan-pipeline.png) |

|Terraform Apply Pipeline:|
|-------|
| ![Terraform Apply Pipeline](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/terraform-apply-pipeline.png) |

|Terraform Destroy Pipeline:|
|-------|
| ![Terraform Destroy Pipeline](https://raw.githubusercontent.com/Rihad-A/url-shortener-ecs/main/images/terraform-destroy-pipeline.png) |



