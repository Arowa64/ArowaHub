local RawURL = "https://raw.githubusercontent.com/Arowa64/ArowaHub/main/ArowaHub/"
local timeStamp = "?v=" .. tostring(os.time())
local ArowaUI = loadstring(game:HttpGet(RawURL .. "Core/ArowaUI.lua" .. timeStamp))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local Universal = {}

function Universal.Init()
    local Window = ArowaUI:CreateWindow("ArowaHub", "Universal Edition")

    ---------------------------------------------------------
    -- TAB 1: PLAYER / MOVEMENT
    ---------------------------------------------------------
    local PlayerTab = Window:CreateTab("Player", "⚡")

    PlayerTab:AddSlider("WalkSpeed", 16, 200, 16, function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end)

    PlayerTab:AddSlider("JumpPower", 50, 300, 50, function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end)

    -- Infinite Jump
    local infJumpEnabled = false
    PlayerTab:AddToggle("Infinite Jump", false, function(state)
        infJumpEnabled = state
    end)

    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Noclip
    local noclipEnabled = false
    PlayerTab:AddToggle("Noclip", false, function(state)
        noclipEnabled = state
    end)

    RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    ---------------------------------------------------------
    -- TAB 2: ESP / VISUALS
    ---------------------------------------------------------
    local ESPTab = Window:CreateTab("ESP Visuals", "👁")

    local highlights = {}
    ESPTab:AddToggle("Chams (Highlight)", false, function(state)
        if state then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ArowaChams"
                    hl.FillColor = Color3.fromRGB(0, 255, 136)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = p.Character
                    highlights[p] = hl
                end
            end
        else
            for _, hl in pairs(highlights) do
                if hl then hl:Destroy() end
            end
            highlights = {}
        end
    end)

    ---------------------------------------------------------
    -- TAB 3: HUB SETTINGS
    ---------------------------------------------------------
    local SettingsTab = Window:CreateTab("Hub Settings")

    SettingsTab:AddButton("Server Hop", function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)

    SettingsTab:AddButton("Rejoin Game", function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    SettingsTab:AddButton("Copy Discord Link", function()
        if setclipboard then
            setclipboard("https://discord.gg/grogu")
        end
    end)

    SettingsTab:AddButton("Unload Script", function()
        if game:GetService("CoreGui"):FindFirstChild("ArowaMainHub") then
            game:GetService("CoreGui").ArowaMainHub:Destroy()
        end
    end)
end

return Universal
