// env/axi_agent.sv
`ifndef AXI_AGENT_SV
`define AXI_AGENT_SV

`include "uvm_macros.svh"   // UVM 宏
import uvm_pkg::*;          // UVM 包
`include "axi_sequence_item.sv" // transaction 类型（如果用到了）
`include "axi_driver.sv"
`include "axi_monitor.sv"
`include "axi_sequencer.sv"

class axi_agent extends uvm_agent;

	`uvm_component_utils(axi_agent);
  // 参数：决定 agent 是否激活
  bit is_active;

  // 组件句柄
  axi_driver      driver;
  axi_monitor     monitor;
  uvm_sequencer #(axi_sequence_item) sequencer;

  // 构造函数
  function new(string name, uvm_component parent);
    super.new(name, parent);
    is_active = 1; // 默认激活
  endfunction

  // build_phase 创建子组件
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = uvm_sequencer #(axi_sequence_item)::type_id::create("sequencer", this);
    driver    = axi_driver::type_id::create("driver", this);
    monitor   = axi_monitor::type_id::create("monitor", this);
  endfunction

  // connect_phase 连接 driver 和 sequencer
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif

