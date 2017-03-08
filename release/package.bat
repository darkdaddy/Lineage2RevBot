
@SET VERSION=0.5
@SET SOURCE_DIR=..\..\Lineage2RevBot
@SET TARGET=Lineage2RevBot
@SET TARGET_DIR=.\

@SET ZIP_7Z_FILE=7z\7z.exe
@SET ARCHIVE_FILE_NAME=%TARGET%_%VERSION%.zip

rmdir /Q /S %TARGET_DIR%\%TARGET%
mkdir %TARGET_DIR%\%TARGET%

copy %SOURCE_DIR%\Lineage2Rev.exe %TARGET_DIR%\%TARGET%\ 

::============================================
:: Archive zip file..
::============================================
del /F/Q/S %ARCHIVE_FILE_NAME%
%ZIP_7Z_FILE% a -tzip %TARGET_DIR%\%ARCHIVE_FILE_NAME% %TARGET_DIR%\%TARGET%

pause
