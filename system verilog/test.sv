`include "environment.sv"

program test (int1 intf);
  
  environment env;
  
  initial
    begin
      env = new (intf);
      env.gen.count = 400;
      env.main();
    end
  
endprogram : test
