module lfsr (
    input clk,
    input reset_n,
    output [7:0] data
);

    reg [7:0] lfsr_reg;
    wire feedback;
    
    // Feedback calculation using taps at positions 1, 4, 6, and 7
    // XOR the tap positions to generate feedback
    assign feedback = lfsr_reg[7] ^ lfsr_reg[6] ^ lfsr_reg[4] ^ lfsr_reg[1];
    
    // LFSR operation - shift left and insert feedback at LSB
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initial state: 10001010 (0x8A)
            lfsr_reg <= 8'b10001010;
        end else begin
            // Shift left and insert feedback at bit 0
            lfsr_reg <= {lfsr_reg[6:0], feedback};
        end
    end
    
    // Output assignment
    assign data = lfsr_reg;

endmodule
