module traffic_light_fsm (
    input clk,
    input reset_n,
    input enable,
    output red,
    output yellow,
    output green
);

    // State encoding
    localparam STATE_RED    = 2'b00;
    localparam STATE_GREEN  = 2'b01;
    localparam STATE_YELLOW = 2'b10;
    
    // Counter parameters
    localparam RED_CYCLES    = 32;
    localparam GREEN_CYCLES  = 20;
    localparam YELLOW_CYCLES = 7;
    
    // State registers
    reg [1:0] current_state, next_state;
    reg [5:0] counter;  // 6 bits to count up to 32
    
    // State transition logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= STATE_RED;
            counter <= 6'd0;
        end else if (enable) begin
            if (counter == 6'd0) begin
                current_state <= next_state;
            end else begin
                current_state <= current_state;
            end
            counter <= counter + 1'b1;
        end
    end
    
    // Next state logic with counter
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            STATE_RED: begin
                if (counter == RED_CYCLES - 1)
                    next_state = STATE_GREEN;
            end
            
            STATE_GREEN: begin
                if (counter == GREEN_CYCLES - 1)
                    next_state = STATE_YELLOW;
            end
            
            STATE_YELLOW: begin
                if (counter == YELLOW_CYCLES - 1)
                    next_state = STATE_RED;
            end
            
            default: begin
                next_state = STATE_RED;
            end
        endcase
    end
    
    // Counter control logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 6'd0;
        end else if (enable) begin
            case (current_state)
                STATE_RED: begin
                    if (counter == RED_CYCLES - 1)
                        counter <= 6'd0;
                    else
                        counter <= counter + 1'b1;
                end
                
                STATE_GREEN: begin
                    if (counter == GREEN_CYCLES - 1)
                        counter <= 6'd0;
                    else
                        counter <= counter + 1'b1;
                end
                
                STATE_YELLOW: begin
                    if (counter == YELLOW_CYCLES - 1)
                        counter <= 6'd0;
                    else
                        counter <= counter + 1'b1;
                end
                
                default: begin
                    counter <= 6'd0;
                end
            endcase
        end
    end
    
    // Output logic
    assign red    = (current_state == STATE_RED);
    assign green  = (current_state == STATE_GREEN);
    assign yellow = (current_state == STATE_YELLOW);

endmodule
