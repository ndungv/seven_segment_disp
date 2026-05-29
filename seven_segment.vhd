-- Seven_segment logic for Nexys-A7100T FPGA board with 8 digit
-- Written by Viet Dung Nguyen with support from internet source
-- Support number and manually drive mode

library IEEE;
use IEEE.std_logic_1164.all;

entity seven_segment_display is 
port (
    clk : in std_logic;
    
    
    
    pass_through : in std_logic_vector( 7 downto 0) :="00000000"; -- 0 for number mode (default). 1 for manually drive 
    dp_ctrl : in std_logic_vector(7 downto 0); -- dot digit is manually drive
    
    digit0 : in std_logic_vector(6 downto 0) := "0000000";
    digit1 : in std_logic_vector(6 downto 0):= "0000000";
    digit2 : in std_logic_vector(6 downto 0):= "0000000";
    digit3 : in std_logic_vector(6 downto 0):= "0000000";
    digit4 : in std_logic_vector(6 downto 0):= "0000000";
    digit5 : in std_logic_vector(6 downto 0):= "0000000";
    digit6 : in std_logic_vector(6 downto 0):= "0000000";
    digit7 : in std_logic_vector(6 downto 0):= "0000000";
    
    CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
    AN : out std_logic_vector(7 downto 0)
    );
    
end entity;

architecture arch of seven_segment_display is 

signal refresh : integer :=0;
signal digit_selection : integer range 0 to 7 := 0;
signal CLK_FREQ : integer := 25000; -- tested freq that perfect for human eyes on this board only

begin

process (clk) 

variable value_selected : std_logic_vector(6 downto 0);
variable segment_control : std_logic_vector(6 downto 0);


--basic logic: show one letter at a time but flashing it very quickly make all active letter stay visible in human eyes
begin
    if rising_edge(clk) then
        
        if refresh = (CLK_FREQ) -1 then
            refresh <= 0;
            if digit_selection = 7 then 
                digit_selection <= 0;
            else    
                digit_selection <= digit_selection + 1;
            end if;
            
            else 
                refresh <= refresh + 1;
         end if;
         
         AN <= "11111111";  --reset AN
         AN(digit_selection) <= '0'; --turn on selected digit
         
         
         --Choose what digit to display in the current order
         case digit_selection is 
            when 0 => value_selected := digit0;
            when 1 => value_selected := digit1;
            when 2 => value_selected := digit2;
            when 3 => value_selected := digit3;
            when 4 => value_selected := digit4;
            when 5 => value_selected := digit5;
            when 6 => value_selected := digit6;
            when 7 => value_selected := digit7;
         end case;
         
         if pass_through(digit_selection) = '0' then
         -- Only when digit is in number mode (there are 7 bits but valid input is only 0 to 9)
         --Encode selected value from int to support seven segment display 
         case value_selected is 
            when "0000000" => segment_control := "1111110";
            when "0000001" => segment_control := "0110000";
            when "0000010" => segment_control := "1101101";
            when "0000011" => segment_control := "1111001";
            when "0000100" => segment_control := "0110011";
            when "0000101" => segment_control := "1011011";
            when "0000110" => segment_control := "1011111";
            when "0000111" => segment_control := "1110000";
            when "0001000" => segment_control := "1111111";
            when "0001001" => segment_control := "1110011";
            when others => segment_control := "0000000";
         end case;
         
         else
            -- for manually drive 
            segment_control := value_selected;
         end if;
         
            CA <= not segment_control(6); -- top bar
            CB <= not segment_control(5); -- top-right
            CC <= not segment_control(4); -- bot-right
            CD <= not segment_control(3); -- bottom
            CE <= not segment_control(2); -- bot-left
            CF <= not segment_control(1); -- top-left
            CG <= not segment_control(0); -- m iddle
            
            
            -- Drive dot digit - needs to drive manually only has two state (ON -OFF)      
          
            DP <= not (dp_ctrl(digit_selection)); -- dot
            
        
         end if;
end process;

end arch;       



    