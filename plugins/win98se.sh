#!/bin/sh
set -e
#Windows 98 SE Setup plugin for multicd.sh
#version 5.7
#Copyright for this script (c) 2010 maybeway36
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
if [ $1 = scan ];then
	if [ -f win98se.iso ];then
		echo "Windows 98 SE (Not open source - do not distribute)"
		touch tags/win9x
	fi
elif [ $1 = copy ];then
	if [ -f win98se.iso ];then
		echo "Copying Windows 98 SE..."
		if [ ! -d win98se ];then
			mkdir win98se
		fi
		if grep -q "`pwd`/win98se" /etc/mtab ; then
			umount win98se
		fi
		mount -o loop win98se.iso win98se/
		cp -r win98se/win98 multicd-working/
		rm -r multicd-working/win98/ols
		cp -r win98se/tools multicd-working/w98tools
		umount win98se;rmdir win98se
		dd if=win98se.iso bs=1 skip=43008 count=1474560 of=multicd-working/boot/win98se.img
		if which mdel 2> /dev/null;then
			mdel -i multicd-working/boot/win98se.img ::JO.SYS #Disable HD/CD boot prompt - not needed, but a nice idea
		fi
	fi
elif [ $1 = writecfg ];then
if [ -f win98se.iso ];then
echo "label win98se
menu label Windows ^98 Second Edition Setup
kernel memdisk
initrd /boot/win98se.img">>multicd-working/boot/isolinux/isolinux.cfg
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi