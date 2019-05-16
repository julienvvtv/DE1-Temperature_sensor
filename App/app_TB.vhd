LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY app_TB IS

END app_TB;

ARCHITECTURE beh OF app_TB IS
	 signal iclk       :        STD_LOGIC;                    
	 signal reset_n   :        STD_LOGIC;                    --active low reset
    signal ena       :        STD_LOGIC;                    
    signal addr      :        STD_LOGIC_VECTOR(6 DOWNTO 0); 
    signal rw        :        STD_LOGIC;                    
    signal data_wr  :        STD_LOGIC_VECTOR(7 DOWNTO 0); 
    signal busy      :       STD_LOGIC;                    
    signal iSlv_ack1		:        STD_LOGIC;					
    signal iSlv_ack2		:        STD_LOGIC;					 
    signal iMstr_ack		:        STD_LOGIC;
    signal iStop		:        STD_LOGIC;
	 signal iRd			:  		STD_LOGIC;
	 signal led :  std_LOGIC_VECTOR(7 DOWNTO 0);
	 signal sState :  std_logic;
  constant clk_period : time := 10 ns;

	component app IS
	  PORT(
	 clk       :  IN      STD_LOGIC;                    
	 reset_n   :  IN      STD_LOGIC;                    
    ena       :  OUT      STD_LOGIC;                    
    addr      :  OUT      STD_LOGIC_VECTOR(6 DOWNTO 0); 
    rw        :  OUT      STD_LOGIC;                    
    data_wr  :  OUT      STD_LOGIC_VECTOR(7 DOWNTO 0); 
    busy      :  IN     STD_LOGIC;                    
    iSlv_ack1		:  IN      STD_LOGIC;					
    iSlv_ack2		:  IN      STD_LOGIC;					
    iMstr_ack		:  IN      STD_LOGIC;
    iStop		:  IN      STD_LOGIC;
	 iRd			: IN 		STD_LOGIC;
	 led : out std_LOGIC_VECTOR(7 DOWNTO 0);
	 sState : out std_logic
		);
	END component;
	
		
		BEGIN
		
		Iapp: entity work.app(logic)   
		 port map ( 
			clk=>iclk,
			reset_n   =>reset_n,
			ena  =>ena,
			addr =>addr,
			data_wr  =>data_wr,
			busy    =>busy,
			iSlv_ack1	=>iSlv_ack1,
			iSlv_ack2	=>iSlv_ack2,
			iMstr_ack 	=> iMstr_ack,	
			iStop		=>iStop,
			iRd		=>iRd,
			led => led,
			sState => sState
		  ); 
		 
			temp : process
	begin
		wait for clk_period;
		wait for clk_period;
		iSlv_ack2<='1';
		wait for clk_period;
		iSlv_ack2<='0';
		wait for clk_period;
		iSlv_ack2<='1';
		wait for clk_period;
		busy<='0';
		wait for clk_period;
		iSlv_ack2<='1';
		wait for clk_period;
		iMstr_ack<='1';
		wait for clk_period;
		iRd<='1';
		wait for clk_period;
		iMstr_ack<='1';
		wait for clk_period;
		iStop<='1';
		wait for clk_period;
		iSlv_ack2<='0';
		wait for clk_period;
	end process;
	
			
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
