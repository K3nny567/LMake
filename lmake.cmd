@Echo Off
pushd "%~dp0"
setlocal EnableExtensions EnableDelayedExpansion
set _title_prefix=LMake: LonaRPG Mod Build System
set _title_sep= - 
title !_title_prefix!

:argparse
Call :config
if [%~1] EQU [build] if /I [%~2] == [all] (
  Call :buildtar !_targets!
) else (
  for %%T in (!_targets!) do (
    if /I [%~2] == [%%~T] Call :buildtar %%~T
  )
)
if /I [%~1] EQU [help] goto :help
if /I [%~1] EQU [update] Call :update
if /I [%~1] EQU [dist] Call :buildzip
if /I [%~1] EQU [release] Call :release
if /I [%~1] EQU [clean] Call :clean
if [%~1] EQU [] goto :help
goto :end

:pause
echo/
echo Press any key to exit. . .
>nul pause
echo.
goto :EOF

:config
for /F "usebackq delims=; tokens=1 eol=;" %%A in ("%~dpn0.cfg") DO (
	ECHO.%%A | findstr /C:"=">nul && (
		CALL SET %%A
	) || (
    REM NOP
	)
)
goto :EOF

:titled
title !_title_prefix!
echo Done
goto :EOF

:titles
title !_title_prefix!!_title_sep!%*
echo %*
goto :EOF

:update
Call :titles Updating local project !_project!. . .
for /L %%D in (1,1,!_repos[0]!) do (
  for /F "tokens=5 delims=/." %%I in ("!_repos[%%D]!") do (
    if exist "%%I\*.*" (
      pushd "%%~fI"
      git pull
      popd
    ) else (
      git clone !_repos[%%D]!
    )
  )
)
Call :titled
goto :EOF

:clean
Call :titles Cleaning. . .
rmdir /S /Q build 2>nul
rmdir /S /Q dist 2>nul
Call :titled
goto :EOF

:buildtar
for %%A in (%*) do (
  Call :titles Building %%A. . .
  for /L %%D in (1,1,!_build[%%A][0]!) do (
    for /F "tokens=1* delims=:" %%I in ("!_build[%%A][%%D]!") do (
      >nul robocopy "%%~I" "build\%%~J" /E /COPY:DT /DCOPY:DT -XF Thumbs.db todo.txt preview.pdn
    )
  )
  Call :titled
)
goto :EOF

:buildzip
Call :titles Packaging. . .
if not exist "dist\*.*" mkdir dist
if exist "build\*.*" for /D %%D in (build\*) do if exist "%%~fD\*.*" Call :7zip "%%~fD"
Call :titled
goto :EOF

:7zip
setlocal
set _ArchiveOpts=-tzip -mx5 -scs932 -ssp -ssw -stl
pushd %1
>nul 7z a !_ArchiveOpts! "..\..\dist\%~n1.zip" "**"
popd
endlocal
goto :EOF

:release
Call :titles Creating %_project% release. . .
Call :buildtar !_targets!
Call :buildzip
Call :titled
goto :EOF

:help
echo/
echo Syntax:
echo/
echo %~n0 ^<command^> [paramters]
echo/
echo ÿ^<command^>ÿ=ÿIs required and can be any of the following:
echo ÿÿÿÿhelpÿÿÿÿÿÿÿÿÿÿÿ=ÿShows this screen. ^(Default if no command^)
echo ÿÿÿÿupdateÿÿÿÿÿÿÿÿÿ=ÿDownload^/Update configured project from github. [Do this first if there is not a local copy of the project]
echo ÿÿÿÿbuild [target]ÿ=ÿBuilds the specified in target. Valid targets are: !_targets! all
echo ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿTarget all is special and will build all other targets at once.
echo ÿÿÿÿdistÿÿÿÿÿÿÿÿÿÿÿ=ÿCreates distributions for all built targets.
echo ÿÿÿÿreleaseÿÿÿÿÿÿÿÿ=ÿBuild and creates distribution files for all targets.
echo ÿÿÿÿcleanÿÿÿÿÿÿÿÿÿÿ=ÿDeletes all builds and distributions.
echo/
echo ÿÿÿNote:
echo ÿÿÿÿÿÿThe following apps are required for everything to work:
echo/
echo ÿÿÿÿÿÿRoboCopy [included with Windows], Git and 7-Zip
echo/
echo ÿÿÿÿÿÿMake sure that they are installed before using any commands.
echo.
Call :pause
goto :end

:end
endlocal
popd
if "%ComTitle%" == "" (
  title %ComSpec%
) else title %ComTitle%
exit /B
::::: sig=2f184801908edda81dd4af0264c4eb78561db4a559500b114eb003d909d8489b70a953f7a596e36628410f8e5ad26b99f00ca83ca9068b21678611c00bd7bce4 :::::
