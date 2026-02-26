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
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 210),
        Button = Color3.fromRGB(25, 25, 32),
        ButtonHover = Color3.fromRGB(45, 45, 55),
        InputBg = Color3.fromRGB(30, 30, 40),
        ToggleOff = Color3.fromRGB(50, 50, 60),
        BorderLight = Color3.fromRGB(70, 70, 80),
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
    
    -- ===== CREATE TEXTBOX LOKAL (agar tidak mengganggu SimpleGUI) =====
    local function createTextBox(options)
        local opts = options or {}
        
        -- Main frame dengan border
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = opts.Name or "TextBox_" .. math.random(1000, 9999)
        MainFrame.Size = UDim2.new(0.95, 0, 0, 40)
        MainFrame.BackgroundColor3 = theme.ContentCard
        MainFrame.BackgroundTransparency = 0
        MainFrame.BorderSizePixel = 2
        MainFrame.BorderColor3 = theme.BorderLight
        MainFrame.LayoutOrder = #Tab.Elements + 1
        MainFrame.Parent = Tab.Content
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 6)
        MainCorner.Parent = MainFrame
        
        -- Inner frame untuk padding
        local InnerFrame = Instance.new("Frame")
        InnerFrame.Name = "InnerFrame"
        InnerFrame.Size = UDim2.new(1, -4, 1, -4)
        InnerFrame.Position = UDim2.new(0, 2, 0, 2)
        InnerFrame.BackgroundColor3 = theme.ContentCard
        InnerFrame.BackgroundTransparency = 0
        InnerFrame.BorderSizePixel = 0
        InnerFrame.Parent = MainFrame
        
        local InnerCorner = Instance.new("UICorner")
        InnerCorner.CornerRadius = UDim.new(0, 4)
        InnerCorner.Parent = InnerFrame
        
        -- Layout horizontal
        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = InnerFrame
        
        -- Label di KIRI
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(0, 100, 0, 30)
        Label.Text = opts.Label or "Input:"
        Label.TextColor3 = theme.Text
        Label.BackgroundTransparency = 1
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamBold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = InnerFrame
        
        -- Input frame di KANAN
        local InputFrame = Instance.new("Frame")
        InputFrame.Name = "InputFrame"
        InputFrame.Size = UDim2.new(0, 150, 0, 32)
        InputFrame.BackgroundColor3 = theme.InputBg
        InputFrame.BackgroundTransparency = 0
        InputFrame.Parent = InnerFrame
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 5)
        InputCorner.Parent = InputFrame
        
        -- Icon (optional)
        local Icon = Instance.new("TextLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 32, 1, 0)
        Icon.Text = opts.Icon or "📝"
        Icon.TextColor3 = theme.Accent
        Icon.BackgroundTransparency = 1
        Icon.TextSize = 16
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = InputFrame
        
        -- TextBox
        local TextBox = Instance.new("TextBox")
        TextBox.Name = "TextBox"
        TextBox.Size = UDim2.new(1, -32, 1, 0)
        TextBox.Position = UDim2.new(0, 32, 0, 0)
        TextBox.Text = opts.Text or ""
        TextBox.TextColor3 = theme.Text
        TextBox.BackgroundTransparency = 1
        TextBox.TextSize = 14
        TextBox.Font = Enum.Font.Gotham
        TextBox.ClearTextOnFocus = false
        TextBox.Parent = InputFrame
        
        -- Placeholder
        if opts.Placeholder and TextBox.Text == "" then
            TextBox.Text = opts.Placeholder
            TextBox.TextColor3 = theme.TextMuted
        end
        
        -- Focus handling
        TextBox.Focused:Connect(function()
            if TextBox.Text == opts.Placeholder then
                TextBox.Text = ""
                TextBox.TextColor3 = theme.Text
            end
        end)
        
        TextBox.FocusLost:Connect(function(enterPressed)
            if opts.Callback then
                local newText = opts.Callback(TextBox.Text)
                if newText then
                    TextBox.Text = newText
                end
            end
            
            if TextBox.Text == "" and opts.Placeholder then
                TextBox.Text = opts.Placeholder
                TextBox.TextColor3 = theme.TextMuted
            end
        end)
        
        -- Return object dengan method
        local textBoxObj = {
            Frame = MainFrame,
            TextBox = TextBox,
            SetText = function(self, text)
                TextBox.Text = tostring(text)
                TextBox.TextColor3 = theme.Text
            end,
            GetText = function(self)
                return TextBox.Text
            end
        }
        
        table.insert(Tab.Elements, MainFrame)
        return textBoxObj
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
    local qtyBoxRef = nil
    local delayBoxRef = nil
    
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
        Text = "🌱 Pilih Bibit",
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
    
    -- 2. JUMLAH BIBIT - TEXTBOX
    qtyBoxRef = createTextBox({
        Name = "QuantityBox",
        Label = "🔢 Jumlah Bibit",
        Icon = "🔢",
        Text = tostring(buyQuantity),
        Placeholder = "1-99",
        Callback = function(text)
            local value = tonumber(text)
            if value and value >= 1 and value <= 99 then
                buyQuantity = math.floor(value)
                return tostring(buyQuantity)
            else
                Bdev:Notify({
                    Title = "❌ Invalid",
                    Content = "Jumlah harus 1-99",
                    Duration = 2
                })
                return tostring(buyQuantity)
            end
        end
    })
    
    -- 3. DELAY - TEXTBOX
    delayBoxRef = createTextBox({
        Name = "DelayBox",
        Label = "⏱️ Delay (detik)",
        Icon = "⏱️",
        Text = tostring(buyDelay) .. "s",
        Placeholder = "0.5-5",
        Callback = function(text)
            local cleanText = text:gsub("s", "")
            local value = tonumber(cleanText)
            if value and value >= 0.5 and value <= 5 then
                buyDelay = value
                if autoBuyEnabled then
                    stopAutoBuy()
                    startAutoBuy()
                end
                return tostring(value) .. "s"
            else
                Bdev:Notify({
                    Title = "❌ Invalid",
                    Content = "Delay harus 0.5-5 detik",
                    Duration = 2
                })
                return tostring(buyDelay) .. "s"
            end
        end
    })
    
    -- 4. BELI SEKARANG (TOGGLE)
    buyToggleRef = Tab:CreateToggle({
        Name = "BuyNowToggle",
        Text = "🛒 Beli Sekarang",
        CurrentValue = false,
        Callback = function(state)
            if state then
                buySeed(selectedSeed, buyQuantity, false)
                task.wait(0.1)
                if buyToggleRef and buyToggleRef.SetValue then
                    buyToggleRef:SetValue(false)
                end
            end
        end
    })
    
    -- 5. AUTO BUY (TOGGLE)
    autoToggleRef = Tab:CreateToggle({
        Name = "AutoBuyToggle",
        Text = "🤖 Auto Buy",
        CurrentValue = autoBuyEnabled,
        Callback = function(state)
            if state then
                if checkRemote() then
                    startAutoBuy()
                else
                    if autoToggleRef and autoToggleRef.SetValue then
                        autoToggleRef:SetValue(false)
                    end
                end
            else
                stopAutoBuy()
            end
        end
    })
    
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
                if qtyBoxRef and qtyBoxRef.SetText then
                    qtyBoxRef:SetText(tostring(buyQuantity))
                end
            end
        end,
        SetDelay = function(value)
            if value and value >= 0.5 and value <= 5 then
                buyDelay = value
                if delayBoxRef and delayBoxRef.SetText then
                    delayBoxRef:SetText(tostring(value) .. "s")
                end
                if autoBuyEnabled then
                    stopAutoBuy()
                    startAutoBuy()
                end
            end
        end
    }
    
    print("✅ Shop module loaded - Dengan TextBox lokal")
    
    return cleanup
end

return ShopAutoBuy