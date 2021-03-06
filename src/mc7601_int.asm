// Send interrupts to ARM

import from mc7601_def.mlb;

NMC_DEF(); // Define constants for loader and sync functions

global _ncl_sendHPINT: label;
global _ncl_sendLPINT: label;
global _ncl_setTSTD0: label;
global _ncl_unsetTSTD0: label;
global _ncl_setTSTD1: label;
global _ncl_unsetTSTD1: label;

begin ".text"

// Send high priority interrupt to ARM
//void ncl_sendHPINT(void);


<_ncl_setTSTD0>
	push gr0,ar0;
	gr7 = nmscu;
	gr0 = 20h; //value of first LED 
	gr7 = gr7 or gr0;
	nmscu = gr7;
	pop gr0,ar0;
	return;
	
<_ncl_unsetTSTD0>
	push gr0,ar0;
	gr7 = nmscu;
	gr0 = 20h; //value of first LED 
	gr0= not gr0;
	gr7 = gr7 and gr0;
	nmscu = gr7;
	pop gr0,ar0;
	return;
	
<_ncl_setTSTD1>
	push gr0,ar0;
	gr7 = nmscu;
	gr0 = 40h; //value of Second LED 
	gr7 = gr7 or gr0;
	nmscu = gr7;
	pop gr0,ar0;
	return;
	
	
	gr3 = nmscu;
	gr2 = 40h;
	
<_ncl_unsetTSTD1>
	push gr0,ar0;
	gr7 = nmscu;
	gr0 =  40h; //value of Second LED 
	gr0= not gr0;
	gr7 = gr7 and gr0;
	nmscu = gr7;
	pop gr0,ar0;
	return;
	

<_ncl_sendHPINT>
	push gr0,ar0;
	gr7 = 1;
	[HP_INT_SEND] = gr7;
	gr7 = nmscu;
	gr0 = 4h;
	gr7 = gr7 or gr0;
	nmscu = gr7;
	pop gr0,ar0;
	return;

// Send low priority interrupt to ARM
//void ncl_sendLPINT(void);

<_ncl_sendLPINT>
	push gr0,ar0;
//	gr7 = 1;
//	[LP_INT_SEND] = gr7;
	gr7 = nmscu;
	gr0 = 8h;
	gr7 = gr7 or gr0;
	nmscu = gr7;
	pop gr0,ar0;
	return;

end ".text";
