

if [ $# -ne "1" ]; then
	echo "Text file not found"
	exit
fi

cat $1 | base64 --decode > ./tmpfile.tar
tar -xvzf ./tmpfile.tar
rm -rf  ./tmpfile.tar