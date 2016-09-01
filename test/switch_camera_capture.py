# Shao Depeng 20150804 v0.1
# c_dshao@qti.qualcomm.com

#! /usr/bin/env python
import os
import commands
import shutil
import time


def CHECK():
	out=commands.getoutput("adb shell ps")
	result=out.find('org.codeaurora.snapcam')
	if (result == -1):
		print("snap exit")
		time.sleep(5)
		shutil.move("log.txt", "bak.txt")
		raw_input("pause, press any key to exit")
		os._exit()
	else:
		print("running")

COUNTER_F=0
COUNTER_B=0

os.system("adb logcat -v time > log.txt &")

while 1:
	# take picture - back
	COUNTER_B=COUNTER_B+1
	print("take capture %d times - E" %COUNTER_B)
	os.system("adb shell input tap 540 1800")
	print("take capture %d times - X" %COUNTER_B)
	time.sleep(2)
	CHECK()

	# switch camera
	os.system("adb shell input tap 545 123")
	print("switch camera back --> front")
	time.sleep(2)

	CHECK()

	# take picture - front
	COUNTER_F=COUNTER_F+1
	print("take picture %d times - E" %COUNTER_F)
	os.system("adb shell input tap 540 1800")
	print("take picture %d times - X" %COUNTER_F)
	time.sleep(2)

	CHECK()

	# switch camera
	os.system("adb shell input tap 545 123")
	print("switch camera front --> back")
	time.sleep(2)

	CHECK()
