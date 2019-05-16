LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY appdriver IS
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
	 appscl       :  inOUT   STD_LOGIC						 
	 );
END appdriver;

ARCHITECTURE structure OF appdriver IS
	-- test 	s
		signal ena       :    STD_LOGIC;                    
		signal addr      :    STD_LOGIC_VECTOR(6 DOWNTO 0); 
		signal rw        :    STD_LOGIC;                    
		signal data_wr   :    STD_LOGIC_VECTOR(7 DOWNTO 0); 
		signal busy      :    STD_LOGIC;                    
		signal data_rd   :    STD_LOGIC_VECTOR(7 DOWNTO 0); 
		signal ack_error :    STD_LOGIC;                    
		signal sReady	  :  STD_LOGIC;
	   signal sStart		:  STD_LOGIC;
		signal sSlv_ack1		:  STD_LOGIC;					
		signal sSlv_ack2		:  STD_LOGIC;					
		signal sMstr_ack		:  STD_LOGIC;
		signal sStop		:  STD_LOGIC;
		signal sRd			: STD_LOGIC;
		signal sSda : std_logic;
		signal sScl : std_logic;
		signal sled : std_logic_vector(7 downto 0);
		signal signalState : std_logic;

	component app IS
	  PORT(
		 clk       :  IN      STD_LOGIC;                    
		 reset_n   :  IN      STD_LOGIC;                    
		 ena       :  OUT      STD_LOGIC;                    
		 addr      :  OUT      STD_LOGIC_VECTOR(6 DOWNTO 0); 
		 rw        :  OUT      STD_LOGIC;                    
		 data_wr   :  OUT      STD_LOGIC_VECTOR(7 DOWNTO 0); 
		 busy      :  IN     STD_LOGIC;                    
		 iSlv_ack1		:  IN      STD_LOGIC;					
		 iSlv_ack2		:  IN      STD_LOGIC;				
		 iMstr_ack		:  IN      STD_LOGIC;
		 iStop		:  IN      STD_LOGIC;
		 iRd			: IN 		STD_LOGIC;
		 led : out std_LOGIC_VECTOR(7 DOWNTO 0);
		 sState : out std_logic);
	END component;

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
		
		IApp: entity work.app(logic)  
		 port map( clk=> iclk, 
		 reset_n => reset_n, 
		 ena => ena, 
		 addr => addr , 
		 rw => rw , 
		 data_wr => data_wr , 
		 busy => busy ,
  		  iSlv_ack1=>sSlv_ack1 ,
		  iSlv_ack2=>sSlv_ack2 ,
		  iMstr_ack=>sMstr_ack ,
		  iStop=>sStop ,
		  iRd=>sRd,
		  sState=>signalState);
		  
		I2Cdriver : entity work.i2c_master(logic) 
		 port map( 
			clk=> iclk, 
			reset_n => reset_n, 
			ena => ena, 
			addr => addr , 
			rw => rw , 
			data_wr => data_wr , 
			busy => busy , 
			data_rd => sled ,
			ack_error => ack_error,
				  oReady=>oReady ,
				  oStart=>oStart ,
				  oSlv_ack1=>sSlv_ack1 ,
				  oSlv_ack2=>sSlv_ack2 ,
				  oMstr_ack=>sMstr_ack ,
				  oStop=>sStop ,
				  oRd=>sRd ,
				  sda => appsda,
				  scl => appscl
		  );	 
			oSlv_ack1<=sSlv_ack1 ; 
			oSlv_ack2<=sSlv_ack2 ;
		  oMstr_ack<=sMstr_ack ;
		  oStop<=sStop ;
		  oRd<=sRd;
		  led<=sled when signalState='1' else "00000000";
	

END structure;