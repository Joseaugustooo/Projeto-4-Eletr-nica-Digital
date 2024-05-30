module leds (
    input play, stop, clk,
    output reg [4:1] leds
);
    reg [1:0] states;
    localparam s0 = 2'b00;
    localparam s1 = 2'b01;
    localparam s2 = 2'b10;
    reg [4:1] l;
    
    always @(posedge clk) begin
        case(states)
            s0:
                if (play == 1'b1) begin
                    states <= s1;
                end
            s1:
                if (stop == 1'b1) begin
                    states <= s0;
                end
                else if (play == 1'b1) begin
                    states <= s2;
                end
            s2:
                if (stop == 1'b1) begin
                    states <= s0;
                end
                else if (play == 1'b1) begin
                    states <= s1;
                end
            default: l = 4'b0111;
        endcase
        
        case(states)
            s0:
                l = 4'b1110;
            s1:
                l = 4'b1101;
            s2:
                l = 4'b1011;
        endcase
    end

    always @(posedge clk) begin
        leds <= l;
    end
endmodule
