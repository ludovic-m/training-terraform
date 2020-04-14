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
  - [Exercice 4 : Creation de workspaces (environnements)](#exercice-4--creation-de-workspaces-environnements)
  - [Exercice 5 : Constrution d'une (petite) infra](#exercice-5--constrution-dune-petite-infra)
  - [Exercice 6 : Travailler en equipe sur le projet (remote tfstate)](#exercice-6--travailler-en-equipe-sur-le-projet-remote-tfstate)
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
provider "azurerm" { }

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
resource "azurerm_subnet" "subnet_coding_dojo" {
  name                 = "subnet_coding_dojo"
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

We will had a Network Interface in our subnet, and introduce the use of variables and built-in functions.

We will create a file named `variables.tf` where we will declare all the variables we're going to use, with a default value. Then we will create a file named `values.tfvars` which will contain the vales of our variables.

For example, we will declare the `location` variable, set the value to `West Europe`, and use it for every resources we have.

For each variable, you can set a default value (which can be overriden later).

Perform the following tasks :

- Add a `nic.tf` file and add a Network Interface using the snippet `tf-azurerm_network_interface`
- Add a `variables.tf` file and decalre the `location` variable with a default value set to `West Europe`
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

## Exercice 4 : Creation de workspaces (environnements)

Les workspaces permettent de gérer plusieurs environnements. Chaque workspace a un fichier `.tfstate` dédié.

Le but de l'exercice est d'avoir deux workspaces : **Production** et **Recette** utilisant chacun un fichier de configuration distinct.

- Créer un fichier `recette.tfvars` et copier / coller les variables du fichier `production.tfvars` en chageant leurs valeurs
- Créer deux workspaces à l'aide de la commande `terraform workspace new <workspace_name>`
- Déployer les environnements sur chacun des deux workspaces

Pour switcher de workspace, utiliser la commande `terraform workspace select <workspace_name>`

Pour voir la liste des workspaces et le workspace actif, utiliser la commande `terraform workspace list`

## Exercice 5 : Constrution d'une (petite) infra

Le but est de compléter les exercices précédents pour construire l'infra suivante :

![exercice6-infra](exercice6.jpg)

Les machines virtuelles auront les caractéristiques suivantes :

| Property | Value |
| --- | --- |
| vm_size | "Standard_D2s_v3" (permet d'avoir des disques Premium) |
| OS publisher | "Canonical" |
| OS offer | "UbuntuServer"|
| OS sku | "14.04.2-LTS" |
| OS version | latest |
|managed_disk_type |"Premium_LRS" |

Le seul requirement est qu'on doit pouvoir ajouter facilement une ou plusieurs autres VM sur l'environnement de production.

Il est recommandé de créer les fichiers suivants :

- `disk.tf`
  - Contient le Data Disk managé de la VM (ressource `azurerm_managed_disk`). Se référer à la doc Terraform, pas de snippet pour cette ressource.

```bash
resource "azurerm_managed_disk" "datadisk_coding_dojo" {
  name = "datadisk"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_coding_dojo.name}"
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = "1024"
}
```

- `availability_set.tf`
  - L'availability set doit aussi être managé pour supporter des VM avece des disques managés. Ajouter la propriété `managed = "true"`
- `nsg.tf`
  - Network security group pour le subnet
- `vm.tf`
  - Vous aurez besoin d'un OS Disk et d'un Data Disk (celui que vous avez créé dans le fichier `disk.tf`)

```bash
  storage_os_disk {
    name              = "${var.vm_coding_dojo_name}_osdisk"
    managed_disk_type = "Premium_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name              = "${var.vm_coding_dojo_name}_datadisk"
    managed_disk_id   = "${azurerm_managed_disk.datadisk_coding_dojo.id}"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = "1024"
    create_option     = "Attach"
    lun               = 0
  }
```

Le premier est créé directement, alors que le deuxième est une référence au disque déjà créé. Attention, les propriétés qui définissent la taille et le nom du disque doivent être les mêmes dans le fichier `disk.tf` et `vm.tf`.

Quelques points à noter :

- Le hostname doit être écrit avec des caractères alphanumériques
- Le login de la VM ne doit pas être 'admin' (il y a une liste de login interdits)
- Le password de la VM doit faire au moins 12 caractèresn avec (probablement) des caractères spéciaux

Pour créer plusieurs VMs, on utilisera la propriété `count`. On a après plusieurs solutions :

- Soit les VM sont en IP Statique
  - On déclare alors la liste des IPs dans le fichier de variables, et on donne comme valeur à `count` la taille du tableau qui liste ces IPs (fonction `length`).
- Soit les VM sont en IP Dynamique
  - Dans le fichier de variables, on rajoute une propriété qui est simplement le nombre de machine.

## Exercice 6 : Travailler en equipe sur le projet (remote tfstate)

Jusqu'à présent, le fichier `.tfstate` enregistrant l'état de la plateforme est stocké localement. Cela devient un problème quand plusieurs personnes travaillent sur l'infrastructure ou si l'infrastructure est gérée dans un pipeline de CI/CD (qui utilise en général un workspace temporaire pour s'exécuter).

Terraform permet de stocker le `.tfstate` en remote, afin de pouvoir le partager avec le reste de l'équipe, et que chacun puisse le lock lors d'une modification de l'infrastructure.

On profitera de cet exercice pour s'authentifier, non plus avec l'Azure CLI, mais avec une App Azure AD.

Sur Azure, Terraform supporte de le stocker dans un `Storage Account > Blob > Container`.

Côté Azure :

- Créer une App dans l'Azure AD de votre souscription
- Générer un client secret
- Vous aurez besoin du tenantId, applicationId, clientSecret, et subscriptionId
- Donner des droits de contributeurs à l'App sur la souscription
- Créer un Blob Container dans un Storage Account

Côté Terraform :

Modifiez le `main.tf` pour ajouter le backend et l'authentification via une App Azure, et ajoutez les variables manquantes dans le `variables.tf`

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

- Créer un fichier `backend.secrets.tfvars` (infos de connexion au storage account) et un fichier `dojo.secrets.tfvars` (infos de connexion à la souscription Azure)
- Remplissez avec les valeurs des variables

D'après la documentation Terraform, le fichier de configuration du backend doit avoir les valeurs de variables sous la forme :

```bash
arm_subscription_id = "subscription_id"

arm_client_id = "client_id"

arm_client_secret = "client_secret"

arm_tenant_id = "tenant_id"
```

Initialisez le backend pour prendre en compte les modifications. Si vous avez une erreur, supprimez le répertoire `.terraform` qui contient l'ancien fichier `.tfstate`

```bash
terraform init --backend-config="backend.secrets.tfvars" --var-file="dojo.secrets.tfvars"
```

- Recréer les deux workspaces `prod` et `rec` et déployez l'infrastructure en recette.

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
