/// @file     nwzCrypto.h
/// @brief    DLL �ܺ� ���� class 

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
plan [in] : ��ȣȭ�ϰ��� �ϴ� ���ڿ�
plainSize [in]: ��ȣȭ�ϰ��� �ϴ� ���ڿ��� ����
encryptedBuffer [out] : ��ȣȭ�� ������� ���� buffer�� pointer
encryptedBufferSize [in] : ��ȣȭ�� ������� ���� buffer�� �ִ�ũ��
alg [in] : ��ĪŰ �˰���  BLOWFISH = 0 (����� blowfish�� ������ )

//return value
������ ��� ��ȣȭ�� ���ڿ��� ����
������ ��� ������
encryptedBuffer = NULL , encryptedBufferSize = 0 �� �Է��ϸ� �ʿ��� encryptedBuffer ũ�⸦ ����

//remarks
unicode(utf16) ���� ��ȣȭ�Ͽ� ������� unicode(utf16)�� ������ 


//Syntax
int decryptPwdUC(
	const TCHAR * encrypted, 
	const int encryptedSize, 
	TCHAR * plainBuffer, 
	int plainBufferSize, 
	int alg=0
);
//Parameters
encrypted [in] : ��ȣȭ�ϰ��� �ϴ� ��ȣȭ�� ���ڿ� �Ǵ� ��ȣŰ��
encryptedSize [in]: ��ȣȭ�ϰ��� �ϴ� ��ȣȭ�� ���ڿ� �Ǵ� ��ȣŰ���� ����
plainBuffer [out] : ��ȣȭ�� ������� ���� buffer�� pointer
plainBufferSize [in] : ��ȣȭ�� ������� ���� buffer�� �ִ�ũ��
alg [in] : ��ĪŰ �˰���  BLOWFISH = 0 (����� blowfish�� ������ )

//return value
������ ��� ��ȣȭ�� ���ڿ��� ����
������ ��� ������
plainBuffer = NULL , plainBufferSize = 0 �� �Է��ϸ� �ʿ��� plainBuffer ũ�⸦ ����

//remarks
unicode(utf16) ���� ��ȣȭ�Ͽ� ������� unicode(utf16)�� ������ 
��ȣŰ���� ����ϴ� ��� �ܺμ����� http ����� �Ͽ� ��ȣȭ�� ���ڿ����� �����ͼ� ��ȣȭ��


//Syntax
void setPwdAuthHost(
	const TCHAR * hostname
);

//Parameters
hostname[in] : �����н����弭���� ����ϴ°�� hostname

//remarks
�⺻ �������� URL ��δ� http://dbdove.pmang.com/getPwd.nwz?ikey= �̳�
���Լ��� ����Ͽ� hostname�� �����Ҽ� �ִ�.
���������� URL��ü�� �����ϰ��� �Ҷ��� ȯ�溯���� PWD_AUTH_URL�� �߰��ϰ� ���� �����Ѵ�.
����ȯ�� �������� URL�� "http://tom.dev.pmang.com/~ezkiro/getPwd.nwz?ikey=" �̴�.

*/

#ifdef NWZ_CRYPTO_LIB
#else
#define NWZ_CRYPTO_LIB extern "C" __declspec(dllimport)
#endif

//BLOWFISH=0,DES=1,ASE

// �����ڵ带 ����ϴ� ���
// encryptedBuffer = NULL , encryptedBufferSize = 0 �� �Է��ϸ� �ʿ��� encryptedBuffer ũ�⸦ ����
NWZ_CRYPTO_LIB int encryptPwdUC(const TCHAR * plain, const int plainSize, TCHAR * encryptedBuffer,int encryptedBufferSize, int alg=0);
// plainBuffer = NULL , plainBufferSize = 0 �� �Է��ϸ� �ʿ��� plainBuffer ũ�⸦ ����
NWZ_CRYPTO_LIB int decryptPwdUC(const TCHAR * encrypted, const int encryptedSize, TCHAR * plainBuffer, int plainBufferSize, int alg=0);

// ANSI char�� ����ϴ� ���
// encrypted = NULL , encryptedSize = 0 �� �Է��ϸ� �ʿ��� encrypted ũ�⸦ ����
NWZ_CRYPTO_LIB int encryptPwd(const char * plain, const int plainSize, char * encrypted, int encryptedSize, int alg=0);
// plain = NULL , plainSize = 0 �� �Է��ϸ� �ʿ��� plain ũ�⸦ ����
NWZ_CRYPTO_LIB int decryptPwd(const char * encrypted, const int encryptedSize, char * plain, int plainSize, int alg=0);

// remote ���������� ������
NWZ_CRYPTO_LIB int QueryToAuthServerUC(LPCWSTR lpHostName, LPCWSTR lpSendBuf, DWORD dwSendBufSize, LPWSTR lpRecvBuf, DWORD lpRecvBufSize);

NWZ_CRYPTO_LIB int nwzEncryptUC(LPCWSTR lpPlainBuf, DWORD dwPlainBufSize, LPWSTR lpEncryptedBuf, DWORD dwEncryptedBufSize, int nAlg=0);

NWZ_CRYPTO_LIB int nwzDecryptUC(LPCWSTR lpEncryptedBuf, DWORD dwEncryptedBufSize, LPWSTR lpPlainBuf, DWORD dwPlainBufSize, int nAlg=0);
