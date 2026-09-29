local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

-- Önbelleği (cache) kırmak için zaman damgası ekliyoruz
local timeStamp = "?v=" .. tostring(os.time())

-- Core UI Motorunu Önbelleksiz Yükle
local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua" .. timeStamp))()

-- Universal Modülünü Yükle
local UniversalModule = loadstring(game:HttpGet(RawURL .. "Games/Universal_Module.lua" .. timeStamp))()

-- Modülü Başlat
UniversalModule.Init()
