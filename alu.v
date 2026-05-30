`timescale 1ns / 1ps

module alu (
    input  wire signed [7:0] A,      // 8-bit 有號數 (-99 ~ +99)
    input  wire signed [7:0] B,      // 8-bit 有號數 (-99 ~ +99)
    input  wire [1:0] op,            // 運算碼 (00:+, 01:-, 10:*, 11:/)
    output reg  signed [14:0] res,   // 15-bit 運算結果 (-16384 ~ +16383)
    output reg  error                // 除零錯誤旗標
);

    always @(*) begin
        // 預設值 (防止 Latch)
        res = 15'sd0; 
        error = 1'b0;

        case (op)
            2'b00: res = A + B;
            2'b01: res = A - B;
            2'b10: res = A * B;
            2'b11: begin
                if (B == 8'sd0) begin
                    error = 1'b1;
                    res = 15'sd0;
                end else begin
                    res = A / B;
                end
            end
            default: begin
                res = 15'sd0;
                error = 1'b0;
            end
        endcase
    end

endmodule