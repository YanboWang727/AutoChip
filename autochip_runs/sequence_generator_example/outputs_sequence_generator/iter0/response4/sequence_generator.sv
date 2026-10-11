module sequence_generator (
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);

    // State counter to track position in sequence
    reg [2:0] state;
    
    // Define the sequence length
    localparam SEQ_LENGTH = 8;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 3'd0;
            data <= 8'hAF;  // Initialize to first value
        end
        else if (enable) begin
            // Move to next state
            if (state == SEQ_LENGTH - 1)
                state <= 3'd0;
            else
                state <= state + 1'b1;
            
            // Generate output based on state
            case (state)
                3'd0: data <= 8'hAF;
                3'd1: data <= 8'hBC;
                3'd2: data <= 8'hE2;
                3'd3: data <= 8'h78;
                3'd4: data <= 8'hFF;
                3'd5: data <= 8'hE2;
                3'd6: data <= 8'h0B;
                3'd7: data <= 8'h8D;
                default: data <= 8'hAF;
            endcase
        end
        // If not enabled, hold current value
    end

endmodule
