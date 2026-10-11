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
    
    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            RED: begin
                if (counter == 6'd31)
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            
            GREEN: begin
                if (counter == 6'd19)
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            
            YELLOW: begin
                if (counter == 6'd6)
                    next_state = RED;
                else
                    next_state = YELLOW;
            end
            
            default: next_state = RED;
        endcase
    end
    
    // State register and counter update (sequential)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 6'd0;
        end
        else if (enable) begin
            if (current_state != next_state) begin
                current_state <= next_state;
                counter <= 6'd0;
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end
    
    // Output logic
    assign red    = (current_state == RED);
    assign yellow = (current_state == YELLOW);
    assign green  = (current_state == GREEN);

endmodule
