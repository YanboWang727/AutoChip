module lfsr (
    input clk,
    input reset_n,
    output [7:0] data
);

    reg [7:0] lfsr_reg;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initial state: 10001010 (0x8A)
            lfsr_reg <= 8'b10001010;
        end else begin
            // Galois LFSR implementation
            // Shift right and XOR feedback bit into tap positions
            lfsr_reg[7] <= lfsr_reg[0];
            lfsr_reg[6] <= lfsr_reg[7] ^ lfsr_reg[0];
            lfsr_reg[5] <= lfsr_reg[6];
            lfsr_reg[4] <= lfsr_reg[5] ^ lfsr_reg[0];
            lfsr_reg[3] <= lfsr_reg[4];
            lfsr_reg[2] <= lfsr_reg[3];
            lfsr_reg[1] <= lfsr_reg[2] ^ lfsr_reg[0];
            lfsr_reg[0] <= lfsr_reg[1];
        end
    end
    
    // Output assignment
    assign data = lfsr_reg;

endmodule
