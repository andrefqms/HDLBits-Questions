module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    reg [3:0]	ones;
    reg [3:0]	tens;
    reg [3:0]	hundreds;
    reg [3:0]	thousands;
    
    always@(posedge clk)begin
        if(reset)begin
            ones <= 4'd0;
        end
        else if(ones == 4'd9)begin
            ones <= 4'd0;
        end
        else begin
            ones <= ones + 1'b1;
        end
    end
    
    always@(posedge clk)begin
        if(reset)begin
            tens <= 4'd0;
        end
        else if(tens == 4'd9&&ones == 4'd9)begin
            tens <= 4'd0;
        end
        else if(ones == 4'd9)begin
            tens <= tens + 1'b1;
        end
    end
    
    always@(posedge clk)begin
        if(reset)begin
            hundreds <= 4'd0;
        end
        else if(hundreds == 4'd9&&tens == 4'd9&&ones == 4'd9)begin
            hundreds <= 4'd0;
        end
        else if(tens == 4'd9&&ones == 4'd9)begin
            hundreds <= hundreds + 1'b1;
        end
    end
    
    always@(posedge clk)begin
        if(reset)begin
            thousands <= 4'd0;
        end
        else if(thousands == 4'd9&&hundreds == 4'd9&&tens == 4'd9&&ones == 4'd9)begin
            thousands <= 4'd0;
        end
        else if(hundreds == 4'd9&&tens == 4'd9&&ones == 4'd9)begin
            threate a set of counters suitable for use as a 12-hour clock (with am/pm indicator). Your counters are clocked by a fast-running clk, with a pulse on ena whenever your clock should increment (i.e., once per second).

reset resets the clock to 12:00 AM. pm is 0 for AM and 1 for PM. hh, mm, and ss are two BCD (Binary-Coded Decimal) digits each for hours (01-12), minutes (00-59), and seconds (00-59). Reset has higher priority than enable, and can occur even when not enabled.

The following timing diagram shows the rollover behaviour from 11:59:59 AM to 12:00:00 PM and the synchronous reset and enable behaviour.

clkresetenapmhh[7:0]8'h118'h12mm[7:0]8'h598'h00ss[7:0]8'h578'h588'h598'h008'h018'h008'h018'h02
Module Declaration

module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 


