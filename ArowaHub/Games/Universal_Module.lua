-- // Enhanced ESP & Modern Hub (Universal Module)
-- // Roblox Luau Scripting

local UniversalModule = {}

function UniversalModule.Init()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    -- // Ayarlar (Settings State)
    local Settings = {
        ESP_Enabled = true,
        TeamCheck = true,
        ShowBoxes = true,
        ShowTracers = true,
        ShowInfo = true,
        HighlightChams = true,
        MaxDistance = 10000,
        BoxColor = Color3.fromRGB(255, 60, 60),
        TeamColor = Color3.fromRGB(60, 255, 120),
        TracerColor = Color3.fromRGB(255, 255, 255)
    }

    local ToggleKey = Enum.KeyCode.RightShift

    -- // UI Oluşturma
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ArowaHub_UniversalUI"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 360, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -180, 0.4, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Header
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Arowa Hub | Universal"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = MainFrame

    -- Tab Butonları Alanı
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -20, 0, 30)
    TabBar.Position = UDim2.new(0, 10, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabBar

    local MainTabBtn = Instance.new("TextButton")
    MainTabBtn.Size = UDim2.new(0.5, -2, 1, 0)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MainTabBtn.Text = "ESP Görselleri"
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.Font = Enum.Font.GothamBold
    MainTabBtn.TextSize = 12
    MainTabBtn.BorderSizePixel = 0
    MainTabBtn.Parent = TabBar
    Instance.new("UICorner", MainTabBtn).CornerRadius = UDim.new(0, 6)

    local SettingsTabBtn = Instance.new("TextButton")
    SettingsTabBtn.Size = UDim2.new(0.5, -2, 1, 0)
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    SettingsTabBtn.Text = "ESP Ayarları"
    SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    SettingsTabBtn.Font = Enum.Font.GothamBold
    SettingsTabBtn.TextSize = 12
    SettingsTabBtn.BorderSizePixel = 0
    SettingsTabBtn.Parent = TabBar
    Instance.new("UICorner", SettingsTabBtn).CornerRadius = UDim.new(0, 6)

    -- Konteynerlar (Pages)
    local MainContainer = Instance.new("ScrollingFrame")
    MainContainer.Size = UDim2.new(1, -20, 1, -80)
    MainContainer.Position = UDim2.new(0, 10, 0, 75)
    MainContainer.BackgroundTransparency = 1
    MainContainer.BorderSizePixel = 0
    MainContainer.ScrollBarThickness = 3
    MainContainer.Visible = true
    MainContainer.Parent = MainFrame

    local SettingsContainer = Instance.new("ScrollingFrame")
    SettingsContainer.Size = UDim2.new(1, -20, 1, -80)
    SettingsContainer.Position = UDim2.new(0, 10, 0, 75)
    SettingsContainer.BackgroundTransparency = 1
    SettingsContainer.BorderSizePixel = 0
    SettingsContainer.ScrollBarThickness = 3
    SettingsContainer.Visible = false
    SettingsContainer.Parent = MainFrame

    local L1 = Instance.new("UIListLayout", MainContainer)
    L1.SortOrder = Enum.SortOrder.LayoutOrder
    L1.Padding = UDim.new(0, 6)

    local L2 = Instance.new("UIListLayout", SettingsContainer)
    L2.SortOrder = Enum.SortOrder.LayoutOrder
    L2.Padding = UDim.new(0, 6)

    -- Tab Değiştirme Mantığı
    MainTabBtn.MouseButton1Click:Connect(function()
        MainContainer.Visible = true
        SettingsContainer.Visible = false
        MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        SettingsTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)

    SettingsTabBtn.MouseButton1Click:Connect(function()
        MainContainer.Visible = false
        SettingsContainer.Visible = true
        SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        SettingsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        MainTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)

    -- Dragging Mantığı
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Eleman Oluşturucular
    local function createToggle(parent, name, defaultState, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -6, 0, 32)
        Button.BackgroundColor3 = defaultState and Color3.fromRGB(35, 120, 80) or Color3.fromRGB(30, 30, 38)
        Button.Text = "  " .. name .. ": " .. (defaultState and "AÇIK" or "KAPALI")
        Button.TextColor3 = Color3.fromRGB(230, 230, 230)
        Button.TextSize = 12
        Button.Font = Enum.Font.GothamMedium
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.BorderSizePixel = 0
        Button.Parent = parent

        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

        local state = defaultState
        Button.MouseButton1Click:Connect(function()
            state = not state
            Button.BackgroundColor3 = state and Color3.fromRGB(35, 120, 80) or Color3.fromRGB(30, 30, 38)
            Button.Text = "  " .. name .. ": " .. (state and "AÇIK" or "KAPALI")
            callback(state)
        end)
    end

    local function createInput(parent, name, defaultText, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -6, 0, 32)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        Frame.BorderSizePixel = 0
        Frame.Parent = parent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 1, 0)
        Label.Position = UDim2.new(0, 8, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 12
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(0.35, -5, 0.7, 0)
        Box.Position = UDim2.new(0.65, 0, 0.15, 0)
        Box.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Box.Text = tostring(defaultText)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextSize = 12
        Box.Font = Enum.Font.GothamMedium
        Box.BorderSizePixel = 0
        Box.Parent = Frame
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

        Box.FocusLost:Connect(function()
            callback(Box.Text)
        end)
    end

    local function createColorSelector(parent, name, defaultColor, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -6, 0, 32)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        Frame.BorderSizePixel = 0
        Frame.Parent = parent
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.new(0, 8, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 12
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(0.45, -5, 0.7, 0)
        Box.Position = UDim2.new(0.55, 0, 0.15, 0)
        Box.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Box.Text = string.format("%d,%d,%d", defaultColor.R * 255, defaultColor.G * 255, defaultColor.B * 255)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextSize = 11
        Box.Font = Enum.Font.GothamMedium
        Box.BorderSizePixel = 0
        Box.Parent = Frame
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

        Box.FocusLost:Connect(function()
            local r, g, b = Box.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if r and g and b then
                local newColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                callback(newColor)
            end
        end)
    end

    -- Tab 1 Controls (Görseller)
    createToggle(MainContainer, "ESP Master Toggle", Settings.ESP_Enabled, function(v) Settings.ESP_Enabled = v end)
    createToggle(MainContainer, "Team Check", Settings.TeamCheck, function(v) Settings.TeamCheck = v end)
    createToggle(MainContainer, "2D Box ESP", Settings.ShowBoxes, function(v) Settings.ShowBoxes = v end)
    createToggle(MainContainer, "Info (Name/HP/Distance)", Settings.ShowInfo, function(v) Settings.ShowInfo = v end)
    createToggle(MainContainer, "Tracers", Settings.ShowTracers, function(v) Settings.ShowTracers = v end)
    createToggle(MainContainer, "Chams (Highlight)", Settings.HighlightChams, function(v) Settings.HighlightChams = v end)

    -- Tab 2 Controls (Ayarlar & Renkler)
    createInput(SettingsContainer, "Max Mesafe (Studs):", Settings.MaxDistance, function(text)
        local num = tonumber(text)
        if num then Settings.MaxDistance = num end
    end)

    createColorSelector(SettingsContainer, "Düşman/Kutu Rengi:", Settings.BoxColor, function(color)
        Settings.BoxColor = color
    end)

    createColorSelector(SettingsContainer, "Takım Rengi:", Settings.TeamColor, function(color)
        Settings.TeamColor = color
    end)

    createColorSelector(SettingsContainer, "Tracer Rengi:", Settings.TracerColor, function(color)
        Settings.TracerColor = color
    end)

    CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- // ESP Render Mantığı
    local ESP_Cache = {}

    local function removeESP(player)
        if ESP_Cache[player] then
            for _, object in pairs(ESP_Cache[player].Drawing) do
                if object and object.Remove then object:Remove() end
            end
            if ESP_Cache[player].Highlight then ESP_Cache[player].Highlight:Destroy() end
            ESP_Cache[player] = nil
        end
    end

    local function createESP(player)
        if player == LocalPlayer then return end
        removeESP(player)

        local box = Drawing.new("Square")
        box.Thickness = 1.5
        box.Filled = false
        box.Visible = false

        local text = Drawing.new("Text")
        text.Size = 14
        text.Center = true
        text.Outline = true
        text.Font = 2
        text.Visible = false

        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Visible = false

        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.2
        highlight.Enabled = false

        ESP_Cache[player] = {
            Drawing = {Box = box, Text = text, Tracer = tracer},
            Highlight = highlight
        }
    end

    RunService.RenderStepped:Connect(function()
        for player, data in pairs(ESP_Cache) do
            local box = data.Drawing.Box
            local text = data.Drawing.Text
            local tracer = data.Drawing.Tracer
            local highlight = data.Highlight

            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local head = character and character:FindFirstChild("Head")

            local isTeammate = (LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team)
            local shouldShow = Settings.ESP_Enabled
                and character
                and rootPart
                and humanoid
                and humanoid.Health > 0
                and (not Settings.TeamCheck or not isTeammate)

            if shouldShow then
                local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

                if onScreen and distance <= Settings.MaxDistance then
                    local currentColor = isTeammate and Settings.TeamColor or Settings.BoxColor
                    local extents = character:GetExtentsSize()
                    local hrpCF = rootPart.CFrame

                    local topLeft = Camera:WorldToViewportPoint((hrpCF * CFrame.new(-extents.X / 2, extents.Y / 2, 0)).Position)
                    local bottomRight = Camera:WorldToViewportPoint((hrpCF * CFrame.new(extents.X / 2, -extents.Y / 2, 0)).Position)

                    local boxWidth = bottomRight.X - topLeft.X
                    local boxHeight = bottomRight.Y - topLeft.Y

                    -- 1. Box ESP
                    if Settings.ShowBoxes then
                        box.Size = Vector2.new(boxWidth, boxHeight)
                        box.Position = Vector2.new(topLeft.X, topLeft.Y)
                        box.Color = currentColor
                        box.Visible = true
                    else
                        box.Visible = false
                    end

                    -- 2. Text Info ESP
                    if Settings.ShowInfo and head then
                        local headPos = Camera:WorldToViewportPoint(head.Position)
                        text.Position = Vector2.new(headPos.X, topLeft.Y - 18)
                        text.Text = string.format("%s | HP: %d | %dm", player.Name, math.floor(humanoid.Health), math.floor(distance))
                        text.Color = currentColor
                        text.Visible = true
                    else
                        text.Visible = false
                    end

                    -- 3. Tracer ESP
                    if Settings.ShowTracers then
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                        tracer.Color = Settings.TracerColor
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end

                    -- 4. Chams
                    if Settings.HighlightChams then
                        highlight.Parent = character
                        highlight.FillColor = currentColor
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Enabled = true
                    else
                        highlight.Enabled = false
                    end
                else
                    box.Visible = false
                    text.Visible = false
                    tracer.Visible = false
                    highlight.Enabled = false
                end
            else
                box.Visible = false
                text.Visible = false
                tracer.Visible = false
                highlight.Enabled = false
            end
        end
    end)

    local function setupPlayer(player)
        if player == LocalPlayer then return end
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            createESP(player)
        end)
        if player.Character then createESP(player) end
    end

    for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
    Players.PlayerAdded:Connect(setupPlayer)
    Players.PlayerRemoving:Connect(removeESP)
end

return UniversalModule
