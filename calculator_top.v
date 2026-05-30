`timescale 1ns / 1ps

module calculator_top(
    input  wire clk,                 
    input  wire rst_n,               
    
    // 5 個實體按鍵 (十字方向與確認)
    input  wire btn_center, 
    input  wire btn_up,     
    input  wire btn_down,   
    input  wire btn_left,   
    input  wire btn_right,  
    
    // 指撥開關: [7:6]=OP, [5]=B符號, [4]=A符號
    input  wire [7:0] sw,   
    
    output wire [7:0] anode,
    output wire [7:0] seg_left,
    output wire [7:0] seg_right
);

    // --- 1. 按鍵防彈跳 (Debounce) ---
    wire pulse_center, pulse_up, pulse_down, pulse_left, pulse_right;
    
    debounce u_db_center (.clk(clk), .rst_n(rst_n), .btn_in(btn_center), .btn_pulse(pulse_center));
    debounce u_db_up     (.clk(clk), .rst_n(rst_n), .btn_in(btn_up),     .btn_pulse(pulse_up));
    debounce u_db_down   (.clk(clk), .rst_n(rst_n), .btn_in(btn_down),   .btn_pulse(pulse_down));
    debounce u_db_left   (.clk(clk), .rst_n(rst_n), .btn_in(btn_left),   .btn_pulse(pulse_left));
    debounce u_db_right  (.clk(clk), .rst_n(rst_n), .btn_in(btn_right),  .btn_pulse(pulse_right));

    // --- 2. 輸入介面 (BCD 計數與二進位轉換) ---
    wire [3:0] a_ten, a_one, b_ten, b_one;
    wire a_sign = sw[4];
    wire b_sign = sw[5];
    
    bcd_counter u_counter (
        .clk(clk), .rst_n(rst_n),
        .btn_up_pulse(pulse_up), .btn_down_pulse(pulse_down),
        .btn_left_pulse(pulse_left), .btn_right_pulse(pulse_right),
        .A_ten(a_ten), .A_one(a_one), .B_ten(b_ten), .B_one(b_one)
    );

    wire signed [7:0] bin_A_curr, bin_B_curr;
    bcd_to_bin u_b2b_A (.ten(a_ten), .one(a_one), .sign(a_sign), .bin_out(bin_A_curr));
    bcd_to_bin u_b2b_B (.ten(b_ten), .one(b_one), .sign(b_sign), .bin_out(bin_B_curr));

    // --- 3. 狀態機與資料鎖存 (FSM & Datapath) ---
    localparam S_INPUT   = 1'b0;
    localparam S_DISPLAY = 1'b1;
    reg current_state, next_state;

    reg signed [7:0] reg_A, reg_B;
    reg [1:0] reg_op;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= S_INPUT;
        else        current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        if (pulse_center) begin
            case (current_state)
                S_INPUT:   next_state = S_DISPLAY;
                S_DISPLAY: next_state = S_INPUT;
            endcase
        end
    end

    // 於輸入狀態按下確認鍵時，鎖存當下數值供 ALU 運算
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_A  <= 8'sd0;
            reg_B  <= 8'sd0;
            reg_op <= 2'b00;
        end else if (current_state == S_INPUT && pulse_center) begin
            reg_A  <= bin_A_curr;
            reg_B  <= bin_B_curr;
            reg_op <= sw[7:6];
        end
    end

    // --- 4. 算術運算與 BCD 解碼 (ALU & Double Dabble) ---
    wire signed [14:0] calc_res;
    wire alu_error;

    alu u_alu (
        .A(reg_A), .B(reg_B), .op(reg_op),
        .res(calc_res), .error(alu_error)
    );

    // 擷取 15-bit 結果的符號與絕對值
    wire is_neg = calc_res[14]; 
    wire [14:0] abs_res = is_neg ? (~calc_res + 1'b1) : calc_res;
    
    wire [3:0] bcd_tho, bcd_hun, bcd_ten, bcd_one;
    bcd_converter u_bcd (
        .bin_in(abs_res), 
        .bcd_tho(bcd_tho), .bcd_hun(bcd_hun), .bcd_ten(bcd_ten), .bcd_one(bcd_one)
    );

    // --- 5. 動態掃描顯示多工器 ---
    seg_display u_seg (
        .clk(clk), .rst_n(rst_n),
        .current_state(current_state),
        .A_sign(a_sign), .A_ten(a_ten), .A_one(a_one),
        .B_sign(b_sign), .B_ten(b_ten), .B_one(b_one),
        .res_sign(is_neg),
        .res_tho(bcd_tho), .res_hun(bcd_hun), .res_ten(bcd_ten), .res_one(bcd_one),
        .error_flag(alu_error),
        .anode(anode), .seg_data(seg_left)
    );

    // EGO1 左右側並聯
    assign seg_right = seg_left;

endmodule