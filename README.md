# Plex-Codec-Compatibility-Script

1. Download Prerequisites: MKVToolNix (https://mkvtoolnix.download/downloads.html#windows) and ffmpeg (https://github.com/BtbN/FFmpeg-Builds/releases)
2. Install MKVToolNix first (Follow the normal installation process.)
3. Add the following directories in your "User" and "System" PATH variables by going to "View Advanced System Settings" and selecting "Environment Variables" (Win10)
    a. "C:\Program Files\MKVToolNix"
    b. "C:\Program Files\MKVToolNix\tools"
5. Place the "ffmpeg.exe" in the "tools" directory for MKVToolNix (i.e: C:\Program Files\MKVToolNix\tools\ffmpeg.exe)
6. Create a new directory in: "C:\Program Files\MKVToolNix\" called: "Custom Scripts" (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
7. Place the Powershell .ps1 script file in the "Custom Scripts" directory you just created.
8. Modify the Powershell File (.ps1) with your movie/plex media directory location to check and convert.
9. Place all the relevant .bat files in the same directory. (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
10. Import the .xml Task into Task scheduler and adjust as desired.
11. Profit? 
-Every night it will now check any media downloaded that day in the off hours and convert/reorder incompatible codecs (DTS and TrueHD) and remove subtitles and remove commentary tracks or extra languages, etc.
