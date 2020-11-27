#!/bin/sh
export LC_CTYPE="en_US.UTF-8"
if [ -n  "$1" ]; then 
	host_va=$1
else
	host_va="null"
fi

expect -c "
#if [ string compare  $host_va \"null\" ] {send \" a am true\"}
spawn ssh name@your relay -p port
set timeout 3
expect  \"Password:\"
set password \"your relay password\"
send \"\$password\r\"
set timeout 3
expect \"Verification code:\"
set authcode \"`oathtool --totp -b -d 6 your two factor authcode`\"
send \"\$authcode\r\"
expect \"*->*\"
set timeout 3
if [ string compare $host_va \"null\" ] {
send \"\s $host_va\n\"
set timeout 3
expect \"\*\:\~\$\*\"
} 
interact
"
