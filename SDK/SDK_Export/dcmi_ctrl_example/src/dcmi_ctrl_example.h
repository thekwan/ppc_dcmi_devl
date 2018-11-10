#ifndef _MASTER_EXAMPLE_H_
#define _MASTER_EXAMPLE_H_

#include "xio.h"
#include "xparameters.h"

/* Definitions for peripheral DCMI_IP_0 */
//#define XPAR_DCMI_IP_0_BASEADDR 0x8F000000
//#define XPAR_DCMI_IP_0_HIGHADDR 0x8F0007FF

#define XPAR_DCMI_IP_CTRL_REG (XPAR_DCMI_IP_0_BASEADDR+0x100)
#define XPAR_DCMI_IP_STAT_REG (XPAR_DCMI_IP_0_BASEADDR+0x101)
#define XPAR_DCMI_IP_ADDR_REG (XPAR_DCMI_IP_0_BASEADDR+0x104)
#define XPAR_DCMI_IP_BTEN_REG (XPAR_DCMI_IP_0_BASEADDR+0x108)
//#define XPAR_DCMI_IP_LENG_REG (XPAR_DCMI_IP_0_BASEADDR+0x10C)
//#define XPAR_DCMI_IP_GO_REG   (XPAR_DCMI_IP_0_BASEADDR+0x10F)
#define XPAR_DCMI_IP_SW_RESET (XPAR_DCMI_IP_0_BASEADDR+0x203)

#define WAIT_FOR_DONE  while( XIo_In8(XPAR_DCMI_IP_STAT_REG) & 0x40 )

void dcmi_ip_reset( void );
//void dcmi_ip_set_read_single_mode( void );
//void dcmi_ip_set_write_single_mode( void );
//void dcmi_ip_set_read_burst_mode( void );
//void dcmi_ip_set_write_burst_mode( void );
void dcmi_ip_oper_enable( void );
void dcmi_ip_oper_disable( void );
//void dcmi_ip_go_start( void );
void dcmi_ip_set_addr( u32 addr );
void dcmi_ip_set_byte_en_reg( u16 reg );
//void dcmi_ip_set_length( u16 size );
#endif
