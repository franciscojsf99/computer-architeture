echo off

REM " APPLICATION: p3print.bat                                                      "
REM " AUTHOR: Nuno Roma <Nuno.Roma@inesc-id.pt>                                     "
REM " DATE: 29/03/2006                                                              "
REM " DESCRIPTION: script to pretty-print P3 assembly files in postscript.          "
REM " USAGE: 1. Copy the assembly file into the p3print base directory;             "
REM "        2. Run the command: 'p3print.bat <prog.as>';                           "
REM "        3. The output file 'prog.as.ps' will be created in the base directory; "
REM "        4. Open and print the postscript file using the GhostView program.     "
       
REM "NOTE: This script is based on the popular "a2ps" program using the following   " 
REM "      arguments:                                                               "
REM "      a2ps -r --medium=a4 --columns=2 --tabsize=8 --sides=duplex --pretty-print=p3 %1 -o %1.ps "

if exist %1 goto convert

:error
echo ERROR: The assemby file must be located in the current directory.
echo USAGE: Open a MSDOS window and run the command:
echo        p3print <file.as>
goto end

:convert
set OLDDIR=%CD%
pushd c:\Programs\P3\GnuWin32\bin
:: copy %1 .\GnuWin32\bin\
:: cd .\GnuWin32\bin
a2ps.exe -r --medium=a4 --columns=2 --tabsize=8 --sides=duplex --pretty-print=p3 %OLDDIR%\%1 -o %OLDDIR%\%1.ps
:: move %1.ps ..\..
:: del %1
popd

:end
