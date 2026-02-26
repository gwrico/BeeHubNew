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
        ToggleOff = Color3.fromRGB(50, 50, 60)
    }
    
    -- Get services
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    
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
        {Display = "None", Name = "None"}
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
    local infoLabelRef = nil
    local qtyInputRef = nil
    local delayInputRef = nil
    local autoBuyToggleRef = nil
    
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
            -- Hanya tampilkan notifikasi jika MANUAL (bukan auto)
            if not isAuto then
                Bdev:Notify({
                    Title = "✅ Berhasil",
                    Content = string.format("%s x%d", seedName, amount),
                    Duration = 2
                })
            end
            return true
        else
            -- Notifikasi error tetap tampil
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
                buySeed(selectedSeed, buyQuantity)
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
    
    -- ===== FUNGSI UPDATE INFO LABEL =====
    local function updateInfoLabel()
        if infoLabelRef then
            infoLabelRef.Text = "➤ Bibit aktif: " .. selectedDisplay
        end
    end
    
    -- ===== MEMBUAT UI DENGAN DROPDOWN =====
    
    -- 1. PILIH BIBIT SECTION
    local header1 = Tab:CreateLabel({
        Name = "Header_PilihBibit",
        Text = "───── 🌱 PILIH BIBIT ─────",
        Color = theme.Accent,  -- MERAH
        Bold = true,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- DROPDOWN untuk memilih bibit
    dropdownRef = Tab:CreateDropdown({
        Name = "SeedDropdown",
        Text = "Pilih Bibit:",
        Options = seedDisplayOptions,
        Default = seedDisplayOptions[1],
        Callback = function(value)
            selectedDisplay = value
            selectedSeed = displayToName[value]
            updateInfoLabel()
            
            Bdev:Notify({
                Title = "Bibit Dipilih",
                Content = value,
                Duration = 1
            })
            
            print("✅ Dipilih:", value, "->", selectedSeed)
            
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    -- Label info untuk menampilkan bibit yang dipilih
    infoLabelRef = Tab:CreateLabel({
        Name = "InfoLabel",
        Text = "➤ Bibit aktif: " .. selectedDisplay,
        Color = theme.Text,  -- PUTIH
        Alignment = Enum.TextXAlignment.Left
    })
    
    -- Spacer
    Tab:CreateLabel({
        Name = "Spacer1",
        Text = "",
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- 2. PENGATURAN & AUTO BUY SECTION
    local header2 = Tab:CreateLabel({
        Name = "Header_PengaturanAuto",
        Text = "───── ⚙️ PENGATURAN & AUTO BUY ─────",
        Color = theme.Accent,  -- MERAH
        Bold = true,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- Frame untuk pengaturan dalam satu baris
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Size = UDim2.new(0.95, 0, 0, 40)
    SettingsFrame.BackgroundTransparency = 1
    SettingsFrame.LayoutOrder = #Tab.Elements + 1
    SettingsFrame.Parent = Tab.Content
    
    -- Layout horizontal untuk settings
    local SettingsLayout = Instance.new("UIListLayout")
    SettingsLayout.FillDirection = Enum.FillDirection.Horizontal
    SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SettingsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SettingsLayout.Padding = UDim.new(0, 10)
    SettingsLayout.Parent = SettingsFrame
    
    -- TextBox untuk Jumlah
    local QtyFrame = Instance.new("Frame")
    QtyFrame.Name = "QtyFrame"
    QtyFrame.Size = UDim2.new(0, 80, 0, 36)
    QtyFrame.BackgroundColor3 = theme.InputBg  -- HITAM
    QtyFrame.BackgroundTransparency = 0
    QtyFrame.Parent = SettingsFrame
    
    local QtyCorner = Instance.new("UICorner")
    QtyCorner.CornerRadius = UDim.new(0, 6)
    QtyCorner.Parent = QtyFrame
    
    local QtyLabel = Instance.new("TextLabel")
    QtyLabel.Name = "QtyLabel"
    QtyLabel.Size = UDim2.new(0, 30, 1, 0)
    QtyLabel.Text = "x"
    QtyLabel.TextColor3 = theme.Accent  -- MERAH
    QtyLabel.BackgroundTransparency = 1
    QtyLabel.TextSize = 16
    QtyLabel.Font = Enum.Font.GothamBold
    QtyLabel.Parent = QtyFrame
    
    local QtyBox = Instance.new("TextBox")
    QtyBox.Name = "QtyBox"
    QtyBox.Size = UDim2.new(1, -30, 1, 0)
    QtyBox.Position = UDim2.new(0, 30, 0, 0)
    QtyBox.Text = tostring(buyQuantity)
    QtyBox.TextColor3 = theme.Text  -- PUTIH
    QtyBox.BackgroundTransparency = 1
    QtyBox.TextSize = 14
    QtyBox.Font = Enum.Font.Gotham
    QtyBox.ClearTextOnFocus = false
    QtyBox.Parent = QtyFrame
    
    -- TextBox untuk Delay
    local DelayFrame = Instance.new("Frame")
    DelayFrame.Name = "DelayFrame"
    DelayFrame.Size = UDim2.new(0, 100, 0, 36)
    DelayFrame.BackgroundColor3 = theme.InputBg  -- HITAM
    DelayFrame.BackgroundTransparency = 0
    DelayFrame.Parent = SettingsFrame
    
    local DelayCorner = Instance.new("UICorner")
    DelayCorner.CornerRadius = UDim.new(0, 6)
    DelayCorner.Parent = DelayFrame
    
    local DelayLabel = Instance.new("TextLabel")
    DelayLabel.Name = "DelayLabel"
    DelayLabel.Size = UDim2.new(0, 40, 1, 0)
    DelayLabel.Text = "⏱️"
    DelayLabel.TextColor3 = theme.Accent  -- MERAH
    DelayLabel.BackgroundTransparency = 1
    DelayLabel.TextSize = 16
    DelayLabel.Font = Enum.Font.GothamBold
    DelayLabel.Parent = DelayFrame
    
    local DelayBox = Instance.new("TextBox")
    DelayBox.Name = "DelayBox"
    DelayBox.Size = UDim2.new(1, -40, 1, 0)
    DelayBox.Position = UDim2.new(0, 40, 0, 0)
    DelayBox.Text = tostring(buyDelay) .. "s"
    DelayBox.TextColor3 = theme.Text  -- PUTIH
    DelayBox.BackgroundTransparency = 1
    DelayBox.TextSize = 14
    DelayBox.Font = Enum.Font.Gotham
    DelayBox.ClearTextOnFocus = false
    DelayBox.Parent = DelayFrame
    
    -- Fungsi untuk validasi input
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
    
    -- Tombol Aksi Cepat
    local ActionFrame = Instance.new("Frame")
    ActionFrame.Name = "ActionFrame"
    ActionFrame.Size = UDim2.new(0.95, 0, 0, 40)
    ActionFrame.BackgroundTransparency = 1
    ActionFrame.LayoutOrder = #Tab.Elements + 1
    ActionFrame.Parent = Tab.Content
    
    local ActionLayout = Instance.new("UIListLayout")
    ActionLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ActionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ActionLayout.Padding = UDim.new(0, 10)
    ActionLayout.Parent = ActionFrame
    
    -- Tombol Beli Sekarang
    local BuyNowBtn = Instance.new("TextButton")
    BuyNowBtn.Name = "BuyNowBtn"
    BuyNowBtn.Size = UDim2.new(0, 120, 0, 36)
    BuyNowBtn.Text = "🛒 BELI"
    BuyNowBtn.TextColor3 = theme.Text  -- PUTIH
    BuyNowBtn.BackgroundColor3 = theme.Accent  -- MERAH
    BuyNowBtn.BackgroundTransparency = 0
    BuyNowBtn.TextSize = 14
    BuyNowBtn.Font = Enum.Font.GothamBold
    BuyNowBtn.AutoButtonColor = false
    BuyNowBtn.Parent = ActionFrame
    
    local BuyCorner = Instance.new("UICorner")
    BuyCorner.CornerRadius = UDim.new(0, 6)
    BuyCorner.Parent = BuyNowBtn
    
    BuyNowBtn.MouseButton1Click:Connect(function()
        buySeed(selectedSeed, buyQuantity)
    end)
    
    -- Toggle Auto Buy
    local AutoToggleBtn = Instance.new("TextButton")
    AutoToggleBtn.Name = "AutoToggleBtn"
    AutoToggleBtn.Size = UDim2.new(0, 120, 0, 36)
    AutoToggleBtn.Text = "🤖 AUTO OFF"
    AutoToggleBtn.TextColor3 = theme.Text  -- PUTIH
    AutoToggleBtn.BackgroundColor3 = theme.ToggleOff  -- ABU-ABU
    AutoToggleBtn.BackgroundTransparency = 0
    AutoToggleBtn.TextSize = 14
    AutoToggleBtn.Font = Enum.Font.GothamBold
    AutoToggleBtn.AutoButtonColor = false
    AutoToggleBtn.Parent = ActionFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = AutoToggleBtn
    
    -- Fungsi untuk update tampilan tombol auto
    local function updateAutoButton()
        if autoBuyEnabled then
            AutoToggleBtn.Text = "🤖 AUTO ON"
            AutoToggleBtn.BackgroundColor3 = theme.Accent  -- MERAH
        else
            AutoToggleBtn.Text = "🤖 AUTO OFF"
            AutoToggleBtn.BackgroundColor3 = theme.ToggleOff  -- ABU-ABU
        end
    end
    
    AutoToggleBtn.MouseButton1Click:Connect(function()
        if not autoBuyEnabled then
            if checkRemote() then
                startAutoBuy()
            end
        else
            stopAutoBuy()
        end
        updateAutoButton()
    end)
    
    -- Tombol Stop (X)
    local StopBtn = Instance.new("TextButton")
    StopBtn.Name = "StopBtn"
    StopBtn.Size = UDim2.new(0, 40, 0, 36)
    StopBtn.Text = "✕"
    StopBtn.TextColor3 = theme.Error or Color3.fromRGB(255, 70, 70)  -- MERAH ERROR
    StopBtn.BackgroundColor3 = theme.Button  -- HITAM
    StopBtn.BackgroundTransparency = 0
    StopBtn.TextSize = 16
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.AutoButtonColor = false
    StopBtn.Parent = ActionFrame
    
    local StopCorner = Instance.new("UICorner")
    StopCorner.CornerRadius = UDim.new(0, 6)
    StopCorner.Parent = StopBtn
    
    StopBtn.MouseButton1Click:Connect(function()
        if autoBuyEnabled then
            stopAutoBuy()
            updateAutoButton()
        end
    end)
    
    -- Hover effects dengan TWEEN
    local function setupHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = hoverColor}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = normalColor}, 0.15)
        end)
    end
    
    setupHover(BuyNowBtn, theme.Accent, theme.AccentLight or Color3.fromRGB(255, 60, 60))
    setupHover(StopBtn, theme.Button, theme.ButtonHover)
    
    -- Hover untuk AutoToggleBtn (efek khusus)
    AutoToggleBtn.MouseEnter:Connect(function()
        if not autoBuyEnabled then
            tween(AutoToggleBtn, {BackgroundColor3 = theme.ButtonHover}, 0.15)
        else
            tween(AutoToggleBtn, {BackgroundColor3 = theme.AccentLight or Color3.fromRGB(255, 60, 60)}, 0.15)
        end
    end)
    
    AutoToggleBtn.MouseLeave:Connect(function()
        if not autoBuyEnabled then
            tween(AutoToggleBtn, {BackgroundColor3 = theme.ToggleOff}, 0.15)
        else
            tween(AutoToggleBtn, {BackgroundColor3 = theme.Accent}, 0.15)
        end
    end)
    
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
            return buySeed(seedName, amount or 1)
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
                updateAutoButton()
            end
        end,
        SetSeed = function(seedDisplay)
            if displayToName[seedDisplay] then
                selectedDisplay = seedDisplay
                selectedSeed = displayToName[seedDisplay]
                if dropdownRef and dropdownRef.SetValue then
                    dropdownRef:SetValue(seedDisplay)
                end
                updateInfoLabel()
            end
        end,
        SetQuantity = function(value)
            if value >= 1 and value <= 10 then
                buyQuantity = value
                QtyBox.Text = tostring(value)
            end
        end,
        SetDelay = function(value)
            if value >= 0.5 and value <= 5 then
                buyDelay = value
                DelayBox.Text = tostring(value) .. "s"
            end
        end
    }
    
    print("✅ Shop module loaded - Bee Futuristic Edition")
    
    return cleanup
end

return ShopAutoBuy