module cpu_tb (   
);

reg clk;
reg [47:0] test_prog;
reg [3:0] count = 0;
reg [15:0] test_prog1 [4:0];
reg [79:0] temp;
integer fd = 0;
initial begin
    clk = 0;    
    test_prog[15:0] = 16'b0011000000000000;
    test_prog[31:16] = 16'b0001100100101010;
    test_prog[47:32] = 16'b1111000000100101;

    test_prog1[0] = 16'b0011000000000000;
    test_prog1[1] = 16'b0001100100101010;
    test_prog1[2] = 16'b0001011011101000;
    test_prog1[3] = 16'b0001011100000100;
    test_prog1[4] = 16'b1111000000100101;    
    // $readmemb("add.bin", test_prog1);
    //$display("%b", test_prog1);
end

always begin : main_block
    #5 clk = ~clk;
end
    

cpu #(.SIZE(5)) cpu_uut(clk, test_prog1);


endmodule