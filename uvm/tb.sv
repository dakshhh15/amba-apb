`include "packet.sv"
`include "design.sv"

module tb;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pkg::*;
  
  bit PCLK;
  bit PRESETn;
  
  int1 apb_if(.PCLK(PCLK), .PRESETn(PRESETn));
  
  apb_master u_master (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(apb_if.PSEL),
    .PENABLE(apb_if.PENABLE),
    .PADDR(apb_if.PADDR),
    .PWDATA(apb_if.PWDATA),
    .PWRITE(apb_if.PWRITE),
    .PRDATA(apb_if.PRDATA),
    .PREADY(apb_if.PREADY)
  );
  
  apb_slave u_slave (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(apb_if.PSEL),
    .PENABLE(apb_if.PENABLE),
    .PADDR(apb_if.PADDR),
    .PWDATA(apb_if.PWDATA),
    .PWRITE(apb_if.PWRITE),
    .PRDATA(apb_if.PRDATA),
    .PREADY(apb_if.PREADY)
  );
  
  always #10 PCLK = ~PCLK;
  
  initial
    begin
      PCLK = 0;
      PRESETn = 0;
      #10 PRESETn = 1;
      //#500 PRESETn = 0; //reset on posedge
      //#80 PRESETn = 1; //end on posedge
      //#3200 PRESETn = 0; //reset on posedge
      //#70 PRESETn = 1; //end on negedge
      //#4000 PRESETn = 0; //reset on negedge
      //#70 PRESETn = 1; //end on posedge
      //#3230 PRESETn = 0;  //reset on negedge
      //#80 PRESETn = 1; //end on negedge
  end
  
  initial
    begin
      uvm_config_db#(virtual int1)::set(null, "*", "vint", apb_if);
      uvm_config_int::set(null, "test_1.seq", "count", 200);
    end
  
  initial
    begin
      run_test("test_1");
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
endmodule
