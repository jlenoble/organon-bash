#!/usr/bin/env bash

instruction_type=${1:-all}

case $instruction_type in
all) ;;

data_transfer)
    echo MOV CMOVE CMOVZ CMOVNE CMOVNZ CMOVA CMOVNBE CMOVAE CMOVNB CMOVB CMOVNAE CMOVBE CMOVNA CMOVG CMOVNLE CMOVGE CMOVNL
    echo CMOVL CMOVNGE CMOVLE CMOVNG CMOVC CMOVNC CMOVO CMOVNO CMOVS CMOVNS CMOVP CMOVPE CMOVNP CMOVPO XCHG BSWAP XADD
    echo CMPXCHG CMPXCHG8B PUSH POP PUSHA PUSHAD POPA POPAD CWD CDQ CBW CWDE MOVSX MOVZX
    ;;

binary_arithmetic)
    echo ADCX ADOX ADD ADC SUB SBB IMUL MUL IDIV DIV INC DEC NEG CMP
    ;;

decimal_arithmetic)
    echo DAA DAS AAA AAS AAM AAD
    ;;

logical)
    echo AND OR XOR NOT
    ;;

shift_and_rotate)
    echo SAR SHR SAL SHL SHRD SHLD ROR ROL RCR RCL
    ;;

bit_and_byte)
    echo BT BTS BTR BTC BSF BSR SETE SETZ SETNE SETNZ SETA SETNBE SETAE SETNB SETNC SETB SETNAE SETC SETBE SETNA SETG SETNLE
    echo SETGE SETNL SETL SETNGE SETLE SETNG SETS SETNS SETO SETNO SETPE SETP SETPO SETNP TEST CRC32 POPCNT
    ;;

control_transfer)
    echo JMP JE JZ JNE JNZ JA JNBE JAE JNB JB JNAE JBE JNA JG JNLE JGE JNL JL JNGE JLE JNG JC JNC JO JNO JS JNS JPO JNP JPE JP
    echo JCXZ JECXZ LOOP LOOPZ LOOPE LOOPNZ LOOPNE CALL RET IRET INT INTO BOUND ENTER LEAVE
    ;;

string)
    echo MOVS MOVSB MOVSW MOVSD CMPS CMPSB CMPSW CMPSD SCAS SCASB SCASW SCASD LODS LODSB LODSW LODSD STOS STOSB STOSW STOSD
    echo REP REPE REPZ REPNE REPNZ
    ;;

io)
    echo IN OUT INS INSB INSW INSD OUTS OUTSB OUTSW OUTSD
    ;;

enter_and_leave)
    echo ENTER LEAVE
    ;;

flag_control)
    echo STC CLC CMC CLD STD LAHF SAHF PUSHF PUSHFD POPF POPFD STI CLI
    ;;

segment_register)
    echo LDS LES LFS LGS LSS
    ;;

miscellaneous)
    echo LEA NOP UD XLAT XLATB CPUID MOVBE PREFETCHW PREFETCHWT1 CLFLUSH CLFLUSHOPT
    ;;

user_mode_extended_state_save_restore)
    echo XSAVE XSAVEC XSAVEOPT XRSTOR XGETBV
    ;;

random_number_generator)
    echo RDRAND RDSEED
    ;;

bmi1_bmi2)
    echo ANDN BEXTR BLSI BLSMSK BLSR BZHI LZCNT MULX PDEP PEXT RORX SARX SHLX SHRX TZCNT
    ;;

x87_fpu_data_transfer)
    echo FLD FST FSTP FILD FIST FISTP FBLD FBSTP FXCH FCMOVE FCMOVNE FCMOVB FCMOVBE FCMOVNB FCMOVNBE FCMOVU FCMOVNU
    ;;

x87_fpu_basic_arithmetic)
    echo FADD FADDP FIADD FSUB FSUBP FISUB FSUBR FSUBRP FISUBR FMUL FMULP FIMUL FDIV FDIVP FIDIV FDIVR FDIVRP FIDIVR FPREM
    echo FPREM1 FABS FCHS FRNDINT FSCALE FSQRT FXTRACT
    ;;

