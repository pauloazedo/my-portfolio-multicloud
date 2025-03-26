# my-portfolio-oci-devops

A fully automated, production-ready infrastructure stack to host a personal technical portfolio on Oracle Cloud Infrastructure (OCI), leveraging Terraform, Ansible, Jenkins, and modern DevOps practices.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Diagram](#architecture-diagram)
3. [Technology Stack](#technology-stack)
4. [Repository Structure](#repository-structure)
5. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Environment Setup](#environment-setup)
6. [Infrastructure Provisioning (Terraform)](#infrastructure-provisioning-terraform)
   - [Secrets Management (OCI Vault)](#secrets-management-oci-vault)
   - [Environments: UAT and PROD](#environments-uat-and-prod)
   - [Cloudflare DNS Integration](#cloudflare-dns-integration)
7. [Configuration Management (Ansible)](#configuration-management-ansible)
   - [Roles Breakdown](#roles-breakdown)
   - [Fail2Ban and iptables Hardening](#fail2ban-and-iptables-hardening)
   - [NGINX + Let's Encrypt Setup](#nginx--lets-encrypt-setup)
   - [Jenkins Container Deployment](#jenkins-container-deployment)
8. [CI/CD Pipeline](#cicd-pipeline)
   - [GitHub Integration](#github-integration)
   - [Automated Builds and Deployments](#automated-builds-and-deployments)
9. [Monitoring & Logging (Planned)](#monitoring--logging-planned)
10. [Security Considerations](#security-considerations)
11. [Portfolio Website (Next.js + Tailwind)](#portfolio-website-nextjs--tailwind)
   - [Project Structure](#project-structure)
   - [Features and Pages](#features-and-pages)
   - [Deployment Strategy](#deployment-strategy)
12. [Future Improvements](#future-improvements)
13. [License](#license)

---

## Project Overview

Brief description of the project's goal — showcasing your DevOps capabilities through infrastructure-as-code, secure automation, and a professional portfolio website hosted entirely on OCI.

## Architecture Diagram

> Add a simple diagram showing:
- OCI infrastructure (VCN, Subnets, Instances)
- Jenkins CI/CD pipeline
- DNS/SSL via Cloudflare & Let's Encrypt
- Next.js frontend hosted in containers
- Separation of UAT and PROD

## Technology Stack

- **Cloud**: Oracle Cloud Infrastructure (OCI)
- **IaC**: Terraform
- **Configuration Management**: Ansible
- **CI/CD**: Jenkins
- **DNS**: Cloudflare
- **Frontend**: React + Next.js + Tailwind CSS
- **Security**: Fail2Ban, iptables, OCI Vault

## Repository Structure

<pre>

<code>
```text
.
├── terraform/
│   ├── main.tf
│   ├── uat.tf
│   ├── prod.tf
│   ├── variables.tf
├── ansible/
│   ├── site.yml
│   ├── group_vars/
│   ├── roles/
│   │   ├── hardening/
│   │   ├── nginx/
│   │   └── jenkins/
├── portfolio/         # Next.js application
│   ├── pages/
│   ├── components/
│   ├── tailwind.config.js
│   └── Jenkinsfile
```
</code>

</pre>

## Getting Started

### Prerequisites

- OCI CLI
- Terraform (>= 1.4)
- Ansible
- Git + SSH key pair
- Python 3 (for OCI SDK if needed)

### Environment Setup

1. Clone the repo
2. Configure `.env`, `terraform.tfvars`, and secrets in OCI Vault
3. Generate API keys for Terraform + Ansible automation

---

## Infrastructure Provisioning (Terraform)

### Secrets Management (OCI Vault)

- List of required secrets:
  - `jenkins_admin_user`
  - `jenkins_admin_pass`
  - `github_token`
  - `ansible_vault_pass`

### Environments: UAT and PROD

- Each with isolated subnets
- Separate compute instances
- Distinct DNS records

### Cloudflare DNS Integration

- DNS records for:
  - `uat.pauloazedo.us`
  - `prod.pauloazedo.us`
  - `jenkins.pauloazedo.us`

---

## Configuration Management (Ansible)

### Roles Breakdown

- `hardening`: Fail2Ban + iptables
- `nginx`: Reverse proxy + HTTPS + Certbot
- `jenkins`: Container setup + plugins

### Fail2Ban and iptables Hardening

- Secures SSH, HTTP, HTTPS ports
- Rules persisted via `iptables-persistent`

### NGINX + Let's Encrypt Setup

- HTTP-first deploy → HTTPS upgrade after certs issued
- Automatic renewal with Certbot

### Jenkins Container Deployment

- Non-root, secure container setup
- Accessible at `jenkins.pauloazedo.us`

---

## CI/CD Pipeline

### GitHub Integration

- Webhooks to Jenkins
- GitOps model with automated deployment

### Automated Builds and Deployments

- Build and test Next.js site
- Push Docker image to OCI Artifact Registry (future)
- Redeploy to UAT or PROD

---

## Monitoring & Logging (Planned)

> Placeholder for integrating Prometheus, Loki, or Grafana in future phases.

---

## Security Considerations

- Minimal open ports
- Hardened OS setup
- All secrets stored in OCI Vault
- No containers running as root

---

## Portfolio Website (Next.js + Tailwind)

### Project Structure

- Built with TypeScript, Tailwind CSS
- React SPA hosted in Docker container

### Features and Pages

- About Me
- Skills
- Certifications (Credly badges)
- Timeline for Education & Work
- Contact section

### Deployment Strategy

- Static build from Jenkins
- Reverse-proxied via NGINX on UAT/PROD

---

## Future Improvements

- Add CI steps for Terraform plan/apply with approvals
- Use Molecule for Ansible testing
- Add backup strategy and monitoring
- Integrate GCP or AWS alternative infrastructure

---

## License

MIT License (or choose another)