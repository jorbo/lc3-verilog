module cpu(input clk, input [SIZE-1:0] i_instructions);

    parameter SIZE = 80;
    reg [16:0] pc = 0;
    reg [127:0] registers;
    reg [15:0] curr_instr = 16'b0;
    reg [SIZE-1:0] instructions;
    reg [3:0] opcode;
    reg [2:0] src_reg;
    reg [2:0] src_reg2;
    reg [2:0] dst_reg;
    reg [4:0] imm_value;
    reg running = 1;
    integer i = 15;
    integer j;
    integer src_start = 0;
    integer dst_start = 0;
    integer src2_start = 0;
    initial begin
        assign instructions = i_instructions;   
        $display("%d", instructions);
        registers = 0;     
        imm_value = 0;
        j = 0;

    end
    

    always @(posedge clk && running == 1) begin   
        curr_instr = i_instructions[i-:16];
        // $display("PC: %3d INSTR: %b", pc, curr_instr);
        opcode = curr_instr[15:12];
        dst_reg = curr_instr[11:9];
        src_reg = curr_instr[8:6];
        if(opcode == 4'b1111) begin
            running = 0;
            $display("HALT");
        end
        case(dst_reg)
            3'b000: dst_start = 15;
            3'b001: dst_start = 31;
            3'b010: dst_start = 47;
            3'b011: dst_start = 63;
            3'b100: dst_start = 79;
            3'b101: dst_start = 95;
            3'b110: dst_start = 111;
            3'b111: dst_start = 127;
            default: dst_start = 0;
        endcase
        case(src_reg)
            3'b000: src_start = 15;
            3'b001: src_start = 31;
            3'b010: src_start = 47;
            3'b011: src_start = 63;
            3'b100: src_start = 79;
            3'b101: src_start = 95;
            3'b110: src_start = 111;
            3'b111: src_start = 127;
            default: src_start = 0;
        endcase
        // ADD
        if(opcode == 4'b0001)  begin
            // ADD IMMEDIATE
            if(curr_instr[5] == 1'b1) begin     
                imm_value = curr_instr[4:0];                
                $display("ADD r%-d r%-d #%-d", dst_reg, src_reg, imm_value);
                $display("DST: %-d SRC: %-d", registers[dst_start-:16], registers[src_start-:16]);
                registers[dst_start-:16] = registers[src_start-:16] + imm_value;
                $display("DST: %-d SRC: %-d", registers[dst_start-:16], registers[src_start-:16]);
                
            end
            if(curr_instr[5] != 1'b1) begin
                src_reg2 = curr_instr[2:0];
                case(src_reg2)
                    3'b000: src2_start = 15;
                    3'b001: src2_start = 31;
                    3'b010: src2_start = 47;
                    3'b011: src2_start = 63;
                    3'b100: src2_start = 79;
                    3'b101: src2_start = 95;
                    3'b110: src2_start = 111;
                    3'b111: src2_start = 127;
                    default: src2_start = 0;
                endcase
                $display("ADD r%-d r%-d r%-1d", dst_reg, src_reg, src_reg2);
                registers[dst_start-:16] = registers[src_start-:16] + registers[src2_start-:16];
                $display("DST: %-d SRC: %-d SRC2: %-d", registers[dst_start-:16], registers[src_start-:16], registers[src2_start-:16]);
            end                        
        end
        // AND
        if(opcode == 4'b0101)  begin
            //IMMEDIATE MODE
            if(curr_instr[5] == 1'b1) begin     
                imm_value = curr_instr[4:0];                
                $display("AND r%-d r%-d #%-d", dst_reg, src_reg, imm_value);
                $display("DST: %-d SRC: %-d", registers[dst_start-:16], registers[src_start-:16]);
                registers[dst_start-:16] = registers[src_start-:16] & imm_value;
                $display("DST: %-d SRC: %-d SRC2: %-d", registers[dst_start-:16], registers[src_start-:16], registers[src2_start-:16]);
                
            end
            if(curr_instr[5] != 1'b1) begin 
                src_reg2 = curr_instr[2:0];
                case(src_reg2)
                    3'b000: src2_start = 15;
                    3'b001: src2_start = 31;
                    3'b010: src2_start = 47;
                    3'b011: src2_start = 63;
                    3'b100: src2_start = 79;
                    3'b101: src2_start = 95;
                    3'b110: src2_start = 111;
                    3'b111: src2_start = 127;
                    default: src_start = 0;
                endcase
                $display("AND r%d r%d r%d", opcode, dst_reg, src_reg, src_reg2);
                registers[dst_start-:16] = registers[src_start-:16] & registers[src2_start-:16];
                $display("DST: %-d SRC: %-d SRC2: %-d", registers[dst_start-:16], registers[src_start-:16], registers[src_start-:16]);
            end                        
        end
        //NOT
        if(opcode == 4'b1001) begin
            registers[dst_start-:16] = ~registers[src_start-:16];
        end
        pc = pc +1;
        i = i+16;
    end


endmodule