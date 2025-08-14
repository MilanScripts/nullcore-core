local STYLED_PREFIXES = {
	info = "^4[i]^7",
	warning = "^3[‼]^7",
	error = "^1[×]^7",
	success = "^2[√]^7",
	debug = "^6[？]^7",
	log = "^5[(*)]^7",
	default = "^7[LOG]^7"
}
local HAS_JSON = (type(json) == "table" and type(json.encode) == "function")

function print(levelOrMsg, msg)
	local level, message
	if msg == nil then
		level = "log"
		message = levelOrMsg
	else
		level = tostring(levelOrMsg)
		message = msg
	end

	if level == "debug" then
		local debugEnabled = (type(Config) == "table" and Config.Debug == true)
		if not debugEnabled then return end
	end

	local function fallbackSerialize(t, seen)
		seen = seen or {}
		if type(t) ~= "table" then return tostring(t) end
		if seen[t] then return "<recursion>" end
		seen[t] = true
		local parts = {}
		for k, v in pairs(t) do
			local key = tostring(k)
			if type(v) == "table" then
				table.insert(parts, key .. "=" .. fallbackSerialize(v, seen))
			else
				table.insert(parts, key .. "=" .. tostring(v))
			end
		end
		return "{" .. table.concat(parts, ", ") .. "}"
	end

	if type(message) == "table" then
		local encoded
		local ok, res = pcall(function()
			if HAS_JSON then
				return json.encode(message)
			end
			return nil
		end)
		if ok and res then
			message = res
		else
			message = fallbackSerialize(message)
		end
	else
		message = tostring(message)
	end

	local prefix = STYLED_PREFIXES[level] or STYLED_PREFIXES.default
	Citizen.Trace(prefix .. " " .. message .. "\n")
end