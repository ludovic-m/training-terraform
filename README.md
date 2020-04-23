# Terraform Quick Start on Azure

<!-- toc -->

- [Terraform Quick Start on Azure](#terraform-quick-start-on-azure)
  - [Prerequisites](#prerequisites)
  - [Terraform install](#terraform-install)
    - [Manual install](#manual-install)
    - [Install using Chocolatey](#install-using-chocolatey)
  - [Exercise 1 : Terraform initialization and creation of a resourge group](#exercise-1--terraform-initialization-and-creation-of-a-resourge-group)
  - [Exercise 2 : Creation of a Virtual Network](#exercise-2--creation-of-a-virtual-network)
  - [Exercice 3 : Variables and functions](#exercice-3--variables-and-functions)
  - [Exercice 4 : Workspaces](#exercice-4--workspaces)
  - [Exercice 5 : Build a set of virtual machines](#exercice-5--build-a-set-of-virtual-machines)
    - [Availability set](#availability-set)
    - [Network Security Group](#network-security-group)
    - [Virtual Machine](#virtual-machine)
    - [Replicate Virtual Machines](#replicate-virtual-machines)
  - [Exercice 6 : Remote Tfstate](#exercice-6--remote-tfstate)
  - [Exercice 7](#exercice-7)

<!-- tocstop -->

## Prerequisites

- An active Azure subscription (with administrator privileges)
- Visual Studio Code
  - Terraform extension : <https://marketplace.visualstudio.com/items?itemName=mauve.terraform>
    - Enable support for 0.12 language : <https://medium.com/@gmusumeci/how-to-install-update-enable-and-disable-language-server-for-terraform-extension-in-visual-116e73f58722>
  - Terraform snipets extension : <https://marketplace.visualstudio.com/items?itemName=mindginative.terraform-snippets> (extension outdated)
- Azure CLI : <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest>
- Git (optional) : <https://git-scm.com/download/win>
- Terraform documentation for Azure : <https://www.terraform.io/docs/providers/azurerm/>

## Terraform install

### Manual install

- Download the package on the official website : <https://www.terraform.io/downloads.html>
- Update the PATH to make the terraform binary available : <https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows>

### Install using Chocolatey

Chocolatey is a Windows Package Manager. It can be used to install Terraform.

You can install Chocolatey with PowerShell using this command line : <https://chocolatey.org/install#install-with-powershellexe>

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Then you can install Terraform

```bash
choco install terraform
```

## Exercise 1 : Terraform initialization and creation of a resourge group

A terraform project is made of a collection of `*.tf` files. Terraform files are written using HCL (HashiCorp Configuration Language)

Create an empty folder, then create the file `main.tf`

```bash
provider "azurerm" {
  features {}
 }

# Snippet tf-azurerm_resource_group
resource "azurerm_resource_group" "rg_training" {
   name = "rg-training"
   location = "West Europe"
}
```

- The first line indicates which Terraform provider is to be used
- The second block will create a resource group named `rg-training`

Open a terminal, and go to the directory you just created.

The first step is to initialize the Terraform project. Run the following command :

```bash
terraform init
```

Terraform will download the latest vestion of the Azure provider, and create a `.terraform` folder where all the artefacts needed to run Terraform will be stored. This folder must be present in the `.gitignore` file if you want to use Git.

Authenticate to your Azure Subscription using the Azure CLI (this won't work with a PowerShell command)

```bash
az login

# If you have more than one subscription associated with your account, select the one you want to use
az account set --subscription <subscription_id>
```

> There's another way to authenticate to Azure to run your Terraform project, using an App. It's the recommended way to do in a real life situation, but the one we use is the fastest and is more than ok for a training.

Once you're authenticated on Azure, run the following command :

```bash
terraform plan
```

This command won't do anything on Azure, but it will show you what's going to be done, like a dry run. You should see that one resource group will be created, and no resource will be updated or deleted.

In order to apply the modifications on Azure, run the command :

```bash
terraform apply

# Type yes to confirm
```

Using the command `az group list` or directly in the Azure Portal, you should now see the resource group `rg-training`

A `terraform.tfstate` file has been created at the root of the folder. It contains the state of your infrastructure deployed with your Terraform project. One again, don't put this file in your Source Control, even if you are more than one working on the project. You will see later how to store it to work in a distributed way.

## Exercise 2 : Creation of a Virtual Network

We will add a Virtual Network and a Subnet in our resource group. Create a second file named `vnet.tf` and add the following resources :

```bash
# Snippet : tf-azurerm_virtual_network
resource "azurerm_virtual_network" "vnet_training" {
  name                = "vnet-training"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.rg_training.name
  address_space       = ["10.0.0.0/16"]
}

# Snippet : tf-azurerm_subnet
resource "azurerm_subnet" "subnet_training" {
  name                 = "subnet-training"
  resource_group_name = azurerm_resource_group.rg_training.name
  virtual_network_name = azurerm_virtual_network.vnet_training.name
  address_prefix       = "10.0.1.0/24"
}
```

Run the command `terraform plan`

Since the resource group is already there, Terraform will only create 2 additional resources.

Run `terraform apply`

Once you've checked that all the resources have been created correctly, destroy everything using the command `terraform destroy`.

## Exercice 3 : Variables and functions

We will add a Network Interface in our subnet, and introduce the use of variables and built-in functions.

We will create a file named `variables.tf` where we will declare all the variables we're going to use, with a default value. Then we will create a file named `values.tfvars` which will contain the vales of our variables.

For example, we will declare the `location` variable, set the value to `West Europe`, and use it for every resources we have.

For each variable, you can set a default value (which can be overriden later).

Perform the following tasks :

- Add a `nic.tf` file and add a Network Interface using the snippet `tf-azurerm_network_interface` or the one in the official Terraform documentation

```bash
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet_training.address_prefix, 10)
  }
}
```

The `cidrhost` function allows you to calculate an address using a subnet prefix.

- Add a `variables.tf` file and declare the `location` variable with a default value set to `West Europe`

```bash
variable "location" {
  default = "West Europe"
}
```

- In each `.tf` file (main, nic, vnet), replace hardcoded values with variables
- Create a file `values.tfvars` which will contain values for the variables, using the following syntax :

```bash
var_01 = "value01"

var_02 = "value02"

var_03 = "value03"
```

Run the commands :

```bash
terraform plan --var-file="values.tfvars"
terraform apply --var-file="values.tfvars"
```

Once you've checked that everything is deployed correctly, run a `terraform destroy`.

> Tips : Use the `variables.tf` file to declare variables that are used globally accross tf files. If a variable is only used in a single `.tf` file, like, for example, the `vnet_address_space`, declare it directly in the same `.tf` file. Doing this, you can differentiate global and local variables, even if in the end, it's the same for the Terraform engine.

## Exercice 4 : Workspaces

Workspaces allow you yo have multiple version of the same infrastructure. It's used, for example, to create a Production environment, a Development environment, etc...

Every workspace has a dedicated `.tfstate` file.

The goal of this exercise is to create two workspaces : **Production** and **Development**. For each workspace, we will create a dedicated `.tfvars` file, in order to have different values for each environment.

- Create a  `dev.tfvars`, copy / paste the content of the `values.tfvars` file, and change the values.
- Rename the `values.tfvars` in `prod.tfvars`
- Create two workspaces with the command `terraform workspace new <workspace_name>`
- Use the variable `terraform.workspace` in your resources name in order to identify each resources created within the workspace. For example, in the `main.tf` file :

```bash
resource "azurerm_resource_group" "rg_training" {
  name     = "rg-${terraform.workspace}-training"
  location = var.location
}
```

- Deploy the two environments on each workspaces

To switch between workspaces, use the command `terraform workspace select <workspace_name>`

To see the list of workspaces, and which one of them is selected, use the command `terraform workspace list`

## Exercice 5 : Build a set of virtual machines

The goal is to continue the previous exercise to build the following infrastructure :

![exercice6-infra](exercice6.jpg)

The virtual machines must have the following configuration :

| Property | Value |
| --- | --- |
| vm_size | "Standard_DS2_v2" (permet d'avoir des disques Premium) |
| OS publisher | "Canonical" |
| OS offer | "UbuntuServer"|
| OS sku | "14.04.2-LTS" |
| OS version | latest |
|managed_disk_type |"Premium_LRS" |

You're required to make it easy to add another virtual machine later.

### Availability set

Create a file named `availability_set.tf` and add the resource. Set the `managed` property to true in order to be able to use managed disks later.

```bash
resource "azurerm_availability_set" "example" {
  name                = "example-aset"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  managed             = true
}
```

Don't forget either to put the workspace name in the name of the resource, so we don't have duplicate later.

### Network Security Group

Create a file named `nsg.tf` and add a network security group resource.

```bash
resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
```

Add the nsg to the subnet using the `azurerm_subnet_network_security_group_association` resource

```bash
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}
```

### Virtual Machine

Create a file named `vm.tf` and add a virtual machine resource with the spec defined earlier.

```bash
resource "azurerm_virtual_machine" "main" {
  name                  = "vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS2_v2"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "avanade"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/avanade/.ssh/authorized_keys"
      key_data = "ssh_public_key"
    }
  }
}
```

A few things to note :

- The hostname must contain only alphanumerical characters.
- The login of the VM cannot be **admin**

### Replicate Virtual Machines

Now that you have a virtual machine, use the `count` keyword to duplicate it.

- Declare a variable to define the number of virtual machines you need.
- Use the variable in each resource that needs to be duplicated, and the `count.index` property to iterate
- In your virtual machine resource, you will have to reference a nic. Use the array syntax with the `count.index` property

At the end of the exercise, delete the infrastructure on both workspaces.

## Exercice 6 : Remote Tfstate

Until now, the `.tfstate` file, which save the state of the infrastructure, is stored locally. This is a problem when you're not the only one working on the Terraform project, or when you use a CI / CD pipeline to deploy your infrastructure (executed in a stateless agent).

Terraform allow you to store the `.tfstate` remotely, so you can share it with the rest of your team.

During the exercise, we will also switch from Azure CLI authentication to using an Azure AD App.

On Azure, Terraform supports to store the `.tfstate` in a Blob Storage.

On the Azure side, you have to :

- Create an App in your Azure AD tenant
- Generate a client secret
- Give this App Contributor or Owner permissions on your subscription
- Create a Blob Container in a Storage Account (manually, without Terraform)

On the Terraform side, you have to :

- Modify the `main.tf` file to add the backend config (which host the `.tfstate`), modify the provider bloc to enable the Azure App authentication, and add the missing variables in the `variables.tf` file

```bash
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "<resource group name>"
    storage_account_name = "<storage account name>"
    container_name       = "<container name>"
    key                  = "<key>"
  }
}
```

- Create a `backend.secrets.tfvars` file, containing the infos to connect to the storage account, and a file `auth.secrets.tfvars` containing the infos to authenticate your Azure subscription

According to the Terraform documentation, the config file for the backend must contains the following values :

```bash
subscription_id = "subscription_id"

client_id = "client_id"

client_secret = "client_secret"

tenant_id = "tenant_id"
```

Initialize the backend to take into account the modifications. If you have an error, delete the `.terraform` folder and try again.

```bash
terraform init --backend-config="backend.secrets.tfvars"
```

Redeploy the whole infrastructure.

## Exercice 7

- Créer un répo GIT sur Azure DevOps
- Initialiser le répertoire local en répository Git et configurer la branche remote/origin comme étant le répo que vous avez créé sur Azure DevOps

```bash
git init
git remote add origin <repo_url>
git add .
git commit -am "Init"
git push -u origin master
```

- Installer l'extension `Terraform` de Peter Groenewegen (Xpirit)
- Créer un nouveau build et utilisez les étapes Terraform pour sélectionner le workspace, puis appliquer les changements
- N'oubliez pas de renseigner les variables d'environnement en les préfixant avec TF_VAR_<nom_variable> (attention, il faut que la variable soit en majuscule)
