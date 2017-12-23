QSYS_GENERATE ?= $(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-generate
QUARTUS_SH ?= $(QUARTUS_ROOTDIR)/bin/quartus_sh

qsys: system.sopcinfo
sof: buildstamp

buildstamp: de0-nano-test.qpf de0-nano-test.qsf de0-nano-test.sv qsys
	$(QUARTUS_SH) --flow compile $<
	touch buildstamp

system.sopcinfo: system.qsys
	$(QSYS_GENERATE) $< --synthesis=VERILOG --simulation=VERILOG
