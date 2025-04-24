`include "design.sv"


`ifndef APB_INT_SV
`define APB_INT_SV

interface apb_int (clk);

    // Parameters
    parameter ADDR_WIDTH = 32;                   
    parameter DATA_WIDTH = 32;                
    parameter STRB_WIDTH = DATA_WIDTH / 8;
    
    // Input signals
    input bit clk;                   

    // Internal signals
    logic [DATA_WIDTH-1:0] master_in;        
    logic [DATA_WIDTH-1:0] slave_in;                
    logic [ADDR_WIDTH-1:0] address;                 
    logic [ADDR_WIDTH-1:0] master_out;     
    logic [DATA_WIDTH-1:0] slave_out;             
    logic [DATA_WIDTH-1:0] PRDATA;           
    logic [ADDR_WIDTH-1:0] PADDR;                   
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [STRB_WIDTH-1:0] PSTRB;
    logic [6:0] processs;            
    logic [2:0] PPROT;       
    logic [1:0] data_size;    
    logic rst_n;                
    logic valid;          
    logic PSEL1;                 
    logic PSEL0;                 
    logic PENABLE;         
    logic PWRITE;         
    logic PREADY;                    

endinterface : apb_int
`endif
