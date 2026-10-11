module sequence_generator (
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);

    // State counter to track position in sequence (0-7)
    reg [2:0] state;
    
    // Sequence generation logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset to first value in sequence
            state <= 3'b000;
            data <= 8'hAF;
        end
        else if (enable) begin
            // Increment state and update data based on current state
            state <= state + 1'b1;
            
            case (state)
                3'b000: data <= 8'hBC;  // Next value after AF
                3'b001: data <= 8'hE2;  // Next value after BC
                3'b010: data <= 8'h78;  // Next value after E2
                3'b011: data <= 8'hFF;  // Next value after 78
                3'b100: data <= 8'hE2;  // Next value after FF
                3'b101: data <= 8'h0B;  // Next value after E2
                3'b110: data <= 8'h8D;  // Next value after 0B
                3'b111: data <= 8'hAF;  // Next value after 8D (wrap around)
                default: data <= 8'hAF;
            endcase
        end
        // If enable is low, hold current value
    end

endmodule
