<div align="center">

# ☁️ Azure Cloud Adoption Framework (CAF) Production Landing Zone
### **Enterprise Terraform Architecture with Management Groups, Hub-and-Spoke Networking & Automated Drift Detection**

![Terraform](https://img.shields.io/badge/Terraform-v1.5%2B-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Azure CAF](https://img.shields.io/badge/Architecture-Microsoft_CAF-0089D6?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Security](https://img.shields.io/badge/Compliance-CIS_Azure_v2.0-238636?style=for-the-badge)

</div>

---

## 📌 Architectural Overview

This repository provides an enterprise-ready **Microsoft Cloud Adoption Framework (CAF)** landing zone implementation engineered with Terraform. It provisions a hardened, isolated, and scalable multi-subscription cloud foundation:

- 🏛️ **Management Group Hierarchy:** Tenant Root $\rightarrow$ Platform (Identity, Management, Connectivity) & Workload Landing Zones (Corp, Online, Sandbox).
- 🌐 **Hub-and-Spoke Networking:** Central Hub VNet with **Azure Firewall Premium**, GatewaySubnet (ExpressRoute/S2S VPN), and central Private DNS Zones.
- 🚦 **Forced Traffic Inspection:** User-Defined Routes (UDRs) routing all egress (`0.0.0.0/0`) and inter-spoke traffic through the Azure Firewall.
- 🔄 **Continuous Drift Detection:** Nightly automated CI pipeline executing `terraform plan -detailed-exitcode` to detect unmanaged console mutations.

---

## 🧭 Tenant & Management Group Hierarchy

```
                            [ Microsoft Entra ID Tenant ]
                                          |
                              [ Tenant Root Group ]
                                          |
         +--------------------------------+--------------------------------+
         |                                |                                |
[ Platform Management Group ]   [ Landing Zones (Workloads) ]    [ Decommissioned / Sandbox ]
   |-- Identity (AD/DNS)           |-- Corp (Internal Only)         |-- Sandbox MG
   |-- Management (Logs/Mon)       |-- Online (Public/DMZ)          |-- Decommissioned MG
   `-- Connectivity (Hub/Firewall) |-- Dev Subscriptions
                                   |-- UAT Subscriptions
                                   `-- Prod Subscriptions
```

---

## 📁 Repository Structure

```
azure-caf-production-landing-zone/
├── main.tf                         # Hub VNet, Azure Firewall, GatewaySubnet & UDRs
├── variables.tf                    # Input variable specifications
├── terraform.tfvars                # Production CIDR blocks & region settings
├── versions.tf                     # Pinned AzureRM provider configuration
├── .gitignore                      # Standard Terraform ignore rules
├── .github/workflows/
│   └── drift-detection.yml         # Scheduled nightly drift detection workflow
└── README.md                       # Architecture & execution runbook
```

---

## 🚀 Deployment & Validation

```bash
# 1. Initialize working directory
terraform init -backend=false

# 2. Verify syntax and formatting
terraform fmt -check
terraform validate

# 3. Generate execution plan
terraform plan
```

---

## 👨‍💻 Author
**Ashwani Jaiswal**  
*Azure DevOps Engineer & DevSecOps Specialist*  
- GitHub: [@iashwanijaiswal](https://github.com/iashwanijaiswal)  
- LinkedIn: [linkedin.com/in/iashwanijaiswal](https://linkedin.com/in/iashwanijaiswal)
