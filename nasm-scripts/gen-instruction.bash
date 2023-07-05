#!/usr/bin/env bash

mnemonics=${1:-mov}
n_operands=${2:-2}
op_mode=${3:-16}

imm8="0 12 16 150"
imm16="0 12 16 150 1000 32768 50000"

echo "[bits $op_mode]"

case $op_mode in
16)
    r8="$(list-registers lo) $(list-registers hi)"
    r16="$(list-registers 16)"

    # r8, r8
    for src in $r8; do
        for dest in $r8; do
            echo "        $mnemonics $dest, $src"
        done
    done

    # r16, r16
    for src in $r16; do
        for dest in $r16; do
            echo "        $mnemonics $dest, $src"
        done
    done

    # r8, imm
    for src in $imm8; do
        for dest in $r8; do
            echo "        $mnemonics $dest, $src"
        done
    done

    # r16, imm
    for src in $imm16; do
        for dest in $r16; do
            echo "        $mnemonics $dest, $src"
        done
    done
    ;;

*)
    echo "Bad op_mode; Should be 16 | 32 | 64" >&2
    exit 1
    ;;
esac
