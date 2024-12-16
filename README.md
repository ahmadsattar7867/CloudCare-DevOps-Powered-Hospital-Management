# Hospital Management System

## Project Overview

This project is a comprehensive Hospital Management System that demonstrates the implementation of modern DevOps practices and cloud-native technologies. It showcases a full-stack application with microservices architecture, containerization, automated CI/CD pipelines, and deployment to a Kubernetes cluster on AWS using Terraform.

## Key Features

- Microservices-based architecture for scalability and maintainability
- Containerization using Docker for consistent development and deployment
- Kubernetes orchestration for robust and scalable cloud deployment
- CI/CD pipelines for automated testing, building, and deployment
- Infrastructure as Code using Terraform for AWS resource management
- Helm charts for streamlined Kubernetes deployments
- Comprehensive security measures including RBAC, network policies, and secrets management

## Technologies Used

- Development: MERN Stack
- Containerization: Docker
- Orchestration: Kubernetes
- CI/CD: [Your CI/CD tool, e.g., GitLab CI, GitHub Actions, Jenkins]
- Infrastructure as Code: Terraform
- Cloud Provider: AWS
- Package Management: Helm

## Containerization

Each service in the project is containerized using Docker. Optimized Dockerfiles are provided for each service, implementing best practices such as multi-stage builds and non-root users for enhanced security.

### Docker Compose for Local Development

A \`docker-compose.yml\` file is provided in the root directory, allowing for easy local development and testing. It includes configurations for hot-reloading to streamline the development process.

## Kubernetes Deployment

The application is deployed to a Kubernetes cluster on AWS. Key features of the Kubernetes setup include:

- Helm charts for templating and managing Kubernetes resources
- RBAC implementation for secure access control
- Ingress controllers for routing external traffic
- StatefulSets and Persistent Volume Claims (PVCs) for database management

## CI/CD Pipeline

The project includes a comprehensive CI/CD pipeline that automates the following tasks:

- Building Docker containers for all components
- Running unit tests
- Performing linting and Static Application Security Testing (SAST)
- Pushing containers to DockerHub with appropriate tags

The pipeline is configured to run on commits to the main branch and on pull request creation.

## Cloud Deployment

The application is deployed on AWS using the following approach:

- Terraform is used to provision and manage the Kubernetes cluster and associated AWS resources
- Helm charts are used in conjunction with Terraform to deploy the application to the cluster

## Security and Monitoring

Security measures implemented in the project include:

- Service accounts and RBAC for access control
- Network policies to control inter-pod communication
- Secrets management for sensitive information



