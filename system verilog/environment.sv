`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  
  virtual int1 vint;
  
  generator gen;
  driver driv;
  monitor mon;
  scoreboard sb;
  
  mailbox mbx1;
  mailbox mbx2;
  
  function new (virtual int1 vint);
    this.vint = vint;
    
    mbx1 = new ();
    mbx2 = new ();
    
    gen = new (mbx1);
    driv = new (vint, mbx1);
    mon = new (vint, mbx2);
    sb = new (mbx2);
  endfunction 
  
  //task pre();
    //driv.reset();
  //endtask : pre
  
  task run();
    fork
      gen.main();
      driv.main();
      mon.main();
      sb.main();
    join_none
  endtask : run
  
  task post();
    wait (gen.ended.triggered);
    $display("%0t generation ends %0d", $time, driv.count1);
    wait (gen.count >= driv.count1);
    $display("driver ended");
    wait (gen.count == sb.count2);
    $display("sb ended");
    
  endtask : post
  
  task main();
    //pre();
    run();
    post();
    $finish;
  endtask : main
  
endclass : environment
