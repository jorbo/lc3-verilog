`timescale 1ns/1ps  
module cpu(input i_clk, input [SIZE-1:0] i_instructions);

    parameter SIZE = 80;
    reg [16:0] pc = 0;
    reg [15:0] registers [7:1];
    reg [15:0] IR = 16'b0;
    reg [3:0] opcode;
    reg [2:0] src_reg;
    reg [2:0] src_reg2;
    reg [2:0] dst_reg;
    reg [4:0] imm_value;
    reg running = 1;
    integer i = 15;

    always @(posedge i_clk & running) begin  
        IR = i_instructions[i-:16];
        pc = pc + 1;
        // $display("PC: %3d INSTR: %b", pc, IR);
        opcode <= IR[15:12];
        dst_reg <= IR[11:9];
        src_reg <= IR[8:6];
       case(opcode)
           4'b0001: begin // ADD
               //IMMEDIATE MODE
               if(IR[5] & 1'b1) begin     
                imm_value = IR[4:0];                
                registers[dst_reg] = registers[src_reg] + imm_value;                
                end
                if(IR[5] & 1'b0) begin
                    src_reg2 = IR[2:0];
                    registers[dst_reg] = registers[src_reg] + registers[src_reg2];                             
                end                        
           end
           4'b0101: begin // BITWISE AND
               //IMMEDIATE MODE
                if(IR[5] & 1'b1) begin     
                    imm_value = IR[4:0];                            
                    registers[dst_reg] = registers[src_reg] & imm_value;
                end
                if(IR[5] & 1'b0) begin                 
                    registers[dst_reg] = registers[src_reg] & registers[src_reg2];
                end
           end
           4'b1001: registers[dst_reg] = ~registers[src_reg]; //BITWISE NOT
           4'b1111: running = 0; // HALT
       endcase

        i = i+16;
    end


endmodule