!define APP_NAME "AvaloniaApplication1"
!define APP_PUBLISHER "Your Company Name"

OutFile "AvaloniaApp_Setup.exe"
Icon "Assets\avalonia-logo.ico"
UninstallIcon "Assets\avalonia-logo.ico"

InstallDir "$PROGRAMFILES64\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "InstallLocation"
RequestExecutionLevel admin
BrandingText "${APP_NAME} v${APP_VERSION}"

; CI注入版本兜底
!ifndef APP_VERSION
  !define APP_VERSION "0.0.0"
!endif

; 安装页面流程
Page Components
Page Directory
Page InstFiles
UninstPage uninstConfirm
UninstPage instfiles

; 安装区块
Section "Main"
  SetOutPath "$INSTDIR"
  File /r "build\aot\*"

  ; 创建开始菜单独立文件夹
  CreateDirectory "$SMPROGRAMS\${APP_NAME}"

  ; 桌面快捷方式（修复参数，移除末尾非法0）
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" \
  "$INSTDIR\${APP_NAME}.exe" \
  "" \
  "$INSTDIR\${APP_NAME}.exe" \
  0
  ; 软件启动快捷方式
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" \
  "$INSTDIR\${APP_NAME}.exe" \
  "" \
  "$INSTDIR\${APP_NAME}.exe" \
  0
  ; 卸载快捷方式
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\卸载 ${APP_NAME}.lnk" \
  "$INSTDIR\uninstall.exe" \
  "" \
  "$INSTDIR\uninstall.exe" \
  0

  ; 生成卸载程序
  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; 自定义软件注册表
  WriteRegStr HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "Version" "${APP_VERSION}"

  ; ========== Windows控制面板标准卸载项（缺失的核心配置） ==========
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\${APP_NAME}.exe,0"
SectionEnd

; 完整卸载区块（补齐所有清理逻辑）
Section "Uninstall"
  ; 强制删除桌面快捷方式，不存在不报错
  Delete /F "$DESKTOP\${APP_NAME}.lnk"
  ; 删除整个开始菜单文件夹
  RMDir /r "$SMPROGRAMS\${APP_NAME}"
  ; 删除程序目录
  RMDir /r "$INSTDIR"
  ; 清理注册表
  DeleteRegKey /ifempty HKLM "Software\${APP_PUBLISHER}\${APP_NAME}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd

; 安装完成弹窗：是否启动程序
Function .onInstSuccess
  MessageBox MB_YESNO "${APP_NAME} 安装完成！是否立即启动软件？" IDYES RunApp
  Goto End
RunApp:
  Exec "$INSTDIR\${APP_NAME}.exe"
End:
FunctionEnd

; 检测旧版本，防止直接覆盖损坏文件
Function .onVerifyInstDir
  IfFileExists "$INSTDIR\${APP_NAME}.exe" 0 NoOldVer
  MessageBox MB_OKCANCEL "检测到已安装 ${APP_NAME} v${APP_VERSION}，继续安装将覆盖现有文件！" IDOK Continue IDCANCEL Abort
Abort:
  Abort
Continue:
NoOldVer:
FunctionEnd