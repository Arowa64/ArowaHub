local UniversalModule = {}

function UniversalModule.Init()
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"

    if CoreGui:FindFirstChild("ArowaUniversalGUI") then
        CoreGui.ArowaUniversalGUI:Destroy()
    end

    local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua"))()
    local window = ArowaUI:CreateWindow("ArowaHub", "Universal ESP")

    -- ESP Ayarları
    local ESP_Settings = {
        MasterToggle = false,
        Chams = false
    }

    local function updateESP(player)
        if player == LocalPlayer then return end

        local function applyChams(character)
            if not character then return end
            local highlight = character:FindFirstChild("ArowaHighlight")

            if ESP_Settings.MasterToggle and ESP_Settings.Chams then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ArowaHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 136)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.OutlineTransparency = 0
                    highlight.Parent = character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end

        if player.Character then applyChams(player.Character) end
        player.CharacterAdded:Connect(applyChams)
    end

    local function refreshAllESP()
        for _, p in ipairs(Players:GetPlayers()) do
            updateESP(p)
        end
    end

    Players.PlayerAdded:Connect(updateESP)

    -- SEKMELER VE DÜĞMELER
    local MainTab = window:CreateTab("ESP Görselleri")
    
    MainTab:AddToggle("ESP Ana Şalter (Master Toggle)", false, function(val)
        ESP_Settings.MasterToggle = val
        refreshAllESP()
    end)

    MainTab:AddToggle("Chams (Highlight ESP)", false, function(val)
        ESP_Settings.Chams = val
        refreshAllESP()
    end)
end

return UniversalModule
