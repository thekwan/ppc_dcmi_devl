#include "master_example.h"

/**************************************
 * RESET
 **************************************/
void dcmi_ip_reset( void ) {
	XIo_Out8(XPAR_DCMI_IP_SW_RESET,  0x0A);
}

/**************************************
 * Operating mode set
 **************************************/
void dcmi_ip_set_read_single_mode( void ) {
	WAIT_FOR_DONE;
	XIo_Out8(XPAR_DCMI_IP_CTRL_REG,  0x80);
}

void dcmi_ip_set_write_single_mode( void ) {
	WAIT_FOR_DONE;
	XIo_Out8(XPAR_DCMI_IP_CTRL_REG,  0x40);
}

void dcmi_ip_set_read_burst_mode( void ) {
	WAIT_FOR_DONE;
	XIo_Out8(XPAR_DCMI_IP_CTRL_REG,  0x90);
}

void dcmi_ip_set_write_burst_mode( void ) {
	WAIT_FOR_DONE;
	XIo_Out8(XPAR_DCMI_IP_CTRL_REG,  0x50);
}

/**************************************
 * Start API
 **************************************/
void dcmi_ip_go_start( void ) {
	WAIT_FOR_DONE;
	XIo_Out8(XPAR_DCMI_IP_GO_REG,  0x0A);
}


/**************************************
 * Burst operation configs
 **************************************/
void dcmi_ip_set_addr( u32 addr ) {
	WAIT_FOR_DONE;
	XIo_Out32(XPAR_DCMI_IP_ADDR_REG,  addr);
}

void dcmi_ip_set_byte_en_reg( u16 reg ) {
	WAIT_FOR_DONE;
	XIo_Out16(XPAR_DCMI_IP_BTEN_REG, reg );
}

void dcmi_ip_set_length( u16 size ) {
	WAIT_FOR_DONE;
	XIo_Out16(XPAR_DCMI_IP_LENG_REG, size );
}


