-- ==============================================
-- 🛒 SHOP MODULE - BELI BIBIT (BEE FUTURISTIC EDITION)
-- ==============================================

local ShopAutoBuy = {}

function ShopAutoBuy.Init(Dependencies)
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local Bdev = Dependencies.Bdev
    local GUI = Dependencies.GUI or Shared.GUI
    
    -- Ambil theme dari GUI
    local theme = GUI:GetTheme() or {
        Accent = Color3.fromRGB(255, 40, 40),
        AccentLight = Color3.fromRGB(255, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 210),
        Button = Color3.fromRGB(25, 25, 32),
        ButtonHover = Color3.fromRGB(45, 45, 55),
        InputBg = Color3.fromRGB(30, 30, 40),
        ToggleOff = Color3.fromRGB(50, 50, 60),
        BorderLight = Color3.fromRGB(70, 70, 80),
        BorderRed = Color3.fromRGB(255, 40, 40),
        ContentCard = Color3.fromRGB(20, 20, 25),
        TextMuted = Color3.fromRGB(140, 140, 150)
    }
    
    -- Get services
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    -- ===== FUNGSI TWEEN LOKAL =====
    local function tween(object, properties, duration, easingStyle)
        if not object then return nil end
        
        local tweenInfo = TweenInfo.new(
            duration or 0.2, 
            easingStyle or Enum.EasingStyle.Quint, 
            Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(object, tweenInfo, properties)
        tween:Play()
        return tween
    end
    
    -- ===== REMOTE SHOP =====
    local RequestShop = ReplicatedStorage:FindFirstChild("Remotes")
    if RequestShop then
        RequestShop = RequestShop:FindFirstChild("TutorialRemotes")
        if RequestShop then
            RequestShop = RequestShop:FindFirstChild("RequestShop")
        end
    end
    
    -- ===== DAFTAR BIBIT =====
    local seedsList = {
        {Display = "🌾 Padi", Name = "Bibit Padi"},
        {Display = "🌽 Jagung", Name = "Bibit Jagung"},
        {Display = "🍅 Tomat", Name = "Bibit Tomat"},
        {Display = "🍆 Terong", Name = "Bibit Terong"},
        {Display = "🍓 Strawberry", Name = "Bibit Strawberry"},
        {Display = "❌ None", Name = "None"}
    }
    
    -- Buat array terpisah untuk dropdown options (hanya display names)
    local seedDisplayOptions = {}
    for i, seed in ipairs(seedsList) do
        seedDisplayOptions[i] = seed.Display
    end
    
    -- Mapping untuk konversi Display -> Name
    local displayToName = {}
    for i, seed in ipairs(seedsList) do
        displayToName[seed.Display] = seed.Name
    end
    
    -- ===== STATE VARIABLES =====
    local selectedDisplay = seedDisplayOptions[1]
    local selectedSeed = displayToName[selectedDisplay]
    local autoBuyEnabled = false
    local autoBuyConnection = nil
    local buyDelay = 2
    local buyQuantity = 1
    
    -- Variable untuk menyimpan references
    local dropdownRef = nil
    local autoToggleRef = nil
    local buyToggleRef = nil
    
    -- ===== FUNGSI CEK REMOTE =====
    local function checkRemote()
        if not RequestShop then
            Bdev:Notify({
                Title = "Error",
                Content = "❌ Remote RequestShop tidak ditemukan!",
                Duration = 4
            })
            return false
        end
        return true
    end
    
    -- ===== FUNGSI BELI BIBIT =====
    local function buySeed(seedName, amount, isAuto)
        if not checkRemote() then return false end
        
        amount = amount or 1
        
        local arguments = {
            [1] = "BUY",
            [2] = seedName,
            [3] = amount
        }
        
        local success, result = pcall(function()
            return RequestShop:InvokeServer(unpack(arguments))
        end)
        
        if success then
            if not isAuto then
                Bdev:Notify({
                    Title = "✅ Berhasil",
                    Content = string.format("%s x%d", seedName, amount),
                    Duration = 2
                })
            end
            return true
        else
            Bdev:Notify({
                Title = "❌ Gagal",
                Content = "Mungkin uang tidak cukup?",
                Duration = 3
            })
            return false
        end
    end
    
    -- ===== AUTO BUY LOOP =====
    local function startAutoBuy()
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
        end
        
        autoBuyEnabled = true
        
        Bdev:Notify({
            Title = "🤖 Auto Buy ON",
            Content = string.format("%s setiap %d detik", selectedDisplay, buyDelay),
            Duration = 3
        })
        
        local lastBuyTime = 0
        autoBuyConnection = RunService.Heartbeat:Connect(function()
            if not autoBuyEnabled then return end
            if tick() - lastBuyTime >= buyDelay then
                buySeed(selectedSeed, buyQuantity, true)
                lastBuyTime = tick()
            end
        end)
    end
    
    local function stopAutoBuy()
        autoBuyEnabled = false
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
            autoBuyConnection = nil
        end
        
        Bdev:Notify({
            Title = "⏹️ Auto Buy OFF",
            Content = "Dihentikan",
            Duration = 2
        })
    end
    
    -- ===== MEMBUAT UI =====
    
    -- 1. DROPDOWN
    dropdownRef = Tab:CreateDropdown({
        Name = "SeedDropdown",
        Text = "Pilih Bibit:",
        Options = seedDisplayOptions,
        Default = seedDisplayOptions[1],
        Callback = function(value)
            selectedDisplay = value
            selectedSeed = displayToName[value]
            
            Bdev:Notify({
                Title = "Bibit Dipilih",
                Content = value,
                Duration = 1
            })
            
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    -- 2. FRAME UNTUK JUMLAH BIBIT (BARIS 1)
    local QuantityFrame = Instance.new("Frame")
    QuantityFrame.Name = "QuantityFrame"
    QuantityFrame.Size = UDim2.new(0.95, 0, 0, 50)
    QuantityFrame.BackgroundColor3 = theme.ContentCard
    QuantityFrame.BackgroundTransparency = 0
    QuantityFrame.BorderSizePixel = 2
    QuantityFrame.BorderColor3 = theme.BorderLight
    QuantityFrame.LayoutOrder = #Tab.Elements + 1
    QuantityFrame.Parent = Tab.Content
    
    -- Rounded corners untuk frame
    local QuantityCorner = Instance.new("UICorner")
    QuantityCorner.CornerRadius = UDim.new(0, 8)
    QuantityCorner.Parent = QuantityFrame
    
    -- Inner frame untuk padding
    local QuantityInner = Instance.new("Frame")
    QuantityInner.Name = "QuantityInner"
    QuantityInner.Size = UDim2.new(1, -4, 1, -4)
    QuantityInner.Position = UDim2.new(0, 2, 0, 2)
    QuantityInner.BackgroundColor3 = theme.ContentCard
    QuantityInner.BackgroundTransparency = 0
    QuantityInner.BorderSizePixel = 0
    QuantityInner.Parent = QuantityFrame
    
    local QuantityInnerCorner = Instance.new("UICorner")
    QuantityInnerCorner.CornerRadius = UDim.new(0, 6)
    QuantityInnerCorner.Parent = QuantityInner
    
    -- Layout horizontal untuk quantity
    local QuantityLayout = Instance.new("UIListLayout")
    QuantityLayout.FillDirection = Enum.FillDirection.Horizontal
    QuantityLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    QuantityLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    QuantityLayout.Padding = UDim.new(0, 10)
    QuantityLayout.Parent = QuantityInner
    
    -- Label "Jumlah Bibit:"
    local QtyLabelText = Instance.new("TextLabel")
    QtyLabelText.Name = "QtyLabelText"
    QtyLabelText.Size = UDim2.new(0, 100, 0, 30)
    QtyLabelText.Text = "Jumlah Bibit:"
    QtyLabelText.TextColor3 = theme.Text
    QtyLabelText.BackgroundTransparency = 1
    QtyLabelText.TextSize = 14
    QtyLabelText.Font = Enum.Font.GothamBold
    QtyLabelText.TextXAlignment = Enum.TextXAlignment.Right
    QtyLabelText.Parent = QuantityInner
    
    -- QUANTITY CONTROL
    local QtyFrame = Instance.new("Frame")
    QtyFrame.Name = "QtyFrame"
    QtyFrame.Size = UDim2.new(0, 120, 0, 36)
    QtyFrame.BackgroundColor3 = theme.InputBg
    QtyFrame.BackgroundTransparency = 0
    QtyFrame.Parent = QuantityInner
    
    local QtyCorner = Instance.new("UICorner")
    QtyCorner.CornerRadius = UDim.new(0, 6)
    QtyCorner.Parent = QtyFrame
    
    local QtyIcon = Instance.new("TextLabel")
    QtyIcon.Name = "QtyIcon"
    QtyIcon.Size = UDim2.new(0, 35, 1, 0)
    QtyIcon.Text = "🔢"
    QtyIcon.TextColor3 = theme.Accent
    QtyIcon.BackgroundTransparency = 1
    QtyIcon.TextSize = 16
    QtyIcon.Font = Enum.Font.GothamBold
    QtyIcon.Parent = QtyFrame
    
    local QtyBox = Instance.new("TextBox")
    QtyBox.Name = "QtyBox"
    QtyBox.Size = UDim2.new(1, -35, 1, 0)
    QtyBox.Position = UDim2.new(0, 35, 0, 0)
    QtyBox.Text = tostring(buyQuantity)
    QtyBox.TextColor3 = theme.Text
    QtyBox.BackgroundTransparency = 1
    QtyBox.TextSize = 14
    QtyBox.Font = Enum.Font.Gotham
    QtyBox.ClearTextOnFocus = false
    QtyBox.Parent = QtyFrame
    
    -- 3. FRAME UNTUK DELAY (BARIS 2)
    local DelayFrame2 = Instance.new("Frame")
    DelayFrame2.Name = "DelayFrame2"
    DelayFrame2.Size = UDim2.new(0.95, 0, 0, 50)
    DelayFrame2.BackgroundColor3 = theme.ContentCard
    DelayFrame2.BackgroundTransparency = 0
    DelayFrame2.BorderSizePixel = 2
    DelayFrame2.BorderColor3 = theme.BorderLight
    DelayFrame2.LayoutOrder = #Tab.Elements + 1
    DelayFrame2.Parent = Tab.Content
    
    -- Rounded corners untuk frame
    local DelayCorner2 = Instance.new("UICorner")
    DelayCorner2.CornerRadius = UDim.new(0, 8)
    DelayCorner2.Parent = DelayFrame2
    
    -- Inner frame untuk padding
    local DelayInner2 = Instance.new("Frame")
    DelayInner2.Name = "DelayInner2"
    DelayInner2.Size = UDim2.new(1, -4, 1, -4)
    DelayInner2.Position = UDim2.new(0, 2, 0, 2)
    DelayInner2.BackgroundColor3 = theme.ContentCard
    DelayInner2.BackgroundTransparency = 0
    DelayInner2.BorderSizePixel = 0
    DelayInner2.Parent = DelayFrame2
    
    local DelayInnerCorner2 = Instance.new("UICorner")
    DelayInnerCorner2.CornerRadius = UDim.new(0, 6)
    DelayInnerCorner2.Parent = DelayInner2
    
    -- Layout horizontal untuk delay
    local DelayLayout2 = Instance.new("UIListLayout")
    DelayLayout2.FillDirection = Enum.FillDirection.Horizontal
    DelayLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DelayLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
    DelayLayout2.Padding = UDim.new(0, 10)
    DelayLayout2.Parent = DelayInner2
    
    -- Label "Delay (detik):"
    local DelayLabelText = Instance.new("TextLabel")
    DelayLabelText.Name = "DelayLabelText"
    DelayLabelText.Size = UDim2.new(0, 100, 0, 30)
    DelayLabelText.Text = "Delay (detik):"
    DelayLabelText.TextColor3 = theme.Text
    DelayLabelText.BackgroundTransparency = 1
    DelayLabelText.TextSize = 14
    DelayLabelText.Font = Enum.Font.GothamBold
    DelayLabelText.TextXAlignment = Enum.TextXAlignment.Right
    DelayLabelText.Parent = DelayInner2
    
    -- DELAY CONTROL
    local DelayFrame = Instance.new("Frame")
    DelayFrame.Name = "DelayFrame"
    DelayFrame.Size = UDim2.new(0, 120, 0, 36)
    DelayFrame.BackgroundColor3 = theme.InputBg
    DelayFrame.BackgroundTransparency = 0
    DelayFrame.Parent = DelayInner2
    
    local DelayCorner = Instance.new("UICorner")
    DelayCorner.CornerRadius = UDim.new(0, 6)
    DelayCorner.Parent = DelayFrame
    
    local DelayIcon = Instance.new("TextLabel")
    DelayIcon.Name = "DelayIcon"
    DelayIcon.Size = UDim2.new(0, 35, 1, 0)
    DelayIcon.Text = "⏱️"
    DelayIcon.TextColor3 = theme.Accent
    DelayIcon.BackgroundTransparency = 1
    DelayIcon.TextSize = 16
    DelayIcon.Font = Enum.Font.GothamBold
    DelayIcon.Parent = DelayFrame
    
    local DelayBox = Instance.new("TextBox")
    DelayBox.Name = "DelayBox"
    DelayBox.Size = UDim2.new(1, -35, 1, 0)
    DelayBox.Position = UDim2.new(0, 35, 0, 0)
    DelayBox.Text = tostring(buyDelay) .. "s"
    DelayBox.TextColor3 = theme.Text
    DelayBox.BackgroundTransparency = 1
    DelayBox.TextSize = 14
    DelayBox.Font = Enum.Font.Gotham
    DelayBox.ClearTextOnFocus = false
    DelayBox.Parent = DelayFrame
    
    -- Validasi Quantity
    QtyBox.FocusLost:Connect(function()
        local value = tonumber(QtyBox.Text)
        if value and value >= 1 and value <= 99 then
            buyQuantity = math.floor(value)
            QtyBox.Text = tostring(buyQuantity)
        else
            QtyBox.Text = tostring(buyQuantity)
            Bdev:Notify({
                Title = "❌ Invalid",
                Content = "Jumlah harus 1-99",
                Duration = 2
            })
        end
    end)
    
    -- Validasi Delay
    DelayBox.FocusLost:Connect(function()
        local text = DelayBox.Text:gsub("s", "")
        local value = tonumber(text)
        if value and value >= 0.5 and value <= 5 then
            buyDelay = value
            DelayBox.Text = tostring(buyDelay) .. "s"
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        else
            DelayBox.Text = tostring(buyDelay) .. "s"
            Bdev:Notify({
                Title = "❌ Invalid",
                Content = "Delay harus 0.5-5 detik",
                Duration = 2
            })
        end
    end)
    
    -- 4. FRAME UNTUK BELI SEKARANG (BARIS 3) - DENGAN TOGGLE
    local BuyFrame = Instance.new("Frame")
    BuyFrame.Name = "BuyFrame"
    BuyFrame.Size = UDim2.new(0.95, 0, 0, 60)
    BuyFrame.BackgroundColor3 = theme.ContentCard
    BuyFrame.BackgroundTransparency = 0
    BuyFrame.BorderSizePixel = 2
    BuyFrame.BorderColor3 = theme.BorderLight
    BuyFrame.LayoutOrder = #Tab.Elements + 1
    BuyFrame.Parent = Tab.Content
    
    local BuyCorner = Instance.new("UICorner")
    BuyCorner.CornerRadius = UDim.new(0, 8)
    BuyCorner.Parent = BuyFrame
    
    local BuyInner = Instance.new("Frame")
    BuyInner.Name = "BuyInner"
    BuyInner.Size = UDim2.new(1, -4, 1, -4)
    BuyInner.Position = UDim2.new(0, 2, 0, 2)
    BuyInner.BackgroundColor3 = theme.ContentCard
    BuyInner.BackgroundTransparency = 0
    BuyInner.BorderSizePixel = 0
    BuyInner.Parent = BuyFrame
    
    local BuyInnerCorner = Instance.new("UICorner")
    BuyInnerCorner.CornerRadius = UDim.new(0, 6)
    BuyInnerCorner.Parent = BuyInner
    
    -- Toggle untuk Beli Sekarang (sekali pakai)
    buyToggleRef = Tab:CreateToggle({
        Name = "BuyNowToggle",
        Text = "Beli Sekarang",  -- Teks di kiri, toggle di kanan
        CurrentValue = false,
        Callback = function(state)
            if state then
                buySeed(selectedSeed, buyQuantity, false)
                -- Kembalikan ke false setelah beli
                task.wait(0.1)
                if buyToggleRef and buyToggleRef.SetValue then
                    buyToggleRef:SetValue(false)
                end
            end
        end
    })
    
    -- Reparent toggle ke BuyInner
    if buyToggleRef and buyToggleRef.Frame then
        buyToggleRef.Frame.Parent = BuyInner
        buyToggleRef.Frame.Size = UDim2.new(1, -20, 0, 40)
    end
    
    -- 5. FRAME UNTUK AUTO BUY (BARIS 4) - DENGAN TOGGLE
    local AutoFrame = Instance.new("Frame")
    AutoFrame.Name = "AutoFrame"
    AutoFrame.Size = UDim2.new(0.95, 0, 0, 60)
    AutoFrame.BackgroundColor3 = theme.ContentCard
    AutoFrame.BackgroundTransparency = 0
    AutoFrame.BorderSizePixel = 2
    AutoFrame.BorderColor3 = theme.BorderLight
    AutoFrame.LayoutOrder = #Tab.Elements + 1
    AutoFrame.Parent = Tab.Content
    
    local AutoCorner = Instance.new("UICorner")
    AutoCorner.CornerRadius = UDim.new(0, 8)
    AutoCorner.Parent = AutoFrame
    
    local AutoInner = Instance.new("Frame")
    AutoInner.Name = "AutoInner"
    AutoInner.Size = UDim2.new(1, -4, 1, -4)
    AutoInner.Position = UDim2.new(0, 2, 0, 2)
    AutoInner.BackgroundColor3 = theme.ContentCard
    AutoInner.BackgroundTransparency = 0
    AutoInner.BorderSizePixel = 0
    AutoInner.Parent = AutoFrame
    
    local AutoInnerCorner = Instance.new("UICorner")
    AutoInnerCorner.CornerRadius = UDim.new(0, 6)
    AutoInnerCorner.Parent = AutoInner
    
    -- Toggle Auto Buy
    autoToggleRef = Tab:CreateToggle({
        Name = "AutoBuyToggle",
        Text = "Auto Buy",  -- Teks di kiri, toggle di kanan
        CurrentValue = autoBuyEnabled,
        Callback = function(state)
            if state then
                if checkRemote() then
                    startAutoBuy()
                else
                    -- Jika gagal, kembalikan toggle ke false
                    if autoToggleRef and autoToggleRef.SetValue then
                        autoToggleRef:SetValue(false)
                    end
                end
            else
                stopAutoBuy()
            end
        end
    })
    
    -- Reparent toggle ke AutoInner
    if autoToggleRef and autoToggleRef.Frame then
        autoToggleRef.Frame.Parent = AutoInner
        autoToggleRef.Frame.Size = UDim2.new(1, -20, 0, 40)
    end
    
    -- 6. FOOTER
    Tab:CreateLabel({
        Name = "Footer",
        Text = "─────────────────────",
        Color = theme.TextMuted,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- ===== CLEANUP FUNCTION =====
    local function cleanup()
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
            autoBuyConnection = nil
        end
        autoBuyEnabled = false
    end
    
    -- ===== SHARE FUNCTIONS =====
    Shared.Modules = Shared.Modules or {}
    Shared.Modules.ShopAutoBuy = {
        BuySeed = function(seedName, amount)
            return buySeed(seedName, amount or 1, false)
        end,
        GetStatus = function()
            return {
                SelectedDisplay = selectedDisplay,
                SelectedSeed = selectedSeed,
                AutoBuyEnabled = autoBuyEnabled,
                Delay = buyDelay,
                Quantity = buyQuantity
            }
        end,
        StopAutoBuy = stopAutoBuy,
        StartAutoBuy = function()
            if checkRemote() then
                startAutoBuy()
                if autoToggleRef and autoToggleRef.SetValue then
                    autoToggleRef:SetValue(true)
                end
            end
        end,
        SetSeed = function(seedDisplay)
            if displayToName[seedDisplay] then
                selectedDisplay = seedDisplay
                selectedSeed = displayToName[seedDisplay]
                if dropdownRef and dropdownRef.SetValue then
                    dropdownRef:SetValue(seedDisplay)
                end
            end
        end,
        SetQuantity = function(value)
            if value and value >= 1 and value <= 99 then
                buyQuantity = math.floor(value)
                QtyBox.Text = tostring(buyQuantity)
            end
        end,
        SetDelay = function(value)
            if value and value >= 0.5 and value <= 5 then
                buyDelay = value
                DelayBox.Text = tostring(value) .. "s"
                if autoBuyEnabled then
                    stopAutoBuy()
                    startAutoBuy()
                end
            end
        end
    }
    
    print("✅ Shop module loaded - Bee Futuristic Edition")
    
    return cleanup
end

return ShopAutoBuy