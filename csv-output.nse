-- The Head Section
description = [[A script to output nmap data to CSV format.
The output contains the host, its IP address, the scanned port, the protocol, the port state, the service and its version]]

---
-- @usage
-- nmap -A --script csv-output --script-args=filename=myscan.csv <target>
-- nmap -v0 -A --scirpt csv-output <target> # -v0 suppress any other output so only have the CSV data
-- @args
-- filename: name of the csv file (default outputs to stdout)

author     = "Théophile Choutri"
license    = "MIT"
categories = {"external","safe"}

local nmap = require "nmap"

-- The Rule Section

local escapeCSV, to_CSV

function prerule ()
  file:write("hostname,ip,port,protocol,state,service,version,os\n") -- This will be the header of the CSV file
end

portrule = function() return true end
postrule = function() return true end

local file
if (nmap.registry.args.filename~=nil) then
  local filename = nmap.registry.args.filename
  file = io.open(filename, "a")
else
  file = io.stdout
end


-- This is where everything happens
function portaction (host, port)
  local version = ""

  if (port.version.product ~= nil) then
    version = port.version.product 
  end

  if (port.version.version ~= nil) then
    version = version .. " " .. port.version.version
  end

  if (host.os ~= nil) and 
     (host.os[1]["name"] ~= nil) then
      local os = host.os[1]["name"]
  else
      local os = "Unknown"
  end

  local data = { host.name .. "," .. host.ip .. "," .. port.number .. "," .. port.protocol ..
           "," .. port.state .. "," .. port.service .. "," .. version .. "," .. os
         }

  -- write_as_csv(file,data)
  local csv_data = to_CSV(data)
  file:write(csv_data)

end


function postaction ()
  io.close(file)
end


local actiontable = {
  portrule = portaction,
  postrule = postaction
}

action = function(...) return actiontable[SCRIPT_TYPE](...) end

-- CSV Utils

-- Used to escape "'s by toCSV
function escapeCSV (s)
  if string.find(s, '[,"]') then
    s = string.gsub(s, '"', '""')
  end
  return s
end

function to_CSV (tt)
  local s = ""

  for _,p in ipairs(tt) do  
    s = s .. "," .. escapeCSV(p) .. '\n'
  end
  return string.sub(s, 2)      -- remove first comma
end
