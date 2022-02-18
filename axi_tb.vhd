----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2021 10:51:38 AM
-- Design Name: 
-- Module Name: axi_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use work.utils_pkg.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axi_tb is
--  Port ( );
end axi_tb;

architecture Behavioral of axi_tb is

    --M files
    file    file_m                  :   text;
    file    file_prefix_m           :   text;   
    file    file_in_data_m          :   text;   
    file    file_out_data_integer_m :   text;           
    file    file_read_data_m        :   text;       
    --Opseg files
    file     file_opseg             :   text;
    file     file_prefix            :   text;
    file     file_in_data           :   text;
    file     file_out_data_integer  :   text;
    file     file_read_data         :   text;
    file     file_debug1_data       :   text;
    file     file_debug2_data       :   text;
    file     file_debug3_data       :   text;
    file     file_debug4_data       :   text;
    file     file_debug5_data       :   text;
    file     file_debug6_data       :   text;
    file     file_debug7_data       :   text;
    file     file_debug8_data       :   text;
    file     file_debug9_data       :   text;

        

    type mem_t is array (0 to 8) of integer;

    constant MEM_TEST_c : mem_t := (1,2,3,4,5,6,7,8,9, others => 0);

    signal clk_s:   std_logic;
    signal reset_s: std_logic;

    constant alpha_c               : sfixed(9 downto -22) := to_sfixed(0.8,9,-22);
    constant gamma_c               : sfixed(9 downto -22) := to_sfixed(1.4,9,-22);
    constant beta_c                : sfixed(9 downto -22) := to_sfixed(1.7,9,-22);
    constant m_size_c              : integer := 258;

    --Psolaf core's address map
    constant ALPHA_REG_ADDR_C              : integer := 0;
    constant BETA_REG_ADDR_C               : integer := 4;
    constant GAMMA_REG_ADDR_C              : integer := 8;
    constant IN_SIZE_REG_ADDR_C            : integer := 12;
    constant M_SIZE_REG_ADDR_C             : integer := 16;
    constant START_REG_ADDR_C              : integer := 20;
    constant READY_REG_ADDR_C              : integer := 24;


    constant ADDR_W_c                      : integer := 16; --12 je dosta za 1500  tj 4095 podataka

    --IN memorija 
    constant SIZE_IN_TOP_c                 : integer := 1500;
    constant W_HIGH_IN_TOP_c               : integer := 1;
    constant W_LOW_IN_TOP_c                : integer := -25;
    --OPSEG memorija
    constant SIZE_OPSEG_TOP_c              : integer := 5000;
    constant W_HIGH_OPSEG_ADDR_TOP_c       : integer := 14;
    constant W_HIGH_OPSEG_TOP_c            : integer := 2;
    constant W_LOW_OPSEG_TOP_c             : integer := -25;
    --M memorija
    --kod ove memorije pogledaj kako kada su vrednosti preko 20k kako se cita in memorija
    constant SIZE_M_TOP_c                 : integer := 1000;
    constant SIZE_ADDR_W_M_c              : integer := 14;
    constant W_HIGH_M_TOP_c               : integer := 18;
    constant W_LOW_M_TOP_c                : integer := 0;
    --OUT memorija
    constant SIZE_OUT_TOP_c               : integer := 1000;
    constant SIZE_ADDR_W_OUT_c            : integer := 14;
    constant W_HIGH_OUT_TOP_c             : integer := 1;
    constant W_LOW_OUT_TOP_c              : integer := -31;
    
    constant C_S00_AXI_DATA_WIDTH_c                 : integer := 32;
    constant C_S00_AXI_ADDR_WIDTH_c                 : integer := 5;
    
    ---------------AXI Interfaces signals---------------------------
    --Parameters of Axi-Full Master Bus Interface M00_AXI
     
    -- Base address of targeted slave
  
    constant C_M00_TARGET_SLAVE_BASE_ADDR_c	: std_logic_vector	:= x"00000";
    -- Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    constant C_M00_AXI_BURST_LEN_c	: integer	:= 128;
    -- Thread ID Width
    constant C_M00_AXI_ID_WIDTH_c	: integer	:= 1;
    -- Width of Address Bus
    constant C_M00_AXI_ADDR_WIDTH_c	: integer	:= 20;
    -- Width of Data Bus
    constant C_M00_AXI_DATA_WIDTH_c	: integer	:= 32;
    -- Width of User Write Address Bus
    constant C_M00_AXI_AWUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Read Address Bus
    constant C_M00_AXI_ARUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Write Data Bus
    constant C_M00_AXI_WUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Read Data Bus
    constant C_M00_AXI_RUSER_WIDTH_c	: integer	:= 0;
    -- Width of User Response Bus
    constant C_M00_AXI_BUSER_WIDTH_c	: integer	:= 0;

    -- Ports of Axi Slave Bus Interface S00_AXI
    signal s00_axi_aclk_s	    :  std_logic;
    signal s00_axi_aresetn_s	:  std_logic;
    signal s00_axi_awaddr_s	    :  std_logic_vector(C_S00_AXI_ADDR_WIDTH_c -1 downto 0);
    signal s00_axi_awprot_s	    :  std_logic_vector(2 downto 0);
    signal s00_axi_awvalid_s	:  std_logic;
    signal s00_axi_awready_s	:  std_logic;
    signal s00_axi_wdata_s	    :  std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0);
    signal s00_axi_wstrb_s	    :  std_logic_vector((C_S00_AXI_DATA_WIDTH_c/8)-1 downto 0);
    signal s00_axi_wvalid_s	    :  std_logic;
    signal s00_axi_wready_s	    :  std_logic;
    signal s00_axi_bresp_s	    :  std_logic_vector(1 downto 0);
    signal s00_axi_bvalid_s	    :  std_logic;
    signal s00_axi_bready_s	    :  std_logic;
    signal s00_axi_araddr_s	    :  std_logic_vector(C_S00_AXI_ADDR_WIDTH_c-1 downto 0);
    signal s00_axi_arprot_s	    :  std_logic_vector(2 downto 0);
    signal s00_axi_arvalid_s	:  std_logic;
    signal s00_axi_arready_s	:  std_logic;
    signal s00_axi_rdata_s	    :  std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0);
    signal s00_axi_rresp_s	    :  std_logic_vector(1 downto 0);
    signal s00_axi_rvalid_s	    :  std_logic;
    signal s00_axi_rready_s	    :  std_logic;


    --Ports of Axi_Full Master Bus Interface M00_AXI
    signal m00_init_axi_txn_s       : std_logic;
    signal m00_axi_txn_done_s       : std_logic;
    signal m00_axi_error_s              : std_logic;    
    signal m00_axi_aclk_s           : std_logic;
    signal m00_axi_aresetn_s        : std_logic;
    signal m00_axi_awid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
    signal m00_axi_awaddr_s         : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
    --signal m00_axi_awlen_s          : std_logic_vector(7 downto 0)  := (others => '0');
    signal m00_axi_awlen_s          : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0'); 

    signal m00_axi_awsize_s         : std_logic_vector(2 downto 0)  := (others => '0');
    signal m00_axi_awburst_s        : std_logic_vector(1 downto 0)  := (others => '0');
    signal m00_axi_awlock_s         : std_logic := '0';
    signal m00_axi_awcache_s        : std_logic_vector(3 downto 0)  := (others => '0');
    signal m00_axi_awprot_s         : std_logic_vector(2 downto 0)  := (others => '0');
    signal m00_axi_awqos_s        : std_logic_vector(3 downto 0)  := (others => '0');
    signal m00_axi_awregion_s        : std_logic_vector(3 downto 0)  := (others => '0');
    signal m00_axi_awuser_s        : std_logic_vector(C_M00_AXI_AWUSER_WIDTH_c - 1 downto 0)  := (others => '0');
    signal m00_axi_awvalid_s         : std_logic := '0';
    signal m00_axi_awready_s         : std_logic := '0';
    signal m00_axi_wdata_s        : std_logic_vector(C_M00_AXI_DATA_WIDTH_c - 1 downto 0)  := (others => '0');
    signal m00_axi_wstrb_s        : std_logic_vector((C_M00_AXI_DATA_WIDTH_c/8) - 1 downto 0)  := (others => '0');
    signal m00_axi_wlast_s         : std_logic := '0';
    signal m00_axi_wuser_s        : std_logic_vector(C_M00_AXI_WUSER_WIDTH_c - 1 downto 0)  := (others => '0');
    signal m00_axi_wvalid_s         : std_logic := '0';
    signal m00_axi_wready_s         : std_logic := '0';
    signal m00_axi_bid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
    signal m00_axi_bresp_s        : std_logic_vector(1 downto 0)  := (others => '0');
    signal m00_axi_buser_s           : std_logic_vector(C_M00_AXI_BUSER_WIDTH_c - 1 downto 0) := (others => '0');
    signal m00_axi_bvalid_s         : std_logic := '0';
    signal m00_axi_bready_s         : std_logic := '0';
    signal m00_axi_arid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
    signal m00_axi_araddr_s         : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0);-- := (others => '0');ss
    --signal m00_axi_arlen_s          : std_logic_vector(7 downto 0)  := (others => '0'); 
    signal m00_axi_arlen_s          : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0'); 
    signal m00_axi_arsize_s         : std_logic_vector(2 downto 0)  := (others => '0');
    signal m00_axi_arburst_s        : std_logic_vector(1 downto 0)  := (others => '0');
    signal m00_axi_arlock_s         : std_logic := '0';
    signal m00_axi_arcache_s        : std_logic_vector(3 downto 0)  := (others => '0');
    signal m00_axi_arprot_s         : std_logic_vector(2 downto 0)  := (others => '0');
    signal m00_axi_arqos_s          : std_logic_vector(3 downto 0)  := (others => '0');
    signal m00_axi_arregion_s       : std_logic_vector(3 downto 0)  := (others => '0');
    signal m00_axi_aruser_s         : std_logic_vector(C_M00_AXI_AWUSER_WIDTH_c - 1 downto 0) := (others => '0');
    signal m00_axi_arvalid_s        : std_logic := '0';
    signal m00_axi_arready_s        : std_logic := '0';
    signal m00_axi_rid_s           : std_logic_vector(C_M00_AXI_ID_WIDTH_c - 1 downto 0) := (others => '0');
    signal m00_axi_rdata_s        : std_logic_vector(C_M00_AXI_DATA_WIDTH_c - 1 downto 0)  := (others => '0');
    signal m00_axi_rresp_s        : std_logic_vector(1 downto 0)  := (others => '0');
    signal m00_axi_rlast_s         : std_logic := '0';
    signal m00_axi_ruser_s        : std_logic_vector(C_M00_AXI_RUSER_WIDTH_c - 1 downto 0)  := (others => '0');
    signal m00_axi_rvalid_s         : std_logic := '0';
    signal m00_axi_rready_s         : std_logic := '0';
    


    constant ADDR_LSB		            : integer := (C_M00_AXI_DATA_WIDTH_c/32) + 1;
    --pomocni signali
    signal cnt_s                        : unsigned(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0'); 
    signal axi_arv_arr_flag             : std_logic;
    signal axi_awv_awr_flag             : std_logic;
    signal axi_arlen_cntr               : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0');
    signal tmp_m00_axi_araddr_s         : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
    signal axi_araddr_s                 : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
    signal addr_field_read_s	        : std_logic_vector(1 downto 0);
    signal axi_awlen_cntr               : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c)  := (others => '0');
    signal axi_awaddr_s                 : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');


