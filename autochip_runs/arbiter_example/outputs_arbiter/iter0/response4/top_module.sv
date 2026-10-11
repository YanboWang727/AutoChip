module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10
    } state_t;
    
    state_t state, next_state;

    // State Flip-Flop
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // State Transition Logic
    always_comb begin
        case(state)
            A: begin
                if (r[1])
                    next_state = B;
                else if (r[2])
                    next_state = C;    
                else
                    next_state = A;  // Stay in A
            end
            B: begin
                if (r[1])
                    next_state = B;  // Stay in B
                else
                    next_state = A;  // Go to A if r1 is not asserted
            end
            C: begin
                if (r[2])
                    next_state = C;  // Stay in C
                else
                    next_state = A;  // Go to A if r2 is not asserted
            end
            default: next_state = A; // Default case
        endcase
    end

    // Output Logic
    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn)
            g <= 3'b000;
        else begin
            case(state)
                A: g <= 3'b000; // No grants
                B: g <= 3'b100; // Grant to device 1
                C: g <= 3'b010; // Grant to device 2
                default: g <= 3'b000; // Default case
            endcase
        end
    end
endmodule
