`timescale 1ns / 1ps

module calculator_top (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_left,
    input  wire btn_right,
    input  wire btn_up,
    input  wire btn_down,
    input  wire btn_exec,
    input  wire [7:0] sw,
    output wire [7:0] anode,
    output wire [7:0] seg_left,
    output wire [7:0] seg_right
);

    wire rst = ~rst_n;

    // --- Debounce Instantiation ---
    wire p_l, p_r, p_u, p_d, p_e;
    debounce dl (.clk(clk), .rst(rst), .btn_in(btn_left),  .pulse(p_l));
    debounce dr (.clk(clk), .rst(rst), .btn_in(btn_right), .pulse(p_r));
    debounce du (.clk(clk), .rst(rst), .btn_in(btn_up),    .pulse(p_u));
    debounce dd (.clk(clk), .rst(rst), .btn_in(btn_down),  .pulse(p_d));
    debounce de (.clk(clk), .rst(rst), .btn_in(btn_exec),  .pulse(p_e));

    // --- Core Registers ---
    reg [3:0] D [0:7];       
    reg [3:0] R [0:7];       
    reg [2:0] cursor;        
    reg show_result;         
    reg [7:0] dp_ctrl;       
    reg err;                 

    // Parse Input Values
    wire signed [31:0] val_A = (D[7]==4'hA ? -1 : 1) * (D[6]*100 + D[5]*10 + D[4]);
    wire signed [31:0] val_B = (D[3]==4'hA ? -1 : 1) * (D[2]*100 + D[1]*10 + D[0]);
    wire [3:0] op_sel = { (sw[7]|sw[6]), (sw[5]|sw[4]), (sw[3]|sw[2]), (sw[1]|sw[0]) };

    // ALU Connections
    wire signed [31:0] alu_res;
    wire alu_err;
    wire [7:0] alu_dp;

    alu alu_inst (
        .val_A(val_A),
        .val_B(val_B),
        .op_sel(op_sel),
        .val_Res(alu_res),
        .err(alu_err),
        .dp_ctrl(alu_dp)
    );

    // --- Main State Machine ---
    reg [3:0] state;
    reg [31:0] abs_res;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0; show_result <= 0; cursor <= 7;
            for(i=0; i<8; i=i+1) D[i] <= 0;
        end else begin
            case(state)
                0: begin // State 0: Input and Cursor Control
                    show_result <= 0;
                    dp_ctrl <= 8'b0010_0010; 
                    
                    if (p_l) cursor <= (cursor == 7) ? 0 : cursor + 1;
                    if (p_r) cursor <= (cursor == 0) ? 7 : cursor - 1;
                    
                    if (p_u) begin
                        if (cursor==7 || cursor==3) D[cursor] <= (D[cursor]==4'hA) ? 0 : 4'hA;
                        else D[cursor] <= (D[cursor]==9) ? 0 : D[cursor]+1;
                    end
                    if (p_d) begin
                        if (cursor==7 || cursor==3) D[cursor] <= (D[cursor]==4'hA) ? 0 : 4'hA;
                        else D[cursor] <= (D[cursor]==0) ? 9 : D[cursor]-1;
                    end
                    
                    if (p_e) state <= 1; 
                end

                1: begin // State 1: Arithmetic Execution
                    err <= alu_err;
                    dp_ctrl <= alu_dp;
                    state <= 2;
                end

                2: begin // State 2: Absolute Value
                    abs_res <= (alu_res < 0) ? -alu_res : alu_res;
                    state <= 3;
                end

                3: begin // State 3: BCD Extraction (Low)
                    R[0] <= abs_res % 10;
                    R[1] <= (abs_res / 10) % 10;
                    R[2] <= (abs_res / 100) % 10;
                    R[3] <= (abs_res / 1000) % 10;
                    state <= 4;
                end

                4: begin // State 4: BCD Extraction (High)
                    R[4] <= (abs_res / 10000) % 10;
                    R[5] <= (abs_res / 100000) % 10;
                    R[6] <= (abs_res / 1000000) % 10;
                    R[7] <= 4'hB; 
                    state <= 5;
                end

                5: begin // State 5: Dynamic Zero Blanking
                    if (op_sel == 4'b0001) begin 
                        if (R[6]==0) begin R[6]<=4'hB;
                            if (R[5]==0) begin R[5]<=4'hB;
                                if (R[4]==0) begin R[4]<=4'hB; end
                            end
                        end
                    end else begin 
                        if (R[6]==0) begin R[6]<=4'hB;
                            if (R[5]==0) begin R[5]<=4'hB;
                                if (R[4]==0) begin R[4]<=4'hB;
                                    if (R[3]==0) begin R[3]<=4'hB;
                                        if (R[2]==0) begin R[2]<=4'hB; end
                                    end
                                end
                            end
                        end
                    end
                    state <= 6;
                end

                6: begin // State 6: Floating Sign and Error Handling
                    if (err) begin
                        R[7]<=4'hB; R[6]<=4'hB; R[5]<=4'hB; R[4]<=4'hB;
                        R[3]<=4'hB; R[2]<=4'hB; R[1]<=4'hB; R[0]<=4'hE;
                        dp_ctrl <= 8'b0000_0000;
                    end else if (alu_res < 0) begin
                        if      (R[6]==4'hB) R[6]<=4'hA;
                        else if (R[5]==4'hB) R[5]<=4'hA;
                        else if (R[4]==4'hB) R[4]<=4'hA;
                        else if (R[3]==4'hB && op_sel!=4'b0001) R[3]<=4'hA;
                        else if (R[2]==4'hB && op_sel!=4'b0001) R[2]<=4'hA;
                    end
                    state <= 7;
                end

                7: begin // State 7: Display Result
                    show_result <= 1;
                    if (p_e) state <= 0; 
                end
            endcase
        end
    end

    // --- Display Module Instantiation ---
    wire [31:0] flat_D = {D[7], D[6], D[5], D[4], D[3], D[2], D[1], D[0]};
    wire [31:0] flat_R = {R[7], R[6], R[5], R[4], R[3], R[2], R[1], R[0]};

    seg_display disp_inst (
        .clk(clk),
        .flat_D(flat_D),
        .flat_R(flat_R),
        .cursor(cursor),
        .show_result(show_result),
        .dp_ctrl(dp_ctrl),
        .anode(anode),
        .seg_left(seg_left),
        .seg_right(seg_right)
    );

endmodule