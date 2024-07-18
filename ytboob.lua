#!/bin/env luajit
local http = require("socket.http")
local https = require("ssl.https")
local ltn12 = require("ltn12")

local function downloadFile(url, filename)
    local protocol = string.sub(url, 1, 7) == "https://" and https or http

    local fp = io.open(filename, "wb")
    if not fp then
        print("File error")
        return false
    end

    local body, code, headers, status = protocol.request{
        url = url,
        sink = ltn12.sink.file(fp)
    }

--    fp:close()

    if code == 200 then
        print(filename .. " downloaded successfully")
        return true
    else
        print("Unable to download " .. url .. ". Error code: " .. tostring(code))
        return false
    end
end

local function main()
    if #arg < 1 then
        print("Usage: lua/luajit " .. arg[0] .. " URL")
        return 1
    end

    local url = arg[1]

    local response = nil
    if string.sub(url, 1, 7) ~= "http://" and string.sub(url, 1, 8) ~= "https://" then
        print("Only http or https URLs are supported.")
        return 1
    end

    local resp_body = {}
    local protocol = string.sub(url, 1, 7) == "https://" and https or http

    local res, code, resp_headers = protocol.request{
        url = url,
        sink = ltn12.sink.table(resp_body)
    }

    if res == 1 and code == 200 then
        response = table.concat(resp_body)
    else
        print("HTTP/HTTPS request failed. Error code: " .. tostring(code))
        return 1
    end

    local patterns = {
        mp4 = 'src="([^"]+%.mp4.-)"',
        webm = 'src="([^"]+%.webm.-)"',
        mkv = 'src="([^"]+%.mkv.-)"'
    }

    local returnCode = false
    for format, pattern in pairs(patterns) do
        local match = string.match(response, pattern)
        if match then
            local filename = string.match(match, "/([^/]+)$") or match
            local link = match

            if not string.find(link, "://") then
                if string.sub(link, 1, 1) == "/" then
					local domainPattern = "^(.-/.-/.-/)"
					link = string.match(url, domainPattern) .. link
				else
					link = url .. "/" .. link
					print("aaaaaaaaaa")
				end
            end

			print("Link = " .. link)
			--[[
            if downloadFile(link, filename) then
                fileFound = true
                break
            end
			]]--
			if os.execute("wget " .. link) == 0 then
				returnCode = true
			end
        end
    end

    if not returnCode then
        print("wget exitted unexpectedly")
		print("Link might be incorrect or keybord interupt?")
        return 1
    end

    return 0
end

main()

