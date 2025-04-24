`include "interface.sv"
`include "design.sv"

module apb_top (apb_int apbint);
  
  apb_master master_DUT ( .PCLK(apbint.clk),
              .PRESETn(apbint.rst_n),
              .PADDR(apbint.PADDR),
              .PPROT(apbint.PPROT),
              .PSEL0(apbint.PSEL0),
              .PSEL1(apbint.PSEL1),
              .PENABLE(apbint.PENABLE),
              .PWRITE(apbint.PWRITE),
              .PWDATA(apbint.PWDATA),
              .PSTRB(apbint.PSTRB),
              .PREADY(apbint.PREADY),
              .PRDATA(apbint.PRDATA),
              .address(apbint.address),
              .write_data(apbint.master_in),
              .read_data(apbint.master_out),
              .processs(apbint.processs),
              .data_size(apbint.data_size) );
  
  
  
  apb_slave slave_DUT ( .PCLK(apbint.clk),
             .PRESETn(apbint.rst_n),
             .PADDR(apbint.PADDR),
             .PPROT(apbint.PPROT),
             .PSEL0(apbint.PSEL0),
             .PSEL1(apbint.PSEL1),
             .PENABLE(apbint.PENABLE),
             .PWRITE(apbint.PWRITE),
             .PWDATA(apbint.PWDATA),
             .PSTRB(apbint.PSTRB),
             .PREADY(apbint.PREADY),
             .PRDATA(apbint.PRDATA),
             .write_data(apbint.slave_out),
             .read_data(apbint.slave_in),
             .valid(apbint.valid) );
  
endmodule : apb_top
