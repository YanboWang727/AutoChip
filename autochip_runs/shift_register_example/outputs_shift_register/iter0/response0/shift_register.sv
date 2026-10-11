module shift_register (
    input clk,
    input reset_n,
    input data_in,
    input shift_enable,
    output [7:0] data_out
);

    reg [7:0] shift_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 8'b0;
        end else if (shift_enable) begin
            shift_reg <= {shift_reg[6:0], data_in};
        end
    end

    assign data_out = shift_reg;

endmodule
