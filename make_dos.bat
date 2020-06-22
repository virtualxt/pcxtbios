@echo off

rem *** Set listing=1 to generate listing file (requires 386+)
rem *** Set floppy=1 to include Sergey's Floppy BIOS
rem *** Set ide=1 to include XT-IDE BIOS
rem *** Set basic=1 to include IBM ROM BASIC

set bios=pcxtbios
set listing=1

set floppy=0
set ide=0
set basic=1

if exist %bios%.obj del %bios%.obj
if exist %bios%.lst del %bios%.lst
if exist %bios%.exe del %bios%.exe
if exist %bios%.bin del %bios%.bin

@echo *******************************************************************************
@echo Assembling BIOS
@echo *******************************************************************************
dos\wasmr -zcm=tasm -d1 -e=1 -fe=nul -fo=%bios%.obj %bios%.asm
if errorlevel 1 goto errasm
if not exist %bios%.obj goto errasm

if %listing%==0 goto link
@echo.
@echo *******************************************************************************
@echo Generating Listing
@echo *******************************************************************************
set oldpath=%path%
set path=%path%;dos\
dos\wdis -l=%bios%.lst -s=%bios%.asm %bios%.obj
if errorlevel 1 goto errlist
if not exist %bios%.lst goto errlist
set path=%oldpath%
echo Ok

:link
@echo.
@echo *******************************************************************************
@echo Linking BIOS
@echo *******************************************************************************
dos\warplink /wn pcxtbios.obj,pcxtbios.exe
del %bios%.obj
if not exist %bios%.exe goto errlink

@echo *******************************************************************************
@echo Building ROM Images
@echo *******************************************************************************

dos\exe2rom /8 %bios%.exe %bios%.bin
del %bios%.exe

if exist test\picoxt.exe dos\inject /70D0 %bios%.bin test\picoxt.exe

if not exist eproms\nul       mkdir eproms
if not exist eproms\2764\nul  mkdir eproms\2764
if not exist eproms\27128\nul mkdir eproms\27128
if not exist eproms\27256\nul mkdir eproms\27256
if not exist eproms\27512\nul mkdir eproms\27512
if not exist eproms\ibmxt\nul mkdir eproms\ibmxt

if %floppy%==1 dos\romfill /8 images\floppy\floppy22.bin eproms\2764\floppy22.rom
if %ide%==1    dos\romfill /8 images\xt-ide\xtide591.bin eproms\2764\xtide591.rom
if %basic%==1  dos\romfill /8 images\basicc11.f6         eproms\2764\basicf6.rom
if %basic%==1  dos\romfill /8 images\basicc11.f8         eproms\2764\basicf8.rom
if %basic%==1  dos\romfill /8 images\basicc11.fa         eproms\2764\basicfa.rom
if %basic%==1  dos\romfill /8 images\basicc11.fc         eproms\2764\basicfc.rom
               dos\romfill /8 %bios%.bin                 eproms\2764\%bios%.rom
if %floppy%==0 del eproms\2764\floppy22.rom >nul
if %ide%==0    del eproms\2764\xtide591.rom >nul
if %basic%==0  del eproms\2764\basicf6.rom  >nul
if %basic%==0  del eproms\2764\basicf8.rom  >nul
if %basic%==0  del eproms\2764\basicfa.rom  >nul
if %basic%==0  del eproms\2764\basicfc.rom  >nul

if %floppy%==1 dos\romfill /16 images\floppy\floppy22.bin eproms\27128\floppy22.rom
if %ide%==1    dos\romfill /16 images\xt-ide\xtide591.bin eproms\27128\xtide591.rom
if %basic%==1  dos\romfill /16 images\basicc11.f6         eproms\27128\basicf6.rom
if %basic%==1  dos\romfill /16 images\basicc11.f8         eproms\27128\basicf8.rom
if %basic%==1  dos\romfill /16 images\basicc11.fa         eproms\27128\basicfa.rom
if %basic%==1  dos\romfill /16 images\basicc11.fc         eproms\27128\basicfc.rom
               dos\romfill /16 %bios%.bin                 eproms\27128\%bios%.rom
if %floppy%==0 del eproms\27128\floppy22.rom >nul
if %ide%==0    del eproms\27128\xtide591.rom >nul
if %basic%==0  del eproms\27128\basicf6.rom  >nul
if %basic%==0  del eproms\27128\basicf8.rom  >nul
if %basic%==0  del eproms\27128\basicfa.rom  >nul
if %basic%==0  del eproms\27128\basicfc.rom  >nul

