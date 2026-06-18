; ===================== 全局编译配置 =====================
OutFile "AvaloniaApp_Setup.exe"
!define APP_ICON "Assets\avalonia-logo.ico"
Icon "${APP_ICON}"
UninstallIcon "${APP_ICON}"

!define APP_NAME "AvaloniaApplication1"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "你的公司/个人名称"
!define APP_WEBSITE "https://xxx.com"
!define APP_LICENSE "license.txt"

InstallDir "$PROGRAMFILES64\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "InstallLocation"
RequestExecutionLevel admin
BrandingText "${APP_NAME} v${APP_VERSION}"

; 页面顺序
Page License
Page Components
Page Directory
Page InstFiles
UninstPage uninstConfirm
UninstPage instfiles

; ===================== 安装主区块 =====================
Section "Main Program" SEC01
  SetOutPath "$INSTDIR"
  File /r "publish\win-x64\*"

  ; 桌面快捷方式，修正参数，删掉末尾多余0
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe" "" "${APP_NAME} 桌面快捷方式" "$INSTDIR\AvaloniaApplication1.exe"
  ; 开始菜单程序快捷方式
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe" "" "${APP_NAME}" "$INSTDIR\AvaloniaApplication1.exe"
  ; 卸载快捷方式
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\卸载 ${APP_NAME}.lnk" "$UNINSTEXE" "" "卸载 ${APP_NAME}" "$UNINSTEXE"

  ; 注册表
  WriteRegStr HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "Version" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$UNINSTEXE"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\AvaloniaApplication1.exe,0"
SectionEnd

; ===================== 卸载区块 =====================
Section "Uninstall"
  Delete /F "$DESKTOP\${APP_NAME}.lnk"
  RMDir /r "$SMPROGRAMS\${APP_NAME}"
  RMDir /r "$INSTDIR"
  DeleteRegKey /ifempty HKLM "Software\${APP_PUBLISHER}\${APP_NAME}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd

; ===================== 安装完成启动弹窗 =====================
Function .onInstSuccess
  MessageBox MB_YESNO "${APP_NAME} 安装完成！是否立即启动程序？" IDYES RunApp
  Goto End
RunApp:
  Exec "$INSTDIR\AvaloniaApplication1.exe"
End:
FunctionEnd

; ===================== 旧版本覆盖校验 =====================
Function .onVerifyInstDir
  IfFileExists "$INSTDIR\AvaloniaApplication1.exe" 0 NoOldVersion
  MessageBox MB_OKCANCEL "检测到旧版本 ${APP_NAME}，继续安装将覆盖原有文件！" IDOK Continue IDCANCEL Abort
Abort:
  Abort
Continue:
NoOldVersion:
FunctionEnd