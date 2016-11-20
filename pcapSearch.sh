#!/bin/bash
#
# The MIT License (MIT)
#
# Copyright (c) <2015> <Michael J. Mavroudis - michael.j.mavroudis@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

function use {
	echo ""
	echo "Usage: $0 file.pcap"
	echo ""
	echo "  Filter by SRC Number"
	echo "    --src=8005551212"
	echo ""
	echo "  Filter by DST Number"
	echo "    --dst=8005551212"
	echo ""
	echo "  Filter by IP Address"
	echo "    --ip=127.0.0.1"
	echo ""
        echo "  Open results in Wireshark"
        echo "    --ws"
	echo ""
        echo "  Open results in sngrep"
        echo "    --sn"
	echo ""
	exit 1
}

# OPTIONS CHECKS

if [ $# -lt 2 ]; then
	use
fi

for opt in "$@"; do

	optkey=$(echo $opt | cut -f 1 -d '=')
	optval=$(echo $opt | cut -f 2 -d '=')

	if [ $optkey == '--src' ]; then
		cmd="$cmd(sip.From contains $optval)"
	fi

	if [ $optkey == '--dst' ]; then
		cmd="$cmd(sip.To contains $optval)"
	fi

	if [ $optkey == '--ip' ]; then
		cmd="$cmd(ip.addr==$optval)"
	fi

	if [ $optkey == '--ws' ]; then
		out="`which wireshark`"
	fi

	if [ $optkey == '--sn' ]; then
		out="`which sngrep` -I"
	fi

done

if [ -n "$cmd" ]; then
	pcap=`(date +"%s")`.pcap
	`which tshark` -r $1 -Y "${cmd//)(/) and (}" -w $pcap &>/dev/null
	# Older Versions
	# `which tshark` -r $1 -R "${cmd//)(/) and (}" -w $pcap &>/dev/null
	if [ "$(stat -c%s $pcap)" == "80" ]; then
		rm -f $pcap
		echo "Call(s) not found!"
		exit 1
	fi
	if [ -n "$out" ]; then
		$out $pcap
		rm -f $pcap
	fi
else
	use
fi
