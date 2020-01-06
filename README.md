# scripts

## Motorsports
```
initial_setup.ps1
```
This script will create three new accounts:
- fsaeadmin (Admin)
- hson (Admin) <--- optional
- local (Local) 

In addition, it will run the pre-written script to activate Microsoft Office license (specific to Cooper Union Motorsports FSAE)

```
post_setup.ps1
```
This script will: 
1) Enable Windows Firewall
2) Retrieve and record IP and MAC address of the computer into a textfile of the same directory where the script is placed.
3) Enable Remote Desktop Protocol 
4) Change Remote Desktop Protocol port number
