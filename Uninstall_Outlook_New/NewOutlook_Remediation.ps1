<#
Version: 1.0
Author: Christopher Mogis
Description : Uninstall Outlook (New) and add registry key for hide New Outlook toggle in Outlook Desktop
#> 

try{
    #Uninstall Microsoft Outlook New
    Get-AppxPackage -Name *OutlookForWindows* | Remove-AppxPackage -ErrorAction stop
    Write-Host "Microsoft Outlook (New) successfully removed."

    #Disable New Outlook Toggle
    New-ItemProperty -Path "HKCU:\\SOFTWARE\\Policies\\Microsoft\\Office\\16.0\\Outlook\\Options\\General" -Name "HideNewOutlookToggle" -Value "1"  -PropertyType "ExpandString"

}
catch{
    Write-Error "Error removing Microsoft Outlook (New)."
}