if %floppy%==1 dos\romfill /32 images\floppy\floppy22.bin eproms\27256\floppy22.rom
if %ide%==1    dos\romfill /32 images\xt-ide\xtide591.bin eproms\27256\xtide591.rom
if %basic%==1  dos\romfill /32 images\basicc11.f6         eproms\27256\basicf6.rom
if %basic%==1  dos\romfill /32 images\basicc11.f8         eproms\27256\basicf8.rom
if %basic%==1  dos\romfill /32 images\basicc11.fa         eproms\27256\basicfa.rom
if %basic%==1  dos\romfill /32 images\basicc11.fc         eproms\27256\basicfc.rom
               dos\romfill /32 %bios%.bin                 eproms\27256\%bios%.rom
if %floppy%==0 del eproms\27256\floppy22.rom >nul
if %ide%==0    del eproms\27256\xtide591.rom >nul
if %basic%==0  del eproms\27256\basicf6.rom  >nul
if %basic%==0  del eproms\27256\basicf8.rom  >nul
if %basic%==0  del eproms\27256\basicfa.rom  >nul
if %basic%==0  del eproms\27256\basicfc.rom  >nul

if %floppy%==1 dos\romfill /64 images\floppy\floppy22.bin eproms\27512\floppy22.rom
if %ide%==1    dos\romfill /64 images\xt-ide\xtide591.bin eproms\27512\xtide591.rom
if %basic%==1  dos\romfill /64 images\basicc11.f6         eproms\27512\basicf6.rom
if %basic%==1  dos\romfill /64 images\basicc11.f8         eproms\27512\basicf8.rom
if %basic%==1  dos\romfill /64 images\basicc11.fa         eproms\27512\basicfa.rom
if %basic%==1  dos\romfill /64 images\basicc11.fc         eproms\27512\basicfc.rom
               dos\romfill /64 %bios%.bin                 eproms\27512\%bios%.rom
if %floppy%==0 del eproms\27512\floppy22.rom >nul
if %ide%==0    del eproms\27512\xtide591.rom >nul
if %basic%==0  del eproms\27512\basicf6.rom  >nul
if %basic%==0  del eproms\27512\basicf8.rom  >nul
if %basic%==0  del eproms\27512\basicfa.rom  >nul
if %basic%==0  del eproms\27512\basicfc.rom  >nul

if exist eproms\ibmxt\u18.rom del eproms\ibmxt\u18.rom
if exist eproms\ibmxt\u19.rom del eproms\ibmxt\u19.rom
copy images\blank32.bin eproms\ibmxt\u18.rom
copy images\blank32.bin eproms\ibmxt\u19.rom
if %floppy%==1 dos\inject /0000 images\floppy\floppy22.bin eproms\ibmxt\u19.rom
if %ide%==1    dos\inject /2000 images\xt-ide\xtide591.bin eproms\ibmxt\u19.rom
if %basic%==1  dos\inject /6000 images\basicc11.f6         eproms\ibmxt\u19.rom
if %basic%==1  dos\inject /0000 images\basicc11.f8         eproms\ibmxt\u18.rom
if %basic%==1  dos\inject /2000 images\basicc11.fa         eproms\ibmxt\u18.rom
if %basic%==1  dos\inject /4000 images\basicc11.fc         eproms\ibmxt\u18.rom
               dos\inject /6000 %bios%.bin                 eproms\ibmxt\u18.rom

@echo *******************************************************************************
@echo SUCCESS!: BIOS successfully built
@echo *******************************************************************************
goto end

:errasm
@echo.
@echo.
@echo *******************************************************************************
@echo ERROR: Error assembling BIOS
@echo *******************************************************************************
goto end

:errlist
@echo.
@echo.
@echo *******************************************************************************
@echo ERROR: Error generating listing file
@echo *******************************************************************************
set path=%oldpath%
goto end

:errlink
@echo.
@echo.
@echo *******************************************************************************
@echo ERROR: Error linking BIOS
@echo *******************************************************************************
goto end

:end
if exist %bios%.obj del %bios%.obj
if exist %bios%.exe del %bios%.exe

set bios=
set listing=
set floppy=
set ide=
set basic=

pause
