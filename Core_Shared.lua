-- ==============================================
-- 🔧 CORE SHARED - MURNI PENGHUBUNG
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
            
            -- Method 2: Virtual click
            if method == "click" or not method then
                local vim = Shared.Services.VirtualInputManager
                pcall(function()
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
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
        end
    }
    
    --print("✅ Core Shared (Penghubung) initialized")
end

return Core