local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local LocalPlayer = Players.LocalPlayer

-- Kullanıcı Dili Tespiti
local playerLocale = LocalizationService.RobloxLocaleId:lower()
local isTurkish = string.find(playerLocale, "tr") ~= nil

-- LootLabs Linkin
local UserPersonalUrl = "https://lootdest.org/s?F1PcGPsi"

-- UI Motorunu Yükle
local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua"))()

-- 15 Haneli Dynamic Key Oluşturucu (24 Saat Geçerli)
local function GenerateUserKey(userId)
    local currentDay = math.floor(os.time() / 86400)
    local secretSalt = "AROWA_SALT_" .. tostring(userId) .. "_" .. tostring(currentDay)

    local h1 = 0
    local h2 = 0
    for i = 1, #secretSalt do
        local char = string.byte(secretSalt, i)
        h1 = (h1 * 31 + char) % 1000000
        h2 = (h2 * 37 + char) % 1000000
    end

    return "AROWA-" .. string.format("%05X", h1) .. "-" .. string.format("%05X", h2)
end

-- Key Doğrulama Servisi
local function VerifyKey(userKeyInput, callback)
    task.spawn(function()
        local correctKey = GenerateUserKey(LocalPlayer.UserId)
        local formattedInput = string.upper(string.gsub(userKeyInput or "", "%s+", ""))

        if formattedInput == correctKey then
            local successMsg = isTurkish and "Key Başarıyla Doğrulandı!" or "Key Successfully Verified!"
            callback(true, successMsg)
        else
            local errorMsg = isTurkish and "Geçersiz veya Süresi Dolmuş Key!" or "Invalid or Expired Key!"
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

            local placeId = game.PlaceId

            -- Oyun Kodları Yönlendirmesi
            if placeId == 142823291 or placeId == 6366496480 then
                -- Murder Mystery 2
                local MM2 = loadstring(game:HttpGet(RawURL .. "Games/MM2_Module.lua"))()
                MM2.Init()
            else
                -- Universal Modül
                local Universal = loadstring(game:HttpGet(RawURL .. "Games/Universal_Module.lua"))()
                Universal.Init()
            end
        end
    end)
end)
