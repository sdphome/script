#!/bin/bash
SUFFIX=$(date +%Y%m%d -d "today")
COUNTER_F=389
COUNTER_B=389

adb logcat -v time > log.txt &

while true
do
	# take picture - back
	let COUNTER_B=COUNTER_B+1
	echo take capture $COUNTER_B times - E 
	adb shell input tap 540 1600
	echo take capture $COUNTER_B times - X
	sleep 2

OUT=$(adb shell ps | grep org.codeaurora.snapcam)
if [ "$OUT" ]; then
	echo "here"
else
	echo "snap exit"
	sleep 5
	cp log.txt bak.txt
	exit
fi

	# switch camera
	adb shell input tap 545 123
	echo "switch camera back --> front"
	sleep 2

OUT=$(adb shell ps | grep org.codeaurora.snapcam)
if [ "$OUT" ]; then
	echo "here"
else
	echo "snap exit"
	sleep 5
	cp log.txt bak.txt
	exit
fi

	# take picture - front
	let COUNTER_F=COUNTER_F+1
	echo take picture $COUNTER_F times - E 
	adb shell input tap 540 1600
	echo take picture $COUNTER_F times - X
	sleep 2

OUT=$(adb shell ps | grep org.codeaurora.snapcam)
if [ "$OUT" ]; then
	echo "here"
else
	echo "snap exit"
	sleep 5
	cp log.txt bak.txt
	exit
fi

	# switch camera
	adb shell input tap 545 123
	echo "switch camera front --> back"
	sleep 2

OUT=$(adb shell ps | grep org.codeaurora.snapcam)
if [ "$OUT" ]; then
	echo "here"
else
	echo "snap exit"
	sleep 5
	cp log.txt bak.txt
	exit
fi

done
