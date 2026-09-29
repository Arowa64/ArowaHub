local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local ArowaUI = {}

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 1. Yükleme Ekranı
function ArowaUI:ShowLoading(titleText, callback)
    local sg = Instance.new("ScreenGui")
    sg.Name = "ArowaLoadingUI"
    sg.Parent = CoreGui
    sg.ResetOnSpawn = false

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 17, 23)
    bg.BackgroundTransparency = 0.2
    bg.Parent = sg

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 320, 0, 180)
    card.Position = UDim2.new(0.5, -160, 0.5, -90)
    card.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    card.Parent = bg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
    Instance.new("UIStroke", card).Color = Color3.fromRGB(45, 48, 64)

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 0, 50)
    logo.Position = UDim2.new(0, 0, 0, 25)
    logo.BackgroundTransparency = 1
    logo.Text = "AROWA HUB"
    logo.TextColor3 = Color3.fromRGB(0, 255, 136)
    logo.TextSize = 24
    logo.Font = Enum.Font.GothamBold
    logo.Parent = card

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, 0, 0, 20)
    subText.Position = UDim2.new(0, 0, 0, 75)
    subText.BackgroundTransparency = 1
    subText.Text = titleText or "Yükleniyor..."
    subText.TextColor3 = Color3.fromRGB(180, 185, 200)
    subText.TextSize = 13
    subText.Font = Enum.Font.Gotham
    subText.Parent = card

    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0, 30, 0, 30)
    spinner.Position = UDim2.new(0.5, -15, 0, 115)
    spinner.BackgroundTransparency = 1
    spinner.Parent = card

    local spinnerCircle = Instance.new("UIStroke", spinner)
    spinnerCircle.Color = Color3.fromRGB(0, 255, 136)
    spinnerCircle.Thickness = 3

    task.spawn(function()
        while sg.Parent do
            spinner.Rotation = spinner.Rotation + 10
            task.wait(0.01)
        end
    end)

    task.wait(1.5)
    sg:Destroy()
    if callback then callback() end
end

-- 2. Key Sistemi Penceresi (Main.lua'nın Aradığı Metod)
function ArowaUI:CreateKeyWindow(title, lootUrl, onVerify)
    local sg = Instance.new("ScreenGui")
    sg.Name = "ArowaKeyUI"
    sg.Parent = CoreGui
    sg.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    mainFrame.Parent = sg
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(40, 44, 60)

    makeDraggable(mainFrame)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    header.Text = title .. " - KEY SYSTEM"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 18
    header.Font = Enum.Font.GothamBold
    header.Parent = mainFrame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0.85, 0, 0, 45)
    keyInput.Position = UDim2.new(0.075, 0, 0, 80)
    keyInput.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
    keyInput.PlaceholderText = "Enter Key Here..."
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.Gotham
    keyInput.Parent = mainFrame
    Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", keyInput).Color = Color3.fromRGB(50, 55, 75)

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.4, 0, 0, 42)
    verifyBtn.Position = UDim2.new(0.075, 0, 0, 145)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 115)
    verifyBtn.Text = "Verify Key"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 14
    verifyBtn.Parent = mainFrame
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.4, 0, 0, 42)
    getKeyBtn.Position = UDim2.new(0.525, 0, 0, 145)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
    getKeyBtn.Text = "Get Key"
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.TextSize = 14
    getKeyBtn.Parent = mainFrame
    Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0, 215)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 13
    statusLabel.Parent = mainFrame

    getKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(lootUrl)
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
            statusLabel.Text = "Link Copied to Clipboard!"
        end
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        onVerify(keyInput.Text, function(success, message)
            if success then
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
                statusLabel.Text = message
                task.wait(0.5)
                sg:Destroy()
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
                statusLabel.Text = message
            end
        end)
    end)
end

