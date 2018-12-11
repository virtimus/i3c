REM https://github.com/virtimus/i3c


PowerShell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

PowerShell Start-BitsTransfer -source https://raw.githubusercontent.com/virtimus/i3c/master/bootstrap.bat -destination bootstrap.bat

bootstrap.bat


echo "run 'Bash on Ubuntu on Windows' console - this should check out and install i3c.cloud platform from this github repo"
echo "echo 192.168.99.100 i3c.h > windows/system32/drivers/etc/hosts"
echo "echo 192.168.99.100 ovas.i3c.h > windows/system32/drivers/etc/hosts"
echo "theN: /i up i3cp"
echo "theN: /i up ovas"
echo "theN: https://ovas.i3c.h:8443"

