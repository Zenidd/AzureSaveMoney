function global:Get-AzSMDisabledServiceBusQueues {

    <#
        .SYNOPSIS
        Lists disabled Service Bus Queues in a subscription.
        .DESCRIPTION
        Lists disabled Service Bus Queues in a subscription.
        .PARAMETER SubscriptionID
        Azure subscription ID in the format, 00000000-0000-0000-0000-000000000000
        .PARAMETER ResourceGroupName
        A single Azure resource group name to scope query to
        .OUTPUTS
        Microsoft.Azure.Commands.ServiceBus.Models.PSQueueAttributes
        .EXAMPLE
        Get-AzSMDisabledServiceBusQueues -Subscription 00000000-0000-0000-0000-000000000000 -ResourceGroupName RG1
        Get a list of disabled Service Bus Queues in a resource group.
        .EXAMPLE
        Get-AzSMDisabledServiceBusQueues -Subscription 00000000-0000-0000-0000-000000000000|Remove-AzServiceBusQueue
        Removes all disabled Service Bus Queues in a subscription with confirmation.
        .EXAMPLE
        Get-AzSMDisabledServiceBusQueues -Subscription 00000000-0000-0000-0000-000000000000|Remove-AzServiceBusQueue -force
        Removes all disabled Service Bus Queues in a subscription without confirmation.
        .NOTES
        * CAN be piped to Remove-AzServiceBusQueue.
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
      $rgs=Get-AzResourceGroup -Name $ResourceGroupName
    } else {
      $rgs=Get-AzResourceGroup
    }

    $q=$rgs|Get-AzServiceBusNamespace|ForEach-Object {Get-AzServiceBusQueue -ResourceGroupName $_.ResourceGroup -Namespace $_.Name|Where-Object{$_.Status -eq "Disabled"}}
    
    Return $q
 }
 Export-ModuleMember -Function Get-AzSMDisabledServiceBusQueues