@echo off
@echo off
set "kernel=dmesg.txt"
set "file=tmp"

set Today=%date: =%

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

:start

adb reboot
timeout /t 2 /nobreak > nul
adb wait-for-devices
adb shell dmesg > %d%\dmesg.txt
adb root
adb wait-for-devices
adb root
adb wait-for-devices
adb remount
adb wait-for-devices

del %d%\logcat.txt
del %d%\radiologs.txt
del %d%\mainlogs.txt
del %d%\systemlogs.txt
del %d%\eventlogs.txt
del %d%\kernel.txt
del %d%\threads.txt
del %d%\tmp
del %d%\tmp1
del %d%\tmp2
del %d%\dmesg1.txt

start cmd /c "adb logcat -v threadtime > %d%\logcat.txt"
start cmd /c "adb logcat -b radio -v threadtime > %d%\radiologs.txt"
start cmd /c "adb logcat -b main -v threadtime > %d%\mainlogs.txt"
start cmd /c "adb logcat -b system -v threadtime > %d%\systemlogs.txt"
start cmd /c "adb logcat -b events -v threadtime > %d%\eventlogs.txt"
start cmd /c "adb shell cat /proc/kmsg > %d%\kernel.txt"
start cmd /c "adb shell top -t > %d%\threads.txt"

timeout /t 2 /nobreak > nul
adb shell dmesg > %d%\dmesg1.txt
timeout /t 1 /nobreak > nul

findstr /C:"msm_csid_reset failed" %d%\dmesg.txt  > %d%\%file%
findstr /C:"msm_csid_reset failed" %d%\kernel.txt  > %d%\tmp1
findstr /C:"msm_csid_reset failed" %d%\dmesg1.txt  > %d%\tmp2

for %%a in ("%d%\%file%") do (
	if "%%~za" equ "0" (
		set "flag=0"
	) else (
		set "flag=1"
	)
)

for %%a in ("%d%\tmp1") do (
	if "%%~za" equ "0" (
		echo ""
	) else (
		set "flag=1"
	)
)

for %%a in ("%d%\tmp2") do (
	if "%%~za" equ "0" (
		echo ""
	) else (
		set "flag=1"
	)
)

if %flag% equ 1 (
	echo "#######csid error!.!.!######"
	echo "Byebye"
) else (
	echo "No csid error."
	goto start
)

pause