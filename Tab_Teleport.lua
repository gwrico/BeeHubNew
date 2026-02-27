-- ==============================================
-- 📍 TAB_TELEPORT.LUA - Teleport to Players (Fixed)
-- ==============================================

local TeleportTab = {}

function TeleportTab.Init(Dependencies)
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local Bdev = Dependencies.Bdev
    local GUI = Dependencies.GUI
    
    -- Services
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    
    local LocalPlayer = Players.LocalPlayer
    local playerList = {}
    local selectedPlayer = nil
    local refreshConnection = nil
    local lastRefreshTime = 0 -- Pindahkan ke variable terpisah
    
    -- ===== HELPER FUNCTIONS =====
    
    -- Get player character safely
    local function getCharacter(player)
        local character = player.Character
        if not character then
            character = player.CharacterAdded:Wait(5)
        end
        return character
    end
    
    -- Get HumanoidRootPart of a player
    local function getPlayerHRP(player)
        local character = getCharacter(player)
        return character and character:FindFirstChild("HumanoidRootPart")
    end
    
    -- Check if local player is alive
    local function isAlive()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        return humanoid and humanoid.Health > 0
    end
    
    -- Check if target player is valid for teleport
    local function isValidTarget(player)
        if not player or player == LocalPlayer then return false end
        
        local hrp = getPlayerHRP(player)
        if not hrp then return false end
        
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        return humanoid and humanoid.Health > 0
    end
    
    -- ===== CORE TELEPORT FUNCTION =====
    
    local function teleportToPlayer(targetPlayer)
        -- Validasi local player
        if not isAlive() then
            Bdev:Notify({
                Title = "Error",
                Content = "❌ You are dead!",
                Duration = 2
            })
            return false
        end
        
        -- Validasi target player
        if not isValidTarget(targetPlayer) then
            Bdev:Notify({
                Title = "Error",
                Content = "❌ Target player is invalid or dead!",
                Duration = 2
            })
            return false
        end
        
        -- Dapatkan posisi target
        local targetHRP = getPlayerHRP(targetPlayer)
        if not targetHRP then return false end
        
        -- Dapatkan HRP local player
        local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP then return false end
        
        -- Teleport
        local success = pcall(function()
            localHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0) -- Offset sedikit agar tidak overlap
        end)
        
        if success then
            Bdev:Notify({
                Title = "Teleported",
                Content = string.format("✅ Teleported to %s", targetPlayer.Name),
                Duration = 2
            })
            return true
        else
            Bdev:Notify({
                Title = "Error",
                Content = "❌ Teleport failed!",
                Duration = 2
            })
            return false
        end
    end
    
    -- ===== REFRESH PLAYER LIST =====
    
    local function refreshPlayerList()
        local newList = {}
        playerList = {}
        
        -- Get all players except local player
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local displayName = string.format("%s (@%s)", player.DisplayName, player.Name)
                
                -- Cek status player
                local status = "🟢 Online"
                if not isValidTarget(player) then
                    status = "🔴 Dead/Invalid"
                end
                
                table.insert(newList, string.format("%s - %s", displayName, status))
                
                -- Simpan data player
                playerList[displayName] = {
                    player = player,
                    displayName = displayName,
                    isAlive = isValidTarget(player)
                }
            end
        end
        
        -- Update dropdown jika ada
        if playerDropdown and playerDropdown.UpdateOptions then
            playerDropdown:UpdateOptions(newList)
        end
        
        return newList
    end
    
    -- Auto refresh setiap 3 detik - VERSI DIPERBAIKI
    refreshConnection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastRefreshTime > 3 then
            refreshPlayerList()
            lastRefreshTime = currentTime -- Update variable, bukan property connection
        end
    end)
    
    -- ===== UI ELEMENTS =====
    
    -- Header
    Tab:CreateLabel({
        Text = "📍 TELEPORT TO PLAYER",
        Size = 16,
        Color = Color3.fromRGB(255, 40, 40)
    })
    
    -- Info label
    Tab:CreateLabel({
        Text = "Select a player from the dropdown below",
        Size = 12,
        Color = Color3.fromRGB(200, 200, 200)
    })
    
    -- Player Dropdown
    local playerDropdown = Tab:CreateDropdown({
        Name = "PlayerList",
        Text = "👥 Online Players",
        Options = refreshPlayerList(), -- Initial list
        Default = "Select a player...",
        Callback = function(selected)
            -- Find selected player data
            for displayName, data in pairs(playerList) do
                if displayName == selected then
                    selectedPlayer = data.player
                    
                    -- Update info
                    if data.isAlive then
                        Bdev:Notify({
                            Title = "Player Selected",
                            Content = string.format("Selected: %s", displayName),
                            Duration = 1.5
                        })
                    else
                        Bdev:Notify({
                            Title = "Warning",
                            Content = "Selected player is dead or invalid!",
                            Duration = 2
                        })
                    end
                    break
                end
            end
        end
    })
    
    -- Manual refresh button
    Tab:CreateButton({
        Name = "RefreshList",
        Text = "🔄 Refresh Player List",
        Callback = function()
            local newList = refreshPlayerList()
            Bdev:Notify({
                Title = "Refreshed",
                Content = string.format("Found %d online players", #newList),
                Duration = 2
            })
        end
    })
    
    -- Teleport button
    Tab:CreateButton({
        Name = "TeleportToPlayer",
        Text = "🚀 Teleport to Selected Player",
        Callback = function()
            if not selectedPlayer then
                Bdev:Notify({
                    Title = "Error",
                    Content = "❌ No player selected!",
                    Duration = 2
                })
                return
            end
            
            teleportToPlayer(selectedPlayer)
        end
    })
    
    -- ===== STATUS DISPLAY =====
    
    -- Live player count
    local playerCountLabel = Tab:CreateLabel({
        Text = "👥 Online: 0 | Alive: 0",
        Size = 12,
        Color = Color3.fromRGB(150, 150, 150)
    })
    
    -- Update player count periodically
    spawn(function()
        while true do
            local total = #Players:GetPlayers() - 1 -- Exclude self
            local alive = 0
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and isValidTarget(player) then
                    alive = alive + 1
                end
            end
            
            playerCountLabel.Text = string.format("👥 Online: %d | Alive: %d", total, alive)
            task.wait(2)
        end
    end)
    
    -- ===== CLEANUP =====
    
    -- Cleanup when tab is destroyed
    if Tab.Destroy then
        local oldDestroy = Tab.Destroy
        Tab.Destroy = function()
            if refreshConnection then
                refreshConnection:Disconnect()
                refreshConnection = nil
            end
            oldDestroy(Tab)
        end
    end
    
    print("✅ Teleport to Player Module Loaded")
end

return TeleportTab