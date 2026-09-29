local ArowaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

-- Otomatik Dil Algılama
local playerLocale = LocalizationService.RobloxLocaleId:lower()
local isTurkish = string.find(playerLocale, "tr") ~= nil

-- Dil Metinleri (Translations)
local Lang = {
    KeyTitle = isTurkish and "Key Doğrulama" or "Key Verification",
    Placeholder = isTurkish and "LootLabs Anahtarınızı Girin..." or "Enter your LootLabs Key...",
    GetKeyBtn = isTurkish and "Key Al (LootLabs Linki Kopyala)" or "Get Key (Copy LootLabs Link)",
    SubmitBtn = isTurkish and "Anahtarı Doğrula" or "Verify Key",
    InitialStatus = isTurkish and "LootLabs üzerinden key alabilirsiniz." or "You can get a key via LootLabs.",
    CopiedSuccess = isTurkish and "Link panoya kopyalandı! Tarayıcına yapıştır." or "Link copied to clipboard! Paste it in browser.",
    CopyNotSupported = isTurkish and "Kopyalama desteklenmiyor. Link: " or "Copying not supported. Link: ",
    Verifying = isTurkish and "Doğrulanıyor..." or "Verifying...",
    KeySuccess = isTurkish and "Key Başarılı! Yükleniyor..." or "Key Success! Loading...",
    KeyError = isTurkish and "Hatalı veya Süresi Dolmuş Key!" or "Invalid or Expired Key!"
}

function ArowaUI:CreateKeyWindow(hubTitle, lootLabsUrl, onKeySubmit)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ArowaHub_KeyUI"
    ScreenGui.ResetOnSpawn = false

    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Key Ana Pencere
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 380, 0, 260)
    KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", KeyFrame)
    UICorner.CornerRadius = UDim.new(0, 10)

    -- Başlık
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Text = hubTitle .. " | " .. Lang.KeyTitle
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    Title.Parent = KeyFrame

    -- Key Input Box
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.85, 0, 0, 38)
    KeyInput.Position = UDim2.new(0.075, 0, 0.25, 0)
    KeyInput.PlaceholderText = Lang.Placeholder
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.BackgroundColor3 = Color3.fromRGB(28, 31, 40)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.BorderSizePixel = 0
    KeyInput.Parent = KeyFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    -- Key Al (LootLabs Link Kopyala)
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.85, 0, 0, 38)
    GetKeyBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
    GetKeyBtn.Text = Lang.GetKeyBtn
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 85)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 13
    GetKeyBtn.Parent = KeyFrame
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

    -- Doğrula / Giriş Yap Butonu
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    SubmitBtn.Text = Lang.SubmitBtn
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 14
    SubmitBtn.Parent = KeyFrame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

    -- Bilgi / Durum Etiketi
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = Lang.InitialStatus
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = KeyFrame

    -- Sürükleme Mantığı (Draggable)
    local dragging, dragInput, dragStart, startPos
    KeyFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = KeyFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            KeyFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    KeyFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Link Kopyalama Butonu İşlevi
    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(lootLabsUrl)
            StatusLabel.Text = Lang.CopiedSuccess
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        else
            StatusLabel.Text = Lang.CopyNotSupported .. lootLabsUrl
        end
    end)

    -- Key Onaylama İşlevi
    SubmitBtn.MouseButton1Click:Connect(function()
        local userKey = KeyInput.Text
        StatusLabel.Text = Lang.Verifying
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)

        onKeySubmit(userKey, function(success, message)
            if success then
                StatusLabel.Text = Lang.KeySuccess
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
                task.wait(1)
                ScreenGui:Destroy()
            else
                StatusLabel.Text = message or Lang.KeyError
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)
    end)
end

return ArowaUI
