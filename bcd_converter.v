`timescale 1ns / 1ps

module bcd_converter (
    input  wire [14:0] bin_in,  // 15-bit 二進位絕對值輸入
    output reg  [3:0] bcd_tho,  // 千位
    output reg  [3:0] bcd_hun,  // 百位
    output reg  [3:0] bcd_ten,  // 十位
    output reg  [3:0] bcd_one   // 個位
);

    integer i;

    always @(*) begin
        // 預設歸零 (防止 Latch)
        bcd_tho = 4'd0; bcd_hun = 4'd0; bcd_ten = 4'd0; bcd_one = 4'd0;

        // Shift-and-Add-3 演算法 (15 次迴圈)
        for (i = 14; i >= 0; i = i - 1) begin
            if (bcd_tho >= 5) bcd_tho = bcd_tho + 3;
            if (bcd_hun >= 5) bcd_hun = bcd_hun + 3;
            if (bcd_ten >= 5) bcd_ten = bcd_ten + 3;
            if (bcd_one >= 5) bcd_one = bcd_one + 3;

            // 全體左移 1 bit
            bcd_tho = bcd_tho << 1; bcd_tho[0] = bcd_hun[3];
            bcd_hun = bcd_hun << 1; bcd_hun[0] = bcd_ten[3];
            bcd_ten = bcd_ten << 1; bcd_ten[0] = bcd_one[3];
            bcd_one = bcd_one << 1; bcd_one[0] = bin_in[i]; 
        end
    end

endmodule