-- ==============================================
-- 📍 TELEPORT TAB MODULE - PURE SIMPLEGUI VERSION
-- ==============================================

local Teleport = {}

function Teleport.Init(Dependencies)
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local Bdev = Dependencies.Bdev
    local GUI = Dependencies.GUI
    
    -- Get services
    local Players = Shared.Services.Players
    
    -- ===== VARIABLES =====
    local selectedPlayer = nil
    local playerDropdownRef = nil
    local infoLabelRef = nil
    local searchBoxRef = nil
    
    -- ===== FUNGSI TELEPORT =====
    local function teleportToPlayer(targetPlayer)
        if not targetPlayer then
            Bdev:Notify({
                Title = "❌ Error",
                Content = "Pilih player terlebih dahulu!",
                Duration = 3
            })
            return false
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then 
            Bdev:Notify({
                Title = "❌ Error",
                Content = "Character not found!",
                Duration = 3
            })
            return false
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then 
            Bdev:Notify({
                Title = "❌ Error",
                Content = "HumanoidRootPart not found!",
                Duration = 3
            })
            return false
        end
        
        if targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                humanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                Bdev:Notify({
                    Title = "✅ Teleport",
                    Content = "Ke " .. targetPlayer.Name,
                    Duration = 2
                })
                return true
            end
        end
        
        Bdev:Notify({
            Title = "❌ Error",
            Content = "Player tidak memiliki karakter!",
            Duration = 3
        })
        return false
    end
    
    -- ===== FUNGSI GET PLAYER LIST =====
    local function getPlayerList(searchText)
        local players = {}
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local displayName = "👤 " .. player.Name
                
                if not searchText or searchText == "" then
                    table.insert(players, displayName)
                elseif player.Name:lower():find(searchText:lower()) then
                    table.insert(players, displayName)
                end
            end
        end
        
        table.sort(players)
        return players
    end
    
    -- ===== FUNGSI GET PLAYER FROM DISPLAY =====
    local function getPlayerFromDisplay(display)
        if not display or display == "-- Tidak ada player --" then return nil end
        local name = display:gsub("👤 ", "")
        return Players:FindFirstChild(name)
    end
    
    -- ===== FUNGSI UPDATE DROPDOWN =====
    local function updateDropdownOptions(searchText)
        local players = getPlayerList(searchText)
        
        if #players == 0 then
            if playerDropdownRef then
                playerDropdownRef.UpdateOptions({"-- Tidak ada player --"})
                playerDropdownRef.SetValue("-- Tidak ada player --")
            end
            if infoLabelRef then
                infoLabelRef:SetText("➤ Target: Tidak ada player online")
            end
            selectedPlayer = nil
        else
            if playerDropdownRef then
                playerDropdownRef.UpdateOptions(players)
                
                if selectedPlayer then
                    local found = false
                    for _, p in pairs(players) do
                        if p == "👤 " .. selectedPlayer.Name then
                            found = true
                            break
                        end
                    end
                    
                    if found then
                        playerDropdownRef.SetValue("👤 " .. selectedPlayer.Name)
                    else
                        selectedPlayer = getPlayerFromDisplay(players[1])
                        playerDropdownRef.SetValue(players[1])
                        if infoLabelRef then
                            infoLabelRef:SetText("➤ Target: 👤 " .. selectedPlayer.Name)
                        end
                    end
                else
                    selectedPlayer = getPlayerFromDisplay(players[1])
                    playerDropdownRef.SetValue(players[1])
                    if infoLabelRef then
                        infoLabelRef:SetText("➤ Target: 👤 " .. selectedPlayer.Name)
                    end
                end
            end
        end
    end
    
    -- ===== MEMBUAT UI DENGAN SIMPLEGUI =====
    
    -- 1. HEADER
    Tab:CreateLabel({
        Name = "Header_Teleport",
        Text = "───── 📍 TELEPORT ─────",
        Color = Color3.fromRGB(255, 185, 0),
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- 2. INFO LABEL (akan diupdate)
    infoLabelRef = Tab:CreateLabel({
        Name = "InfoLabel",
        Text = "➤ Target: Belum dipilih",
        Color = Color3.fromRGB(255, 255, 255),
        Alignment = Enum.TextXAlignment.Left
    })
    
    -- 3. SEARCH BAR (menggunakan CreateSearchBar dari SimpleGUI)
    searchBoxRef = Tab:CreateSearchBar({
        Name = "PlayerSearch",
        Text = "🔍 Cari Player",
        Placeholder = "Ketik nama player...",
        Data = getPlayerList(),
        Callback = function(searchText)
            updateDropdownOptions(searchText)
        end
    })
    
    -- 4. DROPDOWN LABEL
    Tab:CreateLabel({
        Name = "DropdownLabel",
        Text = "📋 Pilih Player:",
        Color = Color3.fromRGB(255, 255, 255),
        Alignment = Enum.TextXAlignment.Left
    })
    
    -- 5. DROPDOWN PLAYER
    local initialPlayers = getPlayerList()
    
    playerDropdownRef = Tab:CreateDropdown({
        Name = "PlayerDropdown",
        Text = "Pilih Player:",
        Options = #initialPlayers > 0 and initialPlayers or {"-- Tidak ada player --"},
        Default = #initialPlayers > 0 and initialPlayers[1] or "-- Tidak ada player --",
        Callback = function(value)
            if value == "-- Tidak ada player --" then
                selectedPlayer = nil
                if infoLabelRef then
                    infoLabelRef:SetText("➤ Target: Belum dipilih")
                end
            else
                selectedPlayer = getPlayerFromDisplay(value)
                if infoLabelRef then
                    infoLabelRef:SetText("➤ Target: " .. value)
                end
                
                Bdev:Notify({
                    Title = "✅ Dipilih",
                    Content = selectedPlayer and selectedPlayer.Name or "Unknown",
                    Duration = 1
                })
            end
        end
    })
    
    -- Set default selected player
    if #initialPlayers > 0 then
        selectedPlayer = getPlayerFromDisplay(initialPlayers[1])
        if playerDropdownRef and playerDropdownRef.SetValue then
            playerDropdownRef.SetValue(initialPlayers[1])
        end
        if infoLabelRef then
            infoLabelRef:SetText("➤ Target: " .. initialPlayers[1])
        end
    end
    
    -- 6. REFRESH BUTTON (menggunakan CreateButton)
    Tab:CreateButton({
        Name = "RefreshButton",
        Text = "🔄 Refresh Player List",
        Callback = function()
            local searchText = ""
            if searchBoxRef and searchBoxRef.GetText then
                searchText = searchBoxRef.GetText()
            end
            updateDropdownOptions(searchText)
            
            Bdev:Notify({
                Title = "🔄 Refresh",
                Content = "Daftar player diperbarui",
                Duration = 2
            })
        end
    })
    
    -- 7. TELEPORT BUTTON (menggunakan CreateButton)
    Tab:CreateButton({
        Name = "TeleportButton",
        Text = "📍 TELEPORT NOW",
        Callback = function()
            teleportToPlayer(selectedPlayer)
        end
    })
    
    -- 8. SPACER / FOOTER
    Tab:CreateLabel({
        Name = "Footer",
        Text = "─────────────────────",
        Color = Color3.fromRGB(140, 140, 150),
        Alignment = Enum.TextXAlignment.Center
    })
    
    -- ===== AUTO REFRESH =====
    Players.PlayerAdded:Connect(function()
        task.wait(1)
        local searchText = searchBoxRef and searchBoxRef.GetText and searchBoxRef.GetText() or ""
        updateDropdownOptions(searchText)
    end)
    
    Players.PlayerRemoving:Connect(function()
        local searchText = searchBoxRef and searchBoxRef.GetText and searchBoxRef.GetText() or ""
        updateDropdownOptions(searchText)
    end)
    
    -- ===== SHARE FUNCTIONS =====
    Shared.Modules = Shared.Modules or {}
    Shared.Modules.Teleport = {
        TeleportToPlayer = teleportToPlayer,
        GetSelectedPlayer = function() 
            return selectedPlayer 
        end,
        RefreshList = function() 
            local searchText = searchBoxRef and searchBoxRef.GetText and searchBoxRef.GetText() or ""
            updateDropdownOptions(searchText) 
        end,
        Search = function(text)
            if searchBoxRef and searchBoxRef.SetText then
                searchBoxRef.SetText(text)
            end
            updateDropdownOptions(text)
        end
    }
    
    print("✅ Teleport module loaded - Pure SimpleGUI Version")
    
    return function() end
end

return Teleport