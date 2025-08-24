`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "smoke_test.sv"


module axi_ram_tb;

logic clk;
logic rst_n;

initial clk = 0;
always #5 clk = ~clk;

initial begin
	rst_n = 0;
	#100;
	rst_n = 1;
end

axi_if #(
	.ADDR_WIDTH(32),
	.DATA_WIDTH(32),
	.ID_WIDTH(4)
) axi_if_inst (
	.clk (clk),
	.rst_n(rst_n)
);

axi_ram #(
	.ADDR_WIDTH(16),
	.DATA_WIDTH(32),
	.ID_WIDTH(4)
) dut (
	.clk (clk),
	.rst (~rst_n),

	.s_axi_awid (axi_if_inst.awid),
	.s_axi_awaddr (axi_if_inst.awaddr),
	.s_axi_awlen (axi_if_inst.awlen),
	.s_axi_awsize (axi_if_inst.awsize),
	.s_axi_awburst (axi_if_inst.awburst),
	.s_axi_awvalid (axi_if_inst.awburst),
	.s_axi_awready (axi_if_inst.awready),

	.s_axi_wdata (axi_if_inst.wdata),
	.s_axi_wstrb (axi_if_inst.wstrb),
	.s_axi_wlast (axi_if_inst.wlast),
	.s_axi_wvalid (axi_if_inst.wvalid),
	.s_axi_wready (axi_if_inst.wready),

	.s_axi_bid (axi_if_inst.bid),
	.s_axi_bresp (axi_if_inst.bresp),
	.s_axi_bvalid (axi_if_inst.bvalid),
	.s_axi_bready (axi_if_inst.bready),

	.s_axi_arid (axi_if_inst.arid),
	.s_axi_araddr (axi_if_inst.araddr),
	.s_axi_arlen (axi_if_inst.arlen),
	.s_axi_arsize (axi_if_inst.arsize),
	.s_axi_arburst (axi_if_inst.arburst),
	.s_axi_arvalid (axi_if_inst.arvalid),
	.s_axi_arready (axi_if_inst.arready),

	.s_axi_rid (axi_if_inst.rid),
	.s_axi_rdata (axi_if_inst.rdata),
	.s_axi_rresp (axi_if_inst.rresp),
	.s_axi_rlast (axi_if_inst.rlast),
	.s_axi_rvalid (axi_if_inst.rvalid),
	.s_axi_rready (axi_if_inst.rready)
);

initial begin
  // 给 env 下的 agent 的 driver、monitor 传 interface
  uvm_config_db#(virtual axi_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", axi_if_inst);
  uvm_config_db#(virtual axi_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", axi_if_inst);

  run_test("smoke_test");
end


initial begin
	run_test("smoke_test");
end

endmodule
