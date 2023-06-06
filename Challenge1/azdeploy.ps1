$subscriptionId = "xxxx"
$TenantId = "xxxx"

try{
    #connect to the Azure cloud account
    Connect-AzAccount -credential -TenantId "xxx" -servicePrincipal -subscriptionId "xxx" -ErrorAction Stop | Out-Null
}catch{
    throw "Error authenticating to Azure AD: $($_.exception.message)."
}
$rg = New-AzResourceGroup -Name 3tier-architecture -Location eastus
New-AzResourceGroupDeployment -ResourceGroupName $rg.name -TemplateFile ./azuredeploy.json -TemplateParameterFile ./azuredeploy.parameters.json