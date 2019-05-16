LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY app IS
  PORT(
    clk       :  IN      STD_LOGIC;                    
    reset_n   :  IN      STD_LOGIC;                    
    ena       :  OUT      STD_LOGIC;                   
    addr      :  OUT      STD_LOGIC_VECTOR(6 DOWNTO 0); 
    rw        :  OUT      STD_LOGIC;                    
    data_wr  :  OUT      STD_LOGIC_VECTOR(7 DOWNTO 0); 
    busy      :  IN     STD_LOGIC;
    iSlv_ack1		:  IN      STD_LOGIC;					
    iSlv_ack2		:  IN      STD_LOGIC;		--on sort des pins qui rapportent les états dans lesquels on est pour savoir ou on est dans la machine d'état 
    iMstr_ack		:  IN      STD_LOGIC;
    iStop		:  IN      STD_LOGIC;
	 iRd			: IN 		STD_LOGIC;
	 led : out std_LOGIC_VECTOR(7 DOWNTO 0);
	 sState : out std_logic);
END app;

ARCHITECTURE logic OF app IS
	TYPE machine IS(etat1, etat2,etat3, etat4, etat5, etat6, etat7, etat8);
  SIGNAL  state     :  machine;

BEGIN
	sState<='1' when state=etat7 else '0';
	led <= (others => '0');
	PROCESS(clk, reset_n,state)
	BEGIN
	    IF(reset_n = '0') THEN
				ena<='0';
				state<=etat1;
	    ELSIF(clk'EVENT AND clk = '1') THEN
	      CASE state IS
		 WHEN etat1 =>
					addr<="1001000"; 					--
					rw<='0';
					data_wr<="00000001";	
					ena<='1';
					IF(iSlv_ack2='1')
					THEN state<=etat2;
					END IF;
				WHEN etat2 =>
					data_wr<="00100000";
					IF(iSlv_ack2='1')
					THEN state<=etat3;
					END IF;
				WHEN etat3 =>
					ena<='0';
					IF(busy='0')
					THEN state<=etat4;
					END IF;
				WHEN etat4 =>
					data_wr<="00000000";
					rw<='0';
					ena<='1';
					IF(iSlv_ack2='1')
					THEN state<=etat5;
					END IF;
				WHEN etat5 =>
					rw<='1';
					ena<='1';
					IF(iMstr_ack='1')
					THEN state<=etat6;
					END IF;
				WHEN etat6 =>
					IF(iRd='1')
					THEN state<=etat7;
					END IF;
				WHEN etat7 =>
					ena<='0';
					IF(iMstr_ack='1')
					THEN state<=etat8;
					END IF;
				WHEN etat8 =>
					IF(iStop='1')
					THEN state<=etat1;
					END IF;
				WHEN OTHERS =>
					ena<='0';
					state<=etat1;
	      END CASE;    
	    END IF;

       
  END PROCESS;  

END logic;
