# Plex-Codec-Compatibility-Script

1. Download Prerequisites: MKVToolNix (https://mkvtoolnix.download/downloads.html#windows) and ffmpeg (https://github.com/BtbN/FFmpeg-Builds/releases)
2. Install MKVToolNix first (Follow the normal installation process.)
3. Add the new location: "C:\Program Files\MKVToolNix" in your "User" and "System" variables by going to "View Advanced System Settings" and selecting "Environment Variable" (Win10)
4. Place the "ffmpeg.exe" in the "tools" directory for MKVToolNix (i.e: C:\Program Files\MKVToolNix\tools\ffmpeg.exe)
5. Create a new directory in: "C:\Program Files\MKVToolNix\" called: "Custom Scripts" (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
6. Place the Powershell .ps1 script file in the "Custom Scripts" directory you just created.
7. Modify the Powershell File (.ps1) with your movie/video directory location to check and convert.
8. Place all the relevant .bat files in the same directory. (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
9. Import the .xml Task into Task scheduler and adjust as desired.
10. Profit? 
-Every night it will now check any media downloaded that day in the off hours and convert/reorder incompatible codecs (DTS and TrueHD) and remove subtitles and remove commentary tracks or extra languages, etc.
