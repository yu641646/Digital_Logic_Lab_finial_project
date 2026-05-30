`timescale 1ns / 1ps

module seg_display (
    input  wire clk, rst_n, current_state,
    
    input  wire A_sign, 
    input  wire [3:0] A_ten, A_one,
    input  wire B_sign, 
    input  wire [3:0] B_ten, B_one,
    
    input  wire res_sign,
    input  wire [3:0] res_tho, res_hun, res_ten, res_one,
    input  wire error_flag,
    
    output reg  [7:0] anode, seg_data
);

    // --- 1. 掃描時脈產生器 ---
    reg [16:0] scan_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) scan_cnt <= 17'd0;
        else        scan_cnt <= scan_cnt + 1'b1;
    end
    wire [2:0] scan_idx = scan_cnt[16:14];

    // --- 2. 七段顯示解碼器 ---
    function [7:0] decode(input [3:0] digit);
        case(digit)
            4'h0: decode = 8'b0011_1111; 4'h1: decode = 8'b0000_0110;
            4'h2: decode = 8'b0101_1011; 4'h3: decode = 8'b0100_1111;
            4'h4: decode = 8'b0110_0110; 4'h5: decode = 8'b0110_1101;
            4'h6: decode = 8'b0111_1101; 4'h7: decode = 8'b0000_0111;
            4'h8: decode = 8'b0111_1111; 4'h9: decode = 8'b0110_1111;
            default: decode = 8'b0000_0000;
        endcase
    endfunction

    // --- 3. 同步輸出與 50% 佔空比消隱 (消除鬼影) ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            anode <= 8'd0; seg_data <= 8'd0;
        end else if (scan_cnt[13] == 1'b0) begin
            anode <= 8'd0; seg_data <= 8'd0; // 前半週期強制全暗 (消隱放電)
        end else begin
            if (current_state == 1'b0) begin
                // S_INPUT: 顯示 [A號][A十][A個][空] | [B號][B十][B個][空]
                case (scan_idx)
                    3'b000: begin anode <= 8'b0000_0001; seg_data <= A_sign ? 8'b0100_0000 : 8'b0000_0000; end
                    3'b001: begin anode <= 8'b0000_0010; seg_data <= decode(A_ten); end
                    3'b010: begin anode <= 8'b0000_0100; seg_data <= decode(A_one); end
                    3'b011: begin anode <= 8'b0000_1000; seg_data <= 8'b0000_0000; end
                    
                    3'b100: begin anode <= 8'b0001_0000; seg_data <= B_sign ? 8'b0100_0000 : 8'b0000_0000; end
                    3'b101: begin anode <= 8'b0010_0000; seg_data <= decode(B_ten); end
                    3'b110: begin anode <= 8'b0100_0000; seg_data <= decode(B_one); end
                    3'b111: begin anode <= 8'b1000_0000; seg_data <= 8'b0000_0000; end
                endcase
            end else begin
                // S_DISPLAY: 靠右對齊顯示結果 (含零消隱)
                case (scan_idx)
                    3'b000, 3'b001, 3'b010: begin anode <= 8'd0; seg_data <= 8'd0; end
                    
                    3'b011: begin // 符號位
                        anode <= 8'b0000_1000; 
                        if (error_flag) seg_data <= 8'd0; 
                        else            seg_data <= res_sign ? 8'b0100_0000 : 8'd0;
                    end
                    3'b100: begin // 千位 (零消隱)
                        anode <= 8'b0001_0000; 
                        if (error_flag)      seg_data <= 8'b0111_1001; // 顯示 'E'
                        else if (res_tho==0) seg_data <= 8'd0; 
                        else                 seg_data <= decode(res_tho);
                    end
                    3'b101: begin // 百位 (千與百皆 0 則消隱)
                        anode <= 8'b0010_0000; 
                        if (error_flag)                           seg_data <= 8'b0111_1001; 
                        else if (res_tho==0 && res_hun==0)        seg_data <= 8'd0; 
                        else                                      seg_data <= decode(res_hun);
                    end
                    3'b110: begin // 十位 (千、百、十皆 0 則消隱)
                        anode <= 8'b0100_0000; 
                        if (error_flag)                                      seg_data <= 8'b0111_1001; 
                        else if (res_tho==0 && res_hun==0 && res_ten==0)     seg_data <= 8'd0; 
                        else                                                 seg_data <= decode(res_ten);
                    end
                    3'b111: begin // 個位 (必定顯示)
                        anode <= 8'b1000_0000; 
                        if (error_flag) seg_data <= 8'b0111_1001; 
                        else            seg_data <= decode(res_one); 
                    end
                endcase
            end
        end
    end

endmodule