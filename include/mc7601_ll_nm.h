// Header file for synchronization and exchange library for NMC

#ifndef __MC7601_LL_NM__H__
#define __MC7601_LL_NM__H__

#include <stdlib.h>
#include <string.h>

#define NMC_SYNC "1.0"
#define NMC_SYNC_MAJOR_VERSION 1
#define NMC_SYNC_MINOR_VERSION 0

extern "C" //for true C mangling
{
	// Return processor number
	int ncl_getProcessorNo(void);

	// Barrier synchronization with program on ARM
	int ncl_hostSync(int value);

	// Barrier synchronization with program on ARM with array exchange
	int ncl_hostSyncArray(
		int value,        // Value sent to ARM
		void *outAddress, // Address sent to ARM
		size_t outLen,    // Size sent to ARM
		void **inAddress, // Address received from ARM
		size_t *inLen);   // Size received from ARM

	//int barrierSync();

	typedef enum {
		NCL_no_Wait_Handling = 0,
		NCL_Wait_Handling = 1
	} ncl_waitType_t;


	int ncl_hostCommand (
		int commandType, // Command type sent to arm
		void *outBuffer, // Address of buffer sent to ARM
		size_t bufferLen, // Length of buffer sent to ARM
		int wait // Wait or not for command handling
			);

	// Send high priority interrupt to ARM
	void ncl_sendHPINT(void);

	// Send low priority interrupt to ARM
	void ncl_sendLPINT(void);

	void ncl_setTSTD(void);
	void ncl_unsetTSTD(void);
};

#endif // __MC7601_LL_NM__H__
