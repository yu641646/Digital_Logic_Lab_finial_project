`timescale 1ns / 1ps

module bcd_to_bin (
    input  wire [3:0] ten,   // BCD 十位數
    input  wire [3:0] one,   // BCD 個位數
    input  wire sign,        // 正負號 (0:正, 1:負)
    
    output wire signed [7:0] bin_out // 8-bit 有號數 (-99 ~ +99)
);

    // 硬體乘法器：十位數 * 10 + 個位數
    wire [6:0] abs_val = (ten * 4'd10) + one;
    
    // 擴充為 8-bit，若 sign 為 1 則取二補數
    wire [7:0] abs_val_8bit = {1'b0, abs_val};
    assign bin_out = sign ? (~abs_val_8bit + 8'd1) : abs_val_8bit;

endmodule