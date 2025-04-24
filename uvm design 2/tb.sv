`include "package.sv"
`include "interface.sv"
`include "design_top.sv"
//`include "test.sv"

module tb;
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import pkg::*;
  
  bit clk;
  
  apb_int intf (.clk(clk));
  
  apb_top dut (intf);
  
  always #10 clk = ~clk;
  
  initial
    begin
      uvm_config_db#(virtual apb_int)::set(null, "*", "vint", intf);
      //clk = 1;
      //uvm_config_int::set(null, "test.seq", "count", 20);
    end
  
  initial
    begin
      run_test("test");
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
  
endmodule
