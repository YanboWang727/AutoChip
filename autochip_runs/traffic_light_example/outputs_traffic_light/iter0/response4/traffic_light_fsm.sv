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
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    // Counter for timing
    reg [5:0] counter;  // 6 bits to count up to 32
    
    // State transition logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 6'd0;
        end else if (enable) begin
            if (counter == 6'd0) begin
                current_state <= next_state;
            end
            
            // Counter logic
            case (current_state)
                RED: begin
                    if (counter == 6'd31) begin
                        counter <= 6'd0;
                    end else begin
                        counter <= counter + 1'b1;
                    end
                end
                GREEN: begin
                    if (counter == 6'd19) begin
                        counter <= 6'd0;
                    end else begin
                        counter <= counter + 1'b1;
                    end
                end
                YELLOW: begin
                    if (counter == 6'd6) begin
                        counter <= 6'd0;
                    end else begin
                        counter <= counter + 1'b1;
                    end
                end
                default: begin
                    counter <= 6'd0;
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            RED: begin
                if (counter == 6'd31)
                    next_state = GREEN;
            end
            GREEN: begin
                if (counter == 6'd19)
                    next_state = YELLOW;
            end
            YELLOW: begin
                if (counter == 6'd6)
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
