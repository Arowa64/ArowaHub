local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local LocalPlayer = Players.LocalPlayer

-- Kullanıcı Dili Tespiti
local playerLocale = LocalizationService.RobloxLocaleId:lower()
local isTurkish = string.find(playerLocale, "tr") ~= nil

-- LootLabs Linkin
local UserPersonalUrl = "https://lootdest.org/s?F1PcGPsi"

-- SABİT KEY
local SABIT_KEY = "AROWAHUB2026" -- İstediğin key'i buraya yazabilirsin

-- UI Motorunu Yükle
local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua"))()

-- Key Doğrulama Servisi
local function VerifyKey(userKeyInput, callback)
    task.spawn(function()
        local formattedInput = string.upper(string.gsub(userKeyInput or "", "%s+", ""))
        
        if formattedInput == SABIT_KEY then
            local successMsg = isTurkish and "Key Başarıyla Doğrulandı!" or "Key Successfully Verified!"
            callback(true, successMsg)
        else
            local errorMsg = isTurkish and "Geçersiz Key!" or "Invalid Key!"
            callback(false, errorMsg)
        end
    end)
end

-- UI Ekranını Aç
ArowaUI:CreateKeyWindow("AROWA HUB", UserPersonalUrl, function(enteredKey, respond)
    VerifyKey(enteredKey, function(success, message)
        respond(success, message)
        
        if success then
            print(isTurkish and "[Arowa Hub] Giriş Başarılı! Oyun Yükleniyor..." or "[Arowa Hub] Login Successful! Loading Game...")
            
            local Universal = loadstring(game:HttpGet(RawURL .. "Games/Universal_Module.lua"))()
            Universal.Init()
        end
    end)
end)
