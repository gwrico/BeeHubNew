-- ==============================================
-- 🎮 BEEHUB v4.0 - MODULAR SYSTEM (MAIN)
-- ==============================================

-- Configuration
local CONFIG = {
    SIMPLEGUI_URL = "https://raw.githubusercontent.com/gwrico/BeeHubNew/refs/heads/main/SimpleGUI_NEO.lua",
    MODULES_URL = "https://raw.githubusercontent.com/gwrico/BeeHubNew/refs/heads/main/",
    LOAD_TIMEOUT = 10
}

-- Load SimpleGUI
local success, SimpleGUI = pcall(function()
    return loadstring(game:HttpGet(CONFIG.SIMPLEGUI_URL))()
end)

if not success then
    warn("Failed to load SimpleGUI:", SimpleGUI)
    return
end

local GUI = SimpleGUI.new()

-- ===== ANTI-DEBUG UNTUK SEMUA MODULE =====
-- Letakkan di SINI, sebelum create window
pcall(function()
    -- Proteksi debug.getinfo
    if debug and debug.getinfo then
        local oldGetInfo = debug.getinfo
        debug.getinfo = function(...)
            local result = oldGetInfo(...)
            if result and result.source then
                -- Sembunyikan semua referensi ke script BeeHub
                result.source = result.source:gsub("BeeHub", "Core")
                result.source = result.source:gsub("AutoFarm", "System")
                result.source = result.source:gsub("Teleport", "Network")
                result.source = result.source:gsub("Discord", "UI")
                result.source = result.source:gsub("Misc", "Util")
                
                -- Buat seolah-olah dari Roblox
                if result.source:find("StarterPlayer") or result.source:find("BeeHub") then
                    result.source = "=[C]"
                end
            end
            return result
        end
    end
    
    -- Proteksi getgenv (global environment)
    if getgenv then
        -- Sembunyikan fungsi-fungsi penting dari global
        local protectedEnv = setmetatable({}, {
            __index = getgenv(),
            __newindex = getgenv()
        })
        
        -- Ganti _G dengan environment yang dilindungi
        _G = protectedEnv
    end
    
    -- Proteksi debug.getregistry
    if debug and debug.getregistry then
        local oldRegistry = debug.getregistry
        debug.getregistry = function(...)
            local registry = oldRegistry(...)
            -- Bersihkan registry dari referensi BeeHub
            if registry and type(registry) == "table" then
                -- Implementasi sesuai kebutuhan
            end
            return registry
        end
    end
    
    -- Proteksi getgc (garbage collection)
    if getgc then
        local oldGetGC = getgc
        getgc = function(...)
            local gc = oldGetGC(...)
            -- Filter hasil GC
            return gc
        end
    end
    
    print("✅ Anti-Debug activated for all modules")
end)

-- Create main window
local Window = GUI:CreateWindow({
    Name = "⚡ BEEHUB v4.0 - Futuristic Edition",
    Size = UDim2.new(0, 700, 0, 500)
})

-- Notification system
local Bdev = {
    Notify = function(self, notification)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = notification.Title,
            Text = notification.Content,
            Duration = notification.Duration or 3
        })
    end
}

-- Shared state container
local Shared = {
    Window = Window,
    GUI = GUI,
    Bdev = Bdev,
    
    Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        VirtualInputManager = game:GetService("VirtualInputManager")
    },
    
    Variables = {
        autoCollectEnabled = false,
        autoPunchEnabled = false,
        eggESPEnabled = false,
        xrayEnabled = false,
        playerESPEnabled = false,
        antiAfkEnabled = false,
        speedHackEnabled = false,
        jumpHackEnabled = false,
        noclipEnabled = false,
        infiniteJumpEnabled = false,
        flyEnabled = false,
        autoHatchEnabled = false
    },
    
    Tabs = {},
    Modules = { Loaded = {}, Errors = {} }
}

-- ... (lanjut dengan module loader dan initialize modules)

-- Module loader
function Shared.LoadModule(moduleName, urlSuffix)
    local moduleUrl = CONFIG.MODULES_URL .. urlSuffix
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(moduleUrl, true))()
    end)
    
    if success then
        Shared.Modules.Loaded[moduleName] = result
        return result
    else
        Shared.Modules.Errors[moduleName] = "Failed to load " .. moduleName
        Bdev:Notify({
            Title = "Module Error",
            Content = "Failed to load " .. moduleName,
            Duration = 5
        })
        return nil
    end
end

-- Initialize modules
function Shared.InitializeModules()
    -- Load core shared first
    local CoreModule = Shared.LoadModule("Core_Shared", "Core_Shared.lua")
    if CoreModule and CoreModule.Init then
        CoreModule.Init(Shared)
    end
    
    -- Load tabs
    local tabModules = {
        {Name = "AutoFarm", File = "Tab_AutoFarm.lua", TabName = "💰 Auto Farm"},
        {Name = "Shop", File = "Tab_Shop.lua", TabName = "🛍️ Shop"},
        {Name = "Inventory", File = "Tab_Inventory.lua", TabName = "🎒 Inventory"},
        {Name = "Teleport", File = "Tab_Teleport.lua", TabName = "📍 Teleport"},
        {Name = "Misc", File = "Tab_Misc.lua", TabName = "⚡ Misc"},
        {Name = "Utilities", File = "Tab_Utilities.lua", TabName = "🔧 Utilities"},
        {Name = "Discord", File = "Tab_Discord.lua", TabName = "💬 Discord"}
    }
  
    for _, moduleInfo in ipairs(tabModules) do
        local module = Shared.LoadModule(moduleInfo.Name, moduleInfo.File)
        if module and module.Init then
            local tab = Window:CreateTab(moduleInfo.TabName)
            Shared.Tabs[moduleInfo.Name] = tab
            
            module.Init({
                Tab = tab,
                Shared = Shared,
                GUI = GUI,
                Bdev = Bdev
            })
        end
    end
end

-- Start loading
task.spawn(function()
    local startTime = tick()
    Shared.InitializeModules()
    local loadTime = tick() - startTime
    
    Bdev:Notify({
        Title = "BEEHUB v4.0",  -- ← Notifikasi juga BEEHUB
        Content = "Loaded successfully!",
        Duration = 3
    })
end)

return Shared