begin

    clk_gen: process
    begin
        clk_s <= '0', '1' after 100ns;
        wait for 200 ns;
    end process;
    
    
    stimulus_generator: process
        variable axi_read_data_v    : std_logic_vector (31 downto 0);
        variable transfer_size_v    : integer;

        variable    v_cnt_last      : integer;
        variable    v_sub_last      : integer;
        variable    v_wdata         : sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c) := (others => '0');
        variable    v_wdata_slv         : std_logic_vector(27 - 1 downto 0) := (others => '0');
        variable    v_wdata_signed        : signed(27 - 1 downto 0) := (others => '0');
        variable    v_input_line             :   line;
        variable    v_output_line            :   line;
        variable    v_prefix_string          :   string(1 to 14);
        variable    v_wdata_real_write       :   real;
        variable    v_wdata_real             :   real;
        variable    v_wdata_real_2             :   real;
    
        variable    v_p2_wdata_opseg_top_o     :   sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c);

        variable    v_sfixed_test         : sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c) := to_sfixed(-0.0078125,W_HIGH_OPSEG_TOP_c -1,W_LOW_OPSEG_TOP_c);
        subtype result_type is std_logic_vector (v_sfixed_test'length - 1 downto 0);
        variable v_slv_test : result_type;
        variable    v_sfixed_test_2       : sfixed(W_HIGH_OPSEG_TOP_c - 1 downto W_LOW_OPSEG_TOP_c) := (others => '0');
        variable    v_sfixed_test_3       : sfixed(m00_axi_rdata_s'high  downto 0) := (others => '0');
        variable    v_slv                 : std_logic_vector(C_M00_AXI_DATA_WIDTH_c - 1 downto 0)  := (others => '0');

        --M memory variables
        variable    v_wdata_int             : integer;
        variable    v_wdata_m_slv           : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
        variable    v_wdata_int_test        : integer;
        variable    v_wdata_m_test          : integer;
        variable    v_prefix_string_m       :   string(1 to 4);

        
    begin
        --M FAJLOVI
        --file_open(file_m,"debugM2.txt",read_mode);
        --file_open(file_prefix_m,"debugPrefix_m_tb.txt",write_mode);
        --file_open(file_in_data_m,"debugin_data_m_tb.txt",write_mode);
        --file_open(file_out_data_integer_m,"debugOut_data_integer_m.txt",write_mode);
        --file_open(file_read_data_m,"debugOut_data_integer_read_m_tb.txt",write_mode);

        --OPSEG FAJLOVI
        file_open(file_opseg,"debugOpseg.txt",read_mode);
        file_open(file_prefix,"debugPrefix_tb.txt",write_mode);
        file_open(file_in_data,"debugin_data_tb.txt",write_mode);
        file_open(file_out_data_integer,"debugOut_data_integer.txt",write_mode);

        file_open(file_debug1_data,"debug1_v_wdata_slv_tb.txt",write_mode);
        file_open(file_debug2_data,"debug2_v_p2_wdata_opseg_top_o_tb.txt",write_mode);
        file_open(file_debug3_data,"debug3_v_wdata_real_write.txt",write_mode);
        file_open(file_debug4_data,"debug4_v_wdata_real_2_write.txt",write_mode);
        file_open(file_debug5_data,"debug5_v_wdata_real_2_write.txt",write_mode);
        file_open(file_debug6_data,"debug6_v_v_wdata_slv.txt",write_mode);
        file_open(file_debug7_data,"debug7_v_wdata_signed.txt",write_mode);
        --file_open(file_debug8_data,"debug8_test.txt",write_mode);
        file_open(file_debug9_data,"debug9_read_m_test.txt",write_mode);

        --file_open(file_read_data,"debugOut_data_integer_read_tb.txt",write_mode);


        report "Loading memory elements!";


        --reset AXI-lite interface
        s00_axi_aresetn_s <= '0';
        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        --release reset 
        s00_axi_aresetn_s <= '1';
        wait until falling_edge(clk_s);
        -----------------------------------------------------------
        --              setting alpha                            --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(ALPHA_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= to_slv(alpha_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);

        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;

        -----------------------------------------------------------
        --              setting m_size                           --
        -----------------------------------------------------------
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(M_SIZE_REG_ADDR_C,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(m_size_c,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= std_logic_vector(to_unsigned(0,s00_axi_awaddr_s'length));
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= std_logic_vector(to_unsigned(0,s00_axi_wdata_s'length));
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);

        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;







            
        -------------------------------------------------------------------------------------------
        --                              Loading elements of memory m                             --
        -------------------------------------------------------------------------------------------
        --reset AXI4 interface
        m00_axi_aresetn_s <= '0';
        --wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        --release reset
        m00_axi_aresetn_s <= '1';

        
        m00_init_axi_txn_s <= '1';
        --m00_axi_wready_s <= '1';
        
        

        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        wait until falling_edge(clk_s);
        m00_init_axi_txn_s <= '0';
        



        --wait until falling_edge(clk_s);

        --m00_axi_wready_s <= '0';
        --ova petlja je sluzila da se preskoci write stanje da bi dosli u read stanje
        --for i in 1 to 5 loop
        --m00_axi_bvalid_s <= '1';
        --wait until falling_edge(clk_s);
        --wait until falling_edge(clk_s);
        --wait until falling_edge(clk_s);
        --wait until falling_edge(clk_s);
        --wait until falling_edge(clk_s);
        --m00_axi_awready_s <= '1';
        --wait until falling_edge(clk_s);
        --end loop;
        -------------------------------------------------------------------------------------------------
        --p1_write_i_s <= '1';
            --v_cnt_last := 0;
            --v_sub_last := m_size_c;
--
            --for cnt in 0 to m_size_c - 1 loop
            --    
--
            --    readline(file_m,v_input_line);
            --    read(v_input_line,v_prefix_string_m);
            --    
            --    write(v_output_line,v_prefix_string_m);
            --    writeline(file_prefix_m,v_output_line);
            --
            --    read(v_input_line,v_wdata_int);
            --    
            --    write(v_output_line,v_wdata_int);
            --    writeline(file_in_data_m,v_output_line);
            --    
            --    v_wdata_m_slv := std_logic_vector(to_unsigned(v_wdata_int,v_wdata_m_slv'length));
--
            --    v_wdata_int_test := to_integer(unsigned(v_wdata_m_slv));
--
--
            --    m00_axi_rvalid_s <= '1';
            --    --wait until falling_edge(clk_s);
--
--
            --    m00_axi_rdata_s(v_wdata_m_slv'length - 1 downto 0) <= v_wdata_m_slv;
            --    --wait until falling_edge(clk_s);
            --    --v_slv := "00000" & v_wdata_slv;
            --    --write(v_output_line,v_slv);
            --    --writeline(file_debug8_data,v_output_line);
--
            --    v_wdata_m_test := to_integer(unsigned(m00_axi_rdata_s(v_wdata_m_slv'length - 1 downto 0)));
--
            --    write(v_output_line,v_wdata_m_test);
            --    writeline(file_debug8_data,v_output_line);
            --    
            --    v_cnt_last := v_cnt_last + 1;
--
            --    cnt_s <= to_unsigned(v_cnt_last,cnt_s'length);
            --    --wait until falling_edge(clk_s);
            --    
            --    if(v_cnt_last = 128 or v_cnt_last = v_sub_last)then
            --        m00_axi_arready_s <= '1';
            --        m00_axi_rlast_s <= '1';
            --        wait until falling_edge(clk_s);
            --        m00_axi_arready_s <= '0';
            --        m00_axi_rlast_s <= '0';
            --        v_sub_last := v_sub_last - v_cnt_last;
            --        v_cnt_last := 0;
            --    end if;
--
            --   
            --    wait until falling_edge(clk_s);
            --    --wait for 200 ns;
            --end loop;
               -- m00_axi_rvalid_s <= '0';
               -- m00_axi_rready_s <= '0';


    --------------------------------------------------------------------------------
    --                       reading m memory                                     --
    --------------------------------------------------------------------------------


               
        --reset AXI4 interface
        --m00_axi_aresetn_s <= '0';
        ----wait for 5 falling edges of AXI-lite clock signal
        --for i in 1 to 5 loop
        --    wait until falling_edge(clk_s);
        --end loop;
        ----release reset
        --m00_axi_aresetn_s <= '1';

        --wait until m00_axi_awvalid_s = '1';
        --m00_axi_awready_s <= '1';
        --wait until m00_axi_awvalid_s = '0';
--
        --wait until falling_edge(clk_s);
--
        --m00_axi_wready_s <= '1';
        --wait until falling_edge(clk_s);
        --wait until falling_edge(clk_s);
--
        --v_cnt_last := 0;
        --v_sub_last := m_size_c;
        --for cnt in 0 to m_size_c - 1 loop
            
            --readline(file_m,v_input_line);
            --read(v_input_line,v_prefix_string_m);
            --
            --write(v_output_line,v_prefix_string_m);
            --writeline(file_prefix_m,v_output_line);
        --
            --read(v_input_line,v_wdata_int);
            --
            --write(v_output_line,v_wdata_int);
            --writeline(file_in_data_m,v_output_line);
            --
            --v_wdata_m_slv := std_logic_vector(to_unsigned(v_wdata_int,v_wdata_m_slv'length));
            --v_wdata_int_test := to_integer(unsigned(v_wdata_m_slv));
            --m00_axi_rvalid_s <= '1';
            ----wait until falling_edge(clk_s);
            --std_logic_vector(to_unsigned(v_wdata_int,v_wdata_m_slv'length));
        --    v_wdata_m_slv := std_logic_vector(resize(unsigned(m00_axi_wdata_s),v_wdata_m_slv'length));
--
        --    v_wdata_m_test := to_integer(unsigned(v_wdata_m_slv));
        --    write(v_output_line,v_wdata_m_test);
        --    writeline(file_debug9_data,v_output_line);
        --    
        --    v_cnt_last := v_cnt_last + 1;
        --    cnt_s <= to_unsigned(v_cnt_last,cnt_s'length);
        --    --wait until falling_edge(clk_s);
        --    
        --    if(v_cnt_last = 128 or v_cnt_last = v_sub_last)then
        --        m00_axi_awready_s <= '1';
        --      
        --        wait until falling_edge(clk_s);
        --        m00_axi_awready_s <= '0';
 --
        --        v_sub_last := v_sub_last - v_cnt_last;
        --        v_cnt_last := 0;
        --    end if;
        --       
        --    wait until falling_edge(clk_s);
        --    --wait for 200 ns;
        --end loop;
        --  
        --  m00_axi_wready_s <= '0';
--        m00_init_axi_txn_s <= '1';
--        m00_axi_wready_s <= '1';
--        
--        
--
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        m00_init_axi_txn_s <= '0';
--        
--        m00_axi_awready_s <= '1';
--        wait until falling_edge(clk_s);
--        m00_axi_awready_s <= '0';
--
--
--        wait until falling_edge(clk_s);
--
--        m00_axi_wready_s <= '0';
--        
--        for i in 1 to 5 loop
--        m00_axi_bvalid_s <= '1';
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        wait until falling_edge(clk_s);
--        m00_axi_awready_s <= '1';
--        wait until falling_edge(clk_s);
--        end loop;
--        -------------------------------------------------------------------------------------------------
--        --p1_write_i_s <= '1';
--            
--            for cnt in 0 to 99 loop
--                readline(file_opseg,v_input_line);
--                read(v_input_line,v_prefix_string);
--                
--                write(v_output_line,v_prefix_string);
--                writeline(file_prefix,v_output_line);
--            
--                read(v_input_line,v_wdata_real);
--                
--                write(v_output_line,v_wdata_real);
--                writeline(file_in_data,v_output_line);
--                
--                v_wdata := to_sfixed(v_wdata_real,v_wdata);
--
--                v_wdata_slv := to_slv(v_wdata);
--
--
--                m00_axi_rvalid_s <= '1';
--                wait until falling_edge(clk_s);
--
--
--                m00_axi_rdata_s(v_wdata_slv'length - 1 downto 0) <= v_wdata_slv;
--                wait until falling_edge(clk_s);
--                --v_slv := "00000" & v_wdata_slv;
--                --write(v_output_line,v_slv);
--                --writeline(file_debug8_data,v_output_line);
--
--                v_sfixed_test_2 := to_sfixed(m00_axi_rdata_s(v_sfixed_test_2'length - 1 downto 0),v_sfixed_test_2'high,v_sfixed_test_2'low);
--                v_wdata_real_write := to_real(v_sfixed_test_2);
--                write(v_output_line,v_wdata_real_write);
--                writeline(file_debug8_data,v_output_line);
--
--
--                wait until falling_edge(clk_s);
--                m00_axi_bvalid_s <= '0';
--                m00_axi_awready_s <= '0';
--                wait until falling_edge(clk_s);
--                
--                wait for 200 ns;
--            end loop;
        wait;

    end process stimulus_generator;


    --Implement m00_axi_arready generation
    process(clk_s)
    begin
            if(clk_s'event and clk_s = '1')then
                if(m00_axi_aresetn_s = '0') then
                    m00_axi_arready_s <=  '0';
                    axi_arv_arr_flag <= '0';
                else
                    if(m00_axi_arready_s = '0' and m00_axi_arvalid_s = '1' and axi_awv_awr_flag = '0' and axi_arv_arr_flag = '0') then
                        m00_axi_arready_s <= '1';
                        axi_arv_arr_flag <= '1';
                    elsif(m00_axi_rvalid_s = '1' and m00_axi_rready_s = '1' and (axi_arlen_cntr = m00_axi_arlen_s))then
                        --preparing to accept next address after current read completion
                        axi_arv_arr_flag <= '0';
                    else
                        m00_axi_arready_s <= '0';
                    
                    end if;
                end if;
            end if;
    end process;

    --Implement axi_araddr latching
    --This process is used to latch the address when both M_AXI_ARVALID and M_AXI_RVALID are valid
    process(clk_s)
        --variable v_m00_axi_araddr           : std_logic_vector(C_M00_AXI_ADDR_WIDTH_c - 1 downto 0) := (others => '0');
        --variable v_axi_arlen_cntr           : integer;
        variable v_m00_axi_arburst          : std_logic_vector(m00_axi_arburst_s'length - 1 downto 0);
        variable v_m00_axi_arlen            : std_logic_vector(m00_axi_arlen_s'length - 1 downto 0);

    begin
        if (clk_s'event and clk_s = '1') then
            if(m00_axi_aresetn_s = '0') then
                m00_axi_rlast_s <= '0';
                axi_arlen_cntr <= (others => '0');
                --m00_axi_rvalid_s <= '0';
                --m00_axi_rdata_s <= (others => '0');
            else
                if(m00_axi_arready_s = '0' and m00_axi_arvalid_s = '1' and axi_arv_arr_flag = '0')then
                    --address latching
                    --start address of transfer
                    --tmp_m00_axi_araddr_s := m00_axi_araddr_s;

                    --axi_araddr_s <= m00_axi_araddr_s;
                    --axi_araddr_s <= shift_left(m00_axi_araddr_s, 2);
                    axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= m00_axi_araddr_s(m00_axi_araddr_s'high - 2 downto 0);
                    axi_arlen_cntr <= (others => '0');
                    m00_axi_rlast_s <= '0';
                    v_m00_axi_arburst := m00_axi_arburst_s;
                    v_m00_axi_arlen := m00_axi_arlen_s;
                
                elsif((axi_arlen_cntr <= m00_axi_arlen_s) and m00_axi_rvalid_s = '1' and m00_axi_rready_s = '1') then
                    axi_arlen_cntr <= std_logic_vector(unsigned(axi_arlen_cntr)) + 1;
                    m00_axi_rlast_s <= '0';

                    case(v_m00_axi_arburst) is
                        when "01" =>
                        --incremental burst
                        --The read address for all the beats in the transcation are increments by awsize
                        --m00_axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector(unsigned(m00_axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
                        --m00_axi_araddr_s(ADDR_LSB - 1 downto 0) <= (others => '0'); --for arsize = 4 bytes (010)
                        axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector(unsigned(axi_araddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1); --araddr aligned to 4 byte boundary
                        axi_araddr_s(ADDR_LSB - 1 downto 0) <= (others => '0'); --for arsize = 4 bytes (010)
                        when others => 
                            report "ERROR WRONG BURST CODE!!!!!!!!!";
                    end case;


                elsif((axi_arlen_cntr = m00_axi_arlen_s) and m00_axi_rlast_s = '0' and axi_arv_arr_flag = '1') then
                    m00_axi_rlast_s <= '1';
                elsif (m00_axi_rready_s = '1') then
                    m00_axi_rlast_s <= '0';
                end if;
            end if;
        end if;
    end process;

    --Implement axi_rvalid
    process(clk_s)
    begin
        if(clk_s'event and clk_s = '1')then
            if(m00_axi_aresetn_s = '0')then
                m00_axi_rvalid_s <= '0';
                m00_axi_rresp_s <= "00";
            else
                if(axi_arv_arr_flag = '1' and m00_axi_rvalid_s = '0')then
                    m00_axi_rvalid_s <= '1';
                    m00_axi_rresp_s <= "00"; --OKAY response
                elsif(m00_axi_rvalid_s = '1' and m00_axi_rready_s = '1')then
                    m00_axi_rvalid_s <= '0';
                end if;
            end if;
        end if;
    end process;

    reading_memory_m:process

        variable    v_input_line             :   line;
        variable    v_output_line            :   line;

        ----M memory variables
        variable    v_wdata_int             : integer;
        variable    v_wdata_m_slv           : std_logic_vector(W_HIGH_M_TOP_c - 1 downto W_LOW_M_TOP_c);
        variable    v_wdata_int_test        : integer;
        variable    v_wdata_m_test          : integer;
        variable    v_prefix_string_m       :   string(1 to 4);
    begin
    
        --M FAJLOVI
        file_open(file_m,"debugM2.txt",read_mode);
        file_open(file_prefix_m,"debugPrefix_m_tb.txt",write_mode);
        file_open(file_in_data_m,"debugin_data_m_tb.txt",write_mode);
        file_open(file_out_data_integer_m,"debugOut_data_integer_m.txt",write_mode);
        file_open(file_read_data_m,"debugOut_data_integer_read_m_tb.txt",write_mode);
        
        file_open(file_debug8_data,"debug8_test.txt",write_mode);

        for cnt in 0 to m_size_c - 1 loop
            readline(file_m,v_input_line);
            read(v_input_line,v_prefix_string_m);
            
            write(v_output_line,v_prefix_string_m);
            writeline(file_prefix_m,v_output_line);
            
            read(v_input_line,v_wdata_int);
            
            write(v_output_line,v_wdata_int);
            writeline(file_in_data_m,v_output_line);
            
            v_wdata_m_slv := std_logic_vector(to_unsigned(v_wdata_int,v_wdata_m_slv'length));
            v_wdata_int_test := to_integer(unsigned(v_wdata_m_slv));
            
            --if(m00_axi_rvalid_s = '1')then
                --wait until m00_axi_rready_s = '1';
                --wait until m00_axi_rready_s = '0';
                wait until m00_axi_rvalid_s = '1';
                m00_axi_rdata_s(v_wdata_m_slv'length - 1 downto 0) <= v_wdata_m_slv;
                wait until falling_edge(clk_s);
            --end if;
            v_wdata_m_test := to_integer(unsigned(m00_axi_rdata_s(v_wdata_m_slv'length - 1 downto 0)));

            write(v_output_line,v_wdata_m_test);
            writeline(file_debug8_data,v_output_line);
           -- wait until falling_edge(clk_s);
        end loop;
    end process;


    --mem_addr_o <= 	axi_awaddr(C_M_AXI_ADDR_WIDTH - 1 downto ADDR_LSB - 1) when axi_awvalid = '1' else
    --                axi_araddr(C_M_AXI_ADDR_WIDTH  - 1 downto ADDR_LSB - 1) when axi_arvalid = '1' else
    --                (others => '0');



    --addr_field_read_s <= axi_araddr_s(C_M_AXI_ADDR_WIDTH - 1 downto C_M_AXI_ADDR_WIDTH - 2);
--
	--process(addr_field_read_s,m00_axi_arvalid_s,m00_axi_rdata_s) is
	--begin
	--	if(m00_axi_rvalid_s = '1') then 
	--	--if(rnext = '1') then   JEL DOVOLJNO RVALID?
	--		case addr_field_read_s is
	--			when "01" =>
	--				--to_slv ce ici za read a ovde ide sfixed mislim
	--				--p2_wdata_opseg_top_o <= to_slv(resize(((to_sfixed(signed(pit_next_signed),gamma) / gamma) mod 1),gamma)))
	--				--p2_wdata_opseg_top_o <= to_sfixed(to_signed(0,C_M_AXI_DATA_WIDTH - W_HIGH_OPSEG_TOP) & to_signed(M_AXI_WDATA)));
	--				--p2_wdata_opseg_top_o <=  to_sfixed(resize(signed(M_AXI_RDATA),p2_wdata_opseg_top_o'length),p2_wdata_opseg_top_o'high,p2_wdata_opseg_top_o'low);
	--				p2_wdata_opseg_top_o <=  to_sfixed(m00_axi_rdata_s(p2_wdata_opseg_top_o'length - 1 downto 0),p2_wdata_opseg_top_o'high,p2_wdata_opseg_top_o'low);
	--				--p2_wdata_opseg_top_o <=  to_sfixed(M_AXI_RDATA(p2_wdata_opseg_top_o'length - 1 downto 0),p2_wdata_opseg_top_o);
--
	--			when "00" =>
	--				p3_wdata_m_top_o <=  std_logic_vector(resize(unsigned(m00_axi_rdata_s),p3_wdata_m_top_o'length));
	--			when others =>
	--				--p3_wdata_out_top_o <=  to_sfixed(M_AXI_RDATA,p3_wdata_out_top_o'high,p3_wdata_out_top_o'low);
	--				--p3_wdata_out_top_o <=  to_sfixed(resize(signed(M_AXI_RDATA),p3_wdata_out_top_o'length),p3_wdata_out_top_o'high,p3_wdata_out_top_o'low);
	--				p3_wdata_out_top_o <=  to_sfixed(m00_axi_rdata_s(p3_wdata_out_top_o'length - 1 downto 0),p3_wdata_out_top_o'high,p3_wdata_out_top_o'low);
	--				--p3_wdata_out_top_o <=  to_sfixed(M_AXI_RDATA(p3_wdata_out_top_o'length - 1 downto 0),p3_wdata_out_top_o);
--
	--		end case;
	--	end if;
	--end process;




    --Implement axi_awready
    process (clk_s)
    begin
        if(clk_s'event and clk_s = '1')Then
            if(m00_axi_aresetn_s = '0') then
                m00_axi_awready_s <= '0';
                axi_awv_awr_flag <= '0';
            else
                if(m00_axi_awready_s = '0' and m00_axi_awvalid_s = '1' and axi_awv_awr_flag = '0' and axi_arv_arr_flag = '0')then
                    --slave is ready to accept an address and assiciated control signals
                    axi_awv_awr_flag <= '1';--used for generation of bresp and bvalid
                    m00_axi_awready_s <= '1';
                elsif(m00_axi_wlast_s = '1' and m00_axi_wready_s = '1')then
                    --preparing to accept next address after current write burst tx completion
                    axi_awv_awr_flag <= '0';
                else
                    m00_axi_awready_s <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement axi_awaddr latching

	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (clk_s)
        --variable v_m00_axi_awburst          : std_logic_vector(m00_axi_arburst_s'length - 1 downto 0);
        variable v_m00_axi_awlen           : std_logic_vector(m00_axi_arlen_s'length - 1 downto 0);
	begin
	  if rising_edge(clk_s) then 
	    if m00_axi_aresetn_s = '0' then
            axi_awaddr_s <= (others => '0');
	        axi_awlen_cntr <= (others => '0');
	    else
	      if (m00_axi_awready_s = '0' and m00_axi_awvalid_s = '1' and axi_awv_awr_flag = '0') then
	      -- address latching 
            --axi_awaddr_s <= S_AXI_AWADDR(C_S_AXI_ADDR_WIDTH - 1 downto 0);
            --axi_awaddr_s <= m00_axi_awaddr_s;  ---- start address of transfer
            axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= m00_axi_awaddr_s(m00_axi_awaddr_s'high - 2 downto 0);
	        axi_awlen_cntr <= (others => '0');
	
	      elsif((axi_awlen_cntr <= m00_axi_awlen_s) and m00_axi_wready_s = '1' and m00_axi_wvalid_s = '1') then     
	        axi_awlen_cntr <= std_logic_vector (unsigned(axi_awlen_cntr) + 1);

	        case (m00_axi_awburst_s) is

	          when "01" => --incremental burst
	            -- The write address for all the beats in the transaction are increments by awsize
	            axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1);--awaddr aligned to 4 byte boundary
	            axi_awaddr_s(ADDR_LSB-1 downto 0)  <= (others => '0');  ----for awsize = 4 bytes (010)

	          when others => --reserved (incremental burst for example)
	            axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB) <= std_logic_vector (unsigned(axi_awaddr_s(C_M00_AXI_ADDR_WIDTH_c - 1 downto ADDR_LSB)) + 1);--for awsize = 4 bytes (010)
	            axi_awaddr_s(ADDR_LSB-1 downto 0)  <= (others => '0');
	        end case;        
	      end if;
	    end if;
	  end if;
	end process;

    -- Implement axi_wready generation

	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (clk_s)
	begin
	  if rising_edge(clk_s) then 
	    if m00_axi_aresetn_s = '0' then
            m00_axi_wready_s <= '0';
	    else
	      if (m00_axi_wready_s = '0' and m00_axi_wvalid_s = '1' and axi_awv_awr_flag = '1') then
	        m00_axi_wready_s <= '1';
	        -- elsif (axi_awv_awr_flag = '0') then
	      elsif (m00_axi_wlast_s = '1' and m00_axi_wready_s = '1') then 

	        m00_axi_wready_s <= '0';
	      end if;
	    end if;
	  end if;         
	end process; 
        ---------------------------------------------------------------------
        ---                          DUT                                -----
        --------------------------------------------------------------------
        --axi_full_master: entity work.psolaf_axi_v1_0_M00_AXI(implementation)
        --generic map(
        --    C_M_TARGET_SLAVE_BASE_ADDR          => C_M00_TARGET_SLAVE_BASE_ADDR_c,
        --    C_M_AXI_BURST_LEN                   => C_M00_AXI_BURST_LEN_c,
        --    C_M_AXI_ID_WIDTH                    => C_M00_AXI_ID_WIDTH_c,
        --    C_M_AXI_ADDR_WIDTH                  => C_M00_AXI_ADDR_WIDTH_c,
        --    C_M_AXI_DATA_WIDTH                  => C_M00_AXI_DATA_WIDTH_c,
        --    C_M_AXI_AWUSER_WIDTH                => C_M00_AXI_AWUSER_WIDTH_c,
        --    C_M_AXI_ARUSER_WIDTH                => C_M00_AXI_ARUSER_WIDTH_c,
        --    C_M_AXI_WUSER_WIDTH                 => C_M00_AXI_WUSER_WIDTH_c,
        --    C_M_AXI_RUSER_WIDTH                 => C_M00_AXI_RUSER_WIDTH_c,
        --    C_M_AXI_BUSER_WIDTH                 => C_M00_AXI_BUSER_WIDTH_c
        --)
        --port map(
        --    INIT_AXI_TXN            => m00_init_axi_txn_s,
        --    TXN_DONE                => m00_txn_done_s,
        --    ERROR                   => m00_error_s,
        --    M_AXI_ACLK              => clk_s,
        --    M_AXI_ARESETN           => m00_axi_aresetn_s,
        --    M_AXI_AWID              => m00_axi_awid_s,
        --    M_AXI_AWADDR            => m00_axi_awaddr_s,
        --    M_AXI_AWLEN             => m00_axi_awlen_s,
        --    M_AXI_AWSIZE            => m00_axi_awsize_s,
        --    M_AXI_AWBURST           => m00_axi_awburst_s,
        --    M_AXI_AWLOCK            => m00_axi_awlock_s,
        --    M_AXI_AWCACHE           => m00_axi_awcache_s,
        --    M_AXI_AWPROT            => m00_axi_awprot_s,
        --    M_AXI_AWQOS             => m00_axi_awqos_s,
        --    M_AXI_AWUSER            => m00_axi_awuser_s,
        --    M_AXI_AWVALID           => m00_axi_awvalid_s,
        --    M_AXI_AWREADY           => m00_axi_awready_s,
        --    M_AXI_WDATA             => m00_axi_wdata_s,
        --    M_AXI_WSTRB             => m00_axi_wstrb_s,
        --    M_AXI_WLAST             => m00_axi_wlast_s,
        --    M_AXI_WUSER             => m00_axi_wuser_s,
        --    M_AXI_WVALID            => m00_axi_wvalid_s,
        --    M_AXI_WREADY            => m00_axi_wready_s,
        --    M_AXI_BID               => m00_axi_bid_s,
        --    M_AXI_BRESP             => m00_axi_bresp_s,
        --    M_AXI_BUSER             => m00_axi_buser_s,
        --    M_AXI_BVALID            => m00_axi_bvalid_s,
        --    M_AXI_BREADY            => m00_axi_bready_s,
        --    M_AXI_ARID              => m00_axi_arid_s,
        --    M_AXI_ARADDR            => m00_axi_araddr_s,
        --    M_AXI_ARLEN             => m00_axi_arlen_s,
        --    M_AXI_ARSIZE            => m00_axi_arsize_s,
        --    M_AXI_ARBURST           => m00_axi_arburst_s,
        --    M_AXI_ARLOCK            => m00_axi_arlock_s,
        --    M_AXI_ARCACHE           => m00_axi_arcache_s,
        --    M_AXI_ARPROT            => m00_axi_arprot_s,
        --    M_AXI_ARQOS             => m00_axi_arqos_s,
        --    M_AXI_ARUSER            => m00_axi_aruser_s,
        --    M_AXI_ARVALID           => m00_axi_arvalid_s,
        --    M_AXI_ARREADY           => m00_axi_arready_s,
        --    M_AXI_RID               => m00_axi_rid_s,
        --    M_AXI_RDATA             => m00_axi_rdata_s,
        --    M_AXI_RRESP             => m00_axi_rresp_s,
        --    M_AXI_RLAST             => m00_axi_rlast_s,
        --    M_AXI_RUSER             => m00_axi_ruser_s,
        --    M_AXI_RVALID            => m00_axi_rvalid_s,
        --    M_AXI_RREADY            => m00_axi_rready_s);
            

            axi_psolaf: entity work.psolaf_axi_v1_0(arch_imp) 
                generic map(
                    -- Users to add parameters here
                    --Oduzimaju se gornja dva bita od ADDR_W da bi znali u koju memoriju ide
                    ADDR_W                      => ADDR_W_c, --12 je dosta za 1500  tj 4095 podataka
            
                    --IN memorija 
                    SIZE_IN_TOP                 => SIZE_IN_TOP_c,
                    W_HIGH_IN_TOP               => W_HIGH_IN_TOP_c,
                    W_LOW_IN_TOP                => W_LOW_IN_TOP_c,
                    --OPSEG memorija
                    SIZE_OPSEG_TOP              => SIZE_OPSEG_TOP_c,
                    W_HIGH_OPSEG_ADDR_TOP       => W_HIGH_OPSEG_ADDR_TOP_c,
                    W_HIGH_OPSEG_TOP            => W_HIGH_OPSEG_TOP_c,
                    W_LOW_OPSEG_TOP             => W_LOW_OPSEG_TOP_c,
                    --M memorija
                    --kod ove memorije pogledaj kako kada su vrednosti preko 20k kako se cita in memorija
                    SIZE_M_TOP                 => SIZE_M_TOP_c,
                    SIZE_ADDR_W_M              => SIZE_ADDR_W_M_c,
                    W_HIGH_M_TOP               => W_HIGH_M_TOP_c,
                    W_LOW_M_TOP                => W_LOW_M_TOP_c,
                    --OUT memorija
                    SIZE_OUT_TOP               => SIZE_OUT_TOP_c,
                    SIZE_ADDR_W_OUT            => SIZE_ADDR_W_OUT_c,
                    W_HIGH_OUT_TOP             => W_HIGH_OUT_TOP_c,
                    W_LOW_OUT_TOP              => W_LOW_OUT_TOP_c, 
                    
                    -- User parameters ends
                    -- Do not modify the parameters beyond this line
            
            
                    -- Parameters of Axi Slave Bus Interface S00_AXI
                    C_S00_AXI_DATA_WIDTH	        => C_S00_AXI_DATA_WIDTH_c,
                    C_S00_AXI_ADDR_WIDTH	        => C_S00_AXI_ADDR_WIDTH_c,
            
                    -- Parameters of Axi Master Bus Interface M00_AXI
                    C_M00_AXI_TARGET_SLAVE_BASE_ADDR	=> C_M00_TARGET_SLAVE_BASE_ADDR_c,
                    C_M00_AXI_BURST_LEN	                => C_M00_AXI_BURST_LEN_c,
                    C_M00_AXI_ID_WIDTH	                => C_M00_AXI_ID_WIDTH_c,
                    C_M00_AXI_ADDR_WIDTH	            => C_M00_AXI_ADDR_WIDTH_c,
                    C_M00_AXI_DATA_WIDTH	            => C_M00_AXI_DATA_WIDTH_c,
                    C_M00_AXI_AWUSER_WIDTH	            => C_M00_AXI_AWUSER_WIDTH_c,
                    C_M00_AXI_ARUSER_WIDTH	            => C_M00_AXI_ARUSER_WIDTH_c,
                    C_M00_AXI_WUSER_WIDTH	            => C_M00_AXI_WUSER_WIDTH_c,
                    C_M00_AXI_RUSER_WIDTH	            => C_M00_AXI_RUSER_WIDTH_c,
                    C_M00_AXI_BUSER_WIDTH	            => C_M00_AXI_BUSER_WIDTH_c)
                port map(
                    -- Users to add ports here
            
                    -- User ports ends
                    -- Do not modify the ports beyond this line
            
            
                    -- Ports of Axi Slave Bus Interface S00_AXI
                    s00_axi_aclk	=> clk_s,
                    s00_axi_aresetn	=> s00_axi_aresetn_s,
                    s00_axi_awaddr	=> s00_axi_awaddr_s,
                    s00_axi_awprot	=> s00_axi_awprot_s,
                    s00_axi_awvalid	=> s00_axi_awvalid_s,
                    s00_axi_awready	=> s00_axi_awready_s,
                    s00_axi_wdata	=> s00_axi_wdata_s,
                    s00_axi_wstrb	=> s00_axi_wstrb_s,
                    s00_axi_wvalid	=> s00_axi_wvalid_s,
                    s00_axi_wready	=> s00_axi_wready_s,
                    s00_axi_bresp	=> s00_axi_bresp_s,
                    s00_axi_bvalid	=> s00_axi_bvalid_s,
                    s00_axi_bready	=> s00_axi_bready_s,
                    s00_axi_araddr	=> s00_axi_araddr_s, 
                    s00_axi_arprot	=> s00_axi_arprot_s,
                    s00_axi_arvalid => s00_axi_arvalid_s,	
                    s00_axi_arready	=> s00_axi_arready_s,
                    s00_axi_rdata	=> s00_axi_rdata_s,
                    s00_axi_rresp	=> s00_axi_rresp_s,
                    s00_axi_rvalid	=> s00_axi_rvalid_s,
                    s00_axi_rready	=> s00_axi_rready_s,
            
                    -- Ports of Axi Master Bus Interface M00_AXI
                    m00_axi_init_axi_txn    => m00_init_axi_txn_s,	
                    m00_axi_txn_done	    => m00_axi_txn_done_s,
                    m00_axi_error           => m00_axi_error_s,	
                    m00_axi_aclk	        => clk_s,
                    m00_axi_aresetn	        => m00_axi_aresetn_s,
                    m00_axi_awid	        => m00_axi_awid_s,
                    m00_axi_awaddr	        => m00_axi_awaddr_s,
                    m00_axi_awlen	        => m00_axi_awlen_s,
                    m00_axi_awsize	        => m00_axi_awsize_s,
                    m00_axi_awburst         => m00_axi_awburst_s,	
                    m00_axi_awlock          => m00_axi_awlock_s,	
                    m00_axi_awcache         => m00_axi_awcache_s,	
                    m00_axi_awprot          => m00_axi_awprot_s,	
                    m00_axi_awqos	        => m00_axi_awqos_s,
                    m00_axi_awuser          => m00_axi_awuser_s,	
                    m00_axi_awvalid	        => m00_axi_awvalid_s,
                    m00_axi_awready         => m00_axi_awready_s,	
                    m00_axi_wdata           => m00_axi_wdata_s,	
                    m00_axi_wstrb           => m00_axi_wstrb_s,	
                    m00_axi_wlast           => m00_axi_wlast_s,	
                    m00_axi_wuser           => m00_axi_wuser_s,	
                    m00_axi_wvalid          => m00_axi_wvalid_s,	
                    m00_axi_wready	        => m00_axi_wready_s,
                    m00_axi_bid             => m00_axi_bid_s,	
                    m00_axi_bresp           => m00_axi_bresp_s,	
                    m00_axi_buser           => m00_axi_buser_s,	
                    m00_axi_bvalid          => m00_axi_bvalid_s,	
                    m00_axi_bready          => m00_axi_bready_s,	
                    m00_axi_arid            => m00_axi_arid_s,	
                    m00_axi_araddr	        => m00_axi_araddr_s,
                    m00_axi_arlen           => m00_axi_arlen_s,	
                    m00_axi_arsize	        => m00_axi_arsize_s,
                    m00_axi_arburst         => m00_axi_arburst_s,	
                    m00_axi_arlock          => m00_axi_arlock_s,	
                    m00_axi_arcache         => m00_axi_arcache_s,	
                    m00_axi_arprot          => m00_axi_arprot_s,	
                    m00_axi_arqos           => m00_axi_arqos_s,	
                    m00_axi_aruser          => m00_axi_aruser_s,	
                    m00_axi_arvalid         => m00_axi_arvalid_s,	
                    m00_axi_arready         => m00_axi_arready_s,	
                    m00_axi_rid             => m00_axi_rid_s,	
                    m00_axi_rdata           => m00_axi_rdata_s,	 
                    m00_axi_rresp           => m00_axi_rresp_s,	  
                    m00_axi_rlast           => m00_axi_rlast_s,	 
                    m00_axi_ruser           => m00_axi_ruser_s,	  
                    m00_axi_rvalid          => m00_axi_rvalid_s,	 
                    m00_axi_rready          => m00_axi_rready_s);
            --end psolaf_axi_v1_0;
    

end Behavioral;
