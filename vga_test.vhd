library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity vga_test is
    port(
        res        : in std_logic;
        L,R,U,D    : in std_logic;
        clk100MHz     : in  std_logic;
        hsync,vsync    : out std_logic;
        red,green,blue : out std_logic_vector(3 downto 0);
        led : out STD_LOGIC_VECTOR (7 downto 0);
        rand : in STD_LOGIC_VECTOR (7 downto 0);
        ssd : out STD_LOGIC_VECTOR (6 downto 0);
        ssdcat : out STD_LOGIC
    );
end vga_test;

architecture vga_test_arch of vga_test is

-- row constants
constant H_TOTAL: integer:=800-1;
constant H_SYNC: integer:=96-1;
constant H_BACK: integer:=48-1;
constant H_START: integer:=96+48-1;
constant H_ACTIVE: integer:=640-1;
constant H_END: integer:=800-16-1;
constant H_FRONT: integer:=16-1;

-- column constants
constant V_TOTAL: integer:=524-1;
constant V_SYNC: integer:=2-1;
constant V_BACK: integer:=31-1;
constant V_START: integer:=2+31-1;
constant V_ACTIVE: integer:=480-1;
constant V_END: integer:=524-11-1;
constant V_FRONT: integer:=11-1;

type state_type is (s0,s1,s2,s3,s4);
signal g_state : state_type :=s0;
signal check,clk50MHz, clk25MHz,clk8Hz, clk1Hz ,clk2Hz,clk4Hz,clk16Hz,clk32Hz,ms_pulse :std_logic;
signal check_1,check_2,check_3,check_4,check_5,check_6,check_7,check_8,check_2_1,check_2_2,check_2_3,check_2_4,check_2_5,check_2_6,check_2_7,check_2_8,check_2_9,check_2_10,check_2_11,check_2_12,check_2_13,check_2_14,check_2_15,check_2_16,check_2_17,check_2_18,check_3_1,check_3_2,check_3_3,check_3_4,check_3_5,check_3_6,check_3_7,check_3_8,check_3_9,check_3_10,check_3_11,check_3_12,check_3_13,check_3_14,check_3_15,check_3_16,check_3_17,check_3_18,check_3_19,check_3_20,check_3_21,check_3_22,randcheck,game_over,ena1,ena2,ena3,ena4,ena5,ena6,ena7,ena8,ena_c_1,ena_c_2,ena_c_3,ena_c_4,ena_c_5,ena_c_6,ena_c_7,ena_c_8,con1,con2,con3,con4,con5,con6,con7,con8:std_logic :='0';
signal ena_2_1,ena_2_2,ena_2_3,ena_2_4,ena_2_5,ena_2_6,ena_2_7,ena_2_8,ena_2_9,ena_2_10,ena_2_11,ena_2_12,ena_2_13,ena_2_14,ena_2_15,ena_2_16,ena_2_17,ena_2_18,ena_2_c_1,ena_2_c_2,ena_2_c_3,ena_2_c_4,ena_2_c_5,ena_2_c_6,ena_2_c_7,ena_2_c_8,ena_2_c_9,ena_2_c_10,ena_2_c_11,ena_2_c_12,ena_2_c_13,ena_2_c_14,ena_2_c_15,ena_2_c_16,ena_2_c_17,ena_2_c_18,con_2_1,con_2_2,con_2_3,con_2_4,con_2_5,con_2_6,con_2_7,con_2_8,con_2_9,con_2_10,con_2_11,con_2_12,con_2_13,con_2_14,con_2_15,con_2_16,con_2_17,con_2_18:std_logic :='0';
signal ena_3_1,ena_3_2,ena_3_3,ena_3_4,ena_3_5,ena_3_6,ena_3_7,ena_3_8,ena_3_9,ena_3_10,ena_3_11,ena_3_12,ena_3_13,ena_3_14,ena_3_15,ena_3_16,ena_3_17,ena_3_18,ena_3_19,ena_3_20,ena_3_21,ena_3_22,ena_3_c_1,ena_3_c_2,ena_3_c_3,ena_3_c_4,ena_3_c_5,ena_3_c_6,ena_3_c_7,ena_3_c_8,ena_3_c_9,ena_3_c_10,ena_3_c_11,ena_3_c_12,ena_3_c_13,ena_3_c_14,ena_3_c_15,ena_3_c_16,ena_3_c_17,ena_3_c_18,ena_3_c_19,ena_3_c_20,ena_3_c_21,ena_3_c_22,con_3_1,con_3_2,con_3_3,con_3_4,con_3_5,con_3_6,con_3_7,con_3_8,con_3_9,con_3_10,con_3_11,con_3_12,con_3_13,con_3_14,con_3_15,con_3_16,con_3_17,con_3_18,con_3_19,con_3_20,con_3_21,con_3_22:std_logic :='0';
signal hcount, vcount: std_logic_vector(11 downto 0);
signal lifecount,ssdcount,ledcount,sec_count,gen_count,gen_count_2,gen_count_3, count,ms_count: integer :=0;
signal rand_num1_x,rand_num1_y,rand_num2_x,rand_num2_y,rand_num3_x,rand_num4_y,rand_num5_y,rand_num5_x,rand_num6_x,rand_num6_y,rand_num7_x,rand_num8_y: integer :=40;
signal rand_num3_y,rand_num7_y: integer := 440;
signal rand_num4_x,rand_num8_x: integer := 600;
signal rand_2_num1_x,rand_2_num1_y,rand_2_num17_x,rand_2_num17_y,rand_2_num13_x,rand_2_num13_y,rand_2_num18_x,rand_2_num18_y,rand_2_num9_x,rand_2_num9_y,rand_2_num2_x,rand_2_num2_y,rand_2_num14_x,rand_2_num14_y,rand_2_num10_x,rand_2_num10_y,rand_2_num3_x,rand_2_num15_x,rand_2_num11_x,rand_2_num4_y,rand_2_num16_y,rand_2_num5_y,rand_2_num5_x,rand_2_num6_x,rand_2_num6_y,rand_2_num7_x,rand_2_num8_y,rand_2_num12_y: integer :=40;
signal rand_2_num3_y,rand_2_num15_y,rand_2_num11_y,rand_2_num7_y: integer := 440;
signal rand_2_num4_x,rand_2_num16_x,rand_2_num8_x,rand_2_num12_x: integer := 600;
signal rand_3_num1_x,rand_3_num1_y,rand_3_num21_x,rand_3_num21_y,rand_3_num17_x,rand_3_num17_y,rand_3_num9_x,rand_3_num9_y,rand_3_num2_x,rand_3_num2_y,rand_3_num22_x,rand_3_num22_y,rand_3_num18_x,rand_3_num18_y,rand_3_num10_x,rand_3_num10_y,rand_3_num3_x,rand_3_num19_x,rand_3_num15_x,rand_3_num11_x,rand_3_num4_y,rand_3_num20_y,rand_3_num16_y,rand_3_num12_y,rand_3_num5_y,rand_3_num5_x,rand_3_num13_y,rand_3_num13_x,rand_3_num6_x,rand_3_num6_y,rand_3_num14_x,rand_3_num14_y,rand_3_num7_x,rand_3_num8_y: integer :=40;
signal rand_3_num3_y,rand_3_num19_y,rand_3_num15_y,rand_3_num11_y,rand_3_num7_y: integer := 440;
signal rand_3_num4_x,rand_3_num20_x,rand_3_num16_x,rand_3_num12_x,rand_3_num8_x: integer := 600;
signal ori_x: integer := 320;
signal ori_y: integer := 240;
signal lfsr: std_logic_vector (8 downto 0);
signal feedback,snDRec : std_logic;
signal counter_vec: std_logic_vector (7 downto 0);
signal jstkData,sndData: std_logic_vector (39 downto 0);
signal xpos,ypos:std_logic_vector (9 downto 0);
signal digit: integer;
signal x,y: integer:=512;

begin

-- generate 50MHz clock
vga_clk_gen_proc1: process(clk100MHz,res)
begin
    if(res='1')then
        clk50MHz<='0';
        sec_count<=0;
        ms_count<=0;
        ms_pulse<='0';
        clk32Hz<='0';
    elsif( rising_edge(clk100MHz) ) then
        clk50MHz <= not clk50MHz;
        if(sec_count =1562499) then
            clk32Hz <= not clk32Hz;
            sec_count <=0;
         else
           sec_count <=sec_count+1;
        end if;
        if (ms_count=99999) then
         ms_pulse <= not ms_pulse;
         ms_count<=0;
        else
         ms_count<=ms_count+1;
        end if;
    end if;
end process vga_clk_gen_proc1;

vga_clk_gen_proc7: process(clk32Hz,res)
    begin
       if(res='1')then
        clk16Hz<='0';
        randcheck<='0';
        elsif( rising_edge(clk32Hz) ) then
            clk16Hz <= not clk16Hz;
           if(randcheck='0') then
              lfsr<='0' & rand(7 downto 0);
              randcheck<='1';
            else
            lfsr <= lfsr(7 downto 0) & feedback;
           end if;
        end if;
end process vga_clk_gen_proc7;
   
