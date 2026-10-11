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
        C = 2'b10,
        D = 2'b11
    } state_t;
    
    state_t current_state, next_state;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn) 
            current_state <= A;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always @* begin
        case (current_state)
            A: begin
                if (r[1]) 
                    next_state = B;           // Grant to device 1
                else if (r[2]) 
                    next_state = C;           // Grant to device 2
                else if (r[3]) 
                    next_state = D;           // Grant to device 3
                else 
                    next_state = A;           // Stay in state A
            end
            B: begin
                if (r[1]) 
                    next_state = B;           // Stay in state B
                else 
                    next_state = A;           // Go back to A
            end
            C: begin
                if (r[2]) 
                    next_state = C;           // Stay in state C
                else 
                    next_state = A;           // Go back to A
            end
            D: begin
                if (r[3]) 
                    next_state = D;           // Stay in state D
                else 
                    next_state = A;           // Go back to A
            end
            default: next_state = A;           // Default to A
        endcase
    end

    // Output logic
    always @* begin
        g = 3'b000; // Default all grants to 0
        case (current_state)
            B: g[1] = 1; // Grant to device 1
            C: g[2] = 1; // Grant to device 2
            D: g[3] = 1; // Grant to device 3
            default: g = 3'b000; // Default
        endcase
    end

endmodule
