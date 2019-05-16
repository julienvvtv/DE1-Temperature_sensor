LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY i2c_master_TB2 IS
END i2c_master_TB2;

ARCHITECTURE beh OF i2c_master_TB2 IS
		signal clk       :    STD_LOGIC :='0';
		signal reset_n   :    STD_LOGIC :='1';
		signal ena       :    STD_LOGIC;                    
		signal addr      :    STD_LOGIC_VECTOR(6 DOWNTO 0); 
		signal rw        :    STD_LOGIC;                    
		signal data_wr   :    STD_LOGIC_VECTOR(7 DOWNTO 0); 
		signal busy      :    STD_LOGIC;                    
		signal data_rd   :    STD_LOGIC_VECTOR(7 DOWNTO 0); 
		signal ack_error :    STD_LOGIC;                    
		signal sda       :    STD_LOGIC;                    
		signal scl       :    STD_LOGIC;
		signal sReady	  :  STD_LOGIC;
		 signal sStart		:  STD_LOGIC;
		 signal sSlv_ack1		:  STD_LOGIC;					
		 signal sSlv_ack2		:  STD_LOGIC;				
		 signal sMstr_ack		:  STD_LOGIC;
		 signal sStop		:  STD_LOGIC;
		 signal sRd			: STD_LOGIC;
		  signal d : STD_LOGIC;
  -- clock period for simulation
  constant clk_period : time := 10 ns;
	
component i2c_master IS
  GENERIC(
	 input_clk :  INTEGER := 50_000_000; 
	 bus_clk   :  INTEGER := 400_000);   
  PORT(
	 clk       :  IN      STD_LOGIC;                    
	 reset_n   :  IN      STD_LOGIC;                    
	 ena       :  IN      STD_LOGIC;                    
	 addr      :  IN      STD_LOGIC_VECTOR(6 DOWNTO 0); 
	 rw        :  IN      STD_LOGIC;                    
	 data_wr   :  IN      STD_LOGIC_VECTOR(7 DOWNTO 0); 
	 busy      :  OUT     STD_LOGIC;                    
	 data_rd   :  OUT     STD_LOGIC_VECTOR(7 DOWNTO 0); 
	 ack_error :  BUFFER  STD_LOGIC;                    
	 oReady	  :  out      STD_LOGIC;
    oStart		:  out      STD_LOGIC;
	 oSlv_ack1		:  out      STD_LOGIC;					
	 oSlv_ack2		:  out      STD_LOGIC;					
	 oMstr_ack		:  out      STD_LOGIC;
	 oStop		:  out      STD_LOGIC;
	 oRd			: out 		STD_LOGIC;
	 sda       :  INOUT   STD_LOGIC;                    
	 scl       :  INOUT   STD_LOGIC);                   
END component;

BEGIN
	DUT : entity work.i2c_master(logic) 
		 port map( clk=> clk, reset_n => reset_n, ena => ena, addr => addr , rw => rw , data_wr => data_wr , busy => busy , data_rd => data_rd ,ack_error => ack_error,
		  oReady=>sReady ,
		  oStart=>sStart ,
		  oSlv_ack1=>sSlv_ack1 ,
		  oSlv_ack2=>sSlv_ack2 ,
		  oMstr_ack=>sMstr_ack ,
		  oStop=>sStop ,
		  oRd=>sRd ,
		  sda => sda ,scl => scl);	
		 
	pCLK: process
	begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
	end process;
	
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
	
	pRESETn: process
	begin
		reset_n <= '1';
		wait for clk_period*5 + clk_period/3;
		reset_n <= '0';
		wait for clk_period;
		reset_n <= '1';
		wait;
	end process;

	temp : process
	begin
		addr<="1001000"; 						--
		rw<='0';
		data_wr<="00000001";	
		ena<='1';							--réglage de la résolution
		wait until sSlv_ack2='1';
		data_wr<="00100000";
		wait until sSlv_ack2='1';		
		ena<='0';							--
		wait until busy='0';
		data_wr<="00000000";
		rw<='0';
		ena<='1';							--on demande de nous envoyer la temperature
		wait until sSlv_ack2='1';
		rw<='1';								--on commence la lecture 
		ena<='1';
		wait until sMstr_ack='1';
		wait until sRd='1';
		ena<='0';				--on boucle 2 fois pour avoir les 16 bits
		wait until sMstr_ack='1';
		wait until sStop='1';
	end process;
		
END beh;
