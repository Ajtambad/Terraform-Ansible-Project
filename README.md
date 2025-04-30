# AWS Infrastructure Automation with Jenkins, Terraform, and Ansible

## 📋 Project Overview

This project automates the complete lifecycle of an AWS EC2 instance — from provisioning, deployment, live website setup, to automatic teardown — using Jenkins, Terraform, Ansible, and GitHub Actions.
It demonstrates best practices in infrastructure as code (IaC), continuous deployment (CD), credential management, and ephemeral environment handling.

## ⚙️ Tools & Technologies

- Terraform – AWS EC2 provisioning

- Ansible – Server configuration & app deployment

- Jenkins – CI/CD automation and orchestration

- GitHub Webhooks – Automatic job triggering on code push

- AWS EC2 – Infrastructure platform

- Bash & Groovy – Automation scripting

## 🚀 Workflow

Git Push ➔ GitHub webhook triggers Jenkins pipeline

Jenkins Pipeline

  - Runs terraform apply to create EC2 instance

  - Injects SSH keys dynamically using Jenkins credentials

  - Configures server with Ansible (installs HTTP server, deploys site)

  - Verifies website is live using curl

Timer Trigger

  - After 15 minutes, Jenkins triggers a destroy pipeline

  - Runs terraform destroy to tear down infrastructure cleanly

## 🔒 Credential Management

- AWS keys and SSH private keys are securely stored in Jenkins Credentials Manager.

- No sensitive files are pushed to GitHub.

- Terraform user data injects keys dynamically during EC2 provisioning.

## 📂 Project Structure

    .
    ├── Terraform/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── user_data.sh
    ├── Ansible/
    │   ├── playbook.yaml
    │   └── hosts
    ├── Jenkinsfile
    └── README.md

## 🌟 Key Highlights

- Fully automated end-to-end deployment
  
- Secure handling of credentials (no hardcoding)

- Auto-expiry infrastructure (saves AWS cost)

- Hands-on practice with real-world CI/CD tools

## 🧠 Lessons Learned

- How to integrate Terraform, Ansible, Jenkins, and GitHub in a production-style pipeline

- How to securely manage keys and secrets across tools

- How to implement timed resource destruction to prevent cloud wastage
