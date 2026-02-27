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
    local qtyInputRef = nil
    local delayInputRef = nil
    local searchBarRef = nil
    
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
    
    -- ===== MEMBUAT UI DENGAN TABGROUP =====
    
    -- Buat TabGroup utama
    local shopGroup = Tab:CreateTabGroup({Name = "🛒 SHOP MENU"})
    
    -- ===== TAB 1: PENCARIAN & PEMILIHAN =====
    local searchTab = shopGroup:CreateSubTab("🔍 Cari")
    
    -- SEARCH BAR untuk filter bibit
    searchBarRef = searchTab:CreateSearchBar({
        Name = "SeedSearch",
        Text = "🔍 Cari Bibit",
        Placeholder = "Ketik nama bibit...",
        Data = seedDisplayOptions,
        Callback = function(result)
            if result then
                -- Update dropdown dengan hasil pencarian
                selectedDisplay = result
                selectedSeed = displayToName[result]
                if dropdownRef and dropdownRef.SetValue then
                    dropdownRef:SetValue(result)
                end
                
                Bdev:Notify({
                    Title = "Bibit Dipilih",
                    Content = result,
                    Duration = 1
                })
            end
        end
    })
    
    -- DROPDOWN
    dropdownRef = searchTab:CreateDropdown({
        Name = "SeedDropdown",
        Text = "🌱 Pilih Bibit",
        Options = seedDisplayOptions,
        Default = seedDisplayOptions[1],
        Callback = function(value)
            selectedDisplay = value
            selectedSeed = displayToName[value]
            
            -- Update search bar text (optional)
            if searchBarRef and searchBarRef.SetText then
                searchBarRef:SetText("")
            end
            
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
    
    -- Info label
    searchTab:CreateLabel({
        Name = "InfoLabel",
        Text = "🔍 Ketik nama bibit atau pilih dari dropdown",
        Color = theme.TextMuted,
        Size = 11,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- ===== TAB 2: KONFIGURASI =====
    local configTab = shopGroup:CreateSubTab("⚙️ Config")
    
    -- JUMLAH BIBIT - CreateInput (number)
    qtyInputRef = configTab:CreateInput({
        Name = "QuantityInput",
        Text = "🔢 Jumlah Bibit",
        InputType = "number",
        DefaultValue = tostring(buyQuantity),
        Min = 1,
        Max = 99,
        Step = 1,
        ShowControls = true,
        LiveUpdate = false,
        Callback = function(value, enterPressed)
            local numValue = tonumber(value) or 1
            numValue = math.clamp(numValue, 1, 99)
            buyQuantity = math.floor(numValue)
            
            -- Update display jika perlu
            if qtyInputRef and qtyInputRef.SetValue then
                qtyInputRef:SetValue(tostring(buyQuantity))
            end
            
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    -- DELAY - CreateInput (number)
    delayInputRef = configTab:CreateInput({
        Name = "DelayInput",
        Text = "⏱️ Delay (detik)",
        InputType = "number",
        DefaultValue = tostring(buyDelay),
        Min = 0.5,
        Max = 5,
        Step = 0.5,
        ShowControls = true,
        Unit = "s",
        LiveUpdate = false,
        Callback = function(value, enterPressed)
            local numValue = tonumber(value) or 2
            numValue = math.clamp(numValue, 0.5, 5)
            buyDelay = numValue
            
            -- Update display
            if delayInputRef and delayInputRef.SetValue then
                delayInputRef:SetValue(tostring(buyDelay))
            end
            
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    -- Info konfigurasi
    configTab:CreateLabel({
        Name = "ConfigInfo",
        Text = "⚙️ Atur jumlah dan delay pembelian",
        Color = theme.TextMuted,
        Size = 11,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- ===== TAB 3: AKSI & STATUS =====
    local actionTab = shopGroup:CreateSubTab("🎮 Aksi")
    
    -- BELI SEKARANG - CreateButton
    local buyButton = actionTab:CreateButton({
        Name = "BuyNowButton",
        Text = "🛒 Beli Sekarang",
        Callback = function()
            buySeed(selectedSeed, buyQuantity, false)
        end
    })
    
    -- AUTO BUY - Toggle
    autoToggleRef = actionTab:CreateToggle({
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
    
    -- Status label
    local statusLabel = actionTab:CreateLabel({
        Name = "StatusLabel",
        Text = string.format("➤ Bibit: %s\n➤ Jumlah: %d\n➤ Delay: %.1fs", 
            selectedDisplay, buyQuantity, buyDelay),
        Color = theme.TextSecondary,
        Size = 12,
        Alignment = Enum.TextXAlignment.Left
    })
    
    -- Update status label
    local function updateStatusLabel()
        if statusLabel then
            statusLabel.Text = string.format("➤ Bibit: %s\n➤ Jumlah: %d\n➤ Delay: %.1fs", 
                selectedDisplay, buyQuantity, buyDelay)
        end
    end
    
    -- Hook ke callback untuk update label
    local originalQtyCallback = qtyInputRef.Callback
    qtyInputRef.Callback = function(value, enterPressed)
        if originalQtyCallback then
            originalQtyCallback(value, enterPressed)
        end
        updateStatusLabel()
    end
    
    local originalDelayCallback = delayInputRef.Callback
    delayInputRef.Callback = function(value, enterPressed)
        if originalDelayCallback then
            originalDelayCallback(value, enterPressed)
        end
        updateStatusLabel()
    end
    
    -- Info tambahan
    actionTab:CreateLabel({
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
                updateStatusLabel()
            end
        end,
        SetQuantity = function(value)
            if value and value >= 1 and value <= 99 then
                buyQuantity = math.floor(value)
                if qtyInputRef and qtyInputRef.SetValue then
                    qtyInputRef:SetValue(tostring(buyQuantity))
                end
                updateStatusLabel()
            end
        end,
        SetDelay = function(value)
            if value and value >= 0.5 and value <= 5 then
                buyDelay = value
                if delayInputRef and delayInputRef.SetValue then
                    delayInputRef:SetValue(tostring(buyDelay))
                end
                if autoBuyEnabled then
                    stopAutoBuy()
                    startAutoBuy()
                end
                updateStatusLabel()
            end
        end,
        SearchSeed = function(query)
            if searchBarRef and searchBarRef.SetText then
                searchBarRef:SetText(query)
            end
        end,
        SwitchToTab = function(tabName)
            -- Fungsi untuk berpindah tab (search, config, action)
            if tabName == "search" then
                -- Pindah ke tab pertama
                -- Implementasi tergantung bagaimana tab group diakses
            elseif tabName == "config" then
                -- Pindah ke tab kedua
            elseif tabName == "action" then
                -- Pindah ke tab ketiga
            end
        end
    }
    
    print("✅ Shop module loaded - Dengan TabGroup (Search, Config, Action)")
    
    return cleanup
end

return ShopAutoBuy