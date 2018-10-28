/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 */

#include <stdio.h>
#include "platform.h"
#include "master_example.h"

void print(char *str);

int main()
{
    init_platform();


	XIo_Out32(0x00123450 , 0x01234567);
	XIo_Out32(0x00123454 , 0x11223344);
	XIo_Out32(0x00123458 , 0x99887766);
	XIo_Out32(0x0012345C , 0x98765432);

    //print("Hello World\n\r");
	dcmi_ip_reset();
	//dcmi_ip_set_read_mode();
	//dcmi_ip_set_write_single_mode();
	dcmi_ip_set_read_burst_mode();
	dcmi_ip_set_addr( 0x00123450 );
	dcmi_ip_set_byte_en_reg( 0x000f );
	dcmi_ip_set_length( 0x0010 );
	dcmi_ip_go_start();

	dcmi_ip_set_write_burst_mode();
	dcmi_ip_go_start();

    cleanup_platform();

    return 0;
}
