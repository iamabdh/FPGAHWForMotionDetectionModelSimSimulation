`timescale 1ns/1ps

module testbench();

wire clk;
wire turn;
wire stop_alarm;
wire pir_sensor_1;
wire pir_sensor_2;
wire pir_sensor_3;
wire [2:0] LED;
wire buzzer;
wire [20:0] display_data;

pir c1 (clk, turn, stop_alarm, pir_sensor_1, pir_sensor_2, pir_sensor_3, LED, buzzer, display_data);
tester t1 (clk, turn, stop_alarm, pir_sensor_1, pir_sensor_2, pir_sensor_3);

    initial $monitor ($time, "clk = %b, turn = %b, stop_alarm = %b, pir_sensor_1 = %b, pir_sensor_2 = %b, pir_sensor_3 = %b, LED = %b, buzzer = %b, display_data = %b", clk, turn, stop_alarm, pir_sensor_1, pir_sensor_2, pir_sensor_3, LED, buzzer, display_data);

endmodule