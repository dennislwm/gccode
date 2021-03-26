# gccode
Docker starter project for Google Cloud ["GC"].

<!-- TOC -->

- [gccode](#gccode)
    - [About gccode](#about-gccode)
    - [Project Structure](#project-structure)
    - [Installation](#installation)
        - [Terraform](#terraform)
        - [GC SDK](#gc-sdk)
        - [Troubleshooting](#troubleshooting)
    - [Terraform Project](#terraform-project)
        - [Creating the Main File](#creating-the-main-file)
        - [Enabling the APIs](#enabling-the-apis)
        - [Setting up Remote State in Cloud Storage](#setting-up-remote-state-in-cloud-storage)
        - [Troubleshooting](#troubleshooting)
    - [Infrastructure as Code](#infrastructure-as-code)
        - [Initializing Terraform](#initializing-terraform)
        - [Create a Terraform Plan](#create-a-terraform-plan)
        - [Execute a Terraform Plan](#execute-a-terraform-plan)

<!-- /TOC -->

---
## About gccode
**gccode** was a personal project to:
- automate SSH key generation and uploading to remote server
- automate droplet creation in a remote server
- automate package installation in a remote server
- automate make swapfile in a remote server
- automate docker-compose in a remote server
- automate restore files to a remote server
- automate backup files from a remote server

---
## Project Structure
     gccode/                          <-- Root of your project
       |- README.md                   <-- This README markdown file
       +- config/                     <-- Holds any configuration files
       +- tf/                         <-- Terraform root folder
          |- main.tf                  <-- Main TF file (required)

---
## Installation

### Terraform

* [Download Terraform](https://www.terraform.io/downloads.html)

Terraform is distributed as a single binary. Install Terraform (64-bit) by unzipping it and moving it to a directory included in your system's ```PATH```.

### GC SDK

* [Installing Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

You should check the option to Install Bundled Python, if you don't have Python installed. After installation, you will need to include these directories in your system's ```PATH```, substituting ```$GOOGLE_CLOUD_SDK``` with your installed directory:
* ```$GOOGLE_CLOUD_SDK\bin```
* ```$GOOGLE_CLOUD_SDK\platform\bundledpython```

The first step is to run the command line ```gcloud init``` that prompts authenticate with your Google Cloud account. After that it prompts you to either select an existing or create a new project.

The second step is to use Google Cloud Console and navigate to ```IAM & Admin -> Service Accounts```. Next create a new service account with a name and description (optional), then set ```Editor``` role access to this service account. 

Final step is to grant admin access to your Google user account and to create a private JSON key to the service account. Save the key to your PC and set the environment variable to the key file's path:

```GOOGLE_APPLICATION_CREDENTIALS=[PATH]/[FILE]```

### Troubleshooting

* ["Permission Denied" trying to run Python on Windows 10 - Stack Overflow](https://stackoverflow.com/questions/56974927/permission-denied-trying-to-run-python-on-windows-10)

* [Creating and managing service account keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

* [Getting Started with the Google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started)

## Terraform Project

### Creating the Main File

Create a ```main.tf``` file and type the following code. Save it in the ```tf``` folder. Substitute ```<PATH>``` and ```<FILE>``` with the path and filename of your Google private JSON key.

```
provider "google" {
  credentials = file("<PATH>/<FILE>")

  project = "gccode"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "objVpcNetwork" {
  name = "vn_gcode"
}
```
### Enabling the APIs

Use Google Cloud Console and navigate to API & Services --> Dashboard. Click on **Enable APIs and Services**, search and enable the following API (repeat steps for each):

* Cloud Resource Manager API
* Compute Engine API
* Cloud Storage
* Identity and Access Management (IAM) API
* Cloud Billing API

### Setting up Remote State in Cloud Storage

This step is OPTIONAL.

Remote state supports state locking. You can skip this step if you want to store your terraform state file within your local PC.

Create a bucket using Google Cloud Console and pick a globally unique name for each bucket that you create with default settings and region. Create a folder ```tf``` within each bucket.

Append the following code to your ```main.tf``` file. Substitute ```<GC_BUCKET>``` with your bucket name, and ```<GC_FOLDER>``` with the folder name within the bucket.

```
terraform {
  backend "gcs" {
    bucket  = "<GC_BUCKET>"
    prefix  = "<GC_FOLDER>"
    credentials = "<PATH>/<FILE>"
  }
}
```

### Troubleshooting

* [Backend Type: gcs](https://www.terraform.io/docs/language/settings/backends/gcs.html)

---
## Infrastructure as Code

### Initializing Terraform

In the Terraform root folder, type the following command in your terminal:

     $ terraform init

---

### Create a Terraform Plan

Type the following command in your terminal:

     $ terraform plan

---

### Execute a Terraform Plan

Type the following command in your terminal:

     $ terraform apply

Before typing 'yes', ensure that ALL resources Terraform will create and **destroy** are correct.

---
