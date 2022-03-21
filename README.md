
# Private Azure Container Apps (Microsoft.App) and Private DNS Zone

```bash
az group create --location eastus --name rb-container-apps
az configure --defaults group=rb-container-apps
cd deploy-env
#az deployment group what-if --template-file .\main.bicep --parameters prefixName=rb location=eastus
az deployment group create --template-file .\main.bicep --parameters prefixName=rb location=eastus
cd ..\deploy-app
#az deployment group what-if --template-file .\main.bicep --parameters environmentName=acaenv-rb vnetName=vnet appName=myapp1 containerImage=nginx containerPort=80
az deployment group create --template-file .\main.bicep --parameters environmentName=acaenv-rb vnetName=vnet appName=myapp1 containerImage=nginx containerPort=80
```
