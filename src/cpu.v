module cpu(input i_clk, input [SIZE-1:0] i_instructions);

    parameter SIZE = 80;
    reg [16:0] pc = 0;
    reg [15:0] registers [7:1];
    reg [15:0] curr_instr = 16'b0;
    reg [3:0] opcode;
    reg [2:0] src_reg;
    reg [2:0] src_reg2;
    reg [2:0] dst_reg;
    reg [4:0] imm_value;
    reg running = 1;
    integer i = 0;

    

    always @(posedge i_clk) begin   
        curr_instr = i_instructions[i-:16];
        $display("PC: %3d INSTR: %b", pc, curr_instr);
        opcode = curr_instr[15:12];
        dst_reg = curr_instr[11:9];
        src_reg = curr_instr[8:6];
        if(opcode == 4'b1111) begin
            running = 0;
            $display("HALT");
        end
       case(opcode)
           4'b0001: begin
               //IMMEDIATE MODE
               if(curr_instr[5] & 1'b1) begin     
                imm_value = curr_instr[4:0];                
                registers[dst_reg] = registers[src_reg] + imm_value;                
                end
                if(curr_instr[5] & 1'b0) begin
                    src_reg2 = curr_instr[2:0];
                    registers[dst_reg] = registers[src_reg] + registers[src_reg2];                             
                end                        
           end
           4'b0101: begin
               //IMMEDIATE MODE
                if(curr_instr[5] & 1'b1) begin     
                    imm_value = curr_instr[4:0];                            
                    registers[dst_reg] = registers[src_reg] & imm_value;
                end
                if(curr_instr[5] & 1'b0) begin                 
                    registers[dst_reg] = registers[src_reg] & registers[src_reg2];
                end
           end
           4'b1001: registers[dst_reg] = ~registers[src_reg];
       endcase

        pc = pc + 1;
        i = i+16;
    end


endmodule