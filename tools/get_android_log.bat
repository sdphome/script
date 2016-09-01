echo off
echo off

set Today=%date: =%
echo,%Today%

for /f "tokens=1,2 delims=/" %%i in ("%Today%") do (
	set mm=%%i
	set dd=%%j
)

SET date=%mm%-%dd%

set tmp_time=%time:~-11,2%%time:~-8,2%%time:~-5,2%
set tmp_time=%tmp_time: =%
set d=%date%_%tmp_time%
mkdir "%d%"
echo %d%

adb wait-for-devices
adb root
adb wait-for-devices
adb remount
adb wait-for-devices
adb logcat -c
adb shell sync
mkdir "%d%"
adb root
pause
adb logcat -c
start cmd /c "adb logcat -v threadtime > %d%\logcat.txt"
start cmd /c "adb logcat -b radio -v threadtime > %d%\radiologs.txt"
start cmd /c "adb logcat -b main -v threadtime > %d%\mainlogs.txt"
start cmd /c "adb logcat -b system -v threadtime > %d%\systemlogs.txt"
start cmd /c "adb logcat -b events -v threadtime > %d%\eventlogs.txt"
start cmd /c "adb shell cat /proc/kmsg > %d%\kernel.txt"
start cmd /c "adb shell dmesg > %d%\dmesg.txt"
start cmd /c "adb shell top -t > %d%\threads.txt"