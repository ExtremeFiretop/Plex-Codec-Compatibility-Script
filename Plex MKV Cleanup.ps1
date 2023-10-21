##Script Locations##
$CustomScripts = "C:\Program Files\MKVToolNix\Custom Scripts"
##Root of Movies Directory##
$MoviesD = "M:\Movies\"
##Same as above, but add secondary backslashes to the path##
$MoviesDC = "M:\\Movies\\"


##MKV Audio Track Values to Search in Files##
$Track2A= "Track ID 2: audio"
###DTS Values###
$Track1DTS = "Track ID 1: audio (DTS)"
$Track1DTSHD = "Track ID 1: audio (DTS-HD Master Audio)"
$Track2DTS = "Track ID 2: audio (DTS)"
$Track2DTSHD = "Track ID 2: audio (DTS-HD Master Audio)"
###TrueHD Values###
$Track1True = "Track ID 1: audio (TrueHD)"
$Track1TrueA = "Track ID 1: audio (TrueHD Atmos)"
$Track2True = "Track ID 2: audio (TrueHD)"
$Track2TrueA = "Track ID 2: audio (TrueHD Atmos)"

function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "MKV Cleanup"
    $Toast.Group = "MKV Cleanup"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddHours(8)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("MKV Cleanup")
    $Notifier.Show($Toast);
}

##Commentary Track Search & Remove Code##
Set-Location -Path $MoviesD
$oldvids = Get-ChildItem *.mkv -Recurse | sort Creationtime | select -last 8
foreach ($oldvid in $oldvids) {
$vidpath = mkvmerge.exe -J $oldvid | Select-String -SimpleMatch $MoviesDC | foreach{ $_.ToString().TrimStart() }
$Newestvidpath = $vidpath | Select-String -SimpleMatch $MoviesDC | foreach{$_ -replace '"file_name": "',"" }
$newVariable = Split-Path $Newestvidpath -Parent
Set-Location -Path "$newVariable"
$newvids = mkvmerge.exe -J $oldvid
    if($newvids -match "Commentary")
    {& $CustomScripts\DelMKVComment.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.NoComments.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".NoComments", "")
    Show-Notification "Removed Commentary Tracks!" "Removed Commentary Tracks Detected from $newVariable" }
    }
}


##DTS Search and Reorder & Replace Code##
Set-Location -Path $MoviesD
$oldvids = Get-ChildItem *.mkv -Recurse | sort Creationtime | select -last 8
foreach ($oldvid in $oldvids) {
$vidpath = mkvmerge.exe -i $oldvid | Select-String -SimpleMatch $MoviesD | foreach{ $_.ToString().TrimStart("File '") }
$newVariable = Split-Path $vidpath -Parent
Set-Location -Path "$newVariable"
$newvids = mkvmerge.exe -i $oldvid

#Reorder if DTS is first Audio track, and anything but DTS or TrueHD is the second audio track#
    if(($newvids -match [regex]::Escape($Track1DTS) -xor ($newvids -match [regex]::Escape($Track1DTSHD))) -and ($newvids -notmatch [regex]::Escape($Track2DTS) -xor ($newvids -match [regex]::Escape($Track2DTSHD))) -and ($newvids -notmatch [regex]::Escape($Track2True) -xor ($newvids -match [regex]::Escape($Track2TrueA))) -and ($newvids -match [regex]::Escape($Track2A)))
    {& $CustomScripts\DTSReorder.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.AudioTrackReordered.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".AudioTrackReordered", "") }
    Show-Notification "DTS Tracks Detected!" "Reordered DTS Tracks Detected from $newVariable" 
    continue
    }

#Convert if DTS is first Audio track, and DTS or TrueHD is the second audio track#
    if(($newvids -match [regex]::Escape($Track1DTS) -xor $newvids -match [regex]::Escape($Track1DTSHD)) -and ($newvids -match [regex]::Escape($Track2DTSHD) -xor $newvids -match [regex]::Escape($Track2DTS) -xor $newvids -match [regex]::Escape($Track2TrueA) -xor $newvids -match [regex]::Escape($Track2True)))
    {& $CustomScripts\DTSConvert.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.ACConverted.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".ACConverted", "") }
    Show-Notification "DTS Tracks Detected!" "Converted DTS Tracks Detected from $newVariable" 
    continue
    }

