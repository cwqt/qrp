# qrp

*Quick Rotonde Poster*, a simple cli utility for posting to [Rotonde](https://github.com/Rotonde).

![](https://ftp.cass.si/==AO2ETO5k.png)

## Installation 
Assuming [luarocks](https://luarocks.org/) is already installed.

```
git clone git@gitlab.com:cxss/qrp.git
cd qrp
luarocks install moonscript rxi-log-lua
moonc main.moon
chmod +x qrp
ln -s log /usr/local/share/lua/5.3/log
ln -s /Users/$whoami/Code/Software/qrp/qrp /usr/local/bin/qrp
```
