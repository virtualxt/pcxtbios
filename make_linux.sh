#!/bin/bash

# *** Set floppy=1 to include Sergey's Floppy BIOS
# *** Set ide=1 to include XT-IDE BIOS
# *** Set basic=1 to include IBM ROM BASIC

bios=pcxtbios

floppy=0
ide=0
basic=1

function goto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

rm -f $bios.obj 2>/dev/null
rm -f $bios.lst 2>/dev/null
rm -f $bios.exe 2>/dev/null
rm -f $bios.bin 2>/dev/null

chmod +x linux/*

echo "*******************************************************************************"
echo "Assembling BIOS"
echo "*******************************************************************************"
linux/wasm -zcm=tasm -d1 -e=1 -fe=/dev/null -fo=$bios.obj $bios.asm
if [ $? = "1" ]; then goto errasm; fi
if [ ! -e "$bios.obj" ]; then goto errasm; fi

echo
echo "*******************************************************************************"
echo "Generating Listing"
echo "*******************************************************************************"
linux/wdis -l=$bios.lst -s=$bios.asm $bios.obj
if [ $? = "1" ]; then goto errlist; fi
if [ ! -e "$bios.lst" ]; then goto errlist; fi
echo Ok

echo
echo "*******************************************************************************"
echo "Linking BIOS"
echo "*******************************************************************************"
linux/wlink format dos name $bios.exe file $bios.obj
rm -f $bios.obj 2>/dev/null
if [ ! -e "$bios.exe" ]; then goto errlink; fi

echo
echo "*******************************************************************************"
echo "Building ROM Images"
echo "*******************************************************************************"

linux/exe2rom /8 $bios.exe $bios.bin
rm -f $bios.exe 2>/dev/null

if [ -e "test/picoxt.exe" ]; then linux/inject /70D0 $bios.bin test/picoxt.exe; fi

mkdir eproms       2>/dev/null
mkdir eproms/2764  2>/dev/null
mkdir eproms/27128 2>/dev/null
mkdir eproms/27256 2>/dev/null
mkdir eproms/27512 2>/dev/null
mkdir eproms/ibmxt 2>/dev/null

if [ $floppy = "1" ]; then linux/romfill /8 images/floppy/floppy22.bin eproms/2764/floppy22.rom; fi
if [ $ide    = "1" ]; then linux/romfill /8 images/xt-ide/xtide591.bin eproms/2764/xtide591.rom; fi
if [ $basic  = "1" ]; then linux/romfill /8 images/basicc11.f6         eproms/2764/basicf6.rom
                           linux/romfill /8 images/basicc11.f8         eproms/2764/basicf8.rom
                           linux/romfill /8 images/basicc11.fa         eproms/2764/basicfa.rom
                           linux/romfill /8 images/basicc11.fc         eproms/2764/basicfc.rom; fi
                           linux/romfill /8 $bios.bin                  eproms/2764/$bios.rom
if [ $floppy = "0" ]; then rm -f eproms/2764/floppy22.rom 2>/dev/null; fi
if [ $ide    = "0" ]; then rm -f eproms/2764/xtide591.rom 2>/dev/null; fi
if [ $basic  = "0" ]; then rm -f eproms/2764/basicf6.rom  2>/dev/null
                           rm -f eproms/2764/basicf8.rom  2>/dev/null
                           rm -f eproms/2764/basicfa.rom  2>/dev/null
                           rm -f eproms/2764/basicfc.rom  2>/dev/null; fi

if [ $floppy = "1" ]; then linux/romfill /16 images/floppy/floppy22.bin eproms/27128/floppy22.rom; fi
if [ $ide    = "1" ]; then linux/romfill /16 images/xt-ide/xtide591.bin eproms/27128/xtide591.rom; fi
if [ $basic  = "1" ]; then linux/romfill /16 images/basicc11.f6         eproms/27128/basicf6.rom
                           linux/romfill /16 images/basicc11.f8         eproms/27128/basicf8.rom
                           linux/romfill /16 images/basicc11.fa         eproms/27128/basicfa.rom
                           linux/romfill /16 images/basicc11.fc         eproms/27128/basicfc.rom; fi
                           linux/romfill /16 $bios.bin                  eproms/27128/$bios.rom
if [ $floppy = "0" ]; then rm -f eproms/27128/floppy22.rom 2>/dev/null; fi
if [ $ide = "0" ];    then rm -f eproms/27128/xtide591.rom 2>/dev/null; fi
if [ $basic  = "0" ]; then rm -f eproms/27128/basicf6.rom  2>/dev/null
                           rm -f eproms/27128/basicf8.rom  2>/dev/null
                           rm -f eproms/27128/basicfa.rom  2>/dev/null
                           rm -f eproms/27128/basicfc.rom  2>/dev/null; fi

if [ $floppy = "1" ]; then linux/romfill /32 images/floppy/floppy22.bin eproms/27256/floppy22.rom; fi
if [ $ide    = "1" ]; then linux/romfill /32 images/xt-ide/xtide591.bin eproms/27256/xtide591.rom; fi
if [ $basic  = "1" ]; then linux/romfill /32 images/basicc11.f6         eproms/27256/basicf6.rom
                           linux/romfill /32 images/basicc11.f8         eproms/27256/basicf8.rom
                           linux/romfill /32 images/basicc11.fa         eproms/27256/basicfa.rom
                           linux/romfill /32 images/basicc11.fc         eproms/27256/basicfc.rom; fi
                           linux/romfill /32 $bios.bin                  eproms/27256/$bios.rom
if [ $floppy = "0" ]; then rm -f eproms/27256/floppy22.rom 2>/dev/null; fi
if [ $ide = "0" ];    then rm -f eproms/27256/xtide591.rom 2>/dev/null; fi
if [ $basic  = "0" ]; then rm -f eproms/27256/basicf6.rom  2>/dev/null
                           rm -f eproms/27256/basicf8.rom  2>/dev/null
                           rm -f eproms/27256/basicfa.rom  2>/dev/null
                           rm -f eproms/27256/basicfc.rom  2>/dev/null; fi

if [ $floppy = "1" ]; then linux/romfill /64 images/floppy/floppy22.bin eproms/27512/floppy22.rom; fi
if [ $ide    = "1" ]; then linux/romfill /64 images/xt-ide/xtide591.bin eproms/27512/xtide591.rom; fi
if [ $basic  = "1" ]; then linux/romfill /64 images/basicc11.f6         eproms/27512/basicf6.rom
                           linux/romfill /64 images/basicc11.f8         eproms/27512/basicf8.rom
                           linux/romfill /64 images/basicc11.fa         eproms/27512/basicfa.rom
                           linux/romfill /64 images/basicc11.fc         eproms/27512/basicfc.rom; fi
                           linux/romfill /64 $bios.bin                  eproms/27512/$bios.rom
if [ $floppy = "0" ]; then rm -f eproms/27512/floppy22.rom 2>/dev/null; fi
if [ $ide = "0" ];    then rm -f eproms/27512/xtide591.rom 2>/dev/null; fi
if [ $basic  = "0" ]; then rm -f eproms/27512/basicf6.rom  2>/dev/null
                           rm -f eproms/27512/basicf8.rom  2>/dev/null
                           rm -f eproms/27512/basicfa.rom  2>/dev/null
                           rm -f eproms/27512/basicfc.rom  2>/dev/null; fi

rm -f eproms/ibmxt/u18.rom 2>/dev/null
rm -f eproms/ibmxt/u19.rom 2>/dev/null
cp -f images/blank32.bin eproms/ibmxt/u18.rom
cp -f images/blank32.bin eproms/ibmxt/u19.rom
if [ $floppy = "1" ]; then linux/inject /0000 images/floppy/floppy22.bin eproms/ibmxt/u19.rom; fi
if [ $ide    = "1" ]; then linux/inject /2000 images/xt-ide/xtide591.bin eproms/ibmxt/u19.rom; fi
if [ $basic  = "1" ]; then linux/inject /6000 images/basicc11.f6         eproms/ibmxt/u19.rom
                           linux/inject /0000 images/basicc11.f8         eproms/ibmxt/u18.rom
                           linux/inject /2000 images/basicc11.fa         eproms/ibmxt/u18.rom
                           linux/inject /4000 images/basicc11.fc         eproms/ibmxt/u18.rom; fi
                           linux/inject /6000 $bios.bin                  eproms/ibmxt/u18.rom

echo "*******************************************************************************"
echo "SUCCESS!: BIOS successfully built"
echo "*******************************************************************************"
goto end

errasm:
echo
echo
echo "*******************************************************************************"
echo "ERROR: Error assembling BIOS"
echo "*******************************************************************************"
goto end

errlist:
echo
echo
echo "*******************************************************************************"
echo "ERROR: Error generating listing file"
echo "*******************************************************************************"
goto end

errlink:
echo
echo "*******************************************************************************"
echo "ERROR: Error linking BIOS"
echo "*******************************************************************************"
goto end

end:
rm -f $bios.obj 2>/dev/null
rm -f $bios.exe 2>/dev/null

bios=
floppy=
ide=
basic=

