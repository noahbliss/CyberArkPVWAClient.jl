# CyberarkPVWAClient.jl
Julia module for interfacing with the CyberArk PVWA REST API

Basic usage:  
```
using CyberArkPVWAClient

pvwauri = "https://cyberark.skynet.local/PasswordVault"
method = "ldap"
causer = "noah.bliss"

capass = Base.getpass("Please enter your CyberArk password")
cookieset = CyberArkPVWAClient.login(pvwauri, method, causer, capass)
accountsresult = CyberArkPVWAClient.request(pvwauri, cookieset, "ExtendedAccounts")
```

To fetch RDP files you'll need the "AccountID" which is usually `##_#` e.g. `23_1`

```
psmrdpfile = CyberArkPVWAClient.psmconnect(pvwauri, cookieset, "23_7", "Because I want to.", "someserver.skynet.local")

filename = "rdpswap.rdp"
open(filename, "w")
write(filename, psmrdpfile)
run(`ca-rdp $filename`)
```
