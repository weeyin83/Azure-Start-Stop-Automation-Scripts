# Authenticate with your Automation Account
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationID $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

($rmvms=Get-AzurermVM) > 0


        
        # Start all running VMs in ResourceGroup
    foreach ($vm in $rmvms)
        {   
            $vmStatus = Get-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
            # Start running VMs
            if($vmStatus.Statuses | where Code -match "PowerState/deallocated")  
            {
                Write-Output "Starting VM [$($vm.Name)]"
                $vm | Start-AzureRmVM
            }
            else {
                Write-Output "VM [$($vm.Name)] is already running!"
            }
        }
