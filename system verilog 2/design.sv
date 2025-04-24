module apb_master (
  input logic PCLK, PRESETn,
  output logic PSEL, PENABLE,
  output logic [31:0] PADDR, PWDATA,
  output logic PWRITE,
  input logic [31:0] PRDATA,
  input logic PREADY
);
  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state, next_state;
  
  always_ff@(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      state <= IDLE;
    else
      state <= next_state;
  end
  
  always_comb begin
    	next_state = state;
   		case(state)
       		IDLE: next_state = SETUP;
          	SETUP: next_state = ACCESS;
          ACCESS: next_state = (PREADY) ? IDLE: ACCESS;
        endcase
  end
  
  always_ff @(posedge PCLK or negedge PRESETn) begin
    
    if (!PRESETn) begin
      PSEL <= 0;
      PENABLE <= 0;
      PWRITE <= 0;
      PADDR <= 0;
      PWDATA <= 0;
      $display("Reset in design");
    end else begin 
      case (state)
        IDLE: begin 
          PSEL <= 1;
          PADDR <= 32'h1000;
          PWDATA <= 32'hABCD1234;
          PWRITE <= 1;
        end
        SETUP: begin
          PENABLE <=1;
        end
        ACCESS: begin
          if (PREADY) begin
            PSEL <= 0;
            PENABLE <= 0;
          end
        end
      endcase
    end
  end
endmodule

module apb_slave (
  input logic PCLK, PRESETn,
  input logic PSEL, PENABLE,
  input logic [31:0] PADDR, PWDATA,
  input logic PWRITE,
  output logic [31:0] PRDATA,
  output logic PREADY
);
  
  
  logic [31:0] mem [0:255];
  
  always_ff @(posedge PCLK or negedge PRESETn)
    begin
      
      if (!PRESETn)
        PREADY <= 0;
      else
        PREADY <= (PSEL && PENABLE);
    end
  
  always_ff @(posedge PCLK)
    begin
      if (PSEL && PENABLE)
        begin
          if (PWRITE)
            begin
              mem[PADDR[7:0]] <= PWDATA;
            end
          
          else
            begin
              PRDATA <= mem[PADDR[7:0]];
            end
        end
    end
  
endmodule

interface int1 (input logic PCLK,
                input logic PRESETn);
  
  logic PSEL;
  logic PENABLE;
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic PWRITE;
  logic [31:0] PRDATA;
  logic PREADY;
  
endinterface :int1
