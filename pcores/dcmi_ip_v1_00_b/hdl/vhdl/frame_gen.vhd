library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity frame_gen is
  port
  (
    clk                 : in  std_logic;
    clkx2               : in  std_logic;
    reset               : in  std_logic;
    pclk                : out std_logic;
    pdata               : out std_logic_vector(0 to 7);
    VSYNC               : out std_logic;
    HREF                : out std_logic
  );
end entity frame_gen;

architecture IMP of frame_gen is

  constant CNT_N                         : integer := 10;

  signal vsync_line_cnt                  : std_logic_vector(0 to CNT_N-1);
--signal vsync_line_cnt                  : unsigned(CNT_N-1 downto 0);
  signal vsync_line_cnt_en               : std_logic;
  signal vsync_line_cnt_inc              : std_logic;
  signal vsync_line_cnt_clr              : std_logic;
  signal href_pixel_cnt                  : std_logic_vector(0 to CNT_N-1);
--signal href_pixel_cnt                  : unsigned(CNT_N-1 downto 0);
  signal href_pixel_cnt_en               : std_logic;
  signal href_pixel_cnt_clr              : std_logic;
  signal href_oper_en                    : std_logic;

  signal pdata_cnt                       : std_logic_vector(0 to 7);
  
--constant VSYNC_HIGH_PERIOD : integer := 3;
  constant VSYNC_HIGH_PERIOD : integer := 1;
  constant VSYNC_LOW_PERIOD  : integer := 510;
  constant HREF_HIGH_PERIOD  : integer := 640;
  constant HREF_LOW_PERIOD   : integer := 144;
  constant PIXEL_CNT_PERIOD  : integer := HREF_HIGH_PERIOD + HREF_LOW_PERIOD;
--constant HREF_START_CNT    : integer := 20;
  constant HREF_START_CNT    : integer := 2;
  constant HREF_STOP_CNT     : integer := 480+20;
--constant RESOLUTION_H      : integer := 640;
--constant RESOLUTION_V      : integer := 480;

  --------------------------------------------------------------
  -- State Machine defines
  --------------------------------------------------------------

  type VSYNC_SM_TYPE is (VSYNC_IDLE, VSYNC_HIGH, VSYNC_LOW);
  type HREF_SM_TYPE is  (HREF_IDLE, HREF_HIGH, HREF_LOW);
  signal vsync_sm_state : VSYNC_SM_TYPE;
  signal href_sm_state  : HREF_SM_TYPE;

