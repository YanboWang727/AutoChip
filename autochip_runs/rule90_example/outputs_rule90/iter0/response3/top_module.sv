module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            next_q[0] = 1'b0 ^ q[1]; // Left of q[0] is assumed 0
            next_q[511] = q[510] ^ 1'b0; // Right of q[511] is assumed 0
            
            genvar i;
            for (i = 1; i < 511; i = i + 1) begin
                next_q[i] = q[i-1] ^ q[i+1];
            end
            
            q <= next_q;
        end
    end
endmodule
