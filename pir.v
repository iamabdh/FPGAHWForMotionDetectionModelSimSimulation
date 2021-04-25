module pir (
    clk, 
    stop_alarm,
    pir_sersor_1,
    pir_sensor_2,
    pir_sensor_3,
    LED,  // On: motion, Off: no motion
    buzzer, // On: motion, Off: no motion 
    display_data
);

// ----------------
// input Ports
// ----------------

input           clk;
input           stop_alarm;
input           pir_sensor_1;
input           pir_sensor_2;
input           pir_sensor_3;

// ----------------
// Output Ports
// ----------------

output          LED;
output          buzzer;
output [20:0]   display_data;

// ----------------
// Lacal parameters 
// ----------------

localparam INIT             = 4'b0001;
localparam IDLE             = 4'b0010;
localparam BUZZRING         = 4'b0100;
localparam STOPING_ALARM    = 4'b1000;

// Period of Operation (in clock cycles)
localparam BUZZING_DELAY 	= 100;

// ----------------
// Registers 
// ----------------

reg [3:0] fsm_state = INIT;
reg [6:0] counter_buzzing;

// ----------------
// Calculator Controller
// ----------------

always @(posedge clk) begin

    case(fsm_state)

        INIT: begin
            LED <= 0;
            display_data <= 0;
            counter_buzzing <= 0;
            fsm_state <= IDEL
        end

        IDLE: begin
            if (pir_sensor_1 == 1 | pir_sensor_2 == 1 | pir_sensor_3 == 1) begin
                fsm_state  <=  BUZZRING;
            end
        end
        BUZZRING : begin
            LED <= 1;
            buzzer <= 1;
            counter_buzzing <= counter_buzzing + 1;
            if (counter_buzzing >= BUZZING_DELAY) begin
                counter_buzzing <= 0;
                fsm_state <= STOPING_ALARM;
            end
            if (stop_alarm == 1) begin
                counter_buzzing <= 0;
                fsm_state <= STOPING_ALARM;
            end
        end
        STOPING_ALARM: begin
            LED <= 0;
            buzzer <= 0;
            fsm_state <= IDLE;
        end
    endcase
end   
endmodule