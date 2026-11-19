/*
Count seconds and minutes from 00:00 through 59:59. 
Advance only when enabled, reset both fields 
synchronously, and pulse alarm for one cycle when the count rolls over from 59:59 to 00:00.
*/

module top_module (
    input wire clk,
    input wire reset,
    input wire enable,
    output wire [5:0] seconds,
    output wire [5:0] minutes,
    output wire alarm
);
    reg [5:0] sec = {6{1'b0}};
    reg [5:0] min = {6{1'b0}};
    reg alarm_state = 1'b0;
    assign seconds = (sec);
    assign minutes = (min);
    assign alarm = alarm_state;
    always @(posedge clk) begin
        alarm_state <= 1'b0;
        if (reset == 1'b1) begin
            sec <= {6{1'b0}};
            min <= {6{1'b0}};
        end
        else if (enable == 1'b1) begin
            if (sec == 59) begin
                sec <= {6{1'b0}};
                if (min == 59) begin
                    min <= {6{1'b0}};
                    alarm_state <= 1'b1;
                end
                else begin
                    min <= min + 1;
                end
            end
            else begin
                sec <= sec + 1;
            end
        end
    end
endmodule
