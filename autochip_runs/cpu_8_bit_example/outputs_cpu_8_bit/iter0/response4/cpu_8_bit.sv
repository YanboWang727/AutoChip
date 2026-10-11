module cpu_8_bit (
    input clk,
    input reset_n
);

    // Registers
    reg [7:0] acc;
    reg [4:0] pc;
    
    // Memory - 32 bytes shared instruction/data
    reg [7:0] mem [0:31];
    
    // Pipeline stage
    reg [7:0] ir;  // Instruction register
    reg stage;     // 0 = fetch, 1 = execute
    
    // Decode signals
    wire [2:0] opcode = ir[7:5];
    wire [4:0] address = ir[4:0];
    wire [3:0] immediate = ir[3:0];
    wire is_mem_op = (ir[7:5] != 3'b111);
    wire is_addi = (ir[7:4] == 4'b1110);
    wire is_single_byte = (ir[7:4] == 4'b1111);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc <= 8'd0;
            pc <= 5'd0;
            ir <= 8'd0;
            stage <= 1'b0;
        end else begin
            if (stage == 1'b0) begin
                // FETCH stage
                ir <= mem[pc];
                pc <= pc + 5'd1;
                stage <= 1'b1;
            end else begin
                // EXECUTE stage
                if (is_mem_op) begin
                    // Memory operations (3-bit opcode + 5-bit address)
                    case (opcode)
                        3'b000: acc <= mem[address];           // LDA
                        3'b001: mem[address] <= acc;           // STA
                        3'b010: acc <= acc + mem[address];     // ADD
                        3'b011: acc <= acc - mem[address];     // SUB
                        3'b100: acc <= acc & mem[address];     // AND
                        3'b101: acc <= acc | mem[address];     // OR
                        3'b110: acc <= acc ^ mem[address];     // XOR
                        default: acc <= acc;
                    endcase
                end else if (is_addi) begin
                    // ADDI - add 4-bit immediate
                    acc <= acc + {4'd0, immediate};
                end else if (is_single_byte) begin
                    // Single-byte instructions (0xFx)
                    case (ir[3:0])
                        4'h0: pc <= acc[4:0];                  // JMP
                        4'h1: begin                            // JSR
                            acc <= {3'd0, pc};
                            pc <= acc[4:0];
                        end
                        4'h2: if (acc == 8'd0) pc <= pc + 5'd2; // BEQ_FWD
                        4'h3: if (acc == 8'd0) pc <= pc - 5'd3; // BEQ_BWD
                        4'h4: if (acc != 8'd0) pc <= pc + 5'd2; // BNE_FWD
                        4'h5: if (acc != 8'd0) pc <= pc - 5'd3; // BNE_BWD
                        4'h6: acc <= {acc[6:0], 1'b0};         // SHL
                        4'h7: acc <= {1'b0, acc[7:1]};         // SHR
                        4'h8: acc <= {acc[3:0], 4'b0000};      // SHL4
                        4'h9: acc <= {acc[6:0], acc[7]};       // ROL
                        4'hA: acc <= {acc[0], acc[7:1]};       // ROR
                        4'hB: acc <= mem[acc[4:0]];            // LDAR
                        4'hC: acc <= acc - 8'd1;               // DEC
                        4'hD: acc <= 8'd0;                     // CLR
                        4'hE: acc <= ~acc;                     // INV
                        4'hF: pc <= pc - 5'd1;                 // HLT (stay at same instruction)
                        default: acc <= acc;
                    endcase
                end
                
                stage <= 1'b0;  // Return to fetch stage
            end
        end
    end

endmodule
