module sequence_generator (
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);

    // State counter to track position in sequence (0-7)
    reg [2:0] seq_index;
    
    // Define the sequence values
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            seq_index <= 3'd0;
            data <= 8'hAF;  // Initialize to first value
        end
        else if (enable) begin
            // Move to next state
            seq_index <= seq_index + 1'b1;
            
            // Output the appropriate value based on sequence index
            case (seq_index + 1'b1)  // Use next index value
                3'd0: data <= 8'hAF;
                3'd1: data <= 8'hBC;
                3'd2: data <= 8'hE2;
                3'd3: data <= 8'h78;
                3'd4: data <= 8'hFF;
                3'd5: data <= 8'hE2;
                3'd6: data <= 8'h0B;
                3'd7: data <= 8'h8D;
            endcase
        end
    end

endmodule
