# nullcore-core
Minimal server core used for all my resources.

## Install

- Resource name must be `nullcore-core`.
- Start it before any consumers.

```ini
# server.cfg
ensure nullcore-core
ensure your-consumer-resource
```

## Shared init helpers (init.lua)

- Global: `Nullcore` (also available as `nullcore`).
- Logger: `Nullcore.print(level, message)`
  - Levels: `info`, `warning`, `error`, `success`, `debug`, `log`.
  - Tables are auto-serialized. `debug` prints only if `Config.Debug = true`.

Usage example (server):

```lua
CreateThread(function()
    -- wait until shared is present
    while type(Nullcore) ~= 'table' or type(Nullcore.print) ~= 'function' do Wait(50) end

    Nullcore.print('info', 'My resource started')
    while true do
        local ids = Nullcore.GetReadyIds()
        Nullcore.print('info', ids)
        Wait(1000)
    end
end)
```

## Server exports

- `exports['nullcore-core']:GetNullcore()`
  - Returns the core table for advanced integrations.
- `exports['nullcore-core']:GetReadyIds()`
  - Returns an array of ready player server IDs, e.g., `{1, 27, 42}`.

Usage example (server):

```lua
CreateThread(function()
    while GetResourceState('nullcore-core') ~= 'started' do Wait(100) end
    local ids = exports['nullcore-core']:GetReadyIds()
    for _, src in ipairs(ids) do
        -- do something with ready src
    end
end)
```

## Notes

- Do not call server exports from the client.
- Prefer the `GetReadyIds` export for a clean list; the core’s internal table may differ.
