# Azure Monitoring, Backup and Deployment Automation

Infrastructure-as-code sample deploying a small App Service environment, telemetry workspace, alert rules, and a protected Azure Files share.

## Components
- Bicep templates for App Service, Storage Account, and Log Analytics
- ARM template export for side-by-side template comparison
- GitHub Actions validation and deployment workflow for dev and test
- Azure Monitor metric alerts and a KQL workbook/query set
- Azure Backup policy for an Azure Files share with 30-day retention
- PowerShell restore verification script and operational SOP

## Deploy
Configure GitHub OIDC federation for the repository and set `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID` as repository variables. The workflow uses federated login; no client secret is stored in Git. Deploy with `az deployment group create` or run the GitHub Actions workflow.

The templates are examples and require a pre-created resource group and correctly configured federated identity. Review costs, region availability, naming rules, and backup support before applying.

## Measurement notes
The project brief describes five alert rules, detection under five minutes during a load test, and three checksum-verified restore tests. Re-run those tests in your own Azure subscription before treating the figures as measured outcomes.

## Safety and cleanup
- Use a dedicated test resource group and least-privilege federated identity.
- Do not use storage account keys in GitHub Actions; prefer managed identity or OIDC.
- Backups, Log Analytics ingestion, App Service plans, and public endpoints can incur charges.
- Delete lab resources only after confirming that backup retention and evidence requirements are satisfied.
