$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$ValueName    = "BlockNtlmv1SSO"
$DesiredValue = 0

try {
    # Create the key if it does not exist
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force -ErrorAction Stop |
            Out-Null
    }

    # Create or fix the DWORD value
    New-ItemProperty `
        -LiteralPath $RegistryPath `
        -Name $ValueName `
        -Value $DesiredValue `
        -PropertyType DWord `
        -Force `
        -ErrorAction Stop | Out-Null

    # Verify the remediation
    $Key = Get-Item -LiteralPath $RegistryPath -ErrorAction Stop
    $FinalValue = Get-ItemPropertyValue `
        -LiteralPath $RegistryPath `
        -Name $ValueName `
        -ErrorAction Stop
    $FinalType = $Key.GetValueKind($ValueName)

    if ($FinalValue -eq 0 -and
        $FinalType -eq [Microsoft.Win32.RegistryValueKind]::DWord) {
        Write-Output "SUCCESS: BlockNtlmv1SSO = 0 (REG_DWORD)."
        exit 0
    }

    throw "Post-remediation verification failed."
}
catch {
    Write-Output "FAILURE: $($_.Exception.Message)"
    exit 1
}
