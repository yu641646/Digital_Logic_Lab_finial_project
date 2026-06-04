`timescale 1ns / 1ps

module seg_display (
    input  wire clk,
    input  wire [31:0] flat_D,
    input  wire [31:0] flat_R,
    input  wire [2:0] cursor,
    input  wire show_result,
    input  wire [7:0] dp_ctrl,
    output reg  [7:0] anode,
    output reg  [7:0] seg_left,
    output reg  [7:0] seg_right
);

    reg [16:0] scan_cnt;
    reg [24:0] blink_cnt;

    always @(posedge clk) begin
        scan_cnt <= scan_cnt + 1;
        blink_cnt <= blink_cnt + 1;
    end

    wire [2:0] scan_idx = scan_cnt[16:14];
    wire cursor_blink = blink_cnt[24];
    wire hw_blanking = (scan_cnt[13:12] == 2'b00);

    function [6:0] decode(input [3:0] digit);
        case(digit)
            4'h0: decode = 7'b0111111; 
            4'h1: decode = 7'b0000110;
            4'h2: decode = 7'b1011011; 
            4'h3: decode = 7'b1001111;
            4'h4: decode = 7'b1100110; 
            4'h5: decode = 7'b1101101;
            4'h6: decode = 7'b1111101; 
            4'h7: decode = 7'b0000111;
            4'h8: decode = 7'b1111111; 
            4'h9: decode = 7'b1101111;
            4'hA: decode = 7'b1000000; // Sign
            4'hE: decode = 7'b1111001; // Error
            default: decode = 7'b0000000; // Blank
        endcase
    endfunction

    reg [3:0] current_digit;
    always @(*) begin
        if (show_result) begin
            case(scan_idx)
                0: current_digit = flat_R[3:0];
                1: current_digit = flat_R[7:4];
                2: current_digit = flat_R[11:8];
                3: current_digit = flat_R[15:12];
                4: current_digit = flat_R[19:16];
                5: current_digit = flat_R[23:20];
                6: current_digit = flat_R[27:24];
                7: current_digit = flat_R[31:28];
            endcase
        end else begin
            case(scan_idx)
                0: current_digit = flat_D[3:0];
                1: current_digit = flat_D[7:4];
                2: current_digit = flat_D[11:8];
                3: current_digit = flat_D[15:12];
                4: current_digit = flat_D[19:16];
                5: current_digit = flat_D[23:20];
                6: current_digit = flat_D[27:24];
                7: current_digit = flat_D[31:28];
            endcase
        end
    end

    wire current_dp = dp_ctrl[scan_idx];
    wire hide_plus = (!show_result && current_digit==0 && (scan_idx==7 || scan_idx==3));
    wire cursor_off = (!show_result && scan_idx==cursor && cursor_blink);

    always @(posedge clk) begin
        if (hw_blanking || cursor_off) begin
            anode <= 8'd0; seg_left <= 8'd0; seg_right <= 8'd0;
        end else begin
            anode <= (8'b00000001 << scan_idx);
            if (scan_idx >= 4) begin
                seg_left  <= hide_plus ? 8'd0 : {current_dp, decode(current_digit)};
                seg_right <= 8'd0;
            end else begin
                seg_left  <= 8'd0;
                seg_right <= hide_plus ? 8'd0 : {current_dp, decode(current_digit)};
            end
        end
    end

endmodule