@echo off
cls
set mydate=%date:~10,4%%date:~7,2%%date:~4,2%
echo.
for %%a in (*.mkv) do (
    for /f %%b in ('mkvmerge -J "%%a" ^| find /c /i "commentary"') do (
        if [%%b]==[0] (
            echo "%%a" has no Commentary to remove
        ) else (
            echo.
            echo "%%a" has Commentary to remove
            mkvmerge --priority higher -q -o "%%~dpna.NoComments%%~xa" --audio-tracks 1 --no-subtitles "%%a"
            if errorlevel 1 (
			    if not exist "%USERPROFILE%\Desktop\PlexErrors" mkdir "%USERPROFILE%\Desktop\PlexErrors"
                echo Warnings/errors generated during remuxing, original file not deleted > "%USERPROFILE%\Desktop\PlexErrors\%%a_CommentaryError_%mydate%.txt"
            ) else (
				del /f "%%a"
                echo Successfully remuxed to "%%~dpna.NoComments%%~xa", original file deleted
            )
            echo.
        )
    )
)