PLUGIN.name = "Business Block"
PLUGIN.desc = "Turns off business for EVERYONE"
PLUGIN.license =  "MIT not for use on Kaktusownia opensource.org/licenses/MIT"

function PLUGIN:CanPlayerUseBusiness()
    return false
end