vga_clk_gen_proc6: process(clk16Hz,res)
begin
    if(res='1')then
     clk8Hz<='0';
     gen_count_3<=0;
     ena_3_1<='0';
		 ena_3_2<='0';
		 ena_3_3<='0';
		 ena_3_4<='0';
		 ena_3_5<='0';
		 ena_3_6<='0';
		 ena_3_7<='0';
		 ena_3_8<='0';
		 ena_3_9<='0';
		 ena_3_10<='0';
		 ena_3_11<='0';
		 ena_3_12<='0';
		 ena_3_13<='0';
		 ena_3_14<='0';
		 ena_3_15<='0';
		 ena_3_16<='0';
		 ena_3_17<='0';
		 ena_3_18<='0';
		 ena_3_19<='0';
		 ena_3_20<='0';
		 ena_3_21<='0';
		 ena_3_22<='0';
		 rand_3_num1_x<=40;
		 rand_3_num1_y<=40;
		 rand_3_num2_x<=40;
		 rand_3_num2_y<=40;
		 rand_3_num3_x<=40;
		 rand_3_num3_y<=440;
		 rand_3_num4_x<=600;
		 rand_3_num4_y<=40;
		 rand_3_num5_x<=40;
		 rand_3_num5_y<=40;
		 rand_3_num6_x<=40;
		 rand_3_num6_y<=40;
		 rand_3_num7_y<=440;
		 rand_3_num7_x<=40;
		 rand_3_num8_x<=600;
		 rand_3_num8_y<=40;
		 rand_3_num9_x<=40;
		 rand_3_num9_y<=40;
		 rand_3_num10_x<=40;
		 rand_3_num10_y<=40;
		 rand_3_num11_y<=440;
		 rand_3_num11_x<=40;
		 rand_3_num12_x<=600;
		 rand_3_num12_x<=40;
		 rand_3_num13_x<=40;
		 rand_3_num13_y<=40;
		 rand_3_num14_x<=40;
		 rand_3_num14_y<=40;
		 rand_3_num15_y<=440;
		 rand_3_num15_x<=40;
		 rand_3_num16_x<=600;
		 rand_3_num16_y<=40;
		 rand_3_num17_x<=40;
		 rand_3_num17_y<=40;
		 rand_3_num18_x<=40;
		 rand_3_num18_y<=40;
		 rand_3_num19_y<=440;
		 rand_3_num19_x<=40;
		 rand_3_num20_x<=600;
		 rand_3_num20_x<=40;
		 rand_3_num21_x<=40;
		 rand_3_num21_y<=40;
		 rand_3_num22_x<=40;
		 rand_3_num22_y<=40;
		 con_3_1<='0';
		 con_3_2<='0';
		 con_3_3<='0';
		 con_3_4<='0';
		 con_3_5<='0';
		 con_3_6<='0';
		 con_3_7<='0';
		 con_3_8<='0';
		 con_3_9<='0';
		 con_3_10<='0';
		 con_3_11<='0';
		 con_3_12<='0';
		 con_3_13<='0';
		 con_3_14<='0';
		 con_3_15<='0';
		 		 con_3_16<='0';
		 		 con_3_17<='0';
		 		 con_3_18<='0';
		 		 con_3_19<='0';
		 		 con_3_20<='0';
		 		 con_3_21<='0';
		 		 con_3_22<='0';
    elsif( rising_edge(clk16Hz) ) then
      clk8Hz <= not clk8Hz;
        if(g_state=s3) then
    				if(gen_count_3=0) then
    					 rand_3_num1_x<=to_integer(unsigned(lfsr));
    					 ena_3_1<= '1';
    				elsif(ena_3_1='1' and gen_count_3=1) then
    									if(rand_3_num1_x < 40) then
    									 rand_3_num1_x<=40;
    									 elsif(rand_3_num1_x>320) then
    										con_3_1<='1';
    									 end if;
    				 elsif(gen_count_3>1) then
    									if(con_3_1='1') then
    									 rand_3_num1_x<=rand_3_num1_x-5;
    									 rand_3_num1_y<=rand_3_num1_y+5;
    									else
    									 rand_3_num1_x<=rand_3_num1_x+5;
    									 rand_3_num1_y<=rand_3_num1_y+5;
    									end if;
    									if(rand_3_num1_x>600 or rand_3_num1_x<40 or rand_3_num1_y>440 or rand_3_num1_y<40) then
    										ena_3_1<='0';
    									end if;
    								end if;
    				if(gen_count_3=5) then
    					 rand_3_num2_y<=to_integer(unsigned(lfsr));
    					 ena_3_2<= '1';
    			 	elsif(ena_3_2='1' and gen_count_3=6) then
    										if(rand_3_num2_y > 430) then
    									 rand_3_num2_y<=430;
    									 con_3_2<='1';
    									 elsif(rand_3_num2_y < 40) then
    										rand_3_num2_y<=40;
    									 elsif(rand_3_num2_y>240) then
    									 con_3_2<='1';
    									 end if;
    						elsif (gen_count_3>6) then
    									if(con_3_2='1') then
    									 rand_3_num2_x<=rand_3_num2_x+5;
    									 rand_3_num2_y<=rand_3_num2_y-3;
    									else
    									 rand_3_num2_x<=rand_3_num2_x+5;
    									 rand_3_num2_y<=rand_3_num2_y+3;
    									end if;
    									if(rand_3_num2_x>600 or rand_3_num2_x<40 or rand_3_num2_y>440 or rand_3_num2_y<40) then
    										ena_3_2<='0';
    									end if;
    						end if;
    				if(gen_count_3=10) then
    						rand_3_num3_x<=to_integer(unsigned(lfsr));
    						ena_3_3<= '1';
    				 elsif(ena_3_3='1' and gen_count_3=11) then
    										 if(rand_3_num3_x < 40) then
    											rand_3_num3_x<=40;
    											 elsif(rand_3_num3_x>320) then
    											 con_3_3<='1';
    											 end if;
    						 elsif(gen_count_3>11) then
    										if(con_3_3='1') then
    										 rand_3_num3_x<=rand_3_num3_x-5;
    										rand_3_num3_y<=rand_3_num3_y-5;
    										else
    									 rand_3_num3_x<=rand_3_num3_x+5;
    									 rand_3_num3_y<=rand_3_num3_y-5;
    									 end if;
    							if(rand_3_num3_x>600 or rand_3_num3_x<40 or rand_3_num3_y>440 or rand_3_num3_y<40) then
    									ena_3_3<='0';
    								 end if;
    							 end if;
    				 if(gen_count_3=15) then
    						 rand_3_num4_y<=to_integer(unsigned(lfsr));
    						 ena_3_4<= '1';
    						elsif(ena_3_4='1' and gen_count_3=16) then
    											if(rand_3_num4_y > 430) then
    												rand_3_num4_y<=430;
    												con_3_4<='1';
    										 elsif(rand_3_num4_y < 40) then
    										 rand_3_num4_y<=40;
    											 elsif(rand_3_num4_y>240) then
    											 con_3_4<='1';
    											end if;
    							elsif(gen_count_3>16) then
    									 if(con_3_4='1') then
    										 rand_3_num4_x<=rand_3_num4_x-5;
    									 rand_3_num4_y<=rand_3_num4_y-3;
    										else
    									 rand_3_num4_x<=rand_3_num4_x-5;
    									 rand_3_num4_y<=rand_3_num4_y+3;
    									 end if;
    									 if(rand_3_num4_x>600 or rand_3_num4_x<40 or rand_3_num4_y>440 or rand_3_num4_y<40) then
    									 ena_3_4<='0';
    								 end if;
    						 end if;
    					 if(gen_count_3=20) then
    							rand_3_num5_x<=to_integer(unsigned(lfsr));
    							ena_3_5<= '1';
    					elsif(ena_3_5='1' and gen_count_3=21) then
    									if(rand_3_num5_x < 40) then
    									rand_3_num5_x<=40;
    								 elsif(rand_3_num5_x>320) then
    										con_3_5<='1';
    									 end if;
    					 elsif(gen_count_3>21) then
    							if(con_3_5='1') then
    							 rand_3_num5_x<=rand_3_num5_x-5;
    							 rand_3_num5_y<=rand_3_num5_y+5;
    								else
    								rand_3_num5_x<=rand_3_num5_x+5;
    							 rand_3_num5_y<=rand_3_num5_y+5;
    								 end if;
    								if(rand_3_num5_x>600 or rand_3_num5_x<40 or rand_3_num5_y>440 or rand_3_num5_y<40) then
    								ena_3_5<='0';
    								end if; 
    						end if;
    					if(gen_count_3=25) then
    									rand_3_num6_y<=to_integer(unsigned(lfsr));
    									ena_3_6<= '1';
    							 elsif(ena_3_6='1' and gen_count_3=26) then
    										 if(rand_3_num6_y > 430) then
    										rand_3_num6_y<=430;
    										con_3_6<='1';
    										elsif(rand_3_num6_y < 40) then
    										 rand_3_num6_y<=40;
    										elsif(rand_3_num6_y>240) then
    										con_3_6<='1';
    										end if;
    							elsif (gen_count_3>26) then
    							if(con_3_6='1') then
    							 rand_3_num6_x<=rand_3_num6_x+5;
    							 rand_3_num6_y<=rand_3_num6_y-3;
    							else
    							 rand_3_num6_x<=rand_3_num6_x+5;
    							 rand_3_num6_y<=rand_3_num6_y+3;
    							end if;
    							if(rand_3_num6_x>600 or rand_3_num6_x<40 or rand_3_num6_y>440 or rand_3_num6_y<40) then
    								ena_3_6<='0';
    							end if;
    						end if;
    					 if(gen_count_3=30) then
    								rand_3_num7_x<=to_integer(unsigned(lfsr));
    								ena_3_7<= '1';
    								 elsif(ena_3_7='1' and gen_count_3=31) then
    										 if(rand_3_num7_x < 40) then
    											rand_3_num7_x<=40;
    											 elsif(rand_3_num7_x>320) then
    											 con_3_7<='1';
    											 end if;
    								 elsif(gen_count_3>31) then
    												if(con_3_7='1') then
    												 rand_3_num7_x<=rand_3_num7_x-5;
    												rand_3_num7_y<=rand_3_num7_y-5;
    												else
    											 rand_3_num7_x<=rand_3_num7_x+5;
    											 rand_3_num7_y<=rand_3_num7_y-5;
    											 end if;
    									if(rand_3_num7_x>600 or rand_3_num7_x<40 or rand_3_num7_y>440 or rand_3_num7_y<40) then
    											ena_3_7<='0';
    							 end if;
    						 end if;
    						if(gen_count_3=35) then
    								rand_3_num8_y<=to_integer(unsigned(lfsr));
    								ena_3_8<= '1';
    							 elsif(ena_3_8='1' and gen_count_3=36) then
    												if(rand_3_num8_y > 430) then
    												con_3_8<='1';
    													rand_3_num8_y<=430;
    											 elsif(rand_3_num8_y < 40) then
    											 rand_3_num8_y<=40;
    												 elsif(rand_3_num8_y>240) then
    												 con_3_8<='1';
    												end if;
    								 elsif(gen_count_3>36) then
    											if(con_3_8='1') then
    												rand_3_num8_x<=rand_3_num8_x-5;
    											rand_3_num8_y<=rand_3_num8_y-3;
    											 else
    											rand_3_num8_x<=rand_3_num8_x-5;
    											rand_3_num8_y<=rand_3_num8_y+3;
    											end if;
    											if(rand_3_num8_x>600 or rand_3_num8_x<40 or rand_3_num8_y>440 or rand_3_num8_y<40) then
    											ena_3_8<='0';
    										end if;
    								end if;
    						if(gen_count_3=40) then
										rand_3_num9_x<=to_integer(unsigned(lfsr));
										ena_3_9<= '1';
								elsif(ena_3_9='1' and gen_count_3=41) then
												if(rand_3_num9_x < 40) then
												rand_3_num9_x<=40;
											 elsif(rand_3_num9_x>320) then
													con_3_9<='1';
												 end if;
								 elsif(gen_count_3>41) then
										if(con_3_9='1') then
										 rand_3_num9_x<=rand_3_num9_x-5;
										 rand_3_num9_y<=rand_3_num9_y+5;
											else
											rand_3_num9_x<=rand_3_num9_x+5;
										 rand_3_num9_y<=rand_3_num9_y+5;
											 end if;
											if(rand_3_num9_x>600 or rand_3_num9_x<40 or rand_3_num9_y>440 or rand_3_num9_y<40) then
											ena_3_9<='0';
											end if; 
									end if;
							 if(gen_count_3=45) then
											rand_3_num10_y<=to_integer(unsigned(lfsr));
											ena_3_10<= '1';
									 elsif(ena_3_10='1' and gen_count_3=46) then
												 if(rand_3_num10_y > 430) then
												rand_3_num10_y<=430;
												con_3_10<='1';
												elsif(rand_3_num10_y < 40) then
												 rand_3_num10_y<=40;
												elsif(rand_3_num10_y>240) then
												con_3_10<='1';
												end if;
									elsif (gen_count_3>46) then
									if(con_3_10='1') then
									 rand_3_num10_x<=rand_3_num10_x+5;
									 rand_3_num10_y<=rand_3_num10_y-3;
									else
									 rand_3_num10_x<=rand_3_num10_x+5;
									 rand_3_num10_y<=rand_3_num10_y+3;
									end if;
									if(rand_3_num10_x>600 or rand_3_num10_x<40 or rand_3_num10_y>440 or rand_3_num10_y<40) then
										ena_3_10<='0';
									end if;
								end if;
							 if(gen_count_3=50) then
									rand_3_num11_x<=to_integer(unsigned(lfsr));
									ena_3_11<= '1';
									 elsif(ena_3_11='1' and gen_count_3=51) then
											 if(rand_3_num11_x < 40) then
												rand_3_num11_x<=40;
												 elsif(rand_3_num11_x>320) then
												 con_3_11<='1';
												 end if;
									 elsif(gen_count_3>51) then
													if(con_3_11='1') then
													 rand_3_num11_x<=rand_3_num11_x-5;
													rand_3_num11_y<=rand_3_num11_y-5;
													else
												 rand_3_num11_x<=rand_3_num11_x+5;
												 rand_3_num11_y<=rand_3_num11_y-5;
												 end if;
										if(rand_3_num11_x>600 or rand_3_num11_x<40 or rand_3_num11_y>440 or rand_3_num11_y<40) then
												ena_3_11<='0';
								 end if;
							 end if;
							 if(gen_count_3=55) then
									rand_3_num12_y<=to_integer(unsigned(lfsr));
									ena_3_12<= '1';
								 elsif(ena_3_12='1' and gen_count_3=56) then
													if(rand_3_num12_y > 430) then
													con_3_12<='1';
														rand_3_num12_y<=430;
												 elsif(rand_3_num12_y < 40) then
												 rand_3_num12_y<=40;
													 elsif(rand_3_num12_y>240) then
													 con_3_12<='1';
													end if;
									 elsif(gen_count_3>56) then
												if(con_3_12='1') then
													rand_3_num12_x<=rand_3_num12_x-5;
												rand_3_num12_y<=rand_3_num12_y-3;
												 else
												rand_3_num12_x<=rand_3_num12_x-5;
												rand_3_num12_y<=rand_3_num12_y+3;
												end if;
												if(rand_3_num12_x>600 or rand_3_num12_x<40 or rand_3_num12_y>440 or rand_3_num12_y<40) then
												ena_3_12<='0';
											end if;
									end if;
								if(gen_count_3=60) then
											rand_3_num13_x<=to_integer(unsigned(lfsr));
											ena_3_13<= '1';
									elsif(ena_3_13='1' and gen_count_3=61) then
													if(rand_3_num13_x < 40) then
													rand_3_num13_x<=40;
												 elsif(rand_3_num13_x>320) then
														con_3_13<='1';
													 end if;
									 elsif(gen_count_3>61) then
											if(con_3_13='1') then
											 rand_3_num13_x<=rand_3_num13_x-5;
											 rand_3_num13_y<=rand_3_num13_y+5;
												else
												rand_3_num13_x<=rand_3_num13_x+5;
											 rand_3_num13_y<=rand_3_num13_y+5;
												 end if;
												if(rand_3_num13_x>600 or rand_3_num13_x<40 or rand_3_num13_y>440 or rand_3_num13_y<40) then
												ena_3_13<='0';
												end if; 
										end if;
							 if(gen_count_3=65) then
											rand_3_num14_y<=to_integer(unsigned(lfsr));
											ena_3_14<= '1';
									 elsif(ena_3_14='1' and gen_count_3=66) then
												 if(rand_3_num14_y > 430) then
												rand_3_num14_y<=430;
												con_3_14<='1';
												elsif(rand_3_num14_y < 40) then
												 rand_3_num14_y<=40;
												elsif(rand_3_num14_y>240) then
												con_3_14<='1';
												end if;
									elsif (gen_count_3>66) then
									if(con_3_14='1') then
									 rand_3_num14_x<=rand_3_num14_x+5;
									 rand_3_num14_y<=rand_3_num14_y-3;
									else
									 rand_3_num14_x<=rand_3_num14_x+5;
									 rand_3_num14_y<=rand_3_num14_y+3;
									end if;
									if(rand_3_num14_x>600 or rand_3_num14_x<40 or rand_3_num14_y>440 or rand_3_num14_y<40) then
										ena_3_14<='0';
									end if;
								end if;
						if(gen_count_3=70) then
													rand_3_num15_x<=to_integer(unsigned(lfsr));
													ena_3_15<= '1';
													 elsif(ena_3_15='1' and gen_count_3=71) then
															 if(rand_3_num15_x < 40) then
																rand_3_num15_x<=40;
																 elsif(rand_3_num15_x>320) then
																 con_3_15<='1';
																 end if;
													 elsif(gen_count_3>71) then
																	if(con_3_15='1') then
																	 rand_3_num15_x<=rand_3_num15_x-5;
																	rand_3_num15_y<=rand_3_num15_y-5;
																	else
																 rand_3_num15_x<=rand_3_num15_x+5;
																 rand_3_num15_y<=rand_3_num15_y-5;
																 end if;
														if(rand_3_num15_x>600 or rand_3_num15_x<40 or rand_3_num15_y>440 or rand_3_num15_y<40) then
																ena_3_15<='0';
												 end if;
											 end if;
											if(gen_count_3=75) then
													rand_3_num16_y<=to_integer(unsigned(lfsr));
													ena_3_16<= '1';
												 elsif(ena_3_16='1' and gen_count_3=76) then
																	if(rand_3_num16_y > 430) then
																	con_3_16<='1';
																		rand_3_num16_y<=430;
																 elsif(rand_3_num16_y < 40) then
																 rand_3_num16_y<=40;
																	 elsif(rand_3_num16_y>240) then
																	 con_3_16<='1';
																	end if;
													 elsif(gen_count_3>76) then
																if(con_3_16='1') then
																	rand_3_num16_x<=rand_3_num16_x-5;
																rand_3_num16_y<=rand_3_num16_y-3;
																 else
																rand_3_num16_x<=rand_3_num16_x-5;
																rand_3_num16_y<=rand_3_num16_y+3;
																end if;
																if(rand_3_num16_x>600 or rand_3_num16_x<40 or rand_3_num16_y>440 or rand_3_num16_y<40) then
																ena_3_16<='0';
															end if;
													end if;
											if(gen_count_3=80) then
													rand_3_num17_x<=to_integer(unsigned(lfsr));
													ena_3_17<= '1';
											elsif(ena_3_17='1' and gen_count_3=81) then
															if(rand_3_num17_x < 40) then
															rand_3_num17_x<=40;
														 elsif(rand_3_num17_x>320) then
																con_3_17<='1';
															 end if;
											 elsif(gen_count_3>81) then
													if(con_3_17='1') then
													 rand_3_num17_x<=rand_3_num17_x-5;
													 rand_3_num17_y<=rand_3_num17_y+5;
														else
														rand_3_num17_x<=rand_3_num17_x+5;
													 rand_3_num17_y<=rand_3_num17_y+5;
														 end if;
														if(rand_3_num17_x>600 or rand_3_num17_x<40 or rand_3_num17_y>440 or rand_3_num17_y<40) then
														ena_3_17<='0';
														end if; 
												end if;
										 if(gen_count_3=85) then
														rand_3_num18_y<=to_integer(unsigned(lfsr));
														ena_3_18<= '1';
												 elsif(ena_3_18='1' and gen_count_3=86) then
															 if(rand_3_num18_y > 430) then
															rand_3_num18_y<=430;
															con_3_18<='1';
															elsif(rand_3_num18_y < 40) then
															 rand_3_num18_y<=40;
															elsif(rand_3_num18_y>240) then
															con_3_18<='1';
															end if;
												elsif (gen_count_3>86) then
												if(con_3_18='1') then
												 rand_3_num18_x<=rand_3_num18_x+5;
												 rand_3_num18_y<=rand_3_num18_y-3;
												else
												 rand_3_num18_x<=rand_3_num18_x+5;
												 rand_3_num18_y<=rand_3_num18_y+3;
												end if;
												if(rand_3_num18_x>600 or rand_3_num18_x<40 or rand_3_num18_y>440 or rand_3_num18_y<40) then
													ena_3_18<='0';
												end if;
											end if;
										 if(gen_count_3=90) then
												rand_3_num19_x<=to_integer(unsigned(lfsr));
												ena_3_19<= '1';
												 elsif(ena_3_19='1' and gen_count_3=91) then
														 if(rand_3_num19_x < 40) then
															rand_3_num19_x<=40;
															 elsif(rand_3_num19_x>320) then
															 con_3_19<='1';
															 end if;
												 elsif(gen_count_3>91) then
																if(con_3_19='1') then
																 rand_3_num19_x<=rand_3_num19_x-5;
																rand_3_num19_y<=rand_3_num19_y-5;
																else
															 rand_3_num19_x<=rand_3_num19_x+5;
															 rand_3_num19_y<=rand_3_num19_y-5;
															 end if;
													if(rand_3_num19_x>600 or rand_3_num19_x<40 or rand_3_num19_y>440 or rand_3_num19_y<40) then
															ena_3_19<='0';
											 end if;
										 end if;
										 if(gen_count_3=95) then
												rand_3_num20_y<=to_integer(unsigned(lfsr));
												ena_3_20<= '1';
											 elsif(ena_3_20='1' and gen_count_3=96) then
																if(rand_3_num20_y > 430) then
																con_3_20<='1';
																	rand_3_num20_y<=430;
															 elsif(rand_3_num20_y < 40) then
															 rand_3_num20_y<=40;
																 elsif(rand_3_num20_y>240) then
																 con_3_20<='1';
																end if;
												 elsif(gen_count_3>96) then
															if(con_3_20='1') then
																rand_3_num20_x<=rand_3_num20_x-5;
															rand_3_num20_y<=rand_3_num20_y-3;
															 else
															rand_3_num20_x<=rand_3_num20_x-5;
															rand_3_num20_y<=rand_3_num20_y+3;
															end if;
															if(rand_3_num20_x>600 or rand_3_num20_x<40 or rand_3_num20_y>440 or rand_3_num20_y<40) then
															ena_3_20<='0';
														end if;
												end if;
											if(gen_count_3=100) then
														rand_3_num21_x<=to_integer(unsigned(lfsr));
														ena_3_21<= '1';
												elsif(ena_3_21='1' and gen_count_3=101) then
																if(rand_3_num21_x < 40) then
																rand_3_num21_x<=40;
															 elsif(rand_3_num21_x>320) then
																	con_3_21<='1';
																 end if;
												 elsif(gen_count_3>101) then
														if(con_3_21='1') then
														 rand_3_num21_x<=rand_3_num21_x-5;
														 rand_3_num21_y<=rand_3_num21_y+5;
															else
															rand_3_num21_x<=rand_3_num21_x+5;
														 rand_3_num21_y<=rand_3_num21_y+5;
															 end if;
															if(rand_3_num21_x>600 or rand_3_num21_x<40 or rand_3_num21_y>440 or rand_3_num21_y<40) then
															ena_3_21<='0';
															end if; 
													end if;
										 if(gen_count_3=105) then
														rand_3_num22_y<=to_integer(unsigned(lfsr));
														ena_3_22<= '1';
												 elsif(ena_3_22='1' and gen_count_3=106) then
															 if(rand_3_num22_y > 430) then
															rand_3_num22_y<=430;
															con_3_22<='1';
															elsif(rand_3_num22_y < 40) then
															 rand_3_num22_y<=40;
															elsif(rand_3_num22_y>240) then
															con_3_22<='1';
															end if;
												elsif (gen_count_3>106) then
												if(con_3_22='1') then
												 rand_3_num22_x<=rand_3_num22_x+5;
												 rand_3_num22_y<=rand_3_num22_y-3;
												else
												 rand_3_num22_x<=rand_3_num22_x+5;
												 rand_3_num22_y<=rand_3_num22_y+3;
												end if;
												if(rand_3_num22_x>600 or rand_3_num22_x<40 or rand_3_num22_y>440 or rand_3_num22_y<40) then
													ena_3_22<='0';
												end if;
											end if;
    				gen_count_3<=gen_count_3+1;
    			else
    					 ena_3_1<='0';
    					 ena_3_2<='0';
    					 ena_3_3<='0';
    					 ena_3_4<='0';
    					 ena_3_5<='0';
    					 ena_3_6<='0';
    					 ena_3_7<='0';
    					 ena_3_8<='0';
    					 ena_3_9<='0';
    					 ena_3_10<='0';
    					 ena_3_11<='0';
    					 ena_3_12<='0';
    					 ena_3_13<='0';
    					 ena_3_14<='0';
    					 ena_3_15<='0';
									 ena_3_16<='0';
									 ena_3_17<='0';
									 ena_3_18<='0';
									 ena_3_19<='0';
									 ena_3_20<='0';
									 ena_3_21<='0';
									 ena_3_22<='0';
    			end if;
    end if;
end process vga_clk_gen_proc6;

