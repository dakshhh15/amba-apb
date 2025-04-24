`ifndef APB_MASTER_SV
`define APB_MASTER_SV

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
      //$display("[%0t] Reset in design", $time);
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
`endif

`ifndef APB_SLAVE_SV
`define APB_SLAVE_SV

module apb_slave (
  input logic PCLK, PRESETn,
  input logic PSEL, PENABLE,
  input logic [31:0] PADDR, PWDATA,
  input logic PWRITE,
  output logic [31:0] PRDATA,
  output logic PREADY
);
  
  
  logic [31:0] mem [0:255];
  
  always_ff @(posedge PCLK or negedge PRESETn) begin
  if (!PRESETn) begin
    PREADY <= 0;
    foreach (mem[i])
      mem[i] <= 0;
  end
  else begin
    PREADY <= (PSEL && PENABLE);

    if (PSEL && PENABLE) begin
      if (PWRITE)
        mem[PADDR[7:0]] <= PWDATA;
      else
        PRDATA <= mem[PADDR[7:0]];
    end
  end
end

  
endmodule
`endif

`ifndef INT1_SV
`define INT1_SV

interface int1 (input logic PCLK,
               input logic PRESETn);

  logic PSEL;
  logic PENABLE;
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic PWRITE;
  logic [31:0] PRDATA;
  logic PREADY;
  
  property prop_1;
    @(posedge PCLK)
    disable iff(!PRESETn) $rose(PSEL) |=> PENABLE;
  endproperty
  assert property(prop_1);
    
  property prop_2;
    @(posedge PCLK)
    disable iff(!PRESETn) $rose(PSEL) |-> ##2 PREADY;
  endproperty
  assert property(prop_2);
    
  property prop_3;
    @(posedge PCLK)
    disable iff(!PRESETn) $rose(PSEL) |=> $rose(PENABLE) |=> $rose(PREADY);
  endproperty
  assert property(prop_3);
  
  assert property (@(posedge PCLK) PENABLE |=> PREADY);
  assert property (@(posedge PCLK) (PSEL && PENABLE) |=> PREADY);
    
  assert property (@(posedge PCLK) $fell(PRESETn) |-> !PSEL);
  assert property (@(posedge PCLK) $fell(PRESETn) |-> !PENABLE);
  assert property (@(posedge PCLK) $fell(PRESETn) |-> !PREADY);
    
endinterface :int1
`endif
