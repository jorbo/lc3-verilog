`timescale 1ns/1ps
module cpu(input i_clk,
           input [15:0] i_instructions [SIZE-1:0]);
    
    parameter SIZE = 80;
    reg [16:0] pc  = 0;
    reg [15:0] registers [7:0];
    reg [15:0] IR = 16'b0;
    reg [3:0] opcode;
    reg [2:0] src_reg;
    reg [2:0] src_reg2;
    reg [2:0] dst_reg;
    reg [4:0] imm_value;
    reg [8:0] pcoffset;
    // (N)egative = CC[0]
    // (Z)ero = CC[1];
    // (P)ositive = CC[2];
    reg [2:0] CC;
    reg running = 1;
    
    always @(posedge i_clk && running) begin
        IR = i_instructions[pc];
        // $display("PC: %3d INSTR: %b", pc, IR);
        opcode  = IR[15:12];
        dst_reg = IR[11:9];
        src_reg = IR[8:6];
        // $display("PC: %2d OP: %b DST: r%d SRC: r%d", pc, opcode, dst_reg, src_reg);
        case(opcode)
            // BR[NZP]
            4'b0000: begin
                // OFFSET IS NEGATIVE
                if(IR[8] == 1) begin
                    // IF OFFSET Is NEGATIVE then we 2's compliment
                    pcoffset = ~IR[8:0] + 1;
                    // UNCONDITIONAL BRANCH
                    if(IR[11:9] == 3'b111) begin                    
                        pc = pc - pcoffset;
                    end                
                    // Only branch if our branch condition matches the one of the NZP values in the CC register
                    if(IR[11] & CC[0] | IR[10] & CC[1] | IR[9] & CC[2]) begin
                        pc = pc - pcoffset;
                    end
                end
                if(IR[8] == 0) begin
                    pcoffset = IR[8:0];
                    // UNCONDITIONAL BRANCH
                    if(IR[11:9] == 3'b111) begin
                        pc = pc + pcoffset;
                    end                
                    // Only branch if our branch condition matches the one of the NZP values in the CC register
                    if(IR[11] & CC[0] | IR[10] & CC[1] | IR[9] & CC[2]) begin
                        pc = pc + pcoffset;
                    end
                end
            end
            4'b0001: begin // ADD
                //IMMEDIATE MODE
                if (IR[5] == 1'b1) begin
                    imm_value          = IR[4:0];
                    registers[dst_reg] = registers[src_reg] + imm_value;
                end
                if (IR[5] == 1'b0) begin
                    src_reg2           = IR[2:0];
                    registers[dst_reg] = registers[src_reg] + registers[src_reg2];
                end
            end
            4'b0101: begin // BITWISE AND
                //IMMEDIATE MODE
                if (IR[5] == 1'b1) begin
                    imm_value          = IR[4:0];
                    registers[dst_reg] = registers[src_reg] & imm_value;
                end
                if (IR[5] ==1'b0) begin
                    registers[dst_reg] = registers[src_reg] & registers[src_reg2];
                end
            end
            4'b1001: registers[dst_reg] = ~registers[src_reg]; //BITWISE NOT
            4'b1111: running            = 0; // HALT
        endcase
        
        pc = pc + 1;
    end
    
    
endmodule
