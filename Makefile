#
# Make file for the RISC-V MIA module.
#

# Define the work directory, and if necessary any other variables.
WORKDIR=work

help:
	@echo "Each of the 5 parts has a job for itself and its testbench, e.g.:"
	@echo "  - alu"
	@echo "  - test_alu"
	@echo ""
	@echo "You can simply analyze and elaborate by calling one of the jobs,"
	@echo "and run its testbench by simply calling one of the test jobs, e.g."
	@echo "  make alu"
	@echo ""
	@echo "The possible make targets are: alu, test_alu, im, test_im,"
	@echo "  ram, test_ram, regs, test_regs, sync, test_sync,"
	@echo "  riscv, test_riscv, clean, and help"
	@echo ""


# Create the work directory if not created or silently do nothing
work:
	mkdir -p work


# Analyze and elaborate ALU.
alu: work
	ghdl -a --workdir=$(WORKDIR) --std=08 ALU/alu.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 ALU


# Test the ALU.
test_alu: alu
	ghdl -a --workdir=$(WORKDIR) --std=08 ALU/testbench.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 testbench
	ghdl -r --workdir=$(WORKDIR) --std=08 testbench --wave=$(WORKDIR)/alu.ghw 


# Analyze and elaborate instruction memory.
im: work
	ghdl -a --workdir=$(WORKDIR) --std=08 Instruction_Memory/package.vhd
	ghdl -a --workdir=$(WORKDIR) --std=08 Instruction_Memory/instruction_memory.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 Instruction_Memory


# Test the instruction memory.
test_im: im
	ghdl -a --workdir=$(WORKDIR) --std=08 Instruction_Memory/testbench.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 tb_instruction_memory 
	ghdl -r --workdir=$(WORKDIR) --std=08 tb_instruction_memory -wave=$(WORKDIR)/im.ghw 


# Analyze and elaborate the inferred RAM.
ram: work
	ghdl -a --workdir=$(WORKDIR) --std=08 RAM/package.vhd
	ghdl -a --workdir=$(WORKDIR) --std=08 RAM/RAM.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 ram_infer


# Test the inferred RAM.
test_ram: ram
	ghdl -a --workdir=$(WORKDIR) --std=08 RAM/testbench.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 testbench
	ghdl -r --workdir=$(WORKDIR) --std=08 testbench --wave=$(WORKDIR)/ram.ghw 


# Analyze and elaborate the Registers.
regs: work
	ghdl -a --workdir=$(WORKDIR) --std=08 Registers/package.vhd
	ghdl -a --workdir=$(WORKDIR) --std=08 Registers/FF_D.vhd
	ghdl -a --workdir=$(WORKDIR) --std=08 Registers/RISCV_Register.vhd
	ghdl -a --workdir=$(WORKDIR) --std=08 Registers/register_file.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 RISCV_register_file


# Test the registers.
test_regs: regs
	ghdl -a --workdir=$(WORKDIR) --std=08 Registers/testbench.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 testbench
	ghdl -r --workdir=$(WORKDIR) --std=08 testbench --wave=$(WORKDIR)/registers.ghw 


# Analyze and elaborate the ALU synchronizer.
sync: work
	ghdl -a --workdir=$(WORKDIR) --std=08 Synchroniser/ALU_Synchronizer.vhd
	ghdl -e --workdir=$(WORKDIR) --std=08 ALU_Synchronizer


# Test, when available, the ALU synchronizer.
test_sync: sync
	echo "No test for this yet."


# Analyze and elaborate the whole thing!
riscv: work alu im ram regs sync 
	ghdl -a --workdir=$(WORKDIR) --std=08 pkg.vhd
	ghdl -a --workdir=$(WORKDIR) --std=08 riscv.vhd


# Test, when available, the whole thing!
test_riscv: riscv
	echo "No test for this yet."


# Clean up after ourselves.
clean:
	rm -rf work
