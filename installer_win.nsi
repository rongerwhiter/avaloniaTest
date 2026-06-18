OutFile "AvaloniaApp_Setup.exe"
InstallDir "$PROGRAMFILES64\AvaloniaApp"
InstallDirRegKey HKLM "Software\AvaloniaApp" "InstallLocation"
RequestExecutionLevel admin
!define APP_NAME "AvaloniaApplication1"
!define APP_VERSION "1.0.0"

Page Components
Page Directory
Page InstFiles
Page UninstFiles

Section "Main Program" SEC01
  SetOutPath "$INSTDIR"
  File /r "publish\win-x64\*"
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe"
SectionEnd

Section "Uninstall"
  Delete "$DESKTOP\${APP_NAME}.lnk"
  Delete "$SMPROGRAMS\${APP_NAME}.lnk"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKLM "Software\${APP_NAME}"
SectionEnd