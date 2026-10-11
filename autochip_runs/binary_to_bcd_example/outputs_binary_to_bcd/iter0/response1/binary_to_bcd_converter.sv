module binary_to_bcd_converter (
    input [4:0] binary_input,
    output [7:0] bcd_output
);

    reg [3:0] tens;
    reg [3:0] ones;
    
    always @(*) begin
        // For 5-bit input, maximum value is 31
        if (binary_input < 5'd10) begin
            tens = 4'd0;
            ones = binary_input[3:0];
        end
        else if (binary_input < 5'd20) begin
            tens = 4'd1;
            ones = binary_input - 5'd10;
        end
        else if (binary_input < 5'd30) begin
            tens = 4'd2;
            ones = binary_input - 5'd20;
        end
        else begin // binary_input >= 30 and <= 31
            tens = 4'd3;
            ones = binary_input - 5'd30;
        end
    end
    
    assign bcd_output = {tens, ones};

endmodule
