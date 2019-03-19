import from mc7601_def.mlb;

NMC_DEF(); // Define constants for loader and sync functions

extern _ncl_sendHPINT: label; //send High priority interrupt
extern _ncl_sendLPINT: label;

global _ncl_hostCommand: label;

/*	int ncl_hostCommand (
*		int commandType, // Command type sent to arm
*		void *outBuffer, // Address of buffer sent to ARM
*		size_t bufferLen, // Length of buffer sent to ARM
*		ncl_waitType_t wait  // Wait or not for command handling
*			);
*/
begin ".text"

<_ncl_hostCommand>
	ar5 = sp - 2;
	push gr0, ar0;
	push gr4, ar4;
	push gr5, ar5;
	push gr6, ar6;

    // Запись передаваемых значений  значений
	gr7 = [--ar5];
	[CMD_TO_ARM + offset(CommandBlock, commantType)] = gr7; // commandType
	gr7 = [--ar5];
	[CMD_TO_ARM + offset(CommandBlock, bufferAddr)] = gr7; // *outBuffer
	gr7 = [--ar5];
	[CMD_TO_ARM + offset(CommandBlock, bufferLen)] = gr7; // bufferLen
	gr7 = [--ar5];
	gr4 = gr7; // Wait or not for command handling

	//Адрес статуса обработчика
    ar1 = CMD_TO_ARM + offset(CommandBlock, handlerStatus);

     //Ожидание освобождения обработчика команды
    //gr0 = 0;
<cmd_wait_ready_to_handle>
    gr2 = gr2 + 1;
    gr2 = gr2 - 1;
    gr2 = gr2 + 1;
    gr2 = gr2 - 1;
    gr7 = [ar1];
    //with gr7 = gr7; //проверка handlerStatus==0
    if <>0 skip cmd_wait_ready_to_handle;

	//gr4 = false;
	gr5 = false;
	gr6 = false;

//	// Посылка HPINT
	call _ncl_sendHPINT;
	
	//Определить ожидать обработки или нет
	gr7 = 1h;
	gr7 = gr7 and gr4;
	if =0 skip cmd_no_wait_handling;
	
	// Ожидание завершения обработки
<cmd_wait_handling>
    gr2 = gr2 + 1;
    gr2 = gr2 - 1;
    gr2 = gr2 + 1;
    gr2 = gr2 - 1;
    gr7 = [ar1];
    //with gr7 = gr7 or gr0; 
    if <>0 skip cmd_wait_handling;

<cmd_no_wait_handling>

	// value
	gr7 = 0;

	pop gr6, ar6;
	pop gr5, ar5;
	pop gr4, ar4;
	pop gr0, ar0;

	return;
	
end ".text";