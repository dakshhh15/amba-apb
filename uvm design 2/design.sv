`ifndef APB_MASTER_SV
`define APB_MASTER_SV
module apb_master (PCLK, PRESETn, PADDR, PPROT, PSEL0, PSEL1, PENABLE, PWRITE, PWDATA, PSTRB, PREADY, PRDATA, address, write_data, read_data, processs, data_size);
  
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter STRB_WIDTH = DATA_WIDTH / 8;
  parameter IDLE_PHASE = 2'b00;
  parameter SETUP_PHASE = 2'b01;
  parameter ACCESS_PHASE = 2'b10;
  
  input [DATA_WIDTH - 1 : 0] PRDATA;
  input [DATA_WIDTH - 1 : 0] write_data;
  input [DATA_WIDTH - 1 : 0] address;
  input [6:0] processs;
  input [1:0] data_size;
  input PCLK;
  input PRESETn;
  input PREADY;
  
  output reg [ADDR_WIDTH - 1 : 0] PADDR;
  output reg [DATA_WIDTH - 1 : 0] PWDATA;
  output reg [DATA_WIDTH - 1 : 0] read_data;
  output reg [STRB_WIDTH - 1 : 0] PSTRB;
  output reg [2:0] PPROT;
  output reg PSEL0;
  output reg PSEL1;
  output reg PENABLE;
  output reg PWRITE;
  
  reg [1:0] current_state;
  reg [1:0] next_state;
  
  //state set
  always @(posedge PCLK)
    begin
      if (!PRESETn)
        begin
          current_state <= IDLE_PHASE;
        end
      else
        begin
          current_state <= next_state;
        end
    end
  
  always @(*)
    begin
      case (current_state)
        IDLE_PHASE : begin
          PSEL0 <= 0;
          PSEL1 <= 0;
          PENABLE <= 0;
        end
        
        SETUP_PHASE : begin
          PADDR <= address;
          PENABLE <= 0;
          PPROT <= 3'b000;
          PWDATA <= write_data;
          
          if (address == 4000)
            begin
              PSEL0 <= 1;
              PSEL1 <= 0;
            end
          else if (address == 4001)
            begin
              PSEL0 <= 0;
              PSEL1 <= 1;
            end
          else
            begin
              PSEL0 <= 0;
              PSEL1 <= 0;
            end
          
          if (processs == 7'b0000011)
            begin
              PWRITE <= 0;
              PSTRB <= 4'b0000;
            end
          else if (processs == 7'b0100011)
            begin
              PWRITE <= 1;
              case (data_size)
                2'b00 : PSTRB <= (4'b0001 << address[1:0]);
                2'b01 : PSTRB <= (4'b0011 << { address[1], 1'b0 });
                2'b10 : PSTRB <= 4'b1111;
                default : PSTRB <= 4'b1111;
              endcase
            end
        end
        
        ACCESS_PHASE : begin
          PENABLE <= 1;
        end
        
        default : begin
          PADDR <= 0;
          PWDATA <= 0;
          PSTRB <= 0;
          PPROT <= 0;
          PSEL1 <= 0;
          PSEL0 <= 0;
          PENABLE <= 0;
          PWRITE <= 0;
        end
      endcase
    end
  
  always @(*)
    begin
      case (current_state)
        IDLE_PHASE : begin
          if (processs == (7'b0000011) || processs == (7'b0100011))
            begin
              next_state <= SETUP_PHASE;
            end
          else
            begin
              next_state <= IDLE_PHASE;
            end
        end
        
        SETUP_PHASE : begin
          next_state <= ACCESS_PHASE;
        end
        
        ACCESS_PHASE : begin
          if (PREADY && (processs == (7'b0000011) || processs == (7'b0100011))) 
            begin
              next_state <= SETUP_PHASE;
            end
          else if (PREADY)
            begin
              next_state <= IDLE_PHASE;
            end
          else
            begin
              next_state <= ACCESS_PHASE;
            end
        end
        default : begin next_state <= IDLE_PHASE;
        end
      endcase
    end
  
  always @(posedge PCLK)
    begin
      if (!PRESETn)
        begin
          read_data <= 0;
        end
      else if (PREADY && !PWRITE)
        begin
          read_data <= PRDATA;
        end 
    end
  
endmodule : apb_master
`endif





`ifndef APB_SLAVE_SV
`define APB_SLAVE_SV
module apb_slave (PCLK, PRESETn, PADDR, PPROT, PSEL0, PSEL1, PENABLE, PWRITE, PWDATA, PSTRB, PREADY, PRDATA, write_data, read_data, valid);

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter STRB_WIDTH = DATA_WIDTH / 8;
    parameter IDLE_PHASE = 2'b00;      
    parameter SETUP_PHASE = 2'b01;      
    parameter ACCESS_PHASE = 2'b10;      

    // Inputs
    input [DATA_WIDTH-1:0] read_data;       
    input [DATA_WIDTH-1:0] PWDATA;          
    input [ADDR_WIDTH-1:0] PADDR;               
    input [STRB_WIDTH-1:0] PSTRB;           
    input [2:0] PPROT;                                  
    input PCLK;   
    input PRESETn;         
    input PSEL1;
    input PSEL0;
    input PENABLE;
    input PWRITE;
    input valid;

    // Outputs
    output reg [DATA_WIDTH-1:0] write_data;
    output reg [DATA_WIDTH-1:0] PRDATA;
    output PREADY; 

    
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            write_data <= 0;               
            PRDATA <= 0;                   
        end
      else if (PREADY) begin
            if (PWRITE) begin
                write_data <= PWDATA & {{8{PSTRB[3]}},{8{PSTRB[2]}},{8{PSTRB[1]}},{8{PSTRB[0]}}};
            end
      end
    end

    assign PREADY = (PENABLE && valid && PRESETn && (PSEL0||PSEL1));

    always @(*) begin
        if (PREADY) begin
            PRDATA <= read_data;
        end
    end

endmodule : apb_slave
`endif
