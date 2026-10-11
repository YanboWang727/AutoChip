module lfsr (
    input clk,
    input reset_n,
    output [7:0] data
);

    reg [7:0] lfsr_reg;
    wire feedback;
    
    // Fibonacci LFSR: XOR taps at positions 1, 4, 6, and 7
    // These positions refer to the polynomial x^8 + x^7 + x^6 + x^4 + x^1 + 1
    assign feedback = lfsr_reg[7] ^ lfsr_reg[6] ^ lfsr_reg[4] ^ lfsr_reg[1];
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initial state: 10001010 (0x8A)
            lfsr_reg <= 8'b10001010;
        end else begin
            // Shift left with feedback to LSB
            lfsr_reg <= {lfsr_reg[6:0], feedback};
        end
    end
    
    // Output assignment
    assign data = lfsr_reg;

endmodule
