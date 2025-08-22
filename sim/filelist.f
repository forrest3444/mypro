# ========= Include Dirs =========
+incdir+../dut
+incdir+../env
+incdir+../sequences
+incdir+../tests
+incdir+../tb

# ========= DUT =========
../dut/axi_ram.v

# ========= ENV =========
../env/axi_if.sv
../env/axi_driver.sv
../env/axi_monitor.sv
../env/axi_agent.sv
../env/axi_scoreboard.sv
../env/axi_reference.sv
../env/axi_env.sv

# ========= SEQUENCES =========
../sequences/axi_sequence_item.sv      
../sequences/axi_sequencer.sv
../sequences/axi_sequence.sv

# ========= TESTS =========
../tests/axi_base_test.sv
../tests/smoke_test.sv
# (后续新增 test 都要加在这里)

# ========= TB =========
../tb/axi_ram_tb.sv