-- 3. Ana Menü
function ArowaUI:CreateWindow(hubTitle, gameTitle)
    local Window = {}
    
    if CoreGui:FindFirstChild("ArowaMainHub") then
        CoreGui.ArowaMainHub:Destroy()
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "ArowaMainHub"
    sg.Parent = CoreGui
    sg.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 620, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -310, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    mainFrame.Parent = sg
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(35, 38, 50)

    -- Sol Menü Panel
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(13, 14, 18)
    sidebar.Parent = mainFrame
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

    makeDraggable(mainFrame, sidebar)

    local brand = Instance.new("TextLabel")
    brand.Size = UDim2.new(1, -20, 0, 22)
    brand.Position = UDim2.new(0, 12, 0, 12)
    brand.BackgroundTransparency = 1
    brand.Text = hubTitle or "ArowaHub"
    brand.TextColor3 = Color3.fromRGB(255, 255, 255)
    brand.TextSize = 15
    brand.Font = Enum.Font.GothamBold
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.Parent = sidebar

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, -20, 0, 15)
    subText.Position = UDim2.new(0, 12, 0, 32)
    subText.BackgroundTransparency = 1
    subText.Text = gameTitle or "Universal Mode"
    subText.TextColor3 = Color3.fromRGB(110, 115, 130)
    subText.TextSize = 10
    subText.Font = Enum.Font.Gotham
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.Parent = sidebar

    -- Sekmeler Listesi
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -16, 1, -125)
    tabList.Position = UDim2.new(0, 8, 0, 55)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabList
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)

    -- Profil Kartı (Avatar Görseli)
    local profileCard = Instance.new("Frame")
    profileCard.Size = UDim2.new(1, -16, 0, 48)
    profileCard.Position = UDim2.new(0, 8, 1, -56)
    profileCard.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
    profileCard.Parent = sidebar
    Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 8)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(0, 34, 0, 34)
    avatarImg.Position = UDim2.new(0, 7, 0.5, -17)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Parent = profileCard
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

    -- Profil Fotosu Çekme
    task.spawn(function()
        local content, isLoaded = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if isLoaded then
            avatarImg.Image = content
        else
            avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
        end
    end)

    local pName = Instance.new("TextLabel")
    pName.Size = UDim2.new(1, -50, 0, 16)
    pName.Position = UDim2.new(0, 46, 0, 8)
    pName.BackgroundTransparency = 1
    pName.Text = LocalPlayer.DisplayName
    pName.TextColor3 = Color3.fromRGB(240, 240, 240)
    pName.TextSize = 11
    pName.Font = Enum.Font.GothamBold
    pName.TextXAlignment = Enum.TextXAlignment.Left
    pName.Parent = profileCard

    local pUser = Instance.new("TextLabel")
    pUser.Size = UDim2.new(1, -50, 0, 14)
    pUser.Position = UDim2.new(0, 46, 0, 24)
    pUser.BackgroundTransparency = 1
    pUser.Text = "@" .. LocalPlayer.Name
    pUser.TextColor3 = Color3.fromRGB(120, 125, 140)
    pUser.TextSize = 10
    pUser.Font = Enum.Font.Gotham
    pUser.TextXAlignment = Enum.TextXAlignment.Left
    pUser.Parent = profileCard

    -- Sağ İçerik Alanı
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -180, 1, -20)
    contentArea.Position = UDim2.new(0, 175, 0, 10)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    local tabs = {}
    local firstTab = true

    function Window:CreateTab(tabName)
        local Tab = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = "  " .. tabName
        tabBtn.TextColor3 = Color3.fromRGB(140, 145, 160)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 12
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabList
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(50, 55, 70)
        tabContent.Visible = false
        tabContent.Parent = contentArea

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 6)

        if firstTab then
            firstTab = false
            tabContent.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Color3.fromRGB(0, 255, 136)
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Content.Visible = false
                t.Button.BackgroundTransparency = 1
                t.Button.TextColor3 = Color3.fromRGB(140, 145, 160)
            end
            tabContent.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Color3.fromRGB(0, 255, 136)
        end)

        table.insert(tabs, {Button = tabBtn, Content = tabContent})

        function Tab:AddToggle(text, default, callback)
            local state = default or false

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -5, 0, 38)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
            toggleFrame.Parent = tabContent
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 225, 235)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame

            local switch = Instance.new("TextButton")
            switch.Size = UDim2.new(0, 40, 0, 20)
            switch.Position = UDim2.new(1, -50, 0.5, -10)
            switch.BackgroundColor3 = state and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(45, 50, 65)
            switch.Text = ""
            switch.Parent = toggleFrame
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = switch
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            switch.MouseButton1Click:Connect(function()
                state = not state
                switch.BackgroundColor3 = state and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(45, 50, 65)
                knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                if callback then callback(state) end
            end)
        end

        function Tab:AddButton(text, callback)
            local btnFrame = Instance.new("TextButton")
            btnFrame.Size = UDim2.new(1, -5, 0, 36)
            btnFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 44)
            btnFrame.Text = text
            btnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnFrame.Font = Enum.Font.GothamBold
            btnFrame.TextSize = 12
            btnFrame.Parent = tabContent
            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)

            btnFrame.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        return Tab
    end

    return Window
end

return ArowaUI
