module sequence_generator (
    input clk,
    input reset_n,
    input enable,
    output [7:0] data
);

    // State counter to track position in sequence
    reg [2:0] state;
    reg [7:0] data_reg;
    
    // Sequential logic for state counter
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 3'd0;
        end else if (enable) begin
            if (state == 3'd7)
                state <= 3'd0;
            else
                state <= state + 1'b1;
        end
    end
    
    // Combinational logic for sequence generation
    always @(*) begin
        case (state)
            3'd0: data_reg = 8'hAF;
            3'd1: data_reg = 8'hBC;
            3'd2: data_reg = 8'hE2;
            3'd3: data_reg = 8'h78;
            3'd4: data_reg = 8'hFF;
            3'd5: data_reg = 8'hE2;
            3'd6: data_reg = 8'h0B;
            3'd7: data_reg = 8'h8D;
            default: data_reg = 8'h00;
        endcase
    end
    
    assign data = data_reg;

endmodule
