# my-portfolio-oci-devops

![Terraform](https://img.shields.io/badge/Terraform-v1.4+-623CE4?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible)
![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-D24939?logo=jenkins)
![OCI](https://img.shields.io/badge/Oracle%20Cloud-Infrastructure-F80000?logo=oracle)
![License](https://img.shields.io/badge/license-MIT-green)

A fully automated, production-ready infrastructure stack to host a personal technical portfolio on Oracle Cloud Infrastructure (OCI), leveraging Terraform, Ansible, Jenkins, and modern DevOps practices.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Diagram](#architecture-diagram)
3. [Technology Stack](#technology-stack)
4. [Repository Structure](#repository-structure)
5. [Getting Started](#getting-started)
6. [Infrastructure Provisioning (Terraform)](#infrastructure-provisioning-terraform)
7. [Configuration Management (Ansible)](#configuration-management-ansible)
8. [CI/CD Pipeline](#cicd-pipeline)
9. [Monitoring & Logging (Planned)](#monitoring--logging-planned)
10. [Security Considerations](#security-considerations)
11. [Portfolio Website](#portfolio-website)
12. [Future Improvements](#future-improvements)
13. [License](#license)

---

## Project Overview

A full-stack, containerized DevOps showcase hosted on OCI, demonstrating automation, IaC, CI/CD, and security best practices for modern infrastructure projects.

---

## Architecture Diagram

> _[Insert your architecture diagram here – you can link a PNG or embed a markdown image]_  
> Suggested components:
> - OCI compute, networking, Vault
> - Terraform + Ansible flows
> - Jenkins pipeline steps
> - UAT and PROD targets
> - Certbot + NGINX SSL routing

---

## Technology Stack

- **Cloud**: Oracle Cloud Infrastructure (OCI)
- **IaC**: Terraform
- **Automation**: Ansible
- **CI/CD**: Jenkins
- **Containerization**: Docker
- **DNS**: Cloudflare
- **Security**: iptables, Fail2Ban, OCI Vault
- **Frontend**: React + Next.js + Tailwind CSS

---

## Repository Structure

```
.
├── my-portfolio/
│   └── frontend/         # [Next.js website — see full details here](my-portfolio/frontend/README.md)
├── terraform/            # OCI provisioning (VCNs, instances, DNS)
├── ansible/              # Automation roles (Jenkins, NGINX, hardening, etc.)
├── Jenkinsfile           # CI/CD orchestrator
├── run.sh                # Automation entry point
└── README.md
```

---

## Getting Started

### Prerequisites

- OCI CLI
- Terraform (>= 1.4)
- Ansible
- SSH Key Pair
- Python 3 with `oci` SDK

### Quick Start

```bash
git clone https://github.com/youruser/my-portfolio-oci-devops.git
cd my-portfolio-oci-devops
./run.sh            # runs terraform + ansible playbook
```

> Before running, configure your `terraform.tfvars` and OCI Vault secrets.

---

## Infrastructure Provisioning (Terraform)

- UAT and PROD environments defined via separate `.tf` files
- Subnets, compute, and DNS zones provisioned dynamically
- Cloudflare DNS integration for automated IP registration

---

## Configuration Management (Ansible)

- Roles for:
  - `jenkins`: Dockerized Jenkins setup with admin automation
  - `nginx`: Reverse proxy + HTTPS with Let's Encrypt
  - `hardening`: iptables + Fail2Ban security baseline
  - `uat_site` and `prod_site`: Docker deployment of frontend

---

## CI/CD Pipeline

- Jenkins pulls from GitHub on commit
- Builds Next.js site via `npm run build`
- Optionally pushes Docker images to OCI Artifact Registry
- Auto-deploys to UAT or PROD using Ansible

---

## Monitoring & Logging (Planned)

Planned additions:
- Prometheus node exporter
- NGINX and Jenkins logging
- Central log aggregation with Loki or fluentd

---

## Security Considerations

- SSH hardened
- Secrets stored in OCI Vault
- No containers run as root
- HTTPS enforced across all endpoints

---

## Portfolio Website

- Fully described in [`my-portfolio/frontend/README.md`](my-portfolio/frontend/README.md)
- Live UAT: `https://oci.uat.pauloazedo.dev`
- Live PROD: `https://oci.prod.pauloazedo.dev`

---

## Future Improvements

- Add CI steps for `terraform plan` and `terraform apply`
- Add Molecule role testing
- Integrate OCI notifications or Slack alerts
- Support for additional cloud providers (GCP, AWS)

---

## License

MIT License — fork, reuse, improve.
