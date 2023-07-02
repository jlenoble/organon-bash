#!/usr/bin/env bash

register_type=${1:-all}

case $register_type in
all)
    $0 lo
    $0 hi
    $0 16
    $0 32e
    $0 64
    ;;

lo*)
    echo al bl cl dl
    ;;

hi*)
    echo ah bh ch dh
    ;;

16*)
    echo ax bx cx dx di si bp sp
    ;;

32e*)
    echo eax ebx ecx edx edi esi ebp esp r8d r9d r10d r11d r12d r13d r14d r15d
    ;;

32*)
    echo eax ebx ecx edx edi esi ebp esp
    ;;

64*)
    echo rax rbx rcx rdx rdi rsi rbp rsp r8 r9 r10 r11 r12 r13 r14 r15
    ;;

*)
    echo "Unknown register type '$register_type'" >&2
    exit 1
    ;;
esac
