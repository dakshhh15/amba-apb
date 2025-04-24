`include "design.sv"
`include "test.sv"

module tb;
  
  logic PCLK;
  logic PRESETn;
  
  int1 apb_if(.PCLK(PCLK), .PRESETn(PRESETn));
  test t1;
  initial
    begin
      t1 = new(apb_if);
      t1.main();
    end
  
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
      //#150 PRESETn = 0;
      //#140 PRESETn = 1;
  end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
endmodule
