
# my-portfolio-multicloud

![Terraform](https://img.shields.io/badge/Terraform-v1.4+-623CE4?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible)
![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-D24939?logo=jenkins)
![OCI](https://img.shields.io/badge/Oracle%20Cloud-Infrastructure-F80000?logo=oracle)
![License](https://img.shields.io/badge/license-MIT-green)

A production-grade, fully automated DevOps infrastructure stack for hosting a personal technical portfolio. This project demonstrates multi-cloud provisioning, automated Docker deployments, TLS security, and CI/CD pipelines using Terraform, Ansible, and Jenkins.

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Repository Structure](#repository-structure)
5. [Features](#features)
6. [Getting Started](#getting-started)
7. [Infrastructure Provisioning](#infrastructure-provisioning)
8. [Configuration Management](#configuration-management)
9. [CI/CD Pipeline](#cicd-pipeline)
10. [TLS & Security](#tls--security)
11. [Slack Integration](#slack-integration)
12. [Live Sites](#live-sites)
13. [Future Improvements](#future-improvements)
14. [License](#license)

---

## Overview

This project showcases a modern, automated infrastructure to host a personal portfolio website. It supports UAT and PROD deployments, includes a Jenkins-based CI/CD pipeline, and adheres to security best practices.

---

## Architecture

> Architecture diagram pending. Suggested components:
> - OCI compute + block volume
> - Jenkins in Docker with Ansible automation
> - Cloudflare DNS
> - Certbot + NGINX TLS
> - UAT and PROD deployments with blue/green strategy
> - Slack certificate alerts

---

## Technology Stack

- **Cloud**: OCI (primary), with support for AWS, Azure, GCP
- **IaC**: Terraform
- **Automation**: Ansible
- **CI/CD**: Jenkins (Dockerized)
- **App Runtime**: Docker
- **Frontend**: React + Next.js + Tailwind CSS
- **DNS**: Cloudflare
- **Security**: Fail2Ban, iptables, Certbot (HTTPS)

---

## Repository Structure

```
.
├── frontend/                  # React/Next.js portfolio site
├── terraform/oci/            # OCI Terraform infrastructure
├── ansible/                  # Ansible roles (Jenkins, NGINX, etc.)
├── Jenkinsfile               # GitHub → Jenkins pipeline
├── run.sh                    # Combined Terraform + Ansible runner
└── README.md
```

---

## Features

- Multi-cloud inventory (OCI, AWS, Azure, GCP)
- Jenkins in Docker with persistent OCI Block Volume
- UAT fallback container if no image available
- PROD blue/green deployment with routing control
- Slack alerts for Certbot certificate renewals
- Automatic TLS via Let's Encrypt
- Secure by default: no root containers, hardened SSH, IP restrictions
- Secrets stored in encrypted Ansible vault (`all.secrets.yml`)

---

## Getting Started

### Requirements

- Python 3 + `oci` SDK
- OCI CLI
- Terraform (>= 1.4)
- Ansible
- SSH key pair

### Quick Start

```bash
git clone https://github.com/pauloazedo/my-portfolio-multicloud.git
cd my-portfolio-multicloud
./run.sh
```

Configure `terraform.tfvars` and `ansible/group_vars/*` files before running.

---

## Infrastructure Provisioning

- OCI compute instances for UAT and PROD
- Subnet and DNS setup per environment
- OCI Block Volume for Jenkins persistence
- Terraform separated by environment

---

## Configuration Management

- **Jenkins Role**:
  - Installs Jenkins in Docker
  - Injects admin + guest users
  - Installs plugins via `plugins.txt`
  - Mounts persistent volume

- **NGINX Role**:
  - Reverse proxy to Docker containers
  - HTTP → HTTPS redirects
  - TLS automation with Certbot

- **Fail2Ban & iptables**: part of `hardening` role

- **Site Roles** (`uat_site`, `prod_site`):
  - Pull Docker image
  - Run fallback if missing
  - PROD: Blue/green deployment with image tagging

---

## CI/CD Pipeline

- Jenkins polls GitHub
- Build triggered on commit
- `uat_site` is deployed immediately
- `prod_site` uses blue/green with manual promotion
- All deployments run via Ansible over SSH

---

## TLS & Security

- Certbot auto-issues TLS certificates for all services
- NGINX configured per domain
- Fail2Ban protects SSH/HTTP/HTTPS
- iptables default-deny policies enforced

---

## Slack Integration

- Certbot sends renewal events to Slack `#certificates`
- Slack App configured via manifest YAML

---

## Live Sites

- UAT: [https://oci.uat.pauloazedo.dev](https://oci.uat.pauloazedo.dev)
- PROD: [https://oci.prod.pauloazedo.dev](https://oci.prod.pauloazedo.dev)
- Website root: [https://www.pauloazedo.dev](https://www.pauloazedo.dev)

---

## Future Improvements

- Add Molecule testing for Ansible roles
- Add CI for Terraform plan + validate
- Multi-region support
- More advanced observability (Loki, Prometheus)

---

## License

MIT License — feel free to fork, contribute, or use it as a DevOps reference.
