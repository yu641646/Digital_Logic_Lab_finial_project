# ==========================================
# Clock & Reset
# ==========================================
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { clk }];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { rst_n }];     # S6

# ==========================================
# §Q¶r¡‰ Buttons 
# ==========================================
set_property -dict { PACKAGE_PIN V1    IOSTANDARD LVCMOS33 } [get_ports { btn_left }];  # S3
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { btn_right }]; # S0
set_property -dict { PACKAGE_PIN U4    IOSTANDARD LVCMOS33 } [get_ports { btn_up }];    # S4
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { btn_down }];  # S1
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { btn_exec }];  # S2

# ==========================================
# DIP Switches (SW7 ~ SW0)
# ==========================================
set_property -dict { PACKAGE_PIN P5    IOSTANDARD LVCMOS33 } [get_ports { sw[7] }];
set_property -dict { PACKAGE_PIN P4    IOSTANDARD LVCMOS33 } [get_ports { sw[6] }];
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports { sw[5] }];
set_property -dict { PACKAGE_PIN P2    IOSTANDARD LVCMOS33 } [get_ports { sw[4] }];
set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];
set_property -dict { PACKAGE_PIN M4    IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN N4    IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN R1    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];

# ==========================================
# 7-Segment Display Anodes
# ==========================================
set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { anode[0] }];
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { anode[1] }];
set_property -dict { PACKAGE_PIN C1    IOSTANDARD LVCMOS33 } [get_ports { anode[2] }];
set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { anode[3] }];
set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { anode[4] }];
set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { anode[5] }];
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { anode[6] }];
set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports { anode[7] }];

# ==========================================
# 7-Segment Segments - Left
# ==========================================
set_property -dict { PACKAGE_PIN D5    IOSTANDARD LVCMOS33 } [get_ports { seg_left[7] }];
set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { seg_left[6] }];
set_property -dict { PACKAGE_PIN B3    IOSTANDARD LVCMOS33 } [get_ports { seg_left[5] }];
set_property -dict { PACKAGE_PIN A1    IOSTANDARD LVCMOS33 } [get_ports { seg_left[4] }];
set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { seg_left[3] }];
set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { seg_left[2] }];
set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { seg_left[1] }];
set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { seg_left[0] }];

# ==========================================
# 7-Segment Segments - Right
# ==========================================
set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { seg_right[7] }];
set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { seg_right[6] }];
set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { seg_right[5] }];
set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { seg_right[4] }];
set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { seg_right[3] }];
set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { seg_right[2] }];
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { seg_right[1] }];
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { seg_right[0] }];