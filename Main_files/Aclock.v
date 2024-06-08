`timescale 1ns / 1ps

module aclock(
 input reset,  
 input clk,  
/* input [1:0] H_in1, 
 input [3:0] H_in0, */
 input [3:0] M_in1, 
 input [3:0] M_in0,
 input LD_time,  
 input   LD_alarm,  
 input   STOP_al,  
 input   AL_ON,  
 /*input [1:0] month_in_1,
 input [3:0] month_in_0,
 input [3:0] year_in_3,
 input [3:0] year_in_2,
 input [3:0] year_in_1,
 input [3:0] year_in_0,
 input [1:0] date_in_1,
 input [3:0] date_in_0,*/
 
 output reg Alarm, 
 output [3:0]  M_out1, 
 output [3:0]  M_out0,
 /*output [1:0]  H_out1, 
 output [3:0]  H_out0,*/
 //output [3:0]  S_out1,
 //output [3:0]  S_out0,
 /*output [1:0] month_out_1,
 output [3:0] month_out_0,
 output [3:0] year_out_3,
 output [3:0] year_out_2,
 output [3:0] year_out_1,
 output [3:0] year_out_0,
 output [1:0] date_out_1,
 output[3:0] date_out_0*/ 
output oled_spi_clk,
output oled_spi_data,
output oled_vdd,
output oled_vbat,
output oled_reset_n,
output oled_dc_n
 );

 reg clk_1s; 
 //reg clk_1;
 reg [63:0]count;
 reg [3:0] tmp_1s; 
 reg [5:0] tmp_hour, tmp_minute, tmp_second,tmp_date,tmp_month; 
 reg [15:0] tmp_year;
 reg [1:0] c_hour1,a_hour1; 
 reg [3:0] c_hour0,a_hour0;
 reg [3:0] c_min1,a_min1;
 reg [3:0] c_min0,a_min0;
 reg [3:0] c_sec1,a_sec1;
 reg [3:0] c_sec0,a_sec0;
 reg [3:0] c_date0,a_date0;
 reg [1:0] c_date1, a_date1;
 reg [1:0] c_month1, a_month1;
 reg [3:0] c_month0,a_month0;
 reg [3:0] c_year0,a_year0;
 reg [3:0] c_year1,a_year1; 
 reg [3:0] c_year2,a_year2;
 reg [3:0] c_year3,a_year3;
 

reg [511:0] text;
reg [63:0]text_M_out1, text_M_out0;
reg [63:0]text_S_out1, text_S_out0;
reg [3:0] S_out1;
reg [3:0] S_out0; 
    
 function [3:0] mod_10;
 input [5:0] number;
 begin
 mod_10 = (number >=50) ? 5 : ((number >= 40)? 4 :((number >= 30)? 3 :((number >= 20)? 2 :((number >= 10)? 1 :0))));
 end
 endfunction
 function [3:0] mod_1000;
 input [15:0] number;
 begin
 mod_1000 = (number >=5000) ? 5 : ((number >= 4000)? 4 :((number >= 3000)? 3 :((number >= 2000)? 2 :((number >= 1000)? 1 :0))));
 end
 endfunction
  function [3:0] mod_100;
 input [15:0] number;
 begin
 number = number - 1000*mod_1000(number);
 mod_100 = (number >=900) ? 9 : ((number >= 800)? 8 :((number >= 700)? 7 :((number >= 600)? 6 :((number >= 500)? 5 :((number>= 400) ? 4: ((number >=300) ?3 : ((number >= 200) ? 2: ((number >= 100) ?1 : 0))))))));
 end
 endfunction
 
 always @(posedge clk or posedge reset) begin
        if(reset) begin
            clk_1s <= 0;
            count <= 0;
        end else begin
            if(count == 64'd50000000) begin
                count <= 0;
                clk_1s<= ~clk_1s;
            end else begin
                count <= count + 1;
            end
        end
   end
 /*always @(posedge clk_1 or posedge reset)
 begin
 if(reset) 
 begin
 tmp_1s <= 0;
 clk_1s <= 0;
 end
 else begin
 tmp_1s <= tmp_1s + 1;
 if(tmp_1s <= 5) 
 clk_1s <= 0;
 else if (tmp_1s >= 10) begin
 clk_1s <= 1;
 tmp_1s <= 1;
 end
 else
 clk_1s <= 1;
 end
 end
 */
 always @(posedge clk_1s or posedge reset )
 begin
 if(reset) begin 
 a_hour1 <= 2'b00;
 a_hour0 <= 4'b0000;
 a_min1 <= 4'b0000;
 a_min0 <= 4'b0000;
 a_sec1 <= 4'b0000;
 a_sec0 <= 4'b0000;
 a_date1 <= 2'b00;
 a_date0 <= 4'b0000;
 a_month0 <= 4'b0000;
 a_month1 <= 2'b00;
 a_year1 <= 4'b0000;
 a_year0 <= 4'b0000;
 a_year2 <= 4'b0000;
 a_year3 <= 4'b0000;
 //tmp_hour <= H_in1*10 + H_in0;
 tmp_minute <= M_in1*10 + M_in0;
 tmp_second <= 0;
 /*tmp_date <= date_in_1*10 + date_in_0;
 tmp_month <= month_in_1*10 + month_in_0;
 tmp_year <= year_in_3*1000 + year_in_2*100 + year_in_1 *10 + year_in_0; */
 end 
 else begin
 if(LD_alarm) begin 
// a_hour1 <= H_in1;
 //a_hour0 <= H_in0;
 a_sec1 <= 4'b0000;
 a_sec0 <= 4'b0000;
 a_min1 <= M_in1;
 a_min0 <= M_in0;

 /*a_date0 <= date_in_0;
 a_date1 <= date_in_1;
 a_month0 <= month_in_0;
 a_month1 <= month_in_1;
 a_year0 <= year_in_0;
 a_year1 <= year_in_1;
 a_year2 <= year_in_2;
 a_year3 <= year_in_3; */
 end 
 if(LD_time) begin
// tmp_hour <= H_in1*10 + H_in0;
 tmp_second <= 0;
 tmp_minute <= M_in1*10 + M_in0;
 /*tmp_date <= date_in_1*10 + date_in_0;
 tmp_month <= month_in_1*10 + month_in_0;
 tmp_year <= year_in_3*1000 + year_in_2*100 + year_in_1 *10 + year_in_0;*/
 end 
 else begin  
 tmp_second <= tmp_second + 1;
 if(tmp_second >=59) begin 
 tmp_minute <= tmp_minute + 1;
 tmp_second <= 0;
 if(tmp_minute >=59) begin 
 tmp_minute <= 0;
 tmp_hour <= tmp_hour + 1;
 if(tmp_hour >= 24) begin 
 tmp_hour <= 0;
 tmp_date<= tmp_date + 1;
 if(tmp_date >= 30) begin
 tmp_date <= 1;
 tmp_month <= tmp_month + 1;
if(tmp_month >=12) begin
 tmp_year <= tmp_year + 1;
 tmp_month <= 1 ;
 end
 end
 end 
 end 
 end

 end 
 end 
 end 
 
 
 
 always @(*) begin

 if(tmp_hour>=20) begin
 c_hour1 = 2;
 end
 else begin
 if(tmp_hour >=10) 
 c_hour1  = 1;
 else
 c_hour1 = 0;
 end
 c_hour0 = tmp_hour - c_hour1*10; 
 c_min1 = mod_10(tmp_minute); 
 c_min0 = tmp_minute - c_min1*10;
 c_sec1 = mod_10(tmp_second);
 c_sec0 = tmp_second - c_sec1*10; 
 
 

 if(tmp_date == 30) begin
 c_date1 = 3;
 end
 else begin
 if(tmp_date >=20) 
 c_date1  = 2;
 else begin
 if(tmp_date >=10)
 c_date1 = 1;
 else
 c_date1 = 0;
 end
 end
 c_date0 = tmp_date - c_date1*10; 
 c_month1 = mod_10(tmp_month); 
 c_month0 = tmp_month - c_month1*10;
 c_year3= mod_1000(tmp_year);
 c_year2 = mod_100(tmp_year);
 c_year1 = mod_10(tmp_year - 100*c_year2 - 1000*c_year3);
 c_year0 = tmp_year - 100*c_year2 - 1000*c_year3 - c_year1*10; 
 end
 

 //assign H_out1 = c_hour1; 
 //assign H_out0 = c_hour0; 
 assign M_out1 = c_min1; 
 assign M_out0 = c_min0; 
// assign S_out1 = c_sec1; 
// assign S_out0 = c_sec0;
 /*assign date_out_0 = c_date0;
 assign date_out_1 = c_date1;
 assign month_out_0 = c_month0;
 assign month_out_1 = c_month1; 
 assign year_out_0 = c_year0;
 assign year_out_1 = c_year1; 
 assign year_out_2 = c_year2;
 assign year_out_3 = c_year3;*/
 
 

 always @(posedge clk_1s or posedge reset) begin
 if(reset) 
 Alarm <=0; 
 else begin
 if({a_min1,a_min0,a_sec1,a_sec0}=={c_min1,c_min0,c_sec1,c_sec0})
 begin 
 if(AL_ON) Alarm <= 1; 
 end
 if(STOP_al) Alarm <=0; 
 end
 end
 //----------------------------------------------------------------
always@(negedge clk_1s)
begin
case(M_out0)
4'b0000: text_M_out0 <= "0"; 
4'b0001: text_M_out0 <= "1"; 
4'b0010: text_M_out0 <= "2"; 
4'b0011: text_M_out0 <= "3"; 
4'b0100: text_M_out0 <= "4"; 
4'b0101: text_M_out0 <= "5"; 
4'b0110: text_M_out0 <= "6"; 
4'b0111: text_M_out0 <= "7"; 
4'b1000: text_M_out0 <= "8"; 
4'b1001: text_M_out0 <= "9";
default: text_M_out0 <= "0"; 
endcase

case(M_out1)
4'b0000: text_M_out1 <= "0"; 
4'b0001: text_M_out1 <= "1"; 
4'b0010: text_M_out1 <= "2"; 
4'b0011: text_M_out1 <= "3"; 
4'b0100: text_M_out1 <= "4"; 
4'b0101: text_M_out1 <= "5"; 
4'b0110: text_M_out1 <= "6"; 
4'b0111: text_M_out1 <= "7"; 
4'b1000: text_M_out1 <= "8"; 
4'b1001: text_M_out1 <= "9";
default: text_M_out1 <= "0"; 
endcase

case(c_sec1)
4'b0000: text_S_out1 <= "0"; 
4'b0001: text_S_out1 <= "1"; 
4'b0010: text_S_out1 <= "2"; 
4'b0011: text_S_out1 <= "3"; 
4'b0100: text_S_out1 <= "4"; 
4'b0101: text_S_out1 <= "5"; 
4'b0110: text_S_out1 <= "6"; 
4'b0111: text_S_out1 <= "7"; 
4'b1000: text_S_out1 <= "8"; 
4'b1001: text_S_out1 <= "9";
default: text_S_out1 <= "0"; 
endcase


case(c_sec0)
4'b0000: text_S_out0 <= "0"; 
4'b0001: text_S_out0 <= "1"; 
4'b0010: text_S_out0 <= "2"; 
4'b0011: text_S_out0 <= "3"; 
4'b0100: text_S_out0 <= "4"; 
4'b0101: text_S_out0 <= "5"; 
4'b0110: text_S_out0 <= "6"; 
4'b0111: text_S_out0 <= "7"; 
4'b1000: text_S_out0 <= "8"; 
4'b1001: text_S_out0 <= "9";
default: text_S_out0 <= "0"; 
endcase

 end
 //Display D1 (clk,reset,M_out1,M_out0,text_M_out0,text_Mout1,text);
 always@(*)
 begin
 text = {text_M_out1,text_M_out0, text_S_out1, text_S_out0 };
 end
 top T1 (clk,reset,text,oled_spi_clk, oled_spi_data, oled_vdd, oled_vbat, oled_reset_n, oled_dc_n);
 
endmodule

