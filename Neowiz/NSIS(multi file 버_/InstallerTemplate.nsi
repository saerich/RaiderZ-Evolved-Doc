;Game Full Client NSIS Template Script
;변경 히스토리 : 2009년 11월 13일 최초 release
;작성자: dive2sky@neowiz.com

;--------------------------------
;사용자 변수 선언 시작
!define VERSION 100 				 		; 게임 클라이언트 버전, 레지스트리에 등록된다. version 값이 잘못되는 경우 피망 런처를 통한 게임실행에 실패하게 되므로 정확히 입력한다.

!define INSTALL_DIR "C:\neowiz\pmang\test"	; 기본 설치 디렉토리 ex) c:\neowiz\pmang\debut
!define UNINSTALLER "Uninstaller.exe" 		; 게임 클라이언트 Uninstaller 파일명 ex) Uninstall.exe 
;!define UNINSTALLER_NAME "Test 제거"  		; Uninstall shortcut
!define PRODUCT_NAME "Test"			  		; 프로그램 영문명, 레지스트리 키값에 사용된다. ex) debut
!define PRODUCT_NAME_KOREAN "테스트"  		; 프로그램 한글명, 설치 프로그램 내에서 표현되는 프로그램 이름에 사용된다.  ex)데뷰
!define INSTALLER_NAME "테스트 설치"		; 설치 프로그램명, 설치 프로그램 윈도우의 Caption이 된다. ex)데뷰 설치
!define OUTFILE_NAME "Test.exe" 			; 설치 프로그램 실행파일(인스톨러)명 ex)debut_full_2009111213.exe
!define ZIPFILE_NAME "Test.7z"		  		; 클라이언트 압축파일명, 정책적으로 설치 프로그램 실행 파일명과 동일하게 설정 하도록 한다.	ex)debut_full_2009111213.7z 
!define CLIENT_SIZE "4096"				    ; 설치 후 클라이언트 크기(KB),
!define LICENSE_TEXT "D:\Packaging System\NSIS Script Template\Test\Resource\TestLicense.txt" 		; 라이센스 동의 문서, 컴파일 전 파일을 준비해야 한다.
!define HEADER_IMAGE "${NSISDIR}\Contrib\Graphics\Header\win.bmp"									; 인스톨러 상단 이미지(150*57 pixel 최적화), 컴파일 전 파일을 준비해야 한다.
!define MUIICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"							; 인스톨러 아이콘, 컴파일 전 파일을 준비해야 한다.
!define FINISHPAGE_IMAGE "${NSISDIR}\Contrib\Graphics\Header\win.bmp"								; 설치 완료 페이지 이미지, 컴파일 전 파일을 준비해야 한다.

; 설치 및 삭제 게임 버전 정보를 저장하기 위한 레지스트리 키 지정, 특별한 사유가 없는 한 변경하지 않는다.
!define INSTDIR_REG_ROOT "HKLM"
!define INSTDIR_REG_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define CONFIG_REG_ROOT "HKCU"
!define CONFIG_REG_KEY "Software\Neowiz\${PRODUCT_NAME}"

!define BRANDING_TEXT "(주)네오위즈게임즈" 	; 인스톨러 하단 Text
;--------------------------------
;사용자 변수 선언 끝

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
	LangString DESC_Uninstall_Pre ${LANG_KOREAN} "$INSTDIR 하위에 설치된 모든 구성요소를 삭제하시겠습니까? 설치 과정 이외에 $INSTDIR 하위에 설치된 디렉토리 및 파일을 남겨두려면 '아니오'를 선택하세요."

	LangString DESC_Installer_Running ${LANG_ENGLISH} "The installer is already running"
	LangString DESC_Installer_Running ${LANG_KOREAN} "이미 인스톨러가 실행중입니다."

	LangString DESC_Ask_Preinstall_Delete ${LANG_ENGLISH} "${PRODUCT_NAME} client is already installed. Previous Version Client will be uninstalled and New Version Client will be installed."
	LangString DESC_Ask_Preinstall_Delete ${LANG_KOREAN} "${PRODUCT_NAME} 클라이언트가 이미 설치되어 있습니다. 기존 버전의 클라이언트를 삭제하고 새 버전을 설치합니다."

	LangString DESC_UninstPreVer_Warning ${LANG_ENGLISH} "You can't install the new version client when you don't uninstall the previouse version client."
	LangString DESC_UninstPreVer_Warning ${LANG_KOREAN} "이전 버전의 클라이언트를 제거하지 않으면 새 버전을 설치할 수 없습니다."

	LangString DESC_Ask_Continue_Install ${LANG_ENGLISH} "The previous version client completely uninstalled. Do you want to Install New Version Client now?"
	LangString DESC_Ask_Continue_Install ${LANG_KOREAN} "이전 버전의 클라이언트가 제거되었습니다. 새 버전 인스톨을 계속하시겠습니까?"

	LangString DESC_Install_Complete ${LANG_ENGLISH} "Delete Complete"
	LangString DESC_Install_Complete ${LANG_KOREAN} "삭제가 완료되었습니다."
	
	LangString DESC_Installing ${LANG_ENGLISH} "Installing"
	LangString DESC_Installing ${LANG_KOREAN} "설치 진행 중"

	LangString DESC_Already_Excuted_Warning ${LANG_ENGLISH} "Another install is excuting"
	LangString DESC_Already_Excuted_Warning ${LANG_KOREAN} "이미 다른 인스톨러가 실행중입니다."
