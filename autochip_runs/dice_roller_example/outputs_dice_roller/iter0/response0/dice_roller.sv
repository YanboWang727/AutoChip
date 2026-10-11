module dice_roller (
    input clk,
    input rst_n,
    input [1:0] die_select,
    input roll,
    output reg [7:0] rolled_number
);

    // Internal LFSR for pseudo-random number generation
    reg [7:0] lfsr;
    
    // Edge detection for roll signal
    reg roll_prev;
    wire roll_edge;
    
    assign roll_edge = roll && !roll_prev;
    
    // LFSR update and roll previous register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 8'b10101010; // Non-zero seed value
            roll_prev <= 1'b0;
        end else begin
            // Update LFSR every cycle for pseudo-randomness
            // Using polynomial x^8 + x^6 + x^5 + x^4 + 1
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
            
            // Store previous roll state for edge detection
            roll_prev <= roll;
        end
    end
    
    // Dice rolling logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'd1;
        end else if (roll_edge) begin
            case (die_select)
                2'b00: begin // 4-sided die (1-4)
                    rolled_number <= (lfsr % 4) + 1;
                end
                2'b01: begin // 6-sided die (1-6)
                    rolled_number <= (lfsr % 6) + 1;
                end
                2'b10: begin // 8-sided die (1-8)
                    rolled_number <= (lfsr % 8) + 1;
                end
                2'b11: begin // 20-sided die (1-20)
                    rolled_number <= (lfsr % 20) + 1;
                end
            endcase
        end
    end

endmodule
