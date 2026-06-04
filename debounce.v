`timescale 1ns / 1ps

module debounce (
    input  wire clk,
    input  wire rst,
    input  wire btn_in,
    output wire pulse
);
    reg [19:0] cnt;
    reg d1, d2, state, state_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            cnt <= 0; d1 <= 0; d2 <= 0; state <= 0; state_d <= 0; 
        end else begin
            d1 <= btn_in; 
            d2 <= d1;
            
            if (d1 == d2) cnt <= cnt + 1; 
            else cnt <= 0;
            
            if (cnt == 20'd1_000_000) state <= d2;
            state_d <= state;
        end
    end

    assign pulse = state & ~state_d;
endmodule