# Plex-Codec-Compatibility-Script

1. Download Prerequisites: MKVToolNix (https://mkvtoolnix.download/downloads.html#windows) and ffmpeg (https://github.com/BtbN/FFmpeg-Builds/releases)
2. Install MKVToolNix first (Follow the normal installation process.)
3. Add the 2 following directories in your "User" and "System" PATH variables by going to "View Advanced System Settings" and selecting "Environment Variables" (Win 10)
    a. "C:\Program Files\MKVToolNix"
    b. "C:\Program Files\MKVToolNix\tools"
5. Place the "ffmpeg.exe" in the "tools" directory for MKVToolNix (i.e: C:\Program Files\MKVToolNix\tools\ffmpeg.exe)
6. Create a new directory in: "C:\Program Files\MKVToolNix\" called: "Custom Scripts" (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
7. Place the Powershell .ps1 script file in the "Custom Scripts" directory you just created.
8. Modify the Powershell File (.ps1) with your movie/plex media directory location to check and convert.
9. Place all the relevant .bat files in the same directory. (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
10. Import the .xml Task into Task scheduler and adjust as desired.
11. Profit?

# Setting Up Audit Policy for Task Schedule:

1. Right click your Destination Movie folder for Radarr.
2. Click "Properties" from the menu, and select the "Security" Tab from the properties window.
3. Click on "Advanced" and select the "Audit" Tab.
4. Click "Add" and then click "Select a Principal".
5. Enter "Local Service" or "System".
-Note: Depending which context the Radarr service is running, this can be checked in services.msc or Task Manager.
6. Select "Type: Success" and select "Applies to: Subfolders and files only".
7. Click "Show Advanced Permissions" and ONLY select (Check) "Create folders / append data" and NOTHING ELSE.
8. Select (Check) the option for: "Only apply these auditing settings to objects and/or contains within this container".
9. Select Okay, and Apply and close the window.

-The task scheduler has 2 triggers, one to run every night to check any media downloaded that day in the off hours, the other is to do it on every import of new media, and convert incompatible codecs (DTS and TrueHD) and remove subtitles and remove commentary tracks or extra languages, etc.
