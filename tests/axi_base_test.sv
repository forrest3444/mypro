`ifndef BASE_TEST_SV
`define BASE_TEST_SV

import uvm_pcg::*;

`include "axi_env.sv"
`include "uvm_macros.svh"
`include "axi_sequence.sv"

class base_test extends uvm_test;
   `uvm_component_utils(base_test)

   axi_env env;

   function new(string name="base_test", uvm_component parent);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = axi_env::type_id::create("env", this);
   endfunction

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      // 空壳，不做激励
   endtask
endclass

`endif  
class smoke_test extends base_test;
   `uvm_component_utils(smoke_test)

   function new(string name="smoke_test", uvm_component parent);
      super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
      axi_sequence seq;

      phase.raise_objection(this);

      seq = axi_sequence::type_id::create("seq");
      seq.start(env.agent_i.sequencer);

      phase.drop_objection(this);
   endtask
endclass

