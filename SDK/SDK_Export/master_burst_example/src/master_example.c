#include "master_example.h"

void dcmi_ip_reset( void ) {
	XIo_Out8(XPAR_DCMI_IP_SW_RESET,  0x0A);
}

void dcmi_ip_set_read_mode( void ) {
	XIo_Out8(XPAR_DCMI_IP_SW_RESET,  0x01);
}

void dcmi_ip_set_write_mode( void ) {
	XIo_Out8(XPAR_DCMI_IP_SW_RESET,  0x02);
}

void dcmi_ip_go_start( void ) {
	XIo_Out8(XPAR_DCMI_IP_GO_REG,  0x0A);
}

void dcmi_ip_set_addr( u32 addr ) {
	XIo_Out32(XPAR_DCMI_IP_ADDR_REG,  addr);
}

void dcmi_ip_set_byte_en_reg( u16 reg ) {
	XIo_Out16(XPAR_DCMI_IP_BTEN_REG, reg );
}

void dcmi_ip_set_length( u16 size ) {
	XIo_Out16(XPAR_DCMI_IP_LENG_REG, size );
}


