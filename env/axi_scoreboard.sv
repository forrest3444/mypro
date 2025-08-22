// env/axi_scoreboard.sv
`ifndef AXI_SCOREBOARD_SV
`define AXI_SCOREBOARD_SV

`include "uvm_macros.svh"   
import uvm_pkg::*;          
`include "axi_sequence_item.sv"
`include "axi_if.sv"

class axi_scoreboard extends uvm_component;

	`uvm_component_utils(axi_scoreboard);
  // 输入：期望事务（来自参考模型）
  uvm_analysis_imp #(axi_sequence_item, axi_scoreboard) exp_imp;
  // 输入：实际事务（来自 monitor）
  uvm_analysis_imp #(axi_sequence_item, axi_scoreboard) act_imp;

  // 存储最近一次事务
  axi_sequence_item exp_q[$]; // 期望队列
  axi_sequence_item act_q[$]; // 实际队列

  function new(string name, uvm_component parent);
    super.new(name, parent);
    exp_imp = new("exp_imp", this);
    act_imp = new("act_imp", this);
  endfunction

  // 接收参考模型的事务
  function void write(axi_sequence_item tr);
    // 注意：UVM中两个 imp 都会调用 write，这里要区分来源
    // 简化：用 get_full_name() 区分
    string path = get_full_name();
    if ($sfind(path, "exp_imp")) begin
      exp_q.push_back(tr);
    end
    else if ($sfind(path, "act_imp")) begin
      act_q.push_back(tr);
    end
    compare();
  endfunction

  // 比较函数
  function void compare();
    if (exp_q.size() > 0 && act_q.size() > 0) begin
      axi_sequence_item exp_tr = exp_q.pop_front();
      axi_sequence_item act_tr = act_q.pop_front();

      if (exp_tr.data == act_tr.data) begin
        `uvm_info("SCOREBOARD", $sformatf("READ PASS addr=0x%08h data=0x%08h",
                                          act_tr.addr, act_tr.data), UVM_LOW)
      end
      else begin
        `uvm_error("SCOREBOARD", $sformatf("READ FAIL addr=0x%08h expected=0x%08h got=0x%08h",
                                           exp_tr.addr, exp_tr.data, act_tr.data))
      end
    end
  endfunction

endclass

`endif

