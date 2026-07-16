// AzureBatch.L200.Troubleshooting.1 — one-click assessment environment.
//
// Deploying this template stands up the entire scenario automatically: a Batch
// account + Storage account, a compute pool, and a job whose tasks run and
// COMPLETE BUT REPORT A FAILURE (exit code -3). No console app, no manual steps.
// The engineer's job is to identify the task failure using Kusto / Azure Batch
// diagnostics.
//
// The failing behaviour is contained in a task payload (labtask/assessment-task.cmd)
// downloaded to the node as a resource file, so the task command line stays
// innocuous — the exit code must be discovered through telemetry.

@description('Prefix for generated resource names.')
param namePrefix string = 'batlab01'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Raw base URL of this repo (where labtask/assessment-task.cmd is hosted).')
param repoRawBase string = 'https://raw.githubusercontent.com/Walter-B-Jr/Azure_Batch_Assessment_01/master'

var suffix = uniqueString(resourceGroup().id)
var storageAccountName = toLower('${namePrefix}${suffix}')
var batchAccountName = toLower('${namePrefix}ba${suffix}')
var poolId = 'batch_assessment_01_pool'
var jobId = 'batch_assessment_01_job'
var contributorRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: length(storageAccountName) > 24 ? substring(storageAccountName, 0, 24) : storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource batch 'Microsoft.Batch/batchAccounts@2024-07-01' = {
  name: length(batchAccountName) > 24 ? substring(batchAccountName, 0, 24) : batchAccountName
  location: location
  properties: {
    autoStorage: {
      storageAccountId: storage.id
    }
    poolAllocationMode: 'BatchService'
    publicNetworkAccess: 'Enabled'
  }
}

resource pool 'Microsoft.Batch/batchAccounts/pools@2024-07-01' = {
  parent: batch
  name: poolId
  properties: {
    vmSize: 'STANDARD_D1_V2'
    deploymentConfiguration: {
      virtualMachineConfiguration: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2019-datacenter'
          version: 'latest'
        }
        nodeAgentSkuId: 'batch.node.windows amd64'
      }
    }
    scaleSettings: {
      fixedScale: {
        targetDedicatedNodes: 1
        resizeTimeout: 'PT15M'
      }
    }
  }
}

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${namePrefix}-seed-id'
  location: location
}

resource batchContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(batch.id, uami.id, contributorRole)
  scope: batch
  properties: {
    roleDefinitionId: contributorRole
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Bash executed in an azure-cli container to create the job + failing tasks
// (jobs/tasks are Batch data-plane objects and cannot be declared in ARM).
var seedScript = '''
set -e
echo "Authenticating with managed identity..."
for a in 1 2 3 4 5 6; do
  az login --identity -u "$UAMI_CLIENT_ID" -o none && break
  echo "  az login retry $a"; sleep 15
done
echo "Logging in to Batch account (shared key)..."
for a in 1 2 3 4 5 6; do
  az batch account login -g "$RG" -n "$BATCH_NAME" --shared-key-auth -o none && break
  echo "  batch login retry $a (waiting for role propagation)"; sleep 20
done
echo "Creating job $JOB_ID..."
az batch job create --id "$JOB_ID" --pool-id "$POOL_ID" -o none
echo "Creating failing tasks..."
for i in 1 2 3; do
cat > /tmp/task.json <<JSON
{"id":"assessmentTestTask_$i","commandLine":"cmd /c assessment-task.cmd taskdata$i.txt","resourceFiles":[{"httpUrl":"$RAW_BASE/labtask/assessment-task.cmd","filePath":"assessment-task.cmd"}]}
JSON
  az batch task create --job-id "$JOB_ID" --json-file /tmp/task.json -o none
  echo "  created assessmentTestTask_$i"
done
echo "SEED_DONE"
'''

resource seed 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: '${namePrefix}-seed'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uami.id}': {}
    }
  }
  properties: {
    sku: 'Standard'
    osType: 'Linux'
    restartPolicy: 'Never'
    containers: [
      {
        name: 'seed'
        properties: {
          image: 'mcr.microsoft.com/azure-cli:2.61.0'
          resources: {
            requests: {
              cpu: 1
              memoryInGB: json('1.5')
            }
          }
          environmentVariables: [
            { name: 'UAMI_CLIENT_ID', value: uami.properties.clientId }
            { name: 'RG', value: resourceGroup().name }
            { name: 'BATCH_NAME', value: batch.name }
            { name: 'POOL_ID', value: poolId }
            { name: 'JOB_ID', value: jobId }
            { name: 'RAW_BASE', value: repoRawBase }
          ]
          command: [
            '/bin/bash'
            '-c'
            'echo ${base64(seedScript)} | base64 -d | tr -d \'\\r\' | bash'
          ]
        }
      }
    ]
  }
  dependsOn: [
    pool
    batchContributor
  ]
}

output batchAccountName string = batch.name
output batchAccountUrl string = 'https://${batch.properties.accountEndpoint}'
output storageAccountName string = storage.name
output poolId string = poolId
output jobId string = jobId
