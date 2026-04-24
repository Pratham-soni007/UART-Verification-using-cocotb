//Baud Rate Generator-->

module baud_rate_generator(input logic clk,
                           output logic rx_enable,
                           output logic tx_enable,
                           input logic rst
                          );
  parameter freq=50000000;
  parameter baud_rate=115200;
  parameter tx_cycles=freq/baud_rate;  //434
  parameter rx_cycles=tx_cycles/16;  //27
  logic [$clog2(tx_cycles)-1:0] tx_counter;
  logic [$clog2(rx_cycles)-1:0] rx_counter;
  
  //Transmitter
  always_ff @(posedge clk) begin
    if(rst) begin
      tx_counter<=1'b0;
      tx_enable<=1'b0;
    end
    else if(tx_counter==tx_cycles-1) begin
      tx_enable<=1'b1;
      tx_counter<='0;
    end
    else begin
      tx_enable<='0;
      tx_counter<=tx_counter+1;
    end
  end
  
  //Receiver
  always_ff @(posedge clk) begin
    if(rst) begin
      rx_counter<='0;
      rx_enable<='0;
    end
    else if(rx_counter==rx_cycles-1) begin
      rx_enable<=1'b1;
      rx_counter<='0;
    end
    else begin
      rx_enable<='0;
      rx_counter<=rx_counter+1;
    end
  end
endmodule
