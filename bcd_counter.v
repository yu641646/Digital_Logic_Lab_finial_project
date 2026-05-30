`timescale 1ns / 1ps

module bcd_counter (
    input  wire clk,
    input  wire rst_n,
    
    input  wire btn_up_pulse,    // 控制 A 十位
    input  wire btn_down_pulse,  // 控制 A 個位
    input  wire btn_left_pulse,  // 控制 B 十位
    input  wire btn_right_pulse, // 控制 B 個位
    
    output reg [3:0] A_ten, A_one,
    output reg [3:0] B_ten, B_one
);

    // 獨立控制 4 個位數的 0~9 循環加法
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) A_ten <= 4'd0;
        else if (btn_up_pulse) A_ten <= (A_ten == 4'd9) ? 4'd0 : A_ten + 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) A_one <= 4'd0;
        else if (btn_down_pulse) A_one <= (A_one == 4'd9) ? 4'd0 : A_one + 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) B_ten <= 4'd0;
        else if (btn_left_pulse) B_ten <= (B_ten == 4'd9) ? 4'd0 : B_ten + 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) B_one <= 4'd0;
        else if (btn_right_pulse) B_one <= (B_one == 4'd9) ? 4'd0 : B_one + 1'b1;
    end

endmodule