`timescale 1ns/1ps

module tb; 

    reg clk;
    reg reset_n;

    integer mismatches = 0; 
    integer samples = 0;

    cpu_8_bit dut(
        .clk(clk),
        .reset_n(reset_n)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer k;
    task reset;
    begin
        reset_n = 0;
        for (k = 0; k < 32; k = k + 1)
            dut.mem[k] = 8'b0000_0000;
        @(negedge clk);
        reset_n = 1;
    end
    endtask

    task run_instruction;
    begin
        @(posedge clk);
        @(posedge clk);
        #1;
    end
    endtask

    task check_acc;
        input [7:0] expected_val;
    begin
        samples = samples + 1; 
        if(expected_val === dut.acc)
            $display("PASS, ACC = %h", dut.acc);
        else begin
            mismatches = mismatches + 1; 
            $display("NOT PASS, ACC = %h, expected result = %h", dut.acc, expected_val);
        end
    end
    endtask

    task check_mem;
        input [4:0] address;
        input [7:0] expected_val;
    begin
        samples = samples + 1;
        if(expected_val === dut.mem[address])
            $display("PASS, MEM[%d] = %h", address, dut.mem[address]);
        else begin
            mismatches = mismatches + 1;
            $display("NOT PASS, MEM[%d] = %h, expected result = %h", address, dut.mem[address], expected_val);
        end
    end
    endtask

    task check_pc;
        input [4:0] expected_val;
    begin
        samples = samples + 1;
        if(expected_val === dut.pc)
            $display("PASS, PC = %d", dut.pc);
        else begin
            mismatches = mismatches + 1;
            $display("NOT PASS, PC = %d, expected result = %d", dut.pc, expected_val);
        end
    end
    endtask

    initial begin

        //ADDI
        reset();
        dut.mem[0] = 8'b1110_0101;
        run_instruction();
        $display("ADDI Test:");
        check_acc(8'b0000_0101);

        //LDA
        reset();
        dut.mem[0] = 8'b000_01010;
        dut.mem[10] = 8'b0000_0001;
        run_instruction();
        $display("LDA Test:");
        check_acc(8'b0000_0001);

        //STA
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b001_01010;
        run_instruction();
        run_instruction();
        $display("STA Test:");
        check_mem(5'd10, 8'b0000_0101);

        //ADD
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b010_01010;
        dut.mem[10] = 8'b0000_0011;
        run_instruction();
        run_instruction();
        $display("ADD Test:");
        check_acc(8'b0000_1000);

        //SUB
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b011_01010;
        dut.mem[10] = 8'b0000_0011;
        run_instruction();
        run_instruction();
        $display("SUB Test:");
        check_acc(8'b0000_0010);

        //AND
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b100_01010;
        dut.mem[10] = 8'b0000_0011;
        run_instruction();
        run_instruction();
        $display("AND Test:");
        check_acc(8'b0000_0001);

        //OR
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b101_01010;
        dut.mem[10] = 8'b0000_0011;
        run_instruction();
        run_instruction();
        $display("OR Test:");
        check_acc(8'b0000_0111);

        //XOR
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b110_01010;
        dut.mem[10] = 8'b0000_0011;
        run_instruction();
        run_instruction();
        $display("XOR Test:");
        check_acc(8'b0000_0110);

        //JMP
        reset();
        dut.mem[0] = 8'b1110_1010;
        dut.mem[1] = 8'b1111_0000;
        run_instruction();
        run_instruction();
        $display("JMP Test:");
        check_pc(5'd10);

        //JSR
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b1111_0001;
        run_instruction();
        run_instruction();
        $display("JSR Test:");
        check_acc(8'd2);
        check_pc(5'd5);

        //BEQ_FWD
        reset();
        dut.mem[0] = 8'b1111_1101;
        dut.mem[1] = 8'b1111_0010;
        run_instruction();
        run_instruction();
        $display("BEQ_FWD Test:");
        check_pc(5'd4);

        //BEQ_BWD
        reset();
        dut.mem[0] = 8'b1111_1101;
        dut.mem[1] = 8'b1110_0001;
        dut.mem[2] = 8'b1111_1101;
        dut.mem[3] = 8'b1111_0011;
        run_instruction();
        run_instruction();
        run_instruction();
        run_instruction();
        $display("BEQ_BWD Test:");
        check_pc(5'd1);

        //BNE_FWD
        reset();
        dut.mem[0] = 8'b1110_0001;
        dut.mem[1] = 8'b1111_0100;
        run_instruction();
        run_instruction();
        $display("BNE_FWD Test:");
        check_pc(5'd4);

        //BNE_BWD
        reset();
        dut.mem[0] = 8'b1110_0001;
        dut.mem[1] = 8'b1110_0001;
        dut.mem[2] = 8'b1110_0001;
        dut.mem[3] = 8'b1111_0101;
        run_instruction();
        run_instruction();
        run_instruction();
        run_instruction();
        $display("BNE_BWD Test:");
        check_pc(5'd1);

        //SHL
        reset();
        dut.mem[0] = 8'b1110_0011;
        dut.mem[1] = 8'b1111_0110;
        run_instruction();
        run_instruction();
        $display("SHL Test:");
        check_acc(8'b0000_0110);

        //SHR
        reset();
        dut.mem[0] = 8'b1110_1000;
        dut.mem[1] = 8'b1111_0111;
        run_instruction();
        run_instruction();
        $display("SHR Test:");
        check_acc(8'b0000_0100);

        //SHL4
        reset();
        dut.mem[0] = 8'b1110_0011;
        dut.mem[1] = 8'b1111_1000;
        run_instruction();
        run_instruction();
        $display("SHL4 Test:");
        check_acc(8'b0011_0000);

        //ROL
        reset();
        dut.mem[0] = 8'b000_01010;
        dut.mem[1] = 8'b1111_1001;
        dut.mem[10] = 8'b1000_0001;
        run_instruction();
        run_instruction();
        $display("ROL Test:");
        check_acc(8'b0000_0011);

        //ROR
        reset();
        dut.mem[0] = 8'b000_01010;
        dut.mem[1] = 8'b1111_1010;
        dut.mem[10] = 8'b1000_0001;
        run_instruction();
        run_instruction();
        $display("ROR Test:");
        check_acc(8'b1100_0000);

        //LDAR
        reset();
        dut.mem[0] = 8'b1110_1010;
        dut.mem[1] = 8'b1111_1011;
        dut.mem[10] = 8'b1010_1010;
        run_instruction();
        run_instruction();
        $display("LDAR Test:");
        check_acc(8'b1010_1010);

        //DEC
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b1111_1100;
        run_instruction();
        run_instruction();
        $display("DEC Test:");
        check_acc(8'b0000_0100);

        //CLR
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b1111_1101;
        run_instruction();
        run_instruction();
        $display("CLR Test:");
        check_acc(8'b0000_0000);

        //INV
        reset();
        dut.mem[0] = 8'b1110_0101;
        dut.mem[1] = 8'b1111_1110;
        run_instruction();
        run_instruction();
        $display("INV Test:");
        check_acc(8'b1111_1010);

        //HLT
        reset();
        dut.mem[0] = 8'b1111_1111;
        run_instruction();
        $display("HLT Test:");

        $display("Mismatches: %0d in %0d samples", mismatches, samples);
        $finish(0);
    end

endmodule