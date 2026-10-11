//Let us make a brand new microprocessor design together. We’re severely constrained on space and I/O. 
//We have to fit in 1000 standard cells of an ASIC, 
//so I think we will need to restrict ourselves to an accumulator based 8-bit architecture with no multi-byte instructions. 
//
//The microarchitecture is suggested complete an instruction in 2 stages
//The instruction shall implement the following ISA:
//
//Memory instructions use a 3-bit opcode and a 5-bit address:
//000: LDA — load M[address] into ACC.
//001: STA — store ACC in M[address].
//010: ADD — add M[address] to ACC.
//011: SUB — subtract M[address] from ACC.
//100: AND — bitwise AND.
//101: OR — bitwise OR.
//110: XOR — bitwise XOR.
//
//1110iiii: ADDI — add the unsigned 4-bit immediate iiii to ACC.
//
//The following are complete instruction bytes:
//F0: JMP — jump to ACC.
//F1: JSR — save the next instruction address in ACC and jump to the old ACC.
//F2: BEQ_FWD — if ACC is zero, add 2 to the already-incremented PC.
//F3: BEQ_BWD — if ACC is zero, subtract 3 from that PC.
//F4: BNE_FWD — same forward branch when ACC is nonzero.
//F5: BNE_BWD — same backward branch when ACC is nonzero.
//F6: SHL — shift ACC left by 1.
//F7: SHR — shift ACC right by 1.
//F8: SHL4 — shift ACC left by 4.
//F9: ROL — rotate ACC left by 1.
//FA: ROR — rotate ACC right by 1.
//FB: LDAR — load M[ACC] into ACC.
//FC: DEC — subtract 1 from ACC.
//FD: CLR — clear ACC.
//FE: INV — invert every ACC bit.
//FF: HLT — stop execution until reset.
//
//Use an 8-bit register named acc.
//Use a 5-bit register named pc.
//Use a shared instruction/data memory named mem with 32 entries of 8 bits.



module cpu_8_bit (
    input clk,
    input reset_n
);