x87_fpu_comparison)
    echo FCOM FCOMP FCOMPP FUCOM FUCOMP FUCOMPP FICOM FICOMP FCOMI FUCOMI FCOMIP FUCOMIP FTST FXAM
    ;;

X87_fpu_transcendental)
    echo FSIN FCOS FSINCOS FPTAN FPATAN F2XM1 FYL2X FYL2XP1
    ;;

x87_fpu_load_constants)
    echo FLD1 FLDZ FLDPI FLDL2E FLDLN2 FLDL2T FLDLG2
    ;;

x87_fpu_control)
    echo FINCSTP FDECSTP FFREE FINIT FNINIT FCLEX FNCLEX FSTCW FNSTCW FLDCW FSTENV FNSTENV FLDENV FSAVE FNSAVE FRSTOR FSTSW
    echo FNSTSW WAIT FWAIT FNOP
    ;;

x87_fpu_and_simd_state_management)
    echo FXSAVE FXRSTOR
    ;;

mmx_data_transfer)
    echo MOVD MOVQ
    ;;

mmx_conversion)
    echo PACKSSWB PACKSSDW PACKUSWB PUNPCKHBW PUNPCKHWD PUNPCKHDQ PUNPCKLBW PUNPCKLWD PUNPCKLDQ
    ;;

mmx_packed_arithmetic)
    echo PADDB PADDW PADDD PADDSB PADDSW PADDUSB PADDUSW PSUBB PSUBW PSUBD PSUBSB PSUBSW PSUBUSB PSUBUSW PMULHW PMULLW PMADDWD
    ;;

mmx_comparison)
    echo PCMPEQB PCMPEQW PCMPEQD PCMPGTB PCMPGTW PCMPGTD
    ;;

mmx_logical)
    echo PAND PANDN POR PXOR
    ;;

mmx_shift_and_rotate)
    echo PSLLW PSLLD PSLLQ PSRLW PSRLD PSRLQ PSRAW PSRAD
    ;;

mmx_state_management)
    echo EMMS
    ;;

sse_data_transfer)
    echo MOVAPS MOVUPS MOVHPS MOVHLPS MOVLPS MOVLHPS MOVMSKPS
    ;;

sse_packed_arithmetic)
    echo ADDPS ADDSS SUBPS SUBSS MULPS MULSS DIVPS DIVSS RCPPS RCPSS SQRTPS SQRTSS RSQRTPS RSQRTSS MAXPS MAXSS MINPS MINSS
    ;;

sse_comparison)
    echo CMPPS CMPSS COMISS UCOMISS
    ;;

sse_logical)
    echo ANDPS ANDNPS ORPS XORPS
    ;;

sse_shuffle_and_unpack)
    echo SHUFPS UNPCKHPS UNPCKLPS
    ;;

sse_conversion)
    echo CVTPI2PS CVTSI2SS CVTPS2PI CVTTPS2PI CVTSS2SI CVTTSS2SI
    ;;

sse_mxcsr_state_management)
    echo LDMXCSR STMXCSR
    ;;

sse_64bit_simd_integer)
    echo PAVGB PAVGW PEXTRW PINSRW PMAXUB PMAXSW PMINUB PMINSW PMOVMSKB PMULHUW PSADBW PSHUFW
    ;;

sse_cacheability_control_prefetch_and_instruction_ordering)
    echo MASKMOVQ MOVNTQ MOVNTPS PREFETCHh SFENCE
    ;;

sse2_data_movement)
    echo MOVAPD MOVUPD MOVHPD MOVLPD MOVMSKPD MOVSD
    ;;

sse2_packed_arithmetic)
    echo ADDPD ADDSD SUBPD SUBSD MULPD MULSD DIVPD DIVSD SQRTPD SQRTSD MAXPD MAXSD MINPD MINSD
    ;;

sse2_logical)
    echo ANDPD ANDNPD ORPD XORPD
    ;;

sse2_compare)
    echo CMPPD CMPSD COMISD UCOMISD
    ;;

sse2_shuffle_and_unpack)
    echo SHUFPD UNPCKHPD UNPCKLPD
    ;;

