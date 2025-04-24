`include "environment.sv"

class test;
  virtual int1 vint;
  
  environment env;

  function new (virtual int1 vint);
    this.vint = vint;
    env = new (vint);
    env.gen.count = 75;
  endfunction
  
  task main;
        env.main();
  endtask
  
endclass : test
