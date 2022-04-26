module add_imm (
    input clk,
    input src_reg, 
    input imm_value, 
    input dest_reg, 
    input [15:0] r0,
    input [15:0] r1,
    input [15:0] r2,
    input [15:0] r3,
    input [15:0] r4,
    input [15:0] r5,
    input [15:0] r6,
    input [15:0] r7,
    output reg [15:0] o_r0,
    output reg [15:0] o_r1,
    output reg [15:0] o_r2,
    output reg [15:0] o_r3,
    output reg [15:0] o_r4,
    output reg [15:0] o_r5,
    output reg [15:0] o_r6,
    output reg [15:0] o_r7
);
    wire lhs;
    wire rhs;

    initial begin
        case (dest_reg)
            3'b000: assign lhs=o_r0;
            3'b001: assign lhs=o_r1;
            3'b010: assign lhs=o_r2;
            3'b011: assign lhs=o_r3;
            3'b100: assign lhs=o_r4;
            3'b101: assign lhs=o_r5;
            3'b110: assign lhs=o_r6;
            3'b111: assign lhs=o_r7;
            default: $display("error");
        endcase
        case (src_reg)
            3'b000: assign rhs=r0;
            3'b001: assign rhs=r1;
            3'b010: assign rhs=r2;
            3'b011: assign rhs=r3;
            3'b100: assign rhs=r4;
            3'b101: assign rhs=r5;
            3'b110: assign rhs=r6;
            3'b111: assign rhs=r7;
            default: $display("error");
        endcase
    end

    always @(posedge clk ) begin
        rhs = rhs+1;        
    end

endmodule