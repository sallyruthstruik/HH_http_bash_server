#!/bin/bash

REGEX_HELLO="GET*"



function get_request {
	code=$1;
	body=$2;
	now=`date`;
	echo "HTTP/1.1 ${code}
Date: ${now}
Server: Bash netcat
Content-Language: ru
Content-Type: text/html; charset=utf-8
Connection: close

${body}";

}

function parse_header {
	header=$1;

	if [[ $header =~ GET[[:space:]]/hello[[:space:]]HTTP ]]; then
		echo "Getted hello";
		get_request "200 OK" "Hello world" > file;
	elif [[ $header =~ GET[[:space:]]/echo[[:space:]]HTTP ]]; then
		cat temp.txt > file;
	else
		echo "Getted 404";
		get_request "404 Not Found" "Not Found" > file;
	fi

}

rm -f file;
mkfifo file;
while true 
do
	cat file | nc -l 1234 | (
		lines="";
		read header; 
		while read data && [ ${#data} -gt 1 ]
		do
			echo ${data};
		done > temp.txt;

		parse_header "${header}";
	)
done