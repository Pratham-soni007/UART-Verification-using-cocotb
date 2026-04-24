##Transmitter-->
module transmitter(input logic clk,
                   input logic wr_enb,
                   input logic enb,
                   input logic rst,
                   input logic [7:0]data_in,
                   output logic tx,
                   output logic busy);
  typedef enum logic[1:0]{
    IDLE=2'b00,
    START=2'b01,
    DATA=2'b10,
    STOP=2'b11
  }state_t;
  state_t state;
  logic [2:0] counter;
  logic [7:0] data_copy;
  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      state<=IDLE;
      tx<=1'b1;
      busy<=1'b0;
      counter<='0;
      data_copy<='0;
    end
    else if(enb) begin
      case(state)
        IDLE: begin
          tx<=1;
          busy<='0;
        if(wr_enb==1) begin
          data_copy<=data_in;
          state<=START;
        end
        else begin
          state<=IDLE;
        end 
        end
        START: begin
          tx<=0;
        busy<=1;
        state<=DATA;
        end
        DATA: begin
          busy<=1'b1;
            tx<=data_copy[0];
            data_copy<=data_copy>>1;
            counter<=counter+1;
          if(counter==3'b111) begin 
          state<=STOP;
            counter<=0;
        end
        end
        STOP: begin
          tx<=1;
        busy<=1;
        end
      endcase
    end
    end
      endmodule
