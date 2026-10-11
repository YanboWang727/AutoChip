module binary_to_bcd_converter (
    input [4:0] binary_input,
    output [7:0] bcd_output
);

    reg [3:0] tens;
    reg [3:0] ones;
    
    always @(*) begin
        // Handle all possible 5-bit binary values (0-31)
        case (binary_input)
            5'd0:  begin tens = 4'd0; ones = 4'd0; end
            5'd1:  begin tens = 4'd0; ones = 4'd1; end
            5'd2:  begin tens = 4'd0; ones = 4'd2; end
            5'd3:  begin tens = 4'd0; ones = 4'd3; end
            5'd4:  begin tens = 4'd0; ones = 4'd4; end
            5'd5:  begin tens = 4'd0; ones = 4'd5; end
            5'd6:  begin tens = 4'd0; ones = 4'd6; end
            5'd7:  begin tens = 4'd0; ones = 4'd7; end
            5'd8:  begin tens = 4'd0; ones = 4'd8; end
            5'd9:  begin tens = 4'd0; ones = 4'd9; end
            5'd10: begin tens = 4'd1; ones = 4'd0; end
            5'd11: begin tens = 4'd1; ones = 4'd1; end
            5'd12: begin tens = 4'd1; ones = 4'd2; end
            5'd13: begin tens = 4'd1; ones = 4'd3; end
            5'd14: begin tens = 4'd1; ones = 4'd4; end
            5'd15: begin tens = 4'd1; ones = 4'd5; end
            5'd16: begin tens = 4'd1; ones = 4'd6; end
            5'd17: begin tens = 4'd1; ones = 4'd7; end
            5'd18: begin tens = 4'd1; ones = 4'd8; end
            5'd19: begin tens = 4'd1; ones = 4'd9; end
            5'd20: begin tens = 4'd2; ones = 4'd0; end
            5'd21: begin tens = 4'd2; ones = 4'd1; end
            5'd22: begin tens = 4'd2; ones = 4'd2; end
            5'd23: begin tens = 4'd2; ones = 4'd3; end
            5'd24: begin tens = 4'd2; ones = 4'd4; end
            5'd25: begin tens = 4'd2; ones = 4'd5; end
            5'd26: begin tens = 4'd2; ones = 4'd6; end
            5'd27: begin tens = 4'd2; ones = 4'd7; end
            5'd28: begin tens = 4'd2; ones = 4'd8; end
            5'd29: begin tens = 4'd2; ones = 4'd9; end
            5'd30: begin tens = 4'd3; ones = 4'd0; end
            5'd31: begin tens = 4'd3; ones = 4'd1; end
            default: begin tens = 4'd0; ones = 4'd0; end
        endcase
    end
    
    assign bcd_output = {tens, ones};

endmodule
