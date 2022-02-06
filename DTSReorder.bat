@echo off
cls
set mydate=%date:~10,4%%date:~7,2%%date:~4,2%
echo.
for %%a in (*.mkv) do (
    for /f %%b in ('mkvmerge -i "%%a" ^| find /c /i "DTS"') do (
        if [%%b]==[0] (
            echo "%%a" has no DTS audio to re-order
        ) else (
		    echo.
            echo "%%a" has DTS audio to re-order
            mkvmerge --priority higher -q -o "%%~dpna.AudioTrackReordered%%~xa" --audio-tracks und,eng --default-track 1:no --default-track 2:yes --no-subtitles "%%a" --track-order 0:0,0:2,0:1
            if errorlevel 1 (
			    if not exist "%USERPROFILE%\Desktop\PlexErrors" mkdir "%USERPROFILE%\Desktop\PlexErrors"
                echo Warnings/errors generated during remuxing, original file not deleted > "%USERPROFILE%\Desktop\PlexErrors\%%a_ReorderError_%mydate%.txt"
            ) else (
			    del /f "%%a"
                echo Successfully remuxed to "%%~dpna.AudioTrackReordered%%~xa", original file deleted
            )
            echo.
        )
    )
)