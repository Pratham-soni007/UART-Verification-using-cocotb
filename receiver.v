//Receiver Module
module receiver(input logic clk,
                input logic rst,
                input logic rdy_clr,//testbench
                input logic clk_en,
                input logic rx,
                output logic rdy,
                output logic [7:0] data_out);
  typedef enum logic [1:0]{
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
      rdy<='0;
      counter<='0;
      data_out<='0;
      data_copy<=0;
    end
    else begin
      if(rdy_clr) 
        rdy<=1'b0;
      else if(clk_en) begin
       case(state)
        IDLE: begin
          rdy<=0;
          counter<=0;
          if(rx==0)
            state<=START;
          else
            state<=IDLE;
        end
        START:
          begin
            counter<=0;
            state<=DATA;
          end
        DATA:
          begin
              data_copy<={rx,data_copy[7:1]};
              counter<=counter+1;
              if(counter==3'd7) begin
                state<=STOP;
                counter<='0;
              end
          end
        STOP:
          begin
            if(rx==1) begin
              rdy<=1;
              data_out<=data_copy;
              state<=IDLE;
            end
          end
      endcase
    end
    end
  end
endmodule
