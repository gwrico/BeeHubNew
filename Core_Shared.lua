-- ==============================================
-- 🔧 CORE SHARED - MURNI PENGHUBUNG (DENGAN RANDOMISASI)
-- ==============================================

local Core = {}

function Core.Init(Shared)
    
    -- PASTIKAN VARIABLES TERDEFINISI
    Shared.Variables = Shared.Variables or {}
    
    Shared.Functions = {
        
        -- ----- GENERIC UTILITIES (UNTUK SEMUA TAB) -----
        
        formatNumber = function(num)
            if num >= 1000000 then
                return string.format("%.1fM", num / 1000000)
            elseif num >= 1000 then
                return string.format("%.1fK", num / 1000)
            else
                return tostring(math.floor(num))
            end
        end,
        
        createHighlight = function(object, color, transparency)
            if not object then return nil end
            local highlight = Instance.new("Highlight")
            highlight.Name = "BeeHub_Highlight"
            highlight.FillColor = color or Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = transparency or 0.7
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = object
            highlight.Parent = game:GetService("CoreGui")
            return highlight
        end,
        
        -- ----- CONNECTION MANAGEMENT (UNTUK SEMUA TAB) -----
        
        safeDisconnect = function(connection)
            if connection and typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            end
            return nil
        end,
        
        safeDestroy = function(object)
            if object and object.Parent then
                pcall(function() object:Destroy() end)
            end
        end,
        
        -- ----- PLAYER UTILITIES (UNTUK SEMUA TAB) -----
        
        getCharacter = function()
            local player = game.Players.LocalPlayer
            return player and player.Character
        end,
        
        getHumanoidRootPart = function()
            local character = Shared.Functions.getCharacter()
            return character and character:FindFirstChild("HumanoidRootPart")
        end,
        
        isAlive = function()
            local character = Shared.Functions.getCharacter()
            local humanoid = character and character:FindFirstChild("Humanoid")
            return humanoid and humanoid.Health > 0
        end,
        
        -- ----- GENERIC ACTIONS (BISA DIPAKAI SEMUA TAB) -----
        
        teleportToPosition = function(position)
            local hrp = Shared.Functions.getHumanoidRootPart()
            if not hrp then return false end
            hrp.CFrame = CFrame.new(position)
            return true
        end,
        
        -- PERFORM ACTION DENGAN RANDOMISASI (UNTUK BYPASS ADONIS)
        performAction = function(method)
            local character = Shared.Functions.getCharacter()
            if not character then return false end
            
            -- Method 1: Tool activation
            if method == "tool" then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    pcall(function() tool:Activate() end)
                    return true
                end
            end
            
            -- Method 2: Virtual click dengan RANDOMISASI LENGKAP
            if method == "click" or not method then
                local vim = Shared.Services.VirtualInputManager
                
                -- RANDOMISASI: Posisi mouse acak
                local x = math.random(100, 900)
                local y = math.random(100, 600)
                
                -- RANDOMISASI: Hold time bervariasi
                local holdTime = 0.03 + (math.random() * 0.1)
                
                -- RANDOMISASI: Delay sebelum click
                task.wait(math.random() * 0.1)
                
                pcall(function()
                    vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
                    task.wait(holdTime)
                    vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
                end)
                
                -- RANDOMISASI: Delay setelah click
                task.wait(math.random() * 0.1)
                
                return true
            end
            
            return false
        end,
        
        -- ----- TOOL MANAGEMENT (GENERIC) -----
        
        getEquippedTool = function()
            local character = Shared.Functions.getCharacter()
            return character and character:FindFirstChildOfClass("Tool")
        end,
        
        autoEquipTool = function()
            local player = game.Players.LocalPlayer
            local character = Shared.Functions.getCharacter()
            if not character then return false end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return false end
            
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    humanoid:EquipTool(tool)
                    return true
                end
            end
            return false
        end,
        
        -- ----- ANTI-DETECTION UTILITY -----
        getRandomDelay = function(baseMin, baseMax)
            -- Fungsi untuk menghasilkan delay acak yang tidak terduga
            local variation = math.random(-30, 30) / 100
            return (baseMin + math.random() * (baseMax - baseMin)) + variation
        end,
        
        humanizedWait = function(minSec, maxSec)
            -- Delay dengan pola seperti manusia
            minSec = minSec or 0.5
            maxSec = maxSec or 1.5
            local waitTime = Shared.Functions.getRandomDelay(minSec, maxSec)
            task.wait(math.max(0.1, waitTime))
        end
    }
    
    print("✅ Core Shared initialized (with Adonis bypass)")
end

return Core