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
    localparam A_SET = 4'b0010;
    localparam B_SET = 4'b0100;
    localparam DONE  = 4'b1000;
    
    // State register
    reg [3:0] current_state;
    reg [3:0] next_state;
    
    // Output assignment
    assign State = current_state;
    assign O = (current_state == DONE);
    
    // State register with active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = current_state; // Default to stay in current state
        
        case (current_state)
            IDLE: begin
                if (A && B) begin
                    next_state = DONE;
                end else if (A) begin
                    next_state = A_SET;
                end else if (B) begin
                    next_state = B_SET;
                end
            end
            
            A_SET: begin
                if (B) begin
                    next_state = DONE;
                end
            end
            
            B_SET: begin
                if (A) begin
                    next_state = DONE;
                end
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
