## Lab Name: AzureBatch.L200.Troubleshooting.1

### Introduction
This is a Level 200 lab for Troubleshooting in Azure Batch. It is a **self-contained failure scenario**: deploying the template stands up the entire environment *and* runs the failing workload automatically. There is **no console app to build or run** and **no manual steps** — your job is purely to diagnose the failure with our internal tools.

## Deployment Instructions

Deploy the ARM template **`azuredeploy.json`** (root of this repo) using any option below.

### Option 1 - Deploy to Azure (one-click)
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FWalter-B-Jr%2FAzure_Batch_Assessment_01%2Fmaster%2Fazuredeploy.json)

Click the button, pick (or create) a resource group + region, optionally set `namePrefix`, then **Review + create** -> **Create**.

### Option 2 - Azure CLI
```powershell
az group create -n rg-batch-lab-01 -l eastus2
az deployment group create -g rg-batch-lab-01 --template-file azuredeploy.json --parameters namePrefix=batlab01
```
> Pick a region where your subscription has Batch **dedicated core quota** so the pool node can allocate.

### Option 3 - Azure Portal (Load file)
1. Portal -> search **Deploy a custom template** -> **Build your own template in the editor**.
2. **Load file** -> select `azuredeploy.json` -> **Save**.
3. Choose/create a resource group + region, optionally set `namePrefix`, then **Review + create** -> **Create**.

## What happens automatically
The deployment creates the Batch and Storage accounts, a compute pool, and (via a short-lived seed container) a job with three tasks. The pool node boots, the tasks run to **completion but report a failure** — you do not need to do anything to trigger it. Allow a few minutes for the node to provision and the tasks to run.

## Resources Created
- A Resource Group
- A Batch Account
- A Storage Account
- A Batch **Pool** (`batch_assessment_01_pool`)
- A Batch **Job** + failing **Tasks** (`batch_assessment_01_job`)
- A short-lived User-Assigned Managed Identity + Container Instance used only to seed the job/tasks (safe to leave; it stops after seeding)

## Scenario
In this lab, a Batch Job has already run. The Job's Tasks should fail. 

## Your Goal
Your goal is to identify the Task failure using our internal tools (i.e. confirmation of failure using our internal tools). To confirm, you will be required to take a snapshot of the failure identified in Kusto and the Azure Batch Diagnostics tool. These images should include timestamps and the failure status.

## Proof of Solution
1. Provide a screen capture of Kusto once you have found the error, highlighting the relevant indicators of the Task failure. Kusto download:

   - Redmond mirror: http://kusto-us/ke/Kusto.Explorer.application
   - ILDC mirror: http://kusto/ke/Kusto.Explorer.application

2. Provide a screen capture of the Azure Batch Diagnostics tool (https://azurebatchdiagnostics.azurewebsites.net/) once you have found the error. Again, highlight the relevant indicators of the Task failure.
3. Bonus: Explain what the next steps in troubleshooting should be.
