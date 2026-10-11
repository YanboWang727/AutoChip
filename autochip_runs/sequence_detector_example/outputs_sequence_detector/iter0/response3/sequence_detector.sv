module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output sequence_found
);

    // State encoding for the 8-step sequence + initial state
    localparam IDLE  = 4'd0;
    localparam SEQ1  = 4'd1;  // Detected 0b001
    localparam SEQ2  = 4'd2;  // Detected 0b001, 0b101
    localparam SEQ3  = 4'd3;  // Detected 0b001, 0b101, 0b110
    localparam SEQ4  = 4'd4;  // Detected 0b001, 0b101, 0b110, 0b000
    localparam SEQ5  = 4'd5;  // Detected 0b001, 0b101, 0b110, 0b000, 0b110
    localparam SEQ6  = 4'd6;  // Detected 0b001, 0b101, 0b110, 0b000, 0b110, 0b110
    localparam SEQ7  = 4'd7;  // Detected 0b001, 0b101, 0b110, 0b000, 0b110, 0b110, 0b011
    localparam FOUND = 4'd8;  // Complete sequence detected
    
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
        next_state = IDLE;  // Default to IDLE on mismatch
        
        case (state)
            IDLE: begin
                if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            SEQ1: begin
                if (data == 3'b101)
                    next_state = SEQ2;
                else if (data == 3'b001)
                    next_state = SEQ1;  // Stay if we see first pattern again
                else
                    next_state = IDLE;
            end
            
            SEQ2: begin
                if (data == 3'b110)
                    next_state = SEQ3;
                else if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            SEQ3: begin
                if (data == 3'b000)
                    next_state = SEQ4;
                else if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            SEQ4: begin
                if (data == 3'b110)
                    next_state = SEQ5;
                else if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            SEQ5: begin
                if (data == 3'b110)
                    next_state = SEQ6;
                else if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            SEQ6: begin
                if (data == 3'b011)
                    next_state = SEQ7;
                else if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            SEQ7: begin
                if (data == 3'b101)
                    next_state = FOUND;
                else if (data == 3'b001)
                    next_state = SEQ1;
                else
                    next_state = IDLE;
            end
            
            FOUND: begin
                if (data == 3'b001)
                    next_state = SEQ1;  // Start looking for new sequence
                else
                    next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // Output logic
    assign sequence_found = (state == FOUND);

endmodule
