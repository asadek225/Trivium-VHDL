library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sterowanie is
Port( CLK		: in std_logic;
		INIT		: out std_logic;
		ZAPIS		: out std_logic;
		START		: in std_logic;
		STOP		: in std_logic;
		DANE_WE	: in std_logic;
		DANE_WY	: out std_logic;
		PRACA		: out std_logic);
end entity;

Architecture STR of Sterowanie is

SIGNAL STATE		: integer range 0 to 3 := 0;
SIGNAL STATE_CNTR	: integer range 0 to 2047 := 0;

begin

AUTOMAT_STANOW: process(CLK)
begin
	if rising_edge(CLK) then
		if STOP = '1' then
			STATE <= 0;
		elsif (STATE = 0 and START = '1') then
			STATE <= 1;
			STATE_CNTR <= 160;
		elsif (STATE = 1 and STATE_CNTR <= 1) then
			STATE <= 2;
			STATE_CNTR <= 1152;
		elsif (STATE = 2 and STATE_CNTR <= 1) then
			STATE <= 3;
		elsif (STATE = 3 and STOP = '1') then
			STATE <= 0;
		elsif (STATE_CNTR /= 0) then
			STATE_CNTR <= STATE_CNTR - 1;
		end if;
	end if;
end process;

ZAPIS <= '1' when STATE = 1 else '0';
INIT <= '1' when STATE = 2 else '0';
DANE_WY <= DANE_WE  when (STATE =1 or STATE = 3) else '0';
PRACA <= '1' when STATE = 3 else '0';

end STR;