module cpu_8_bit (
    input clk,
    input reset_n
);

    // Registers
    reg [7:0] acc;
    reg [4:0] pc;
    reg [7:0] mem [0:31];
    
    // Pipeline stages
    reg [7:0] ir;  // Instruction register
    reg stage;     // 0 = fetch, 1 = execute
    
    // Decode signals
    wire [2:0] opcode;
    wire [4:0] mem_addr;
    wire [3:0] imm4;
    wire is_mem_op;
    wire is_addi;
    wire is_special;
    
    assign opcode = ir[7:5];
    assign mem_addr = ir[4:0];
    assign imm4 = ir[3:0];
    assign is_mem_op = (ir[7:5] != 3'b111);
    assign is_addi = (ir[7:4] == 4'b1110);
    assign is_special = (ir[7:4] == 4'b1111);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 5'h00;
            ir <= 8'hFF;  // HLT
            stage <= 1'b0;
        end else begin
            if (stage == 1'b0) begin
                // Fetch stage
                ir <= mem[pc];
                pc <= pc + 5'h01;
                stage <= 1'b1;
            end else begin
                // Execute stage
                stage <= 1'b0;
                
                if (is_mem_op) begin
                    case (opcode)
                        3'b000: acc <= mem[mem_addr];           // LDA
                        3'b001: mem[mem_addr] <= acc;           // STA
                        3'b010: acc <= acc + mem[mem_addr];     // ADD
                        3'b011: acc <= acc - mem[mem_addr];     // SUB
                        3'b100: acc <= acc & mem[mem_addr];     // AND
                        3'b101: acc <= acc | mem[mem_addr];     // OR
                        3'b110: acc <= acc ^ mem[mem_addr];     // XOR
                        default: acc <= acc;
                    endcase
                end else if (is_addi) begin
                    acc <= acc + {4'h0, imm4};                  // ADDI
                end else if (is_special) begin
                    case (ir[3:0])
                        4'h0: pc <= acc[4:0];                   // JMP
                        4'h1: begin                              // JSR
                            acc <= {3'b000, pc};
                            pc <= acc[4:0];
                        end
                        4'h2: if (acc == 8'h00) pc <= pc + 5'h02;  // BEQ_FWD
                        4'h3: if (acc == 8'h00) pc <= pc - 5'h03;  // BEQ_BWD
                        4'h4: if (acc != 8'h00) pc <= pc + 5'h02;  // BNE_FWD
                        4'h5: if (acc != 8'h00) pc <= pc - 5'h03;  // BNE_BWD
                        4'h6: acc <= {acc[6:0], 1'b0};          // SHL
                        4'h7: acc <= {1'b0, acc[7:1]};          // SHR
                        4'h8: acc <= {acc[3:0], 4'h0};          // SHL4
                        4'h9: acc <= {acc[6:0], acc[7]};        // ROL
                        4'hA: acc <= {acc[0], acc[7:1]};        // ROR
                        4'hB: acc <= mem[acc[4:0]];             // LDAR
                        4'hC: acc <= acc - 8'h01;               // DEC
                        4'hD: acc <= 8'h00;                     // CLR
                        4'hE: acc <= ~acc;                      // INV
                        4'hF: stage <= 1'b1;                    // HLT (stay in execute)
                        default: acc <= acc;
                    endcase
                end
            end
        end
    end

endmodule
