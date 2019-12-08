#!/bin/bash

distKantu='/src/kantu/dist_ff'
outFile=$distKantu'/pi.in2'
distI3C='/src/i3cExt'
outFileI3C=$distI3C'/pi.in2'
#/src/config/preinstall_macros.js
#echo "export default {" > $outFile
echo "outFile:$outFile"
echo "test" > $outFile
cat >$outFile << EOF
/* generated from ... */ 

var preinstall_macros = ({
});
var opener =  window.parent;
//lert('Browser is run from i3c/kantu container'); // needed for proper macros loading (async effects?)
function sleep (time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}

preinstall_macros = ({
        
EOF

cat >$outFileI3C << EOF
<!-- generated from ... -->    	
EOF
        	

con=""
for filename in /run/secrets/kantu/*.json; do
	bName=$(basename "$filename" .json)
	echo $con"\""$bName"\": " >> $outFile
	cat $filename >> $outFile
	con=","
	
	echo '<div class="button kantuMacro">'$bName'</div>' >> $outFileI3C
done
#echo "}" >> $outFile
cat >>$outFile << EOF
        });        


EOF
 


tPath=$distKantu'/pi.in2'
tPathT=$distKantu'/popup.js'
tPath2=$distKantu'/popup-out.js'
#
#
lead='^\/\/ CONCATENATED MODULE: \.\/src\/config\/preinstall_macros\.js$'
tail='^\/\/ CONCATENATED MODULE: \.\/src\/config\/preinstall_suites\.js$'
#lead='^### BEGIN I3C AUTOCONF ###$'
#tail='^### END I3C AUTOCONF ###$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r $tPath
        }; /$tail/p; d }" $tPathT > $tPath2

cp $tPath2 $tPathT


tPath=$distI3C'/pi.in2'
tPathT=$distI3C'/popup/choose_script.html'
tPath2=$distI3C'/popup/choose_script_dist.html'
#
#
#lead='^\/\/ CONCATENATED MODULE: \.\/src\/config\/preinstall_macros\.js$'
#tail='^\/\/ CONCATENATED MODULE: \.\/src\/config\/preinstall_suites\.js$'
lead='^###KRMPOSSTART###$'
tail='^###KRMPOSEND###$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r $tPath
        }; /$tail/p; d }" $tPathT > $tPath2

cp $tPath2 $tPathT






