module traffic_light_fsm (
    input clk,
    input reset_n,
    input enable,
    output red,
    output yellow,
    output green
);

    // State encoding
    localparam RED    = 2'b00;
    localparam GREEN  = 2'b01;
    localparam YELLOW = 2'b10;
    
    // State registers
    reg [1:0] current_state, next_state;
    
    // Counter for timing
    reg [5:0] counter;  // 6 bits to count up to 32
    
    // Counter thresholds
    localparam RED_CYCLES    = 6'd32;
    localparam GREEN_CYCLES  = 6'd20;
    localparam YELLOW_CYCLES = 6'd7;
    
    // State register with active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 6'd0;
        end else if (enable) begin
            current_state <= next_state;
            // Reset counter when state changes, otherwise increment
            if (current_state != next_state)
                counter <= 6'd0;
            else
                counter <= counter + 1'b1;
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = current_state;  // Default: stay in current state
        
        case (current_state)
            RED: begin
                if (counter >= RED_CYCLES - 1)
                    next_state = GREEN;
            end
            
            GREEN: begin
                if (counter >= GREEN_CYCLES - 1)
                    next_state = YELLOW;
            end
            
            YELLOW: begin
                if (counter >= YELLOW_CYCLES - 1)
                    next_state = RED;
            end
            
            default: begin
                next_state = RED;
            end
        endcase
    end
    
    // Output logic
    assign red    = (current_state == RED);
    assign green  = (current_state == GREEN);
    assign yellow = (current_state == YELLOW);

endmodule
