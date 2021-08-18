#!/bin/bash

# APPLICATION: p3print.sh
# AUTHOR: Nuno Roma <Nuno.Roma@ist.utl.pt>
# VERSION: 2.0
# DATE: 12/05/2009
# DESCRIPTION: script to pretty-print P3 assembly files in postscript.
# USAGE: 1. Copy the assembly file into the p3print base directory;
#        2. Run the command 'p3print.sh' 
#           (run p3print.sh -h to see available options);

BASENAME=`which basename`
ICONV=`which iconv`
PS2PDF=`which ps2pdf`

# Default options
ENCODING="utf8"
FILE_TYPE="pdf"
MEDIUM="A4"
TMPFILE=`mktemp /tmp/p3print.XXXXXXXXXX`

function usage() {
  echo -e "p3print.sh  -  Version 2.0  -  Author: Nuno Roma <Nuno.Roma@ist.utl.pt>"
  echo -e "
  Usage:
  \t -h (shows this help)
  \t -f <file>\t Input file (.as)
  \t -t <option>\t Output file type: option=ps,pdf\t\t[default=pdf]
  \t -p <option>\t Printer type: option=deskjet,laserjet\t\t[default=laserjet]
  \t -e <option>\t Encoding charset: option=utf8,iso-8859-1\t[default=utf8]
  \t            \t NOTE: Most Linux text editors adopt utf8 encoding.
  \t            \t       Most MS Windows text editors adopt iso-8859-1 encoding.
  "
  exit -1
}

while getopts "hf:t:e:p:" OPT; do
    case "$OPT" in
	"h") usage;; 
	"f") FILE_IN=$OPTARG;;
	"t") if [ $OPTARG = "ps" ]; then 
	         FILE_TYPE="ps"; 
             else 
	         FILE_TYPE="pdf"; 
             fi;;
	"e") if [ $OPTARG = "iso-8859-1" ]; then 
	         ENCODING="iso-8859-1"; 
	     else 
	         ENCODING="utf8"; 
	     fi;;
	"p") if [ $OPTARG = "deskjet" ]; then 
	         MEDIUM="A4dj"; 
	     else 
	         MEDIUM="A4"; 
	     fi;;
	"?") usage; 
	     exit -1;;
    esac
done

#################### Input File #################################
if [ -z $FILE_IN ]; then
    echo -e "ERROR: Invalid input file";
    usage;
    exit -1;
else
    echo -e "Input file:\t$FILE_IN"
fi

#################### Output File ################################
FILE_OUT=`$BASENAME $FILE_IN .as`
echo -e "Output file:\t$FILE_OUT.$FILE_TYPE"

#################### Encoding ###################################
echo -e "Encoding mode:\t$ENCODING";
cp $FILE_IN $TMPFILE 
if [ $ENCODING = "utf8" ]; then 
#   echo "Converting charset to UTF-8"
    $ICONV --from-code=UTF-8 --to-code=ISO-8859-1 $FILE_IN > $TMPFILE
fi

#################### Output Medium ##############################
echo -e "Output medium:\t$MEDIUM"
echo -e "-----------------------"
#################### Generation of PS file  #####################
a2ps --center-title=$FILE_IN \
     --footer=$FILE_IN       \
     --landscape             \
     --medium=$MEDIUM        \
     --columns=2             \
     --tabsize=8             \
     --sides=duplex          \
     --pretty-print=key.ssh  \
     -o $FILE_OUT.ps         \
     $TMPFILE 

# IMPORTANT NOTE ABOUT A2PS
# Option: --pretty-print[=language]
# If language is `key.ssh', then don't look in the library path, 
# but use the file `key.ssh'. This is to ease debugging non installed 
# style sheets. 

#################### Generation of PDF file  ####################
if [ $FILE_TYPE = "pdf" ]; then 
    echo "Converting to PDF: this make take a while...."
    $PS2PDF $FILE_OUT.ps $FILE_OUT.pdf
    rm $FILE_OUT.ps
fi

#################### Removal of TMP file  #######################
rm $TMPFILE
