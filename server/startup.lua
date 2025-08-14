Nullcore = Nullcore or {}
Nullcore.Ready = false
Nullcore.Version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
Nullcore.versionDone = false
Nullcore.frameworkReady = false

local function nowMs()
    local ok, t = pcall(GetGameTimer)
    if ok and type(t) == 'number' then return t end
    return math.floor(os.clock() * 1000)
end

local _bootStartMs = nowMs()

local function GetVersionFromGitHub(cb)
    PerformHttpRequest('https://raw.githubusercontent.com/MilanScripts/nullcore-core/refs/heads/main/version',
        function(err, text, headers)
            if err == 200 then
                local version = text:gsub("\n", "")
                if cb then cb(version) end
            else
                if cb then cb(nil, err) end
            end
        end, 'GET')
end

local function tryFinalize()
    if Nullcore.versionDone and Nullcore.frameworkReady and not Nullcore.Ready then
        Nullcore.Ready = true
        local elapsed = nowMs() - _bootStartMs
        Nullcore.StartupMs = elapsed
        print("success", ("%s started in %d ms"):format(GetCurrentResourceName(), elapsed))
    end
end

CreateThread(function()
    while true do
        local fw = exports[GetCurrentResourceName()] and exports[GetCurrentResourceName()].GetFramework and
        exports[GetCurrentResourceName()]:GetFramework()
        if fw then
            Nullcore.framework = fw
            Nullcore.frameworkReady = true
            tryFinalize()
            break
        end
        Wait(100)
    end
end)

CreateThread(function()
    GetVersionFromGitHub(function(githubVersion, err)
        if githubVersion then
            if githubVersion ~= Nullcore.Version then
                print("warning", "New version available: " .. githubVersion .. " (current: " .. Nullcore.Version .. ")")
            else
                print("info", "You are using the latest version: " .. Nullcore.Version)
            end
        else
            print("error", "Failed to fetch version from GitHub. Error code: " .. tostring(err))
        end
        Nullcore.versionDone = true
        tryFinalize()
    end)
end)
