# Jenkins Azure Provisioning 
This project uses Terraform to create a VM in azure and set it up to enable ansible to install Docker, runs Jenkins in a container, and configures it with plugins and pipelines.

## Prerequisites

- Terraform and Ansible installed
- Azure CLI authenticated (`az login`)
- SSH keys at `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`
- Vault in ansible/secrets.yaml that contains secrets:
    - in my case it contains:
      - jenkins_account_username 
      - jenkins_account_password  
      - gitlab_stageDevops_commercial_token (for the first pipeline)
      - gitlab_reclamation_token (for the second pipeline)
- Vault password in `ansible/.vault_pass`

## Secrets
Create a secrets file:
```bash
ansible-vault create ansible/secrets.yaml
```
Edit encrypted secrets (you have to manually create the vault password file):
```bash
ansible-vault edit ansible/secrets.yaml --vault-password-file ansible/.vault_pass
```

## Usage

```bash
# Provision infrastructure
cd terraform
terraform init
terraform apply

# ansible will run automatically after the vm gets created

# Access Jenkins
# http://<VM_IP>:8080
```

