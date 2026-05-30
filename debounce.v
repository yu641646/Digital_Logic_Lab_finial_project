`timescale 1ns / 1ps

module debounce (
    input  wire clk, rst_n, btn_in,
    output wire btn_pulse
);

    // 1. 雙層同步暫存器 (消除亞穩態)
    reg btn_ff1, btn_ff2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_ff1 <= 1'b0; btn_ff2 <= 1'b0;
        end else begin
            btn_ff1 <= btn_in; btn_ff2 <= btn_ff1;
        end
    end

    // 2. 防彈跳計數器 (20ms)
    reg [20:0] count;
    reg btn_stable; 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 21'd0; btn_stable <= 1'b0;
        end else begin
            if (btn_ff2 != btn_stable) begin
                count <= count + 1'b1;
                if (count == 21'd2_000_000) begin  
                    btn_stable <= btn_ff2;
                    count <= 21'd0;
                end
            end else begin
                count <= 21'd0;
            end
        end
    end

    // 3. 正緣觸發 (產生單步脈衝)
    reg btn_stable_delay;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) btn_stable_delay <= 1'b0;
        else        btn_stable_delay <= btn_stable;
    end

    assign btn_pulse = btn_stable & (~btn_stable_delay);

endmodule