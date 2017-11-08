@echo off
title 获取aboot.img  by MIUI论坛_浅蓝的灯
mode con lines=28 cols=64
color 8f
Rem 创建文件路径
echo. 
echo 检测运行环境ing…… 请稍后
ping 127.0.0.1 /n 2 /w 1200 >nul
echo.
set TempFile_Name=%SystemRoot%\System32\BatTestUACin_SysRt%Random%.batemp
echo %TempFile_Name%

Rem 写入文件
( echo "BAT Test UAC in Temp" >%TempFile_Name% ) 1>nul 2>nul
 
Rem 判断写入是否成功
if exist %TempFile_Name% (
color af
echo.
echo 正在以管理员身份运行当前批处理，即将进入下一步
ping 127.0.0.1 /n 3 >nul
goto A
) else (
color cf
echo.
echo 检测失败，没有以管理员身份运行当前批处理
echo.
echo 请按任意键退出,然后 右键-以管理员身份运行
)
pause >nul
exit

:A
Rem 删除临时文件
del %TempFile_Name% 1>nul 2>nul
CLS
color 3f
mode con lines=36 cols=80
cd /d %~dp0
ECHO. ==============================================================
ECHO. 获取aboot.img  by MIUI论坛_浅蓝的灯
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
cls
ECHO.
ECHO  请在下方输入aboot分区的序号名，例如：mmcblk0p7
ECHO  然后回车继续
ECHO.
set mmc=
set /p mmc= 分区序号名:
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
adb shell su -c "dd if=/dev/block/%mmc% of=/sdcard/aboot.img bs=4096"
ECHO.
pause >nul
cls
ECHO. 
echo  下面把 aboot.img 文件保存到电脑上，输入需要保存的磁盘(纯字母)，例如：D
echo.
set back=
set /p back= 保存到:
cls
echo.
ECHO. ==============================================================
echo.
echo    在分隔符下方是否看见 类似 如下提示,
echo.
echo    2573 KB/s ^<4194304 bytes in 2.146s^>
echo    或者
echo    [100%] /sdcard/aboot.img
echo.
echo    如果看到以上提示，证明导出成功，按任意键继续。
echo.
ECHO. ==============================================================
echo.
echo.
adb pull /sdcard/aboot.img %back%:/
pause >nul
cls
ECHO. ===========================================================
ECHO.
echo 请检查 %back%:/ 下否有文件生成，本软件将于3秒后自动退出
ECHO.
ECHO. ===========================================================
ping 127.0.0.1 /n 4 >nul
start %back%:/
exit 