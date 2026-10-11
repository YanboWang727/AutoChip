module lfsr (
    input clk,
    input reset_n,
    output [7:0] data
);

    reg [7:0] lfsr_reg;
    wire feedback;
    
    // Feedback calculation using taps at positions 1, 4, 6, and 7
    // LFSR bits are indexed 7:0, so we XOR bits at positions 1, 4, 6, and 7
    assign feedback = lfsr_reg[7] ^ lfsr_reg[6] ^ lfsr_reg[4] ^ lfsr_reg[1];
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initial state: 10001010
            lfsr_reg <= 8'b10001010;
        end else begin
            // Shift left and insert feedback at LSB
            lfsr_reg <= {lfsr_reg[6:0], feedback};
        end
    end
    
    // Output the current LFSR state
    assign data = lfsr_reg;

endmodule
