#!/usr/bin/env bash

mnemonics=${1:-mov}
n_operands=${2:-2}
op_mode=${3:-16}

echo "[bits $op_mode]"

case $op_mode in
16)
    r8="$(list-registers lo) $(list-registers hi)"
    r16="$(list-registers 16)"

    for src in $r8; do
        for dest in $r8; do
            echo "        $mnemonics $dest, $src"
        done
    done

    for src in $r16; do
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
