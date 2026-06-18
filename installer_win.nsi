; ===================== 全局配置 =====================
OutFile "AvaloniaApp_Setup.exe"
; 安装包图标，替换为你的 ico 文件
!define APP_ICON "Assets\avalonia-logo.ico"
Icon "${APP_ICON}"
; 卸载程序图标
UninstallIcon "${APP_ICON}"

!define APP_NAME "AvaloniaApplication1"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "你的公司/个人名称"
!define APP_WEBSITE "https://xxx.com"
!define APP_LICENSE "license.txt" ; 许可协议文本文件

; 默认64位安装目录
InstallDir "$PROGRAMFILES64\${APP_NAME}"
; 注册表存储安装路径，卸载读取
InstallDirRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "InstallLocation"
; 软件版本写入注册表
WriteRegStr HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "Version" "${APP_VERSION}"

; 安装需要管理员权限（ProgramFiles 保护目录）
RequestExecutionLevel admin
; 安装包名称（控制面板卸载列表显示）
BrandingText "${APP_NAME} v${APP_VERSION}"

; ===================== 安装页面流程 =====================
Page License ; 许可协议页（新增）
Page Components
Page Directory
Page InstFiles
; 卸载界面页面
UninstPage uninstConfirm
UninstPage instfiles

; ===================== 安装主程序 =====================
Section "Main Program" SEC01
  SetOutPath "$INSTDIR"
  ; 递归复制全部程序文件
  File /r "publish\win-x64\*"

  ; 桌面快捷方式 + 备注
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe" "" "${APP_NAME} 桌面快捷方式" "$INSTDIR\AvaloniaApplication1.exe" 0

  ; 开始菜单程序快捷方式
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\AvaloniaApplication1.exe" "" "${APP_NAME}" "$INSTDIR\AvaloniaApplication1.exe" 0

  ; 【新增】开始菜单卸载快捷方式
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\卸载 ${APP_NAME}.lnk" "$UNINSTEXE" "" "卸载 ${APP_NAME}" "$UNINSTEXE" 0

  ; 写入软件信息到注册表
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$UNINSTEXE"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\AvaloniaApplication1.exe,0"
SectionEnd

; ===================== 卸载逻辑（增强容错） =====================
Section "Uninstall"
  ; 删除桌面快捷方式，不存在不报错
  Delete /F "$DESKTOP\${APP_NAME}.lnk"

  ; 删除整个开始菜单文件夹（程序+卸载快捷一次性清空）
  RMDir /r "$SMPROGRAMS\${APP_NAME}"

  ; 删除安装目录所有文件
  RMDir /r "$INSTDIR"

  ; 删除所有注册表项
  DeleteRegKey /ifempty HKLM "Software\${APP_PUBLISHER}\${APP_NAME}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd

; ===================== 安装完成弹窗：是否启动软件 =====================
Function .onInstSuccess
  MessageBox MB_YESNO "${APP_NAME} 安装完成！是否立即启动程序？" IDYES RunApp
  Goto End
RunApp:
  Exec "$INSTDIR\AvaloniaApplication1.exe"
End:
FunctionEnd

; ===================== 覆盖旧版本提示 =====================
Function .onVerifyInstDir
  IfFileExists "$INSTDIR\AvaloniaApplication1.exe" 0 NoOldVersion
  MessageBox MB_OKCANCEL "检测到旧版本 ${APP_NAME}，继续安装将覆盖原有文件！" IDOK Continue IDCANCEL Abort
Abort:
  Abort
Continue:
NoOldVersion:
FunctionEnd