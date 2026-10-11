module lfsr (
    input clk,
    input reset_n,
    output [7:0] data
);

    reg [7:0] lfsr_reg;
    wire feedback;
    
    // Feedback calculation using taps at positions 1, 4, 6, and 7
    // For an 8-bit LFSR with taps at [7,6,4,1], the feedback is XOR of these positions
    assign feedback = lfsr_reg[7] ^ lfsr_reg[6] ^ lfsr_reg[4] ^ lfsr_reg[1];
    
    // LFSR shift register with feedback
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            lfsr_reg <= 8'b10001010;  // Initial state
        end else begin
            lfsr_reg <= {lfsr_reg[6:0], feedback};  // Shift left and insert feedback at LSB
        end
    end
    
    // Output assignment
    assign data = lfsr_reg;

endmodule
