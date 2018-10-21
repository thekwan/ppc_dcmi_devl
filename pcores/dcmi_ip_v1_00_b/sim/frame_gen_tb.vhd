library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity frame_gen_tb is
end entity frame_gen_tb;

architecture IMP of frame_gen_tb is

  component frame_gen is
    port(
      clk     : in std_logic;
      clkx2   : in std_logic;
      reset   : in std_logic;
      pclk    : out std_logic;
      pdata   : out std_logic_vector(0 to 7);
      VSYNC   : out std_logic;
      HREF    : out std_logic
    );
  end component;

  constant clk_pin_PERIOD    : time := 10000.00000 ps;
  constant clkx2_pin_PERIOD  : time :=  5000.00000 ps;
  constant reset_pin_LENGTH  : time := 205000 ps;

  signal clk     : std_logic;
  signal clkx2   : std_logic;
  signal pclk    : std_logic;
  signal pdata   : std_logic_vector(0 to 7);
  signal reset   : std_logic;
  signal VSYNC   : std_logic;
  signal HREF    : std_logic;

begin

  dut : frame_gen
  port map (
    clk    =>  clk,
    clkx2  =>  clkx2,
    pclk   =>  pclk ,
    pdata  =>  pdata,
	reset  =>  reset,
	VSYNC  =>  VSYNC,
	HREF   =>  HREF  
  );

  process
  begin
    clk <= '0';
    loop
      wait for (clk_pin_PERIOD/2);
      clk <= not clk;
    end loop;
  end process;

  process
  begin
    clkx2 <= '1';
    loop
      wait for (clkx2_pin_PERIOD/2);
      clkx2 <= not clkx2;
    end loop;
  end process;


  process
  begin
    reset <= '0';
	wait for (reset_pin_LENGTH);
	reset <= '1';
	wait for (clk_pin_PERIOD);
	reset <= '0';
	wait;
  end process;
 
end IMP;
