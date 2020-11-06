module CyberArkPVWAClient

# Exports first. -- The functions we want to get exported when using is called on this module.
#export login,

# Imports second. -- Import gives us all the functions, but doesn't define them globally. E.g. HTTP.request() but not request()
import HTTP
import JSON

# Using third. -- Same as import but exported functions are available globally as well.


# Returns a set of cookies that must be used for subsequent requests.
function login(pvwauri, method, causer, capass)
        pvwahost = match(r"^http[s]?://(.*)/.*", pvwauri).captures[1]
        cookiejar = Dict{String, Set{HTTP.Cookie}}()
        uri = "$pvwauri/api/auth/$method/logon"
        headers = ["Content-Type" => "application/json"]
        payload = Base.SecretBuffer(JSON.json(Dict(
                "username" => causer,
                "password" => read(capass, String),
                "newPassword" => nothing,
                "type" => method,
                "secureMode" => true,
                "additionalInfo" => ""
        )))
        Base.shred!(capass)
        response = HTTP.request("POST", uri, headers, read(payload,String); require_ssl_verification = false, cookies = true, cookiejar = cookiejar)
        Base.shred!(payload)
        if response.status == 200 # This should probably be a try/catch
                return cookiejar[pvwahost]
        else
                error("Response not 200.")
        end
end

# Requests your query, returns the JSON response as a data structure.
# usage: webreq("https://cyberark.org.local/PasswordVault", cookieset, "ExtendedAccounts")
function webreq(pvwauri, cookieset, query)
        uri = "$pvwauri/api/$query"
        pvwahost = match(r"^http[s]?://(.*)/.*", pvwauri).captures[1]
        cookiejar = Dict{String, Set{HTTP.Cookie}}(pvwahost => cookieset)
        headerauth = "" # Lets us use the value in the scope of the whole function.
        for cookie in cookieset
                if cookie.name == "CA66666"
                        headerauth = cookie.value
                end
        end
        headers = ["Content-Type" => "application/json", "X-CA66666" => headerauth ]
        response = HTTP.request("GET", uri, headers; require_ssl_verification = false, cookies = true, cookiejar = cookiejar)
        #return String(response.body)
        if response.status == 200
                return JSON.parse(String(response.body))
        else
                error(response.status)
        end
        # return response.body
end


end # module
