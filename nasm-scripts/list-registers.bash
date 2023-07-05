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
    echo al cl dl bl
    ;;

hi*)
    echo ah ch dh bh
    ;;

16*)
    echo ax cx dx bx sp bp si di
    ;;

32e*)
    echo eax ecx edx ebx esp ebp esi edi r8d r9d r10d r11d r12d r13d r14d r15d
    ;;

32*)
    echo eax ecx edx ebx esp ebp esi edi
    ;;

64*)
    echo rax rcx rdx rbx rsp rbp rsi rdi r8 r9 r10 r11 r12 r13 r14 r15
    ;;

*)
    echo "Unknown register type '$register_type'" >&2
    exit 1
    ;;
esac
