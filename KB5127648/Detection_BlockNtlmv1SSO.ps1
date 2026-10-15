$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$ValueName    = "BlockNtlmv1SSO"
$DesiredValue = 0

try {
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        Write-Output "NON CONFORME : la clé de registre est absente."
        exit 1
    }

    $Key = Get-Item -LiteralPath $RegistryPath -ErrorAction Stop

    if ($Key.GetValueKind($ValueName) -ne
        [Microsoft.Win32.RegistryValueKind]::DWord) {
        Write-Output "NON CONFORME : la valeur est absente ou son type est incorrect."
        exit 1
    }

    $CurrentValue = Get-ItemPropertyValue `
        -LiteralPath $RegistryPath `
        -Name $ValueName `
        -ErrorAction Stop

    if ($CurrentValue -ne $DesiredValue) {
        Write-Output "NON CONFORME : valeur actuelle = $CurrentValue ; valeur attendue = 0."
        exit 1
    }

    Write-Output "CONFORME : BlockNtlmv1SSO = 0 (REG_DWORD)."
    exit 0
}
catch {
    Write-Output "NON CONFORME : erreur de lecture du registre. $($_.Exception.Message)"
    exit 1
}
