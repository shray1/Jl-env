# This script is used to copy shared library dependencies to chroot directory. (jailed env)
 

# Set CHROOT directory name
BASE="/home/Desktop/abc"

if [ $# -eq 0 ]; then
  echo "Syntax : $0 /path/to/executable"
  echo "Example: $0 /usr/bin/php5-cgi"
  exit 1
fi

[ ! -d $BASE ] && mkdir -p $BASE || : 

# iggy ld-linux* file as it is not shared one
FILES="$(ldd $1 | awk '{ print $3 }' |egrep -v ^'\(')"

echo "Copying shared files/libs to $BASE..."
for i in $FILES
do
  d="$(dirname $i)"
  [ ! -d $BASE$d ] && mkdir -p $BASE$d || :
  /bin/cp $i $BASE$d
done

# copy /lib/ld-linux* or /lib64/ld-linux* to $BASE/$sldlsubdir
# get ld-linux full file location 
sldl="$(ldd $1 | grep 'ld-linux' | awk '{ print $1}')"
# now get sub-dir
sldlsubdir="$(dirname $sldl)"

if [ ! -f $BASE$sldl ];
then
  echo "Copying $sldl $BASE$sldlsubdir..."
  /bin/cp $sldl $BASE$sldlsubdir
else
  :
fi