#Convert if DTS is the only Audio track#
    if(($newvids -match [regex]::Escape($Track1DTSHD) -xor $newvids -match [regex]::Escape($Track1DTS)) -and ($newvids -notmatch [regex]::Escape($Track2A)))
    {& $CustomScripts\DTSConvert.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.ACConverted.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".ACConverted", "") }
    Show-Notification "DTS Tracks Detected!" "Converted DTS Tracks Detected from $newVariable" 
    }
}


##TrueHD Search and Reorder & Replace Code##
Set-Location -Path $MoviesD
$oldvids = Get-ChildItem *.mkv -Recurse | sort Creationtime | select -last 8
foreach ($oldvid in $oldvids) {
$vidpath = mkvmerge.exe -i $oldvid | Select-String -SimpleMatch $MoviesD | foreach{ $_.ToString().TrimStart("File '") }
$newVariable = Split-Path $vidpath -Parent
Set-Location -Path "$newVariable"
$newvids = mkvmerge.exe -i $oldvid

#Reorder if TrueHD is first Audio track, and anything but DTS or TrueHD is the second audio track#
    if(($newvids -match [regex]::Escape($Track1True) -xor ($newvids -match [regex]::Escape($Track1TrueA))) -and ($newvids -notmatch [regex]::Escape($Track2True) -xor ($newvids -match [regex]::Escape($Track2TrueA))) -and ($newvids -notmatch [regex]::Escape($Track2DTS) -xor ($newvids -match [regex]::Escape($Track2DTSHD))) -and ($newvids -match [regex]::Escape($Track2A)))
    {& $CustomScripts\TrueHDTReorder.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.AudioTrackReordered.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".AudioTrackReordered", "") }
    Show-Notification "TrueHD Tracks Detected!" "Reordered TrueHD Tracks Detected from $newVariable" 
    continue
}

#Convert if TrueHD is first Audio track, and TrueHD or DTS is the second audio track#
    if(($newvids -match [regex]::Escape($Track1True) -xor $newvids -match [regex]::Escape($Track1TrueA)) -and ($newvids -match [regex]::Escape($Track2TrueA) -xor $newvids -match [regex]::Escape($Track2True) -xor $newvids -match [regex]::Escape($Track2DTS) -xor $newvids -match [regex]::Escape($Track2DTSHD)))
    {& $CustomScripts\TrueHDConvert.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.ACConverted.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".ACConverted", "") }
    Show-Notification "TrueHD Tracks Detected!" "Converted TrueHD Tracks Detected from $newVariable" 
    continue
}

#Convert if TrueHD is the only Audio track#
    if(($newvids -match [regex]::Escape($Track1True) -xor $newvids -match [regex]::Escape($Track1TrueA)) -and ($newvids -notmatch [regex]::Escape($Track2A)))
    {& $CustomScripts\TrueHDConvert.bat
    Start-Sleep -Milliseconds 500
    get-childitem -Path * *.ACConverted.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".ACConverted", "") }
    Show-Notification "TrueHD Tracks Detected!" "Converted TrueHD Tracks Detected from $newVariable" 
    }
}


##Subtitle and Search & Remove Code##
#Set-Location -Path $MoviesD
#$oldvids = Get-ChildItem *.mkv -Recurse | sort Creationtime | select -last 8
#foreach ($oldvid in $oldvids) {
#$vidpath = mkvmerge.exe -i $oldvid | Select-String -SimpleMatch $MoviesD | foreach{ $_.ToString().TrimStart("File '") }
#$newVariable = Split-Path $vidpath -Parent
#Set-Location -Path "$newVariable"
#$newvids = mkvmerge.exe -i $oldvid
#    if($newvids -match "subtitles")
#    {& $CustomScripts\DelMKVSubs.bat
#    Start-Sleep -Milliseconds 500
#    get-childitem -Path * *.NoSubs.mkv -Recurse | foreach { rename-item $_ $_.Name.Replace(".NoSubs", "") }
#    Show-Notification "Subtitle Tracks Detected!" "Removed Subtitle Tracks Detected from $newVariable" 
#    }
# }

exit
