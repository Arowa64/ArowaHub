local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

-- Anti-Cache Parametresi (Her seferinde taze sürümü çeker)
local cacheBust = "?v=" .. tostring(math.random(100000, 999999))

-- Ana Universal Modülünü Yükle
local success, err = pcall(function()
    local Universal = loadstring(game:HttpGet(RawURL .. "Games/Universal_Module.lua" .. cacheBust))()
    if Universal and Universal.Init then
        Universal.Init()
    end
end)

if not success then
    warn("[ArowaHub Error]: " .. tostring(err))
end
