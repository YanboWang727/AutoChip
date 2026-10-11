module cpu_8_bit (
    input clk,
    input reset_n
);

    // Registers
    reg [7:0] acc;
    reg [4:0] pc;
    
    // Memory
    reg [7:0] mem [0:31];
    
    // Pipeline registers
    reg [7:0] instruction;
    reg fetch_stage;
    
    // Instruction decode
    wire [2:0] opcode = instruction[7:5];
    wire [4:0] address = instruction[4:0];
    wire [3:0] immediate = instruction[3:0];
    
    // Instruction type detection
    wire is_mem_op = (instruction[7:5] != 3'b111);
    wire is_addi = (instruction[7:4] == 4'b1110);
    wire is_single_byte = (instruction[7:4] == 4'b1111);
    
    // ALU operations
    reg [7:0] alu_result;
    reg [7:0] mem_data;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'h00;
            pc <= 5'h00;
            fetch_stage <= 1'b1;
            instruction <= 8'h00;
        end else begin
            if (fetch_stage) begin
                // Fetch stage
                instruction <= mem[pc];
                pc <= pc + 1'b1;
                fetch_stage <= 1'b0;
            end else begin
                // Execute stage
                mem_data = mem[address];
                
                if (is_mem_op && !is_addi) begin
                    // Memory operations (000-110)
                    case (opcode)
                        3'b000: acc <= mem_data;  // LDA
                        3'b001: mem[address] <= acc;  // STA
                        3'b010: acc <= acc + mem_data;  // ADD
                        3'b011: acc <= acc - mem_data;  // SUB
                        3'b100: acc <= acc & mem_data;  // AND
                        3'b101: acc <= acc | mem_data;  // OR
                        3'b110: acc <= acc ^ mem_data;  // XOR
                        default: acc <= acc;
                    endcase
                end else if (is_addi) begin
                    // ADDI instruction
                    acc <= acc + {4'b0000, immediate};
                end else if (is_single_byte) begin
                    // Single byte instructions (F0-FF)
                    case (instruction[3:0])
                        4'h0: pc <= acc[4:0];  // JMP
                        4'h1: begin  // JSR
                            mem_data = acc;
                            acc <= {3'b000, pc};
                            pc <= mem_data[4:0];
                        end
                        4'h2: if (acc == 8'h00) pc <= pc + 2'd2;  // BEQ_FWD
                        4'h3: if (acc == 8'h00) pc <= pc - 3'd3;  // BEQ_BWD
                        4'h4: if (acc != 8'h00) pc <= pc + 2'd2;  // BNE_FWD
                        4'h5: if (acc != 8'h00) pc <= pc - 3'd3;  // BNE_BWD
                        4'h6: acc <= {acc[6:0], 1'b0};  // SHL
                        4'h7: acc <= {1'b0, acc[7:1]};  // SHR
                        4'h8: acc <= {acc[3:0], 4'b0000};  // SHL4
                        4'h9: acc <= {acc[6:0], acc[7]};  // ROL
                        4'hA: acc <= {acc[0], acc[7:1]};  // ROR
                        4'hB: acc <= mem[acc[4:0]];  // LDAR
                        4'hC: acc <= acc - 1'b1;  // DEC
                        4'hD: acc <= 8'h00;  // CLR
                        4'hE: acc <= ~acc;  // INV
                        4'hF: pc <= pc - 1'b1;  // HLT - stay at current instruction
                        default: acc <= acc;
                    endcase
                end
                
                fetch_stage <= 1'b1;
            end
        end
    end

endmodule
