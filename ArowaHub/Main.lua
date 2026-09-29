local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"
local timeStamp = "?v=" .. tostring(os.time())

-- UI Motoru ve Modülü doğrudan yükle
local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua" .. timeStamp))()
local UniversalModule = loadstring(game:HttpGet(RawURL .. "Games/Universal_Module.lua" .. timeStamp))()

-- Doğrudan başlat (Key kontrolünü atla)
UniversalModule.Init()
