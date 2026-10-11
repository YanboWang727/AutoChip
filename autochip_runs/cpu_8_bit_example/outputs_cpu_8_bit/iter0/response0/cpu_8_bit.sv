module cpu_8_bit (
    input clk,
    input reset_n
);

    // Registers
    reg [7:0] acc;
    reg [4:0] pc;
    reg [7:0] mem [0:31];
    
    // Internal signals
    reg [7:0] instr;
    reg stage;  // 0 = fetch, 1 = execute
    
    // Instruction decode
    wire [2:0] opcode = instr[7:5];
    wire [4:0] addr = instr[4:0];
    wire [3:0] imm4 = instr[3:0];
    wire is_mem_op = (opcode != 3'b111);
    wire is_addi = (instr[7:4] == 4'b1110);
    wire is_special = (instr[7:4] == 4'b1111);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 5'h00;
            stage <= 1'b0;
            instr <= 8'h00;
        end else begin
            if (stage == 1'b0) begin
                // Fetch stage
                instr <= mem[pc];
                pc <= pc + 5'd1;
                stage <= 1'b1;
            end else begin
                // Execute stage
                stage <= 1'b0;
                
                if (is_mem_op && !is_addi) begin
                    case (opcode)
                        3'b000: acc <= mem[addr];              // LDA
                        3'b001: mem[addr] <= acc;              // STA
                        3'b010: acc <= acc + mem[addr];        // ADD
                        3'b011: acc <= acc - mem[addr];        // SUB
                        3'b100: acc <= acc & mem[addr];        // AND
                        3'b101: acc <= acc | mem[addr];        // OR
                        3'b110: acc <= acc ^ mem[addr];        // XOR
                        default: ;
                    endcase
                end else if (is_addi) begin
                    acc <= acc + {4'b0000, imm4};              // ADDI
                end else if (is_special) begin
                    case (instr[3:0])
                        4'h0: pc <= acc[4:0];                  // JMP
                        4'h1: begin                            // JSR
                            acc <= {3'b000, pc};
                            pc <= acc[4:0];
                        end
                        4'h2: if (acc == 8'h00) pc <= pc + 5'd2;  // BEQ_FWD
                        4'h3: if (acc == 8'h00) pc <= pc - 5'd3;  // BEQ_BWD
                        4'h4: if (acc != 8'h00) pc <= pc + 5'd2;  // BNE_FWD
                        4'h5: if (acc != 8'h00) pc <= pc - 5'd3;  // BNE_BWD
                        4'h6: acc <= {acc[6:0], 1'b0};         // SHL
                        4'h7: acc <= {1'b0, acc[7:1]};         // SHR
                        4'h8: acc <= {acc[3:0], 4'b0000};      // SHL4
                        4'h9: acc <= {acc[6:0], acc[7]};       // ROL
                        4'hA: acc <= {acc[0], acc[7:1]};       // ROR
                        4'hB: acc <= mem[acc[4:0]];            // LDAR
                        4'hC: acc <= acc - 8'd1;               // DEC
                        4'hD: acc <= 8'h00;                    // CLR
                        4'hE: acc <= ~acc;                     // INV
                        4'hF: stage <= 1'b1;                   // HLT (stay in execute)
                        default: ;
                    endcase
                end
            end
        end
    end

endmodule
