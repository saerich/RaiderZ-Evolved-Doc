;Game Full Client NSIS Template Script
;���� �����丮 : 2009�� 11�� 13�� ���� release
;�ۼ���: dive2sky@neowiz.com

;--------------------------------
;����� ���� ���� ����
!define VERSION 100 				 		; ���� Ŭ���̾�Ʈ ����, ������Ʈ���� ��ϵȴ�. version ���� �߸��Ǵ� ��� �Ǹ� ��ó�� ���� ���ӽ��࿡ �����ϰ� �ǹǷ� ��Ȯ�� �Է��Ѵ�.

!define INSTALL_DIR "C:\neowiz\pmang\test"	; �⺻ ��ġ ���丮 ex) c:\neowiz\pmang\debut
!define UNINSTALLER "Uninstaller.exe" 		; ���� Ŭ���̾�Ʈ Uninstaller ���ϸ� ex) Uninstall.exe 
;!define UNINSTALLER_NAME "Test ����"  		; Uninstall shortcut
!define PRODUCT_NAME "Test"			  		; ���α׷� ������, ������Ʈ�� Ű���� ���ȴ�. ex) debut
!define PRODUCT_NAME_KOREAN "�׽�Ʈ"  		; ���α׷� �ѱ۸�, ��ġ ���α׷� ������ ǥ���Ǵ� ���α׷� �̸��� ���ȴ�.  ex)����
!define INSTALLER_NAME "�׽�Ʈ ��ġ"		; ��ġ ���α׷���, ��ġ ���α׷� �������� Caption�� �ȴ�. ex)���� ��ġ
!define OUTFILE_NAME "Test.exe" 			; ��ġ ���α׷� ��������(�ν��緯)�� ex)debut_full_2009111213.exe
!define ZIPFILE_NAME "Test.7z"		  		; Ŭ���̾�Ʈ �������ϸ�, ��å������ ��ġ ���α׷� ���� ���ϸ�� �����ϰ� ���� �ϵ��� �Ѵ�.	ex)debut_full_2009111213.7z 
!define CLIENT_SIZE "4096"				    ; ��ġ �� Ŭ���̾�Ʈ ũ��(KB),
!define LICENSE_TEXT "D:\Packaging System\NSIS Script Template\Test\Resource\TestLicense.txt" 		; ���̼��� ���� ����, ������ �� ������ �غ��ؾ� �Ѵ�.
!define HEADER_IMAGE "${NSISDIR}\Contrib\Graphics\Header\win.bmp"									; �ν��緯 ��� �̹���(150*57 pixel ����ȭ), ������ �� ������ �غ��ؾ� �Ѵ�.
!define MUIICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"							; �ν��緯 ������, ������ �� ������ �غ��ؾ� �Ѵ�.
!define FINISHPAGE_IMAGE "${NSISDIR}\Contrib\Graphics\Header\win.bmp"								; ��ġ �Ϸ� ������ �̹���, ������ �� ������ �غ��ؾ� �Ѵ�.

; ��ġ �� ���� ���� ���� ������ �����ϱ� ���� ������Ʈ�� Ű ����, Ư���� ������ ���� �� �������� �ʴ´�.
!define INSTDIR_REG_ROOT "HKLM"
!define INSTDIR_REG_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define CONFIG_REG_ROOT "HKCU"
!define CONFIG_REG_KEY "Software\Neowiz\${PRODUCT_NAME}"

!define BRANDING_TEXT "(��)�׿����������" 	; �ν��緯 �ϴ� Text
;--------------------------------
;����� ���� ���� ��

;--------------------------------
!include MUI2.nsh

;--------------------------------
;General

;Set Install Directory & read Registry key for the Install Directory if available 
InstallDir "${INSTALL_DIR}"

;Name and File
Name "${PRODUCT_NAME_KOREAN}"
OutFile "${OUTFILE_NAME}"

;Caption on installer windows
Caption "${INSTALLER_NAME}"
ShowInstDetails nevershow
ShowUninstDetails show

;Don't Allow Install to Root Directory or Network Share
AllowRootDirInstall false 

;Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------
;Interface Settings
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${HEADER_IMAGE}"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${FINISHPAGE_IMAGE}"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${FINISHPAGE_IMAGE}"
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNIG
!define MUI_ICON "${MUIICON}"
!define MUI_UNICON "${MUIICON}"

BrandingText /TRIMCENTER ${BRANDING_TEXT} 

;---------------------------------
;Page

!define MUI_PAGE_CUSTOMFUNCTION_PRE checkpreinstall
!insertmacro MUI_PAGE_LICENSE "${LICENSE_TEXT}"
;!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


;--------------------------------
;Languages
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "English"
;--------------------------------
;Installer Sections

Section "!${PRODUCT_NAME_KOREAN}" 
	SectionIN RO
	SetOutPath "$INSTDIR"  
	
	addsize ${CLIENT_SIZE}

	GetFunctionAddress $R9 CallbackProgress
	Nsis7z::ExtractWithCallback "$EXEDIR\${ZIPFILE_NAME}" $R9
	
	;store installation foler 
	WriteRegStr ${CONFIG_REG_ROOT} "${CONFIG_REG_KEY}" "InstallPath" $INSTDIR
	WriteRegDword ${CONFIG_REG_ROOT} "${CONFIG_REG_KEY}" "Version" ${VERSION}

	;add uninstall information to Add/Remove Programs
	WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "InstallDir" $INSTDIR
	WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "DisplayName" "${PRODUCT_NAME_KOREAN}"
	WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "UninstallString" "$INSTDIR\${UNINSTALLER}"
	WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "UninstallDirectory" "$INSTDIR"
	
	WriteUninstaller $INSTDIR\${UNINSTALLER}
	;Delete "$OUTDIR\${ZIPFILE_NAME}"
