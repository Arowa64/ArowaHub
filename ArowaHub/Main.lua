local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local UserPersonalUrl = "https://loot-link.com/s?z9sNoHrz"
local SABIT_KEY = "123"

local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua"))()

-- Key Penceresi
ArowaUI:CreateKeyWindow("AROWA HUB", UserPersonalUrl, function(enteredKey, respond)
    local formattedInput = string.gsub(enteredKey or "", "%s+", "")
    
    if formattedInput == SABIT_KEY then
        respond(true, "Key Validated!")
        
        -- Dönen Animasyonlu Yükleme Ekranı
        ArowaUI:ShowLoading("Loading Arowa Hub...", function()
            local Universal = loadstring(game:HttpGet(RawURL .. "Games/Universal_Module.lua"))()
            Universal.Init()
            
            -- Görseldeki Tarzda Ana Hub'ı Aç
            ArowaUI:CreateWindow("ArowaHub", "Universal Mode")
        end)
    else
        respond(false, "Invalid Key!")
    end
end)
