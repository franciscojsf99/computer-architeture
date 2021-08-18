APPLICATION: p3print.bat
AUTHOR: Nuno Roma <Nuno.Roma@inesc-id.pt>
DATE: 29/03/2006
DESCRIPTION: script to pretty-print P3 assembly files in postscript
USAGE: 1. Copy the assembly file into the p3print base directory;
       2. Run the command: 'p3print.bat <prog.as>';
       3. The output file 'prog.as.ps' will be created in the base directory;
       4. Open and print the postscript file using the GhostView program.
       
NOTE: This script is based on the popular "a2ps" program using the following arguments:
      a2ps -r --medium=a4 --columns=2 --tabsize=8 --sides=duplex --pretty-print=p3 %1 -o %1.ps
