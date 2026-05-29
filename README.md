# Simple Seven segment display control module for Artix 7 board
## VHDL implementation for the Nexys A7 (Artix-7) FPGA

A reusable 7-segment display controller written in VHDL, designed for the
Nexys A7 development board. Supports multiplexed multi-digit output with
configurable display content.

---

## ✨ Features
- Ready to use
- Control all 8 digit of screen by input raw value (to show text or desirable characters) or input binary number < 10
- Control all dot lights
- Tested on Diligent Artix 7 board - 25000MHZ 

```
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
```

