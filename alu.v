`timescale 1ns / 1ps

module alu (
    input  wire signed [31:0] val_A,
    input  wire signed [31:0] val_B,
    input  wire [3:0] op_sel,
    output reg  signed [31:0] val_Res,
    output reg  err,
    output reg  [7:0] dp_ctrl
);

    reg [31:0] uA, uB, uRes;

    always @(*) begin
        err = 0;
        val_Res = 0;
        dp_ctrl = 8'b0000_0000;

        case (op_sel)
            4'b1000: begin 
                val_Res = val_A + val_B; 
                dp_ctrl = 8'b0000_0010; 
            end
            4'b0100: begin 
                val_Res = val_A - val_B; 
                dp_ctrl = 8'b0000_0010; 
            end
            4'b0010: begin 
                val_Res = (val_A * val_B) / 10; 
                dp_ctrl = 8'b0000_0010; 
            end
            4'b0001: begin
                if (val_B == 0) begin
                    err = 1;
                end else begin
                    // Handle signed division by resolving absolute magnitudes first
                    uA = (val_A < 0) ? -val_A : val_A;
                    uB = (val_B < 0) ? -val_B : val_B;
                    uRes = (uA * 1000) / uB;
                    val_Res = ((val_A < 0) ^ (val_B < 0)) ? -uRes : uRes;
                end
                dp_ctrl = 8'b0000_1000; 
            end
            default: begin
                err = 1; 
            end
        endcase
    end
endmodule