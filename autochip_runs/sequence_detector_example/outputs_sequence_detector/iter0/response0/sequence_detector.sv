module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output sequence_found
);

    // State encoding for the 8-step sequence + idle state
    localparam IDLE = 4'd0;
    localparam S0   = 4'd1;  // Found 0b001
    localparam S1   = 4'd2;  // Found 0b001, 0b101
    localparam S2   = 4'd3;  // Found 0b001, 0b101, 0b110
    localparam S3   = 4'd4;  // Found 0b001, 0b101, 0b110, 0b000
    localparam S4   = 4'd5;  // Found 0b001, 0b101, 0b110, 0b000, 0b110
    localparam S5   = 4'd6;  // Found 0b001, 0b101, 0b110, 0b000, 0b110, 0b110
    localparam S6   = 4'd7;  // Found 0b001, 0b101, 0b110, 0b000, 0b110, 0b110, 0b011
    localparam FOUND = 4'd8; // Complete sequence found

    reg [3:0] state, next_state;

    // State register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = IDLE;  // Default to IDLE if no match
        
        case (state)
            IDLE: begin
                if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S0: begin
                if (data == 3'b101)
                    next_state = S1;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S1: begin
                if (data == 3'b110)
                    next_state = S2;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S2: begin
                if (data == 3'b000)
                    next_state = S3;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S3: begin
                if (data == 3'b110)
                    next_state = S4;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S4: begin
                if (data == 3'b110)
                    next_state = S5;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S5: begin
                if (data == 3'b011)
                    next_state = S6;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            S6: begin
                if (data == 3'b101)
                    next_state = FOUND;
                else if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            FOUND: begin
                if (data == 3'b001)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign sequence_found = (state == FOUND);

endmodule