vga_clk_gen_proc5: process(clk8Hz,res)
begin
    if(res='1')then
     clk4Hz<='0';
     gen_count_2<=0;
     ena_2_1<='0';
		 ena_2_2<='0';
		 ena_2_3<='0';
		 ena_2_4<='0';
		 ena_2_5<='0';
		 ena_2_6<='0';
		 ena_2_7<='0';
		 ena_2_8<='0';
		 ena_2_9<='0';
		 ena_2_10<='0';
		 ena_2_11<='0';
		  ena_2_12<='0';
		 ena_2_13<='0';
		 ena_2_14<='0';
		 ena_2_15<='0';
		 ena_2_16<='0';
		 ena_2_17<='0';
		 ena_2_18<='0';
		 rand_2_num1_x<=40;
		 rand_2_num1_y<=40;
		 rand_2_num2_x<=40;
		 rand_2_num2_y<=40;
		 rand_2_num3_x<=40;
		 rand_2_num3_y<=440;
		 rand_2_num4_x<=600;
		 rand_2_num4_y<=40;
		 rand_2_num5_x<=40;
		 rand_2_num5_y<=40;
		 rand_2_num6_x<=40;
		 rand_2_num6_y<=40;
		 rand_2_num7_y<=440;
		 rand_2_num7_x<=40;
		 rand_2_num8_x<=600;
		 rand_2_num8_y<=40;
		 rand_2_num9_x<=40;
		 rand_2_num9_y<=40;
		 rand_2_num10_x<=40;
		 rand_2_num10_y<=40;
		 rand_2_num11_y<=440;
		 rand_2_num11_x<=40;
		 rand_2_num12_x<=600;
		 rand_2_num12_y<=40;
		 rand_2_num13_x<=40;
		 rand_2_num13_y<=40;
		 rand_2_num14_x<=40;
		 rand_2_num14_y<=40;
		 rand_2_num15_x<=40;
		 rand_2_num15_y<=440;
		 rand_2_num16_x<=600;
		 rand_2_num16_y<=40;
		 rand_2_num17_x<=40;
		 rand_2_num17_y<=40;
		 rand_2_num18_y<=40;
		 rand_2_num18_x<=40;
		 con_2_1<='0';
		 con_2_2<='0';
		 con_2_3<='0';
		 con_2_4<='0';
		 con_2_5<='0';
		 con_2_6<='0';
		 con_2_7<='0';
		 con_2_8<='0';
		 con_2_9<='0';
		 con_2_10<='0';
		 con_2_11<='0';
		 con_2_12<='0';
		 con_2_13<='0';
		 con_2_14<='0';
		 con_2_15<='0';
		 con_2_16<='0';
		 con_2_17<='0';
		 con_2_18<='0';
    elsif( rising_edge(clk8Hz) ) then
    clk4Hz <= not clk4Hz;
      if(g_state=s2) then
    				if(gen_count_2=0) then
    					 rand_2_num1_x<=to_integer(unsigned(lfsr));
    					 ena_2_1<= '1';
    				elsif(ena_2_1='1' and gen_count_2=1) then
    									if(rand_2_num1_x < 40) then
    									 rand_2_num1_x<=40;
    									 elsif(rand_2_num1_x>320) then
    										con_2_1<='1';
    									 end if;
    				 elsif(gen_count_2>1) then
    									if(con_2_1='1') then
    									 rand_2_num1_x<=rand_2_num1_x-5;
    									 rand_2_num1_y<=rand_2_num1_y+5;
    									else
    									 rand_2_num1_x<=rand_2_num1_x+5;
    									 rand_2_num1_y<=rand_2_num1_y+5;
    									end if;
    									if(rand_2_num1_x>600 or rand_2_num1_x<40 or rand_2_num1_y>440 or rand_2_num1_y<40) then
    										ena_2_1<='0';
    									end if;
    								end if;
    				if(gen_count_2=5) then
    					 rand_2_num2_y<=to_integer(unsigned(lfsr));
    					 ena_2_2<= '1';
    				elsif(ena_2_2='1' and gen_count_2=6) then
    										if(rand_2_num2_y > 430) then
    									 rand_2_num2_y<=430;
    									 con_2_2<='1';
    									 elsif(rand_2_num2_y < 40) then
    										rand_2_num2_y<=40;
    									 elsif(rand_2_num2_y>240) then
    									 con_2_2<='1';
    									 end if;
    						elsif (gen_count_2>6) then
    									if(con_2_2='1') then
    									 rand_2_num2_x<=rand_2_num2_x+5;
    									 rand_2_num2_y<=rand_2_num2_y-3;
    									else
    									 rand_2_num2_x<=rand_2_num2_x+5;
    									 rand_2_num2_y<=rand_2_num2_y+3;
    									end if;
    									if(rand_2_num2_x>600 or rand_2_num2_x<40 or rand_2_num2_y>440 or rand_2_num2_y<40) then
    										ena_2_2<='0';
    									end if;
    						end if;
    				if(gen_count_2=10) then
    						rand_2_num3_x<=to_integer(unsigned(lfsr));
    						ena_2_3<= '1';
    				 elsif(ena_2_3='1' and gen_count_2=11) then
    										 if(rand_2_num3_x < 40) then
    											rand_2_num3_x<=40;
    											 elsif(rand_2_num3_x>320) then
    											 con_2_3<='1';
    											 end if;
    						 elsif(gen_count_2>11) then
    										if(con_2_3='1') then
    										 rand_2_num3_x<=rand_2_num3_x-5;
    										rand_2_num3_y<=rand_2_num3_y-5;
    										else
    									 rand_2_num3_x<=rand_2_num3_x+5;
    									 rand_2_num3_y<=rand_2_num3_y-5;
    									 end if;
    							if(rand_2_num3_x>600 or rand_2_num3_x<40 or rand_2_num3_y>440 or rand_2_num3_y<40) then
    									ena_2_3<='0';
    								 end if;
    							 end if;
    				 if(gen_count_2=15) then
    						 rand_2_num4_y<=to_integer(unsigned(lfsr));
    						 ena_2_4<= '1';
    						elsif(ena_2_4='1' and gen_count_2=16) then
    											if(rand_2_num4_y > 430) then
    												rand_2_num4_y<=430;
    												con_2_4<='1';
    										 elsif(rand_2_num4_y < 40) then
    										 rand_2_num4_y<=40;
    											 elsif(rand_2_num4_y>240) then
    											 con_2_4<='1';
    											end if;
    							elsif(gen_count_2>16) then
    									 if(con_2_4='1') then
    										 rand_2_num4_x<=rand_2_num4_x-5;
    									 rand_2_num4_y<=rand_2_num4_y-3;
    										else
    									 rand_2_num4_x<=rand_2_num4_x-5;
    									 rand_2_num4_y<=rand_2_num4_y+3;
    									 end if;
    									 if(rand_2_num4_x>600 or rand_2_num4_x<40 or rand_2_num4_y>440 or rand_2_num4_y<40) then
    									 ena_2_4<='0';
    								 end if;
    						 end if;
    					 if(gen_count_2=20) then
    							rand_2_num5_x<=to_integer(unsigned(lfsr));
    							ena_2_5<= '1';
    					elsif(ena_2_5='1' and gen_count_2=21) then
    									if(rand_2_num5_x < 40) then
    									rand_2_num5_x<=40;
    								 elsif(rand_2_num5_x>320) then
    										con_2_5<='1';
    									 end if;
    					 elsif(gen_count_2>21) then
    							if(con_2_5='1') then
    							 rand_2_num5_x<=rand_2_num5_x-5;
    							 rand_2_num5_y<=rand_2_num5_y+5;
    								else
    								rand_2_num5_x<=rand_2_num5_x+5;
    							 rand_2_num5_y<=rand_2_num5_y+5;
    								 end if;
    								if(rand_2_num5_x>600 or rand_2_num5_x<40 or rand_2_num5_y>440 or rand_2_num5_y<40) then
    								ena_2_5<='0';
    								end if; 
    						end if;
    					if(gen_count_2=25) then
    									rand_2_num6_y<=to_integer(unsigned(lfsr));
    									ena_2_6<= '1';
    							 elsif(ena_2_6='1' and gen_count_2=26) then
    										 if(rand_2_num6_y > 430) then
    										rand_2_num6_y<=430;
    										con_2_6<='1';
    										elsif(rand_2_num6_y < 40) then
    										 rand_2_num6_y<=40;
    										elsif(rand_2_num6_y>240) then
    										con_2_6<='1';
    										end if;
    							elsif (gen_count_2>26) then
    							if(con_2_6='1') then
    							 rand_2_num6_x<=rand_2_num6_x+5;
    							 rand_2_num6_y<=rand_2_num6_y-3;
    							else
    							 rand_2_num6_x<=rand_2_num6_x+5;
    							 rand_2_num6_y<=rand_2_num6_y+3;
    							end if;
    							if(rand_2_num6_x>600 or rand_2_num6_x<40 or rand_2_num6_y>440 or rand_2_num6_y<40) then
    								ena_2_6<='0';
    							end if;
    						end if;
    					 if(gen_count_2=30) then
    								rand_2_num7_x<=to_integer(unsigned(lfsr));
    								ena_2_7<= '1';
    								 elsif(ena_2_7='1' and gen_count_2=31) then
    										 if(rand_2_num7_x < 40) then
    											rand_2_num7_x<=40;
    											 elsif(rand_2_num7_x>320) then
    											 con_2_7<='1';
    											 end if;
    								 elsif(gen_count_2>31) then
    												if(con_2_7='1') then
    												 rand_2_num7_x<=rand_2_num7_x-5;
    												rand_2_num7_y<=rand_2_num7_y-5;
    												else
    											 rand_2_num7_x<=rand_2_num7_x+5;
    											 rand_2_num7_y<=rand_2_num7_y-5;
    											 end if;
    									if(rand_2_num7_x>600 or rand_2_num7_x<40 or rand_2_num7_y>440 or rand_2_num7_y<40) then
    											ena_2_7<='0';
    							 end if;
    						 end if;
    						if(gen_count_2=35) then
    								rand_2_num8_y<=to_integer(unsigned(lfsr));
    								ena_2_8<= '1';
    							 elsif(ena_2_8='1' and gen_count_2=36) then
    												if(rand_2_num8_y > 430) then
    												con_2_8<='1';
    													rand_2_num8_y<=430;
    											 elsif(rand_2_num8_y < 40) then
    											 rand_2_num8_y<=40;
    												 elsif(rand_2_num8_y>240) then
    												 con_2_8<='1';
    												end if;
    								 elsif(gen_count_2>36) then
    											if(con_2_8='1') then
    												rand_2_num8_x<=rand_2_num8_x-5;
    											rand_2_num8_y<=rand_2_num8_y-3;
    											 else
    											rand_2_num8_x<=rand_2_num8_x-5;
    											rand_2_num8_y<=rand_2_num8_y+3;
    											end if;
    											if(rand_2_num8_x>600 or rand_2_num8_x<40 or rand_2_num8_y>440 or rand_2_num8_y<40) then
    											ena_2_8<='0';
    										end if;
    						  end if;
    						 if(gen_count_2=40) then
									 rand_2_num9_x<=to_integer(unsigned(lfsr));
									 ena_2_9<= '1';
								elsif(ena_2_9='1' and gen_count_2=41) then
													if(rand_2_num9_x < 40) then
													 rand_2_num9_x<=40;
													 elsif(rand_2_num9_x>320) then
														con_2_9<='1';
													 end if;
								 elsif(gen_count_2>41) then
													if(con_2_9='1') then
													 rand_2_num9_x<=rand_2_num9_x-5;
													 rand_2_num9_y<=rand_2_num9_y+5;
													else
													 rand_2_num9_x<=rand_2_num9_x+5;
													 rand_2_num9_y<=rand_2_num9_y+5;
													end if;
													if(rand_2_num9_x>600 or rand_2_num9_x<40 or rand_2_num9_y>440 or rand_2_num9_y<40) then
														ena_2_9<='0';
													end if;
												end if;
						 if(gen_count_2=45) then
							 rand_2_num10_y<=to_integer(unsigned(lfsr));
							 ena_2_10<= '1';
						elsif(ena_2_10='1' and gen_count_2=46) then
												if(rand_2_num10_y > 430) then
											 rand_2_num10_y<=430;
											 con_2_10<='1';
											 elsif(rand_2_num10_y < 40) then
												rand_2_num10_y<=40;
											 elsif(rand_2_num10_y>240) then
											 con_2_10<='1';
											 end if;
								elsif (gen_count_2>46) then
											if(con_2_10='1') then
											 rand_2_num10_x<=rand_2_num10_x+5;
											 rand_2_num10_y<=rand_2_num10_y-3;
											else
											 rand_2_num10_x<=rand_2_num10_x+5;
											 rand_2_num10_y<=rand_2_num10_y+3;
											end if;
											if(rand_2_num10_x>600 or rand_2_num10_x<40 or rand_2_num10_y>440 or rand_2_num10_y<40) then
												ena_2_10<='0';
											end if;
								end if;
							if(gen_count_2=50) then
								rand_2_num11_x<=to_integer(unsigned(lfsr));
								ena_2_11<= '1';
						 elsif(ena_2_11='1' and gen_count_2=51) then
												 if(rand_2_num11_x < 40) then
													rand_2_num11_x<=40;
													 elsif(rand_2_num11_x>320) then
													 con_2_11<='1';
													 end if;
								 elsif(gen_count_2>51) then
												if(con_2_11='1') then
												 rand_2_num11_x<=rand_2_num11_x-5;
												rand_2_num11_y<=rand_2_num11_y-5;
												else
											 rand_2_num11_x<=rand_2_num11_x+5;
											 rand_2_num11_y<=rand_2_num11_y-5;
											 end if;
									if(rand_2_num11_x>600 or rand_2_num11_x<40 or rand_2_num11_y>440 or rand_2_num11_y<40) then
											ena_2_11<='0';
										 end if;
									 end if;
								if(gen_count_2=55) then
											rand_2_num12_y<=to_integer(unsigned(lfsr));
											ena_2_12<= '1';
										 elsif(ena_2_12='1' and gen_count_2=56) then
															if(rand_2_num12_y > 430) then
															con_2_12<='1';
																rand_2_num12_y<=430;
														 elsif(rand_2_num12_y < 40) then
														 rand_2_num12_y<=40;
															 elsif(rand_2_num12_y>240) then
															 con_2_12<='1';
															end if;
											 elsif(gen_count_2>56) then
														if(con_2_12='1') then
															rand_2_num12_x<=rand_2_num12_x-5;
														rand_2_num12_y<=rand_2_num12_y-3;
														 else
														rand_2_num12_x<=rand_2_num12_x-5;
														rand_2_num12_y<=rand_2_num12_y+3;
														end if;
														if(rand_2_num12_x>600 or rand_2_num12_x<40 or rand_2_num12_y>440 or rand_2_num12_y<40) then
														ena_2_12<='0';
													end if;
										end if;
									if(gen_count_2=60) then
												 rand_2_num13_x<=to_integer(unsigned(lfsr));
												 ena_2_13<= '1';
											elsif(ena_2_13='1' and gen_count_2=61) then
																if(rand_2_num13_x < 40) then
																 rand_2_num13_x<=40;
																 elsif(rand_2_num13_x>320) then
																	con_2_13<='1';
																 end if;
											 elsif(gen_count_2>61) then
																if(con_2_13='1') then
																 rand_2_num13_x<=rand_2_num13_x-5;
																 rand_2_num13_y<=rand_2_num13_y+5;
																else
																 rand_2_num13_x<=rand_2_num13_x+5;
																 rand_2_num13_y<=rand_2_num13_y+5;
																end if;
																if(rand_2_num13_x>600 or rand_2_num13_x<40 or rand_2_num13_y>440 or rand_2_num13_y<40) then
																	ena_2_13<='0';
																end if;
															end if;
								if(gen_count_2=65) then
										 rand_2_num14_y<=to_integer(unsigned(lfsr));
										 ena_2_14<= '1';
									elsif(ena_2_14='1' and gen_count_2=66) then
															if(rand_2_num14_y > 430) then
														 rand_2_num14_y<=430;
														 con_2_14<='1';
														 elsif(rand_2_num14_y < 40) then
															rand_2_num14_y<=40;
														 elsif(rand_2_num14_y>240) then
														 con_2_14<='1';
														 end if;
											elsif (gen_count_2>66) then
														if(con_2_14='1') then
														 rand_2_num14_x<=rand_2_num14_x+5;
														 rand_2_num14_y<=rand_2_num14_y-3;
														else
														 rand_2_num14_x<=rand_2_num14_x+5;
														 rand_2_num14_y<=rand_2_num14_y+3;
														end if;
														if(rand_2_num14_x>600 or rand_2_num14_x<40 or rand_2_num14_y>440 or rand_2_num14_y<40) then
															ena_2_14<='0';
														end if;
											end if;
									if(gen_count_2=70) then
												rand_2_num15_x<=to_integer(unsigned(lfsr));
												ena_2_15<= '1';
										 elsif(ena_2_15='1' and gen_count_2=71) then
																 if(rand_2_num15_x < 40) then
																	rand_2_num15_x<=40;
																	 elsif(rand_2_num15_x>320) then
																	 con_2_15<='1';
																	 end if;
												 elsif(gen_count_2>71) then
																if(con_2_15='1') then
																 rand_2_num15_x<=rand_2_num15_x-5;
																rand_2_num15_y<=rand_2_num15_y-5;
																else
															 rand_2_num15_x<=rand_2_num15_x+5;
															 rand_2_num15_y<=rand_2_num15_y-5;
															 end if;
													if(rand_2_num15_x>600 or rand_2_num15_x<40 or rand_2_num15_y>440 or rand_2_num15_y<40) then
															ena_2_15<='0';
														 end if;
													 end if;
									 if(gen_count_2=75) then
													rand_2_num16_y<=to_integer(unsigned(lfsr));
													ena_2_16<= '1';
												 elsif(ena_2_16='1' and gen_count_2=76) then
																	if(rand_2_num16_y > 430) then
																	con_2_16<='1';
																		rand_2_num16_y<=430;
																 elsif(rand_2_num16_y < 40) then
																 rand_2_num16_y<=40;
																	 elsif(rand_2_num16_y>240) then
																	 con_2_16<='1';
																	end if;
													 elsif(gen_count_2>76) then
																if(con_2_16='1') then
																	rand_2_num16_x<=rand_2_num16_x-5;
																rand_2_num16_y<=rand_2_num16_y-3;
																 else
																rand_2_num16_x<=rand_2_num16_x-5;
																rand_2_num16_y<=rand_2_num16_y+3;
																end if;
																if(rand_2_num16_x>600 or rand_2_num16_x<40 or rand_2_num16_y>440 or rand_2_num16_y<40) then
																ena_2_16<='0';
															end if;
												end if;
										if(gen_count_2=80) then
												 rand_2_num17_x<=to_integer(unsigned(lfsr));
												 ena_2_17<= '1';
											elsif(ena_2_17='1' and gen_count_2=81) then
																if(rand_2_num17_x < 40) then
																 rand_2_num17_x<=40;
																 elsif(rand_2_num17_x>320) then
																	con_2_17<='1';
																 end if;
											 elsif(gen_count_2>81) then
																if(con_2_17='1') then
																 rand_2_num17_x<=rand_2_num17_x-5;
																 rand_2_num17_y<=rand_2_num17_y+5;
																else
																 rand_2_num17_x<=rand_2_num17_x+5;
																 rand_2_num17_y<=rand_2_num17_y+5;
																end if;
																if(rand_2_num17_x>600 or rand_2_num17_x<40 or rand_2_num17_y>440 or rand_2_num17_y<40) then
																	ena_2_17<='0';
																end if;
															end if;
										if(gen_count_2=85) then
													 rand_2_num18_y<=to_integer(unsigned(lfsr));
													 ena_2_18<= '1';
												elsif(ena_2_18='1' and gen_count_2=86) then
																		if(rand_2_num18_y > 430) then
																	 rand_2_num18_y<=430;
																	 con_2_18<='1';
																	 elsif(rand_2_num18_y < 40) then
																		rand_2_num18_y<=40;
																	 elsif(rand_2_num18_y>240) then
																	 con_2_18<='1';
																	 end if;
														elsif (gen_count_2>86) then
																	if(con_2_18='1') then
																	 rand_2_num18_x<=rand_2_num18_x+5;
																	 rand_2_num18_y<=rand_2_num18_y-3;
																	else
																	 rand_2_num18_x<=rand_2_num18_x+5;
																	 rand_2_num18_y<=rand_2_num18_y+3;
																	end if;
																	if(rand_2_num18_x>600 or rand_2_num18_x<40 or rand_2_num18_y>440 or rand_2_num18_y<40) then
																		ena_2_18<='0';
																	end if;
														end if;
    				gen_count_2<=gen_count_2+1;
    			else
    				 ena_2_1<='0';
    				 ena_2_2<='0';
    				 ena_2_3<='0';
    				 ena_2_4<='0';
    				 ena_2_5<='0';
    				 ena_2_6<='0';
    				 ena_2_7<='0';
    				 ena_2_8<='0';
    				 ena_2_9<='0';
    				 ena_2_10<='0';
    				 ena_2_11<='0';
    				 ena_2_12<='0';
						 ena_2_13<='0';
						 ena_2_14<='0';
						 ena_2_15<='0';
						 ena_2_16<='0';
						 ena_2_17<='0';
						 ena_2_18<='0';
    			end if;
    	end if;
