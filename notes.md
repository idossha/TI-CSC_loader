for windows:

if you are running wsl 2 backend, you want to have a .wslconfig file with resource allocation.

Example:

C:\Users\<YourUsername>\.wslconfig   #important, do not have a .txt extention created by notepad.

```bash
[wsl2]
memory=8GB          # Limits VM memory in WSL 2 to 8 GB
processors=4        # Allocates 4 CPU cores to WSL 2
swap=16GB           # Sets swap space to 16 GB
localhostForwarding=true  # Enables localhost forwarding
```
wait 10 secons

wsl --shutdown

close docker 

close terminal

open docker

open powershell

docker info

assess resources. 
