-- ==============================================
-- 💰 AUTO FARM TAB MODULE - DENGAN AUTO RECORD POSISI + AUTO HARVEST + AUTO WALK
-- ==============================================

local AutoFarm = {}

function AutoFarm.Init(Dependencies)
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local Bdev = Dependencies.Bdev
    local GUI = Dependencies.GUI
    
    local Variables = Shared.Variables or {}
    
    -- Get services
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    -- Auto-plant variables
    local plantConnection = nil
    
    -- Default position (dari script Anda)
    local defaultPos = Vector3.new(37.042457580566406, 39.296875, -265.78594970703125)
    
    -- Custom position (akan diupdate dari posisi player)
    local customX = defaultPos.X
    local customY = defaultPos.Y
    local customZ = defaultPos.Z
    
    -- Auto harvest variables
    local isActive = false
    local HOLD_DURATION = 1.0      -- Hold 1 detik
    local DELAY_BETWEEN = 0.5      -- Delay 0.5 detik antar harvest
    
    -- ===== AUTO WALK VARIABLES =====
    local autoWalkEnabled = false
    local autoWalkConnection = nil
    local STOP_DISTANCE = 3         -- Berhenti jika sudah dalam 3 stud
    local WALK_TRIGGER_DISTANCE = 10 -- Mulai berjalan jika jarak > 10 stud
    
    -- Label untuk menampilkan posisi
    local positionLabel = nil
    
    -- Dapatkan remote PlantCrop
    local function getPlantRemote()
        local success, remote = pcall(function()
            return ReplicatedStorage.Remotes.TutorialRemotes.PlantCrop
        end)
        
        if success and remote then
            return remote
        end
        
        -- Coba cari dengan aman
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local tutorial = remotes:FindFirstChild("TutorialRemotes")
            if tutorial then
                return tutorial:FindFirstChild("PlantCrop")
            end
        end
        
        return nil
    end
    
    -- Fungsi untuk mendapatkan posisi player
    local function getPlayerPosition()
        local player = Players.LocalPlayer
        local character = player.Character
        if not character then return nil end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return nil end
        
        return humanoidRootPart.Position
    end
    
    -- Fungsi untuk update posisi dan tampilkan
    local function updatePositionDisplay(newPos)
        if not newPos then return end
        
        customX = newPos.X
        customY = newPos.Y
        customZ = newPos.Z
        
        -- Update label jika ada
        if positionLabel then
            positionLabel.Text = string.format("📍 X: %.1f | Y: %.1f | Z: %.1f", customX, customY, customZ)
        end
        
        -- Tampilkan notifikasi
        Bdev:Notify({
            Title = "Position Recorded",
            Content = string.format("📍 X: %.1f, Y: %.1f, Z: %.1f", customX, customY, customZ),
            Duration = 3
        })
    end
    
    -- ===== AUTO WALK FUNCTIONS =====
    
    -- Fungsi untuk membuat karakter berjalan ke target
    local function walkToTarget(targetPos)
        local player = Players.LocalPlayer
        local character = player.Character
        if not character then return false end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not hrp then return false end
        
        -- Hitung jarak ke target
        local currentPos = hrp.Position
        local distance = (targetPos - currentPos).Magnitude
        
        -- Jika sudah dekat, berhenti
        if distance <= STOP_DISTANCE then
            humanoid:MoveTo(currentPos)  -- Stop moving
            return true
        end
        
        -- Gerakkan karakter ke target
        humanoid:MoveTo(targetPos)
        
        -- Force jump jika ada halangan atau sedang jatuh
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall or 
           humanoid:GetState() == Enum.HumanoidStateType.StrafingNoPhysics then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        return false
    end
    
    -- Loop untuk auto walk
    local function startAutoWalk()
        if autoWalkConnection then
            autoWalkConnection:Disconnect()
        end
        
        autoWalkConnection = RunService.Heartbeat:Connect(function()
            if not autoWalkEnabled then return end
            
            local player = Players.LocalPlayer
            local character = player.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            -- Posisi target tanam
            local targetPos = Vector3.new(customX, customY, customZ)
            local currentPos = hrp.Position
            local distance = (targetPos - currentPos).Magnitude
            
            -- Jika terlalu jauh, berjalan kembali
            if distance > WALK_TRIGGER_DISTANCE then
                walkToTarget(targetPos)
            end
        end)
    end
    
    -- ===== CEK KETERSEDIAAN REMOTE =====
    local plantRemote = getPlantRemote()
    if plantRemote then
        Bdev:Notify({
            Title = "PlantCrop Ready",
            Content = "✅ Join Discord ABCD",
            Duration = 3
        })
    else
        Bdev:Notify({
            Title = "Warning",
            Content = "⚠️ Kamu Belum Join Discord",
            Duration = 4
        })
    end
    
    -- ===== AUTO PLANT CROPS =====
    Tab:CreateToggle({
        Name = "AutoPlant",
        Text = "🌱 Auto Plant",
        CurrentValue = false,
        Callback = function(value)
            Variables.autoPlantEnabled = value
            
            if value then
                local plantRemote = getPlantRemote()
                if not plantRemote then
                    Bdev:Notify({
                        Title = "Error",
                        Content = "❌ PlantCrop remote tidak ditemukan!",
                        Duration = 4
                    })
                    Variables.autoPlantEnabled = false
                    return
                end
                
                Bdev:Notify({
                    Title = "Auto Plant",
                    Content = "🌱 Auto planting ENABLED",
                    Duration = 2
                })
                
                if plantConnection then
                    plantConnection:Disconnect()
                end
                
                plantConnection = RunService.Heartbeat:Connect(function()
                    if not Variables.autoPlantEnabled then return end
                    
                    local remote = getPlantRemote()
                    if remote then
                        -- Gunakan custom position yang sudah direkam
                        local plantPos = Vector3.new(customX, customY, customZ)
                        
                        pcall(function()
                            remote:FireServer(plantPos)
                        end)
                        
                        task.wait(1.0) -- Default delay 1 detik
                    end
                end)
                
            else
                Bdev:Notify({
                    Title = "Auto Plant",
                    Content = "🌱 Auto planting DISABLED",
                    Duration = 2
                })
                
                if plantConnection then
                    plantConnection:Disconnect()
                    plantConnection = nil
                end
            end
        end
    })
    
    -- ===== RECORD POSISI =====
    Tab:CreateButton({
        Name = "RecordOnly",
        Text = "📍 Ambil Lokasi Tanam (Klik ini)",
        Callback = function()
            local playerPos = getPlayerPosition()
            if not playerPos then
                Bdev:Notify({
                    Title = "Error",
                    Content = "❌ Tidak bisa dapatkan posisi!",
                    Duration = 2
                })
                return
            end
            
            updatePositionDisplay(playerPos)
        end
    })
    
    -- ===== TAMPILAN POSISI SAAT INI =====
    Tab:CreateLabel({
        Text = "📍 POSISI TANAM TERSIMPAN",
        Size = 12,
        Color = Color3.fromRGB(255, 40, 40)
    })
    
    positionLabel = Tab:CreateLabel({
        Text = string.format("📍 X: %.1f | Y: %.1f | Z: %.1f", customX, customY, customZ),
        Size = 14,
        Color = Color3.fromRGB(255, 255, 255)
    })
    
    -- ===== AUTO WALK TOGGLE =====
    Tab:CreateToggle({
        Name = "AutoWalk",
        Text = "🚶 Auto Walk ke Posisi Tanam",
        CurrentValue = false,
        Callback = function(value)
            autoWalkEnabled = value
            
            if value then
                Bdev:Notify({
                    Title = "Auto Walk",
                    Content = "🚶 Akan berjalan kembali ke posisi tanam jika menjauh",
                    Duration = 3
                })
                startAutoWalk()
            else
                Bdev:Notify({
                    Title = "Auto Walk",
                    Content = "❌ Auto Walk disabled",
                    Duration = 2
                })
                if autoWalkConnection then
                    autoWalkConnection:Disconnect()
                    autoWalkConnection = nil
                end
            end
        end
    })
    
    -- ===== WALK TRIGGER DISTANCE SLIDER =====
    Tab:CreateSlider({
        Name = "WalkTriggerDistance",
        Text = "🚶 Jarak Trigger Auto Walk (stud)",
        Range = {5, 30},
        CurrentValue = 10,
        Callback = function(val)
            WALK_TRIGGER_DISTANCE = val
        end
    })
    
    -- ===== WALK NOW BUTTON =====
    Tab:CreateButton({
        Name = "WalkNow",
        Text = "🚶 Walk ke Posisi Sekarang",
        Callback = function()
            local player = Players.LocalPlayer
            local character = player.Character
            if not character then 
                Bdev:Notify({
                    Title = "Error",
                    Content = "❌ Karakter tidak ditemukan!",
                    Duration = 2
                })
                return
            end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            local targetPos = Vector3.new(customX, customY, customZ)
            humanoid:MoveTo(targetPos)
            
            Bdev:Notify({
                Title = "Walking",
                Content = "🚶 Berjalan ke posisi tanam...",
                Duration = 2
            })
        end
    })
    
    -- ===== AUTO HARVEST =====
    local function pressAndHoldE()
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(HOLD_DURATION)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end)
    end
    
    local function harvest()
        local activeCrops = workspace:FindFirstChild("ActiveCrops")
        if not activeCrops then return end
        
        local player = Players.LocalPlayer
        local character = player.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, crop in ipairs(activeCrops:GetChildren()) do
            local root = crop:FindFirstChild("Root")
            if root and root:IsA("BasePart") then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist <= 10 then
                    pressAndHoldE()
                    break
                end
            end
        end
    end
    
    -- Tombol AUTO HARVEST
    Tab:CreateToggle({
        Name = "AutoHarvest",
        Text = "🤖 AUTO HARVEST",
        CurrentValue = false,
        Callback = function(val)
            isActive = val
            
            if val then
                spawn(function()
                    while isActive do
                        harvest()
                        
                        -- Delay 0.5 detik antar harvest
                        local waitTime = DELAY_BETWEEN
                        while waitTime > 0 and isActive do
                            task.wait(0.1)
                            waitTime = waitTime - 0.1
                        end
                    end
                end)
            end
        end
    })
    
    -- Tombol STOP HARVEST
    Tab:CreateButton({
        Name = "StopHarvest",
        Text = "⏹️ STOP HARVEST",
        Callback = function()
            isActive = false
            Bdev:Notify({
                Title = "Harvest",
                Content = "⏹️ Auto harvest stopped",
                Duration = 2
            })
        end
    })
    
    --print("✅ AutoFarm Posisi dan Harverst Ready - BeeHub")
end

return AutoFarm