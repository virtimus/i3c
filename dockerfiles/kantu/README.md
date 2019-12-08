
##Kanu automation in docker containaer

Needs some preparations:

- create /i3c/.overrides/i3c-run-config.sh file with at least:

xhost + ( to allow x-win access from external hosts)
cp (Your macros) /i3c/.secrets/.secrets/kantu/*.json


- konfigure firefox after first start

about:config
xpinstall.signatures.required;false


https://addons.mozilla.org/pl/firefox/addon/custom-right-click-menu/

https://greasyfork.org/en/scripts/32-show-password-onmouseover/code?locale_override=1
