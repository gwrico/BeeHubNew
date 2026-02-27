-- ==============================================
-- 🛒 TAB SHOP - BELI BIBIT (BEE FUTURISTIC EDITION)
-- ==============================================

local ShopAutoBuy = {}

function ShopAutoBuy.Init(Dependencies)
    -- ===== VALIDASI DEPENDENCIES =====
    if not Dependencies then
        error("❌ Dependencies tidak ada!")
    end
    
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local GUI = Dependencies.GUI
    local Bdev = Dependencies.Bdev
    
    -- ===== VALIDASI TAB =====
    if not Tab then
        error("❌ Tab tidak ditemukan di Dependencies!")
    end
    
    -- ===== DEBUG: CEK METHOD TAB =====
    --print("=== SHOP MODULE DEBUG ===")
    --print("✅ Tab diterima, type:", typeof(Tab))
    
    local methods = {}
    for k, v in pairs(Tab) do
        if type(v) == "function" then
            table.insert(methods, tostring(k))
        end
    end
    --print("Method tersedia (" .. #methods .. "):", table.concat(methods, ", "))
    --print("==========================")
    
    -- ===== AMBIL THEME =====
    local theme
    if GUI and GUI.GetTheme then
        theme = GUI:GetTheme()
    else
        -- Fallback theme
        theme = {
            Accent = Color3.fromRGB(255, 40, 40),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 200, 210),
            TextMuted = Color3.fromRGB(140, 140, 150),
            Button = Color3.fromRGB(25, 25, 32),
            ButtonHover = Color3.fromRGB(45, 45, 55),
            InputBg = Color3.fromRGB(30, 30, 40),
            ToggleOff = Color3.fromRGB(50, 50, 60),
            BorderLight = Color3.fromRGB(70, 70, 80),
            ContentCard = Color3.fromRGB(20, 20, 25)
        }
    end
    
    -- ===== GET SERVICES =====
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
    
    -- ===== FUNGSI NOTIFIKASI =====
    local function notify(title, content, duration)
        if Bdev and Bdev.Notify then
            Bdev:Notify({
                Title = title,
                Content = content,
                Duration = duration or 3
            })
        else
            --print(string.format("[%s] %s", title, content))
        end
    end
    
    -- ===== FUNGSI CEK REMOTE =====
    local function checkRemote()
        if not RequestShop then
            notify("Error", "❌ Remote RequestShop tidak ditemukan!", 4)
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
        
        local success = pcall(function()
            return RequestShop:InvokeServer(unpack(arguments))
        end)
        
        if success then
            if not isAuto then
                notify("✅ Berhasil", string.format("%s x%d", seedName, amount), 2)
            end
            return true
        else
            notify("❌ Gagal", "Mungkin uang tidak cukup?", 3)
            return false
        end
    end
    
    -- ===== AUTO BUY LOOP =====
    local function startAutoBuy()
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
        end
        
        autoBuyEnabled = true
        notify("🤖 Auto Buy ON", string.format("%s setiap %d detik", selectedDisplay, buyDelay), 3)
        
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
        notify("⏹️ Auto Buy OFF", "Dihentikan", 2)
    end
    
    -- ===== MEMBUAT UI =====
    
    -- DROPDOWN (PILIH BIBIT)
    local dropdownRef
    if Tab.CreateDropdown then
        dropdownRef = Tab:CreateDropdown({
            Name = "SeedDropdown",
            Text = "🌱 Pilih Bibit",
            Options = seedDisplayOptions,
            Default = seedDisplayOptions[1],
            Callback = function(value)
                selectedDisplay = value
                selectedSeed = displayToName[value]
                notify("Bibit Dipilih", value, 1)
                
                if autoBuyEnabled then
                    stopAutoBuy()
                    startAutoBuy()
                end
            end
        })
    end
    
    -- JUMLAH BIBIT
    if Tab.CreateInput then
        Tab:CreateInput({
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
    end
    
    -- DELAY
    if Tab.CreateInput then
        Tab:CreateInput({
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
    end
    
    -- BELI SEKARANG
    if Tab.CreateButton then
        Tab:CreateButton({
            Name = "BuyNowButton",
            Text = "🛒 Beli Sekarang",
            Callback = function()
                buySeed(selectedSeed, buyQuantity, false)
            end
        })
    end
    
    -- AUTO BUY
    if Tab.CreateToggle then
        Tab:CreateToggle({
            Name = "AutoBuyToggle",
            Text = "🤖 Auto Buy",
            CurrentValue = autoBuyEnabled,
            Callback = function(state)
                if state then
                    if checkRemote() then
                        startAutoBuy()
                    else
                        -- Jika gagal, toggle akan kembali mati
                        task.wait(0.1)
                        -- Cara mengubah nilai toggle perlu disesuaikan dengan implementasi SimpleGUI
                    end
                else
                    stopAutoBuy()
                end
            end
        })
    end
    
    -- FOOTER
    if Tab.CreateLabel then
        Tab:CreateLabel({
            Name = "Footer",
            Text = "─────────────────────",
            Color = theme.TextMuted,
            Alignment = Enum.TextXAlignment.Center
        })
    end
    
    -- ===== CLEANUP =====
    local function cleanup()
        stopAutoBuy()
    end
    
    -- ===== SHARE FUNCTIONS =====
    if Shared then
        Shared.Modules = Shared.Modules or {}
        Shared.Modules.ShopAutoBuy = {
            BuySeed = function(seedName, amount)
                return buySeed(seedName, amount or 1, false)
            end,
            StopAutoBuy = stopAutoBuy,
            StartAutoBuy = function()
                if checkRemote() then
                    startAutoBuy()
                end
            end,
            GetStatus = function()
                return {
                    SelectedDisplay = selectedDisplay,
                    SelectedSeed = selectedSeed,
                    AutoBuyEnabled = autoBuyEnabled,
                    Delay = buyDelay,
                    Quantity = buyQuantity
                }
            end
        }
    end
    
    --print("✅ Shop module loaded (tanpa section title)")
    return cleanup
end

return ShopAutoBuy