begin

  VSYNC_MAIN_SM : process( clk ) is
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then

	    vsync_sm_state <= VSYNC_IDLE;

	  else

	    case vsync_sm_state is
		  when VSYNC_IDLE =>
		    vsync_sm_state <= VSYNC_HIGH;

		  when VSYNC_HIGH =>
		    if to_integer(unsigned(href_pixel_cnt)) = HREF_HIGH_PERIOD-1 and
		       to_integer(unsigned(vsync_line_cnt)) = VSYNC_HIGH_PERIOD-1 then
			  vsync_sm_state <= VSYNC_LOW;
			end if;

		  when VSYNC_LOW  =>
		    if to_integer(unsigned(href_pixel_cnt)) = HREF_HIGH_PERIOD-1 and
		       to_integer(unsigned(vsync_line_cnt)) = VSYNC_LOW_PERIOD-1 then
			  vsync_sm_state <= VSYNC_IDLE;
			end if;
		end case;

	  end if;
	end if;
  end process VSYNC_MAIN_SM;

  HREF_MAIN_SM : process( clk )
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
	    href_sm_state <= HREF_IDLE;
	  else

	    case href_sm_state is
		  when HREF_IDLE =>
		    if href_oper_en = '1' then
		    	href_sm_state <= HREF_HIGH;
			end if;

		  when HREF_HIGH =>
		    if to_integer(unsigned(href_pixel_cnt)) = HREF_HIGH_PERIOD-1 then
			  href_sm_state <= HREF_LOW;
			end if;

		  when HREF_LOW  =>
		    --if to_integer(unsigned(href_pixel_cnt)) = HREF_LOW_PERIOD-1 then
		    if to_integer(unsigned(href_pixel_cnt)) = PIXEL_CNT_PERIOD-1 then
			  if href_oper_en = '1' then
			  	href_sm_state <= HREF_HIGH;
			  else
			  	href_sm_state <= HREF_IDLE;
			  end if;
			end if;
		end case;

	  end if;
	end if;
  end process HREF_MAIN_SM;


  --------------------------------------------------------------
  -- Combinational logic
  --------------------------------------------------------------

  VSYNC_COMB_SIG_GEN : process( vsync_sm_state, vsync_line_cnt, href_pixel_cnt )
  begin

    case vsync_sm_state is
	  when VSYNC_IDLE =>
	    vsync_line_cnt_en    <= '0';
	    vsync_line_cnt_clr   <= '1';
	    href_pixel_cnt_en    <= '0';
	    href_pixel_cnt_clr   <= '1';
		href_oper_en         <= '0';
		VSYNC                <= '0';

	  when VSYNC_HIGH =>
	    if to_integer(unsigned(href_pixel_cnt)) = PIXEL_CNT_PERIOD-1 then
	      href_pixel_cnt_en  <= '0';
	      href_pixel_cnt_clr <= '1';
		  if to_integer(unsigned(vsync_line_cnt)) = VSYNC_HIGH_PERIOD-1 then
	        vsync_line_cnt_en  <= '0';
	        vsync_line_cnt_clr <= '1';
		  else
	        vsync_line_cnt_en  <= '1';
	        vsync_line_cnt_clr <= '0';
		  end if;
		else
	      href_pixel_cnt_en  <= '1';
	      href_pixel_cnt_clr <= '0';
		end if;
	    VSYNC                <= '1';
		href_oper_en         <= '0';

	  when VSYNC_LOW  =>
	    if to_integer(unsigned(href_pixel_cnt)) = PIXEL_CNT_PERIOD-1 then
	      href_pixel_cnt_en  <= '0';
	      href_pixel_cnt_clr <= '1';
	      if to_integer(unsigned(vsync_line_cnt)) = VSYNC_LOW_PERIOD-1 then
	        vsync_line_cnt_en  <= '0';
	        vsync_line_cnt_clr <= '1';
		  else
	        vsync_line_cnt_en  <= '1';
	        vsync_line_cnt_clr <= '0';
		  end if;
		else
	      href_pixel_cnt_en  <= '1';
	      href_pixel_cnt_clr <= '0';
		end if;
		if to_integer(unsigned(vsync_line_cnt)) >= HREF_START_CNT-1 and
		   to_integer(unsigned(vsync_line_cnt)) <  HREF_STOP_CNT-1 and
		   to_integer(unsigned(href_pixel_cnt)) = PIXEL_CNT_PERIOD-1 then
			href_oper_en     <= '1';
		else
			href_oper_en     <= '0';
		end if;
		VSYNC                <= '0';

	end case;

  end process VSYNC_COMB_SIG_GEN;

  HREF_COMB_SIG_GEN : process( href_sm_state, href_pixel_cnt )
  begin
	if to_integer(unsigned(href_pixel_cnt)) = PIXEL_CNT_PERIOD-1 then
	  vsync_line_cnt_inc <= '1';
	else
	  vsync_line_cnt_inc <= '0';
	end if;

    case href_sm_state is
	  when HREF_IDLE =>
		HREF <= '0';
	  when HREF_HIGH =>
		HREF <= '1';
	  when HREF_LOW  =>
		HREF <= '0';
	end case;
  end process HREF_COMB_SIG_GEN;


  --------------------------------------------------------------
  -- Synchronous logics
  --------------------------------------------------------------

  VSYNC_CNT_PROC : process( clk ) is
    variable cnt: integer;
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
	    vsync_line_cnt <= (others => '0');
	  elsif vsync_line_cnt_clr = '1' then
	    vsync_line_cnt <= (others => '0');
	  elsif vsync_line_cnt_en = '1' and vsync_line_cnt_inc = '1' then
	    cnt := to_integer(unsigned(vsync_line_cnt));
	    cnt := cnt + 1;
		vsync_line_cnt <= std_logic_vector(to_unsigned(cnt, CNT_N));
	  end if;
	end if;
  end process VSYNC_CNT_PROC;

  HREF_CNT_PROC : process( clk ) is
    variable cnt: integer;
  begin
    if clk'event and clk = '1' then
	  if reset = '1' then
	    href_pixel_cnt <= (others => '0');
	  elsif href_pixel_cnt_clr = '1' then
	    href_pixel_cnt <= (others => '0');
	  elsif href_pixel_cnt_en = '1' then
	    cnt := to_integer(unsigned(href_pixel_cnt));
		cnt := cnt + 1;
	    href_pixel_cnt <= std_logic_vector(to_unsigned(cnt, CNT_N));
	  end if;
	end if;
  end process HREF_CNT_PROC;


  PIXEL_DATA_PROC : process( clkx2 ) is
    variable cnt: integer;
  begin
    if clkx2'event and clkx2 = '1' then
	  if reset = '1' then
	    pdata_cnt <= (others => '0');
	  elsif href_oper_en = '1' then
	    pdata_cnt <= (others => '0');
	  else
	    cnt := to_integer(unsigned(pdata_cnt));
        cnt := cnt + 1;
		pdata_cnt <= std_logic_vector(to_unsigned(cnt, 8));
	  end if;
	end if;
  end process PIXEL_DATA_PROC;

  pdata <= pdata_cnt;
  pclk  <= clkx2;

end IMP;
