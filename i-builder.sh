#!/bin/bash

MAKE_OPT="$1"
shift

BLD_SCRIPT=/tmp/xxx #`mktemp`
echo "using $BLD_SCRIPT"
cat >$BLD_SCRIPT <<EOF
#!/bin/bash

echo invoked \${#@}
#MAK="make -k $MAKE_OPT"
MAK="make -k $MAKE_OPT \`echo \$@|sed 's/\.c\>/.i/g'\`"
#echo \$@|sed 's/\.c\>/.i/g'
#for file in \$@; do
#	MAK="\$MAK \${file%.c}.i"
#done
\$MAK
EOF

chmod u+x "$BLD_SCRIPT"

find . -type f -name '*.c' -exec "$BLD_SCRIPT" {} +

rm -f "$BLD_SCRIPT"
