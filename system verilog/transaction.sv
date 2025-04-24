class transaction;
  
  bit psel, penable;
  rand bit pwrite;
  rand bit [31:0] paddr, pwdata;
  bit pready;
  bit [31:0] prdata;
  bit presetn;

  static bit [31:0] prev_addr;
  static bit prev_pwrite;

  //coverage
  covergroup g1;
    addr : coverpoint paddr { bins valid[] = {[0:255]}; }
    read_wr : cross paddr, pwrite;
  endgroup : g1

  
  constraint addr { paddr[31:0] >= 32'd0; paddr[31:0] < 256; }
  
  constraint cycle { if (prev_pwrite == 1)
  						{pwrite == 0;
                         paddr == prev_addr; } }
      
  function void post_randomize();
    prev_addr = paddr;
    prev_pwrite = pwrite;
  endfunction

  function new ();
    g1 = new();
  endfunction
      
  
  function void display (string name);
    $write("[%s]", name);
    $display("[%0t] paddr = %0d | pwrite = %0d | pwdata = %0d | prdata = %0d ", $time, paddr, pwrite, pwdata, prdata);
  endfunction
  
endclass : transaction
