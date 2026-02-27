-- ==============================================
-- 🎨 SIMPLEGUI v8.0 - Bee FUTURISTIC EDITION
-- ==============================================
--print("🔧 Loading SimpleGUI v8.0 - Bee Futuristic Edition...")

local SimpleGUI = {}
SimpleGUI.__index = SimpleGUI

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🔥 Bee FUTURISTIC COLOR SCHEME - Red & Black
SimpleGUI.Themes = {
    Bee = {
        Name = "Bee Futuristic",
        
        -- Warna dasar Bee (Hitam & Merah)
        Primary = Color3.fromRGB(10, 10, 10),        -- Hitam pekat
        Secondary = Color3.fromRGB(20, 20, 20),       -- Hitam lebih terang
        Accent = Color3.fromRGB(255, 40, 40),         -- Merah terang
        AccentDark = Color3.fromRGB(180, 20, 20),      -- Merah gelap
        AccentGlow = Color3.fromRGB(255, 60, 60),      -- Merah untuk efek glow
        
        Text = Color3.fromRGB(255, 255, 255),         -- Putih murni
        TextSecondary = Color3.fromRGB(200, 200, 210), -- Abu-abu terang
        TextMuted = Color3.fromRGB(140, 140, 150),     -- Abu-abu gelap
        TextGlow = Color3.fromRGB(255, 80, 80),        -- Merah untuk teks glow
        
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 40, 40),           -- Merah untuk error
        
        -- Border & Effects
        Border = Color3.fromRGB(40, 40, 45),
        BorderLight = Color3.fromRGB(70, 70, 80),
        BorderRed = Color3.fromRGB(255, 40, 40),       -- Border merah penuh
        
        Hover = Color3.fromRGB(255, 40, 40, 0.2),       -- Merah transparan untuk hover
        Active = Color3.fromRGB(255, 40, 40),           -- Merah untuk active
        
        -- UI Specific
        WindowBg = Color3.fromRGB(5, 5, 8),            -- Hitam pekat dengan sedikit biru
        TitleBar = Color3.fromRGB(12, 12, 15),
        TitleBarGlow = Color3.fromRGB(255, 40, 40, 0.2),
        
        TabNormal = Color3.fromRGB(18, 18, 22),
        TabActive = Color3.fromRGB(255, 40, 40),        -- Merah untuk tab aktif
        TabHover = Color3.fromRGB(35, 35, 45),
        
        ContentBg = Color3.fromRGB(8, 8, 12),
        ContentBgLight = Color3.fromRGB(15, 15, 20),    -- Untuk background card
        ContentCard = Color3.fromRGB(20, 20, 25),       -- Background card yang lebih terang
        
        Button = Color3.fromRGB(25, 25, 32),
        ButtonHover = Color3.fromRGB(45, 45, 55),
        ButtonGlow = Color3.fromRGB(255, 40, 40, 0.15),
        
        InputBg = Color3.fromRGB(18, 18, 25),
        InputBgFocus = Color3.fromRGB(28, 28, 38),
        InputBorder = Color3.fromRGB(255, 40, 40, 0.3),
        
        ToggleOff = Color3.fromRGB(50, 50, 60),
        ToggleOn = Color3.fromRGB(255, 40, 40),         -- Merah untuk toggle on
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        
        SliderTrack = Color3.fromRGB(30, 30, 38),
        SliderFill = Color3.fromRGB(255, 40, 40),       -- Merah untuk slider fill
        SliderThumb = Color3.fromRGB(255, 255, 255),
        
        Sidebar = Color3.fromRGB(10, 10, 15),
        SidebarGlow = Color3.fromRGB(255, 40, 40, 0.1),
        
        -- Efek khusus
        Overlay = Color3.fromRGB(0, 0, 0, 0.7),
        Glow = Color3.fromRGB(255, 40, 40, 0.25),       -- Glow merah
        Scanline = Color3.fromRGB(255, 40, 40, 0.05),    -- Efek scanline
        Gradient1 = Color3.fromRGB(255, 20, 20),
        Gradient2 = Color3.fromRGB(180, 10, 10)
    }
}

