## Pipelined MIPS Processor in SystemVerilog (Verilog)

This repository implements a 32-bit pipelined MIPS architecture using SystemVerilog.

**Structure:**

* **RTL/**: Source code for the pipelined MIPS processor
    * `MIPS_top.sv`: Top-level module integrating all components
    * `MIPS_datapath.sv`: Datapath for the pipelined MIPS processor
    * `MIPS_control.sv`: Control unit for the pipelined MIPS processor
    * `Main_control.sv`: Main control unit logic
    * `ALUControl.sv`: Decodes ALU operations
    * `Forwarding.sv`: Handles data forwarding between stages
    * `Hazard_detection.sv`: Detects data and control hazards
    * `ALU.sv`: Arithmetic Logic Unit
    * `PC.sv`: Program Counter
    * `InstructionMemory.sv`: Instruction memory model
    * `DataMemory.sv`: Data memory model
    * `RegisterFile.sv`: Register file model
* **Memory_Initialization/**: Initialization files for memories
    * `InstructionMemory.dat`: Initial instruction memory contents
    * `DataMemory.dat`: Initial data memory contents
    * `RegisterFile.dat`: Initial register file contents
* **Verification/**: Testbench and test code
    * `MIPS_tb.sv`: Testbench for simulation
    * `test_code.s`: MIPS assembly test code
* **Documentation/**: Documentation
    * `MIPS_pipelined_documentation.pdf`: Detailed design explanation

## Getting Started

### Prerequisites

- ModelSim/QuestaSim for simulation
- Quartus Prime for synthesis, place-and-route, and timing analysis

### Running Simulations

1. Clone the repository by typing the following command in your terminal
```bash
git clone https://github.com/amrelbatarny/MIPS_Pipelined_32bit
```
2. Open ModelSim/QuestaSim

3. From the `File` menu, click on `Change directory` and navigate to the `Verification` directory

4. From the `Transcript` window run the following TCL command to run the script file
```tcl
do run_MIPS.do
```


**Further Resources:**

The included documentation provides a detailed explanation of the design and implementation process (refer to `Documentation` / `MIPS_pipelined_documentation.pdf`).

**Contribution:**

We welcome contributions to this educational project. Feel free to submit pull requests for improvements or additional features.

**Contact:**

Click on the image

<a href="https://beacons.ai/amrelbatarny" target="_blank">
  <img align="left" alt="Beacons" width="180px" src="https://www.colormango.com/development/boxshot/beacons-ai_154511.png" />
</a> 
<br>
