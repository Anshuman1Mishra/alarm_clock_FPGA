`timescale 1ns / 1ps

module tb();


 reg reset;
 reg clk;
 //reg [1:0] H_in1;
 //reg [3:0] H_in0;
 reg [3:0] M_in1;
 reg [3:0] M_in0;
 reg LD_time;
 reg LD_alarm;
 reg STOP_al;
 reg AL_ON;
/* reg [1:0] date_in_1;
 reg [3:0] date_in_0;
 reg [1:0] month_in_1;
 reg [3:0] month_in_0;
 reg [3:0] year_in_3;
 reg [3:0] year_in_2;
 reg [3:0] year_in_1;
 reg [3:0] year_in_0;*/

 wire Alarm;
 //wire [1:0] H_out1;
 //wire [3:0] H_out0;
 wire [3:0] M_out1;
 wire [3:0] M_out0;
 //wire [3:0] S_out1;
 //wire [3:0] S_out0;
 /*
 wire [1:0] date_out_1;
 wire [3:0] date_out_0;
 wire [1:0] month_out_1;
 wire [3:0] month_out_0;
 wire [3:0] year_out_3;
 wire [3:0] year_out_2;
 wire [3:0] year_out_1;
 wire [3:0] year_out_0;*/
wire oled_spi_clk;
wire oled_spi_data;
wire oled_vdd;
wire oled_vbat;
wire oled_reset_n;
wire oled_dc_n;

//wire clk_1;
//wire clk_1s;

 aclock uut(
 .reset(reset), 
 .clk(clk), 
 //.H_in1(H_in1), 
 //.H_in0(H_in0), 
 .M_in1(M_in1), 
 .M_in0(M_in0), 
 .LD_time(LD_time), 
 .LD_alarm(LD_alarm), 
 .STOP_al(STOP_al), 
 .AL_ON(AL_ON), 
 .Alarm(Alarm), 
 /*.H_out1(H_out1), 
 .H_out0(H_out0), */
 .M_out1(M_out1), 
 .M_out0(M_out0),
 //.S_out1(S_out1), 
 //.S_out0(S_out0),
 /*.date_in_0(date_in_0),
 .date_in_1(date_in_1),
 .month_in_0(month_in_0),
 .month_in_1(month_in_1),
 .date_out_0(date_out_0),
 .date_out_1(date_out_1),
 .month_out_0(month_out_0),
 .month_out_1(month_out_1),
 .year_in_0(year_in_0),
 .year_in_1(year_in_1),
 .year_in_2(year_in_2),
 .year_in_3(year_in_3),
 .year_out_0(year_out_0),
 .year_out_1(year_out_1),
 .year_out_2(year_out_2),
 .year_out_3(year_out_3)*/
.oled_spi_clk(oled_spi_clk),
.oled_spi_data(oled_spi_data),
.oled_vdd(oled_vdd),
.oled_vbat(oled_vbat),
.oled_reset_n(oled_reset_n),
.oled_dc_n(oled_dc_n)
//.clk_1(clk_1),
//.clk_1s(clk_1s)

 );
 
 initial begin 
  clk = 0;
  forever #5 clk = ~clk;
 end
 
 
 initial begin
 reset = 1;
 //H_in1 = 1;
 //H_in0 = 0;
 M_in1 = 1;
 M_in0 = 4;
 LD_time = 0;
 LD_alarm = 0;
 STOP_al = 0;
 AL_ON = 0; 
 /*date_in_0 = 2;
 date_in_1 = 1;
 month_in_0 = 6;
 month_in_1 = 0;
 year_in_0 = 2;
 year_in_1 = 2;
 year_in_2 = 0;
 year_in_3 = 2;*/
 
 #1000;
      reset = 0;
 //H_in1 = 1;
 //H_in0 = 0;
 M_in1 = 1;
 M_in0 = 5;
 LD_time = 0;
 LD_alarm = 1;
 STOP_al = 0;
 AL_ON = 1;
 /*date_in_0 = 2;
 date_in_1 = 1;
 month_in_0 = 6;
 month_in_1 = 0;
 year_in_0 = 2;
 year_in_1 = 2;
 year_in_2 = 0;
 year_in_3 = 2;*/ 
 #1000; 
 reset = 0;
 //H_in1 = 1;
 //H_in0 = 0;
 M_in1 = 1;
 M_in0 = 5;
 LD_time = 0;
 LD_alarm = 0;
 STOP_al = 0;
 AL_ON = 1; 
 /*date_in_0 = 2;
 date_in_1 = 1;
 month_in_0 = 6;
 month_in_1 = 0;
 year_in_0 = 2;
 year_in_1 = 2;
 year_in_2 = 0;
 year_in_3 = 2;*/
 wait(Alarm); 
 #1000
 STOP_al = 1; 
 #1000
 STOP_al = 0;
 /*H_in1 = 0;
 H_in0 = 4;
 M_in1 = 4;
 M_in0 = 5;
 LD_time = 1; 
 LD_alarm = 0;
 date_in_0 = 2;
 date_in_1 = 1;
 month_in_0 = 6;
 month_in_1 = 0;
 year_in_0 = 2;
 year_in_1 = 2;
 year_in_2 = 0;
 year_in_3 = 2;
 #1000
 STOP_al = 0;
 //H_in1 = 0;
 //H_in0 = 4;
 M_in1 = 5;
 M_in0 = 5;
 LD_alarm = 1; 
 LD_time = 0;
 date_in_0 = 2;
 date_in_1 = 1;
 month_in_0 = 6;
 month_in_1 = 0;
 year_in_0 = 2;
 year_in_1 = 2;
 year_in_2 = 0;
 year_in_3 = 2;
 wait(Alarm);
 #1000
 STOP_al = 1;*/
 
 end
      
endmodule

