`timescale 1ns/1ps

module testbench();

reg         clk;
wire        turn;
wire        stop_alarm;
wire [6:0]  pir_sensor_1;
wire [6:0]  pir_sensor_2;
wire [6:0]  pir_sensor_3;
wire [2:0]  LED;
wire        buzzer;
wire [6:0]  display_threshold_1;
wire [6:0]  display_threshold_2;
wire [6:0]  display_last_measurment_1;
wire [6:0]  display_last_measurment_2;
wire [6:0]  display_total_sensors_1;
wire [6:0]  display_total_sensors_2;
wire [6:0]  check_counter;
wire [6:0]  check_counter_total;

initial clk = 1'b0;
always 
begin
    #10     clk = ~clk;   // 50 MHz 
end




pir c1 (clk, turn, stop_alarm, pir_sensor_1, pir_sensor_2, pir_sensor_3, LED, buzzer, display_threshold_1,  display_threshold_2, 
        display_last_measurment_1, display_last_measurment_2, display_total_sensors_1, display_total_sensors_2, check_counter, check_counter_total);
tester t1 (clk, turn, stop_alarm, pir_sensor_1, pir_sensor_2, pir_sensor_3);

    initial $monitor ($time, "clk = %b, turn = %b, stop_alarm = %b, pir_sensor_1 = %b, pir_sensor_2 = %b, pir_sensor_3 = %b, LED = %b, 
                                buzzer = %b, display_threshold_1 = %b, display_threshold_2 = %b, display_last_measurment_1 = %b, 
                                display_last_measurment_2 = %b, display_total_sensors_1 = %b, display_total_sensors_2 = %b, 
                                check_counter = %b, check_counter_total = %b", 
                                clk, turn, stop_alarm, pir_sensor_1, pir_sensor_2, pir_sensor_3, LED, buzzer, display_threshold_1,
                                display_threshold_2, display_last_measurment_1,  display_last_measurment_2,  display_total_sensors_1,  
                                display_total_sensors_2, check_counter, check_counter_total);

endmodule