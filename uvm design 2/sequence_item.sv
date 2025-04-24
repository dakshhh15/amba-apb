import uvm_pkg::*;
`include "uvm_macros.svh"

class seq_item extends uvm_sequence_item;
  
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter STRB_WIDTH = DATA_WIDTH / 8;
  
  rand logic [DATA_WIDTH-1:0] master_in;
  rand logic [DATA_WIDTH-1:0] slave_in;
  rand logic [ADDR_WIDTH-1:0] address;
  logic [ADDR_WIDTH-1:0] master_out;
  logic [DATA_WIDTH-1:0] slave_out;       
  logic [DATA_WIDTH-1:0] PRDATA;   
  logic [ADDR_WIDTH-1:0] PADDR;  
  logic [DATA_WIDTH-1:0] PWDATA;
  logic [STRB_WIDTH-1:0] PSTRB;
  rand logic [6:0] processs;   
  logic [2:0] PPROT;      
  rand logic [1:0] data_size;  
  rand logic rst_n;            
  rand logic valid;   
  logic PSEL1;         
  logic PSEL0;   
  logic PENABLE;
  logic PWRITE;  
  logic PREADY;
  bit clk;
  
  //coverage off
  `uvm_object_utils(seq_item)
  //coverage on
  
  function new (string name = "seq_item");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("%s master_in = %0d | slave_in = %0d | address = %0d | process = %0d | data_size = %0d | valid = %0d | rst = %0d | master_out = %0d | slave_out = %0d, PWDATA = %0d | PSTRB = %0d | PRDATA = %0d | PADDR = %0d | PPROT = %0d | PSEL1 = %0d | PSEL0 = %0d | PENABLE = %0d | PWRITE = %0d | PREADY = %0d", super.convert2string(), master_in, slave_in, address, processs, data_size, valid, rst_n, master_out, slave_out, PWDATA, PSTRB, PRDATA, PADDR, PPROT, PSEL1, PSEL0, PENABLE, PWRITE, PREADY);
        endfunction
  
  constraint apb_constraints { rst_n dist {0:/10, 1:/90};

                              
            valid dist {0:/10, 1:/90};
    
            address dist {4000:/45, 4001:/45, [0:32'hFFFFFFFF]:/10};
    
            processs dist {7'b0000011:/45, 7'b0100011:/45, [0:7'b1111111]:/10};
    
            data_size dist {0:/30, 1:/30, 2:/30}; }
  
endclass : seq_item
