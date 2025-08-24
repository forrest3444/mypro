`ifndef AXI_ENV_SV
`define AXI_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_agent.sv"
`include "axi_scoreboard.sv"
`include "axi_reference.sv"
`include "axi_sequence_item.sv"
`include "axi_if.sv"

class axi_env extends uvm_env;

	`uvm_component_utils(axi_env);
  // 子组件
  axi_agent       agt_i;
	axi_agent       agt_o;
  axi_scoreboard  scb;
	axi_reference   refm;

  // 构造函数
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // build_phase：实例化子组件
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

		//上游agt
    agt_i      = axi_agent::type_id::create("agt_i", this);
		uvm_config_db#(uvm_active_passive_enum)::set(this, "agt_i", "is_active", UVM_ACTIVE);

		//下游agt
		agt_o      = axi_agent::type_id::create("agt_o", this);
		uvm_config_db#(uvm_active_passive_enum)::set(this, "agt_o", "is_active", UVM_PASSIVE);

    scb        = axi_scoreboard::type_id::create("scb", this);
		refm       = axi_reference ::type_id::create("refm", this);
  endfunction

  // connect_phase：连接 monitor → scoreboard
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Monitor 的事务广播给 Reference Model（用于预测）
    agt_i.monitor.ap.connect(refm.imp);

    // 同时把 Monitor 的“实际读事务”广播给 Scoreboard 的 actual 端口
    agt_o.monitor.ap.connect(scb.act_imp);

    // Reference Model 把“期望读事务”送到 Scoreboard 的 expected 端口
    refm.ap.connect(scb.exp_imp);

      endfunction

endclass

`endif

