<#
.DESCRIPTION
    Detects whether the Windows registry setting BlockNtlmv1SSO is configured
    to disable NTLMv1 SSO in the MSV1_0 registry key.

    The script checks the existence of the registry key, validates the value type,
    and ensures the value is set to 0 (REG_DWORD).

.NOTES
    Version       : 1.0
    Author        : Christopher Mogis
    Creation Date : 15/10/2026
    Modification  : 15/10/2026
#>

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$ValueName    = "BlockNtlmv1SSO"
$DesiredValue = 0

try {
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        Write-Output "NOT COMPLIANT: the registry key is missing."
        exit 1
    }

    $Key = Get-Item -LiteralPath $RegistryPath -ErrorAction Stop

    if ($Key.GetValueKind($ValueName) -ne
        [Microsoft.Win32.RegistryValueKind]::DWord) {
        Write-Output "NOT COMPLIANT: the value is missing or its type is incorrect."
        exit 1
    }

    $CurrentValue = Get-ItemPropertyValue `
        -LiteralPath $RegistryPath `
        -Name $ValueName `
        -ErrorAction Stop

    if ($CurrentValue -ne $DesiredValue) {
        Write-Output "NOT COMPLIANT: current value = $CurrentValue; expected value = 0."
        exit 1
    }

    Write-Output "COMPLIANT: BlockNtlmv1SSO = 0 (REG_DWORD)."
    exit 0
}
catch {
    Write-Output "NOT COMPLIANT: registry read error. $($_.Exception.Message)"
    exit 1
}
