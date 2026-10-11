//I am trying to create a Verilog model binary_to_bcd_converter for a binary to binary-coded-decimal converter. It must meet the following specifications:
//	- Inputs:
//		- Binary input (5-bits)
//	- Outputs:
//		- BCD (8-bits: 4-bits for the 10's place and 4-bits for the 1's place)
//
//How would I write a design that meets these specifications?

module binary_to_bcd_converter (
    input [4:0] binary_input,
    output [7:0] bcd_output
);