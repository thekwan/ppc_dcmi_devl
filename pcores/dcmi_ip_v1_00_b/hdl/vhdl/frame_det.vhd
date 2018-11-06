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
    HREF                : in  std_logic;
    pixel_data_r        : out std_logic_vector(0 to 4);
    pixel_data_g        : out std_logic_vector(0 to 5);
    pixel_data_b        : out std_logic_vector(0 to 4);
    pixel_data_addr     : out std_logic_vector(0 to 31);
    pixel_data_en       : out std_logic
  );
end entity frame_det;

architecture IMP of frame_det is

  constant MEMORY_LINE_SIZE              : integer := 1024;
  constant MEMORY_LINES                  : integer := 512;

  signal line_addr                       : std_logic_vector(0 to 31);
  signal data_addr                       : std_logic_vector(0 to 31);
  signal pixel_data                      : std_logic_vector(0 to 7);
  signal pixel_line_cnt                  : std_logic_vector(0 to 8);
  signal pixel_line_cnt_en               : std_logic;
  signal pixel_line_cnt_clr              : std_logic;
  signal pixel_data_cnt                  : std_logic_vector(0 to 9);
  signal pixel_data_cnt_en               : std_logic;
  signal pixel_data_cnt_clr              : std_logic;
  signal pixel_data_catch                : std_logic;
  signal latch_x2_en                     : std_logic;

  signal pclk_fall_det                   : std_logic;
  signal vsync_fall_det                  : std_logic;
  signal href_fall_det                   : std_logic;
  signal href_fall_det_d1                : std_logic;
  signal pclk_d1                         : std_logic;
  signal pclk_d2                         : std_logic;
  signal VSYNC_d1                        : std_logic;
  signal VSYNC_d2                        : std_logic;
  signal HREF_d1                         : std_logic;
  signal HREF_d2                         : std_logic;
  signal pdata_d1                        : std_logic_vector(0 to 7);
  signal pixel_data_en_wire              : std_logic;
  
--constant RESOLUTION_V      : integer := 480;

  --------------------------------------------------------------
  -- State Machine defines
  --------------------------------------------------------------

  type VSYNC_SM_TYPE is (VSYNC_IDLE, VSYNC_HIGH, VSYNC_LOW);
  signal vsync_sm_state : VSYNC_SM_TYPE;

begin

  -- VSYNC, HREF falling edge detector
  vsync_fall_det <= (not VSYNC_d1) and VSYNC_d2;
  href_fall_det  <= (not HREF_d1 ) and HREF_d2;
  pclk_fall_det  <= (not pclk_d2) and pclk_d1;

  DELAY_LOGIC : process( clk ) is
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
	    VSYNC_d1 <= '0';
	    VSYNC_d2 <= '0';
	    HREF_d1  <= '0';
	    HREF_d2  <= '0';
		pclk_d1  <= '0';
		pclk_d2  <= '0';
		pdata_d1 <= (others => '0');
		href_fall_det_d1 <= '0';
	  else
	    VSYNC_d1 <= VSYNC;
	    VSYNC_d2 <= VSYNC_d1;
	    HREF_d1  <= HREF;
	    HREF_d2  <= HREF_d1;
		pclk_d1  <= pclk;
		pclk_d2  <= pclk_d1;
		pdata_d1 <= pdata;
		href_fall_det_d1 <= href_fall_det;
	  end if;
	end if;
  end process;

  -- pclk falling edge detector


  -- Pixel data latch logic
  pixel_data_catch <= ((not VSYNC_d1) and HREF_d1 and pclk_fall_det) or href_fall_det;

  PIXEL_DATA_CATCH_LOGIC : process( clk ) is
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
		pixel_data_r    <= (others => '1');
		pixel_data_g    <= (others => '1');
		pixel_data_b    <= (others => '1');
		latch_x2_en     <= '0';
	  elsif href_fall_det_d1 = '1' then
		pixel_data_r    <= (others => '1');
		pixel_data_g    <= (others => '1');
		pixel_data_b    <= (others => '1');
		latch_x2_en     <= '0';
	  elsif pixel_data_catch = '1' then
	    -- Latch pixel data 8bits
		latch_x2_en <= latch_x2_en xor '1';

		if  latch_x2_en = '0' then
		  pixel_data_r(0 to 4) <= pdata_d1(0 to 4);
		  pixel_data_g(0 to 2) <= pdata_d1(5 to 7);
		else
		  pixel_data_g(3 to 5) <= pdata_d1(0 to 2);
		  pixel_data_b(0 to 4) <= pdata_d1(3 to 7);
		end if;
		
	  end if;
	end if;
  end process;

  pixel_data_en_wire <= ((pixel_data_catch and (not latch_x2_en)) or href_fall_det) and HREF_d2;
  pixel_data_en      <= pixel_data_en_wire;

  pixel_data_cnt_en  <= pixel_data_en_wire;
  pixel_data_cnt_clr <= pixel_line_cnt_en;

  PIXEL_DATA_COUNTER : process( clk ) is
    variable cnt : integer;
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
		pixel_data_cnt  <= (others => '0');
	  elsif pixel_data_cnt_clr = '1' then
	    pixel_data_cnt  <= (others => '0');
	  elsif pixel_data_cnt_en = '1' then
		-- Increases pixel data counter value
        cnt := to_integer(unsigned(pixel_data_cnt));
        cnt := cnt + 1;
		pixel_data_cnt <= std_logic_vector(to_unsigned(cnt, 10));
	  end if;
	end if;
  end process;


  pixel_line_cnt_en  <= href_fall_det_d1;
  pixel_line_cnt_clr <= vsync_fall_det;

  PIXEL_LINE_COUNTER : process( clk ) is
    variable cnt : integer;
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
		pixel_line_cnt  <= (others => '0');
	  elsif pixel_line_cnt_clr = '1' then
	    pixel_line_cnt  <= (others => '0');
	  elsif pixel_line_cnt_en = '1' then
		-- Increases pixel data counter value
        cnt := to_integer(unsigned(pixel_line_cnt));
        cnt := cnt + 1;
		pixel_line_cnt <= std_logic_vector(to_unsigned(cnt, 9));
	  end if;
	end if;
  end process;


  line_addr <= "00000000000" & pixel_line_cnt & "000000000000";
  data_addr <= "00000000000000000000" & pixel_data_cnt & "00";

  PIXEL_ADDR_GEN : process( line_addr, data_addr ) is
    variable laddr, daddr, baddr : integer;
  begin
    laddr := to_integer(unsigned(line_addr));
    daddr := to_integer(unsigned(data_addr));
    baddr := daddr + laddr;
	pixel_data_addr <= std_logic_vector(to_unsigned(baddr, 32));
  end process;

end IMP;
