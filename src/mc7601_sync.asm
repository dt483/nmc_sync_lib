// Shared memory processor syncronization library for NMC

const DEBUG = 0;

import from mc7601_def.mlb;

NMC_DEF(); // Define constants for loader and sync functions

extern _ncl_sendHPINT: label;
extern _ncl_sendLPINT: label;


global _ncl_getProcessorNo: label;
global _ncl_hostSync: label;
global _ncl_hostSyncArray: label;

begin ".text"

// Return processor number
//int ncl_getProcessorNo(void);

<_ncl_getProcessorNo>
	delayed return;
	gr7 = nmscu;
	gr7 <<= 27;
	gr7 >>= 31;

// Barrier synchronization with program on ARM
//int ncl_hostSync(int value);

<_ncl_hostSync>
	ar5 = sp - 2;
	push gr0, ar0;
	push gr4, ar4;
	push gr5, ar5;
	push gr6, ar6;

        // Запись выходных значений (имеет смысл только value)
	gr7 = [--ar5];
	[SYNC_TO_ARM + offset(SyncroBlock, value)] = gr7 with gr0 = false;
	[SYNC_TO_ARM + offset(SyncroBlock, array_addr)] = gr0;
	[SYNC_TO_ARM + offset(SyncroBlock, array_len)] = gr0;

    ar1 = SYNC_TO_ARM + offset(SyncroBlock, syncFlag);
    ar0 = SYNC_FROM_ARM + offset(SyncroBlock, syncFlag);

	gr0 = SYNC_FLAG;
	gr4 = false;
	gr5 = false;
	gr6 = false;

//	// Ожидание разрешения послать прерывание
//<Wait_HP_int_free>


//	// Установка статуса синхронизации
//	[TO_ARM] = gr0;
	// Set host flag to 1.
	[ar1] = gr0;

//	// Посылка HPINT


        // Wait own flag to 1.
<hs_wait1>
    ar2 = ar2 + 1;
    ar2 = ar2 - 1;
    ar2 = ar2 + 1;
    ar2 = ar2 - 1;
    gr7 = [ar0];
    with gr7 = gr7 and gr0;
    if =0 skip hs_wait1;

//	// Ожидание завершения обработки
//	// (функцией PL_SyncArray)
//<Wait_end_sync>

	with gr1 = false;
        // Set own flag to 0.
	[ar1] = gr1;
        // Wait host flag to 0.
<hs_wait2>
    ar2 = ar2 + 1;
    ar2 = ar2 - 1;
    ar2 = ar2 + 1;
    ar2 = ar2 - 1;

    gr7 = [ar0];
    with gr7 = gr7 and gr0;
    if <>0 skip hs_wait2;

	// Чтение входного значения
	gr7 = [SYNC_FROM_ARM + offset(SyncroBlock, value)];

	pop gr6, ar6;
	pop gr5, ar5;
	pop gr4, ar4;
	pop gr0, ar0;

	return;


// Barrier synchronization with program on ARM with array exchange
//int ncl_hostSyncArray(
//	int value,        // Value sent to ARM
//	void *outAddress, // Address sent to ARM
//	size_t outLen,    // Size sent to ARM
//	void **inAddress, // Address received from ARM
//	size_t *inLen);   // Size received from ARM

<_ncl_hostSyncArray>
	ar5 = sp - 2;
	push gr0, ar0;
	push gr4, ar4;
	push gr5, ar5;
	push gr6, ar6;

        // Запись выходных значений
	gr7 = [--ar5];
	[SYNC_TO_ARM + offset(SyncroBlock, value)] = gr7; // value
	gr7 = [--ar5];
	[SYNC_TO_ARM + offset(SyncroBlock, array_addr)] = gr7; // outArray
	gr7 = [--ar5];
	[SYNC_TO_ARM + offset(SyncroBlock, array_len)] = gr7; // outLen

    ar1 = SYNC_TO_ARM + offset(SyncroBlock, syncFlag);
    ar0 = SYNC_FROM_ARM + offset(SyncroBlock, syncFlag);

	gr0 = SYNC_FLAG;
	gr4 = false;
	gr5 = false;
	gr6 = false;

	// Ожидание разрешения послать прерывание
//<Wait_HP_int_free_array>


//	// Установка статуса синхронизации
//	[TO_ARM] = gr0;
	// Set host flag to 1.
	[ar1] = gr0;

//	// Посылка HPINT
	//call _ncl_sendHPINT;

        // Wait own flag to 1.
<hsa_wait1>
    ar2 = ar2+ 1;
    ar2 = ar2-1;
    ar2 = ar2+ 1;
    ar2 = ar2-1;
    gr7 = [ar0];
    with gr7 = gr7 and gr0;
    if =0 skip hsa_wait1;

//	// Ожидание завершения обработки
//	// (функцией PL_SyncArray)
//<Wait_end_sync_array>

	with gr1 = false;
        // Set own flag to 0.
	[ar1] = gr1;

        // Wait host flag to 0.
<hsa_wait2>
    ar2 = ar2 + 1;
    ar2 = ar2 - 1;
    ar2 = ar2 + 1;
    ar2 = ar2 - 1;
    gr7 = [ar0];
    with gr7 = gr7 and gr0;
    if <>0 skip hsa_wait2;

	// Чтение входных значений

	// inArray
	gr0 = [--ar5];
	with gr0;
	if =0 skip hsa_notSet1;
	gr7 = [SYNC_FROM_ARM + offset(SyncroBlock, array_addr)];
	[gr0] = gr7;
<hsa_notSet1>

	// inLen
	gr0 = [--ar5];
	with gr0;
	if =0 skip hsa_notSet2;
	gr7 = [SYNC_FROM_ARM + offset(SyncroBlock, array_len)];
	[gr0] = gr7;
<hsa_notSet2>

	// value
	gr7 = [SYNC_FROM_ARM + offset(SyncroBlock, value)];

	pop gr6, ar6;
	pop gr5, ar5;
	pop gr4, ar4;
	pop gr0, ar0;

	return;

end ".text";
