# nodesource_lab

## Resources to be Deployd

### Networking
- AWS VPC
- AWS Private and Public Subents (us-east-1b) (us-east-1b)
- AWS NAT Gateway
- AWS Route Table

### Compute
- AWS EKS
- AWS EKS Managed Node Groups
- AWS ECR registries
- AWS EKS Load Balancer controller
- AWS ALB Ingress

### CI/CD
The Github Actions pipeline will be triggered On the following escenarios:
- When merge a commit on main branch will run the Build and Deploy steps.
- When create a PUll REQUEST will run only a BUILD.

The following steps will be executed:
- Configure AWS Credentials from github secrets
- Configure AWS ECR credentials
- Build and Push to ECR the Docker image, I use as tag the sha commit.
- Configure EKS token credentials
- Perform an Apply with kubectl over the k8s manifests

This pipeline is enough simple just for deploy the LAB and his changes.

## Folder structure & content

### Folder Content

#### .github
The .github folder contains the Github Actions pipelines to build and deploy de microServiceA and microServiceB artifacts

#### Infrastructure
This folder contains the terraform code to the deploy the infrastructure for this LAB

#### packages
This folder contains the folder microServiceA and microServiceB which have a very very basic REST-API with express

```
nodesource_lab
├── .github
    └── workflows
│       ├── build-and-deploy-a.yml
│       └── build-and-deploy-b.yml
├── Infrastructure
│   ├── backend.tf
│   ├── main.tf
│   ├── variables.tf
│   └── versions.tf
├── README.md
└── packages
    ├── microServiceA
    │   ├── Dockerfile
    │   ├── app.js
    │   ├── k8s
    │   │   ├── deployment.yml
    │   │   └── service.yml
    │   ├── package-lock.json
    │   └── package.json
    └── microServiceB
        ├── Dockerfile
        ├── app.js
        ├── k8s
        │   ├── deployment.yml
        │   └── service.yml
        └── package.json
```

## Reference arch AWS NETWORK


![image](https://user-images.githubusercontent.com/55195249/166247426-57657f11-261c-48b7-a1a6-24976ece8915.png)