SectionEnd

;Section "NVIDIA GAME System Software 2.8.1 "
;	ExecWait '"msiexec" /i "$INSTDIR\PhysX_Game_installer_281.msi"'
;SectionEnd

Section "UnInstall"
	RMDir /r $INSTDIR

	DeleteRegKey /ifempty ${CONFIG_REG_ROOT} "${CONFIG_REG_KEY}"
	DeleteRegKey /ifempty ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}"
SectionEnd

Function .onInit
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "myMutext") i .r1 ?e'
	Pop $R0
	StrCmp $R0 0 +3
		MessageBox MB_OK|MB_ICONEXCLAMATION $(DESC_Already_Excuted_Warning)
		Abort
FunctionEnd

Function checkpreinstall
	ReadRegStr $0 ${CONFIG_REG_ROOT} "${CONFIG_REG_KEY}" "InstallPath"
	StrCmp $0 "" preinstallFalse preinstallTrue
	preinstallFalse:
		goto end
	preinstallTrue:
		MessageBox MB_YESNO $(DESC_Ask_Preinstall_Delete) IDYES true IDNO false
		false:
			MessageBox MB_OK $(DESC_UninstPreVer_Warning)
			Quit
		true:	
			StrCpy $R3 "$INSTDIR"
			ReadRegStr $INSTDIR ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "InstallDir"
			ReadRegStr $R1 ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "UninstallString"
			ReadRegStr $R2 ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "UninstallDirectory"
		
			ExecWait '"$R1" /S _?=$R2' 
			RMdir /r $INSTDIR
			MessageBox MB_YESNO $(DESC_Ask_Continue_Install) IDYES deletetemp IDNO stop
				stop:
					Quit
				deletetemp:
					DetailPrint $(DESC_Install_Complete)
					StrCpy "$INSTDIR" $R3
	end:
Functionend

Function CallbackProgress
  Pop $R8
  Pop $R9

  IntOp $R8 $R8 / 1048576 
  IntOp $R9 $R9 / 1048576

  SetDetailsPrint textonly
  DetailPrint "$(DESC_Installing) $R8M byte / $R9M byte..."
  SetDetailsPrint both

FunctionEnd

;--------------------------------
;Descriptions
;Language strings
	LangString DESC_Uninstall_Pre ${LANG_ENGLISH} "Do you want to Delete All sub component in $INSTDIR?"
	LangString DESC_Uninstall_Pre ${LANG_KOREAN} "$INSTDIR ������ ��ġ�� ��� ������Ҹ� �����Ͻðڽ��ϱ�? ��ġ ���� �̿ܿ� $INSTDIR ������ ��ġ�� ���丮 �� ������ ���ܵη��� '�ƴϿ�'�� �����ϼ���."

	LangString DESC_Installer_Running ${LANG_ENGLISH} "The installer is already running"
	LangString DESC_Installer_Running ${LANG_KOREAN} "�̹� �ν��緯�� �������Դϴ�."

	LangString DESC_Ask_Preinstall_Delete ${LANG_ENGLISH} "${PRODUCT_NAME} client is already installed. Previous Version Client will be uninstalled and New Version Client will be installed."
	LangString DESC_Ask_Preinstall_Delete ${LANG_KOREAN} "${PRODUCT_NAME} Ŭ���̾�Ʈ�� �̹� ��ġ�Ǿ� �ֽ��ϴ�. ���� ������ Ŭ���̾�Ʈ�� �����ϰ� �� ������ ��ġ�մϴ�."

	LangString DESC_UninstPreVer_Warning ${LANG_ENGLISH} "You can't install the new version client when you don't uninstall the previouse version client."
	LangString DESC_UninstPreVer_Warning ${LANG_KOREAN} "���� ������ Ŭ���̾�Ʈ�� �������� ������ �� ������ ��ġ�� �� �����ϴ�."

	LangString DESC_Ask_Continue_Install ${LANG_ENGLISH} "The previous version client completely uninstalled. Do you want to Install New Version Client now?"
	LangString DESC_Ask_Continue_Install ${LANG_KOREAN} "���� ������ Ŭ���̾�Ʈ�� ���ŵǾ����ϴ�. �� ���� �ν����� ����Ͻðڽ��ϱ�?"

	LangString DESC_Install_Complete ${LANG_ENGLISH} "Delete Complete"
	LangString DESC_Install_Complete ${LANG_KOREAN} "������ �Ϸ�Ǿ����ϴ�."
	
	LangString DESC_Installing ${LANG_ENGLISH} "Installing"
	LangString DESC_Installing ${LANG_KOREAN} "��ġ ���� ��"

	LangString DESC_Already_Excuted_Warning ${LANG_ENGLISH} "Another install is excuting"
	LangString DESC_Already_Excuted_Warning ${LANG_KOREAN} "�̹� �ٸ� �ν��緯�� �������Դϴ�."
