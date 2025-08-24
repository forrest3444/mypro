// env/axi_reference_model.sv
`ifndef AXI_REFERENCE_MODEL_SV
`define AXI_REFERENCE_MODEL_SV

`include "uvm_macros.svh"   
import uvm_pkg::*;          
`include "axi_sequence_item.sv"
`include "axi_if.sv"

class axi_reference extends uvm_component;

	`uvm_component_utils(axi_reference);
  // 输入：从 monitor 接收 DUT 事务
  uvm_analysis_imp #(axi_sequence_item, axi_reference) imp;

  // 输出：发送期望事务给 scoreboard
  uvm_analysis_port #(axi_sequence_item) ap;

  // 内存模型（参考行为）
  typedef bit [31:0] addr_t;
  typedef bit [31:0] data_t;
  data_t mem_model[addr_t];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
    ap  = new("ap",  this);
  endfunction

  // 接收 monitor 的事务
  function void write(axi_sequence_item tr);
    axi_sequence_item exp_tr = axi_sequence_item::type_id::create("exp_tr");

    if (tr.cmd == axi_sequence_item::WRITE) begin
      // 写操作 -> 更新参考模型
      mem_model[tr.addr] = tr.data;
      // 写事务本身不会传给 scoreboard（因为无比较意义）
      `uvm_info("REF_MODEL", $sformatf("WRITE addr=0x%08h data=0x%08h (更新参考模型)",
                                       tr.addr, tr.data), UVM_LOW)
    end
    else if (tr.cmd == axi_sequence_item::READ) begin
      exp_tr.addr = tr.addr;
      exp_tr.cmd  = axi_sequence_item::READ;
      // 期望数据 = 模型中的值（如果没有，默认0）
      if (mem_model.exists(tr.addr))
        exp_tr.data = mem_model[tr.addr];
      else
        exp_tr.data = '0;

      // 把期望事务发给 scoreboard
      ap.write(exp_tr);

      `uvm_info("REF_MODEL", $sformatf("PREDICT READ addr=0x%08h exp=0x%08h",
                                       exp_tr.addr, exp_tr.data), UVM_LOW)
    end
  endfunction

endclass

`endif

