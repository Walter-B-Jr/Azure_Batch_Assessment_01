## Lab Name: AzureBatch.L200.Troubleshooting.1

Introduction
This is a Level 200 lab for the Troubleshooting in Azure Batch.

## Deployment Instructions

Deploy the ARM template **`azuredeploy.json`** (in the root of this repo) using any option below.

### Option 1 - Deploy to Azure (one-click)
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FWalter-B-Jr%2FAzure_Batch_Assessment_01%2Fmaster%2Fazuredeploy.json)

Click the button, pick (or create) a resource group + region, set `namePrefix`, then **Review + create** -> **Create**.

### Option 2 - Azure CLI
```powershell
az group create -n rg-batch-lab-01 -l westus2
az deployment group create -g rg-batch-lab-01 --template-file azuredeploy.json --parameters namePrefix=batlab01
az deployment group show -g rg-batch-lab-01 -n azuredeploy --query properties.outputs
```

### Option 3 - Azure Portal (Load file)
1. Portal -> search **Deploy a custom template** -> **Build your own template in the editor**.
2. **Load file** -> select `azuredeploy.json` from this repo -> **Save**.
3. Choose/create a resource group + region, set `namePrefix`, then **Review + create** -> **Create**.

### After deploying
Open the deployment **Outputs** for `batchAccountName`, `batchAccountUrl`, and `storageAccountName`, then get the keys from the portal:
- Batch account -> **Keys** -> account **URL** + **Primary access key**.
- Storage account -> **Access keys** -> account name + **key1**.

Paste these into `DotNetTutorial\Program.cs` (`BatchAccountName`, `BatchAccountUrl`, `BatchAccountKey`, `StorageAccountName`, `StorageAccountKey`), then build and run the console app.

<details><summary>Manual deployment (alternative)</summary>
[Deployment Template to be added soon]
1.	First, create a Batch and storage account using the following guidance: https://docs.microsoft.com/en-us/azure/batch/quick-create-portal#create-a-batch-account. NOTE: they both must be within the same resourceGroup
2.	Once you have created the accounts above. Please download the code sample here: https://github.com/Walter-B-Jr/Azure_Batch_Assessment_01 
3.	Open the code sample in VS and make the following required changes:
a.	Open �Program.cs� under DotNetTutorial application. 
b.	Proceed to enter the credentials generated for both your Batch and storage account in the relevant fields:
i.	BatchAccountName
ii.	BatchAccountKey
iii.	BatchAccountUrl
iv.	StorageAccountName
v.	StorageAccountKey
vi.	You can name your PoolID and JobID however you desire.

 

</details>

## Resources Created
This lab involves the following resources.
-	A Resource Group (preferable)
-	A Batch Account (required)
-	A Storage Account (required)

## Scenario
In this lab, you will run the Batch Job. This Job�s Task should fail. 
## Your Goal
Your goal is to identify the Task failure using our internal tools. (i.e. confirmation of failure using our internal tools). To confirm, you will be required to take a snapshot of the failure identified in KUSTO and Azure Batch Diagnostics tool. The goal is to use our internal tools to identify the Task failure. These images should include timestamps and the failure status.
## Proof of Solution
1.	Provide a screen capture of KUSTO:  once you have found the error, highlighting the relevant indicators of the Task failure. KUSTO download:

Redmond mirror	 http://kusto-us/ke/Kusto.Explorer.application
ILDC mirror	 http://kusto/ke/Kusto.Explorer.aapplication 

2.	Provide a screen capture of the AzureBatchDiagnostics: https://azurebatchdiagnostics.azurewebsites.net/. Once you have found the error. Again, highlight the relevant indicators of the Task failure
3.	Bonus: Explain what the next steps in troubleshooting should be.
