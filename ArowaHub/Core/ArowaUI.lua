local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local ArowaUI = {}

-- UI Sürükleme Fonksiyonu
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

-- 1. Yükleme Ekranı (Loading Animation)
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

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(45, 48, 64)
    stroke.Thickness = 1

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

    -- Dönen Spinner
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

    task.wait(2)
    sg:Destroy()
    if callback then callback() end
end

-- 2. Modern Key Doğrulama Penceresi
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
                task.wait(1)
                sg:Destroy()
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
                statusLabel.Text = message
            end
        end)
    end)
end

-- 3. Görseldeki VexonHub Tarzı Ana Menü
function ArowaUI:CreateWindow(hubTitle, gameTitle)
    local sg = Instance.new("ScreenGui")
    sg.Name = "ArowaMainHub"
    sg.Parent = CoreGui
    sg.ResetOnSpawn = false -- Kapanmasın, sürekli açık kalsın

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 620, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -310, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    mainFrame.Parent = sg
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(38, 42, 56)

    -- Sol Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
    sidebar.Parent = mainFrame
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

    makeDraggable(mainFrame, sidebar)

    -- Başlık
    local brand = Instance.new("TextLabel")
    brand.Size = UDim2.new(1, -20, 0, 25)
    brand.Position = UDim2.new(0, 15, 0, 15)
    brand.BackgroundTransparency = 1
    brand.Text = hubTitle or "ArowaHub"
    brand.TextColor3 = Color3.fromRGB(255, 255, 255)
    brand.TextSize = 16
    brand.Font = Enum.Font.GothamBold
    brand.TextXAlignment = Enum.TextXAlignment.Left
    brand.Parent = sidebar

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, -20, 0, 15)
    subText.Position = UDim2.new(0, 15, 0, 38)
    subText.BackgroundTransparency = 1
    subText.Text = gameTitle or "Universal"
    subText.TextColor3 = Color3.fromRGB(120, 125, 140)
    subText.TextSize = 11
    subText.Font = Enum.Font.Gotham
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.Parent = sidebar

    -- Oyuncu Profili (Sol Alt Kart)
    local profileCard = Instance.new("Frame")
    profileCard.Size = UDim2.new(1, -20, 0, 45)
    profileCard.Position = UDim2.new(0, 10, 1, -55)
    profileCard.BackgroundColor3 = Color3.fromRGB(22, 25, 34)
    profileCard.Parent = sidebar
    Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 8)

    local pName = Instance.new("TextLabel")
    pName.Size = UDim2.new(1, -10, 0, 20)
    pName.Position = UDim2.new(0, 10, 0, 12)
    pName.BackgroundTransparency = 1
    pName.Text = LocalPlayer.Name
    pName.TextColor3 = Color3.fromRGB(255, 255, 255)
    pName.TextSize = 12
    pName.Font = Enum.Font.GothamBold
    pName.TextXAlignment = Enum.TextXAlignment.Left
    pName.Parent = profileCard

    -- Sağ İçerik Alanı
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -180, 1, -20)
    contentArea.Position = UDim2.new(0, 175, 0, 10)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    -- Bilgi Kutusu (Örnek Görseldeki Kırmızı Kutu Tarzı)
    local alertBox = Instance.new("Frame")
    alertBox.Size = UDim2.new(1, 0, 0, 70)
    alertBox.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
    alertBox.Parent = contentArea
    Instance.new("UICorner", alertBox).CornerRadius = UDim.new(0, 10)

    local alertTitle = Instance.new("TextLabel")
    alertTitle.Size = UDim2.new(1, -20, 0, 25)
    alertTitle.Position = UDim2.new(0, 15, 0, 10)
    alertTitle.BackgroundTransparency = 1
    alertTitle.Text = "ArowaHub Active"
    alertTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    alertTitle.TextSize = 14
    alertTitle.Font = Enum.Font.GothamBold
    alertTitle.TextXAlignment = Enum.TextXAlignment.Left
    alertTitle.Parent = alertBox

    local alertDesc = Instance.new("TextLabel")
    alertDesc.Size = UDim2.new(1, -20, 0, 25)
    alertDesc.Position = UDim2.new(0, 15, 0, 35)
    alertDesc.BackgroundTransparency = 1
    alertDesc.Text = "System successfully loaded. Character killed reset is disabled."
    alertDesc.TextColor3 = Color3.fromRGB(240, 240, 240)
    alertDesc.TextSize = 11
    alertDesc.Font = Enum.Font.Gotham
    alertDesc.TextXAlignment = Enum.TextXAlignment.Left
    alertDesc.Parent = alertBox

    return sg
end

return ArowaUI
