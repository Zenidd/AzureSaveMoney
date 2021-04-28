function global:Get-AzSMExpiredWebhooks {

    <#
        .SYNOPSIS
        List expired Webhooks in a subscription.
        .DESCRIPTION
        List expired Webhooks in a subscription.
        .PARAMETER SubscriptionID
        Azure subscription ID in the format, 00000000-0000-0000-0000-000000000000
        .PARAMETER ResourceGroupName
        A single Azure resource group name to scope query to
        .OUTPUTS
        Microsoft.Azure.Commands.Automation.Model.Webhook
        .EXAMPLE
        Get-AzSMExpiredWebhooks -SubscriptionID 00000000-0000-0000-0000-000000000000
        .EXAMPLE
        Get-AzSMExpiredWebhooks -SubscriptionID 00000000-0000-0000-0000-000000000000|Remove-AzAutomationWebhook
        .NOTES
        * CAN be piped to Remove-AzAutomationWebhook.
        .LINK
    #>
  
    [CmdletBinding(
        DefaultParameterSetName='SubscriptionID',
        ConfirmImpact='Low'
    )]
  
    param(
      [Parameter(Mandatory=$true)][string] $SubscriptionID,
      [Parameter(Mandatory=$false)][string] $ResourceGroupName
    )
  
    $null = Set-AzContext -SubscriptionId $SubscriptionID
    Write-Debug ('Subscription ID: {0}' -f $SubscriptionID)
  
    $expiredWebhks = New-Object System.Collections.ArrayList

    if ($ResourceGroupName.Length -gt 0) {
      $automationaccounts = Get-AzAutomationAccount -ResourceGroupName $ResourceGroupName
    } else {
      $automationaccounts = Get-AzAutomationAccount
    }

    $automationaccounts|ForEach-Object {
      $webhks=Get-AzAutomationWebhook -ResourceGroupName $_.ResourceGroupName -AutomationAccountName $_.AutomationAccountName|Where-Object {$_.ExpiryTime -lt (Get-Date)}
      $webhks|ForEach-Object {
        $null = $expiredWebhks.Add($_)
      }
    }
  
    Return $expiredWebhks
  }
  Export-ModuleMember -Function Get-AzSMExpiredWebhooks