end process vga_clk_gen_proc5;

feedback <= lfsr(5) xor lfsr(2);
vga_clk_gen_proc4: process(clk4Hz,res)
begin
    if(res='1') then
     clk2Hz<='0';
     led<="00000000";
     ledcount<=0;
     elsif( rising_edge(clk4Hz) ) then
        clk2Hz <= not clk2Hz;
        if(g_state/=s4 and game_over ='0') then
           led<="00000000";
        elsif (game_over='1') then
           led<="11111111";
        elsif (g_state=s4 and game_over ='0') then
         case ledcount is 
         when 0=>led<="00000001";
         when 1=>led<="00000010";
         when 2=>led<="00000100";
         when 3=>led<="00001000";
         when 4=>led<="00010000";
         when 5=>led<="00100000";
         when 6=>led<="01000000";
         when others=>led<="10000000";
         end case;
         ledcount<=ledcount+1;
         if(ledcount=7) then
         ledcount<=0;
         end if;
       end if;
    end if;
end process vga_clk_gen_proc4;

sel:process(ms_pulse,res)
	begin
	    if(res='1') then
	     digit<=0;
	     ssdcat<='0';
			elsif ms_pulse='1' then
				digit <= ssdcount/10;
				else
			  digit <= ssdcount mod 10;
			end if;
	ssdcat <= ms_pulse; -- select display
end process sel;

display:process(digit)
 begin

 case digit is
 when 0=>ssd<="1111110";
 when 1=>ssd<="0110000";
 when 2=>ssd<="1101101";
 when 3=>ssd<="1111001";
 when 4=>ssd<="0110011";
 when 5=>ssd<="1011011";
 when 6=>ssd<="1011111";
 when 7=>ssd<="1110000";
 when 8=>ssd<="1111111";
 when others=>ssd<="1111011";
 end case;
end process display;

vga_clk_gen_proc3: process(clk2Hz,res)
begin
   if(res='1') then
   clk1Hz<='0';
    elsif( rising_edge(clk2Hz) ) then
        clk1Hz <= not clk1Hz;
        
    end if;
end process vga_clk_gen_proc3;

-- generate 25MHz clock
vga_clk_gen_proc2: process(clk50MHz,res)
begin
   if(res='1') then
   clk25MHz<='0';
    elsif( rising_edge(clk50MHz) ) then
        clk25MHz <= not clk25MHz;
    end if;
end process vga_clk_gen_proc2;

-- horizontal counter
pixel_count_proc: process(clk25MHz,res)
begin
    if(res='1') then
    hcount<="000000000000";
    elsif( rising_edge(clk25MHz) ) then
        if(hcount = H_TOTAL) then
            hcount <= (others => '0');
        else
            hcount <= hcount + 1;
        end if;
    end if;
end process pixel_count_proc;

-- generate hsync
hsync_gen_proc: process(hcount)
 begin
    if(hcount > H_SYNC) then
        hsync <= '1';
    else
        hsync <= '0';
    end if;
end process hsync_gen_proc;

-- vertical counter
line_count_proc: process(clk25MHz,res)
begin
     if(res='1') then
     vcount<="000000000000";
    elsif( rising_edge(clk25MHz) ) then
        if(hcount = H_TOTAL) then
            if(vcount = V_TOTAL) then
                vcount <= (others => '0');
            else
                vcount <= vcount + 1;
            end if;
        end if;
    end if;
end process line_count_proc;

state: process(clk1Hz,res)
begin
    if(res='1') then
    g_state<=s0;
    ssdcount<=0;
    count<=0;
    elsif(rising_edge(clk1Hz)) then
       if(game_over='0') then
         count <= count+1;
				 if(count = 5) then
							ssdcount<=30;
							g_state<=s1;
				 elsif(count > 5 and count < 35) then
							ssdcount<=ssdcount-1;
				 elsif(count = 35) then
							 ssdcount<=25;
							 g_state<=s2;
				 elsif(count > 35 and count < 60) then
							ssdcount<=ssdcount-1;
				 elsif(count = 60) then
						ssdcount<=15;
						g_state<=s3;
				 elsif(count > 60 and count < 75) then
					ssdcount<=ssdcount-1;
				 elsif(count = 75) then
							ssdcount<=70;
						 g_state<=s4;
				 end if;
			 else 
			   ssdcount<=count-5;
			 end if;
    end if;
    
    --if(count = 50) then
         --g_state<=s4;
       -- end if;
end process state;
-- LFSR size 4

gen: process(clk4Hz,res) 
  begin
  if(res='1')then
       gen_count<=0;
       ena1<='0';
  		 ena2<='0';
  		 ena3<='0';
  		 ena4<='0';
  		 ena5<='0';
  		 ena6<='0';
  		 ena7<='0';
  		 ena8<='0';
  		 rand_num1_x<=40;
  		 rand_num1_y<=40;
  		 rand_num2_x<=40;
  		 rand_num2_y<=40;
  		 rand_num3_x<=40;
  		 rand_num3_y<=440;
  		 rand_num4_x<=600;
  		 rand_num4_y<=40;
  		 rand_num5_x<=40;
  		 rand_num5_y<=40;
  		 rand_num6_x<=40;
  		 rand_num6_y<=40;
  		 rand_num7_y<=440;
  		 rand_num7_x<=40;
  		 rand_num8_x<=600;
  		 rand_num8_y<=40;
  		 con1<='0';
  		 con2<='0';
  		 con3<='0';
  		 con4<='0';
  		 con5<='0';
  		 con6<='0';
  		 con7<='0';
  		 con8<='0';
  elsif (rising_edge(clk4Hz)) then
     if(g_state=s1) then
        if(gen_count=0) then
           rand_num1_x<=to_integer(unsigned(lfsr));
           ena1<= '1';
        elsif(ena1='1' and gen_count=1) then
                  if(rand_num1_x < 40) then
                   rand_num1_x<=40;
                   elsif(rand_num1_x>320) then
                    con1<='1';
                   end if;
         elsif(gen_count>1) then
                  if(con1='1') then
                   rand_num1_x<=rand_num1_x-5;
                   rand_num1_y<=rand_num1_y+5;
                  else
                   rand_num1_x<=rand_num1_x+5;
                   rand_num1_y<=rand_num1_y+5;
                  end if;
                  if(rand_num1_x>600 or rand_num1_x<40 or rand_num1_y>440 or rand_num1_y<40) then
                    ena1<='0';
                  end if;
                end if;
        if(gen_count=5) then
           rand_num2_y<=to_integer(unsigned(lfsr));
           ena2<= '1';
        elsif(ena2='1' and gen_count=6) then
                    if(rand_num2_y > 430) then
                   rand_num2_y<=430;
                   con2<='1';
                   elsif(rand_num2_y < 40) then
                    rand_num2_y<=40;
                   elsif(rand_num2_y>240) then
                   con2<='1';
                   end if;
            elsif (gen_count>6) then
									if(con2='1') then
									 rand_num2_x<=rand_num2_x+5;
									 rand_num2_y<=rand_num2_y-3;
									else
									 rand_num2_x<=rand_num2_x+5;
									 rand_num2_y<=rand_num2_y+3;
									end if;
									if(rand_num2_x>600 or rand_num2_x<40 or rand_num2_y>440 or rand_num2_y<40) then
										ena2<='0';
									end if;
						end if;
        if(gen_count=10) then
            rand_num3_x<=to_integer(unsigned(lfsr));
            ena3<= '1';
         elsif(ena3='1' and gen_count=11) then
                     if(rand_num3_x < 40) then
                      rand_num3_x<=40;
                       elsif(rand_num3_x>320) then
                       con3<='1';
                       end if;
             elsif(gen_count>11) then
                    if(con3='1') then
                     rand_num3_x<=rand_num3_x-5;
                    rand_num3_y<=rand_num3_y-5;
                    else
                   rand_num3_x<=rand_num3_x+5;
                   rand_num3_y<=rand_num3_y-5;
                   end if;
              if(rand_num3_x>600 or rand_num3_x<40 or rand_num3_y>440 or rand_num3_y<40) then
                  ena3<='0';
                 end if;
               end if;
         if(gen_count=15) then
             rand_num4_y<=to_integer(unsigned(lfsr));
             ena4<= '1';
            elsif(ena4='1' and gen_count=16) then
											if(rand_num4_y > 430) then
												rand_num4_y<=430;
												con4<='1';
										 elsif(rand_num4_y < 40) then
										 rand_num4_y<=40;
											 elsif(rand_num4_y>240) then
											 con4<='1';
											end if;
              elsif( gen_count>16) then
                   if(con4='1') then
                     rand_num4_x<=rand_num4_x-5;
                   rand_num4_y<=rand_num4_y-3;
                    else
                   rand_num4_x<=rand_num4_x-5;
                   rand_num4_y<=rand_num4_y+3;
                   end if;
                   if(rand_num4_x>600 or rand_num4_x<40 or rand_num4_y>440 or rand_num4_y<40) then
                   ena4<='0';
                 end if;
             end if;
           if(gen_count=20) then
							rand_num5_x<=to_integer(unsigned(lfsr));
							ena5<= '1';
          elsif(ena5='1' and gen_count=21) then
									if(rand_num5_x < 40) then
									rand_num5_x<=40;
								 elsif(rand_num5_x>320) then
										con5<='1';
									 end if;
					 elsif(gen_count>21) then
							if(con5='1') then
							 rand_num5_x<=rand_num5_x-5;
							 rand_num5_y<=rand_num5_y+5;
								else
								rand_num5_x<=rand_num5_x+5;
							 rand_num5_y<=rand_num5_y+5;
								 end if;
								if(rand_num5_x>600 or rand_num5_x<40 or rand_num5_y>440 or rand_num5_y<40) then
								ena5<='0';
								end if; 
						end if;
			    if(gen_count=25) then
									rand_num6_y<=to_integer(unsigned(lfsr));
									ena6<= '1';
							 elsif(ena6='1' and gen_count=26) then
										 if(rand_num6_y > 430) then
										rand_num6_y<=430;
										con6<='1';
										elsif(rand_num6_y < 40) then
										 rand_num6_y<=40;
										elsif(rand_num6_y>240) then
										con6<='1';
										end if;
							elsif (gen_count>26) then
							if(con6='1') then
							 rand_num6_x<=rand_num6_x+5;
							 rand_num6_y<=rand_num6_y-3;
							else
							 rand_num6_x<=rand_num6_x+5;
							 rand_num6_y<=rand_num6_y+3;
							end if;
							if(rand_num6_x>600 or rand_num6_x<40 or rand_num6_y>440 or rand_num6_y<40) then
								ena6<='0';
							end if;
						end if;
					 if(gen_count=30) then
								rand_num7_x<=to_integer(unsigned(lfsr));
								ena7<= '1';
						     elsif(ena7='1' and gen_count=31) then
										 if(rand_num7_x < 40) then
											rand_num7_x<=40;
											 elsif(rand_num7_x>320) then
											 con7<='1';
											 end if;
								 elsif(gen_count>31) then
												if(con7='1') then
												 rand_num7_x<=rand_num7_x-5;
												rand_num7_y<=rand_num7_y-5;
												else
											 rand_num7_x<=rand_num7_x+5;
											 rand_num7_y<=rand_num7_y-5;
											 end if;
									if(rand_num7_x>600 or rand_num7_x<40 or rand_num7_y>440 or rand_num7_y<40) then
											ena7<='0';
							 end if;
						 end if;
					  if(gen_count=35) then
								rand_num8_y<=to_integer(unsigned(lfsr));
								ena8<= '1';
							 elsif(ena8='1' and gen_count=36) then
												if(rand_num8_y > 430) then
												con8<='1';
													rand_num8_y<=430;
											 elsif(rand_num8_y < 40) then
											 rand_num8_y<=40;
												 elsif(rand_num8_y>240) then
												 con8<='1';
												end if;
								 elsif(gen_count>36) then
											if(con8='1') then
												rand_num8_x<=rand_num8_x-5;
											rand_num8_y<=rand_num8_y-3;
											 else
											rand_num8_x<=rand_num8_x-5;
											rand_num8_y<=rand_num8_y+3;
											end if;
											if(rand_num8_x>600 or rand_num8_x<40 or rand_num8_y>440 or rand_num8_y<40) then
											ena8<='0';
										end if;
								end if;
        gen_count<=gen_count+1;
        else
           ena1<='0';
           ena2<='0';
           ena3<='0';
           ena4<='0';
           ena5<='0';
           ena6<='0';
           ena7<='0';
           ena8<='0';
      end if;
     end if;
  end process gen;

-- generate vsync
vsync_gen_proc: process(hcount)
begin
    if(vcount > V_SYNC) then
        vsync <= '1';
    else
        vsync <= '0';
    end if;
end process vsync_gen_proc;

