@echo off
cls
set mydate=%date:~10,4%%date:~7,2%%date:~4,2%
echo.
for %%a in (*.mkv) do (
    for /f %%b in ('mkvmerge -i "%%a" ^| find /c /i "TrueHD"') do (
        if [%%b]==[0] (
            echo "%%a" has no TrueHD audio to convert
        ) else (
		    echo.
            echo "%%a" has TrueHD audio to convert
            ffmpeg -loglevel error -nostats -fflags +genpts -i "%%a" -map 0:v:0 -c:v:0 copy -map 0:a -c:a copy -disposition:a:0 default -disposition:a:1 0 -disposition:a:2 0 -disposition:a:3 0 -disposition:a:4 0 -map 0:a:0 -c:a:0 ac3 -metadata:s:a:0 title="Transcoded Compatibility Track" "%%~dpna.ACConverted%%~xa"
            if errorlevel 1 (
			    if not exist "%USERPROFILE%\Desktop\PlexErrors" mkdir "%USERPROFILE%\Desktop\PlexErrors"
                echo Warnings/errors generated during remuxing, original file not deleted > "%USERPROFILE%\Desktop\PlexErrors\%%a_ConvertError_%mydate%.txt"
            ) else (
			    del /f "%%a"
                echo Successfully remuxed to "%%~dpna.ACConverted%%~xa", original file deleted
            )
            echo.
        )
    )
)
