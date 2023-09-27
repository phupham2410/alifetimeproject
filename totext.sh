
if [ $# -ne "1" ]; then
	echo "Target dir not found"
	exit
fi

d=$(date '+%Y-%m-%d-%H%M%S')
wrkdir=$(pwd)

logname="tarlog"
tmpname="tempdir"
prjname=$1
#branch="pb-cmodel"
branch="dzb"

tarname="$prjname.$branch.$d.tar"
txtname="$prjname.$branch.$d.txt"

tmpdir="./$tmpname"
prjdir="./$prjname"
logdir="./$logname"
spldir="$logdir/$d"

tarfile="$logdir/$tarname"
txtfile="$logdir/$txtname"
splfile="$spldir/$txtname"

curgit="$prjdir/.git"
newgit="$tmpdir/.git"

part=0
if [ $# -ne "0" ]; then
	part=$(($1))
fi

[ ! -d "$tmpdir" ] && mkdir -p "$tmpdir"
[ ! -d "$logdir" ] && mkdir -p "$logdir"

mv $curgit $newgit

tar -cvzf $tarfile $prjdir
cat $tarfile | base64 > $txtfile

if [ -d "$newgit" ]; then
	mv $newgit $curgit
fi

echo "###: $(du -b $txtfile)"

rm -rf $tmpdir

echo "Size: $(du -b $txtfile) /Split: $part"

if [ $part -gt "1" ]; then
	mkdir -p $spldir
	cp $txtfile $splfile
	cd $spldir
	split -n $part $txtname
	cd $wrkdir
	rm -rf $splfile
	notepad $spldir/* &
else
	notepad $txtfile &	
fi