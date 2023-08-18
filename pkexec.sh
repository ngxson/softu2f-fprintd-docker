#!/bin/bash

# This is a dummy "pkexec" that have only one purpose: exit 0 if user authenticate successfully

check_fprintd_verify() {
    timeout 20 fprintd-verify $USER > /tmp/_fprintd_output.txt
    if grep -q "verify-match" /tmp/_fprintd_output.txt; then
        echo "OK"
        rm /tmp/_fprintd_output.txt
        exit 0
    else
        echo "ERR"
        rm /tmp/_fprintd_output.txt
        exit 2
    fi
}

check_fprintd_verify
