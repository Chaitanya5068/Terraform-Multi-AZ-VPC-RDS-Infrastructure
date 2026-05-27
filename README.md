# 🚀 Terraform-Based Deployment of Multi-AZ VPC Infrastructure with Managed RDS and Automated AMI Management

<p align="left">
  <img src="https://img.shields.io/badge/Terraform-IaC-844FBA?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform" />
  <img src="https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS" />
  <img src="https://img.shields.io/badge/DevOps-Automation-0A66C2?style=for-the-badge&logo=azuredevops&logoColor=white" alt="DevOps" />
  <img src="https://img.shields.io/badge/Linux-Infra-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux" />
  <img src="https://img.shields.io/badge/MySQL-RDS-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
  <img src="https://img.shields.io/badge/Ubuntu-22.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu" />
</p>

**Repository:** `aws-multitier-terraform-automation`  
**Category:** AWS Infrastructure as Code (IaC) | Production-Style DevOps Project

---

## 📌 Project Overview

This project provisions a **secure, scalable, and production-oriented AWS multi-tier network and database infrastructure** using Terraform. It is designed around **Multi-AZ readiness**, **private network isolation**, and **automated AMI lifecycle selection** for reliable compute provisioning.

The stack includes a custom VPC, segmented subnet architecture, bastion-based access pattern, managed MySQL RDS deployment, and secure application-to-database connectivity controls.

---

## 🏗️ Architecture Diagram

### High-Level Infrastructure View

```text
                              ┌───────────────────────────┐
                              │         Internet          │
                              └─────────────┬─────────────┘
                                            │
                                   ┌────────▼────────┐
                                   │ Internet Gateway│
                                   └────────┬────────┘
                                            │
                      ┌─────────────────────▼─────────────────────┐
                      │         Custom VPC (10.0.0.0/16)          │
                      └─────────────────────┬─────────────────────┘
                                            │
        ┌───────────────────────────────────┼───────────────────────────────────┐
        │                                   │                                   │
┌───────▼────────┐                 ┌────────▼────────┐                 ┌────────▼────────┐
│ Public Subnet  │                 │ Private Subnet 1│                 │ Private Subnet 2│
│ (Bastion EC2)  │                 │ (App/DB Ready)  │                 │ (App/DB Ready)  │
└───────┬────────┘                 └────────┬────────┘                 └────────┬────────┘
        │                                   │                                   │
        │                          ┌────────▼────────┐                          │
        │                          │ Private Subnet 3│                          │
        │                          │   (DB Layer)    │                          │
        │                          └────────┬────────┘                          │
        │                                   │                                   │
┌───────▼────────┐                 ┌────────▼───────────────────────────────────▼───────┐
│  NAT Gateway   │                 │            RDS MySQL (Multi-AZ)                   │
│ Outbound Access│                 │      DB Subnet Group + Parameter Group            │
└────────────────┘                 └─────────────────────────────────────────────────────┘

Security Controls:
- EC2 Bastion in Public Subnet
- RDS in Private Subnets
- MySQL ingress only from EC2 Security Group
- Controlled outbound via NAT for private resources
```

### Deployment Workflow View

```text
Developer
   │
   ├── terraform init      -> Provider + module/plugin initialization
   ├── terraform validate  -> Static configuration validation
   ├── terraform plan      -> Execution plan generation
   ├── terraform apply     -> Provision AWS resources
   └── terraform destroy   -> Full stack teardown (when required)
```

---

## ✨ Features

- Multi-AZ capable Terraform-based infrastructure deployment
- Custom VPC (`10.0.0.0/16`) with public/private segmentation
- 1 public subnet + 3 private subnets for tier isolation
- Bastion-host access model for controlled administration
- Managed Amazon RDS MySQL deployment in private network
- DB subnet group and parameter group integration
- Dynamic Ubuntu 22.04 AMI selection via Terraform data source
- Least-privilege security group relationships
- NAT-based egress for private subnet workloads
- Production-style reproducible IaC workflow

---

## ☁️ AWS Services Used

| Service | Purpose |
|---|---|
| Amazon VPC | Core isolated network boundary |
| Subnets (Public/Private) | Tier-based workload segmentation |
| Internet Gateway | Public ingress/egress for public subnet |
| NAT Gateway | Outbound internet for private subnets |
| Route Tables | Deterministic traffic routing |
| Security Groups | Stateful access control |
| Amazon EC2 | Bastion host for controlled shell access |
| Amazon RDS (MySQL) | Managed relational database |
| DB Subnet Group | RDS private subnet placement |
| DB Parameter Group | Runtime engine-level database configuration |

