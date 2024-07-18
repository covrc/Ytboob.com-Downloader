# Ytboob.com-Downloader
A command line video downloader for ytboob.com

A command line video downloader created for ytboob.com

```git clone https://github.com/covrc/Ytboob.com-Downloader``` to copy repository. 


After clonning repo run ```sudo apt install luarocks wget```
```luarocks install luasocket```
```luarocks install luasec``` to install dependencies

```lua/luajit ytboob.lua URL``` to download URL.

Code depends to wget and does not use it's own download function because in some conditions download fails with this way. F.e. if link contains timestamp like "https://vidhost.me/videos/thereisnotavideo.mp4#t=08m57s" download fails.
