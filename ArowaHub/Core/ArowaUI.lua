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
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sg
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(35, 40, 55)
    stroke.Thickness = 1.5

    -- Opening Animation
    mainFrame:TweenSizeAndPosition(
        UDim2.new(0, 630, 0, 390),
        UDim2.new(0.5, -315, 0.5, -195),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )

    -- Sidebar Area
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 175, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
    sidebar.Parent = mainFrame
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

    makeDraggable(mainFrame, sidebar)

    local brand = Instance.new("TextLabel")
    brand.Size = UDim2.new(1, -20, 0, 22)
    brand.Position = UDim2.new(0, 14, 0, 14)
    brand.BackgroundTransparency = 1
    brand.Text = hubTitle or "ArowaHub"
    brand.TextColor3 = Color3.fromRGB(255, 255, 255)
    brand.TextSize = 16
    brand.Font = Enum.Font.GothamBold
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.Parent = sidebar

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, -20, 0, 15)
    subText.Position = UDim2.new(0, 14, 0, 34)
    subText.BackgroundTransparency = 1
    subText.Text = gameTitle or "Universal Edition"
    subText.TextColor3 = Color3.fromRGB(110, 115, 135)
    subText.TextSize = 10
    subText.Font = Enum.Font.Gotham
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.Parent = sidebar

    -- Top Window Controls (Close / Minimize)
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 60, 0, 24)
    controlsFrame.Position = UDim2.new(1, -68, 0, 8)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -22, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(235, 65, 85)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = controlsFrame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -48, 0, 0)
    minBtn.BackgroundColor3 = Color3.fromRGB(240, 170, 50)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.Parent = controlsFrame
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, 630, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        else
            mainFrame:TweenSize(UDim2.new(0, 630, 0, 390), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.3, true, function()
            sg:Destroy()
        end)
    end)

    -- Tab List Area
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -16, 1, -130)
    tabList.Position = UDim2.new(0, 8, 0, 60)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabList
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)

    -- User Profile Card
    local profileCard = Instance.new("Frame")
    profileCard.Size = UDim2.new(1, -16, 0, 48)
    profileCard.Position = UDim2.new(0, 8, 1, -56)
    profileCard.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    profileCard.Parent = sidebar
    Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 8)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(0, 34, 0, 34)
    avatarImg.Position = UDim2.new(0, 7, 0.5, -17)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Parent = profileCard
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

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

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -190, 1, -50)
    contentArea.Position = UDim2.new(0, 182, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    local tabs = {}
    local firstTab = true

    function Window:CreateTab(tabName, icon)
        local Tab = {}

        local displayTitle = tabName
        if tabName:lower():find("setting") then
            displayTitle = "⚙ " .. tabName
        elseif icon then
            displayTitle = icon .. " " .. tabName
        end

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 34)
        tabBtn.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = "   " .. displayTitle
        tabBtn.TextColor3 = Color3.fromRGB(140, 145, 165)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 12
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabList
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(50, 55, 75)
        tabContent.Visible = false
        tabContent.Parent = contentArea

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 7)

        if firstTab then
            firstTab = false
            tabContent.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Color3.fromRGB(0, 255, 136)
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(140, 145, 165)}):Play()
            end
            tabContent.Visible = true
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 136)}):Play()
        end)

        table.insert(tabs, {Button = tabBtn, Content = tabContent})

        -- Toggle Component
        function Tab:AddToggle(text, default, callback)
            local state = default or false

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -6, 0, 38)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
            toggleFrame.Parent = tabContent
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 225, 235)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame

            local switch = Instance.new("TextButton")
            switch.Size = UDim2.new(0, 42, 0, 22)
            switch.Position = UDim2.new(1, -52, 0.5, -11)
            switch.BackgroundColor3 = state and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(42, 46, 60)
            switch.Text = ""
            switch.Parent = toggleFrame
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = switch
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            switch.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 200, 115) or Color3.fromRGB(42, 46, 60)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
                if callback then callback(state) end
            end)
        end

        -- Slider Component
        function Tab:AddSlider(text, min, max, default, callback)
            local value = default or min

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -6, 0, 46)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
            sliderFrame.Parent = tabContent
            Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, 0, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(220, 225, 235)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0.3, 0, 0, 20)
            valLabel.Position = UDim2.new(0.68, 0, 0, 4)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(value)
            valLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = sliderFrame

            local barBg = Instance.new("TextButton")
            barBg.Size = UDim2.new(1, -24, 0, 8)
            barBg.Position = UDim2.new(0, 12, 0, 28)
            barBg.BackgroundColor3 = Color3.fromRGB(38, 42, 56)
            barBg.Text = ""
            barBg.Parent = sliderFrame
            Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

            local barFill = Instance.new("Frame")
            barFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 115)
            barFill.Parent = barBg
            Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                valLabel.Text = tostring(value)
                barFill.Size = UDim2.new(pos, 0, 1, 0)
                if callback then callback(value) end
            end

            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
        end

        -- Button Component
        function Tab:AddButton(text, callback)
            local btnFrame = Instance.new("TextButton")
            btnFrame.Size = UDim2.new(1, -6, 0, 36)
            btnFrame.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
            btnFrame.Text = text
            btnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnFrame.Font = Enum.Font.GothamBold
            btnFrame.TextSize = 12
            btnFrame.Parent = tabContent
            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)

            btnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 200, 115)}):Play()
                task.wait(0.1)
                TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 32, 45)}):Play()
                if callback then callback() end
            end)
        end

        return Tab
    end

    return Window
end

return ArowaUI
