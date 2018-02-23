@echo off
title 备份分区二进制文件  by MIUI论坛_浅蓝的灯
mode con lines=28 cols=64
color 8f
REM ________________________________________________________________

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (

    echo 请求管理员权限...

    goto UACPrompt

) else ( goto gotAdmin )

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
exit /B

:gotAdmin

    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
	goto A

REM ________________________________________________________________



:A
Rem 删除临时文件
del %TempFile_Name% 1>nul 2>nul
CLS
color 3f
mode con lines=36 cols=80
cd /d %~dp0
ECHO. ==============================================================
ECHO. 备份分区二进制文件  by MIUI论坛_浅蓝的灯
ECHO.
ECHO. 手机需开启USB调试并与电脑连接，正确安装好adb驱动（可以先安装小米助手）
ECHO.
echo  关闭所有助手类软件(建议在任务管理器结束进程)
ECHO. ==============================================================
ECHO.
PAUSE
cls
ECHO. ====================================================
ECHO.
ECHO. 正在尝试重启ADB服务~
ECHO.
ECHO. ====================================================
ECHO.
netstat -ano |findstr "5037"
echo.
set pid=
set /p pid= 输入LISTENING 后面的数字(没有就空着),然后后回车:
if /i "%pid%"=="" goto T
tasklist|findstr "%pid%"
echo.
taskkill /f /pid %pid%&&goto T||echo.
echo 结束进程失败，请在任务管理器手动结束后按任意键继续……
echo 进程名在“%pid%”的前面,一般为手机助手类&pause >nul

:T
echo.
taskkill /f /im adb.exe
adb kill-server
adb start-server
ping 127.0.0.1 /n 3 >nul
cls
ECHO.
ECHO  ==============================================================
ECHO.
echo 重启服务完毕，请确保下方设备列表中有你的设备。按任意键继续……
ECHO.
ECHO  ==============================================================
ECHO.
echo 设备列表：
adb devices
echo.
PAUSE >nul

:RETURN
cls
ECHO.
ECHO  请在下方输入需要备份分区的序号名，例如：mmcblk0p7
ECHO  然后设置输出文件名(不含.img)，如：aboot 然后回车继续
ECHO.
set mmc=
set /p mmc= 填写分区序号名:
echo.
set bac=
set /p bac= 设置输出文件名:
ECHO. 
ECHO  ==============================================================
ECHO    开始从手机复制分区二进制数据到 sdcard
echo.
echo    在分隔符下方是否看见 类似 如下提示,
echo.
echo    1024+0 records in
echo    1024+0 records out
echo    4194304 bytes transferred in 0.218 secs ^<19239926 bytes/sec^>
echo. 
echo    如果看到以上提示，证明复制成功，按任意键继续。
echo.
ECHO ===============================================================
echo.
echo.
adb shell su -c "dd if=/dev/block/%mmc% of=/sdcard/%bac%.img bs=4096"
ECHO.
taskkill /f /im adb.exe
pause >nul
cls
ECHO. 
echo  下面把分区备份文件保存到本目录
echo.
echo.
ECHO. ==============================================================
echo.
echo    在分隔符下方是否看见 类似 如下提示,
echo.
echo    2573 KB/s ^<4194304 bytes in 2.146s^>
echo    或者
echo    [100%] /sdcard/xxxxxx.img
echo.
echo    如果看到以上提示，证明导出成功，按任意键继续。
echo.
ECHO. ==============================================================
echo.
echo.
adb pull /sdcard/%bac%.img ./
pause >nul
cls
color cf
ECHO. ===========================================================
ECHO.
echo 请检查 %back%:/ 下否有文件生成，3后自动返回
ECHO.
ECHO. ===========================================================
ping 127.0.0.1 /n 3 >nul
GOTO RETURN
