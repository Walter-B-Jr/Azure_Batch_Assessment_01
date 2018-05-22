## 
Lab Name: AzureBatch.L200.Troubleshooting.4

Introduction
This is a Level 200 lab for the Troubleshooting in Azure App Service.
Deployment Instructions
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

 

Resources Created
This lab involves the following resources.
-	A Resource Group (preferable)
-	A Batch Account (required)
-	A Storage Account (required)

Scenario
In this lab, you will run the Batch Job. This Job�s Task should fail. 
Your Goal
Your goal is to identify the Task failure using our internal tools. (i.e. confirmation of failure using our internal tools). To confirm, you will be required to take a snapshot of the failure identified in KUSTO and Azure Batch Diagnostics tool. The goal is to use our internal tools to identify the Task failure. These images should include timestamps and the failure status.
Proof of Solution
1.	Provide a screen capture of KUSTO:  once you have found the error, highlighting the relevant indicators of the Task failure. KUSTO download:

Redmond mirror	 http://kusto-us/ke/Kusto.Explorer.application
ILDC mirror	 http://kusto/ke/Kusto.Explorer.aapplication 

2.	Provide a screen capture of the AzureBatchDiagnostics: https://azurebatchdiagnostics.azurewebsites.net/. Once you have found the error. Again, highlight the relevant indicators of the Task failure
3.	Bonus: Explain what the next steps in troubleshooting should be.
