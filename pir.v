module pir (
    clk, 
    turn,
    stop_alarm,
    pir_sensor_1,
    pir_sensor_2,
    pir_sensor_3,
    LED,  // On: motion, Off: no motion
    buzzer, // On: motion, Off: no motion 
    display_threshold,
    display_from_threshold,
    display_last_measurment,
    display_from_measurment,
    display_total_sensors,
    display_average_1,
    display_average_2,
    display_average_3,
    check_counter,
    check_counter_total
);

// ----------------
// input Ports
// ----------------

input           clk;
input           turn;
input           stop_alarm;
input   [6:0]   pir_sensor_1;
input   [6:0]   pir_sensor_2;
input   [6:0]   pir_sensor_3;

// ----------------
// Output Ports
// ----------------

output reg  [2:0]   LED;  
output reg          buzzer;
output reg  [7:0]   display_threshold;
output reg  [3:0]   display_from_threshold;
output reg  [7:0]   display_last_measurment;
output reg  [3:0]   display_from_measurment;
output reg  [7:0]   display_total_sensors;
output reg  [7:0]   display_average_1; 
output reg  [7:0]   display_average_2;
output reg  [7:0]   display_average_3;   
output reg  [7:0]   check_counter;
output reg  [7:0]   check_counter_total;


// ----------------
// Lacal parameters 
// ----------------

localparam INIT                 = 4'b0001;
localparam IDLE                 = 4'b0010;
localparam BUZZING              = 4'b0100;
localparam STOPING_ALARM_DEVICE = 4'b1000;

// Period of Operation (in clock cycles)
localparam BUZZING_DELAY 	= 100;
localparam COUNTER_AVERAGE = 4;
localparam COUNTER_AVERAGE_TOTAL = 17;

// ----------------
// Registers 
// ----------------
reg [3:0] fsm_state = INIT;
reg [6:0] counter_buzzing;
reg [6:0] counter_average;
reg [6:0] counter_average_total;
reg [9:0] average_pir_1;
reg [9:0] average_pir_2;
reg [9:0] average_pir_3;
reg [2:0] nth_sensor_triggered;
reg [7:0] total; // used for total number of sensor are triggered 
// ----------------
// RAM  8x8
// ----------------
reg [7:0] RAM [0:7];

integer i;
initial begin
    for(i=0; i<8; i = i+1) begin
        RAM[i] = 0; // initial all data to zero
    end
end

// ----------------
// Controller
// ----------------

always @(posedge clk) begin

    case(fsm_state)

        INIT: begin
            LED <= 0;
            counter_buzzing <= 0;
            counter_average <= 0;
            counter_average_total <=0;
            average_pir_1 <= 0;
            average_pir_2 <= 0;
            average_pir_3 <= 0;
            buzzer <=0;
            nth_sensor_triggered <=0;
            total  <= 0;
            if (turn == 1) begin
                fsm_state <= IDLE;
            end
        end

        IDLE: begin
            if (turn ==1) begin
                // display some data while idling=> 
                // threshold, threshold from  which sensor, 
                // last measurment, last from  which sensor.
                display_threshold           <=  RAM[0];
                display_from_threshold      <=  RAM[1];
                display_last_measurment     <=  RAM[2];
                display_from_measurment     <=  RAM[3];
                display_total_sensors       <=  RAM[4];
                display_average_1           <=  RAM[5];
                display_average_2           <=  RAM[6];
                display_average_3           <=  RAM[7];
                
                // this blocks will excute at each four cycles for 4 times, compute
                // the average for each sensor, and store in adderss 5, 6, 7 for each sesnors
                counter_average <= counter_average + 1;
                counter_average_total <= counter_average_total + 1;
                check_counter <= counter_average;
                check_counter_total <= counter_average_total;

                if (counter_average >= COUNTER_AVERAGE) begin
                    average_pir_1 <= pir_sensor_1 + average_pir_1; 
                    average_pir_2 <= pir_sensor_2 + average_pir_2;
                    average_pir_3 <= pir_sensor_3 + average_pir_3;   
                    counter_average <= 1; 
                end
                if (counter_average_total >= COUNTER_AVERAGE_TOTAL) begin
                    RAM[5] <= average_pir_1 >> 2;
                    RAM[6] <= average_pir_2 >> 2;
                    RAM[7] <= average_pir_3 >> 2;
                    average_pir_1 <= 0;
                    average_pir_2 <= 0;
                    average_pir_3 <= 0;
                    counter_average_total <= 1;
                    counter_average <= 1;      
                end



                // this if statement checks if the average bigger than 50
                 if ( RAM[5] >= 50 | RAM[6] >= 50 |  RAM[7] >= 50) begin
                    fsm_state  <=  BUZZING;
                end 
            end 
            else if (turn == 0) begin
                    fsm_state <= STOPING_ALARM_DEVICE; 
            end
        end

        BUZZING : begin
            buzzer <= 1;
            // check from which sensors the system trigred and produce output in LED,
            //  and store last of them in RAM address 2 and from which of them in address 3
            if (RAM[5] >= 50) begin
                LED[0] <=1;
                nth_sensor_triggered[0] <=1; 
                RAM[2] <= RAM[5];
                RAM[3] <= 1;
            end
            
            if (RAM[6] >= 50) begin
                LED[1] <= 1;
                nth_sensor_triggered[1] <= 1;
                RAM[2] <= RAM[6];
                RAM[3] <= 2;
            end

            if (RAM[7] >= 50) begin
                LED[2] <=1;
                nth_sensor_triggered[2] <=1;
                RAM[2] <= RAM[7];
                RAM[3] <= 3;
            end
            
            //  store total nth sensor triggered
            total <= nth_sensor_triggered[0] + nth_sensor_triggered[1] + nth_sensor_triggered[2];

            // store threshold address in 0, address 1 store from which sensor 
            if (RAM[5] >= RAM[6] & RAM[5] >= RAM[7] & RAM[5] >= RAM[0]) begin
                 RAM[0] <= RAM[5];
                 RAM[1] <= 1;
            end
            if (RAM[6] >= RAM[5] & RAM[6] >= RAM[7] & RAM[6] >= RAM[0]) begin
                 RAM[0] <= RAM[6];
                 RAM[1] <= 2;
            end
            
            if (RAM[7] >= RAM[5] & RAM[7] >= RAM[6] & RAM[7] >= RAM[0]) begin
                 RAM[0] <= RAM[7];
                 RAM[1] <= 3;
            end
            
            // this block shows in this state will left in 100 cycles  
            counter_buzzing <= counter_buzzing + 1;
            if (counter_buzzing >= BUZZING_DELAY) begin
                counter_buzzing <= 0;
                fsm_state <= STOPING_ALARM_DEVICE;
            end
            // this if statement checks if stop is set will left this state in next cycle, 
            // or at turn equal  zero
            if (stop_alarm == 1 | turn == 0 ) begin
                counter_buzzing <= 0;
                fsm_state <= STOPING_ALARM_DEVICE;
            end 
        end
        STOPING_ALARM_DEVICE: begin
            RAM[4] <= RAM[4] + total; // store number of sensor are triggried
            RAM[5] <= 0;
            RAM[6] <= 0;
            RAM[7] <= 0;
            fsm_state <= INIT;
        end
    endcase
end   

endmodule