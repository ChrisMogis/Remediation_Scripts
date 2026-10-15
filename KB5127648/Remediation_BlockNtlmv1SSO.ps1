$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$ValueName    = "BlockNtlmv1SSO"
$DesiredValue = 0

try {
    # Créer la clé si elle n'existe pas
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force -ErrorAction Stop |
            Out-Null
    }

    # Créer ou corriger la valeur DWORD
    New-ItemProperty `
        -LiteralPath $RegistryPath `
        -Name $ValueName `
        -Value $DesiredValue `
        -PropertyType DWord `
        -Force `
        -ErrorAction Stop | Out-Null

    # Vérifier la remédiation
    $Key = Get-Item -LiteralPath $RegistryPath -ErrorAction Stop
    $FinalValue = Get-ItemPropertyValue `
        -LiteralPath $RegistryPath `
        -Name $ValueName `
        -ErrorAction Stop
    $FinalType = $Key.GetValueKind($ValueName)

    if ($FinalValue -eq 0 -and
        $FinalType -eq [Microsoft.Win32.RegistryValueKind]::DWord) {
        Write-Output "SUCCÈS : BlockNtlmv1SSO = 0 (REG_DWORD)."
        exit 0
    }

    throw "La vérification après remédiation a échoué."
}
catch {
    Write-Output "ÉCHEC : $($_.Exception.Message)"
    exit 1
}