sse2_conversion)
    echo CVTPD2PI CVTTPD2PI CVTPI2PD CVTPD2DQ CVTTPD2DQ CVTDQ2PD CVTPS2PD CVTPD2PS CVTSS2SD CVTSD2SS CVTSD2SI CVTTSD2SI CVTSI2SD
    ;;

sse2_packed_single_precision_floating_point)
    echo CVTDQ2PS CVTPS2DQ CVTTPS2DQ
    ;;

sse2_128bit_simd_integer)
    echo MOVDQA MOVDQU MOVQ2DQ MOVDQ2Q PMULUDQ PADDQ PSUBQ PSHUFLW PSHUFHW PSHUFD PSLLDQ PSRLDQ PUNPCKHQDQ PUNPCKLQDQ
    ;;

sse2_cacheability_control_and_ordering)
    echo CLFLUSH LFENCE MFENCE PAUSE MASKMOVDQU MOVNTPD MOVNTDQ MOVNTI
    ;;

sse3_x87_fp_integer_conversion)
    echo FISTTP
    ;;

sse3_specialized_128bit_unaligned_data_load)
    echo LDDQU
    ;;

sse3_simd_floating_point_packed_add_sub)
    echo ADDSUBPS ADDSUBPD
    ;;

sse3_simd_floating_point_horizontal_add_sub)
    echo HADDPS HSUBPS HADDPD HSUBPD
    ;;

sse3_simd_floating_point_load_move_duplicate)
    echo MOVSHDUP MOVSLDUP MOVDDUP
    ;;

sse3_agent_synchronisation)
    echo MONITOR MWAIT
    ;;

horizontal_addition_subtraction)
    echo PHADDW PHADDSW PHADDD PHSUBW PHSUBSW PHSUBD
    ;;

packed_absolute_values)
    echo PABSB PABSW PABSD
    ;;

multiply_and_add_packed_signed_and_unsigned_bytes)
    echo PMADDUBSW
    ;;

packed_multiply_high_with_round_and_scale)
    echo PMULHRSW
    ;;

packed_shuffle_bytes)
    echo PSHUFB
    ;;

packed_sign)
    echo PSIGNB PSIGNW PSIGND
    ;;

packed_align_right)
    echo PALIGNR
    ;;

dword_multiply)
    echo PMULLD PMULDQ
    ;;

floating_point_dot_product)
    echo DPPD DPPS
    ;;

streaming_load_hint)
    echo MOVNTDQA
    ;;

packed_blending)
    echo BLENDPD BLENDPS BLENDVPD BLENDVPS PBLENDVB PBLENDW
    ;;

packed_integer_min_max)
    echo PMINUW PMINUD PMINSB PMINSD PMAXUW PMAXUD PMAXSB PMAXSD
    ;;

floating_point_round_with_selectable_rounding_mode)
    echo ROUNDPS ROUNDPD ROUNDSS ROUNDSD
    ;;

insertion_and_extractions_from_xmm_registers)
    echo EXTRACTPS INSERTPS PINSRB PINSRD PINSRQ PEXTRB PEXTRW PEXTRD PEXTRQ
    ;;

packed_integer_format_converions)
    echo PMOVSXBW PMOVZXBW PMOVSXBD PMOVZXBD PMOVSXWD PMOVZXWD PMOVSXBQ PMOVZXBQ PMOVSXWQ PMOVZXWQ PMOVSXDQ PMOVZXDQ
    ;;

improved_sums_of_absolute_differences_for_4byte_blocks)
    echo MPSADBW
    ;;

horizontal_search)
    echo PHMINPOSUW
    ;;

packed_test)
    echo PTEST
    ;;

packed_qword_equality_comparisons)
    echo PCMPEQQ
    ;;

dword_packing_with_unsigned_saturation)
    echo PACKUSDW
    ;;

string_and_text_proceqing)
    echo PCMPESTRI PCMPESTRM PCMPISTRI PCMPISTRM
    ;;

packed_comparison_simd_integer)
    echo PCMPGTQ
    ;;

*)
    echo "Unknown instruction type '$instruction_type'" >&2
    exit 1
    ;;
esac
