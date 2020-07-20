/// @file     nwzCrypto.h
/// @brief    DLL 외부 노출 class 

/************************************************************************************************
//Syntax
int encryptPwdUC(
	const TCHAR * plain, const 
	int plainSize, 
	TCHAR * encryptedBuffer,
	int encryptedBufferSize, 
	int alg=0
);

//Parameters
plan [in] : 암호화하고자 하는 문자열
plainSize [in]: 암호화하고자 하는 문자열의 길이
encryptedBuffer [out] : 암호화된 결과값을 받을 buffer의 pointer
encryptedBufferSize [in] : 암호화된 결과값을 받을 buffer의 최대크기
alg [in] : 대칭키 알고리즘  BLOWFISH = 0 (현재는 blowfish만 지원함 )

//return value
성공인 경우 암호화된 문자열의 길이
실패인 경우 음수값
encryptedBuffer = NULL , encryptedBufferSize = 0 을 입력하면 필요한 encryptedBuffer 크기를 리턴

//remarks
unicode(utf16) 값을 암호화하여 결과값을 unicode(utf16)로 돌려줌 


//Syntax
int decryptPwdUC(
	const TCHAR * encrypted, 
	const int encryptedSize, 
	TCHAR * plainBuffer, 
	int plainBufferSize, 
	int alg=0
);
//Parameters
encrypted [in] : 복호화하고자 하는 암호화된 문자열 또는 암호키값
encryptedSize [in]: 복호화하고자 하는 암호화된 문자열 또는 암호키값의 길이
plainBuffer [out] : 복호화된 결과값을 받을 buffer의 pointer
plainBufferSize [in] : 복호화된 결과값을 받을 buffer의 최대크기
alg [in] : 대칭키 알고리즘  BLOWFISH = 0 (현재는 blowfish만 지원함 )

//return value
성공인 경우 복호화된 문자열의 길이
실패인 경우 음수값
plainBuffer = NULL , plainBufferSize = 0 을 입력하면 필요한 plainBuffer 크기를 리턴

//remarks
unicode(utf16) 값을 복호화하여 결과값을 unicode(utf16)로 돌려줌 
암호키값을 사용하는 경우 외부서버로 http 통신을 하여 암호화된 문자열값을 가져와서 복호화함


//Syntax
void setPwdAuthHost(
	const TCHAR * hostname
);

//Parameters
hostname[in] : 통합패스워드서버를 사용하는경우 hostname

//remarks
기본 인증서버 URL 경로는 http://dbdove.pmang.com/getPwd.nwz?ikey= 이나
이함수를 사용하여 hostname을 변경할수 있다.
인증서버의 URL자체를 변경하고자 할때는 환경변수로 PWD_AUTH_URL을 추가하고 값을 셋팅한다.
개발환경 인증서버 URL은 "http://tom.dev.pmang.com/~ezkiro/getPwd.nwz?ikey=" 이다.

*/

#ifdef NWZ_CRYPTO_LIB
#else
#define NWZ_CRYPTO_LIB extern "C" __declspec(dllimport)
#endif

//BLOWFISH=0,DES=1,ASE

// 유니코드를 사용하는 경우
// encryptedBuffer = NULL , encryptedBufferSize = 0 을 입력하면 필요한 encryptedBuffer 크기를 리턴
NWZ_CRYPTO_LIB int encryptPwdUC(const TCHAR * plain, const int plainSize, TCHAR * encryptedBuffer,int encryptedBufferSize, int alg=0);
// plainBuffer = NULL , plainBufferSize = 0 을 입력하면 필요한 plainBuffer 크기를 리턴
NWZ_CRYPTO_LIB int decryptPwdUC(const TCHAR * encrypted, const int encryptedSize, TCHAR * plainBuffer, int plainBufferSize, int alg=0);

// ANSI char를 사용하는 경우
// encrypted = NULL , encryptedSize = 0 을 입력하면 필요한 encrypted 크기를 리턴
NWZ_CRYPTO_LIB int encryptPwd(const char * plain, const int plainSize, char * encrypted, int encryptedSize, int alg=0);
// plain = NULL , plainSize = 0 을 입력하면 필요한 plain 크기를 리턴
NWZ_CRYPTO_LIB int decryptPwd(const char * encrypted, const int encryptedSize, char * plain, int plainSize, int alg=0);

// remote 인증정보를 가져옴
NWZ_CRYPTO_LIB int QueryToAuthServerUC(LPCWSTR lpHostName, LPCWSTR lpSendBuf, DWORD dwSendBufSize, LPWSTR lpRecvBuf, DWORD lpRecvBufSize);

NWZ_CRYPTO_LIB int nwzEncryptUC(LPCWSTR lpPlainBuf, DWORD dwPlainBufSize, LPWSTR lpEncryptedBuf, DWORD dwEncryptedBufSize, int nAlg=0);

NWZ_CRYPTO_LIB int nwzDecryptUC(LPCWSTR lpEncryptedBuf, DWORD dwEncryptedBufSize, LPWSTR lpPlainBuf, DWORD dwPlainBufSize, int nAlg=0);
