module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            A: begin
                if (r[1]) next_state = B;         // Grant to device 1
                else if (r[2]) next_state = C;    // Grant to device 2
                else if (r[3]) next_state = A;    // Grant to device 3 (only if no higher priority)
                else next_state = A;               // Remain in A if no requests
            end
            B: begin
                if (r[1]) next_state = B;         // Stay in B if device 1 still requests
                else next_state = A;               // Return to A if no request
            end
            C: begin
                if (r[2]) next_state = C;         // Stay in C if device 2 still requests
                else next_state = A;               // Return to A if no request
            end
            default: next_state = A;            // Default to state A
        endcase
    end

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;                        // Reset to state A
        end else begin
            state <= next_state;               // Update state on clock edge
        end
    end

    // Output logic
    always @(*) begin
        g = 3'b000;                          // Default output
        case (state)
            B: g[1] = 1'b1;                   // Grant output for device 1
            C: g[2] = 1'b1;                   // Grant output for device 2
        endcase
    end
endmodule
