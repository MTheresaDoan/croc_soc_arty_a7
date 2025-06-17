<<<<<<< HEAD
bender script vivado -t fpga -t rtl -t nexys4_ddr > scripts/add_sources.nexys4_ddr.tcl
mkdir -p build/nexys4_ddr.clkwiz
cd build/nexys4_ddr.clkwiz && \
    vitis-2022.1 vivado -mode batch -log ../nexys4_ddr.clkwiz.log -jou ../nexys4_ddr.clkwiz.jou \
    -source ../../scripts/impl_ip.tcl \
    -tclargs nexys4_ddr clkwiz \
    && cd ../..
mkdir -p build/nexys4_ddr.vio
cd build/nexys4_ddr.vio &&
    vitis-2022.1 vivado -mode batch -log ../nexys4_ddr.vio.log -jou ../nexys4_ddr.vio.jou \
    -source ../../scripts/impl_ip.tcl \
    -tclargs nexys4_ddr vio\
    && cd ../..
mkdir -p build/nexys4_ddr.croc
cd build/nexys4_ddr.croc && \
    vitis-2022.1 vivado -mode batch -log ../croc.nexys4_ddr.log -jou ../croc.nexys4_ddr.jou \
    -source ../../scripts/impl_sys.tcl \
    -tclargs nexys4_ddr croc \
    ../nexys4_ddr.clkwiz/out.xci \
    ../nexys4_ddr.vio/out.xci
=======
bender script vivado -t fpga -t rtl -t nexys-a7-100t > scripts/add_sources.nexys-a7-100t.tcl
mkdir -p build/nexys-a7-100t.clkwiz
cd build/nexys-a7-100t.clkwiz && \
    vivado -mode batch -log ../nexys-a7-100t.clkwiz.log -jou ../nexys-a7-100t.clkwiz.jou \
    -source ~/veron_github/croc_soc/xilinx/scripts/impl_ip_nexys-a7-100t.tcl \
    -tclargs nexys-a7-100t clkwiz \
    && cd ../..
mkdir -p build/nexys-a7-100t.vio
cd build/nexys-a7-100t.vio &&
    vivado -mode batch -log ../nexys-a7-100t.vio.log -jou ../nexys-a7-100t.vio.jou \
    -source ~/veron_github/croc_soc/xilinx/scripts/impl_ip_nexys-a7-100t.tcl \
    -tclargs nexys-a7-100t vio\
    && cd ../..
mkdir -p build/nexys-a7-100t.croc
cd build/nexys-a7-100t.croc && \
    vivado -mode batch -log ../croc.nexys-a7-100t.log -jou ../croc.nexys-a7-100t.jou \
    -source ~/veron_github/croc_soc/xilinx/scripts/impl_sys_nexys-a7-100t.tcl \
    -tclargs nexys-a7-100t croc \
    ../nexys-a7-100t.clkwiz/out.xci \
    ../nexys-a7-100t.vio/out.xci
>>>>>>> aaa1214 (Sua constrain xpr)
