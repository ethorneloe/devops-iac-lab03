# Lab 03: Azure Linux VM with VNet and NSG

## Overview

This lab demonstrates how to create a basic Linux virtual machine on Azure with proper networking configuration using Terraform. You'll create a VNet, subnet, Network Security Group (NSG), and a Linux VM with SSH access.

## Learning Objectives

- Create and configure Azure Virtual Networks (VNet) and subnets
- Implement Network Security Groups (NSG) for controlling network access
- Deploy a Linux virtual machine on Azure
- Configure SSH authentication using SSH keys
- Connect to and manage a remote Linux VM

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Terraform installed (>= 1.0)
- SSH key pair generated (`~/.ssh/id_rsa.pub` must exist)
  - If you don't have one, generate it with: `ssh-keygen -t rsa -b 4096`
- Azure subscription with necessary permissions

## Architecture

This configuration creates:

- **Resource Group**: Container for all resources
- **Virtual Network (VNet)**: Network isolation with address space 10.0.0.0/16
- **Subnet**: Segment within VNet (10.0.1.0/24)
- **Network Security Group (NSG)**: Firewall rules allowing SSH (port 22) and HTTP (port 80)
- **Public IP**: Static public IP address for external access
- **Network Interface (NIC)**: Connects the VM to the network
- **Linux Virtual Machine**: Ubuntu 22.04 LTS VM

## Setup Instructions

### 1. Configure Terraform Variables

Copy the example tfvars file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
project_name                 = "tf-linux-vm-demo"
location                     = "australiaeast"
environment                  = "dev"
vm_admin_username            = "azureuser"
vm_admin_ssh_public_key_path = "~/.ssh/id_rsa.pub"
```

### 2. Configure Backend (Optional)

If using remote state storage, update the backend configuration in `providers.tf` with your actual values:

```hcl
backend "azurerm" {
  resource_group_name  = "your-tfstate-rg"
  storage_account_name = "yourtfstatestorage"
  container_name       = "tfstate"
  key                  = "linux-vm-${var.environment}.tfstate"
}
```

Or comment out the backend block to use local state for learning purposes.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Preview the Changes

```bash
terraform plan
```

Review the planned resources to be created.

### 5. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm.

## Post-Deployment

### 1. Get Connection Information

After successful deployment, Terraform will output the connection details:

```bash
terraform output
```

You should see:
- `vm_public_ip`: The public IP address of your VM
- `ssh_command`: Ready-to-use SSH command

### 2. Connect to Your VM

Use the SSH command from the output:

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

Or copy the exact command from output:

```bash
terraform output -raw ssh_command | bash -c "$(cat)"
```

Or simply:

```bash
eval $(terraform output -raw ssh_command)
```

### 3. Explore Your VM

Once connected, try these commands:

```bash
# Check OS version
cat /etc/os-release

# Check system resources
free -h
df -h

# Check network configuration
ip addr show
```

### 4. Optional: Install and Test Nginx

Install Nginx web server to test HTTP access:

```bash
# Update package list
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Check Nginx status
sudo systemctl status nginx
```

Then visit `http://<VM_PUBLIC_IP>` in your browser. You should see the Nginx welcome page.

### 5. Cleanup

When you're done with the lab, destroy all resources to avoid charges:

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

## File Structure

```
.
├── main.tf                      # Main resource definitions
├── variables.tf                 # Input variable declarations
├── outputs.tf                   # Output value definitions
├── providers.tf                 # Provider and backend configuration
├── terraform.tfvars.example     # Example variable values
└── README.md                    # This file
```

## Resources Created

| Resource Type | Name Pattern | Description |
|--------------|--------------|-------------|
| Resource Group | `{project}-{env}-rg` | Contains all resources |
| Virtual Network | `{project}-{env}-vnet` | Network with 10.0.0.0/16 |
| Subnet | `{project}-{env}-subnet` | Subnet with 10.0.1.0/24 |
| NSG | `{project}-{env}-nsg` | Security rules for SSH and HTTP |
| Public IP | `{project}-{env}-pip` | Static public IP |
| NIC | `{project}-{env}-nic` | Network interface |
| VM | `{project}-{env}-vm` | Ubuntu 22.04 LTS VM |

## Security Considerations

**⚠️ WARNING**: This configuration allows SSH and HTTP access from anywhere (`*`) for educational purposes only.

**For production environments, you should**:

1. Restrict SSH access to specific IP addresses:
   ```hcl
   source_address_prefix = "YOUR_IP_ADDRESS/32"
   ```

2. Use Azure Bastion for secure VM access

3. Implement Azure Key Vault for secrets management

4. Enable disk encryption

5. Configure Azure Monitor and logging

6. Use Network Security Group flow logs

7. Implement Just-In-Time (JIT) VM access

## Troubleshooting

### SSH Connection Refused

- Verify NSG rules allow SSH (port 22)
- Check VM is running: `az vm get-instance-view --resource-group <rg-name> --name <vm-name>`
- Verify public IP: `terraform output vm_public_ip`

### Permission Denied (publickey)

- Ensure your SSH public key is correctly specified in `terraform.tfvars`
- Verify the public key file exists: `cat ~/.ssh/id_rsa.pub`
- Check the private key has correct permissions: `chmod 600 ~/.ssh/id_rsa`

### Terraform Apply Fails

- Check Azure CLI authentication: `az account show`
- Verify you have sufficient permissions in your subscription
- Check quota limits in your region

## Additional Exercises

1. **Modify VM Size**: Change `vm_size` to `Standard_B2s` and observe the changes

2. **Add Data Disk**: Add an additional data disk to the VM

3. **Create Multiple VMs**: Use `count` or `for_each` to create multiple VMs

4. **Implement Load Balancer**: Add an Azure Load Balancer to distribute traffic

5. **Add Availability Set**: Place VMs in an availability set for high availability

6. **Custom Script Extension**: Use custom script extension to automatically install software

## References

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Virtual Machines Documentation](https://docs.microsoft.com/azure/virtual-machines/)
- [Azure Virtual Network Documentation](https://docs.microsoft.com/azure/virtual-network/)
- [Azure NSG Documentation](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)

## License

This lab material is provided for educational purposes.
