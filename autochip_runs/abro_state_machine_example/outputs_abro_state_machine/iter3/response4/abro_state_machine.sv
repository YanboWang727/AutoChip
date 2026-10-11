module abro_state_machine (
    input clk,
    input rst_n,
    input A,
    input B,
    output O,
    output [3:0] State
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001;
    localparam GOT_A  = 4'b0010;
    localparam GOT_B  = 4'b1000;
    localparam GOT_AB = 4'b0100;  // DONE state - both A and B seen

    reg [3:0] current_state, next_state;

    // State register with active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;  // Default to hold current state
        
        case (current_state)
            IDLE: begin
                if (A && B)
                    next_state = GOT_AB;
                else if (A)
                    next_state = GOT_A;
                else if (B)
                    next_state = GOT_B;
                else
                    next_state = IDLE;
            end
            
            GOT_A: begin
                if (B)
                    next_state = GOT_AB;
                else
                    next_state = GOT_A;  // Stay in GOT_A until B arrives
            end
            
            GOT_B: begin
                if (A)
                    next_state = GOT_AB;
                else
                    next_state = GOT_B;  // Stay in GOT_B until A arrives
            end
            
            GOT_AB: begin
                // Return to IDLE after asserting output
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic - O is high when both A and B have been seen
    assign O = (current_state == GOT_AB);
    assign State = current_state;

endmodule
