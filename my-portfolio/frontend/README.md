# Portfolio Frontend – Next.js + Tailwind

![Next.js](https://img.shields.io/badge/Next.js-14-black?logo=next.js)
![Tailwind](https://img.shields.io/badge/TailwindCSS-4.0-blue?logo=tailwindcss)
![TypeScript](https://img.shields.io/badge/TypeScript-4.x-3178C6?logo=typescript)
![Deployed](https://img.shields.io/website?down_color=red&down_message=offline&up_color=green&up_message=online&url=https://oci.prod.pauloazedo.dev)

> ✨ This is the React frontend for `my-portfolio`, built as a dynamic, dark-themed, responsive single-page application (SPA) deployed to OCI using DevOps best practices.

---

## Demo

🔗 [Live Site (PROD @ OCI)](https://oci.prod.pauloazedo.dev)  
🔗 [UAT @ OCI](https://oci.uat.pauloazedo.dev)  
🔗 [Jenkins Dashboard](https://oci.jenkins.pauloazedo.dev)

> Each cloud provider uses its own subdomain prefix:  
> `oci.`, `aws.`, `azure.`, `gcp.` – for fully isolated stacks.

---

## Stack

- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS v4
- **Icons**: React Icons + Custom SVGs
- **Tooling**: ESLint, Prettier
- **Infrastructure**: OCI, AWS, GCP, Azure
- **Orchestration**: Ansible + Terraform
- **CI/CD**: Jenkins (agentless, Dockerized)
- **Certificates**: Let's Encrypt + Certbot (auto-renewal)
- **Monitoring**: Slack notifications for cert renewals

---

## Project Structure

\`\`\`
my-portfolio/
├── frontend/          # This React SPA
├── terraform/         # Multi-provider infra-as-code
│   ├── oci/           # OCI-specific infra (DNS, compute)
│   ├── aws/
│   ├── azure/
│   └── gcp/
└── ansible/           # Server config, app deploy, CI/CD
    ├── inventory/
    │   ├── aws.ini
    │   ├── oci.ini
    │   └── ...
    └── roles/
        ├── cloud_volume_oci/
        ├── nginx/
        └── jenkins/
\`\`\`

---

## Local Development

\`\`\`bash
cd my-portfolio/frontend
npm install
npm run dev
\`\`\`

Then visit: `http://localhost:3000`

---

## Build for Production

\`\`\`bash
npm run build
\`\`\`

Used in Jenkins for container image generation. Output goes to `.next/`.

---

## Features

- Modular React components
- Fully responsive and dark-themed
- Education & experience timeline
- Certification badge display using image references
- Downloadable resume in PDF format
- Placeholder “waiting for deploy” fallback image shown when UAT/PROD build not yet pushed

---

## Deployment Strategy

- Built in CI
- Containerized and deployed to UAT/PROD
- NGINX reverse proxy (port 80/443)
- Certificates issued via Certbot with auto-renewal

---

## License

MIT — Use freely, just give credit.