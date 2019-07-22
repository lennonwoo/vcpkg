@echo off

call:append_unique_value PYTHONPATH "C:\opt\ros\dashing\Lib\site-packages"
call:append_unique_value VCPKG_DEFAULT_TRIPLET "x64-windows"
call:call_file C:\opt\ros\dashing\setup.bat
call:append_unique_value PATH "C:\opt\ros\dashing\Scripts"

echo vcpkg.exe install %*
vcpkg.exe install %*

:append_unique_value
  setlocal enabledelayedexpansion
  :: arguments
  set "listname=%~1"
  set "value=%~2"
  :: expand the list variable
  set "list=!%listname%!"
  :: check if the list contains the value
  set "is_duplicate="
  if "%list%" NEQ "" (
    for %%v in ("%list:;=";"%") do (
      if "%%~v" == "%value%" set "is_duplicate=1"
    )
  )
  :: if it is not a duplicate append it
  if "%is_duplicate%" == "" (
    :: if not empty, append a semi-colon
    if "!list!" NEQ "" set "list=!list!;"
    :: append the value
    set "list=!list!%value%"
  )
  endlocal & (
    :: set result variable in parent scope
    set "%~1=%list%"
  )
goto:eof

:call_file
  if exist "%~1" call "%~1%"
goto:eof