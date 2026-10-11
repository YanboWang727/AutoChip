module abro_state_machine (
    input clk,
    input rst_n,
    input A,
    input B,
    output O,
    output [3:0] State
);

    // One-hot encoded state definitions
    localparam IDLE  = 4'b0001;
    localparam GOT_A = 4'b0010;
    localparam GOT_B = 4'b0100;
    localparam DONE  = 4'b1000;

    // State register
    reg [3:0] current_state;
    reg [3:0] next_state;

    // Output State to verify current state
    assign State = current_state;

    // State register with active-low asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = current_state; // Default: stay in current state
        
        case (current_state)
            IDLE: begin
                if (A && B)
                    next_state = DONE;
                else if (A)
                    next_state = GOT_A;
                else if (B)
                    next_state = GOT_B;
                else
                    next_state = IDLE;
            end
            
            GOT_A: begin
                if (B)
                    next_state = DONE;
                else
                    next_state = GOT_A;
            end
            
            GOT_B: begin
                if (A)
                    next_state = DONE;
                else
                    next_state = GOT_B;
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    assign O = (current_state == DONE);

endmodule
