LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY appdriver_TB IS

END appdriver_TB;

ARCHITECTURE beh OF appdriver_TB IS
		signal iclk      :    STD_LOGIC; 
		signal reset_n   :    STD_LOGIC;  
	   signal led : 			std_LOGIC_VECTOR(7 DOWNTO 0);	
		signal sda       :    STD_LOGIC;                    
		signal scl       :    STD_LOGIC;
		signal sReady	  :  STD_LOGIC;
	   signal sStart		:  STD_LOGIC;
		signal sSlv_ack1		:  STD_LOGIC;					
		signal sSlv_ack2		:  STD_LOGIC;				
		signal sMstr_ack		:  STD_LOGIC;
		signal sStop		:  STD_LOGIC;
		signal sRd			: STD_LOGIC;
		signal d				:    STD_LOGIC; 
		  -- clock period for simulation
  constant clk_period : time := 10 ns;

	component appdriver IS
	  PORT(
		 iclk       :  IN      STD_LOGIC;                   
		 reset_n   :  IN      STD_LOGIC;                    
		 led : out std_LOGIC_VECTOR(7 DOWNTO 0);	 
		 oReady	  :  out      STD_LOGIC;
		 oStart		:  out      STD_LOGIC;
		 oSlv_ack1		:  out      STD_LOGIC;					
		 oSlv_ack2		:  out      STD_LOGIC;				
		 oMstr_ack		:  out      STD_LOGIC;
		 oStop		:  out      STD_LOGIC;
		 oRd			: out 		STD_LOGIC;
		 appsda       :  inOUT   STD_LOGIC;                    
		 appscl       :  inOUT   STD_LOGIC;                   
		);
	END component;

		
		BEGIN
		
		Iappdriver: entity work.appdriver(structure)   
		 port map ( 
			iclk=> iclk, 
			reset_n => reset_n, 
			led => led, 
			oReady=>sReady ,
			oStart=>sStart ,
			oSlv_ack1=>sSlv_ack1 ,
			oSlv_ack2=>sSlv_ack2 ,
			oMstr_ack=>sMstr_ack ,
			oStop=>sStop ,
			oRd=>sRd ,
			appsda => sda ,
			appscl => scl
		  ); 
		 
	pSDA: process
		variable N: natural := 1;
	begin 
		d <= '0';
		wait for clk_period*N;
		d <= '1';
		wait for clk_period*N;
		N := N+1;
	end process;
	
	sda<=	d when sRd='1' else
			'0' when sSlv_ack1 ='1' else
			'0' when sSlv_ack2 ='1' else
			'0' when sMstr_ack ='1' else 'Z';
			
	pCLK: process
	begin
		iclk <= '1';
		wait for clk_period/2;
		iclk <= '0';
		wait for clk_period/2;
	end process;

	pRESETn: process
	begin
		reset_n <= '1';
		wait for clk_period*5 + clk_period/3;
		reset_n <= '0';  
		wait for clk_period;
		reset_n <= '1';
		wait;
	end process;
	
		
END beh;
