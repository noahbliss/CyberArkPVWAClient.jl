module CyberArkPVWAClient

# Exports first. -- The functions we want to get exported when using is called on this module.
#export login,

# Imports second. -- Import gives us all the functions, but doesn't define them globally. E.g. HTTP.request() but not request()
import HTTP
import JSON

# Using third. -- Same as import but exported functions are available globally as well.


greet() = print("Hello World!")






end # module
