local UniversalModule = {}

function UniversalModule.Init()
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

    -- Eski GUI varsa temizle
    if CoreGui:FindFirstChild("ArowaUniversalGUI") then
        CoreGui.ArowaUniversalGUI:Destroy()
    end

    -- Modern UI Motorunu Yükle
    local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua"))()
    
    -- VexonHub Tarzı Ana Menüyü Oluştur
    local window = ArowaUI:CreateWindow("ArowaHub", "Universal ESP Mode")

    ---------------------------------------------------------
    -- ESP DEĞİŞKENLERİ VE AYARLARI
    ---------------------------------------------------------
    local ESP_Settings = {
        MasterToggle = false,
        TeamCheck = true,
        BoxESP = false,
        Tracers = false,
        InfoESP = false
    }

    -- ESP Çizim Fonksiyonları (Arka Plan Mantığı)
    local function applyESP(player)
        if player == LocalPlayer then return end

        local function setupChams(character)
            if not character then return end
            
            local highlight = character:FindFirstChild("ArowaHighlight")
            if ESP_Settings.MasterToggle then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ArowaHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 136)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end

        if player.Character then setupChams(player.Character) end
        player.CharacterAdded:Connect(setupChams)
    end

    -- Tüm Oyunculara ESP Uygula
    for _, player in ipairs(Players:GetPlayers()) do
        applyESP(player)
    end
    Players.PlayerAdded:Connect(applyESP)

    print("[Arowa Hub] Universal Module Successfully Integrated into New UI!")
end

return UniversalModule
