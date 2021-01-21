function global:Get-AzSMUnusedNSGs {

    <#
        .SYNOPSIS
        Lists unused NSGs in a subscription.
        .DESCRIPTION
        Lists unused NSGs in a subscription.
        .PARAMETER SubscriptionID
        Azure subscription ID in the format, 00000000-0000-0000-0000-000000000000
        .PARAMETER ResourceGroupName
        A single Azure resource group name to scope query to
        .OUTPUTS
        Microsoft.Azure.Commands.Network.Models.PSNetworkSecurityGroup
        .EXAMPLE
        Get-AzSMUnusedNSGs -Subscription 00000000-0000-0000-0000-000000000000
        Get a list of unused network security groups in a subscription.
        .EXAMPLE
        Get-AzSMUnusedNSGs -Subscription 00000000-0000-0000-0000-000000000000 | Remove-AzNetworkSecurityGroup
        Remove unused network security groups in a subscription with confirmation.
        .EXAMPLE
        Get-AzSMUnusedNSGs -Subscription 00000000-0000-0000-0000-000000000000 | Remove-AzNetworkSecurityGroup -force
        Remove unused network security groups in a subscription without confirmation.
        .NOTES
        * CAN be piped to Remove-AzNetworkSecurityGroup.
        * When piping to remove resources, include the -force parameter to supress prompts.
        .LINK
    #>
  
    [CmdletBinding(
        DefaultParameterSetName='SubscriptionID',
        ConfirmImpact='low'
    )]
  
    param(
      [Parameter(Mandatory=$true)][string] $SubscriptionID,
      [Parameter(Mandatory=$true)][string] $ResourceGroupName
    )
  
    $null = Set-AzContext -SubscriptionId $SubscriptionID
    Write-Debug ('Subscription: {0}' -f $SubscriptionID)

    if ($ResourceGroupName.Length -gt 0) {
      $nsg=Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName|Where-Object{!$_.NetworkInterfaces -and !$_.Subnets}
    } else {
      $nsg=Get-AzNetworkSecurityGroup|Where-Object{!$_.NetworkInterfaces -and !$_.Subnets}
    }

    Return $nsg
}
Export-ModuleMember -Function Get-AzSMUnusedNSGs