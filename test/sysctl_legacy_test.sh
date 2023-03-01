#!/usr/bin/bash
#
# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
#
# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.

# run sysctl test

. ./test_lib.sh


SLEEPTIME=1

for TUNER in neigh_table ; do

   test_start "$0|sysctl legacy test: does setting sysctl switch off tuner?"

   test_setup "true"

   if [[ ${BPFTUNE_LEGACY} -eq 1 ]]; then
	echo "sysctl test not supported for legacy mode, skipping..."
	test_pass
	test_cleanup
	test_exit
   fi

   test_run_cmd_local "$BPFTUNE -dsL &" true

   sleep $SLEEPTIME
   for SYSCTL in kernel.core_pattern net.ipv4.neigh.default.gc_thresh1 ; do
	val=$(sysctl -qn $SYSCTL)
	sysctl -qw ${SYSCTL}=${val}
   done
   sleep $SLEEPTIME
   grep "modified sysctl" $TESTLOG_LAST
   test_pass

   test_cleanup
done

test_exit