function SimpleGUI.new()
    --print("🚀 Initializing Bee Futuristic Edition...")
    
    local self = setmetatable({}, SimpleGUI)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BeeHub_" .. math.random(1000, 9999)
    self.ScreenGui.DisplayOrder = 99999
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    
    local success, err = pcall(function()
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self.Windows = {}
    self.CurrentTheme = "Bee"
    self.MinimizedIcons = {}
    
    --print("✅ Bee Futuristic Edition initialized!")
    return self
end

function SimpleGUI:GetTheme()
    return self.Themes[self.CurrentTheme]
end

-- Fungsi tween yang ditingkatkan
local function tween(object, properties, duration, easingStyle, easingDirection)
    if not object then return nil end
    
    local tweenInfo = TweenInfo.new(
        duration or 0.2, 
        easingStyle or Enum.EasingStyle.Quint, 
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Fungsi untuk efek glow
local function createGlow(parent, color, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = size or UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://13110549987"
    glow.ImageColor3 = color or Color3.fromRGB(255, 40, 40)
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 10, 10)
    glow.ZIndex = -1
    glow.Parent = parent
    return glow
end

-- Fungsi untuk efek scanline
local function addScanlines(frame)
    local scanline = Instance.new("Frame")
    scanline.Name = "Scanline"
    scanline.Size = UDim2.new(1, 0, 1, 0)
    scanline.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    scanline.BackgroundTransparency = 0.95
    scanline.BorderSizePixel = 0
    scanline.ZIndex = 5
    scanline.Parent = frame
    
    -- Animasi scanline bergerak
    local function animateScanline()
        local yPos = 0
        while scanline and scanline.Parent do
            yPos = (yPos + 1) % 100
            scanline.Position = UDim2.new(0, 0, yPos/100, 0)
            scanline.Size = UDim2.new(1, 0, 0.02, 0)
            task.wait(0.05)
        end
    end
    task.spawn(animateScanline)
end

-- Create window dengan tampilan Bee Futuristic
function SimpleGUI:CreateWindow(options)
    local opts = options or {}
    local isMobile = UserInputService.TouchEnabled
    local scale = isMobile and 0.85 or 1.0
    
    local windowData = {
        Name = opts.Name or "BEE HUB",
        SubName = opts.SubName or "discord.gg/abcd | Bee Black",
        Size = opts.Size or UDim2.new(0, 750 * scale, 0, 520 * scale),
        Position = opts.Position or UDim2.new(0.5, -375 * scale, 0.5, -260 * scale),
        IsMobile = isMobile,
        Scale = scale,
        SidebarWidth = 190 * scale,
        Logo = "B"
    }
    
    local theme = self:GetTheme()
    
    -- ===== MAIN WINDOW FRAME =====
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "BeeHub_Window"
    MainFrame.Size = windowData.Size
    MainFrame.Position = windowData.Position
    MainFrame.BackgroundColor3 = theme.WindowBg
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = true
    MainFrame.Parent = self.ScreenGui
    
    -- Shadow lebih gelap
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://13110549987"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    
    -- Glow effect untuk window
    local WindowGlow = createGlow(MainFrame, theme.AccentGlow, UDim2.new(1, 25, 1, 25))
    
    -- Rounded corners
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 10 * scale)
    WindowCorner.Parent = MainFrame
    
    -- ===== TITLE BAR =====
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 52 * scale)
    TitleBar.BackgroundColor3 = theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 10 * scale)
    TitleBarCorner.Parent = TitleBar
    
    -- Bottom line dengan efek glow
    local TitleBarLine = Instance.new("Frame")
    TitleBarLine.Name = "TitleBarLine"
    TitleBarLine.Size = UDim2.new(1, 0, 0, 2)
    TitleBarLine.Position = UDim2.new(0, 0, 1, -2)
    TitleBarLine.BackgroundColor3 = theme.Accent
    TitleBarLine.BackgroundTransparency = 0.3
    TitleBarLine.BorderSizePixel = 0
    TitleBarLine.Parent = TitleBar
    
    -- Glow untuk line
    local LineGlow = Instance.new("Frame")
    LineGlow.Name = "LineGlow"
    LineGlow.Size = UDim2.new(1, 0, 0, 4)
    LineGlow.Position = UDim2.new(0, 0, 1, -4)
    LineGlow.BackgroundColor3 = theme.AccentGlow
    LineGlow.BackgroundTransparency = 0.7
    LineGlow.BorderSizePixel = 0
    LineGlow.Parent = TitleBar
    
    -- Title Container
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(0.6, 0, 1, 0)
    TitleContainer.Position = UDim2.new(0, 12 * scale, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = TitleBar
    
    -- Icon/Logo Futuristik dengan efek
    local TitleIcon = Instance.new("TextLabel")
    TitleIcon.Name = "TitleIcon"
    TitleIcon.Size = UDim2.new(0, 38 * scale, 0, 38 * scale)
    TitleIcon.Position = UDim2.new(0, 0, 0.5, -19 * scale)
    TitleIcon.Text = "B"
    TitleIcon.TextColor3 = Color3.new(1, 1, 1)
    TitleIcon.BackgroundColor3 = theme.Accent
    TitleIcon.BackgroundTransparency = 0
    TitleIcon.TextSize = 22 * scale
    TitleIcon.Font = Enum.Font.GothamBlack
    TitleIcon.Parent = TitleContainer
    
    -- Efek glow pada icon
    local IconGlow = Instance.new("ImageLabel")
    IconGlow.Name = "IconGlow"
    IconGlow.Size = UDim2.new(1, 10, 1, 10)
    IconGlow.Position = UDim2.new(0, -5, 0, -5)
    IconGlow.BackgroundTransparency = 1
    IconGlow.Image = "rbxassetid://13110549987"
    IconGlow.ImageColor3 = theme.AccentGlow
    IconGlow.ImageTransparency = 0.5
    IconGlow.ScaleType = Enum.ScaleType.Slice
    IconGlow.SliceCenter = Rect.new(10, 10, 10, 10)
    IconGlow.ZIndex = -1
    IconGlow.Parent = TitleIcon
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 8 * scale)
    IconCorner.Parent = TitleIcon
    
    -- Title Text Frame
    local TitleTextFrame = Instance.new("Frame")
    TitleTextFrame.Name = "TitleTextFrame"
    TitleTextFrame.Size = UDim2.new(1, -48 * scale, 1, 0)
    TitleTextFrame.Position = UDim2.new(0, 48 * scale, 0, 0)
    TitleTextFrame.BackgroundTransparency = 1
    TitleTextFrame.Parent = TitleContainer
    
    -- Main Title dengan efek glow
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0.5, -2)
    TitleLabel.Position = UDim2.new(0, 0, 0, 10 * scale)
    TitleLabel.Text = windowData.Name
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextSize = 16 * scale
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleTextFrame
    
    -- Sub Title dengan efek
    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitle"
    SubTitleLabel.Size = UDim2.new(1, 0, 0.5, -2)
    SubTitleLabel.Position = UDim2.new(0, 0, 0.5, 2)
    SubTitleLabel.Text = windowData.SubName
    SubTitleLabel.TextColor3 = theme.Accent  -- Merah untuk sub title
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.TextSize = 11 * scale
    SubTitleLabel.Font = Enum.Font.Gotham  -- Tetap Gotham untuk subtitle (lebih tipis)
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleTextFrame
    
    -- Control Buttons dengan efek
    local buttonSize = 32 * scale
    local buttonSpacing = 6 * scale
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    MinimizeButton.Position = UDim2.new(1, -buttonSize * 2 - buttonSpacing * 2 - 12 * scale, 0.5, -buttonSize/2)
    MinimizeButton.Text = "—"
    MinimizeButton.TextColor3 = theme.TextSecondary
    MinimizeButton.BackgroundColor3 = theme.Button
    MinimizeButton.BackgroundTransparency = 0
    MinimizeButton.TextSize = 20 * scale
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.Parent = TitleBar
    
    local MinimizeButtonCorner = Instance.new("UICorner")
    MinimizeButtonCorner.CornerRadius = UDim.new(0, 8 * scale)
    MinimizeButtonCorner.Parent = MinimizeButton
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    CloseButton.Position = UDim2.new(1, -buttonSize - 12 * scale, 0.5, -buttonSize/2)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = theme.Error
    CloseButton.BackgroundColor3 = theme.Button
    CloseButton.BackgroundTransparency = 0
    CloseButton.TextSize = 18 * scale
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.Parent = TitleBar
    
    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0, 8 * scale)
    CloseButtonCorner.Parent = CloseButton
    
    -- ===== SIDEBAR =====
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, windowData.SidebarWidth, 1, -52 * scale)
    Sidebar.Position = UDim2.new(0, 0, 0, 52 * scale)
    Sidebar.BackgroundColor3 = theme.Sidebar
    Sidebar.BackgroundTransparency = 0
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    Sidebar.ScrollBarThickness = 3 * scale
    Sidebar.ScrollBarImageColor3 = theme.Accent
    Sidebar.ScrollBarImageTransparency = 0.3
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    Sidebar.ElasticBehavior = Enum.ElasticBehavior.Always
    Sidebar.Parent = MainFrame
    
    -- Sidebar Border dengan efek
    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Name = "SidebarBorder"
    SidebarBorder.Size = UDim2.new(0, 2, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -2, 0, 0)
    SidebarBorder.BackgroundColor3 = theme.Accent
    SidebarBorder.BackgroundTransparency = 0.5
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar
    
    -- Efek glow pada border
    local BorderGlow = Instance.new("Frame")
    BorderGlow.Name = "BorderGlow"
    BorderGlow.Size = UDim2.new(0, 4, 1, 0)
    BorderGlow.Position = UDim2.new(1, -4, 0, 0)
    BorderGlow.BackgroundColor3 = theme.AccentGlow
    BorderGlow.BackgroundTransparency = 0.7
    BorderGlow.BorderSizePixel = 0
    BorderGlow.Parent = Sidebar
    
    -- Sidebar Header
    local SidebarHeader = Instance.new("Frame")
    SidebarHeader.Name = "SidebarHeader"
    SidebarHeader.Size = UDim2.new(1, 0, 0, 42 * scale)
    SidebarHeader.BackgroundTransparency = 1
    SidebarHeader.Parent = Sidebar
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Name = "HeaderLabel"
    HeaderLabel.Size = UDim2.new(1, -20, 1, 0)
    HeaderLabel.Position = UDim2.new(0, 12, 0, 12)
    HeaderLabel.Text = "▪️ MENU ▪️"
    HeaderLabel.TextColor3 = theme.Accent  -- Merah untuk MENU
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.TextSize = 14 * scale
    HeaderLabel.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = SidebarHeader
    
    -- Sidebar Container
    local SidebarContainer = Instance.new("Frame")
    SidebarContainer.Name = "SidebarContainer"
    SidebarContainer.Size = UDim2.new(1, 0, 0, 0)
    SidebarContainer.BackgroundTransparency = 1
    SidebarContainer.Parent = Sidebar
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 4 * scale)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = SidebarContainer
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 46 * scale)
    SidebarPadding.PaddingLeft = UDim.new(0, 8 * scale)
    SidebarPadding.PaddingRight = UDim.new(0, 8 * scale)
    SidebarPadding.PaddingBottom = UDim.new(0, 10 * scale)
    SidebarPadding.Parent = SidebarContainer
    
    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarContainer.Size = UDim2.new(1, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 56 * scale)
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 56 * scale)
    end)
    
    -- ===== CONTENT FRAME =====
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -windowData.SidebarWidth, 1, -52 * scale)
    ContentFrame.Position = UDim2.new(0, windowData.SidebarWidth, 0, 52 * scale)
    ContentFrame.BackgroundColor3 = theme.ContentBg
    ContentFrame.BackgroundTransparency = 0
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 3 * scale
    ContentFrame.ScrollBarImageColor3 = theme.Accent
    ContentFrame.ScrollBarImageTransparency = 0.3
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentFrame.ElasticBehavior = Enum.ElasticBehavior.Always
    ContentFrame.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10 * scale)
    ContentCorner.Parent = ContentFrame
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 0, 0)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = ContentFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10 * scale)
    ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Parent = ContentContainer
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 15 * scale)
    ContentPadding.PaddingRight = UDim.new(0, 15 * scale)
    ContentPadding.PaddingTop = UDim.new(0, 15 * scale)
    ContentPadding.PaddingBottom = UDim.new(0, 15 * scale)
    ContentPadding.Parent = ContentContainer
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentContainer.Size = UDim2.new(1, 0, 0, ContentList.AbsoluteContentSize.Y + 30 * scale)
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 30 * scale)
    end)
    
    -- ===== SECTION HEADER =====
    local function createSectionHeader(parent, title)
        local HeaderFrame = Instance.new("Frame")
        HeaderFrame.Name = title .. "_Header"
        HeaderFrame.Size = UDim2.new(0.95, 0, 0, 32 * scale)
        HeaderFrame.BackgroundTransparency = 1
        HeaderFrame.Parent = parent
        
        local HeaderTitle = Instance.new("TextLabel")
        HeaderTitle.Name = "HeaderTitle"
        HeaderTitle.Size = UDim2.new(0, 120, 1, 0)
        HeaderTitle.Text = "▶ " .. title .. " ◀"
        HeaderTitle.TextColor3 = theme.Accent  -- Merah untuk section header
        HeaderTitle.BackgroundTransparency = 1
        HeaderTitle.TextSize = 15 * scale
        HeaderTitle.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
        HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
        HeaderTitle.Parent = HeaderFrame
        
        local HeaderLine = Instance.new("Frame")
        HeaderLine.Name = "HeaderLine"
        HeaderLine.Size = UDim2.new(1, -130, 0, 2)
        HeaderLine.Position = UDim2.new(0, 130, 0.5, -1)
        HeaderLine.BackgroundColor3 = theme.Accent
        HeaderLine.BackgroundTransparency = 0.4
        HeaderLine.BorderSizePixel = 0
        HeaderLine.Parent = HeaderFrame
        
        return HeaderFrame
    end
    
    -- ===== WINDOW OBJECT =====
    local windowObj = {
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        TitleLabel = TitleLabel,
        Sidebar = Sidebar,
        ContentFrame = ContentFrame,
        Tabs = {},
        ActiveTab = nil,
        WindowData = windowData,
        IsMinimized = false,
        
        UpdateTheme = function(self, newTheme)
            theme = newTheme
            
            MainFrame.BackgroundColor3 = theme.WindowBg
            TitleBar.BackgroundColor3 = theme.TitleBar
            TitleBarLine.BackgroundColor3 = theme.Accent
            TitleLabel.TextColor3 = theme.Text
            SubTitleLabel.TextColor3 = theme.Accent
            TitleIcon.BackgroundColor3 = theme.Accent
            Sidebar.BackgroundColor3 = theme.Sidebar
            SidebarBorder.BackgroundColor3 = theme.Accent
            Sidebar.ScrollBarImageColor3 = theme.Accent
            HeaderLabel.TextColor3 = theme.Accent
            ContentFrame.BackgroundColor3 = theme.ContentBg
            ContentFrame.ScrollBarImageColor3 = theme.Accent
            
            MinimizeButton.BackgroundColor3 = theme.Button
            MinimizeButton.TextColor3 = theme.TextSecondary
            CloseButton.BackgroundColor3 = theme.Button
            CloseButton.TextColor3 = theme.Error
            
            WindowGlow.ImageColor3 = theme.AccentGlow
            
            for tabName, tabData in pairs(self.Tabs) do
                if tabData.Button then
                    tabData.Button.BackgroundColor3 = theme.TabNormal
                    tabData.Button.TextColor3 = theme.TextSecondary
                    
                    if self.ActiveTab == tabName then
                        tabData.Button.BackgroundColor3 = theme.TabActive
                        tabData.Button.TextColor3 = Color3.new(1, 1, 1)  -- Text putih di tab aktif
                    end
                end
                
                if tabData.UpdateTheme then
                    tabData:UpdateTheme(newTheme)
                end
            end
        end,
        
        SetVisible = function(self, visible)
            MainFrame.Visible = visible
        end,
        
        Destroy = function(self)
            MainFrame:Destroy()
        end
    }
    
    self.Windows[windowData.Name] = windowObj
    
    -- ===== TAB CREATION =====
    function windowObj:CreateTab(options)
        local tabOptions = type(options) == "string" and {Name = options} or (options or {})
        local tabName = tabOptions.Name or "Tab_" .. (#self.Tabs + 1)
        local icon = tabOptions.Icon or "●"
        local scale = self.WindowData.Scale
        
        -- Tab Button dengan efek
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "_Button"
        TabButton.Size = UDim2.new(1, -16 * scale, 0, 42 * scale)
        TabButton.Text = icon .. "  " .. tabName
        TabButton.TextColor3 = theme.TextSecondary
        TabButton.BackgroundColor3 = theme.TabNormal
        TabButton.BackgroundTransparency = 0
        TabButton.TextSize = 13 * scale
        TabButton.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        TabButton.LayoutOrder = #self.Tabs + 1
        TabButton.Parent = SidebarContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8 * scale)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName .. "_Content"
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 10 * scale)
        TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContent
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Tab click handler
        TabButton.MouseButton1Click:Connect(function()
            for name, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tween(tab.Button, {BackgroundColor3 = theme.TabNormal}, 0.15)
                tab.Button.TextColor3 = theme.TextSecondary
            end
            
            TabContent.Visible = true
            tween(TabButton, {BackgroundColor3 = theme.TabActive}, 0.15)
            TabButton.TextColor3 = Color3.new(1, 1, 1)  -- Text putih saat aktif
            self.ActiveTab = tabName
        end)
        
        -- Button hover effects
        local function setupButtonHover(button, hoverColor, normalColor)
            if not button or not button:IsA("TextButton") then return end
            
            button.MouseEnter:Connect(function()
                if not isMobile and button.BackgroundColor3 ~= theme.TabActive then
                    tween(button, {BackgroundColor3 = theme.TabHover}, 0.15)
                end
            end)
            
            button.MouseLeave:Connect(function()
                if not isMobile and button.BackgroundColor3 ~= theme.TabActive then
                    tween(button, {BackgroundColor3 = normalColor or theme.TabNormal}, 0.15)
                end
            end)
        end
        
        setupButtonHover(TabButton, theme.TabHover, theme.TabNormal)
        setupButtonHover(MinimizeButton, theme.ButtonHover, theme.Button)
        setupButtonHover(CloseButton, theme.ButtonHover, theme.Button)
        
        -- ===== TAB BUILDER METHODS =====
        local tabObj = {
            Button = TabButton,
            Content = TabContent,
            Elements = {},
            ElementObjects = {},
            
            UpdateTheme = function(self, newTheme)
                TabButton.BackgroundColor3 = newTheme.TabNormal
                TabButton.TextColor3 = newTheme.TextSecondary
                
                if windowObj.ActiveTab == tabName then
                    TabButton.BackgroundColor3 = newTheme.TabActive
                    TabButton.TextColor3 = Color3.new(1, 1, 1)  -- Text putih di tab aktif
                end
            end,
            
            CreateSection = function(self, title)
                return createSectionHeader(TabContent, title)
            end,
            
            CreateButton = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local Button = Instance.new("TextButton")
                Button.Name = opts.Name or "Button_" .. #self.Elements + 1
                Button.Size = UDim2.new(0.95, 0, 0, 40 * scale)
                Button.Text = opts.Text or Button.Name
                Button.TextColor3 = theme.Text
                Button.BackgroundColor3 = theme.Button
                Button.BackgroundTransparency = 0
                Button.TextSize = 13 * scale
                Button.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
                Button.AutoButtonColor = false
                Button.LayoutOrder = #self.Elements + 1
                Button.Parent = TabContent
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 8 * scale)
                Corner.Parent = Button
                
                -- Efek glow saat hover
                local ButtonGlow = createGlow(Button, theme.AccentGlow, UDim2.new(1, 10, 1, 10))
                ButtonGlow.ImageTransparency = 1
                
                -- Hover effect
                Button.MouseEnter:Connect(function()
                    if not isMobile then
                        tween(Button, {BackgroundColor3 = theme.ButtonHover}, 0.15)
                        tween(ButtonGlow, {ImageTransparency = 0.6}, 0.15)
                    end
                end)
                
                Button.MouseLeave:Connect(function()
                    if not isMobile then
                        tween(Button, {BackgroundColor3 = theme.Button}, 0.15)
                        tween(ButtonGlow, {ImageTransparency = 1}, 0.15)
                    end
                end)
                
                Button.MouseButton1Click:Connect(function()
                    tween(Button, {BackgroundColor3 = theme.Accent}, 0.1)
                    tween(ButtonGlow, {ImageTransparency = 0.3}, 0.1)
                    task.wait(0.1)
                    tween(Button, {BackgroundColor3 = theme.ButtonHover}, 0.1)
                    task.wait(0.1)
                    tween(Button, {BackgroundColor3 = theme.Button}, 0.1)
                    tween(ButtonGlow, {ImageTransparency = 1}, 0.1)
                    
                    if opts.Callback then
                        pcall(opts.Callback)
                    end
                end)
                
                table.insert(self.Elements, Button)
                return Button
            end,
            
            CreateLabel = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local Label = Instance.new("TextLabel")
                Label.Name = opts.Name or "Label_" .. #self.Elements + 1
                Label.Size = UDim2.new(0.95, 0, 0, 32 * scale)
                Label.Text = opts.Text or Label.Name
                Label.TextColor3 = opts.Color or theme.TextSecondary
                Label.BackgroundTransparency = 1
                Label.TextSize = opts.Size or 13 * scale
                -- ABAIKAN OPSI BOLD, SELALU PAKAI GOTHAMBLACK
                Label.Font = Enum.Font.GothamBlack
                Label.TextXAlignment = opts.Alignment or Enum.TextXAlignment.Left
                Label.LayoutOrder = #self.Elements + 1
                Label.Parent = TabContent
                
                table.insert(self.Elements, Label)
                return Label
            end,
            
            -- ===== CREATE TOGGLE DENGAN BORDER FULL DAN BACKGROUND CARD FULL =====
            CreateToggle = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                -- Main container dengan border FULL
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = opts.Name or "Toggle_" .. #self.Elements + 1
                ToggleFrame.Size = UDim2.new(0.95, 0, 0, 46 * scale)
                ToggleFrame.BackgroundColor3 = theme.ContentCard
                ToggleFrame.BackgroundTransparency = 0
                ToggleFrame.BorderSizePixel = 2
                ToggleFrame.BorderColor3 = theme.BorderLight
                ToggleFrame.LayoutOrder = #self.Elements + 1
                ToggleFrame.Parent = TabContent
                
                -- Rounded corners untuk container
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = ToggleFrame
                
                -- INNER FRAME untuk background card
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = ToggleFrame
                
                -- Rounded corners untuk inner frame
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                -- Efek glow tipis
                local FrameGlow = createGlow(ToggleFrame, theme.AccentGlow, UDim2.new(1, 8, 1, 8))
                FrameGlow.ImageTransparency = 0.9
                
                -- Toggle label (teks menu) di KIRI
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 13 * scale, 0, 0)
                ToggleLabel.Text = opts.Text or opts.Name or "Toggle"
                ToggleLabel.TextColor3 = theme.Text
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.TextSize = 13 * scale
                ToggleLabel.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = InnerFrame
                
                -- Toggle container di KANAN
                local ToggleContainer = Instance.new("TextButton")
                ToggleContainer.Name = "ToggleContainer"
                ToggleContainer.Size = UDim2.new(0, 50 * scale, 0, 26 * scale)
                ToggleContainer.Position = UDim2.new(1, -63 * scale, 0.5, -13 * scale)
                ToggleContainer.Text = ""
                ToggleContainer.BackgroundColor3 = theme.ToggleOff
                ToggleContainer.BackgroundTransparency = 0
                ToggleContainer.BorderSizePixel = 0
                ToggleContainer.AutoButtonColor = false
                ToggleContainer.Parent = InnerFrame
                
                local ContainerCorner = Instance.new("UICorner")
                ContainerCorner.CornerRadius = UDim.new(0, 13 * scale)
                ContainerCorner.Parent = ToggleContainer
                
                -- Toggle circle
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.Size = UDim2.new(0, 22 * scale, 0, 22 * scale)
                ToggleCircle.Position = UDim2.new(0, 2 * scale, 0.5, -11 * scale)
                ToggleCircle.BackgroundColor3 = theme.ToggleCircle
                ToggleCircle.BackgroundTransparency = 0
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleContainer
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(0.5, 0)
                CircleCorner.Parent = ToggleCircle
                
                -- Glow effect untuk toggle container
                local ToggleGlow = createGlow(ToggleContainer, theme.AccentGlow, UDim2.new(1, 10, 1, 10))
                ToggleGlow.ImageTransparency = 1
                
                -- Toggle state
                local isToggled = opts.CurrentValue or false
                
                local function updateToggle()
                    if isToggled then
                        tween(ToggleContainer, {BackgroundColor3 = theme.ToggleOn}, 0.2)
                        tween(ToggleCircle, {Position = UDim2.new(1, -24 * scale, 0.5, -11 * scale)}, 0.2)
                        tween(ToggleGlow, {ImageTransparency = 0.5}, 0.2)
                        tween(ToggleFrame, {BorderColor3 = theme.BorderRed}, 0.2)
                    else
                        tween(ToggleContainer, {BackgroundColor3 = theme.ToggleOff}, 0.2)
                        tween(ToggleCircle, {Position = UDim2.new(0, 2 * scale, 0.5, -11 * scale)}, 0.2)
                        tween(ToggleGlow, {ImageTransparency = 1}, 0.2)
                        tween(ToggleFrame, {BorderColor3 = theme.BorderLight}, 0.2)
                    end
                end
                
                updateToggle()
                
                local function toggle()
                    isToggled = not isToggled
                    updateToggle()
                    if opts.Callback then
                        pcall(opts.Callback, isToggled)
                    end
                end
                
                ToggleContainer.MouseButton1Click:Connect(toggle)
                
                -- Klik label juga untuk toggle
                ToggleLabel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggle()
                    end
                end)
                
                -- Hover effect pada frame
                ToggleFrame.MouseEnter:Connect(function()
                    if not isMobile then
                        tween(ToggleFrame, {BackgroundColor3 = theme.ContentBgLight}, 0.15)
                    end
                end)
                
                ToggleFrame.MouseLeave:Connect(function()
                    if not isMobile then
                        tween(ToggleFrame, {BackgroundColor3 = theme.ContentCard}, 0.15)
                    end
                end)
                
                table.insert(self.Elements, ToggleFrame)
                
                return {
                    Frame = ToggleFrame,
                    GetValue = function() return isToggled end,
                    SetValue = function(value)
                        isToggled = value
                        updateToggle()
                        if opts.Callback then
                            pcall(opts.Callback, isToggled)
                        end
                    end
                }
            end,
            
            CreateSlider = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = opts.Name or "Slider_" .. #self.Elements + 1
                SliderFrame.Size = UDim2.new(0.95, 0, 0, 75 * scale)
                SliderFrame.BackgroundColor3 = theme.ContentCard
                SliderFrame.BackgroundTransparency = 0
                SliderFrame.BorderSizePixel = 2
                SliderFrame.BorderColor3 = theme.BorderLight
                SliderFrame.LayoutOrder = #self.Elements + 1
                SliderFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = SliderFrame
                
                -- Inner frame untuk slider
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = SliderFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                -- Label
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Size = UDim2.new(1, -50, 0, 22 * scale)
                SliderLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                SliderLabel.Text = opts.Name or "Slider"
                SliderLabel.TextColor3 = theme.Text
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.TextSize = 13 * scale
                SliderLabel.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = InnerFrame
                
                -- Value display
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "ValueLabel"
                ValueLabel.Size = UDim2.new(0, 45, 0, 22 * scale)
                ValueLabel.Position = UDim2.new(1, -58 * scale, 0, 8 * scale)
                ValueLabel.Text = tostring(opts.CurrentValue or (opts.Range and opts.Range[1]) or 50)
                ValueLabel.TextColor3 = theme.Accent
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.TextSize = 14 * scale
                ValueLabel.Font = Enum.Font.GothamBlack
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = InnerFrame
                
                -- Slider track
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "SliderTrack"
                SliderTrack.Size = UDim2.new(1, -30, 0, 22 * scale)
                SliderTrack.Position = UDim2.new(0, 13 * scale, 0, 38 * scale)
                SliderTrack.BackgroundColor3 = theme.SliderTrack
                SliderTrack.BackgroundTransparency = 0
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Parent = InnerFrame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 11 * scale)
                TrackCorner.Parent = SliderTrack
                
                -- Slider fill
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = theme.SliderFill
                SliderFill.BackgroundTransparency = 0
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderTrack
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 11 * scale)
                FillCorner.Parent = SliderFill
                
                -- Slider thumb dengan glow
                local SliderThumb = Instance.new("TextButton")
                SliderThumb.Name = "SliderThumb"
                SliderThumb.Size = UDim2.new(0, 26 * scale, 0, 26 * scale)
                SliderThumb.Position = UDim2.new(0, -13 * scale, 0.5, -13 * scale)
                SliderThumb.Text = ""
                SliderThumb.BackgroundColor3 = theme.SliderThumb
                SliderThumb.BackgroundTransparency = 0
                SliderThumb.AutoButtonColor = false
                SliderThumb.Parent = SliderTrack
                
                local ThumbCorner = Instance.new("UICorner")
                ThumbCorner.CornerRadius = UDim.new(0.5, 0)
                ThumbCorner.Parent = SliderThumb
                
                local ThumbGlow = createGlow(SliderThumb, theme.AccentGlow, UDim2.new(1, 10, 1, 10))
                ThumbGlow.ImageTransparency = 0.7
                
                -- Slider variables
                local range = opts.Range or {0, 100}
                local increment = opts.Increment or 1
                local currentValue = opts.CurrentValue or range[1]
                local isDragging = false
                
                local function updateSliderPosition(value)
                    currentValue = math.clamp(
                        math.floor((value - range[1]) / increment) * increment + range[1],
                        range[1],
                        range[2]
                    )
                    
                    local percentage = (currentValue - range[1]) / (range[2] - range[1])
                    local fillWidth = math.clamp(percentage, 0, 1)
                    
                    SliderFill.Size = UDim2.new(fillWidth, 0, 1, 0)
                    SliderThumb.Position = UDim2.new(fillWidth, -13 * scale, 0.5, -13 * scale)
                    ValueLabel.Text = tostring(currentValue)
                    
                    if opts.Callback then
                        pcall(opts.Callback, currentValue)
                    end
                end
                
                updateSliderPosition(currentValue)
                
                SliderThumb.MouseButton1Down:Connect(function()
                    isDragging = true
                    tween(SliderThumb, {Size = UDim2.new(0, 30 * scale, 0, 30 * scale)}, 0.1)
                    tween(ThumbGlow, {ImageTransparency = 0.4}, 0.1)
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local trackPos = SliderTrack.AbsolutePosition
                        local trackSize = SliderTrack.AbsoluteSize
                        
                        local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                        relativeX = math.clamp(relativeX, 0, 1)
                        
                        local value = range[1] + (relativeX * (range[2] - range[1]))
                        updateSliderPosition(value)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
                        isDragging = false
                        tween(SliderThumb, {Size = UDim2.new(0, 26 * scale, 0, 26 * scale)}, 0.1)
                        tween(ThumbGlow, {ImageTransparency = 0.7}, 0.1)
                    end
                end)
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = UserInputService:GetMouseLocation()
                        local trackPos = SliderTrack.AbsolutePosition
                        local trackSize = SliderTrack.AbsoluteSize
                        
                        local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                        relativeX = math.clamp(relativeX, 0, 1)
                        
                        local value = range[1] + (relativeX * (range[2] - range[1]))
                        updateSliderPosition(value)
                    end
                end)
                
                table.insert(self.Elements, SliderFrame)
                
                return {
                    Frame = SliderFrame,
                    GetValue = function() return currentValue end,
                    SetValue = function(value)
                        updateSliderPosition(value)
                    end
                }
            end,
            
            CreateDropdown = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = opts.Name or "Dropdown_" .. #self.Elements + 1
                DropdownFrame.Size = UDim2.new(0.95, 0, 0, 80 * scale)
                DropdownFrame.BackgroundColor3 = theme.ContentCard
                DropdownFrame.BackgroundTransparency = 0
                DropdownFrame.BorderSizePixel = 2
                DropdownFrame.BorderColor3 = theme.BorderLight
                DropdownFrame.LayoutOrder = #self.Elements + 1
                DropdownFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = DropdownFrame
                
                -- Inner frame untuk dropdown
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = DropdownFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                -- Label di KIRI
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "DropdownLabel"
                DropdownLabel.Size = UDim2.new(0.4, 0, 0, 22 * scale)
                DropdownLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                DropdownLabel.Text = opts.Text or opts.Name or "Dropdown"
                DropdownLabel.TextColor3 = theme.Text
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.TextSize = 13 * scale
                DropdownLabel.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = InnerFrame
                
                -- Dropdown button di KANAN
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Size = UDim2.new(0.55, -20, 0, 34 * scale)
                DropdownButton.Position = UDim2.new(0.45, 10, 0, 8 * scale)
                DropdownButton.Text = opts.Default or (opts.Options and #opts.Options > 0 and opts.Options[1]) or "Pilih opsi"
                DropdownButton.TextColor3 = theme.Text
                DropdownButton.BackgroundColor3 = theme.InputBg
                DropdownButton.BackgroundTransparency = 0
                DropdownButton.TextSize = 13 * scale
                DropdownButton.Font = Enum.Font.GothamBlack  -- UBAH KE GOTHAMBLACK
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = InnerFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6 * scale)
                ButtonCorner.Parent = DropdownButton
                
                -- Arrow icon
                local ArrowLabel = Instance.new("TextLabel")
                ArrowLabel.Name = "ArrowLabel"
                ArrowLabel.Size = UDim2.new(0, 22 * scale, 1, 0)
                ArrowLabel.Position = UDim2.new(1, -26 * scale, 0, 0)
                ArrowLabel.Text = "▼"
                ArrowLabel.TextColor3 = theme.Accent
                ArrowLabel.BackgroundTransparency = 1
                ArrowLabel.TextSize = 12 * scale
                ArrowLabel.Font = Enum.Font.Gotham
                ArrowLabel.Parent = DropdownButton
                
                -- Dropdown container
                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = "DropdownContainer"
                DropdownContainer.Size = UDim2.new(1, -30, 0, 0)
                DropdownContainer.Position = UDim2.new(0, 13 * scale, 0, 44 * scale)
                DropdownContainer.BackgroundColor3 = theme.InputBgFocus
                DropdownContainer.BackgroundTransparency = 0
                DropdownContainer.BorderSizePixel = 0
                DropdownContainer.ClipsDescendants = true
                DropdownContainer.Visible = false
                DropdownContainer.Parent = InnerFrame
                
                local ContainerCorner = Instance.new("UICorner")
                ContainerCorner.CornerRadius = UDim.new(0, 6 * scale)
                ContainerCorner.Parent = DropdownContainer
                
                -- Dropdown list
                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Name = "DropdownList"
                DropdownList.Size = UDim2.new(1, -2, 1, -2)
                DropdownList.Position = UDim2.new(0, 1, 0, 1)
                DropdownList.BackgroundTransparency = 1
                DropdownList.BorderSizePixel = 0
                DropdownList.ScrollBarThickness = 3 * scale
                DropdownList.ScrollBarImageColor3 = theme.Accent
                DropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
                DropdownList.ScrollingDirection = Enum.ScrollingDirection.Y
                DropdownList.ElasticBehavior = Enum.ElasticBehavior.Always
                DropdownList.Parent = DropdownContainer
                
                -- List layout
                local ItemLayout = Instance.new("UIListLayout")
                ItemLayout.Padding = UDim.new(0, 2 * scale)
                ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ItemLayout.Parent = DropdownList
                
                local ListPadding = Instance.new("UIPadding")
                ListPadding.PaddingTop = UDim.new(0, 2 * scale)
                ListPadding.PaddingBottom = UDim.new(0, 2 * scale)
                ListPadding.Parent = DropdownList
                
                ItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, ItemLayout.AbsoluteContentSize.Y + 4 * scale)
                end)
                
                -- Variables
                local isOpen = false
                local selectedValue = opts.Default or (opts.Options and #opts.Options > 0 and opts.Options[1]) or ""
                local dropdownItems = {}
                
                opts.Options = opts.Options or {}
                
                local function updateContainerSize()
                    local itemCount = #opts.Options
                    local height = math.min(itemCount * 32 * scale + 4 * scale, 150 * scale)
                    DropdownContainer.Size = UDim2.new(1, -30, 0, height)
                    
                    local totalHeight = 80 * scale
                    if isOpen then
                        totalHeight = 80 * scale + height + 4 * scale
                    end
                    DropdownFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
                end
                
                local function createDropdownItems()
                    for _, item in pairs(dropdownItems) do
                        if item and item.Destroy then
                            pcall(function() item:Destroy() end)
                        end
                    end
                    dropdownItems = {}
                    
                    for _, child in pairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    if not opts.Options or #opts.Options == 0 then
                        local EmptyLabel = Instance.new("TextLabel")
                        EmptyLabel.Name = "EmptyLabel"
                        EmptyLabel.Size = UDim2.new(1, -4 * scale, 0, 30 * scale)
                        EmptyLabel.Text = "Tidak ada data"
                        EmptyLabel.TextColor3 = theme.TextMuted
                        EmptyLabel.BackgroundTransparency = 1
                        EmptyLabel.TextSize = 12 * scale
                        EmptyLabel.Font = Enum.Font.Gotham
                        EmptyLabel.Parent = DropdownList
                        return
                    end
                    
                    for i, option in ipairs(opts.Options) do
                        local ItemButton = Instance.new("TextButton")
                        ItemButton.Name = "Item_" .. i
                        ItemButton.Size = UDim2.new(1, -4 * scale, 0, 30 * scale)
                        ItemButton.Text = tostring(option)
                        ItemButton.TextColor3 = theme.TextSecondary
                        ItemButton.BackgroundColor3 = theme.InputBg
                        ItemButton.BackgroundTransparency = 0
                        ItemButton.TextSize = 12 * scale
                        ItemButton.Font = Enum.Font.Gotham  -- Item dropdown tetap pakai Gotham biasa agar lebih terbaca
                        ItemButton.AutoButtonColor = false
                        ItemButton.LayoutOrder = i
                        ItemButton.Parent = DropdownList
                        
                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 4 * scale)
                        ItemCorner.Parent = ItemButton
                        
                        ItemButton.MouseEnter:Connect(function()
                            if not isMobile then
                                tween(ItemButton, {BackgroundColor3 = theme.ButtonHover}, 0.15)
                            end
                        end)
                        
                        ItemButton.MouseLeave:Connect(function()
                            if not isMobile then
                                if tostring(option) == selectedValue then
                                    tween(ItemButton, {BackgroundColor3 = theme.Accent}, 0.15)
                                else
                                    tween(ItemButton, {BackgroundColor3 = theme.InputBg}, 0.15)
                                end
                            end
                        end)
                        
                        ItemButton.MouseButton1Click:Connect(function()
                            selectedValue = tostring(option)
                            DropdownButton.Text = selectedValue
                            
                            for _, btn in pairs(dropdownItems) do
                                if btn and btn.Destroy then
                                    if btn.Text == selectedValue then
                                        btn.BackgroundColor3 = theme.Accent
                                        btn.TextColor3 = Color3.new(1, 1, 1)
                                    else
                                        btn.BackgroundColor3 = theme.InputBg
                                        btn.TextColor3 = theme.TextSecondary
                                    end
                                end
                            end
                            
                            isOpen = false
                            ArrowLabel.Text = "▼"
                            DropdownContainer.Visible = false
                            tween(DropdownContainer, {Size = UDim2.new(1, -30, 0, 0)}, 0.15)
                            tween(DropdownFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                            updateContainerSize()
                            
                            if opts.Callback then
                                pcall(opts.Callback, selectedValue)
                            end
                        end)
                        
                        if tostring(option) == selectedValue then
                            ItemButton.BackgroundColor3 = theme.Accent
                            ItemButton.TextColor3 = Color3.new(1, 1, 1)
                        end
                        
                        table.insert(dropdownItems, ItemButton)
                    end
                end
                
                createDropdownItems()
                updateContainerSize()
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        ArrowLabel.Text = "▲"
                        DropdownContainer.Visible = true
                        DropdownContainer.Size = UDim2.new(1, -30, 0, 0)
                        tween(DropdownContainer, {
                            Size = UDim2.new(1, -30, 0, math.min(#opts.Options * 32 * scale + 4 * scale, 150 * scale))
                        }, 0.2)
                        tween(DropdownButton, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                        tween(DropdownFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    else
                        ArrowLabel.Text = "▼"
                        tween(DropdownContainer, {Size = UDim2.new(1, -30, 0, 0)}, 0.15)
                        tween(DropdownButton, {BackgroundColor3 = theme.InputBg}, 0.15)
                        tween(DropdownFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                        task.wait(0.15)
                        DropdownContainer.Visible = false
                    end
                    
                    updateContainerSize()
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dropdownPos = DropdownFrame.AbsolutePosition
                        local dropdownSize = DropdownFrame.AbsoluteSize
                        
                        if mousePos.X < dropdownPos.X or mousePos.X > dropdownPos.X + dropdownSize.X or
                           mousePos.Y < dropdownPos.Y or mousePos.Y > dropdownPos.Y + dropdownSize.Y then
                            isOpen = false
                            ArrowLabel.Text = "▼"
                            tween(DropdownContainer, {Size = UDim2.new(1, -30, 0, 0)}, 0.15)
                            tween(DropdownButton, {BackgroundColor3 = theme.InputBg}, 0.15)
                            tween(DropdownFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                            task.wait(0.15)
                            DropdownContainer.Visible = false
                            updateContainerSize()
                        end
                    end
                end)
                
                local function updateOptions(newOptions)
                    newOptions = newOptions or {}
                    opts.Options = newOptions
                    createDropdownItems()
                    updateContainerSize()
                    
                    if #newOptions > 0 then
                        if not table.find(newOptions, selectedValue) then
                            selectedValue = newOptions[1]
                            DropdownButton.Text = selectedValue
                            if opts.Callback then
                                pcall(opts.Callback, selectedValue)
                            end
                        end
                    else
                        selectedValue = ""
                        DropdownButton.Text = "Tidak ada data"
                    end
                end
                
                table.insert(self.Elements, DropdownFrame)
                
                return {
                    Frame = DropdownFrame,
                    GetValue = function() return selectedValue end,
                    SetValue = function(value)
                        if opts.Options and #opts.Options > 0 then
                            for _, option in ipairs(opts.Options) do
                                if tostring(option) == tostring(value) then
                                    selectedValue = tostring(value)
                                    DropdownButton.Text = selectedValue
                                    
                                    for _, btn in pairs(dropdownItems) do
                                        if btn and btn.Destroy then
                                            if btn.Text == selectedValue then
                                                btn.BackgroundColor3 = theme.Accent
                                                btn.TextColor3 = Color3.new(1, 1, 1)
                                            else
                                                btn.BackgroundColor3 = theme.InputBg
                                                btn.TextColor3 = theme.TextSecondary
                                            end
                                        end
                                    end
                                    
                                    if opts.Callback then
                                        pcall(opts.Callback, value)
                                    end
                                    break
                                end
                            end
                        end
                    end,
                    UpdateOptions = function(self, newOptions)
                        updateOptions(newOptions)
                    end,
                    AddOption = function(self, option)
                        opts.Options = opts.Options or {}
                        if not table.find(opts.Options, option) then
                            table.insert(opts.Options, option)
                            createDropdownItems()
                            updateContainerSize()
                        end
                    end,
                    RemoveOption = function(self, option)
                        if opts.Options and #opts.Options > 0 then
                            local index = table.find(opts.Options, option)
                            if index then
                                table.remove(opts.Options, index)
                                createDropdownItems()
                                updateContainerSize()
                                
                                if selectedValue == option then
                                    selectedValue = opts.Options[1] or ""
                                    DropdownButton.Text = selectedValue
                                end
                            end
                        end
                    end
                }
            end,
            
            -- ===== CREATE TEXTBOX (SINGLE LINE INPUT) =====
            CreateTextBox = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                -- TextBox frame utama
                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Name = opts.Name or "TextBox_" .. #self.Elements + 1
                TextBoxFrame.Size = UDim2.new(0.95, 0, 0, 75 * scale)
                TextBoxFrame.BackgroundColor3 = theme.ContentCard
                TextBoxFrame.BackgroundTransparency = 0
                TextBoxFrame.BorderSizePixel = 2
                TextBoxFrame.BorderColor3 = theme.BorderLight
                TextBoxFrame.LayoutOrder = #self.Elements + 1
                TextBoxFrame.Parent = TabContent
                
                -- Rounded corners
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = TextBoxFrame
                
                -- Inner frame
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = TextBoxFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                -- Label
                local TextBoxLabel = Instance.new("TextLabel")
                TextBoxLabel.Name = "TextBoxLabel"
                TextBoxLabel.Size = UDim2.new(1, -26, 0, 22 * scale)
                TextBoxLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                TextBoxLabel.Text = opts.Text or opts.Name or "Input Text"
                TextBoxLabel.TextColor3 = theme.Text
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.TextSize = 13 * scale
                TextBoxLabel.Font = Enum.Font.GothamBlack
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextBoxLabel.Parent = InnerFrame
                
                -- Clear button (optional)
                local ClearButton = Instance.new("TextButton")
                ClearButton.Name = "ClearButton"
                ClearButton.Size = UDim2.new(0, 22 * scale, 0, 22 * scale)
                ClearButton.Position = UDim2.new(1, -35 * scale, 0, 8 * scale)
                ClearButton.Text = "✕"
                ClearButton.TextColor3 = theme.TextMuted
                ClearButton.BackgroundTransparency = 1
                ClearButton.TextSize = 14 * scale
                ClearButton.Font = Enum.Font.Gotham
                ClearButton.Visible = false
                ClearButton.Parent = InnerFrame
                
                -- TextBox
                local TextBox = Instance.new("TextBox")
                TextBox.Name = "TextBox"
                TextBox.Size = UDim2.new(1, -26, 0, 34 * scale)
                TextBox.Position = UDim2.new(0, 13 * scale, 0, 34 * scale)
                TextBox.Text = opts.DefaultText or opts.PlaceholderText or ""
                TextBox.PlaceholderText = opts.PlaceholderText or "Ketik sesuatu..."
                TextBox.PlaceholderColor3 = theme.TextMuted
                TextBox.TextColor3 = theme.Text
                TextBox.BackgroundColor3 = theme.InputBg
                TextBox.BackgroundTransparency = 0
                TextBox.TextSize = 13 * scale
                TextBox.Font = Enum.Font.Gotham
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.ClearTextOnFocus = false
                TextBox.Parent = InnerFrame
                
                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 6 * scale)
                TextBoxCorner.Parent = TextBox
                
                -- Efek glow saat focus
                local TextBoxGlow = createGlow(TextBox, theme.AccentGlow, UDim2.new(1, 8, 1, 8))
                TextBoxGlow.ImageTransparency = 1
                
                -- Character count (optional)
                local CharCount = Instance.new("TextLabel")
                CharCount.Name = "CharCount"
                CharCount.Size = UDim2.new(0, 50, 0, 20)
                CharCount.Position = UDim2.new(1, -60, 0, 34)
                CharCount.Text = "0/" .. (opts.MaxLength or "∞")
                CharCount.TextColor3 = theme.TextMuted
                CharCount.BackgroundTransparency = 1
                CharCount.TextSize = 10 * scale
                CharCount.Font = Enum.Font.Gotham
                CharCount.TextXAlignment = Enum.TextXAlignment.Right
                CharCount.Visible = opts.ShowCount or false
                CharCount.Parent = InnerFrame
                
                -- Variables
                local maxLength = opts.MaxLength or 0
                local textValue = opts.DefaultText or ""
                
                -- Function to update character count
                local function updateCharCount()
                    if opts.ShowCount then
                        local currentLength = string.len(TextBox.Text)
                        CharCount.Text = currentLength .. "/" .. (maxLength > 0 and maxLength or "∞")
                        
                        if maxLength > 0 and currentLength >= maxLength then
                            CharCount.TextColor3 = theme.Error
                        else
                            CharCount.TextColor3 = theme.TextMuted
                        end
                    end
                end
                
                -- Focus events
                TextBox.Focused:Connect(function()
                    tween(TextBox, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                    tween(TextBoxFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    tween(TextBoxGlow, {ImageTransparency = 0.5}, 0.15)
                    
                    if string.len(TextBox.Text) > 0 then
                        ClearButton.Visible = true
                    end
                end)
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    tween(TextBox, {BackgroundColor3 = theme.InputBg}, 0.15)
                    tween(TextBoxFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                    tween(TextBoxGlow, {ImageTransparency = 1}, 0.15)
                    ClearButton.Visible = false
                    
                    textValue = TextBox.Text
                    
                    if opts.Callback then
                        pcall(opts.Callback, TextBox.Text, enterPressed)
                    end
                end)
                
                -- Text changed
                TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if maxLength > 0 and string.len(TextBox.Text) > maxLength then
                        TextBox.Text = string.sub(TextBox.Text, 1, maxLength)
                    end
                    
                    updateCharCount()
                    
                    if opts.LiveUpdate and opts.Callback then
                        pcall(opts.Callback, TextBox.Text, false)
                    end
                    
                    if string.len(TextBox.Text) > 0 then
                        ClearButton.Visible = TextBox:IsFocused()
                    else
                        ClearButton.Visible = false
                    end
                end)
                
                -- Clear button click
                ClearButton.MouseButton1Click:Connect(function()
                    TextBox.Text = ""
                    TextBox:CaptureFocus()
                end)
                
                -- Hover effects
                ClearButton.MouseEnter:Connect(function()
                    tween(ClearButton, {TextColor3 = theme.Error}, 0.15)
                end)
                
                ClearButton.MouseLeave:Connect(function()
                    tween(ClearButton, {TextColor3 = theme.TextMuted}, 0.15)
                end)
                
                TextBoxFrame.MouseEnter:Connect(function()
                    if not isMobile and not TextBox:IsFocused() then
                        tween(TextBoxFrame, {BackgroundColor3 = theme.ContentBgLight}, 0.15)
                    end
                end)
                
                TextBoxFrame.MouseLeave:Connect(function()
                    if not isMobile and not TextBox:IsFocused() then
                        tween(TextBoxFrame, {BackgroundColor3 = theme.ContentCard}, 0.15)
                    end
                end)
                
                -- Validation types
                if opts.Validation then
                    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local text = TextBox.Text
                        
                        if opts.Validation == "number" then
                            TextBox.Text = text:gsub("[^0-9.-]", "")
                        elseif opts.Validation == "letters" then
                            TextBox.Text = text:gsub("[^a-zA-Z]", "")
                        elseif opts.Validation == "alphanumeric" then
                            TextBox.Text = text:gsub("[^a-zA-Z0-9]", "")
                        elseif opts.Validation == "email" then
                            -- No automatic filtering, just visual indicator
                            local isValid = string.match(text, "^[%w._-]+@[%w.-]+%.[%w]+$") ~= nil
                            if text ~= "" and not isValid then
                                TextBox.TextColor3 = theme.Error
                            else
                                TextBox.TextColor3 = theme.Text
                            end
                        end
                    end)
                end
                
                table.insert(self.Elements, TextBoxFrame)
                
                return {
                    Frame = TextBoxFrame,
                    TextBox = TextBox,
                    GetText = function() return TextBox.Text end,
                    SetText = function(text)
                        TextBox.Text = tostring(text)
                        textValue = tostring(text)
                    end,
                    Clear = function()
                        TextBox.Text = ""
                    end,
                    Focus = function()
                        TextBox:CaptureFocus()
                    end,
                    IsFocused = function()
                        return TextBox:IsFocused()
                    end
                }
            end,
            
            -- ===== CREATE INPUT (VERSI LEBIH LENGKAP DENGAN TIPE) =====
            CreateInput = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                -- Main frame
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = opts.Name or "Input_" .. #self.Elements + 1
                InputFrame.Size = UDim2.new(0.95, 0, 0, 85 * scale)
                InputFrame.BackgroundColor3 = theme.ContentCard
                InputFrame.BackgroundTransparency = 0
                InputFrame.BorderSizePixel = 2
                InputFrame.BorderColor3 = theme.BorderLight
                InputFrame.LayoutOrder = #self.Elements + 1
                InputFrame.Parent = TabContent
                
                -- Rounded corners
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = InputFrame
                
                -- Inner frame
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = InputFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                -- Label
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Name = "InputLabel"
                InputLabel.Size = UDim2.new(0.5, -13, 0, 22 * scale)
                InputLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                InputLabel.Text = opts.Text or opts.Name or "Input"
                InputLabel.TextColor3 = theme.Text
                InputLabel.BackgroundTransparency = 1
                InputLabel.TextSize = 13 * scale
                InputLabel.Font = Enum.Font.GothamBlack
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InnerFrame
                
                -- Value display (untuk input type tertentu)
                local ValueDisplay = Instance.new("TextLabel")
                ValueDisplay.Name = "ValueDisplay"
                ValueDisplay.Size = UDim2.new(0.4, -10, 0, 22 * scale)
                ValueDisplay.Position = UDim2.new(0.6, 0, 0, 8 * scale)
                ValueDisplay.Text = opts.DefaultValue or ""
                ValueDisplay.TextColor3 = theme.Accent
                ValueDisplay.BackgroundTransparency = 1
                ValueDisplay.TextSize = 13 * scale
                ValueDisplay.Font = Enum.Font.GothamBlack
                ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
                ValueDisplay.Visible = opts.InputType == "number" or opts.InputType == "slider"
                ValueDisplay.Parent = InnerFrame
                
                -- Input field
                local InputBox = Instance.new("TextBox")
                InputBox.Name = "InputBox"
                InputBox.Size = UDim2.new(1, -26, 0, 34 * scale)
                InputBox.Position = UDim2.new(0, 13 * scale, 0, 34 * scale)
                InputBox.Text = opts.DefaultValue or ""
                InputBox.PlaceholderText = opts.PlaceholderText or "Masukkan nilai..."
                InputBox.PlaceholderColor3 = theme.TextMuted
                InputBox.TextColor3 = theme.Text
                InputBox.BackgroundColor3 = theme.InputBg
                InputBox.BackgroundTransparency = 0
                InputBox.TextSize = 13 * scale
                InputBox.Font = Enum.Font.Gotham
                InputBox.TextXAlignment = Enum.TextXAlignment.Left
                InputBox.ClearTextOnFocus = false
                InputBox.Parent = InnerFrame
                
                local InputBoxCorner = Instance.new("UICorner")
                InputBoxCorner.CornerRadius = UDim.new(0, 6 * scale)
                InputBoxCorner.Parent = InputBox
                
                -- Efek glow
                local InputGlow = createGlow(InputBox, theme.AccentGlow, UDim2.new(1, 8, 1, 8))
                InputGlow.ImageTransparency = 1
                
                -- Unit label (untuk number input)
                local UnitLabel = Instance.new("TextLabel")
                UnitLabel.Name = "UnitLabel"
                UnitLabel.Size = UDim2.new(0, 30, 0, 34)
                UnitLabel.Position = UDim2.new(1, -40, 0, 34)
                UnitLabel.Text = opts.Unit or ""
                UnitLabel.TextColor3 = theme.Accent
                UnitLabel.BackgroundTransparency = 1
                UnitLabel.TextSize = 12 * scale
                UnitLabel.Font = Enum.Font.Gotham
                UnitLabel.Visible = opts.Unit and true or false
                UnitLabel.Parent = InnerFrame
                
                -- Increment buttons (untuk number input)
                local IncrementFrame = Instance.new("Frame")
                IncrementFrame.Name = "IncrementFrame"
                IncrementFrame.Size = UDim2.new(0, 60, 0, 34)
                IncrementFrame.Position = UDim2.new(1, -70, 0, 34)
                IncrementFrame.BackgroundTransparency = 1
                IncrementFrame.Visible = opts.InputType == "number" and opts.ShowControls ~= false
                IncrementFrame.Parent = InnerFrame
                
                if IncrementFrame.Visible then
                    -- Plus button
                    local PlusButton = Instance.new("TextButton")
                    PlusButton.Name = "PlusButton"
                    PlusButton.Size = UDim2.new(0.5, -1, 1, 0)
                    PlusButton.Position = UDim2.new(0.5, 1, 0, 0)
                    PlusButton.Text = "+"
                    PlusButton.TextColor3 = theme.Text
                    PlusButton.BackgroundColor3 = theme.Button
                    PlusButton.BackgroundTransparency = 0
                    PlusButton.TextSize = 16 * scale
                    PlusButton.Font = Enum.Font.Gotham
                    PlusButton.AutoButtonColor = false
                    PlusButton.Parent = IncrementFrame
                    
                    local PlusCorner = Instance.new("UICorner")
                    PlusCorner.CornerRadius = UDim.new(0, 6 * scale)
                    PlusCorner.Parent = PlusButton
                    
                    -- Minus button
                    local MinusButton = Instance.new("TextButton")
                    MinusButton.Name = "MinusButton"
                    MinusButton.Size = UDim2.new(0.5, -1, 1, 0)
                    MinusButton.Position = UDim2.new(0, 0, 0, 0)
                    MinusButton.Text = "-"
                    MinusButton.TextColor3 = theme.Text
                    MinusButton.BackgroundColor3 = theme.Button
                    MinusButton.BackgroundTransparency = 0
                    MinusButton.TextSize = 16 * scale
                    MinusButton.Font = Enum.Font.Gotham
                    MinusButton.AutoButtonColor = false
                    MinusButton.Parent = IncrementFrame
                    
                    local MinusCorner = Instance.new("UICorner")
                    MinusCorner.CornerRadius = UDim.new(0, 6 * scale)
                    MinusCorner.Parent = MinusButton
                    
                    -- Adjust InputBox size
                    InputBox.Size = UDim2.new(1, -90, 0, 34)
                    
                    -- Variables
                    local minValue = opts.Min or -math.huge
                    local maxValue = opts.Max or math.huge
                    local step = opts.Step or 1
                    
                    -- Plus button click
                    PlusButton.MouseButton1Click:Connect(function()
                        local currentValue = tonumber(InputBox.Text) or 0
                        local newValue = math.min(currentValue + step, maxValue)
                        InputBox.Text = tostring(newValue)
                        ValueDisplay.Text = tostring(newValue)
                        
                        if opts.Callback then
                            pcall(opts.Callback, newValue)
                        end
                    end)
                    
                    -- Minus button click
                    MinusButton.MouseButton1Click:Connect(function()
                        local currentValue = tonumber(InputBox.Text) or 0
                        local newValue = math.max(currentValue - step, minValue)
                        InputBox.Text = tostring(newValue)
                        ValueDisplay.Text = tostring(newValue)
                        
                        if opts.Callback then
                            pcall(opts.Callback, newValue)
                        end
                    end)
                    
                    -- Hover effects
                    PlusButton.MouseEnter:Connect(function()
                        tween(PlusButton, {BackgroundColor3 = theme.ButtonHover}, 0.15)
                    end)
                    
                    PlusButton.MouseLeave:Connect(function()
                        tween(PlusButton, {BackgroundColor3 = theme.Button}, 0.15)
                    end)
                    
                    MinusButton.MouseEnter:Connect(function()
                        tween(MinusButton, {BackgroundColor3 = theme.ButtonHover}, 0.15)
                    end)
                    
                    MinusButton.MouseLeave:Connect(function()
                        tween(MinusButton, {BackgroundColor3 = theme.Button}, 0.15)
                    end)
                end
                
                -- Focus events
                InputBox.Focused:Connect(function()
                    tween(InputBox, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                    tween(InputFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    tween(InputGlow, {ImageTransparency = 0.5}, 0.15)
                end)
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    tween(InputBox, {BackgroundColor3 = theme.InputBg}, 0.15)
                    tween(InputFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                    tween(InputGlow, {ImageTransparency = 1}, 0.15)
                    
                    -- Validation based on input type
                    if opts.InputType == "number" then
                        local numValue = tonumber(InputBox.Text)
                        if numValue then
                            if opts.Min and numValue < opts.Min then
                                numValue = opts.Min
                            end
                            if opts.Max and numValue > opts.Max then
                                numValue = opts.Max
                            end
                            InputBox.Text = tostring(numValue)
                            ValueDisplay.Text = tostring(numValue)
                        else
                            InputBox.Text = opts.DefaultValue or "0"
                            ValueDisplay.Text = opts.DefaultValue or "0"
                        end
                    end
                    
                    if opts.Callback then
                        pcall(opts.Callback, InputBox.Text, enterPressed)
                    end
                end)
                
                -- Text changed
                InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if opts.InputType == "number" then
                        -- Filter hanya angka
                        InputBox.Text = InputBox.Text:gsub("[^0-9.-]", "")
                    end
                    
                    ValueDisplay.Text = InputBox.Text
                    
                    if opts.LiveUpdate and opts.Callback then
                        pcall(opts.Callback, InputBox.Text, false)
                    end
                end)
                
                -- Hover effect on frame
                InputFrame.MouseEnter:Connect(function()
                    if not isMobile and not InputBox:IsFocused() then
                        tween(InputFrame, {BackgroundColor3 = theme.ContentBgLight}, 0.15)
                    end
                end)
                
                InputFrame.MouseLeave:Connect(function()
                    if not isMobile and not InputBox:IsFocused() then
                        tween(InputFrame, {BackgroundColor3 = theme.ContentCard}, 0.15)
                    end
                end)
                
                table.insert(self.Elements, InputFrame)
                
                return {
                    Frame = InputFrame,
                    InputBox = InputBox,
                    GetValue = function() return InputBox.Text end,
                    SetValue = function(value)
                        InputBox.Text = tostring(value)
                        ValueDisplay.Text = tostring(value)
                    end,
                    GetNumber = function()
                        return tonumber(InputBox.Text) or 0
                    end,
                    Clear = function()
                        InputBox.Text = ""
                    end,
                    Focus = function()
                        InputBox:CaptureFocus()
                    end
                }
            end,
        }
        
        self.Tabs[tabName] = tabObj
        
        if #self.Tabs == 1 then
            TabButton.BackgroundColor3 = theme.TabActive
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            TabContent.Visible = true
            self.ActiveTab = tabName
        end
        
        return tabObj
    end
    
    -- ===== MINIMIZE FUNCTIONALITY =====
    local originalSize = windowData.Size
    local isMinimized = false
    
    -- Minimized icon dengan huruf B TANPA BACKGROUND
    local MinimizedIcon = Instance.new("TextButton")
    MinimizedIcon.Name = "MinimizedIcon_Bee"
    MinimizedIcon.Size = UDim2.new(0, 48 * scale, 0, 48 * scale)
    MinimizedIcon.Position = UDim2.new(0, 20, 0, 20)
    MinimizedIcon.Text = "B"
    MinimizedIcon.TextColor3 = theme.Accent
    MinimizedIcon.BackgroundTransparency = 1
    MinimizedIcon.TextSize = 32 * scale
    MinimizedIcon.Font = Enum.Font.GothamBlack
    MinimizedIcon.Visible = false
    MinimizedIcon.Parent = self.ScreenGui
    
    self.MinimizedIcons[windowData.Name] = {
        Icon = MinimizedIcon,
        UpdateTheme = function(self, newTheme)
            MinimizedIcon.TextColor3 = newTheme.Accent
        end
    }
    
    local function setMinimized(minimize)
        isMinimized = minimize
        windowObj.IsMinimized = minimize
        
        if minimize then
            local windowPos = MainFrame.Position
            
            tween(MainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = windowPos
            }, 0.2)
            
            task.wait(0.15)
            MainFrame.Visible = false
            
            MinimizedIcon.Position = UDim2.new(
                windowPos.X.Scale,
                windowPos.X.Offset,
                windowPos.Y.Scale,
                windowPos.Y.Offset
            )
            MinimizedIcon.Visible = true
            MinimizedIcon.Size = UDim2.new(0, 0, 0, 0)
            tween(MinimizedIcon, {Size = UDim2.new(0, 48 * scale, 0, 48 * scale)}, 0.2, Enum.EasingStyle.Back)
            
            MinimizeButton.Text = "◉"
        else
            tween(MinimizedIcon, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
            task.wait(0.1)
            MinimizedIcon.Visible = false
            
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            tween(MainFrame, {Size = originalSize}, 0.2, Enum.EasingStyle.Back)
            
            MinimizeButton.Text = "—"
        end
    end
    
    MinimizeButton.MouseButton1Click:Connect(function()
        setMinimized(not isMinimized)
    end)
    
    MinimizedIcon.MouseButton1Click:Connect(function()
        setMinimized(false)
    end)
    
    -- Dragging untuk icon
    local iconDragging = false
    local iconDragStart, iconStartPos
    
    MinimizedIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            iconDragging = true
            iconDragStart = input.Position
            iconStartPos = MinimizedIcon.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if iconDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - iconDragStart
            MinimizedIcon.Position = UDim2.new(
                iconStartPos.X.Scale,
                iconStartPos.X.Offset + delta.X,
                iconStartPos.Y.Scale,
                iconStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and iconDragging then
            iconDragging = false
        end
    end)
    
    -- Close button
    CloseButton.MouseButton1Click:Connect(function()
        if isMinimized then
            tween(MinimizedIcon, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
            task.wait(0.15)
            MinimizedIcon.Visible = false
        else
            tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            MainFrame.Visible = false
        end
    end)
    
    -- Dragging window
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
        end
    end)
    
    --print("✅ Created Bee Futuristic Edition window!")
    return windowObj
end

-- Tambahkan method cleanup
function SimpleGUI:Destroy()
    for _, window in pairs(self.Windows) do
        if window.Destroy then
            window:Destroy()
        end
    end
    
    for _, icon in pairs(self.MinimizedIcons) do
        if icon.Icon then
            icon.Icon:Destroy()
        end
    end
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Windows = {}
    self.MinimizedIcons = {}
end

-- Tambahkan method penggantian tema
function SimpleGUI:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        local theme = self:GetTheme()
        
        for _, window in pairs(self.Windows) do
            if window.UpdateTheme then
                window:UpdateTheme(theme)
            end
        end
        
        for _, icon in pairs(self.MinimizedIcons) do
            if icon.UpdateTheme then
                icon:UpdateTheme(theme)
            end
        end
    end
end

-- Tambahkan method untuk mendapatkan versi
function SimpleGUI:GetVersion()
    return "8.0 - Bee Futuristic Edition"
end

--print("🎉 SimpleGUI v8.0 - Bee Futuristic Edition loaded!")
return SimpleGUI