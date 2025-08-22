# 仿真器
VCS = vcs -sverilog -full64 -timescale=1ns/1ps -ntb_opts uvm-1.2

# 目录
BUILD_DIR = ../build
FILELIST  = filelist.f

# 默认目标
all: simv

# 编译
simv: $(FILELIST)
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && \
	$(VCS) -f ../sim/$(FILELIST) -l compile.log -o simv

# 运行
run: simv
	cd $(BUILD_DIR) && ./simv +UVM_TESTNAME=$(TEST) -l run.log

# 清理
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run clean

