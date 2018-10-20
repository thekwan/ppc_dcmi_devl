//-------------------------------------------------------------------
// system_tb.v
//-------------------------------------------------------------------

`timescale 1 ps / 100 fs

module testbench
(
);

parameter BUS_CLK_PERIOD                 = 10000;
parameter BUS_RST_LENGTH                 = 1600000;
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_REG                      = 5;
parameter C_RDFIFO_DEPTH                 = 8;
parameter C_WRFIFO_DEPTH                 = 8;

reg                                       Bus2IP_Clk;
reg                                       Bus2IP_Reset;
reg        [0 : C_SLV_DWIDTH-1]           Bus2IP_Data;
reg        [0 : C_SLV_DWIDTH/8-1]         Bus2IP_BE;
wire       [0 : C_NUM_REG-1]              Bus2IP_RdCE;
reg        [0 : C_NUM_REG-1]              Bus2IP_WrCE;
wire       [0 : C_SLV_DWIDTH-1]           IP2Bus_Data;
wire                                      IP2Bus_RdAck;
wire                                      IP2Bus_WrAck;
wire                                      IP2Bus_Error;

wire                                      Scl_I;
wire                                      Scl_O;
wire                                      Scl_T;
wire                                      Sda_I;
wire                                      Sda_O;
wire                                      Sda_T;

assign Sda_I = 1'b1;

  user_logic  u_dut (
	.Scl_I                    ( Scl_I                ),
	.Scl_O                    ( Scl_O                ),
	.Scl_T                    ( Scl_T                ),
	.Sda_I                    ( Sda_I                ),
	.Sda_O                    ( Sda_O                ),
	.Sda_T                    ( Sda_T                ),
    .Bus2IP_Clk               ( Bus2IP_Clk           ),
    .Bus2IP_Reset             ( Bus2IP_Reset         ),
    .Bus2IP_Data              ( Bus2IP_Data          ),
    .Bus2IP_BE                ( Bus2IP_BE            ),
    .Bus2IP_RdCE              ( Bus2IP_RdCE          ),
    .Bus2IP_WrCE              ( Bus2IP_WrCE          ),
    .IP2Bus_Data              ( IP2Bus_Data          ),
    .IP2Bus_RdAck             ( IP2Bus_RdAck         ),
    .IP2Bus_WrAck             ( IP2Bus_WrAck         ),
    .IP2Bus_Error             ( IP2Bus_Error         )
  );
    
  initial
  begin
    Bus2IP_Clk <= 1'b0;
	forever #(BUS_CLK_PERIOD / 2)
	  Bus2IP_Clk <= ~Bus2IP_Clk;
  end

  initial
  begin
    Bus2IP_Reset <= 1'b1;
	Bus2IP_BE    <= 'd0;
	Bus2IP_WrCE  <= 'd0;
	Bus2IP_Data  <= 'd0;
    #(BUS_RST_LENGTH)  Bus2IP_Reset <= ~Bus2IP_Reset;
    //#(BUS_RST_LENGTH)  u_dut.slv_reg1 <= 32'hab000000; (dev_addr)
    #(BUS_RST_LENGTH)  Bus2IP_BE        <= 4'b1000;
                       Bus2IP_WrCE[0:4] <= 5'b01000;
                       Bus2IP_Data[0:7] <= 8'h42;
    #(BUS_CLK_PERIOD)  Bus2IP_BE        <= 4'b0000;
                       Bus2IP_WrCE[0:4] <= 5'b00000;
                       Bus2IP_Data[0:7] <= 8'h00;

    //#(BUS_RST_LENGTH)  u_dut.slv_reg2 <= 32'hab000000; (reg_addr)
    #(BUS_RST_LENGTH)  Bus2IP_BE        <= 4'b1000;
                       Bus2IP_WrCE[0:4] <= 5'b00100;
                       Bus2IP_Data[0:7] <= 8'h0A;
    #(BUS_CLK_PERIOD)  Bus2IP_BE        <= 4'b0000;
                       Bus2IP_WrCE[0:4] <= 5'b00000;
                       Bus2IP_Data[0:7] <= 8'h00;

    //#(BUS_RST_LENGTH)  u_dut.slv_reg3 <= 32'hab000000; (reg_data)
    #(BUS_RST_LENGTH)  Bus2IP_BE        <= 4'b1000;
                       Bus2IP_WrCE[0:4] <= 5'b00010;
                       Bus2IP_Data[0:7] <= 8'h6A;
    #(BUS_CLK_PERIOD)  Bus2IP_BE        <= 4'b0000;
                       Bus2IP_WrCE[0:4] <= 5'b00000;
                       Bus2IP_Data[0:7] <= 8'h00;

    if(1) begin
    //#(BUS_RST_LENGTH)  u_dut.slv_reg0[0] <= 1'b1; (ctrl_reg: read)
    #(BUS_RST_LENGTH)  Bus2IP_BE        <= 4'b1000;
                       Bus2IP_WrCE[0:4] <= 5'b10000;
                       Bus2IP_Data[0:7] <= 8'hC0;
    #(BUS_CLK_PERIOD)  Bus2IP_BE        <= 4'b0000;
                       Bus2IP_WrCE[0:4] <= 5'b00000;
                       Bus2IP_Data[0:7] <= 8'h00;
	end

	if(0) begin
    //#(BUS_RST_LENGTH)  u_dut.slv_reg0[0] <= 1'b0; (ctrl_reg: write)
    #(BUS_RST_LENGTH)  Bus2IP_BE        <= 4'b1000;
                       Bus2IP_WrCE[0:4] <= 5'b10000;
                       Bus2IP_Data[0:7] <= 8'h80;
    #(BUS_CLK_PERIOD)  Bus2IP_BE        <= 4'b0000;
                       Bus2IP_WrCE[0:4] <= 5'b00000;
                       Bus2IP_Data[0:7] <= 8'h00;
	end
  end

endmodule
