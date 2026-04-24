## Synchronous First-In-First-Out-->
module fifo(input logic clk,
            input logic rst,
            input logic wr_en,
            input logic rd_en,
            input logic [7:0]data_in,
            output logic [7:0]data_out,	
            output logic full,
            output logic empty);
  logic [3:0]count;
  logic [7:0]data_copy[0:7];
  logic [2:0]wr_ptr;
  logic [2:0]rd_ptr;
  assign empty=(count==4'd0);
  assign full=(count==4'd8);
  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      data_out<='0;
      wr_ptr<='0;
      rd_ptr<='0;
      count<='0;
    end
    else if(wr_en && rd_en && !full && !empty) begin
      data_copy[wr_ptr]<= data_in;
    data_out<= data_copy[rd_ptr];
    wr_ptr<= wr_ptr + 1;
    rd_ptr<= rd_ptr + 1;
    end
    else if(wr_en && !full) begin
      data_copy[wr_ptr]<=data_in;
      wr_ptr<=wr_ptr+1;
      count<=count+1;
    end
    else if(rd_en && !empty) begin
      data_out<=data_copy[rd_ptr];
      rd_ptr<=rd_ptr+1;
      count<=count-1;
    end
    
  end
endmodule
