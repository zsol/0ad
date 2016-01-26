@echo off
rem ** Create Visual Studio Workspaces on Windows **

cd ..\premake
rem ** Support for Visual Studio versions <2013 has been dropped (check #2669).
if not exist ..\workspaces\vc2013\SKIP_PREMAKE_HERE premake5 --outpath="../workspaces/vs2013" --collada --use-shared-glooxwrapper %* vs2013
cd ..\workspaces
