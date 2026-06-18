!define APP_NAME "AvaloniaApplication1"

OutFile "AvaloniaApp_Setup.exe"

InstallDir "$PROGRAMFILES64\${APP_NAME}"
RequestExecutionLevel admin

; =========================
; 版本来自 CI 注入
; =========================
!ifndef APP_VERSION
  !define APP_VERSION "0.0.0"
!endif

Section "Main"

  SetOutPath "$INSTDIR"

  ; ONLY AOT OUTPUT
  File /r "build\aot\*"

  CreateDirectory "$SMPROGRAMS\${APP_NAME}"

  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" \
    "$INSTDIR\${APP_NAME}.exe" "" "$INSTDIR\${APP_NAME}.exe" 0

  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" \
    "$INSTDIR\${APP_NAME}.exe" "" "$INSTDIR\${APP_NAME}.exe" 0

  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; 写版本（商业软件标准）
  WriteRegStr HKLM "Software\${APP_NAME}" "Version" "${APP_VERSION}"

SectionEnd

Section "Uninstall"
  RMDir /r "$INSTDIR"
SectionEnd