-- ==============================================
-- 🛒 SHOP MODULE - BELI BIBIT (BEE FUTURISTIC EDITION)
-- ==============================================

local ShopAutoBuy = {}

function ShopAutoBuy.Init(Dependencies)
    local Tab = Dependencies.Tab  -- <-- INI object tab ASLI dari SimpleGUI
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
    
    local seedDisplayOptions = {}
    for i, seed in ipairs(seedsList) do
        seedDisplayOptions[i] = seed.Display
    end
    
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
    
    -- ===== FUNGSI-FUNGSI =====
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
    
    local function buySeed(seedName, amount, isAuto)
        if not checkRemote() then return false end
        amount = amount or 1
        
        local success = pcall(function()
            return RequestShop:InvokeServer("BUY", seedName, amount)
        end)
        
        if success and not isAuto then
            Bdev:Notify({
                Title = "✅ Berhasil",
                Content = string.format("%s x%d", seedName, amount),
                Duration = 2
            })
        end
        return success
    end
    
    local function startAutoBuy()
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
        end
        autoBuyEnabled = true
        
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
    end
    
    -- ===== DEBUG: CEK METHOD =====
    print("=== METHOD YANG TERSEDIA DI TAB ===")
    for k, v in pairs(Tab) do
        if type(v) == "function" then
            print("✅ " .. tostring(k))
        end
    end
    print("===================================")
    
    -- ===== MEMBUAT UI (TANPA TABGROUP) =====
    
    -- SECTION 1: PEMILIHAN BIBIT
    Tab:CreateSection("🌱 PILIH BIBIT")
    
    local dropdownRef = Tab:CreateDropdown({
        Name = "SeedDropdown",
        Text = "🌱 Pilih Bibit",
        Options = seedDisplayOptions,
        Default = seedDisplayOptions[1],
        Callback = function(value)
            selectedDisplay = value
            selectedSeed = displayToName[value]
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    -- SECTION 2: KONFIGURASI
    Tab:CreateSection("⚙️ KONFIGURASI")
    
    local qtyInputRef = Tab:CreateInput({
        Name = "QuantityInput",
        Text = "🔢 Jumlah",
        InputType = "number",
        DefaultValue = tostring(buyQuantity),
        Min = 1,
        Max = 99,
        Step = 1,
        ShowControls = true,
        Callback = function(value)
            buyQuantity = tonumber(value) or 1
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    local delayInputRef = Tab:CreateInput({
        Name = "DelayInput",
        Text = "⏱️ Delay",
        InputType = "number",
        DefaultValue = tostring(buyDelay),
        Min = 0.5,
        Max = 5,
        Step = 0.5,
        ShowControls = true,
        Unit = "s",
        Callback = function(value)
            buyDelay = tonumber(value) or 2
            if autoBuyEnabled then
                stopAutoBuy()
                startAutoBuy()
            end
        end
    })
    
    -- SECTION 3: AKSI
    Tab:CreateSection("🎮 AKSI")
    
    local buyButton = Tab:CreateButton({
        Name = "BuyNowButton",
        Text = "🛒 Beli Sekarang",
        Callback = function()
            buySeed(selectedSeed, buyQuantity, false)
        end
    })
    
    local autoToggleRef = Tab:CreateToggle({
        Name = "AutoBuyToggle",
        Text = "🤖 Auto Buy",
        CurrentValue = autoBuyEnabled,
        Callback = function(state)
            if state then
                if checkRemote() then
                    startAutoBuy()
                else
                    autoToggleRef:SetValue(false)
                end
            else
                stopAutoBuy()
            end
        end
    })
    
    -- ===== CLEANUP =====
    local function cleanup()
        stopAutoBuy()
    end
    
    -- ===== SHARE FUNCTIONS =====
    Shared.Modules = Shared.Modules or {}
    Shared.Modules.ShopAutoBuy = {
        BuySeed = function(seedName, amount)
            return buySeed(seedName, amount or 1, false)
        end,
        StopAutoBuy = stopAutoBuy,
        StartAutoBuy = function()
            if checkRemote() then
                startAutoBuy()
                autoToggleRef:SetValue(true)
            end
        end
    }
    
    print("✅ Shop module loaded (simple version)")
    return cleanup
end

return ShopAutoBuy