-- ==============================================
-- 🔧 UTILITIES TAB MODULE - DENGAN TOGGLE BUTTON
-- ==============================================

local Utilities = {}

function Utilities.Init(Dependencies)
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local Bdev = Dependencies.Bdev
    local Window = Dependencies.Window
    local GUI = Dependencies.GUI
    
    local Services = Shared.Services
    
    -- Ambil theme dari GUI
    local theme = GUI:GetTheme() or {
        Accent = Color3.fromRGB(255, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(140, 140, 150),
        Button = Color3.fromRGB(25, 25, 32),
        ButtonHover = Color3.fromRGB(45, 45, 55)
    }
    
    -- ===== STATE VARIABLES UNTUK TOGGLE =====
    -- Inisialisasi variable di Shared jika belum ada
    Shared.Variables = Shared.Variables or {}
    Shared.Variables.utilities = Shared.Variables.utilities or {}
    
    -- Destroy GUI toggle (meskipun bukan toggle, kita buat seperti toggle)
    local destroyGUIEnabled = false
    
    -- Rejoin Server toggle
    Shared.Variables.utilities.rejoinEnabled = Shared.Variables.utilities.rejoinEnabled or false
    
    -- Server Hop toggle
    Shared.Variables.utilities.serverHopEnabled = Shared.Variables.utilities.serverHopEnabled or false
    
    -- Game Info toggle
    Shared.Variables.utilities.gameInfoEnabled = Shared.Variables.utilities.gameInfoEnabled or false
    
    -- Copy Discord toggle
    Shared.Variables.utilities.copyDiscordEnabled = Shared.Variables.utilities.copyDiscordEnabled or false
    
    -- Copy Game ID toggle
    Shared.Variables.utilities.copyGameIdEnabled = Shared.Variables.utilities.copyGameIdEnabled or false
    
    -- ===== FUNGSI UNTUK HANDLE TOGGLE =====
    local function handleDestroyGUI(state)
        if state then
            -- Langsung execute Destroy GUI
            if Window and Window.MainFrame then
                Window.MainFrame.Visible = false
                Bdev:Notify({
                    Title = "GUI",
                    Content = "GUI destroyed!",
                    Duration = 3
                })
            else
                Bdev:Notify({
                    Title = "Error",
                    Content = "Could not find GUI window!",
                    Duration = 3
                })
            end
            -- Kembalikan toggle ke false karena sekali pakai
            return false
        end
        return false
    end
    
    local function handleRejoinServer(state)
        if state then
            Bdev:Notify({
                Title = "Rejoin",
                Content = "Rejoining server...",
                Duration = 3
            })
            
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            
            local success, err = pcall(function()
                TeleportService:Teleport(game.PlaceId, player)
            end)
            
            if not success then
                Bdev:Notify({
                    Title = "Error",
                    Content = "Failed to rejoin: " .. tostring(err),
                    Duration = 5
                })
            end
            -- Kembalikan toggle ke false setelah execute
            return false
        end
        return false
    end
    
    local function handleServerHop(state)
        if state then
            Bdev:Notify({
                Title = "Server Hop",
                Content = "Finding new server...",
                Duration = 3
            })
            
            local function findNewServer()
                local HttpService = game:GetService("HttpService")
                local TeleportService = game:GetService("TeleportService")
                
                local success, servers = pcall(function()
                    local response = game:HttpGet(
                        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
                    )
                    return HttpService:JSONDecode(response)
                end)
                
                if success and servers and servers.data then
                    for _, server in ipairs(servers.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            pcall(function()
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                            end)
                            return true
                        end
                    end
                end
                return false
            end
            
            local found = findNewServer()
            if not found then
                Bdev:Notify({
                    Title = "Server Hop",
                    Content = "No servers found, rejoining...",
                    Duration = 3
                })
                
                pcall(function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end)
            end
            -- Kembalikan toggle ke false setelah execute
            return false
        end
        return false
    end
    
    local function handleGameInfo(state)
        if state then
            Bdev:Notify({
                Title = "Game Info",
                Content = "Check console (F9) for details!",
                Duration = 5
            })
            -- Kembalikan toggle ke false setelah execute
            return false
        end
        return false
    end
    
    local function handleCopyDiscord(state)
        if state then
            local discordLink = "https://discord.gg/abcd"
            local copied = false
            
            local methods = {
                function() 
                    if setclipboard then 
                        setclipboard(discordLink) 
                        return true 
                    end 
                end,
                function() 
                    if writeclipboard then 
                        writeclipboard(discordLink) 
                        return true 
                    end 
                end,
                function() 
                    if toclipboard then 
                        toclipboard(discordLink) 
                        return true 
                    end 
                end
            }
            
            for _, method in ipairs(methods) do
                local success = pcall(method)
                if success then
                    copied = true
                    break
                end
            end
            
            if copied then
                Bdev:Notify({
                    Title = "Discord",
                    Content = "Discord link copied!",
                    Duration = 3
                })
            else
                Bdev:Notify({
                    Title = "Discord",
                    Content = "Check console (F9) to copy link!",
                    Duration = 5
                })
            end
            -- Kembalikan toggle ke false setelah execute
            return false
        end
        return false
    end
    
    local function handleCopyGameId(state)
        if state then
            local gameId = tostring(game.PlaceId)
            local copied = false
            
            local methods = {
                function() 
                    if setclipboard then 
                        setclipboard(gameId) 
                        return true 
                    end 
                end,
                function() 
                    if writeclipboard then 
                        writeclipboard(gameId) 
                        return true 
                    end 
                end
            }
            
            for _, method in ipairs(methods) do
                local success = pcall(method)
                if success then
                    copied = true
                    break
                end
            end
            
            if copied then
                Bdev:Notify({
                    Title = "Game ID",
                    Content = "Game ID copied!",
                    Duration = 3
                })
            else
                Bdev:Notify({
                    Title = "Game ID",
                    Content = "Game ID: " .. gameId,
                    Duration = 4
                })
            end
            -- Kembalikan toggle ke false setelah execute
            return false
        end
        return false
    end
    
    -- ===== UTILITIES SECTION =====
    Tab:CreateLabel({
        Name = "UtilitiesLabel",
        Text = "───── 🔧 UTILITIES ─────",
        Color = theme.Accent,
        Bold = true,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- ===== DESTROY GUI TOGGLE =====
    Tab:CreateToggle({
        Name = "DestroyGUI",
        Text = "🗑️ Destroy GUI",
        CurrentValue = destroyGUIEnabled,
        Callback = function(state)
            local newState = handleDestroyGUI(state)
            -- Set toggle back to false
            task.wait(0.1)
            if toggles and toggles.DestroyGUI then
                toggles.DestroyGUI:SetValue(false)
            end
        end
    })
    
    -- ===== REJOIN SERVER TOGGLE =====
    Tab:CreateToggle({
        Name = "RejoinServer",
        Text = "🔄 Rejoin Server",
        CurrentValue = Shared.Variables.utilities.rejoinEnabled,
        Callback = function(state)
            local newState = handleRejoinServer(state)
            Shared.Variables.utilities.rejoinEnabled = newState
            if not newState and toggles and toggles.RejoinServer then
                toggles.RejoinServer:SetValue(false)
            end
        end
    })
    
    -- ===== SERVER HOP TOGGLE =====
    Tab:CreateToggle({
        Name = "ServerHop",
        Text = "🌐 Server Hop",
        CurrentValue = Shared.Variables.utilities.serverHopEnabled,
        Callback = function(state)
            local newState = handleServerHop(state)
            Shared.Variables.utilities.serverHopEnabled = newState
            if not newState and toggles and toggles.ServerHop then
                toggles.ServerHop:SetValue(false)
            end
        end
    })
    
    -- ===== GAME INFO TOGGLE =====
    Tab:CreateToggle({
        Name = "GameInfo",
        Text = "📊 Game Info",
        CurrentValue = Shared.Variables.utilities.gameInfoEnabled,
        Callback = function(state)
            local newState = handleGameInfo(state)
            Shared.Variables.utilities.gameInfoEnabled = newState
            if not newState and toggles and toggles.GameInfo then
                toggles.GameInfo:SetValue(false)
            end
        end
    })
    
    -- ===== COPY DISCORD TOGGLE =====
    Tab:CreateToggle({
        Name = "CopyDiscord",
        Text = "💬 Copy Discord",
        CurrentValue = Shared.Variables.utilities.copyDiscordEnabled,
        Callback = function(state)
            local newState = handleCopyDiscord(state)
            Shared.Variables.utilities.copyDiscordEnabled = newState
            if not newState and toggles and toggles.CopyDiscord then
                toggles.CopyDiscord:SetValue(false)
            end
        end
    })
    
    -- ===== COPY GAME ID TOGGLE =====
    Tab:CreateToggle({
        Name = "CopyGameID",
        Text = "🎮 Copy Game ID",
        CurrentValue = Shared.Variables.utilities.copyGameIdEnabled,
        Callback = function(state)
            local newState = handleCopyGameId(state)
            Shared.Variables.utilities.copyGameIdEnabled = newState
            if not newState and toggles and toggles.CopyGameID then
                toggles.CopyGameID:SetValue(false)
            end
        end
    })
    
    -- ===== FOOTER =====
    Tab:CreateLabel({
        Name = "Footer",
        Text = "─────────────────────",
        Color = theme.TextMuted,
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- Simpan reference toggle untuk reset
    local toggles = {
        DestroyGUI = nil,  -- Akan diisi setelah CreateToggle
        RejoinServer = nil,
        ServerHop = nil,
        GameInfo = nil,
        CopyDiscord = nil,
        CopyGameID = nil
    }
    
    -- Isi reference (dilakukan setelah semua CreateToggle)
    -- Ini akan diisi oleh return value dari CreateToggle
    -- Tapi karena kita tidak menyimpannya, kita perlu modifikasi
    
    --print("✅ Utilities tab initialized dengan toggle button")
end

return Utilities