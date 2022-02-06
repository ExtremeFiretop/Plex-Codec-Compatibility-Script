# Plex-Codec-Compatibility-Convert-Script

1. Download Prerequisites: MKVToolNix (https://mkvtoolnix.download/downloads.html#windows) and ffmpeg (https://github.com/BtbN/FFmpeg-Builds/releases)
2. Install MKVToolNix first (Follow the normal installation process.)
3. Add the new location: "C:\Program Files\MKVToolNix" in your "User" and "System" variables by going to "View Advanced System Settings" and selecting "Environment Variable" (Win10)
4. Place the "ffmpeg.exe" in the "tools" directory for MKVToolNix (i.e: C:\Program Files\MKVToolNix\tools\ffmpeg.exe)
5. Create a new directory in: "C:\Program Files\MKVToolNix\" called: "Custom Scripts" (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
6. Place the Powershell .ps1 script file in the "Custom Scripts" directory you just created.
7. Place all the relevant .bat files in the same directory. (i.e: C:\Program Files\MKVToolNix\Custom Scripts)
8. Import the .xml Task into Task scheduler and adjust as desired.
9. Profit? Every day it will now check media in the off hours and convert incompatible codecs and remove subtitles and remove commentary tracks or extra languages, etc.
