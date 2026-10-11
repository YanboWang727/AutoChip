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
    
    // State register
    reg [1:0] state, next_state;
    
    // Counter register
    reg [5:0] counter;  // 6 bits to count up to 32
    
    // State transition and counter logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RED;
            counter <= 6'd0;
        end else if (enable) begin
            if (counter == 6'd0) begin
                state <= next_state;
                counter <= 6'd1;
            end else begin
                counter <= counter + 1'd1;
            end
        end
    end
    
    // Next state logic with cycle counts
    always @(*) begin
        next_state = state;
        case (state)
            RED: begin
                if (counter == 6'd32)
                    next_state = GREEN;
            end
            GREEN: begin
                if (counter == 6'd20)
                    next_state = YELLOW;
            end
            YELLOW: begin
                if (counter == 6'd7)
                    next_state = RED;
            end
            default: begin
                next_state = RED;
            end
        endcase
    end
    
    // Output logic
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

endmodule