---

## 📂 Project Structure

```text
aws-multitier-terraform-automation/
├── provider.tf            # Provider and region configuration
├── variables.tf           # Input variable definitions
├── terraform.tfvars       # Environment-specific variable values
├── create.tf              # Core networking resources (VPC, subnets, routes)
├── publicec2.tf           # Bastion EC2 instance and related resources
├── rds.tf                 # RDS, subnet group, parameter group, DB security
└── README.md              # Project documentation
```

---

## 🔁 Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

**Recommended execution policy:**
- Always review `terraform plan` output before `apply`
- Use dedicated workspaces or separate state backends per environment
- Protect production runs through CI approval gates

---

## ⚙️ Setup Instructions

### 1. Prerequisites

- Terraform >= 1.x
- AWS CLI configured with valid credentials
- IAM principal with permissions for VPC, EC2, RDS, and networking resources
- SSH key pair (`mykey` / `mykey.pub`)

### 2. Clone Repository

```bash
git clone https://github.com/<your-username>/aws-multitier-terraform-automation.git
cd aws-multitier-terraform-automation
```

### 3. Configure Variables

- Update values in `terraform.tfvars` as per environment requirements
- Keep sensitive values out of version control where possible

### 4. Initialize and Validate

```bash
terraform init
terraform validate
```

---

## 🚢 Deployment Steps

### Step-by-Step Provisioning

1. Review generated plan

```bash
terraform plan
```

2. Apply infrastructure changes

```bash
terraform apply
```

3. Confirm resource outputs in AWS Console and Terraform state

4. Destroy stack when no longer required

```bash
terraform destroy
```

---

## 🔌 EC2 & RDS Connectivity

### SSH into Bastion Host

```bash
ssh -i mykey ubuntu@<EC2-Public-IP>
```

### Connect to MySQL RDS

```bash
mysql -h <RDS-ENDPOINT> -u <username> -p
```

Connectivity model enforces that RDS access is permitted only from approved EC2 security group sources.

---

## 🔒 Security Best Practices

- Private subnet isolation for data-tier resources
- RDS endpoint not exposed publicly
- MySQL ingress restricted to EC2 security group
- Principle of least privilege in security group rules
- Controlled ingress to bastion host
- NAT-only outbound internet path for private subnets
- Sensitive inputs handled through Terraform variables and secure credential strategy

---

## 📈 Monitoring & Scalability Concepts

- CloudWatch metrics/alarms can be added for EC2 and RDS observability
- Multi-AZ topology improves resilience and failover readiness
- Private subnet layout supports horizontal app-tier expansion
- Terraform enables repeatable environment cloning (dev/stage/prod)
- RDS sizing and storage can be tuned with minimal infrastructure drift

---

## 🎯 Learning Outcomes

This project demonstrates practical competency in:

- Designing AWS network segmentation for multi-tier deployments
- Implementing secure Terraform-based infrastructure automation
- Deploying managed relational databases in private subnets
- Enforcing EC2-to-RDS controlled connectivity patterns
- Building production-style IaC workflows for repeatable operations

---

## 🛣️ Future Enhancements

- Remote state backend with S3 + DynamoDB locking
- CI/CD integration (GitHub Actions / Jenkins)
- Autoscaling group for private application tier
- Application Load Balancer integration
- Secrets Manager / SSM Parameter Store for credentials
- Centralized logging and enhanced alerting
- WAF and advanced network security controls

---

## 👨‍💻 Author

**Your Name**  
Cloud & DevOps Engineer

- GitHub: [https://github.com/your-username](https://github.com/your-username)
- LinkedIn: [https://linkedin.com/in/your-profile](https://linkedin.com/in/your-profile)

---

## 🤝 Contribution Guide

Contributions are welcome to improve quality, security, and automation maturity.

1. Fork the repository
2. Create a feature branch
3. Commit your changes with clear messages
4. Open a pull request with context and validation details

Please ensure Terraform formatting, validation, and plan checks pass before submitting changes.

---

## 📄 License

This project is licensed under the **MIT License**.  
Add a `LICENSE` file if not already present.

---

## ⭐ Portfolio Note

This repository is intentionally structured and documented to reflect **real-world DevOps delivery standards**, making it suitable for:

- Resume project showcases
- Cloud/DevOps interview discussions
- Infrastructure automation portfolio demonstrations
