@echo off
cls
set mydate=%date:~10,4%%date:~7,2%%date:~4,2%
echo.
for %%a in (*.mkv) do (
    for /f %%b in ('mkvmerge -i "%%a" ^| find /c /i "subtitles"') do (
        if [%%b]==[0] (
            echo "%%a" has no Subtitles to remove
        ) else (
            echo.
            echo "%%a" has Subtitles to remove
            mkvmerge --priority higher -q -o "%%~dpna.NoSubs%%~xa" --audio-tracks und,eng --no-subtitles "%%a"
            if errorlevel 1 (
			    if not exist "%USERPROFILE%\Desktop\PlexErrors" mkdir "%USERPROFILE%\Desktop\PlexErrors"
                echo Warnings/errors generated during remuxing, original file not deleted > "%USERPROFILE%\Desktop\PlexErrors\%%a_SubtitleError_%mydate%.txt"
            ) else (
			    del /f "%%a"
                echo Successfully remuxed to "%%~dpna.NoSubs%%~xa", original file deleted
            )
            echo.
        )
    )
)