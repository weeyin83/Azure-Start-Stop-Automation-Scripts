
# Authenticate with your Automation Account
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationID $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint



($rmvms=Get-AzurermVM) > 0

        # Stop all running VMs in ResourceGroup
    foreach ($vm in $rmvms)
        {   
            $vmStatus = Get-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
            # Stop running VMs
            if($vmStatus.Statuses | where Code -match "PowerState/running")  
            {
                Write-Output "Stopping VM [$($vm.Name)]"
                $vm | Stop-AzureRmVM -Force
            }
            else {
                Write-Output "VM [$($vm.Name)] is already deallocated!"
            }
        }
