`timescale 1ns/1ps

module tester
(
  output reg clk,
  output reg stop_alarm,
  output reg pir_sensor_1,
  output reg pir_sensor_2,
  output reg pir_sensor_3
);
initial clk = 1'b0;
always 
begin
    #10 
    clk = ~clk;
end

initial begin 
    stop_alarm   = 'b0;
    pir_sensor_1 = 'b0;
    pir_sensor_2 = 'b0;
    pir_sensor_3 = 'b0;
    #50
    pir_sensor_1 = 'b1;
    #10
    pir_sensor_1 = 'b0;
    #50
    stop_alarm ='b1;
    #20
    stop_alarm = 'b0;
    #1000
    $stop;
end
endmodule   
