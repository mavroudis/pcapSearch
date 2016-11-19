###About

Simple pcap search using tshark

###Description

pcapSearch utilizes [TShark](https://www.wireshark.org/docs/wsug_html_chunked/AppToolstshark.html) a network protocol analyzer for simple filtering of previously saved capture files. It optionally displays the results in [Wireshark](https://www.wireshark.org/) or [sngrep](https://github.com/irontec/sngrep).

###Usage

	./pcapSearch.sh file.pcap

	Filter by SRC Number
	--src=8005551212

	Filter by DST Number
 	--dst=8005551212

	Filter by IP Address
	--ip=127.0.0.1

	Open results in Wireshark
	--ws

	Open results in sngrep
	--sn

###Contributors

Contributors are welcome.
