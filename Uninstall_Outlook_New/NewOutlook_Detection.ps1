<#
Version: 1.0
Author: Christopher Mogis
Description : 
#> 

if (Get-AppxPackage -Name *OutlookForWindows*) {
write-host "Microsoft Outlook (New) found."

exit 1
}

else {
write-host "Microsoft Outlook (New) not found."

exit 0
}
