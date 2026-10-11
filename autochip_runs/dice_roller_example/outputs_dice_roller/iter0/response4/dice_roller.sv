module dice_roller (
    input clk,
    input rst_n,
    input [1:0] die_select,
    input roll,
    output reg [7:0] rolled_number
);

    // LFSR for pseudo-random number generation
    reg [7:0] lfsr;
    wire feedback;
    
    // Edge detection for roll input
    reg roll_prev;
    wire roll_edge;
    
    // Feedback polynomial for 8-bit LFSR (maximal length)
    // Using taps at positions 8, 6, 5, 4 (x^8 + x^6 + x^5 + x^4 + 1)
    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];
    
    // Detect rising edge of roll signal
    assign roll_edge = roll && !roll_prev;
    
    // LFSR - runs continuously to generate pseudo-random values
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 8'b10101010; // Non-zero seed value
        end else begin
            lfsr <= {lfsr[6:0], feedback};
        end
    end
    
    // Roll edge detection register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            roll_prev <= 1'b0;
        end else begin
            roll_prev <= roll;
        end
    end
    
    // Dice rolling logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'd1;
        end else if (roll_edge) begin
            case (die_select)
                2'b00: begin // 4-sided die (D4)
                    rolled_number <= (lfsr % 4) + 1;
                end
                2'b01: begin // 6-sided die (D6)
                    rolled_number <= (lfsr % 6) + 1;
                end
                2'b10: begin // 8-sided die (D8)
                    rolled_number <= (lfsr % 8) + 1;
                end
                2'b11: begin // 20-sided die (D20)
                    rolled_number <= (lfsr % 20) + 1;
                end
            endcase
        end
    end

endmodule
