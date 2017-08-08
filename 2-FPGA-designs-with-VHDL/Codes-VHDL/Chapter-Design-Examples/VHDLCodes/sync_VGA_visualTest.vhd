-- sync_VGA_visualTest.vhd

-- created by 	: 	Meher Krishna Patel
-- date			: 	24-Dec-16

-- Functionality:
  -- change the color of screen based on switch combination i.e. 0 to 7

-- ports:
	-- VGA_CLK : 25 MHz clock for VGA operation (generated by sync_VGA.vhd file)
	-- VGA_BLANK : required for VGA operations and set to 1
	-- SW : combination will change the color of screen
	-- VGA_HS and VGA_VS : synchronization signals required for VGA operation
	-- VGA_R, VGA_G and VGA_B : 10 bit RGB signals for displaying colors on screen
	
library ieee;
use ieee.std_logic_1164.all;

entity sync_VGA_visualTest is
   port (
      CLOCK_50, reset: in std_logic;
      VGA_CLK, VGA_BLANK : out std_logic;
      SW: in std_logic_vector(2 downto 0);
      VGA_HS, VGA_VS: out  std_logic;
      VGA_R, VGA_G, VGA_B: out std_logic_vector(9 downto 0)
   );
end sync_VGA_visualTest;

architecture arch of sync_VGA_visualTest is
   signal rgb_reg: std_logic_vector(2 downto 0);
   signal video_on: std_logic;
begin
   -- set VGA_BLANK to 1
   VGA_BLANK <='1';

   -- instantiate sync_VGA for synchronization 
   sync_VGA_unit: entity work.sync_VGA
      port map(clk=>CLOCK_50, reset=>reset, hsync=>VGA_HS,
               vsync=>VGA_VS, video_on=>video_on,
               vga_clk=>VGA_CLK, pixel_x=>open);
   				
   -- read switch and store in rgb_reg
   process (CLOCK_50,reset)
   begin
      if reset='1' then
         rgb_reg <= (others=>'0');
      elsif (CLOCK_50'event and CLOCK_50='1') then
         rgb_reg <= SW;
      end if;
   end process;

   -- send MSB of rgb_reg to all the 10 bits of VGA_R
   -- repeat it for VGA_G and VGA_B with rgb_reg(1) and rgb_reg(0) respectively
   VGA_R <= (others=>rgb_reg(2)) when video_on='1' else (others=>'0');
   VGA_G <= (others=>rgb_reg(1)) when video_on='1' else (others=>'0');
   VGA_B <= (others=>rgb_reg(0)) when video_on='1' else (others=>'0');

end arch;