library IEEE;
use IEEE.std_logic_1164.all;

entity Rejestry is
Port( CLK		: in std_logic;
		INIT		: in std_logic;
		DANE		: in std_logic;
		PRACA		: in std_logic;
		GAMA		: out std_logic);
end entity;

architecture TRIV_REJ of Rejestry is
SIGNAL REG_A 	  		 : std_logic_vector(92 downto 0) := (others => '0');
SIGNAL REG_B 	  		 : std_logic_vector(83 downto 0) := (others => '0');
SIGNAL REG_C 	  		 : std_logic_vector(110 downto 0) := (others => '0');
SIGNAL WEJ_REG_A_INIT : std_logic := '0';
SIGNAL WEJ_REG_B_INIT : std_logic := '0';
SIGNAL WEJ_REG_C_INIT : std_logic := '0';

begin

REJESTR_PIERWSZY: process(CLK)
begin
	if rising_edge(CLK) then
		if INIT = '1' then
			REG_A(0) <= DANE;
			REG_A(79 downto 1) <= REG_A(78 downto 0);
			REG_A(92 downto 80) <= (others => '0');
		elsif PRACA = '1' then
			REG_A(0) <= WEJ_REG_A_INIT;
			REG_A(92 downto 1) <= REG_A(91 downto 0);
		end if;
	end if;
end process;

REJESTR_DRUGI: process(CLK)
begin
	if rising_edge(CLK) then
		if INIT = '1' then
			REG_B(0) <= REG_A(79);
			REG_B(79 downto 1) <= REG_B(78 downto 0);
			REG_B(83 downto 80) <= (others => '0');
		elsif PRACA = '1' then
			REG_B(0) <= WEJ_REG_B_INIT;
			REG_B(83 downto 1) <= REG_B(82 downto 0);
		end if;
	end if;
end process;

REJESTR_TRZECI: process(CLK)
begin
	if rising_edge(CLK) then
		if INIT = '1' then
			REG_C(110 downto 108) <= "111";
			REG_C(107 downto 0) <= (others => '0');
		elsif PRACA = '1' then
			REG_C(0) <= WEJ_REG_C_INIT;
			REG_C(110 downto 1) <= REG_C(109 downto 0);
		end if;
	end if;
end process;

WEJ_REG_A_INIT <= REG_C(65) xor (REG_C(108) and REG_C(109)) xor REG_C(110) xor REG_A(68);
WEJ_REG_B_INIT <= REG_A(65) xor (REG_A(90) and REG_A(91)) xor REG_A(92) xor REG_B(77);
WEJ_REG_C_INIT <= REG_B(68) xor (REG_B(81) and REG_B(82)) xor REG_B(83) xor REG_C(68);

GAMA <= (REG_A(65) xor REG_A(92) xor REG_B(68) xor REG_B(83) xor REG_C(65) xor REG_C(110) xor DANE) and PRACA;

end TRIV_REJ;