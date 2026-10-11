module cpu_8_bit (
    input clk,
    input reset_n
);

    // Registers
    reg [7:0] acc;
    reg [4:0] pc;
    
    // Memory
    reg [7:0] mem [0:31];
    
    // Pipeline state
    reg stage;  // 0 = fetch, 1 = execute
    reg [7:0] ir;  // Instruction register
    
    // Instruction decode
    wire [2:0] opcode = ir[7:5];
    wire [4:0] address = ir[4:0];
    wire [3:0] imm4 = ir[3:0];
    
    // Instruction categories
    wire is_mem_op = (opcode != 3'b111);
    wire is_addi = (ir[7:4] == 4'b1110);
    wire is_single_byte = (ir[7:4] == 4'b1111);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 5'h00;
            stage <= 1'b0;
            ir <= 8'h00;
        end else begin
            if (stage == 1'b0) begin
                // Fetch stage
                ir <= mem[pc];
                pc <= pc + 1'b1;
                stage <= 1'b1;
            end else begin
                // Execute stage
                case (1'b1)
                    is_mem_op: begin
                        case (opcode)
                            3'b000: acc <= mem[address];  // LDA
                            3'b001: mem[address] <= acc;  // STA
                            3'b010: acc <= acc + mem[address];  // ADD
                            3'b011: acc <= acc - mem[address];  // SUB
                            3'b100: acc <= acc & mem[address];  // AND
                            3'b101: acc <= acc | mem[address];  // OR
                            3'b110: acc <= acc ^ mem[address];  // XOR
                            default: ;
                        endcase
                    end
                    is_addi: begin
                        acc <= acc + {4'b0, imm4};  // ADDI
                    end
                    is_single_byte: begin
                        case (ir)
                            8'hF0: pc <= acc[4:0];  // JMP
                            8'hF1: begin  // JSR
                                acc <= {3'b000, pc};
                                pc <= acc[4:0];
                            end
                            8'hF2: if (acc == 8'h00) pc <= pc + 2'd2;  // BEQ_FWD
                            8'hF3: if (acc == 8'h00) pc <= pc - 3'd3;  // BEQ_BWD
                            8'hF4: if (acc != 8'h00) pc <= pc + 2'd2;  // BNE_FWD
                            8'hF5: if (acc != 8'h00) pc <= pc - 3'd3;  // BNE_BWD
                            8'hF6: acc <= {acc[6:0], 1'b0};  // SHL
                            8'hF7: acc <= {1'b0, acc[7:1]};  // SHR
                            8'hF8: acc <= {acc[3:0], 4'b0000};  // SHL4
                            8'hF9: acc <= {acc[6:0], acc[7]};  // ROL
                            8'hFA: acc <= {acc[0], acc[7:1]};  // ROR
                            8'hFB: acc <= mem[acc[4:0]];  // LDAR
                            8'hFC: acc <= acc - 1'b1;  // DEC
                            8'hFD: acc <= 8'h00;  // CLR
                            8'hFE: acc <= ~acc;  // INV
                            8'hFF: pc <= pc - 1'b1;  // HLT - stay at current PC
                            default: ;
                        endcase
                    end
                endcase
                stage <= 1'b0;
            end
        end
    end

endmodule
