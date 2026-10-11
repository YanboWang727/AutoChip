module lfsr (
    input clk,
    input reset_n,
    output [7:0] data
);

    reg [7:0] lfsr_reg;
    wire feedback;
    
    // Feedback from XOR of tap positions 1, 4, 6, and 7
    // For left-shift LFSR, feedback goes into bit 0
    assign feedback = lfsr_reg[7] ^ lfsr_reg[6] ^ lfsr_reg[4] ^ lfsr_reg[1];
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initial state: 10001010 (0x8A)
            lfsr_reg <= 8'b10001010;
        end else begin
            // Left shift with feedback into LSB
            lfsr_reg <= {lfsr_reg[6:0], feedback};
        end
    end
    
    // Output assignment
    assign data = lfsr_reg;

endmodule
