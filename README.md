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
target = "dc01.domain.local"
reason = "Because I want to."
accountid = "23_7"

psmrdpfile = CyberArkPVWAClient.psmconnect(pvwauri, cookieset, accountid, reason, target)

filename = "rdpswap.rdp"
open(filename, "w")
write(filename, psmrdpfile)
run(`ca-rdp $filename`)
```

To make this process a bit more human-friendly, you can use the following function.
```
function getaccountid(username, address, connection, caaccounts)
        for acc in caaccounts["Accounts"]#[1]
                if acc["Properties"]["UserName"] == username &&
                acc["Properties"]["Address"] == address &&
                haskey(acc["ActionsDisplay"]["ConnectionDisplay"]["ConnectionComponents"], connection)
                        return acc["AccountID"]
                end
        end
end

username = "domain-admin"
address = "domain.local"
connection = "PSM-RDP"

accountid = getaccountid(username, address, connection, accountsresult)

```
