
#fuction to collect bearer token to authenticate the rest API.
function getauthheader {
    $azContext = Get-AzContext
    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRm
    ProfileProvider]::Instance.Profile
    $profileClient = New-Object -
    TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -
    ArgumentList ($azProfile)
    $token = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
    $authHeader = @{
        'Content-Type'='application/json'
        'Authorization'='Bearer ' + $token.AccessToken
    }
    return $authHeader
}

#fuction for the REST API callto query Metadata of a Virtual Machine instance in Azure.
function querymetadata {
    param(
        $subscritionId,
        $resourceGroup,
        $vmName
    )
    if($subscritionId -and $resourceGroup -and $vmName){
        $restUri = "https://management.azure.com/subscriptions/$subscritionId/resourceGroups/$resourceGroup/providers/Microsoft.Compute/virtualMachines/$vmName?api-version=2021-03-01"
        $authHeader = getauthheader
        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $authHeader
        return $response.value
    }
}

$subscriptionId = "xxxx"
$TenantId = "xxxx"

try{
    #connect to the Azure cloud account
    Connect-AzAccount -credential -TenantId "xxx" -servicePrincipal -subscriptionId "xxx" -ErrorAction Stop | Out-Null
}catch{
    throw "Error authenticating to Azure AD: $($_.exception.message)."
}

#Please pass subscriptionId, resource group and vm name here to query metadat of the VM.
$metadata = querymetadata -subscritionId $subscriptionId-resourceGroup "test_rg" -vmName "vm" 
if($metadata){
    write-ouput $metadata   
}