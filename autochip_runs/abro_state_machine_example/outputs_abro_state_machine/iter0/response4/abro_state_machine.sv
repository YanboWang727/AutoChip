module abro_state_machine (
    input clk,
    input rst_n,
    input A,
    input B,
    output O,
    output [3:0] State
);

    // One-hot encoded state definitions
    localparam S_IDLE  = 4'b0001;
    localparam S_A     = 4'b0010;
    localparam S_B     = 4'b0100;
    localparam S_DONE  = 4'b1000;

    // State register
    reg [3:0] current_state;
    reg [3:0] next_state;

    // State register - sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic - combinational
    always @(*) begin
        next_state = current_state; // Default: stay in current state
        
        case (current_state)
            S_IDLE: begin
                if (A && B)
                    next_state = S_DONE;
                else if (A)
                    next_state = S_A;
                else if (B)
                    next_state = S_B;
                else
                    next_state = S_IDLE;
            end
            
            S_A: begin
                if (B)
                    next_state = S_DONE;
                else
                    next_state = S_A;
            end
            
            S_B: begin
                if (A)
                    next_state = S_DONE;
                else
                    next_state = S_B;
            end
            
            S_DONE: begin
                next_state = S_IDLE;
            end
            
            default: begin
                next_state = S_IDLE;
            end
        endcase
    end

    // Output logic
    assign O = (current_state == S_DONE);
    assign State = current_state;

endmodule