control: process(clk16Hz,res)
begin
 if(res='1')then
    ori_x<=320;
    ori_y<=240;
    game_over<='0';
    lifecount<=0;
    ena_c_1<='0';
		 ena_c_2<='0';
		 ena_c_3<='0';
		 ena_c_4<='0';
		 ena_c_5<='0';
		 ena_c_6<='0';
		 ena_c_7<='0';
		 ena_c_8<='0';
		 ena_2_c_1<='0';
		 ena_2_c_2<='0';
		 ena_2_c_3<='0';
		 ena_2_c_4<='0';
		 ena_2_c_5<='0';
		 ena_2_c_6<='0';
		 ena_2_c_7<='0';
		 ena_2_c_8<='0';
		 ena_2_c_9<='0';
		 ena_2_c_10<='0';
		 ena_2_c_11<='0';
		 ena_2_c_12<='0';
		 ena_2_c_13<='0';
		 ena_2_c_14<='0';
		 ena_2_c_15<='0';
		 ena_2_c_16<='0';
		 ena_2_c_17<='0';
		 ena_2_c_18<='0';
		 ena_3_c_1<='0';
		 ena_3_c_2<='0';
		 ena_3_c_3<='0';
		 ena_3_c_4<='0';
		 ena_3_c_5<='0';
		 ena_3_c_6<='0';
		 ena_3_c_7<='0';
		 ena_3_c_8<='0';
		 ena_3_c_9<='0';
		 ena_3_c_10<='0';
		 ena_3_c_11<='0';
		 ena_3_c_12<='0';
		 ena_3_c_13<='0';
		 ena_3_c_14<='0';
		 ena_3_c_15<='0';
		 		 ena_3_c_16<='0';
		 		 ena_3_c_17<='0';
		 		 ena_3_c_18<='0';
		 		 ena_3_c_19<='0';
		 		 ena_3_c_20<='0';
		 		 ena_3_c_21<='0';
		 		 ena_3_c_22<='0';
		 check_1<='0';
		 check_2<='0';
		 check_3<='0';
		 check_4<='0';
		 check_5<='0';
		 check_6<='0';
		 check_7<='0';
		 check_8<='0';
		 check_2_1<='0';
		 check_2_2<='0';
		 check_2_3<='0';
		 check_2_4<='0';
		 check_2_5<='0';
		 check_2_6<='0';
		 check_2_7<='0';
		 check_2_8<='0';
		 check_2_9<='0';
		 check_2_10<='0';
		 check_2_11<='0';
		 check_2_12<='0';
		 check_2_13<='0';
		 check_2_14<='0';
		 check_2_15<='0';
		 check_2_16<='0';
		 check_2_17<='0';
		 check_2_18<='0';
		 check_2_1<='0';
		 check_3_2<='0';
		 check_3_3<='0';
		 check_3_4<='0';
		 check_3_5<='0';
		 check_3_6<='0';
		 check_3_7<='0';
		 check_3_8<='0';
		 check_3_9<='0';
		 check_3_10<='0';
		 check_3_11<='0';
		 check_3_12<='0';
		 check_3_13<='0';
		 check_3_14<='0';
		 check_3_15<='0';
		 		 check_3_16<='0';
		 		 check_3_17<='0';
		 		 check_3_18<='0';
		 		 check_3_19<='0';
		 		 check_3_20<='0';
		 		 check_3_21<='0';
		 		 check_3_22<='0';
 elsif( rising_edge(clk16Hz) ) then
   if(L='1' ) then
      if(ori_x <= 625 and ori_x >= 20) then
       ori_x<=ori_x-5;
      end if;
   end if;
   if(R='1' ) then
      if(ori_x <= 620 and ori_x >= 15) then
        ori_x<=ori_x+5;
      end if;
   end if;
   if(U='1' ) then
       if(ori_y <= 465 and ori_y >= 20) then
          ori_y<=ori_y-5;
       end if;
   end if;
   if(D='1' ) then
       if(ori_y <= 460 and ori_y >= 15) then
          ori_y<=ori_y+5;
       end if;
   end if;
   if(check_1='0')then if(ena1='1') then ena_c_1<='1'; check_1<='1'; end if; end if;
   if(check_2='0')then if(ena2='1') then ena_c_2<='1'; check_2<='1'; end if; end if;
   if(check_3='0')then if(ena3='1') then ena_c_3<='1'; check_3<='1'; end if; end if;
   if(check_4='0')then if(ena4='1') then ena_c_4<='1'; check_4<='1'; end if; end if;
   if(check_5='0')then if(ena5='1') then ena_c_5<='1'; check_5<='1'; end if; end if;
   if(check_6='0')then if(ena6='1') then ena_c_6<='1'; check_6<='1'; end if; end if;
   if(check_7='0')then if(ena7='1') then ena_c_7<='1'; check_7<='1'; end if; end if;
   if(check_8='0')then if(ena8='1') then ena_c_8<='1'; check_8<='1'; end if; end if;
   if(check_2_1='0')then if(ena_2_1='1') then ena_2_c_1<='1'; check_2_1<='1'; end if; end if;
   if(check_2_2='0')then if(ena_2_2='1') then ena_2_c_2<='1'; check_2_2<='1'; end if; end if;
   if(check_2_3='0')then if(ena_2_3='1') then ena_2_c_3<='1'; check_2_3<='1'; end if; end if;
   if(check_2_4='0')then if(ena_2_4='1') then ena_2_c_4<='1'; check_2_4<='1'; end if; end if;
   if(check_2_5='0')then if(ena_2_5='1') then ena_2_c_5<='1'; check_2_5<='1'; end if; end if;
   if(check_2_6='0')then if(ena_2_6='1') then ena_2_c_6<='1'; check_2_6<='1'; end if; end if;
   if(check_2_7='0')then if(ena_2_7='1') then ena_2_c_7<='1'; check_2_7<='1'; end if; end if;
   if(check_2_8='0')then if(ena_2_8='1') then ena_2_c_8<='1'; check_2_8<='1'; end if; end if;
   if(check_2_9='0')then if(ena_2_9='1') then ena_2_c_9<='1'; check_2_9<='1'; end if; end if;
   if(check_2_10='0')then if(ena_2_10='1') then ena_2_c_10<='1'; check_2_10<='1'; end if; end if;
   if(check_2_11='0')then if(ena_2_11='1') then ena_2_c_11<='1'; check_2_11<='1'; end if; end if;
   if(check_2_12='0')then if(ena_2_12='1') then ena_2_c_12<='1'; check_2_12<='1'; end if; end if;
		if(check_2_13='0')then if(ena_2_13='1') then ena_2_c_13<='1'; check_2_13<='1'; end if; end if;
		if(check_2_14='0')then if(ena_2_14='1') then ena_2_c_14<='1'; check_2_14<='1'; end if; end if;
		if(check_2_15='0')then if(ena_2_15='1') then ena_2_c_15<='1'; check_2_15<='1'; end if; end if;
		if(check_2_16='0')then if(ena_2_16='1') then ena_2_c_16<='1'; check_2_16<='1'; end if; end if;
		if(check_2_17='0')then if(ena_2_17='1') then ena_2_c_17<='1'; check_2_17<='1'; end if; end if;
		if(check_2_18='0')then if(ena_2_18='1') then ena_2_c_18<='1'; check_2_18<='1'; end if; end if;
   if(check_3_1='0')then if(ena_3_1='1') then ena_3_c_1<='1'; check_3_1<='1'; end if; end if;
   if(check_3_2='0')then if(ena_3_2='1') then ena_3_c_2<='1'; check_3_2<='1'; end if; end if;
   if(check_3_3='0')then if(ena_3_3='1') then ena_3_c_3<='1'; check_3_3<='1'; end if; end if;
   if(check_3_4='0')then if(ena_3_4='1') then ena_3_c_4<='1'; check_3_4<='1'; end if; end if;
   if(check_3_5='0')then if(ena_3_5='1') then ena_3_c_5<='1'; check_3_5<='1'; end if; end if;
   if(check_3_6='0')then if(ena_3_6='1') then ena_3_c_6<='1'; check_3_6<='1'; end if; end if;
   if(check_3_7='0')then if(ena_3_7='1') then ena_3_c_7<='1'; check_3_7<='1'; end if; end if;
   if(check_3_8='0')then if(ena_3_8='1') then ena_3_c_8<='1'; check_3_8<='1'; end if; end if;
   if(check_3_9='0')then if(ena_3_9='1') then ena_3_c_9<='1'; check_3_9<='1'; end if; end if;
   if(check_3_10='0')then if(ena_3_10='1') then ena_3_c_10<='1'; check_3_10<='1'; end if; end if;
   if(check_3_11='0')then if(ena_3_11='1') then ena_3_c_11<='1'; check_3_11<='1'; end if; end if;
   if(check_3_12='0')then if(ena_3_12='1') then ena_3_c_12<='1'; check_3_12<='1'; end if; end if;
   if(check_3_13='0')then if(ena_3_13='1') then ena_3_c_13<='1'; check_3_13<='1'; end if; end if;
   if(check_3_14='0')then if(ena_3_14='1') then ena_3_c_14<='1'; check_3_14<='1'; end if; end if;
   if(check_3_15='0')then if(ena_3_15='1') then ena_3_c_15<='1'; check_3_15<='1'; end if; end if;
      if(check_3_16='0')then if(ena_3_16='1') then ena_3_c_16<='1'; check_3_16<='1'; end if; end if;
      if(check_3_17='0')then if(ena_3_17='1') then ena_3_c_17<='1'; check_3_17<='1'; end if; end if;
      if(check_3_18='0')then if(ena_3_18='1') then ena_3_c_18<='1'; check_3_18<='1'; end if; end if;
      if(check_3_19='0')then if(ena_3_19='1') then ena_3_c_19<='1'; check_3_19<='1'; end if; end if;
      if(check_3_20='0')then if(ena_3_20='1') then ena_3_c_20<='1'; check_3_20<='1'; end if; end if;
      if(check_3_21='0')then if(ena_3_21='1') then ena_3_c_21<='1'; check_3_21<='1'; end if; end if;
      if(check_3_22='0')then if(ena_3_22='1') then ena_3_c_22<='1'; check_3_22<='1'; end if; end if;
    
   if(ena1='1' and ena_c_1='1') then
      if(ori_y-10>rand_num1_y+25 or ori_y+10<rand_num1_y-25 ) then
         check<='1';
      elsif(ori_x+10<rand_num1_x-25 or ori_x-10>rand_num1_x+25) then
         check<='1';
      else
         lifecount<=lifecount+1;
         ena_c_1<='0';
         if(lifecount=2)then
         game_over<='1';
         end if;
      end if;
   end if;
   if(ena2='1'and ena_c_2='1') then
      if(ori_y-10>rand_num2_y+25 or ori_y+10<rand_num2_y-25 ) then
            check<='1';
         elsif(ori_x+10<rand_num2_x-25 or ori_x-10>rand_num2_x+25) then
            check<='1';
         else
            lifecount<=lifecount+1;
            ena_c_2<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
       end if;
   end if;
   if(ena3='1'and ena_c_3='1') then
         if(ori_y-10>rand_num3_y+25 or ori_y+10<rand_num3_y-25 ) then
               check<='1';
            elsif(ori_x+10<rand_num3_x-25 or ori_x-10>rand_num3_x+25) then
               check<='1';
            else
              lifecount<=lifecount+1;
              ena_c_3<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
          end if;
      end if;
   if(ena4='1'and ena_c_4='1') then
            if(ori_y-10>rand_num4_y+25 or ori_y+10<rand_num4_y-25 ) then
               check<='1';
            elsif(ori_x+10<rand_num4_x-25 or ori_x-10>rand_num4_x+25) then
               check<='1';
            else
              lifecount<=lifecount+1;
              ena_c_4<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
            end if;
         end if;
    if(ena5='1'and ena_c_5='1') then
				 if(ori_y-10>rand_num5_y+25 or ori_y+10<rand_num5_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_num5_x-25 or ori_x-10>rand_num5_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_c_5<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena6='1'and ena_c_6='1') then
			 if(ori_y-10>rand_num6_y+25 or ori_y+10<rand_num6_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_num6_x-25 or ori_x-10>rand_num6_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_c_6<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena7='1'and ena_c_7='1') then
			 if(ori_y-10>rand_num7_y+25 or ori_y+10<rand_num7_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_num7_x-25 or ori_x-10>rand_num7_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_c_7<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena8='1'and ena_c_8='1') then
			 if(ori_y-10>rand_num8_y+25 or ori_y+10<rand_num8_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_num8_x-25 or ori_x-10>rand_num8_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_c_8<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_1='1'and ena_2_c_1='1') then
			if(ori_y-10>rand_2_num1_y+25 or ori_y+10<rand_2_num1_y-25 ) then
				 check<='1';
			elsif(ori_x+10<rand_2_num1_x-25 or ori_x-10>rand_2_num1_x+25) then
				 check<='1';
			else
				 lifecount<=lifecount+1;
				 ena_2_c_1<='0';
				if(lifecount=2)then
				game_over<='1';
				end if;
			end if;
	 end if;
	 if(ena_2_2='1'and ena_2_c_2='1') then
			if(ori_y-10>rand_2_num2_y+25 or ori_y+10<rand_2_num2_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_2_num2_x-25 or ori_x-10>rand_2_num2_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_2_c_2<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
			 end if;
	 end if;
	 if(ena_2_3='1'and ena_2_c_3='1') then
				 if(ori_y-10>rand_2_num3_y+25 or ori_y+10<rand_2_num3_y-25 ) then
							 check<='1';
						elsif(ori_x+10<rand_2_num3_x-25 or ori_x-10>rand_2_num3_x+25) then
							 check<='1';
						else
							 lifecount<=lifecount+1;
							 ena_2_c_3<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
					end if;
			end if;
	 if(ena_2_4='1'and ena_2_c_4='1') then
						if(ori_y-10>rand_2_num4_y+25 or ori_y+10<rand_2_num4_y-25 ) then
							 check<='1';
						elsif(ori_x+10<rand_2_num4_x-25 or ori_x-10>rand_2_num4_x+25) then
							 check<='1';
						else
							 lifecount<=lifecount+1;
							 ena_2_c_4<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						end if;
				 end if;
		if(ena_2_5='1'and ena_2_c_5='1') then
				 if(ori_y-10>rand_2_num5_y+25 or ori_y+10<rand_2_num5_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_2_num5_x-25 or ori_x-10>rand_2_num5_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_2_c_5<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena_2_6='1'and ena_2_c_6='1') then
			 if(ori_y-10>rand_2_num6_y+25 or ori_y+10<rand_2_num6_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_2_num6_x-25 or ori_x-10>rand_2_num6_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_2_c_6<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_7='1'and ena_2_c_7='1') then
			 if(ori_y-10>rand_2_num7_y+25 or ori_y+10<rand_2_num7_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_2_num7_x-25 or ori_x-10>rand_2_num7_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_2_c_7<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_8='1'and ena_2_c_8='1') then
			 if(ori_y-10>rand_2_num8_y+25 or ori_y+10<rand_2_num8_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_2_num8_x-25 or ori_x-10>rand_2_num8_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_2_c_8<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_9='1'and ena_2_c_9='1') then
			 if(ori_y-10>rand_2_num9_y+25 or ori_y+10<rand_2_num9_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_2_num9_x-25 or ori_x-10>rand_2_num9_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_2_c_9<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_10='1'and ena_2_c_10='1') then
			 if(ori_y-10>rand_2_num10_y+25 or ori_y+10<rand_2_num10_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_2_num10_x-25 or ori_x-10>rand_2_num10_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_2_c_10<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_11='1'and ena_2_c_11='1') then
			 if(ori_y-10>rand_2_num11_y+25 or ori_y+10<rand_2_num11_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_2_num11_x-25 or ori_x-10>rand_2_num11_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_2_c_11<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_2_12='1'and ena_2_c_12='1') then
						 if(ori_y-10>rand_2_num12_y+25 or ori_y+10<rand_2_num12_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_2_num12_x-25 or ori_x-10>rand_2_num12_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_2_c_12<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_2_13='1'and ena_2_c_13='1') then
					 if(ori_y-10>rand_2_num13_y+25 or ori_y+10<rand_2_num13_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_2_num13_x-25 or ori_x-10>rand_2_num13_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_2_c_13<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_2_14='1'and ena_2_c_14='1') then
					 if(ori_y-10>rand_2_num14_y+25 or ori_y+10<rand_2_num14_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_2_num14_x-25 or ori_x-10>rand_2_num14_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_2_c_14<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_2_15='1'and ena_2_c_15='1') then
					 if(ori_y-10>rand_2_num15_y+25 or ori_y+10<rand_2_num15_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_2_num15_x-25 or ori_x-10>rand_2_num15_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_2_c_15<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_2_16='1'and ena_2_c_16='1') then
					 if(ori_y-10>rand_2_num16_y+25 or ori_y+10<rand_2_num16_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_2_num16_x-25 or ori_x-10>rand_2_num16_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_2_c_16<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_2_17='1'and ena_2_c_17='1') then
					 if(ori_y-10>rand_2_num17_y+25 or ori_y+10<rand_2_num17_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_2_num17_x-25 or ori_x-10>rand_2_num17_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_2_c_17<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_2_18='1'and ena_2_c_18='1') then
					 if(ori_y-10>rand_2_num18_y+25 or ori_y+10<rand_2_num18_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_2_num18_x-25 or ori_x-10>rand_2_num18_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_2_c_18<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
		if(ena_3_1='1'and ena_3_c_1='1') then
					if(ori_y-10>rand_3_num1_y+25 or ori_y+10<rand_3_num1_y-25 ) then
						 check<='1';
					elsif(ori_x+10<rand_3_num1_x-25 or ori_x-10>rand_3_num1_x+25) then
						 check<='1';
					else
						 lifecount<=lifecount+1;
						 ena_3_c_1<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					end if;
			 end if;
			 if(ena_3_2='1'and ena_3_c_2='1') then
					if(ori_y-10>rand_3_num2_y+25 or ori_y+10<rand_3_num2_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num2_x-25 or ori_x-10>rand_3_num2_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_2<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
					 end if;
			 end if;
			 if(ena_3_3='1'and ena_3_c_3='1') then
						 if(ori_y-10>rand_3_num3_y+25 or ori_y+10<rand_3_num3_y-25 ) then
									 check<='1';
								elsif(ori_x+10<rand_3_num3_x-25 or ori_x-10>rand_3_num3_x+25) then
									 check<='1';
								else
									 lifecount<=lifecount+1;
									 ena_3_c_3<='0';
										if(lifecount=2)then
										game_over<='1';
										end if;
							end if;
					end if;
			 if(ena_3_4='1'and ena_3_c_4='1') then
								if(ori_y-10>rand_3_num4_y+25 or ori_y+10<rand_3_num4_y-25 ) then
									 check<='1';
								elsif(ori_x+10<rand_3_num4_x-25 or ori_x-10>rand_3_num4_x+25) then
									 check<='1';
								else
									 lifecount<=lifecount+1;
									 ena_3_c_4<='0';
										if(lifecount=2)then
										game_over<='1';
										end if;
								end if;
						 end if;
				if(ena_3_5='1'and ena_3_c_5='1') then
						 if(ori_y-10>rand_3_num5_y+25 or ori_y+10<rand_3_num5_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num5_x-25 or ori_x-10>rand_3_num5_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_5<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_3_6='1'and ena_3_c_6='1') then
					 if(ori_y-10>rand_3_num6_y+25 or ori_y+10<rand_3_num6_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_3_num6_x-25 or ori_x-10>rand_3_num6_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_3_c_6<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_3_7='1'and ena_3_c_7='1') then
					 if(ori_y-10>rand_3_num7_y+25 or ori_y+10<rand_3_num7_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_3_num7_x-25 or ori_x-10>rand_3_num7_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_3_c_7<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
				if(ena_3_8='1'and ena_3_c_8='1') then
					 if(ori_y-10>rand_3_num8_y+25 or ori_y+10<rand_3_num8_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_3_num8_x-25 or ori_x-10>rand_3_num8_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_3_c_8<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
		if(ena_3_9='1'and ena_3_c_9='1') then
				 if(ori_y-10>rand_3_num9_y+25 or ori_y+10<rand_3_num9_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_3_num9_x-25 or ori_x-10>rand_3_num9_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_3_c_9<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena_3_10='1'and ena_3_c_10='1') then
				 if(ori_y-10>rand_3_num10_y+25 or ori_y+10<rand_3_num10_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_3_num10_x-25 or ori_x-10>rand_3_num10_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_3_c_10<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena_3_11='1'and ena_3_c_11='1') then
				 if(ori_y-10>rand_3_num11_y+25 or ori_y+10<rand_3_num11_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_3_num11_x-25 or ori_x-10>rand_3_num11_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_3_c_11<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena_3_12='1'and ena_3_c_12='1') then
				 if(ori_y-10>rand_3_num12_y+25 or ori_y+10<rand_3_num12_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_3_num12_x-25 or ori_x-10>rand_3_num12_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_3_c_12<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena_3_13='1'and ena_3_c_13='1') then
				 if(ori_y-10>rand_3_num13_y+25 or ori_y+10<rand_3_num13_y-25 ) then
						check<='1';
				 elsif(ori_x+10<rand_3_num13_x-25 or ori_x-10>rand_3_num13_x+25) then
						check<='1';
				 else
						lifecount<=lifecount+1;
						ena_3_c_13<='0';
						if(lifecount=2)then
						game_over<='1';
						end if;
				 end if;
			end if;
		if(ena_3_14='1'and ena_3_c_14='1') then
			 if(ori_y-10>rand_3_num14_y+25 or ori_y+10<rand_3_num14_y-25 ) then
					check<='1';
			 elsif(ori_x+10<rand_3_num14_x-25 or ori_x-10>rand_3_num14_x+25) then
					check<='1';
			 else
					lifecount<=lifecount+1;
					ena_3_c_14<='0';
					if(lifecount=2)then
					game_over<='1';
					end if;
			 end if;
		end if;
		if(ena_3_15='1'and ena_3_c_15='1') then
							 if(ori_y-10>rand_3_num15_y+25 or ori_y+10<rand_3_num15_y-25 ) then
									check<='1';
							 elsif(ori_x+10<rand_3_num15_x-25 or ori_x-10>rand_3_num15_x+25) then
									check<='1';
							 else
									lifecount<=lifecount+1;
									ena_3_c_15<='0';
									if(lifecount=2)then
									game_over<='1';
									end if;
							 end if;
						end if;
						if(ena_3_16='1'and ena_3_c_16='1') then
							 if(ori_y-10>rand_3_num16_y+25 or ori_y+10<rand_3_num16_y-25 ) then
									check<='1';
							 elsif(ori_x+10<rand_3_num16_x-25 or ori_x-10>rand_3_num16_x+25) then
									check<='1';
							 else
									lifecount<=lifecount+1;
									ena_3_c_16<='0';
									if(lifecount=2)then
									game_over<='1';
									end if;
							 end if;
						end if;
				if(ena_3_17='1'and ena_3_c_17='1') then
						 if(ori_y-10>rand_3_num17_y+25 or ori_y+10<rand_3_num17_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num17_x-25 or ori_x-10>rand_3_num17_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_17<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_3_18='1'and ena_3_c_18='1') then
						 if(ori_y-10>rand_3_num18_y+25 or ori_y+10<rand_3_num18_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num18_x-25 or ori_x-10>rand_3_num18_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_18<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_3_19='1'and ena_3_c_19='1') then
						 if(ori_y-10>rand_3_num19_y+25 or ori_y+10<rand_3_num19_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num19_x-25 or ori_x-10>rand_3_num19_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_19<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_3_20='1'and ena_3_c_20='1') then
						 if(ori_y-10>rand_3_num20_y+25 or ori_y+10<rand_3_num20_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num20_x-25 or ori_x-10>rand_3_num20_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_20<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_3_21='1'and ena_3_c_21='1') then
						 if(ori_y-10>rand_3_num21_y+25 or ori_y+10<rand_3_num21_y-25 ) then
								check<='1';
						 elsif(ori_x+10<rand_3_num21_x-25 or ori_x-10>rand_3_num21_x+25) then
								check<='1';
						 else
								lifecount<=lifecount+1;
								ena_3_c_21<='0';
								if(lifecount=2)then
								game_over<='1';
								end if;
						 end if;
					end if;
				if(ena_3_22='1'and ena_3_c_22='1') then
					 if(ori_y-10>rand_3_num22_y+25 or ori_y+10<rand_3_num22_y-25 ) then
							check<='1';
					 elsif(ori_x+10<rand_3_num22_x-25 or ori_x-10>rand_3_num22_x+25) then
							check<='1';
					 else
							lifecount<=lifecount+1;
							ena_3_c_22<='0';
							if(lifecount=2)then
							game_over<='1';
							end if;
					 end if;
				end if;
 end if;  
end process control;

-- disaply
data_output_proc: process(hcount, vcount,g_state,game_over)
begin
 if (g_state = s0 and game_over='0') then
    if( ((hcount>=H_START+130 and hcount<H_START+180) and (vcount >= V_START+200 and vcount<V_START+210))
     or ((hcount>=H_START+130 and hcount<H_START+140) and (vcount >= V_START+210 and vcount<V_START+230))
     or ((hcount>=H_START+130 and hcount<H_START+180) and (vcount >= V_START+230 and vcount<V_START+240))
     or ((hcount>=H_START+170 and hcount<H_START+180) and (vcount >= V_START+240 and vcount<V_START+260))
     or ((hcount>=H_START+130 and hcount<H_START+180) and (vcount >= V_START+260 and vcount<V_START+270))
     or ((hcount>=H_START+200 and hcount<H_START+270) and (vcount >= V_START+200 and vcount<V_START+210))
     or ((hcount>=H_START+230 and hcount<H_START+240) and (vcount >= V_START+210 and vcount<V_START+270))
     or ((hcount>=H_START+290 and hcount<H_START+295) and (vcount >= V_START+260 and vcount<V_START+270))
     or ((hcount>=H_START+295 and hcount<H_START+300) and (vcount >= V_START+250 and vcount<V_START+260))
     or ((hcount>=H_START+300 and hcount<H_START+350) and (vcount >= V_START+240 and vcount<V_START+250))
     or ((hcount>=H_START+305 and hcount<H_START+310) and (vcount >= V_START+230 and vcount<V_START+240))
     or ((hcount>=H_START+310 and hcount<H_START+315) and (vcount >= V_START+220 and vcount<V_START+230))
     or ((hcount>=H_START+315 and hcount<H_START+320) and (vcount >= V_START+210 and vcount<V_START+220))
     or ((hcount>=H_START+320 and hcount<H_START+330) and (vcount >= V_START+200 and vcount<V_START+210))
     or ((hcount>=H_START+330 and hcount<H_START+335) and (vcount >= V_START+210 and vcount<V_START+220))
     or ((hcount>=H_START+335 and hcount<H_START+340) and (vcount >= V_START+220 and vcount<V_START+230))
     or ((hcount>=H_START+340 and hcount<H_START+345) and (vcount >= V_START+230 and vcount<V_START+240))
     or ((hcount>=H_START+350 and hcount<H_START+355) and (vcount >= V_START+250 and vcount<V_START+260))
     or ((hcount>=H_START+355 and hcount<H_START+360) and (vcount >= V_START+260 and vcount<V_START+270))
     or ((hcount>=H_START+370 and hcount<H_START+380) and (vcount >= V_START+200 and vcount<V_START+270))
     or ((hcount>=H_START+380 and hcount<H_START+420) and (vcount >= V_START+200 and vcount<V_START+210))
     or ((hcount>=H_START+410 and hcount<H_START+420) and (vcount >= V_START+210 and vcount<V_START+220))
     or ((hcount>=H_START+380 and hcount<H_START+420) and (vcount >= V_START+220 and vcount<V_START+230))
     or ((hcount>=H_START+380 and hcount<H_START+390) and (vcount >= V_START+230 and vcount<V_START+240))
     or ((hcount>=H_START+390 and hcount<H_START+400) and (vcount >= V_START+240 and vcount<V_START+250))
     or ((hcount>=H_START+400 and hcount<H_START+410) and (vcount >= V_START+250 and vcount<V_START+260))
     or ((hcount>=H_START+410 and hcount<H_START+420) and (vcount >= V_START+260 and vcount<V_START+270))
     or ((hcount>=H_START+440 and hcount<H_START+510) and (vcount >= V_START+200 and vcount<V_START+210))
     or ((hcount>=H_START+470 and hcount<H_START+480) and (vcount >= V_START+210 and vcount<V_START+270))) then
        red   <= "1111";
        green <= "1111";
		    blue  <= "1111";
    else
        red   <= "0000";
        green <= "0000";
        blue  <= "0000";
    end if;
  elsif (g_state =s1 and game_over='0') then
          if( ((hcount>=H_START+395 and hcount<H_START+400) and (vcount >= V_START+20 and vcount<V_START+35))
          or  ((hcount>=H_START+400 and hcount<H_START+405) and (vcount >= V_START+15 and vcount<V_START+40))
          or  ((hcount>=H_START+405 and hcount<H_START+410) and (vcount >= V_START+10 and vcount<V_START+45))
          or  ((hcount>=H_START+410 and hcount<H_START+415) and (vcount >= V_START+10 and vcount<V_START+50))
          or  ((hcount>=H_START+415 and hcount<H_START+420) and (vcount >= V_START+15 and vcount<V_START+55))
          or  ((hcount>=H_START+420 and hcount<H_START+425) and (vcount >= V_START+20 and vcount<V_START+60))
          or  ((hcount>=H_START+425 and hcount<H_START+435) and (vcount >= V_START+25 and vcount<V_START+65))
          or  ((hcount>=H_START+435 and hcount<H_START+440) and (vcount >= V_START+20 and vcount<V_START+60))
          or  ((hcount>=H_START+440 and hcount<H_START+445) and (vcount >= V_START+15 and vcount<V_START+55))
          or  ((hcount>=H_START+445 and hcount<H_START+450) and (vcount >= V_START+10 and vcount<V_START+50))
          or  ((hcount>=H_START+450 and hcount<H_START+455) and (vcount >= V_START+10 and vcount<V_START+45))
          or  ((hcount>=H_START+455 and hcount<H_START+460) and (vcount >= V_START+15 and vcount<V_START+40))
          or  ((hcount>=H_START+460 and hcount<H_START+465) and (vcount >= V_START+20 and vcount<V_START+35))) then
              if(lifecount<1) then
							 red   <= "1100";
								green <= "0000";
								blue  <= "0000";
								else
								red   <= "0000";
								green <= "0000";
								blue  <= "0000";
								end if;
			    elsif( ((hcount>=H_START+475 and hcount<H_START+480) and (vcount >= V_START+20 and vcount<V_START+35))
							or  ((hcount>=H_START+480 and hcount<H_START+485) and (vcount >= V_START+15 and vcount<V_START+40))
							or  ((hcount>=H_START+485 and hcount<H_START+490) and (vcount >= V_START+10 and vcount<V_START+45))
							or  ((hcount>=H_START+490 and hcount<H_START+495) and (vcount >= V_START+10 and vcount<V_START+50))
							or  ((hcount>=H_START+495 and hcount<H_START+500) and (vcount >= V_START+15 and vcount<V_START+55))
							or  ((hcount>=H_START+500 and hcount<H_START+505) and (vcount >= V_START+20 and vcount<V_START+60))
							or  ((hcount>=H_START+505 and hcount<H_START+515) and (vcount >= V_START+25 and vcount<V_START+65))
							or  ((hcount>=H_START+515 and hcount<H_START+520) and (vcount >= V_START+20 and vcount<V_START+60))
							or  ((hcount>=H_START+520 and hcount<H_START+525) and (vcount >= V_START+15 and vcount<V_START+55))
							or  ((hcount>=H_START+525 and hcount<H_START+530) and (vcount >= V_START+10 and vcount<V_START+50))
							or  ((hcount>=H_START+530 and hcount<H_START+535) and (vcount >= V_START+10 and vcount<V_START+45))
							or  ((hcount>=H_START+535 and hcount<H_START+540) and (vcount >= V_START+15 and vcount<V_START+40))
							or  ((hcount>=H_START+540 and hcount<H_START+545) and (vcount >= V_START+20 and vcount<V_START+35))) then
									if(lifecount<2) then
									 red   <= "1100";
										green <= "0000";
										blue  <= "0000";
										else
										red   <= "0000";
										green <= "0000";
										blue  <= "0000";
										end if;
					elsif( ((hcount>=H_START+555 and hcount<H_START+560) and (vcount >= V_START+20 and vcount<V_START+35))
							or  ((hcount>=H_START+560 and hcount<H_START+565) and (vcount >= V_START+15 and vcount<V_START+40))
							or  ((hcount>=H_START+565 and hcount<H_START+570) and (vcount >= V_START+10 and vcount<V_START+45))
							or  ((hcount>=H_START+570 and hcount<H_START+575) and (vcount >= V_START+10 and vcount<V_START+50))
							or  ((hcount>=H_START+575 and hcount<H_START+580) and (vcount >= V_START+15 and vcount<V_START+55))
							or  ((hcount>=H_START+580 and hcount<H_START+585) and (vcount >= V_START+20 and vcount<V_START+60))
							or  ((hcount>=H_START+585 and hcount<H_START+595) and (vcount >= V_START+25 and vcount<V_START+65))
							or  ((hcount>=H_START+595 and hcount<H_START+600) and (vcount >= V_START+20 and vcount<V_START+60))
							or  ((hcount>=H_START+600 and hcount<H_START+605) and (vcount >= V_START+15 and vcount<V_START+55))
							or  ((hcount>=H_START+605 and hcount<H_START+610) and (vcount >= V_START+10 and vcount<V_START+50))
							or  ((hcount>=H_START+610 and hcount<H_START+615) and (vcount >= V_START+10 and vcount<V_START+45))
							or  ((hcount>=H_START+615 and hcount<H_START+620) and (vcount >= V_START+15 and vcount<V_START+40))
							or  ((hcount>=H_START+620 and hcount<H_START+625) and (vcount >= V_START+20 and vcount<V_START+35))) then
									if(lifecount<3) then
									 red   <= "1100";
										green <= "0000";
										blue  <= "0000";
										else
										red   <= "0000";
										green <= "0000";
										blue  <= "0000";
										end if;
          elsif( (hcount>=H_START+ori_x-10 and hcount<H_START+ori_x+10) and (vcount >= V_START+ori_y-10 and vcount<V_START+ori_y+10)) then
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
          elsif ((hcount>=H_START+rand_num1_x-25 and hcount<H_START+rand_num1_x+25) and (vcount >= V_START+rand_num1_y-25 and vcount<V_START+rand_num1_y+25)) then
            if( ena1='1'and ena_c_1='1') then
            red   <= "1111";
            green <= "1100";
            blue  <= "1111";
            else 
            red   <= "0000";
            green <= "0000";
            blue  <= "0000";
            end if;
          elsif ((hcount>=H_START+rand_num2_x-25 and hcount<H_START+rand_num2_x+25) and (vcount >= V_START+rand_num2_y-25 and vcount<V_START+rand_num2_y+25)) then
            if( ena2='1'and ena_c_2='1') then
            red   <= "1111";
            green <= "1100";
            blue  <= "1100";
            else 
            red   <= "0000";
            green <= "0000";
             blue  <= "0000";
            end if;
          elsif ((hcount>=H_START+rand_num3_x-25 and hcount<H_START+rand_num3_x+25) and (vcount >= V_START+rand_num3_y-25 and vcount<V_START+rand_num3_y+25)) then
            if( ena3='1'and ena_c_3='1') then
							red   <= "1000";
							green <= "1100";
							blue  <= "1100";
							else 
							red   <= "0000";
							green <= "0000";
							 blue  <= "0000";
							end if;
			   elsif ((hcount>=H_START+rand_num4_x-25 and hcount<H_START+rand_num4_x+25) and (vcount >= V_START+rand_num4_y-25 and vcount<V_START+rand_num4_y+25)) then
          if( ena4='1'and ena_c_4='1') then
               red   <= "1000";
              green <= "1100";
             blue  <= "1111";
            else 
             red   <= "0000";
             green <= "0000";
              blue  <= "0000";
            end if;
          elsif ((hcount>=H_START+rand_num5_x-25 and hcount<H_START+rand_num5_x+25) and (vcount >= V_START+rand_num5_y-25 and vcount<V_START+rand_num5_y+25)) then
            if( ena5='1'and ena_c_5='1') then
							 red   <= "1010";
							green <= "0010";
						 blue  <= "0111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
				  elsif ( (hcount>=H_START+rand_num6_x-25 and hcount<H_START+rand_num6_x+25) and (vcount >= V_START+rand_num6_y-25 and vcount<V_START+rand_num6_y+25)) then
				     if(ena6='1'and ena_c_6='1') then
							 red   <= "0010";
							green <= "1010";
						 blue  <= "0111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
				 elsif ((hcount>=H_START+rand_num7_x-25 and hcount<H_START+rand_num7_x+25) and (vcount >= V_START+rand_num7_y-25 and vcount<V_START+rand_num7_y+25)) then
					 if( ena7='1'and ena_c_7='1') then
							 red   <= "1111";
							green <= "0000";
						 blue  <= "1111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
				 elsif ((hcount>=H_START+rand_num8_x-25 and hcount<H_START+rand_num8_x+25) and (vcount >= V_START+rand_num8_y-25 and vcount<V_START+rand_num8_y+25)) then
					  if( ena8='1'and ena_c_8='1') then
							 red   <= "1111";
							green <= "1001";
						 blue  <= "1001";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
          else 
           red   <= "0000";
           green <= "0000";
           blue  <= "0000";
          end if;
  elsif (g_state =s2 and game_over='0') then
          if( ((hcount>=H_START+395 and hcount<H_START+400) and (vcount >= V_START+20 and vcount<V_START+35))
            or  ((hcount>=H_START+400 and hcount<H_START+405) and (vcount >= V_START+15 and vcount<V_START+40))
            or  ((hcount>=H_START+405 and hcount<H_START+410) and (vcount >= V_START+10 and vcount<V_START+45))
            or  ((hcount>=H_START+410 and hcount<H_START+415) and (vcount >= V_START+10 and vcount<V_START+50))
            or  ((hcount>=H_START+415 and hcount<H_START+420) and (vcount >= V_START+15 and vcount<V_START+55))
            or  ((hcount>=H_START+420 and hcount<H_START+425) and (vcount >= V_START+20 and vcount<V_START+60))
            or  ((hcount>=H_START+425 and hcount<H_START+435) and (vcount >= V_START+25 and vcount<V_START+65))
            or  ((hcount>=H_START+435 and hcount<H_START+440) and (vcount >= V_START+20 and vcount<V_START+60))
            or  ((hcount>=H_START+440 and hcount<H_START+445) and (vcount >= V_START+15 and vcount<V_START+55))
            or  ((hcount>=H_START+445 and hcount<H_START+450) and (vcount >= V_START+10 and vcount<V_START+50))
            or  ((hcount>=H_START+450 and hcount<H_START+455) and (vcount >= V_START+10 and vcount<V_START+45))
            or  ((hcount>=H_START+455 and hcount<H_START+460) and (vcount >= V_START+15 and vcount<V_START+40))
            or  ((hcount>=H_START+460 and hcount<H_START+465) and (vcount >= V_START+20 and vcount<V_START+35))) then
                if(lifecount<1) then
  							 red   <= "1100";
  								green <= "0000";
  								blue  <= "0000";
  								else
									red   <= "0000";
									green <= "0000";
									blue  <= "0000";
  								end if;
  			    elsif( ((hcount>=H_START+475 and hcount<H_START+480) and (vcount >= V_START+20 and vcount<V_START+35))
  							or  ((hcount>=H_START+480 and hcount<H_START+485) and (vcount >= V_START+15 and vcount<V_START+40))
  							or  ((hcount>=H_START+485 and hcount<H_START+490) and (vcount >= V_START+10 and vcount<V_START+45))
  							or  ((hcount>=H_START+490 and hcount<H_START+495) and (vcount >= V_START+10 and vcount<V_START+50))
  							or  ((hcount>=H_START+495 and hcount<H_START+500) and (vcount >= V_START+15 and vcount<V_START+55))
  							or  ((hcount>=H_START+500 and hcount<H_START+505) and (vcount >= V_START+20 and vcount<V_START+60))
  							or  ((hcount>=H_START+505 and hcount<H_START+515) and (vcount >= V_START+25 and vcount<V_START+65))
  							or  ((hcount>=H_START+515 and hcount<H_START+520) and (vcount >= V_START+20 and vcount<V_START+60))
  							or  ((hcount>=H_START+520 and hcount<H_START+525) and (vcount >= V_START+15 and vcount<V_START+55))
  							or  ((hcount>=H_START+525 and hcount<H_START+530) and (vcount >= V_START+10 and vcount<V_START+50))
  							or  ((hcount>=H_START+530 and hcount<H_START+535) and (vcount >= V_START+10 and vcount<V_START+45))
  							or  ((hcount>=H_START+535 and hcount<H_START+540) and (vcount >= V_START+15 and vcount<V_START+40))
  							or  ((hcount>=H_START+540 and hcount<H_START+545) and (vcount >= V_START+20 and vcount<V_START+35))) then
  									if(lifecount<2) then
  									 red   <= "1100";
  										green <= "0000";
  										blue  <= "0000";
  										else
											red   <= "0000";
											green <= "0000";
											blue  <= "0000";
  										end if;
  					elsif( ((hcount>=H_START+555 and hcount<H_START+560) and (vcount >= V_START+20 and vcount<V_START+35))
  							or  ((hcount>=H_START+560 and hcount<H_START+565) and (vcount >= V_START+15 and vcount<V_START+40))
  							or  ((hcount>=H_START+565 and hcount<H_START+570) and (vcount >= V_START+10 and vcount<V_START+45))
  							or  ((hcount>=H_START+570 and hcount<H_START+575) and (vcount >= V_START+10 and vcount<V_START+50))
  							or  ((hcount>=H_START+575 and hcount<H_START+580) and (vcount >= V_START+15 and vcount<V_START+55))
  							or  ((hcount>=H_START+580 and hcount<H_START+585) and (vcount >= V_START+20 and vcount<V_START+60))
  							or  ((hcount>=H_START+585 and hcount<H_START+595) and (vcount >= V_START+25 and vcount<V_START+65))
  							or  ((hcount>=H_START+595 and hcount<H_START+600) and (vcount >= V_START+20 and vcount<V_START+60))
  							or  ((hcount>=H_START+600 and hcount<H_START+605) and (vcount >= V_START+15 and vcount<V_START+55))
  							or  ((hcount>=H_START+605 and hcount<H_START+610) and (vcount >= V_START+10 and vcount<V_START+50))
  							or  ((hcount>=H_START+610 and hcount<H_START+615) and (vcount >= V_START+10 and vcount<V_START+45))
  							or  ((hcount>=H_START+615 and hcount<H_START+620) and (vcount >= V_START+15 and vcount<V_START+40))
  							or  ((hcount>=H_START+620 and hcount<H_START+625) and (vcount >= V_START+20 and vcount<V_START+35))) then
  									if(lifecount<3) then
  									 red   <= "1100";
  										green <= "0000";
  										blue  <= "0000";
  										else
											red   <= "0000";
											green <= "0000";
											blue  <= "0000";
  										end if;
					elsif( (hcount>=H_START+ori_x-10 and hcount<H_START+ori_x+10) and (vcount >= V_START+ori_y-10 and vcount<V_START+ori_y+10)) then
						red   <= "1111";
						green <= "1111";
						blue  <= "1111";
					elsif( (hcount>=H_START+rand_2_num1_x-25 and hcount<H_START+rand_2_num1_x+25) and (vcount >= V_START+rand_2_num1_y-25 and vcount<V_START+rand_2_num1_y+25)) then
						if (ena_2_1='1'and ena_2_c_1='1') then
						red   <= "1111";
						green <= "1100";
						blue  <= "1111";
						else 
						red   <= "0000";
						green <= "0000";
						blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num2_x-25 and hcount<H_START+rand_2_num2_x+25) and (vcount >= V_START+rand_2_num2_y-25 and vcount<V_START+rand_2_num2_y+25)) then
						if (ena_2_2='1'and ena_2_c_2='1') then
						red   <= "1111";
						green <= "1100";
						blue  <= "1100";
						else 
						red   <= "0000";
						green <= "0000";
						 blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num3_x-25 and hcount<H_START+rand_2_num3_x+25) and (vcount >= V_START+rand_2_num3_y-25 and vcount<V_START+rand_2_num3_y+25)) then
							if (ena_2_3='1'and ena_2_c_3='1') then
							red   <= "1000";
							green <= "1100";
							blue  <= "1100";
							else 
							red   <= "0000";
							green <= "0000";
							 blue  <= "0000";
							end if;
					elsif( (hcount>=H_START+rand_2_num4_x-25 and hcount<H_START+rand_2_num4_x+25) and (vcount >= V_START+rand_2_num4_y-25 and vcount<V_START+rand_2_num4_y+25)) then
							if (ena_2_4='1'and ena_2_c_4='1') then
							 red   <= "1000";
							green <= "1100";
						 blue  <= "1111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num5_x-25 and hcount<H_START+rand_2_num5_x+25) and (vcount >= V_START+rand_2_num5_y-25 and vcount<V_START+rand_2_num5_y+25)) then
							if (ena_2_5='1'and ena_2_c_5='1') then
							 red   <= "1010";
							green <= "0010";
						 blue  <= "0111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num6_x-25 and hcount<H_START+rand_2_num6_x+25) and (vcount >= V_START+rand_2_num6_y-25 and vcount<V_START+rand_2_num6_y+25)) then
							if (ena_2_6='1'and ena_2_c_6='1') then
							 red   <= "0010";
							green <= "1010";
						 blue  <= "0111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num7_x-25 and hcount<H_START+rand_2_num7_x+25) and (vcount >= V_START+rand_2_num7_y-25 and vcount<V_START+rand_2_num7_y+25)) then
							if (ena_2_7='1'and ena_2_c_7='1') then
							 red   <= "1111";
							green <= "0000";
						 blue  <= "1111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num8_x-25 and hcount<H_START+rand_2_num8_x+25) and (vcount >= V_START+rand_2_num8_y-25 and vcount<V_START+rand_2_num8_y+25)) then
							if (ena_2_8='1'and ena_2_c_8='1') then
							 red   <= "1111";
							green <= "1111";
						 blue  <= "1001";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num9_x-25 and hcount<H_START+rand_2_num9_x+25) and (vcount >= V_START+rand_2_num9_y-25 and vcount<V_START+rand_2_num9_y+25)) then
							if (ena_2_9='1'and ena_2_c_9='1') then
							 red   <= "1000";
							green <= "0111";
						 blue  <= "1001";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num10_x-25 and hcount<H_START+rand_2_num10_x+25) and (vcount >= V_START+rand_2_num10_y-25 and vcount<V_START+rand_2_num10_y+25)) then
							if (ena_2_10='1'and ena_2_c_10='1') then
							 red   <= "1000";
							green <= "0001";
						 blue  <= "0101";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num11_x-25 and hcount<H_START+rand_2_num11_x+25) and (vcount >= V_START+rand_2_num11_y-25 and vcount<V_START+rand_2_num11_y+25)) then
							if (ena_2_11='1'and ena_2_c_11='1') then
							 red   <= "1000";
							green <= "0001";
						 blue  <= "0101";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_2_num12_x-25 and hcount<H_START+rand_2_num12_x+25) and (vcount >= V_START+rand_2_num12_y-25 and vcount<V_START+rand_2_num12_y+25)) then
									if (ena_2_12='1'and ena_2_c_12='1') then
									 red   <= "1010";
									green <= "1010";
								 blue  <= "0111";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
							elsif( (hcount>=H_START+rand_2_num13_x-25 and hcount<H_START+rand_2_num13_x+25) and (vcount >= V_START+rand_2_num13_y-25 and vcount<V_START+rand_2_num13_y+25)) then
									if (ena_2_13='1'and ena_2_c_13='1') then
									 red   <= "0011";
									green <= "1011";
								 blue  <= "0111";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
							elsif( (hcount>=H_START+rand_2_num14_x-25 and hcount<H_START+rand_2_num14_x+25) and (vcount >= V_START+rand_2_num14_y-25 and vcount<V_START+rand_2_num14_y+25)) then
									if (ena_2_14='1'and ena_2_c_14='1') then
									 red   <= "1100";
									green <= "0101";
								 blue  <= "1111";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
							elsif( (hcount>=H_START+rand_2_num15_x-25 and hcount<H_START+rand_2_num15_x+25) and (vcount >= V_START+rand_2_num15_y-25 and vcount<V_START+rand_2_num15_y+25)) then
									if (ena_2_15='1'and ena_2_c_15='1') then
									 red   <= "1011";
									green <= "0111";
								 blue  <= "1001";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
							elsif( (hcount>=H_START+rand_2_num16_x-25 and hcount<H_START+rand_2_num16_x+25) and (vcount >= V_START+rand_2_num16_y-25 and vcount<V_START+rand_2_num16_y+25)) then
									if (ena_2_16='1'and ena_2_c_16='1') then
									 red   <= "1001";
									green <= "0101";
								 blue  <= "1001";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
							elsif( (hcount>=H_START+rand_2_num17_x-25 and hcount<H_START+rand_2_num17_x+25) and (vcount >= V_START+rand_2_num17_y-25 and vcount<V_START+rand_2_num17_y+25)) then
									if (ena_2_17='1'and ena_2_c_17='1') then
									 red   <= "0000";
									green <= "0101";
								 blue  <= "0101";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
							elsif( (hcount>=H_START+rand_2_num18_x-25 and hcount<H_START+rand_2_num18_x+25) and (vcount >= V_START+rand_2_num18_y-25 and vcount<V_START+rand_2_num18_y+25)) then
									if (ena_2_18='1'and ena_2_c_18='1') then
									 red   <= "1000";
									green <= "1001";
								 blue  <= "0000";
								else 
								 red   <= "0000";
								 green <= "0000";
									blue  <= "0000";
								end if;
					else 
					 red   <= "0000";
					 green <= "0000";
					 blue  <= "0000";
					end if;
	    elsif (g_state =s3 and game_over='0') then
	        if( ((hcount>=H_START+395 and hcount<H_START+400) and (vcount >= V_START+20 and vcount<V_START+35))
	              or  ((hcount>=H_START+400 and hcount<H_START+405) and (vcount >= V_START+15 and vcount<V_START+40))
	              or  ((hcount>=H_START+405 and hcount<H_START+410) and (vcount >= V_START+10 and vcount<V_START+45))
	              or  ((hcount>=H_START+410 and hcount<H_START+415) and (vcount >= V_START+10 and vcount<V_START+50))
	              or  ((hcount>=H_START+415 and hcount<H_START+420) and (vcount >= V_START+15 and vcount<V_START+55))
	              or  ((hcount>=H_START+420 and hcount<H_START+425) and (vcount >= V_START+20 and vcount<V_START+60))
	              or  ((hcount>=H_START+425 and hcount<H_START+435) and (vcount >= V_START+25 and vcount<V_START+65))
	              or  ((hcount>=H_START+435 and hcount<H_START+440) and (vcount >= V_START+20 and vcount<V_START+60))
	              or  ((hcount>=H_START+440 and hcount<H_START+445) and (vcount >= V_START+15 and vcount<V_START+55))
	              or  ((hcount>=H_START+445 and hcount<H_START+450) and (vcount >= V_START+10 and vcount<V_START+50))
	              or  ((hcount>=H_START+450 and hcount<H_START+455) and (vcount >= V_START+10 and vcount<V_START+45))
	              or  ((hcount>=H_START+455 and hcount<H_START+460) and (vcount >= V_START+15 and vcount<V_START+40))
	              or  ((hcount>=H_START+460 and hcount<H_START+465) and (vcount >= V_START+20 and vcount<V_START+35))) then
	                  if(lifecount<1) then
	    							 red   <= "1100";
	    								green <= "0000";
	    								blue  <= "0000";
	    							else
											red   <= "0000";
											green <= "0000";
											blue  <= "0000";
	    								end if;
	    			    elsif( ((hcount>=H_START+475 and hcount<H_START+480) and (vcount >= V_START+20 and vcount<V_START+35))
	    							or  ((hcount>=H_START+480 and hcount<H_START+485) and (vcount >= V_START+15 and vcount<V_START+40))
	    							or  ((hcount>=H_START+485 and hcount<H_START+490) and (vcount >= V_START+10 and vcount<V_START+45))
	    							or  ((hcount>=H_START+490 and hcount<H_START+495) and (vcount >= V_START+10 and vcount<V_START+50))
	    							or  ((hcount>=H_START+495 and hcount<H_START+500) and (vcount >= V_START+15 and vcount<V_START+55))
	    							or  ((hcount>=H_START+500 and hcount<H_START+505) and (vcount >= V_START+20 and vcount<V_START+60))
	    							or  ((hcount>=H_START+505 and hcount<H_START+515) and (vcount >= V_START+25 and vcount<V_START+65))
	    							or  ((hcount>=H_START+515 and hcount<H_START+520) and (vcount >= V_START+20 and vcount<V_START+60))
	    							or  ((hcount>=H_START+520 and hcount<H_START+525) and (vcount >= V_START+15 and vcount<V_START+55))
	    							or  ((hcount>=H_START+525 and hcount<H_START+530) and (vcount >= V_START+10 and vcount<V_START+50))
	    							or  ((hcount>=H_START+530 and hcount<H_START+535) and (vcount >= V_START+10 and vcount<V_START+45))
	    							or  ((hcount>=H_START+535 and hcount<H_START+540) and (vcount >= V_START+15 and vcount<V_START+40))
	    							or  ((hcount>=H_START+540 and hcount<H_START+545) and (vcount >= V_START+20 and vcount<V_START+35))) then
	    									if(lifecount<2) then
	    									 red   <= "1100";
	    										green <= "0000";
	    										blue  <= "0000";
	    										else
													red   <= "0000";
													green <= "0000";
													blue  <= "0000";
	    										end if;
	    					elsif( ((hcount>=H_START+555 and hcount<H_START+560) and (vcount >= V_START+20 and vcount<V_START+35))
	    							or  ((hcount>=H_START+560 and hcount<H_START+565) and (vcount >= V_START+15 and vcount<V_START+40))
	    							or  ((hcount>=H_START+565 and hcount<H_START+570) and (vcount >= V_START+10 and vcount<V_START+45))
	    							or  ((hcount>=H_START+570 and hcount<H_START+575) and (vcount >= V_START+10 and vcount<V_START+50))
	    							or  ((hcount>=H_START+575 and hcount<H_START+580) and (vcount >= V_START+15 and vcount<V_START+55))
	    							or  ((hcount>=H_START+580 and hcount<H_START+585) and (vcount >= V_START+20 and vcount<V_START+60))
	    							or  ((hcount>=H_START+585 and hcount<H_START+595) and (vcount >= V_START+25 and vcount<V_START+65))
	    							or  ((hcount>=H_START+595 and hcount<H_START+600) and (vcount >= V_START+20 and vcount<V_START+60))
	    							or  ((hcount>=H_START+600 and hcount<H_START+605) and (vcount >= V_START+15 and vcount<V_START+55))
	    							or  ((hcount>=H_START+605 and hcount<H_START+610) and (vcount >= V_START+10 and vcount<V_START+50))
	    							or  ((hcount>=H_START+610 and hcount<H_START+615) and (vcount >= V_START+10 and vcount<V_START+45))
	    							or  ((hcount>=H_START+615 and hcount<H_START+620) and (vcount >= V_START+15 and vcount<V_START+40))
	    							or  ((hcount>=H_START+620 and hcount<H_START+625) and (vcount >= V_START+20 and vcount<V_START+35))) then
	    									if(lifecount<3) then
	    									 red   <= "1100";
	    										green <= "0000";
	    										blue  <= "0000";
	    										else
													red   <= "0000";
													green <= "0000";
													blue  <= "0000";
	    										end if;
					elsif( (hcount>=H_START+ori_x-10 and hcount<H_START+ori_x+10) and (vcount >= V_START+ori_y-10 and vcount<V_START+ori_y+10)) then
						red   <= "1111";
						green <= "1111";
						blue  <= "1111";
					elsif( (hcount>=H_START+rand_3_num1_x-25 and hcount<H_START+rand_3_num1_x+25) and (vcount >= V_START+rand_3_num1_y-25 and vcount<V_START+rand_3_num1_y+25)) then
						if (ena_3_1='1'and ena_3_c_1='1') then
						red   <= "1111";
						green <= "1100";
						blue  <= "1111";
						else 
						red   <= "0000";
						green <= "0000";
						blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num2_x-25 and hcount<H_START+rand_3_num2_x+25) and (vcount >= V_START+rand_3_num2_y-25 and vcount<V_START+rand_3_num2_y+25)) then
						if (ena_3_2='1'and ena_3_c_2='1') then
						red   <= "1111";
						green <= "1100";
						blue  <= "1100";
						else 
						red   <= "0000";
						green <= "0000";
						 blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num3_x-25 and hcount<H_START+rand_3_num3_x+25) and (vcount >= V_START+rand_3_num3_y-25 and vcount<V_START+rand_3_num3_y+25)) then
							if (ena_3_3='1'and ena_3_c_3='1') then
							red   <= "1000";
							green <= "1100";
							blue  <= "1100";
							else 
							red   <= "0000";
							green <= "0000";
							 blue  <= "0000";
							end if;
					elsif( (hcount>=H_START+rand_3_num4_x-25 and hcount<H_START+rand_3_num4_x+25) and (vcount >= V_START+rand_3_num4_y-25 and vcount<V_START+rand_3_num4_y+25)) then
							if (ena_3_4='1'and ena_3_c_4='1') then
							 red   <= "1000";
							green <= "1100";
						 blue  <= "1111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num5_x-25 and hcount<H_START+rand_3_num5_x+25) and (vcount >= V_START+rand_3_num5_y-25 and vcount<V_START+rand_3_num5_y+25)) then
							if (ena_3_5='1'and ena_3_c_5='1') then
							 red   <= "1010";
							green <= "0010";
						 blue  <= "0111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num6_x-25 and hcount<H_START+rand_3_num6_x+25) and (vcount >= V_START+rand_3_num6_y-25 and vcount<V_START+rand_3_num6_y+25)) then
							if (ena_3_6='1'and ena_3_c_6='1') then
							 red   <= "0010";
							green <= "1010";
						 blue  <= "0111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num7_x-25 and hcount<H_START+rand_3_num7_x+25) and (vcount >= V_START+rand_3_num7_y-25 and vcount<V_START+rand_3_num7_y+25)) then
							if (ena_3_7='1'and ena_3_c_7='1') then
							 red   <= "1111";
							green <= "0000";
						 blue  <= "1111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num8_x-25 and hcount<H_START+rand_3_num8_x+25) and (vcount >= V_START+rand_3_num8_y-25 and vcount<V_START+rand_3_num8_y+25)) then
							if (ena_3_8='1'and ena_3_c_8='1') then
							 red   <= "1111";
							green <= "1111";
						 blue  <= "1001";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num9_x-25 and hcount<H_START+rand_3_num9_x+25) and (vcount >= V_START+rand_3_num9_y-25 and vcount<V_START+rand_3_num9_y+25)) then
							if (ena_3_9='1'and ena_3_c_9='1') then
							 red   <= "0111";
							green <= "1100";
						 blue  <= "1001";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num10_x-25 and hcount<H_START+rand_3_num10_x+25) and (vcount >= V_START+rand_3_num10_y-25 and vcount<V_START+rand_3_num10_y+25)) then
							if (ena_3_10='1'and ena_3_c_10='1') then
							 red   <= "0111";
							green <= "1100";
						 blue  <= "1001";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num11_x-25 and hcount<H_START+rand_3_num11_x+25) and (vcount >= V_START+rand_3_num11_y-25 and vcount<V_START+rand_3_num11_y+25)) then
							if (ena_3_11='1'and ena_3_c_11='1') then
							 red   <= "0101";
							green <= "0100";
						 blue  <= "1111";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num12_x-25 and hcount<H_START+rand_3_num12_x+25) and (vcount >= V_START+rand_3_num12_y-25 and vcount<V_START+rand_3_num12_y+25)) then
							if (ena_3_12='1'and ena_3_c_12='1') then
							 red   <= "1101";
							green <= "0100";
						 blue  <= "0101";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num13_x-25 and hcount<H_START+rand_3_num13_x+25) and (vcount >= V_START+rand_3_num13_y-25 and vcount<V_START+rand_3_num13_y+25)) then
							if (ena_3_13='1'and ena_3_c_13='1') then
							 red   <= "0101";
							green <= "1110";
						 blue  <= "0101";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num14_x-25 and hcount<H_START+rand_3_num14_x+25) and (vcount >= V_START+rand_3_num14_y-25 and vcount<V_START+rand_3_num14_y+25)) then
							if (ena_3_14='1'and ena_3_c_14='1') then
							 red   <= "1101";
							green <= "1111";
						 blue  <= "0101";
						else 
						 red   <= "0000";
						 green <= "0000";
							blue  <= "0000";
						end if;
					elsif( (hcount>=H_START+rand_3_num15_x-25 and hcount<H_START+rand_3_num15_x+25) and (vcount >= V_START+rand_3_num15_y-25 and vcount<V_START+rand_3_num15_y+25)) then
													if (ena_3_15='1'and ena_3_c_15='1') then
													 red   <= "1111";
													green <= "0000";
												 blue  <= "0101";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num16_x-25 and hcount<H_START+rand_3_num16_x+25) and (vcount >= V_START+rand_3_num16_y-25 and vcount<V_START+rand_3_num16_y+25)) then
													if (ena_3_16='1'and ena_3_c_16='1') then
													 red   <= "1011";
													green <= "0111";
												 blue  <= "1001";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num17_x-25 and hcount<H_START+rand_3_num17_x+25) and (vcount >= V_START+rand_3_num17_y-25 and vcount<V_START+rand_3_num17_y+25)) then
													if (ena_3_17='1'and ena_3_c_17='1') then
													 red   <= "0010";
													green <= "1100";
												 blue  <= "0001";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num18_x-25 and hcount<H_START+rand_3_num18_x+25) and (vcount >= V_START+rand_3_num18_y-25 and vcount<V_START+rand_3_num18_y+25)) then
													if (ena_3_18='1'and ena_3_c_18='1') then
													 red   <= "0101";
													green <= "1100";
												 blue  <= "0101";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num19_x-25 and hcount<H_START+rand_3_num19_x+25) and (vcount >= V_START+rand_3_num19_y-25 and vcount<V_START+rand_3_num19_y+25)) then
													if (ena_3_19='1'and ena_3_c_19='1') then
													 red   <= "0001";
													green <= "0000";
												 blue  <= "1111";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num20_x-25 and hcount<H_START+rand_3_num20_x+25) and (vcount >= V_START+rand_3_num20_y-25 and vcount<V_START+rand_3_num20_y+25)) then
													if (ena_3_20='1'and ena_3_c_20='1') then
													 red   <= "1101";
													green <= "0111";
												 blue  <= "0101";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num21_x-25 and hcount<H_START+rand_3_num21_x+25) and (vcount >= V_START+rand_3_num21_y-25 and vcount<V_START+rand_3_num21_y+25)) then
													if (ena_3_21='1'and ena_3_c_21='1') then
													 red   <= "0001";
													green <= "1010";
												 blue  <= "0101";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
											elsif( (hcount>=H_START+rand_3_num22_x-25 and hcount<H_START+rand_3_num22_x+25) and (vcount >= V_START+rand_3_num22_y-25 and vcount<V_START+rand_3_num22_y+25)) then
													if (ena_3_22='1'and ena_3_c_22='1') then
													 red   <= "0101";
													green <= "0101";
												 blue  <= "0101";
												else 
												 red   <= "0000";
												 green <= "0000";
													blue  <= "0000";
												end if;
					else 
					 red   <= "0000";
					 green <= "0000";
					 blue  <= "0000";
					end if;
  elsif(g_state=s4 and game_over ='0')then
      if (((hcount>=H_START+70 and hcount<H_START+75) and (vcount >= V_START+100 and vcount<V_START+110))
       or ((hcount>=H_START+75 and hcount<H_START+80) and (vcount >= V_START+110 and vcount<V_START+120))
       or ((hcount>=H_START+80 and hcount<H_START+85) and (vcount >= V_START+120 and vcount<V_START+130))
       or ((hcount>=H_START+85 and hcount<H_START+90) and (vcount >= V_START+130 and vcount<V_START+140))
       or ((hcount>=H_START+90 and hcount<H_START+95) and (vcount >= V_START+140 and vcount<V_START+150))
       or ((hcount>=H_START+95 and hcount<H_START+100) and (vcount >= V_START+150 and vcount<V_START+160))
       or ((hcount>=H_START+100 and hcount<H_START+105) and (vcount >= V_START+160 and vcount<V_START+170))
       or ((hcount>=H_START+105 and hcount<H_START+110) and (vcount >= V_START+150 and vcount<V_START+160))
       or ((hcount>=H_START+110 and hcount<H_START+115) and (vcount >= V_START+140 and vcount<V_START+150))
       or ((hcount>=H_START+115 and hcount<H_START+120) and (vcount >= V_START+130 and vcount<V_START+140))
       or ((hcount>=H_START+120 and hcount<H_START+125) and (vcount >= V_START+120 and vcount<V_START+130))
       or ((hcount>=H_START+125 and hcount<H_START+130) and (vcount >= V_START+110 and vcount<V_START+120))
       or ((hcount>=H_START+130 and hcount<H_START+135) and (vcount >= V_START+100 and vcount<V_START+110))
       or ((hcount>=H_START+135 and hcount<H_START+140) and (vcount >= V_START+110 and vcount<V_START+120))
       or ((hcount>=H_START+140 and hcount<H_START+145) and (vcount >= V_START+120 and vcount<V_START+130))
       or ((hcount>=H_START+145 and hcount<H_START+150) and (vcount >= V_START+130 and vcount<V_START+140))
       or ((hcount>=H_START+150 and hcount<H_START+155) and (vcount >= V_START+140 and vcount<V_START+150))
       or ((hcount>=H_START+155 and hcount<H_START+160) and (vcount >= V_START+150 and vcount<V_START+160))
       or ((hcount>=H_START+160 and hcount<H_START+165) and (vcount >= V_START+160 and vcount<V_START+170))
       or ((hcount>=H_START+165 and hcount<H_START+170) and (vcount >= V_START+150 and vcount<V_START+160))
       or ((hcount>=H_START+170 and hcount<H_START+175) and (vcount >= V_START+140 and vcount<V_START+150))
       or ((hcount>=H_START+175 and hcount<H_START+180) and (vcount >= V_START+130 and vcount<V_START+140))
       or ((hcount>=H_START+180 and hcount<H_START+185) and (vcount >= V_START+120 and vcount<V_START+130))
       or ((hcount>=H_START+185 and hcount<H_START+190) and (vcount >= V_START+110 and vcount<V_START+120))
       or ((hcount>=H_START+190 and hcount<H_START+195) and (vcount >= V_START+100 and vcount<V_START+110))
       or ((hcount>=H_START+240 and hcount<H_START+290) and (vcount >= V_START+100 and vcount<V_START+110))
       or ((hcount>=H_START+260 and hcount<H_START+270) and (vcount >= V_START+110 and vcount<V_START+160))
       or ((hcount>=H_START+240 and hcount<H_START+290) and (vcount >= V_START+160 and vcount<V_START+170))
       or ((hcount>=H_START+330 and hcount<H_START+340) and (vcount >= V_START+100 and vcount<V_START+170))
       or ((hcount>=H_START+340 and hcount<H_START+350) and (vcount >= V_START+110 and vcount<V_START+120))
       or ((hcount>=H_START+350 and hcount<H_START+360) and (vcount >= V_START+120 and vcount<V_START+130))
       or ((hcount>=H_START+360 and hcount<H_START+370) and (vcount >= V_START+130 and vcount<V_START+140))
       or ((hcount>=H_START+370 and hcount<H_START+380) and (vcount >= V_START+140 and vcount<V_START+150))
       or ((hcount>=H_START+380 and hcount<H_START+390) and (vcount >= V_START+150 and vcount<V_START+160))
       or ((hcount>=H_START+390 and hcount<H_START+400) and (vcount >= V_START+100 and vcount<V_START+170))) then
			      red   <= "0000";
						green <= "1111";
						blue  <= "0000";
				else 
						red   <= "0000";
						green <= "0000";
						blue  <= "0000";
				end if;
  else
     if( ((hcount>=H_START+20 and hcount<H_START+60) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+10 and hcount<H_START+20) and (vcount >= V_START+110 and vcount<V_START+160)) 
      or ((hcount>=H_START+20 and hcount<H_START+60) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+50 and hcount<H_START+60) and (vcount >= V_START+140 and vcount<V_START+160))
      or ((hcount>=H_START+40 and hcount<H_START+70) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+90 and hcount<H_START+95) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+95 and hcount<H_START+100) and (vcount >= V_START+150 and vcount<V_START+160))
      or ((hcount>=H_START+100 and hcount<H_START+150) and (vcount >= V_START+140 and vcount<V_START+150))
      or ((hcount>=H_START+105 and hcount<H_START+110) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+110 and hcount<H_START+115) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+115 and hcount<H_START+120) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+120 and hcount<H_START+130) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+130 and hcount<H_START+135) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+135 and hcount<H_START+140) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+140 and hcount<H_START+145) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+150 and hcount<H_START+155) and (vcount >= V_START+150 and vcount<V_START+160))
      or ((hcount>=H_START+155 and hcount<H_START+160) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+170 and hcount<H_START+180) and (vcount >= V_START+100 and vcount<V_START+170))
      or ((hcount>=H_START+180 and hcount<H_START+190) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+190 and hcount<H_START+200) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+200 and hcount<H_START+210) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+210 and hcount<H_START+220) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+220 and hcount<H_START+230) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+230 and hcount<H_START+240) and (vcount >= V_START+100 and vcount<V_START+170))
      or ((hcount>=H_START+250 and hcount<H_START+310) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+250 and hcount<H_START+260) and (vcount >= V_START+110 and vcount<V_START+160))
      or ((hcount>=H_START+250 and hcount<H_START+290) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+250 and hcount<H_START+310) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+330 and hcount<H_START+340) and (vcount >= V_START+110 and vcount<V_START+160))
      or ((hcount>=H_START+340 and hcount<H_START+380) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+340 and hcount<H_START+380) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+380 and hcount<H_START+390) and (vcount >= V_START+110 and vcount<V_START+160))
      or ((hcount>=H_START+410 and hcount<H_START+415) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+415 and hcount<H_START+420) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+420 and hcount<H_START+425) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+425 and hcount<H_START+430) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+430 and hcount<H_START+435) and (vcount >= V_START+140 and vcount<V_START+150))
      or ((hcount>=H_START+435 and hcount<H_START+440) and (vcount >= V_START+150 and vcount<V_START+160))
      or ((hcount>=H_START+440 and hcount<H_START+450) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+450 and hcount<H_START+455) and (vcount >= V_START+150 and vcount<V_START+160))
      or ((hcount>=H_START+455 and hcount<H_START+460) and (vcount >= V_START+140 and vcount<V_START+150))
      or ((hcount>=H_START+460 and hcount<H_START+465) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+465 and hcount<H_START+470) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+470 and hcount<H_START+475) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+475 and hcount<H_START+480) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+490 and hcount<H_START+550) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+490 and hcount<H_START+500) and (vcount >= V_START+110 and vcount<V_START+160))
      or ((hcount>=H_START+490 and hcount<H_START+530) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+490 and hcount<H_START+550) and (vcount >= V_START+160 and vcount<V_START+170))
      or ((hcount>=H_START+580 and hcount<H_START+620) and (vcount >= V_START+100 and vcount<V_START+110))
      or ((hcount>=H_START+570 and hcount<H_START+580) and (vcount >= V_START+100 and vcount<V_START+170))
      or ((hcount>=H_START+580 and hcount<H_START+620) and (vcount >= V_START+120 and vcount<V_START+130))
      or ((hcount>=H_START+610 and hcount<H_START+620) and (vcount >= V_START+110 and vcount<V_START+120))
      or ((hcount>=H_START+580 and hcount<H_START+590) and (vcount >= V_START+130 and vcount<V_START+140))
      or ((hcount>=H_START+590 and hcount<H_START+600) and (vcount >= V_START+140 and vcount<V_START+150))
      or ((hcount>=H_START+600 and hcount<H_START+610) and (vcount >= V_START+150 and vcount<V_START+160))
      or ((hcount>=H_START+610 and hcount<H_START+620) and (vcount >= V_START+160 and vcount<V_START+170))) then
          red   <= "1111";
          green <= "0000";
          blue  <= "0000";
      else 
          red   <= "0000";
          green <= "0000";
          blue  <= "0000";
      end if;
    end if; 
end process data_output_proc;

end vga_test_arch;