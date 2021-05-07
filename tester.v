`timescale 1ns/1ps

module tester
(
  input             clk,
  output reg        turn,
  output reg        stop_alarm,
  output reg [6:0]  pir_sensor_1,
  output reg [6:0]  pir_sensor_2,
  output reg [6:0]  pir_sensor_3
);

initial begin 
    stop_alarm   = 0;
    pir_sensor_1 = 0;
    pir_sensor_2 = 0;
      pir_sensor_3 =  56;
    turn  = 'b1;
    #50
    pir_sensor_1 =  29;
    #1000
    pir_sensor_1 = 0;
    pir_sensor_3 = 0;
    stop_alarm = 1;
    #100
    stop_alarm ='b0;
    turn ='b0;
    #100
    turn ='b1;
    #1000
    pir_sensor_2 = 90;
    #100
    pir_sensor_2 = 0;
    #1000
    #3000
    $stop;
end
endmodule   
