## Code which connects all the four Module-->
module top(input logic clk,
           input logic rst,
           input logic wr_en,
           input logic rd_en,
           input logic [7:0]data_in,
           input logic rx,
           output logic tx,
           output logic [7:0]data_out,
           output logic rdy,
           output logic busy,
          output logic tx_full,
          output logic rx_empty);
  logic tx_enable;
      logic rx_full;
  logic rx_enable;
  logic tx_fifo_empty;
  logic [7:0] tx_fifo_out;
  logic rx_rdy;
  logic rdy_clr;
  logic [7:0] rx_data;
  baud_rate_generator brd(.clk(clk),.rx_enable(rx_enable),.tx_enable(tx_enable),.rst(rst));
  transmitter tr(.clk(clk),.rst(rst),.wr_enb(!tx_fifo_empty),.enb(tx_enable),.data_in(tx_fifo_out),.tx(tx),.busy(busy));
  receiver re(.clk(clk),.rst(rst),.rdy_clr(rdy_clr),.clk_en(rx_enable),.rx(rx),.rdy(rdy),.data_out(rx_data));
  fifo tx_fifo_inst(.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(!busy && !tx_fifo_empty),.data_in(data_in),.data_out(tx_fifo_out),.full(tx_full),.empty(tx_fifo_empty));
  fifo rx_fifo_inst(.clk(clk),.rst(rst),.wr_en(rx_rdy),.rd_en(rd_en),.data_in(rx_data),.data_out(data_out),.full(rx_full),.empty(rx_empty));
endmodule
