module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[1]) 
                    next_state = B; // Request from device 1
                else if (r[2]) 
                    next_state = C; // Request from device 2
                else if (r[3]) 
                    next_state = A; // Request from device 3 (low priority)
                else 
                    next_state = A; // Stay in A
            end
            B: begin
                if (r[1]) 
                    next_state = B; // Grant to device 1
                else 
                    next_state = A; // No request, go to A
            end
            C: begin
                if (r[2]) 
                    next_state = C; // Grant to device 2
                else 
                    next_state = A; // No request, go to A
            end
            default: next_state = A; // Default state
        endcase
    end

    // State register
    always @(posedge clk or negedge resetn) begin
        if (!resetn) 
            current_state <= A; // Reset to state A
        else 
            current_state <= next_state; // Update state
    end

    // Output logic
    always @(*) begin
        g = 3'b000; // Default output
        case (current_state)
            B: g[1] = 1; // Grant for device 1
            C: g[2] = 1; // Grant for device 2
            default: g[3] = 0; // Device 3 does not have a grant
        endcase
    end
endmodule
