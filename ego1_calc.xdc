# ==========================================
# Clock and Reset
# ==========================================
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { clk }];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { rst_n }];     # S6 鍵 (獨立重置鍵)

# ==========================================
# 5 Cross Buttons (十字方向鍵)
# ==========================================
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { btn_center }];# S1 鍵 (中：確認)
set_property -dict { PACKAGE_PIN U4    IOSTANDARD LVCMOS33 } [get_ports { btn_up }];    # S4 鍵 (上：A十位+1)
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { btn_down }];  # S2 鍵 (下：A個位+1)
set_property -dict { PACKAGE_PIN V1    IOSTANDARD LVCMOS33 } [get_ports { btn_left }];  # S3 鍵 (左：B十位+1)
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { btn_right }]; # S0 鍵 (右：B個位+1)

# ==========================================
# DIP Switches (SW7 ~ SW0)
# ==========================================
set_property -dict { PACKAGE_PIN R1    IOSTANDARD LVCMOS33 } [get_ports { sw[7] }];     # OP[1]
set_property -dict { PACKAGE_PIN N4    IOSTANDARD LVCMOS33 } [get_ports { sw[6] }];     # OP[0]
set_property -dict { PACKAGE_PIN M4    IOSTANDARD LVCMOS33 } [get_ports { sw[5] }];     # B 符號
set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports { sw[4] }];     # A 符號
set_property -dict { PACKAGE_PIN P2    IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];     # 保留未使用
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];     # 保留未使用
set_property -dict { PACKAGE_PIN P4    IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];     # 保留未使用
set_property -dict { PACKAGE_PIN P5    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];     # 保留未使用

# ==========================================
# 7-Segment Display Anodes (Digit Selection)
# anode[0] is Leftmost, anode[7] is Rightmost
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
# 7-Segment Display Segments - Left 4 Digits (dp, g, f, e, d, c, b, a)
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
# 7-Segment Display Segments - Right 4 Digits (dp, g, f, e, d, c, b, a)
# ==========================================
set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { seg_right[7] }];
set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { seg_right[6] }];
set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { seg_right[5] }];
set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { seg_right[4] }];
set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { seg_right[3] }];
set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { seg_right[2] }];
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { seg_right[1] }];
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { seg_right[0] }];