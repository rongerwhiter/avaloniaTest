; 全局配置区（仅定义，无执行代码）
OutFile "AvaloniaApp_Setup.exe"
!define APP_ICON "Assets\avalonia-logo.ico"
Icon "${APP_ICON}"
UninstallIcon "${APP_ICON}"

!define APP_NAME "AvaloniaApplication1"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "你的公司/个人名称"
!define APP_LICENSE "license.txt"

InstallDir "$PROGRAMFILES64\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "InstallLocation"
RequestExecutionLevel admin
BrandingText "${APP_NAME} v${APP_VERSION}"

; 安装向导页面
Page License
Page Components
Page Directory
Page InstFiles
UninstPage uninstConfirm
UninstPage instfiles

; 安装主逻辑
Section "Main Program" SEC01
  SetOutPath "$INSTDIR"
  File /r "publish\win-x64\*"

  ; 桌面快捷方式：路径,程序,参数,注释,图标
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe" "" "${APP_NAME} 桌面快捷方式" "$INSTDIR\AvaloniaApplication1.exe,0"
  ; 开始菜单软件入口
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe" "" "${APP_NAME}" "$INSTDIR\AvaloniaApplication1.exe,0"
  ; 卸载快捷方式：只填前4个参数，不传图标，彻底规避解析错误
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\卸载 ${APP_NAME}.lnk" "$UNINSTEXE" "" "卸载 ${APP_NAME}"

  ; 注册表写入（全部在Section内）
  WriteRegStr HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "Version" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$UNINSTEXE"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\AvaloniaApplication1.exe,0"
SectionEnd

; 卸载清理区块
Section "Uninstall"
  Delete /F "$DESKTOP\${APP_NAME}.lnk"
  RMDir /r "$SMPROGRAMS\${APP_NAME}"
  RMDir /r "$INSTDIR"
  DeleteRegKey /ifempty HKLM "Software\${APP_PUBLISHER}\${APP_NAME}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd

; 安装完成弹窗
Function .onInstSuccess
  MessageBox MB_YESNO "${APP_NAME} 安装完成！是否立即启动程序？" IDYES RunApp
  Goto End
RunApp:
  Exec "$INSTDIR\AvaloniaApplication1.exe"
End:
FunctionEnd

; 检测旧版本覆盖提示
Function .onVerifyInstDir
  IfFileExists "$INSTDIR\AvaloniaApplication1.exe" 0 NoOldVersion
  MessageBox MB_OKCANCEL "检测到旧版本 ${APP_NAME}，继续安装将覆盖原有文件！" IDOK Continue IDCANCEL Abort
Abort:
  Abort
Continue:
NoOldVersion:
FunctionEnd