`timescale 1ns / 1ps

module calculator_top_tb;

    // --- 1. 測試訊號宣告 ---
    reg clk;
    reg rst_n;
    
    // 新增的五顆按鍵
    reg btn_center;
    reg btn_up;
    reg btn_down;
    reg btn_left;
    reg btn_right;
    
    reg [7:0] sw;

    wire [7:0] anode;
    wire [7:0] seg_left;
    wire [7:0] seg_right;

    // --- 2. 實例化 DUT ---
    calculator_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .btn_center(btn_center),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .sw(sw),
        .anode(anode),
        .seg_left(seg_left),
        .seg_right(seg_right)
    );

    // --- 3. 系統時脈產生 (100MHz) ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // --- 4. 定義模擬按鍵按下的 Task ---
    task press_center; begin btn_center = 1; #200; btn_center = 0; #100; end endtask
    task press_up;     begin btn_up = 1;     #200; btn_up = 0;     #100; end endtask
    task press_left;   begin btn_left = 1;   #200; btn_left = 0;   #100; end endtask

    // --- 5. 核心測試流程 ---
    initial begin
        // 初始化所有訊號
        rst_n = 0;
        btn_center = 0;
        btn_up = 0;
        btn_down = 0;
        btn_left = 0;
        btn_right = 0;
        sw = 8'b0000_0000;

        // 系統重置
        #20 rst_n = 1;
        #50;

        $display("--- 測試開始 ---");

        // 模擬輸入 A = 10 (按一下 up), B = 10 (按一下 left)
        press_up();
        #100;
        press_left();
        #100;

        // 模擬設定為加法 (sw[7:6] = 00)，並按下確認鍵
        sw = 8'b00_000_000;
        press_center();
        #500;

        $display("--- 測試結束 ---");
        $finish; 
    end

endmodule