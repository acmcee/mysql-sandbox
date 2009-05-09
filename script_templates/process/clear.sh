#!_BINBASH_
__LICENSE__

#-----------------------------------------
SBDIR="_HOME_DIR_/_SANDBOXDIR_"
. "$SBDIR/sandbox_env"
#-----------------------------------------
cd $SBDIR

#
# attempt to drop databases gracefully
#
if [ -f $PIDFILE ]
then
    for D in `echo "show databases " | ./use -B -N | grep -v "^mysql$" | grep -v "^information_schema$"` 
    do
        echo 'drop database `'$D'`' | ./use 
    done
    VERSION=`./use -N -B  -e 'select version()'`
    if [ `perl -le 'print $ARGV[0] ge "5.1" ? "1" : "0" ' "$VERSION"` = "1" ]
    then
        ./use -e "truncate mysql.general_log"
        ./use -e "truncate mysql.slow_log"
    fi
fi

./stop
#./send_kill
rm -f data/`hostname`*
rm -f data/log.0*
rm -f data/*.log
rm -f data/falcon*
rm -f data/mysql-bin*
rm -f data/*relay-bin*
rm -f data/ib*
rm -f data/*.info
rm -f data/*.err
rm -f data/*.err-old
# rm -rf data/test/*

#
# remove all databases if any
#
for D in `ls -d data/*/ | grep -w -v mysql ` 
do
    rm -rf $D
done
mkdir data/test

