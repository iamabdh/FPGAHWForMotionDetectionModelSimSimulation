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
    pir_sensor_3 = 0;
    turn  = 'b1;
    #50
    pir_sensor_1 =  69;
    pir_sensor_2 =  80;
    pir_sensor_3 =  62;
    #80
    pir_sensor_1 =  99;
    pir_sensor_2 =  70;
    pir_sensor_3 =  84;
    #80
    pir_sensor_1 =  99;
    pir_sensor_2 =  70;
    pir_sensor_3 =  60;
    #80
    pir_sensor_1 =  80;
    pir_sensor_2 =  10;
    pir_sensor_3 =  70;
    #120
    pir_sensor_1 = 0;
    pir_sensor_2 = 0;
    pir_sensor_3 = 0;
    #200
    pir_sensor_1 = 30;
    pir_sensor_3 = 30;
    pir_sensor_2 = 51;
    #200 
    stop_alarm = 0;
    #20
    stop_alarm = 0;
    #100
    pir_sensor_1 = 0;
    pir_sensor_3 = 0;
    pir_sensor_2 = 0;
    #10200
    pir_sensor_2 = 90;
    #300
    stop_alarm = 1;
    #20
    stop_alarm = 0;
    pir_sensor_2 = 0;
    #1000
    #3000
    $stop;
end
endmodule   
