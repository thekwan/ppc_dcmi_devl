library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity frame_det is
  port
  (
    clk                 : in  std_logic;
    reset               : in  std_logic;
    pclk                : in  std_logic;
    pdata               : in  std_logic_vector(0 to 7);
    VSYNC               : in  std_logic;
    HREF                : in  std_logic
  );
end entity frame_det;

architecture IMP of frame_det is


  signal pixel_data                      : std_logic_vector(0 to 7);
  signal pixel_data_cnt                  : std_logic_vector(0 to 9);
  signal pixel_data_catch                : std_logic;

  signal pclk_fall_det                   : std_logic;
  signal vsync_fall_det                  : std_logic;
  signal href_fall_det                   : std_logic;
  signal pclk_d1                         : std_logic;
  signal pclk_d2                         : std_logic;
  signal VSYNC_d1                        : std_logic;
  signal HREF_d1                         : std_logic;
  
--constant RESOLUTION_V      : integer := 480;

  --------------------------------------------------------------
  -- State Machine defines
  --------------------------------------------------------------

--type VSYNC_SM_TYPE is (VSYNC_IDLE, VSYNC_HIGH, VSYNC_LOW);
--signal vsync_sm_state : VSYNC_SM_TYPE;

begin

  -- VSYNC, HREF falling edge detector
  vsync_fall_det <= (not VSYNC) and VSYNC_d1;
  href_fall_det  <= (not HREF ) and HREF_d1;
  pclk_fall_det  <= (not pclk_d2) and pclk_d1;

  DELAY_LOGIC : process( clk ) is
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
	    VSYNC_d1 <= '0';
	    HREF_d1  <= '0';
		pclk_d1  <= '0';
		pclk_d2  <= '0';
	  else
	    VSYNC_d1 <= VSYNC;
	    HREF_d1  <= HREF;
		pclk_d1  <= pclk;
		pclk_d2  <= pclk_d1;
	  end if;
	end if;
  end process;

  -- pclk falling edge detector


  -- Pixel data latch logic
  pixel_data_catch <= (not VSYNC) and HREF and pclk_fall_det;

  PIXEL_DATA_CATCH_LOGIC : process( clk ) is
    variable cnt : integer;
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
	    pixel_data      <= (others => '0');
		pixel_data_cnt  <= (others => '0');
	  elsif pixel_data_catch = '1' then
	    -- Latch pixel data 8bits
	    pixel_data <= pdata;

		-- Increases pixel data counter value
        cnt := to_integer(unsigned(pixel_data_cnt));
        cnt := cnt + 1;
		pixel_data_cnt <= std_logic_vector(to_unsigned(cnt, 10));
		
	  end if;
	end if;
  end process;


end IMP;
