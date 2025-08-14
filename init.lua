_G.Nullcore = _G.Nullcore or {}
_G.nullcore = _G.nullcore or _G.Nullcore

-- { Print Handler } --
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

local function fallbackSerialize(t, seen)
    seen = seen or {}
    if type(t) ~= "table" then return tostring(t) end
    if seen[t] then return "<recursion>" end
    seen[t] = true
    local parts = {}
    for k, v in pairs(t) do
        local key = tostring(k)
        if type(v) == "table" then
            parts[#parts + 1] = key .. "=" .. fallbackSerialize(v, seen)
        else
            parts[#parts + 1] = key .. "=" .. tostring(v)
        end
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end

if type(Nullcore.print) ~= 'function' then
    function Nullcore.print(levelOrMsg, msg)
        local level, message
        if msg == nil then
            level = "log"
            message = levelOrMsg
        else
            level = tostring(levelOrMsg)
            message = msg
        end

        if level == "debug" then
            local cfg = rawget(_G, 'Config')
            local debugEnabled = (type(cfg) == "table" and cfg.Debug == true)
            if not debugEnabled then return end
        end

        if type(message) == "table" then
            local ok, res = pcall(function()
                if HAS_JSON then return json.encode(message) end
                return nil
            end)
            message = (ok and res) or fallbackSerialize(message)
        else
            message = tostring(message)
        end

        local prefix = STYLED_PREFIXES[level] or STYLED_PREFIXES.default
        Citizen.Trace(prefix .. " " .. message .. "\n")
    end
end

_G.nullcore = _G.Nullcore
