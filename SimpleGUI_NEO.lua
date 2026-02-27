-- ==============================================
-- 🎨 SIMPLEGUI v8.0 - Bee FUTURISTIC EDITION
-- ==============================================

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
        
        Primary = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 40, 40),
        AccentDark = Color3.fromRGB(180, 20, 20),
        AccentGlow = Color3.fromRGB(255, 60, 60),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 210),
        TextMuted = Color3.fromRGB(140, 140, 150),
        TextGlow = Color3.fromRGB(255, 80, 80),
        
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 40, 40),
        
        Border = Color3.fromRGB(40, 40, 45),
        BorderLight = Color3.fromRGB(70, 70, 80),
        BorderRed = Color3.fromRGB(255, 40, 40),
        
        Hover = Color3.fromRGB(255, 40, 40, 0.2),
        Active = Color3.fromRGB(255, 40, 40),
        
        WindowBg = Color3.fromRGB(5, 5, 8),
        TitleBar = Color3.fromRGB(12, 12, 15),
        TitleBarGlow = Color3.fromRGB(255, 40, 40, 0.2),
        
        TabNormal = Color3.fromRGB(18, 18, 22),
        TabActive = Color3.fromRGB(255, 40, 40),
        TabHover = Color3.fromRGB(35, 35, 45),
        
        ContentBg = Color3.fromRGB(8, 8, 12),
        ContentBgLight = Color3.fromRGB(15, 15, 20),
        ContentCard = Color3.fromRGB(20, 20, 25),
        
        Button = Color3.fromRGB(25, 25, 32),
        ButtonHover = Color3.fromRGB(45, 45, 55),
        ButtonGlow = Color3.fromRGB(255, 40, 40, 0.15),
        
        InputBg = Color3.fromRGB(18, 18, 25),
        InputBgFocus = Color3.fromRGB(28, 28, 38),
        InputBorder = Color3.fromRGB(255, 40, 40, 0.3),
        
        ToggleOff = Color3.fromRGB(50, 50, 60),
        ToggleOn = Color3.fromRGB(255, 40, 40),
        ToggleCircle = Color3.fromRGB(255, 255, 255),
        
        SliderTrack = Color3.fromRGB(30, 30, 38),
        SliderFill = Color3.fromRGB(255, 40, 40),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        
        Sidebar = Color3.fromRGB(10, 10, 15),
        SidebarGlow = Color3.fromRGB(255, 40, 40, 0.1),
        
        Overlay = Color3.fromRGB(0, 0, 0, 0.7),
        Glow = Color3.fromRGB(255, 40, 40, 0.25),
        Scanline = Color3.fromRGB(255, 40, 40, 0.05),
        Gradient1 = Color3.fromRGB(255, 20, 20),
        Gradient2 = Color3.fromRGB(180, 10, 10)
    }
}

function SimpleGUI.new()
    local self = setmetatable({}, SimpleGUI)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BeeHub_" .. math.random(1000, 9999)
    self.ScreenGui.DisplayOrder = 99999
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    
    local success = pcall(function()
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self.Windows = {}
    self.CurrentTheme = "Bee"
    self.MinimizedIcons = {}
    self.Notifications = {}
    self.Modals = {}
    
    return self
end

function SimpleGUI:GetTheme()
    return self.Themes[self.CurrentTheme]
end

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

local function createGlow(parent, color, size)
    -- Validasi parent
    if not parent or typeof(parent) ~= "Instance" then
        warn("createGlow: parent tidak valid")
        return nil
    end
    
    -- Validasi size
    local glowSize = size
    if typeof(glowSize) ~= "UDim2" then
        glowSize = UDim2.new(1, 20, 1, 20)  -- default size
    end
    
    -- Validasi color
    local glowColor = color
    if typeof(glowColor) ~= "Color3" then
        glowColor = Color3.fromRGB(255, 40, 40)
    end
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = glowSize
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://13110549987"
    glow.ImageColor3 = glowColor
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 10, 10)
    glow.ZIndex = -1
    
    -- Safe parenting
    local success = pcall(function()
        glow.Parent = parent
    end)
    
    if not success then
        glow:Destroy()
        return nil
    end
    
    return glow
end

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
        Logo = "B",
        MinSize = opts.MinSize or UDim2.new(0, 400 * scale, 0, 300 * scale),
        MaxSize = opts.MaxSize or UDim2.new(0, 1200 * scale, 0, 800 * scale)
    }
    
    local theme = self:GetTheme()
    
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
    
    local WindowGlow = createGlow(MainFrame, theme.AccentGlow, UDim2.new(1, 25, 1, 25))
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 10 * scale)
    WindowCorner.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 52 * scale)
    TitleBar.BackgroundColor3 = theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 10 * scale)
    TitleBarCorner.Parent = TitleBar
    
    local TitleBarLine = Instance.new("Frame")
    TitleBarLine.Name = "TitleBarLine"
    TitleBarLine.Size = UDim2.new(1, 0, 0, 2)
    TitleBarLine.Position = UDim2.new(0, 0, 1, -2)
    TitleBarLine.BackgroundColor3 = theme.Accent
    TitleBarLine.BackgroundTransparency = 0.3
    TitleBarLine.BorderSizePixel = 0
    TitleBarLine.Parent = TitleBar
    
    local LineGlow = Instance.new("Frame")
    LineGlow.Name = "LineGlow"
    LineGlow.Size = UDim2.new(1, 0, 0, 4)
    LineGlow.Position = UDim2.new(0, 0, 1, -4)
    LineGlow.BackgroundColor3 = theme.AccentGlow
    LineGlow.BackgroundTransparency = 0.7
    LineGlow.BorderSizePixel = 0
    LineGlow.Parent = TitleBar
    
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(0.6, 0, 1, 0)
    TitleContainer.Position = UDim2.new(0, 12 * scale, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = TitleBar
    
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
    
    local TitleTextFrame = Instance.new("Frame")
    TitleTextFrame.Name = "TitleTextFrame"
    TitleTextFrame.Size = UDim2.new(1, -48 * scale, 1, 0)
    TitleTextFrame.Position = UDim2.new(0, 48 * scale, 0, 0)
    TitleTextFrame.BackgroundTransparency = 1
    TitleTextFrame.Parent = TitleContainer
    
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
    
    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitle"
    SubTitleLabel.Size = UDim2.new(1, 0, 0.5, -2)
    SubTitleLabel.Position = UDim2.new(0, 0, 0.5, 2)
    SubTitleLabel.Text = windowData.SubName
    SubTitleLabel.TextColor3 = theme.Accent
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.TextSize = 11 * scale
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleTextFrame
    
    local buttonSize = 32 * scale
    local buttonSpacing = 6 * scale
    
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
    
    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Name = "SidebarBorder"
    SidebarBorder.Size = UDim2.new(0, 2, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -2, 0, 0)
    SidebarBorder.BackgroundColor3 = theme.Accent
    SidebarBorder.BackgroundTransparency = 0.5
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar
    
    local BorderGlow = Instance.new("Frame")
    BorderGlow.Name = "BorderGlow"
    BorderGlow.Size = UDim2.new(0, 4, 1, 0)
    BorderGlow.Position = UDim2.new(1, -4, 0, 0)
    BorderGlow.BackgroundColor3 = theme.AccentGlow
    BorderGlow.BackgroundTransparency = 0.7
    BorderGlow.BorderSizePixel = 0
    BorderGlow.Parent = Sidebar
    
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
    HeaderLabel.TextColor3 = theme.Accent
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.TextSize = 14 * scale
    HeaderLabel.Font = Enum.Font.GothamBlack
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = SidebarHeader
    
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
        HeaderTitle.TextColor3 = theme.Accent
        HeaderTitle.BackgroundTransparency = 1
        HeaderTitle.TextSize = 15 * scale
        HeaderTitle.Font = Enum.Font.GothamBlack
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
    
    local windowObj = {
        MainFrame = MainFrame,
        TitleBar = TitleBar,
        TitleLabel = TitleLabel,
        Sidebar = Sidebar,
        ContentFrame = ContentFrame,
        Tabs = {},
        TabGroups = {},
        ActiveTab = nil,
        WindowData = windowData,
        IsMinimized = false,
        ResizeHandle = nil,
        
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
                        tabData.Button.TextColor3 = Color3.new(1, 1, 1)
                    end
                end
                
                if tabData.UpdateTheme then
                    tabData:UpdateTheme(newTheme)
                end
            end
            
            for _, group in pairs(self.TabGroups) do
                if group.UpdateTheme then
                    group:UpdateTheme(newTheme)
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
    
    -- RESIZE HANDLE
    do
        local ResizeHandle = Instance.new("TextButton")
        ResizeHandle.Name = "ResizeHandle"
        ResizeHandle.Size = UDim2.new(0, 20 * scale, 0, 20 * scale)
        ResizeHandle.Position = UDim2.new(1, -20 * scale, 1, -20 * scale)
        ResizeHandle.Text = "◢"
        ResizeHandle.TextColor3 = theme.Accent
        ResizeHandle.BackgroundTransparency = 1
        ResizeHandle.TextSize = 16 * scale
        ResizeHandle.Font = Enum.Font.Gotham
        ResizeHandle.ZIndex = 10
        ResizeHandle.Parent = MainFrame
        
        local isResizing = false
        local resizeStartPos
        local resizeStartSize
        
        ResizeHandle.MouseButton1Down:Connect(function(input)
            isResizing = true
            resizeStartPos = input.Position
            resizeStartSize = MainFrame.Size
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - resizeStartPos
                local newWidth = math.clamp(
                    resizeStartSize.X.Offset + delta.X,
                    windowData.MinSize.X.Offset,
                    windowData.MaxSize.X.Offset
                )
                local newHeight = math.clamp(
                    resizeStartSize.Y.Offset + delta.Y,
                    windowData.MinSize.Y.Offset,
                    windowData.MaxSize.Y.Offset
                )
                
                MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and isResizing then
                isResizing = false
            end
        end)
        
        windowObj.ResizeHandle = ResizeHandle
    end
    
    -- TAB CREATION
    function windowObj:CreateTab(options)
        local tabOptions = type(options) == "string" and {Name = options} or (options or {})
        local tabName = tabOptions.Name or "Tab_" .. (#self.Tabs + 1)
        local icon = tabOptions.Icon or "●"
        local scale = self.WindowData.Scale
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "_Button"
        TabButton.Size = UDim2.new(1, -16 * scale, 0, 42 * scale)
        TabButton.Text = icon .. "  " .. tabName
        TabButton.TextColor3 = theme.TextSecondary
        TabButton.BackgroundColor3 = theme.TabNormal
        TabButton.BackgroundTransparency = 0
        TabButton.TextSize = 13 * scale
        TabButton.Font = Enum.Font.GothamBlack
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        TabButton.LayoutOrder = #self.Tabs + 1
        TabButton.Parent = SidebarContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8 * scale)
        TabButtonCorner.Parent = TabButton
        
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
        
        TabButton.MouseButton1Click:Connect(function()
            for name, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tween(tab.Button, {BackgroundColor3 = theme.TabNormal}, 0.15)
                tab.Button.TextColor3 = theme.TextSecondary
            end
            
            TabContent.Visible = true
            tween(TabButton, {BackgroundColor3 = theme.TabActive}, 0.15)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            self.ActiveTab = tabName
        end)
        
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
        
        local tabObj = {
            Button = TabButton,
            Content = TabContent,
            Elements = {},
            ElementObjects = {},
            TabGroups = {},
            
            UpdateTheme = function(self, newTheme)
                TabButton.BackgroundColor3 = newTheme.TabNormal
                TabButton.TextColor3 = newTheme.TextSecondary
                
                if windowObj.ActiveTab == tabName then
                    TabButton.BackgroundColor3 = newTheme.TabActive
                    TabButton.TextColor3 = Color3.new(1, 1, 1)
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
                Button.Font = Enum.Font.GothamBlack
                Button.AutoButtonColor = false
                Button.LayoutOrder = #self.Elements + 1
                Button.Parent = TabContent
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 8 * scale)
                Corner.Parent = Button
                
                local ButtonGlow = createGlow(Button, theme.AccentGlow, UDim2.new(1, 10, 1, 10))
                ButtonGlow.ImageTransparency = 1
                
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
                Label.Font = Enum.Font.GothamBlack
                Label.TextXAlignment = opts.Alignment or Enum.TextXAlignment.Left
                Label.LayoutOrder = #self.Elements + 1
                Label.Parent = TabContent
                
                table.insert(self.Elements, Label)
                return Label
            end,
            
            CreateToggle = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = opts.Name or "Toggle_" .. #self.Elements + 1
                ToggleFrame.Size = UDim2.new(0.95, 0, 0, 46 * scale)
                ToggleFrame.BackgroundColor3 = theme.ContentCard
                ToggleFrame.BackgroundTransparency = 0
                ToggleFrame.BorderSizePixel = 2
                ToggleFrame.BorderColor3 = theme.BorderLight
                ToggleFrame.LayoutOrder = #self.Elements + 1
                ToggleFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = ToggleFrame
                
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = ToggleFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                local FrameGlow = createGlow(ToggleFrame, theme.AccentGlow, UDim2.new(1, 8, 1, 8))
                FrameGlow.ImageTransparency = 0.9
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 13 * scale, 0, 0)
                ToggleLabel.Text = opts.Text or opts.Name or "Toggle"
                ToggleLabel.TextColor3 = theme.Text
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.TextSize = 13 * scale
                ToggleLabel.Font = Enum.Font.GothamBlack
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = InnerFrame
                
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
                
                local ToggleGlow = createGlow(ToggleContainer, theme.AccentGlow, UDim2.new(1, 10, 1, 10))
                ToggleGlow.ImageTransparency = 1
                
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
                
                ToggleLabel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        toggle()
                    end
                end)
                
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
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Size = UDim2.new(1, -50, 0, 22 * scale)
                SliderLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                SliderLabel.Text = opts.Name or "Slider"
                SliderLabel.TextColor3 = theme.Text
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.TextSize = 13 * scale
                SliderLabel.Font = Enum.Font.GothamBlack
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = InnerFrame
                
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
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "DropdownLabel"
                DropdownLabel.Size = UDim2.new(0.4, 0, 0, 22 * scale)
                DropdownLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                DropdownLabel.Text = opts.Text or opts.Name or "Dropdown"
                DropdownLabel.TextColor3 = theme.Text
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.TextSize = 13 * scale
                DropdownLabel.Font = Enum.Font.GothamBlack
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = InnerFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Size = UDim2.new(0.55, -20, 0, 34 * scale)
                DropdownButton.Position = UDim2.new(0.45, 10, 0, 8 * scale)
                DropdownButton.Text = opts.Default or (opts.Options and #opts.Options > 0 and opts.Options[1]) or "Pilih opsi"
                DropdownButton.TextColor3 = theme.Text
                DropdownButton.BackgroundColor3 = theme.InputBg
                DropdownButton.BackgroundTransparency = 0
                DropdownButton.TextSize = 13 * scale
                DropdownButton.Font = Enum.Font.GothamBlack
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = InnerFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6 * scale)
                ButtonCorner.Parent = DropdownButton
                
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
                        ItemButton.Font = Enum.Font.Gotham
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
            
            CreateTextBox = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Name = opts.Name or "TextBox_" .. #self.Elements + 1
                TextBoxFrame.Size = UDim2.new(0.95, 0, 0, 75 * scale)
                TextBoxFrame.BackgroundColor3 = theme.ContentCard
                TextBoxFrame.BackgroundTransparency = 0
                TextBoxFrame.BorderSizePixel = 2
                TextBoxFrame.BorderColor3 = theme.BorderLight
                TextBoxFrame.LayoutOrder = #self.Elements + 1
                TextBoxFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = TextBoxFrame
                
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
                
                local TextBoxGlow = createGlow(TextBox, theme.AccentGlow, UDim2.new(1, 8, 1, 8))
                TextBoxGlow.ImageTransparency = 1
                
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
                
                local maxLength = opts.MaxLength or 0
                local textValue = opts.DefaultText or ""
                
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
                
                ClearButton.MouseButton1Click:Connect(function()
                    TextBox.Text = ""
                    TextBox:CaptureFocus()
                end)
                
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
            
            CreateInput = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = opts.Name or "Input_" .. #self.Elements + 1
                InputFrame.Size = UDim2.new(0.95, 0, 0, 85 * scale)
                InputFrame.BackgroundColor3 = theme.ContentCard
                InputFrame.BackgroundTransparency = 0
                InputFrame.BorderSizePixel = 2
                InputFrame.BorderColor3 = theme.BorderLight
                InputFrame.LayoutOrder = #self.Elements + 1
                InputFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = InputFrame
                
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
                
                local InputGlow = createGlow(InputBox, theme.AccentGlow, UDim2.new(1, 8, 1, 8))
                InputGlow.ImageTransparency = 1
                
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
                
                local IncrementFrame = Instance.new("Frame")
                IncrementFrame.Name = "IncrementFrame"
                IncrementFrame.Size = UDim2.new(0, 60, 0, 34)
                IncrementFrame.Position = UDim2.new(1, -70, 0, 34)
                IncrementFrame.BackgroundTransparency = 1
                IncrementFrame.Visible = opts.InputType == "number" and opts.ShowControls ~= false
                IncrementFrame.Parent = InnerFrame
                
                if IncrementFrame.Visible then
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
                    
                    InputBox.Size = UDim2.new(1, -90, 0, 34)
                    
                    local minValue = opts.Min or -math.huge
                    local maxValue = opts.Max or math.huge
                    local step = opts.Step or 1
                    
                    PlusButton.MouseButton1Click:Connect(function()
                        local currentValue = tonumber(InputBox.Text) or 0
                        local newValue = math.min(currentValue + step, maxValue)
                        InputBox.Text = tostring(newValue)
                        ValueDisplay.Text = tostring(newValue)
                        
                        if opts.Callback then
                            pcall(opts.Callback, newValue)
                        end
                    end)
                    
                    MinusButton.MouseButton1Click:Connect(function()
                        local currentValue = tonumber(InputBox.Text) or 0
                        local newValue = math.max(currentValue - step, minValue)
                        InputBox.Text = tostring(newValue)
                        ValueDisplay.Text = tostring(newValue)
                        
                        if opts.Callback then
                            pcall(opts.Callback, newValue)
                        end
                    end)
                    
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
                
                InputBox.Focused:Connect(function()
                    tween(InputBox, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                    tween(InputFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    tween(InputGlow, {ImageTransparency = 0.5}, 0.15)
                end)
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    tween(InputBox, {BackgroundColor3 = theme.InputBg}, 0.15)
                    tween(InputFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                    tween(InputGlow, {ImageTransparency = 1}, 0.15)
                    
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
                
                InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if opts.InputType == "number" then
                        InputBox.Text = InputBox.Text:gsub("[^0-9.-]", "")
                    end
                    
                    ValueDisplay.Text = InputBox.Text
                    
                    if opts.LiveUpdate and opts.Callback then
                        pcall(opts.Callback, InputBox.Text, false)
                    end
                end)
                
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
            
            -- ===== CREATE KEYBIND =====
            CreateKeybind = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Name = opts.Name or "Keybind_" .. #self.Elements + 1
                KeybindFrame.Size = UDim2.new(0.95, 0, 0, 46 * scale)
                KeybindFrame.BackgroundColor3 = theme.ContentCard
                KeybindFrame.BackgroundTransparency = 0
                KeybindFrame.BorderSizePixel = 2
                KeybindFrame.BorderColor3 = theme.BorderLight
                KeybindFrame.LayoutOrder = #self.Elements + 1
                KeybindFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = KeybindFrame
                
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = KeybindFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "KeybindLabel"
                KeybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
                KeybindLabel.Position = UDim2.new(0, 13 * scale, 0, 0)
                KeybindLabel.Text = opts.Text or opts.Name or "Keybind"
                KeybindLabel.TextColor3 = theme.Text
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.TextSize = 13 * scale
                KeybindLabel.Font = Enum.Font.GothamBlack
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = InnerFrame
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "KeybindButton"
                KeybindButton.Size = UDim2.new(0, 80 * scale, 0, 30 * scale)
                KeybindButton.Position = UDim2.new(1, -93 * scale, 0.5, -15 * scale)
                KeybindButton.Text = opts.Default or "None"
                KeybindButton.TextColor3 = theme.Text
                KeybindButton.BackgroundColor3 = theme.InputBg
                KeybindButton.BackgroundTransparency = 0
                KeybindButton.TextSize = 12 * scale
                KeybindButton.Font = Enum.Font.GothamBlack
                KeybindButton.AutoButtonColor = false
                KeybindButton.Parent = InnerFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6 * scale)
                ButtonCorner.Parent = KeybindButton
                
                local ClearButton = Instance.new("TextButton")
                ClearButton.Name = "ClearButton"
                ClearButton.Size = UDim2.new(0, 20 * scale, 0, 20 * scale)
                ClearButton.Position = UDim2.new(1, -28 * scale, 0.5, -10 * scale)
                ClearButton.Text = "✕"
                ClearButton.TextColor3 = theme.TextMuted
                ClearButton.BackgroundTransparency = 1
                ClearButton.TextSize = 14 * scale
                ClearButton.Font = Enum.Font.Gotham
                ClearButton.Visible = opts.Default and opts.Default ~= "None"
                ClearButton.Parent = InnerFrame
                
                local isBinding = false
                local currentKey = opts.Default or "None"
                
                local keyCodeMap = {
                    [Enum.KeyCode.LeftShift] = "LShift",
                    [Enum.KeyCode.RightShift] = "RShift",
                    [Enum.KeyCode.LeftControl] = "LCtrl",
                    [Enum.KeyCode.RightControl] = "RCtrl",
                    [Enum.KeyCode.LeftAlt] = "LAlt",
                    [Enum.KeyCode.RightAlt] = "RAlt",
                    [Enum.KeyCode.Backspace] = "Bksp",
                    [Enum.KeyCode.Return] = "Enter",
                    [Enum.KeyCode.Space] = "Space",
                    [Enum.KeyCode.Tab] = "Tab",
                    [Enum.KeyCode.Escape] = "Esc",
                    [Enum.KeyCode.Insert] = "Ins",
                    [Enum.KeyCode.Delete] = "Del",
                    [Enum.KeyCode.Home] = "Home",
                    [Enum.KeyCode.End] = "End",
                    [Enum.KeyCode.PageUp] = "PgUp",
                    [Enum.KeyCode.PageDown] = "PgDn",
                }
                
                local function getKeyName(input)
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        return keyCodeMap[input.KeyCode] or input.KeyCode.Name
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        return "Mouse1"
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        return "Mouse2"
                    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                        return "Mouse3"
                    end
                    return nil
                end
                
                local function updateButton()
                    if isBinding then
                        KeybindButton.Text = "..."
                        KeybindButton.TextColor3 = theme.Accent
                        tween(KeybindButton, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                        tween(KeybindFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    else
                        KeybindButton.Text = currentKey
                        KeybindButton.TextColor3 = theme.Text
                        tween(KeybindButton, {BackgroundColor3 = theme.InputBg}, 0.15)
                        tween(KeybindFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                    end
                    ClearButton.Visible = not isBinding and currentKey ~= "None"
                end
                
                local function onInputBegan(input)
                    if not isBinding then return end
                    
                    local keyName = getKeyName(input)
                    if keyName and keyName ~= "Unknown" then
                        isBinding = false
                        currentKey = keyName
                        updateButton()
                        
                        if opts.Callback then
                            pcall(opts.Callback, keyName)
                        end
                    end
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    isBinding = true
                    updateButton()
                end)
                
                ClearButton.MouseButton1Click:Connect(function()
                    currentKey = "None"
                    updateButton()
                    if opts.Callback then
                        pcall(opts.Callback, nil)
                    end
                end)
                
                UserInputService.InputBegan:Connect(onInputBegan)
                
                KeybindFrame.MouseEnter:Connect(function()
                    if not isMobile and not isBinding then
                        tween(KeybindFrame, {BackgroundColor3 = theme.ContentBgLight}, 0.15)
                    end
                end)
                
                KeybindFrame.MouseLeave:Connect(function()
                    if not isMobile and not isBinding then
                        tween(KeybindFrame, {BackgroundColor3 = theme.ContentCard}, 0.15)
                    end
                end)
                
                table.insert(self.Elements, KeybindFrame)
                
                return {
                    Frame = KeybindFrame,
                    GetKey = function() return currentKey end,
                    SetKey = function(key)
                        currentKey = key
                        updateButton()
                    end,
                    IsBinding = function() return isBinding end,
                    StartBinding = function()
                        isBinding = true
                        updateButton()
                    end,
                    StopBinding = function()
                        isBinding = false
                        updateButton()
                    end
                }
            end,
            
            -- ===== CREATE COLOR PICKER =====
            CreateColorPicker = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local ColorFrame = Instance.new("Frame")
                ColorFrame.Name = opts.Name or "ColorPicker_" .. #self.Elements + 1
                ColorFrame.Size = UDim2.new(0.95, 0, 0, 120 * scale)
                ColorFrame.BackgroundColor3 = theme.ContentCard
                ColorFrame.BackgroundTransparency = 0
                ColorFrame.BorderSizePixel = 2
                ColorFrame.BorderColor3 = theme.BorderLight
                ColorFrame.LayoutOrder = #self.Elements + 1
                ColorFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = ColorFrame
                
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = ColorFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                local ColorLabel = Instance.new("TextLabel")
                ColorLabel.Name = "ColorLabel"
                ColorLabel.Size = UDim2.new(1, -100, 0, 22 * scale)
                ColorLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                ColorLabel.Text = opts.Text or opts.Name or "Color Picker"
                ColorLabel.TextColor3 = theme.Text
                ColorLabel.BackgroundTransparency = 1
                ColorLabel.TextSize = 13 * scale
                ColorLabel.Font = Enum.Font.GothamBlack
                ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorLabel.Parent = InnerFrame
                
                local ColorPreview = Instance.new("Frame")
                ColorPreview.Name = "ColorPreview"
                ColorPreview.Size = UDim2.new(0, 30 * scale, 0, 22 * scale)
                ColorPreview.Position = UDim2.new(1, -43 * scale, 0, 8 * scale)
                ColorPreview.BackgroundColor3 = opts.DefaultColor or theme.Accent
                ColorPreview.BackgroundTransparency = 0
                ColorPreview.BorderSizePixel = 0
                ColorPreview.Parent = InnerFrame
                
                local PreviewCorner = Instance.new("UICorner")
                PreviewCorner.CornerRadius = UDim.new(0, 4 * scale)
                PreviewCorner.Parent = ColorPreview
                
                local ColorButton = Instance.new("TextButton")
                ColorButton.Name = "ColorButton"
                ColorButton.Size = UDim2.new(0, 80 * scale, 0, 30 * scale)
                ColorButton.Position = UDim2.new(1, -90 * scale, 0, 40 * scale)
                ColorButton.Text = "Pilih Warna"
                ColorButton.TextColor3 = theme.Text
                ColorButton.BackgroundColor3 = theme.Button
                ColorButton.BackgroundTransparency = 0
                ColorButton.TextSize = 11 * scale
                ColorButton.Font = Enum.Font.GothamBlack
                ColorButton.AutoButtonColor = false
                ColorButton.Parent = InnerFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6 * scale)
                ButtonCorner.Parent = ColorButton
                
                local currentColor = opts.DefaultColor or theme.Accent
                local isOpen = false
                
                local ColorPickerContainer = Instance.new("Frame")
                ColorPickerContainer.Name = "ColorPickerContainer"
                ColorPickerContainer.Size = UDim2.new(1, -20, 0, 0)
                ColorPickerContainer.Position = UDim2.new(0, 10 * scale, 0, 80 * scale)
                ColorPickerContainer.BackgroundColor3 = theme.InputBgFocus
                ColorPickerContainer.BackgroundTransparency = 0
                ColorPickerContainer.BorderSizePixel = 0
                ColorPickerContainer.ClipsDescendants = true
                ColorPickerContainer.Visible = false
                ColorPickerContainer.Parent = InnerFrame
                
                local ContainerCorner = Instance.new("UICorner")
                ContainerCorner.CornerRadius = UDim.new(0, 6 * scale)
                ContainerCorner.Parent = ColorPickerContainer
                
                -- Preset colors
                local presetColors = {
                    Color3.fromRGB(255, 40, 40),
                    Color3.fromRGB(255, 100, 40),
                    Color3.fromRGB(255, 200, 40),
                    Color3.fromRGB(40, 255, 40),
                    Color3.fromRGB(40, 200, 255),
                    Color3.fromRGB(40, 40, 255),
                    Color3.fromRGB(200, 40, 255),
                    Color3.fromRGB(255, 40, 200),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(128, 128, 128),
                    Color3.fromRGB(0, 0, 0),
                }
                
                local function createPresetButtons()
                    local gridFrame = Instance.new("Frame")
                    gridFrame.Name = "GridFrame"
                    gridFrame.Size = UDim2.new(1, -10, 0, 70 * scale)
                    gridFrame.Position = UDim2.new(0, 5 * scale, 0, 5 * scale)
                    gridFrame.BackgroundTransparency = 1
                    gridFrame.Parent = ColorPickerContainer
                    
                    for i, color in ipairs(presetColors) do
                        local row = math.floor((i - 1) / 4)
                        local col = (i - 1) % 4
                        
                        local PresetButton = Instance.new("TextButton")
                        PresetButton.Name = "Preset_" .. i
                        PresetButton.Size = UDim2.new(0, 30 * scale, 0, 30 * scale)
                        PresetButton.Position = UDim2.new(0, col * (30 * scale + 5), 0, row * (30 * scale + 5))
                        PresetButton.Text = ""
                        PresetButton.BackgroundColor3 = color
                        PresetButton.BackgroundTransparency = 0
                        PresetButton.AutoButtonColor = false
                        PresetButton.Parent = gridFrame
                        
                        local PresetCorner = Instance.new("UICorner")
                        PresetCorner.CornerRadius = UDim.new(0, 4 * scale)
                        PresetCorner.Parent = PresetButton
                        
                        PresetButton.MouseButton1Click:Connect(function()
                            currentColor = color
                            ColorPreview.BackgroundColor3 = color
                            isOpen = false
                            ColorPickerContainer.Visible = false
                            ColorPickerContainer.Size = UDim2.new(1, -20, 0, 0)
                            tween(ColorFrame, {Size = UDim2.new(0.95, 0, 0, 120 * scale)}, 0.15)
                            
                            if opts.Callback then
                                pcall(opts.Callback, color)
                            end
                        end)
                    end
                end
                
                createPresetButtons()
                
                ColorButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        ColorPickerContainer.Visible = true
                        ColorPickerContainer.Size = UDim2.new(1, -20, 0, 0)
                        tween(ColorPickerContainer, {Size = UDim2.new(1, -20, 0, 90 * scale)}, 0.2)
                        tween(ColorFrame, {Size = UDim2.new(0.95, 0, 0, 210 * scale)}, 0.2)
                        tween(ColorButton, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                        tween(ColorFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    else
                        tween(ColorPickerContainer, {Size = UDim2.new(1, -20, 0, 0)}, 0.15)
                        tween(ColorFrame, {Size = UDim2.new(0.95, 0, 0, 120 * scale)}, 0.15)
                        tween(ColorButton, {BackgroundColor3 = theme.Button}, 0.15)
                        tween(ColorFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                        task.wait(0.15)
                        ColorPickerContainer.Visible = false
                    end
                end)
                
                table.insert(self.Elements, ColorFrame)
                
                return {
                    Frame = ColorFrame,
                    GetColor = function() return currentColor end,
                    SetColor = function(color)
                        currentColor = color
                        ColorPreview.BackgroundColor3 = color
                        if opts.Callback then
                            pcall(opts.Callback, color)
                        end
                    end
                }
            end,
            
            -- ===== CREATE PROGRESS BAR =====
            CreateProgressBar = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local ProgressFrame = Instance.new("Frame")
                ProgressFrame.Name = opts.Name or "Progress_" .. #self.Elements + 1
                ProgressFrame.Size = UDim2.new(0.95, 0, 0, 60 * scale)
                ProgressFrame.BackgroundColor3 = theme.ContentCard
                ProgressFrame.BackgroundTransparency = 0
                ProgressFrame.BorderSizePixel = 2
                ProgressFrame.BorderColor3 = theme.BorderLight
                ProgressFrame.LayoutOrder = #self.Elements + 1
                ProgressFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = ProgressFrame
                
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = ProgressFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                local ProgressLabel = Instance.new("TextLabel")
                ProgressLabel.Name = "ProgressLabel"
                ProgressLabel.Size = UDim2.new(0.7, 0, 0, 22 * scale)
                ProgressLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                ProgressLabel.Text = opts.Text or opts.Name or "Progress"
                ProgressLabel.TextColor3 = theme.Text
                ProgressLabel.BackgroundTransparency = 1
                ProgressLabel.TextSize = 13 * scale
                ProgressLabel.Font = Enum.Font.GothamBlack
                ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
                ProgressLabel.Parent = InnerFrame
                
                local PercentLabel = Instance.new("TextLabel")
                PercentLabel.Name = "PercentLabel"
                PercentLabel.Size = UDim2.new(0.3, -10, 0, 22 * scale)
                PercentLabel.Position = UDim2.new(0.7, 0, 0, 8 * scale)
                PercentLabel.Text = "0%"
                PercentLabel.TextColor3 = theme.Accent
                PercentLabel.BackgroundTransparency = 1
                PercentLabel.TextSize = 13 * scale
                PercentLabel.Font = Enum.Font.GothamBlack
                PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
                PercentLabel.Parent = InnerFrame
                
                local ProgressTrack = Instance.new("Frame")
                ProgressTrack.Name = "ProgressTrack"
                ProgressTrack.Size = UDim2.new(1, -26, 0, 20 * scale)
                ProgressTrack.Position = UDim2.new(0, 13 * scale, 0, 34 * scale)
                ProgressTrack.BackgroundColor3 = theme.SliderTrack
                ProgressTrack.BackgroundTransparency = 0
                ProgressTrack.BorderSizePixel = 0
                ProgressTrack.Parent = InnerFrame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 10 * scale)
                TrackCorner.Parent = ProgressTrack
                
                local ProgressFill = Instance.new("Frame")
                ProgressFill.Name = "ProgressFill"
                ProgressFill.Size = UDim2.new(0, 0, 1, 0)
                ProgressFill.BackgroundColor3 = opts.Color or theme.SliderFill
                ProgressFill.BackgroundTransparency = 0
                ProgressFill.BorderSizePixel = 0
                ProgressFill.Parent = ProgressTrack
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 10 * scale)
                FillCorner.Parent = ProgressFill
                
                local currentProgress = opts.Progress or 0
                local maxProgress = opts.Max or 100
                local isIndeterminate = opts.Indeterminate or false
                
                local function updateProgress(value)
                    currentProgress = math.clamp(value, 0, maxProgress)
                    local percentage = (currentProgress / maxProgress) * 100
                    PercentLabel.Text = math.floor(percentage) .. "%"
                    
                    local fillWidth = (currentProgress / maxProgress)
                    ProgressFill.Size = UDim2.new(fillWidth, 0, 1, 0)
                end
                
                updateProgress(currentProgress)
                
                if isIndeterminate then
                    local animating = true
                    local function indeterminateAnimation()
                        local width = 0.3
                        local pos = 0
                        while animating and ProgressFill and ProgressFill.Parent do
                            pos = (pos + 0.02) % (1 + width)
                            ProgressFill.Size = UDim2.new(width, 0, 1, 0)
                            ProgressFill.Position = UDim2.new(pos - width, 0, 0, 0)
                            PercentLabel.Text = "..."
                            task.wait(0.03)
                        end
                    end
                    task.spawn(indeterminateAnimation)
                    
                    ProgressFrame.AncestryChanged:Connect(function()
                        animating = false
                    end)
                end
                
                table.insert(self.Elements, ProgressFrame)
                
                return {
                    Frame = ProgressFrame,
                    SetProgress = function(value)
                        if isIndeterminate then return end
                        updateProgress(value)
                        if opts.Callback then
                            pcall(opts.Callback, currentProgress)
                        end
                    end,
                    GetProgress = function() return currentProgress end,
                    SetMax = function(max)
                        maxProgress = max
                        updateProgress(currentProgress)
                    end,
                    Increment = function(amount)
                        if isIndeterminate then return end
                        updateProgress(currentProgress + (amount or 1))
                    end,
                    Reset = function()
                        if isIndeterminate then return end
                        updateProgress(0)
                    end
                }
            end,
            
            -- ===== CREATE LIST =====
            CreateList = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local ListFrame = Instance.new("Frame")
                ListFrame.Name = opts.Name or "List_" .. #self.Elements + 1
                ListFrame.Size = UDim2.new(0.95, 0, 0, 200 * scale)
                ListFrame.BackgroundColor3 = theme.ContentCard
                ListFrame.BackgroundTransparency = 0
                ListFrame.BorderSizePixel = 2
                ListFrame.BorderColor3 = theme.BorderLight
                ListFrame.LayoutOrder = #self.Elements + 1
                ListFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = ListFrame
                
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = ListFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                local ListLabel = Instance.new("TextLabel")
                ListLabel.Name = "ListLabel"
                ListLabel.Size = UDim2.new(1, -26, 0, 30 * scale)
                ListLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                ListLabel.Text = opts.Text or opts.Name or "List"
                ListLabel.TextColor3 = theme.Text
                ListLabel.BackgroundTransparency = 1
                ListLabel.TextSize = 13 * scale
                ListLabel.Font = Enum.Font.GothamBlack
                ListLabel.TextXAlignment = Enum.TextXAlignment.Left
                ListLabel.Parent = InnerFrame
                
                local ListContainer = Instance.new("ScrollingFrame")
                ListContainer.Name = "ListContainer"
                ListContainer.Size = UDim2.new(1, -26, 1, -46 * scale)
                ListContainer.Position = UDim2.new(0, 13 * scale, 0, 38 * scale)
                ListContainer.BackgroundColor3 = theme.InputBg
                ListContainer.BackgroundTransparency = 0
                ListContainer.BorderSizePixel = 0
                ListContainer.ScrollBarThickness = 3 * scale
                ListContainer.ScrollBarImageColor3 = theme.Accent
                ListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
                ListContainer.ScrollingDirection = Enum.ScrollingDirection.Y
                ListContainer.ElasticBehavior = Enum.ElasticBehavior.Always
                ListContainer.Parent = InnerFrame
                
                local ContainerCorner = Instance.new("UICorner")
                ContainerCorner.CornerRadius = UDim.new(0, 6 * scale)
                ContainerCorner.Parent = ListContainer
                
                local ItemLayout = Instance.new("UIListLayout")
                ItemLayout.Padding = UDim.new(0, 2 * scale)
                ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ItemLayout.Parent = ListContainer
                
                local ListPadding = Instance.new("UIPadding")
                ListPadding.PaddingTop = UDim.new(0, 4 * scale)
                ListPadding.PaddingBottom = UDim.new(0, 4 * scale)
                ListPadding.Parent = ListContainer
                
                ItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ListContainer.CanvasSize = UDim2.new(0, 0, 0, ItemLayout.AbsoluteContentSize.Y + 8 * scale)
                end)
                
                local items = {}
                local selectedItems = {}
                local multiSelect = opts.MultiSelect or false
                
                local function createItem(option, index)
                    local ItemButton = Instance.new("TextButton")
                    ItemButton.Name = "Item_" .. index
                    ItemButton.Size = UDim2.new(1, -8 * scale, 0, 36 * scale)
                    ItemButton.Text = tostring(option)
                    ItemButton.TextColor3 = theme.TextSecondary
                    ItemButton.BackgroundColor3 = theme.InputBg
                    ItemButton.BackgroundTransparency = 0
                    ItemButton.TextSize = 12 * scale
                    ItemButton.Font = Enum.Font.Gotham
                    ItemButton.AutoButtonColor = false
                    ItemButton.LayoutOrder = index
                    ItemButton.Parent = ListContainer
                    
                    local ItemCorner = Instance.new("UICorner")
                    ItemCorner.CornerRadius = UDim.new(0, 4 * scale)
                    ItemCorner.Parent = ItemButton
                    
                    local SelectedIcon = Instance.new("TextLabel")
                    SelectedIcon.Name = "SelectedIcon"
                    SelectedIcon.Size = UDim2.new(0, 20, 1, 0)
                    SelectedIcon.Position = UDim2.new(1, -25, 0, 0)
                    SelectedIcon.Text = "✓"
                    SelectedIcon.TextColor3 = theme.Accent
                    SelectedIcon.BackgroundTransparency = 1
                    SelectedIcon.TextSize = 14 * scale
                    SelectedIcon.Font = Enum.Font.Gotham
                    SelectedIcon.Visible = false
                    SelectedIcon.Parent = ItemButton
                    
                    local function updateSelection()
                        if multiSelect then
                            if table.find(selectedItems, tostring(option)) then
                                for i, v in ipairs(selectedItems) do
                                    if v == tostring(option) then
                                        table.remove(selectedItems, i)
                                        break
                                    end
                                end
                                ItemButton.BackgroundColor3 = theme.InputBg
                                ItemButton.TextColor3 = theme.TextSecondary
                                SelectedIcon.Visible = false
                            else
                                table.insert(selectedItems, tostring(option))
                                ItemButton.BackgroundColor3 = theme.Accent
                                ItemButton.TextColor3 = Color3.new(1, 1, 1)
                                SelectedIcon.Visible = true
                            end
                        else
                            for _, btn in pairs(items) do
                                btn.ItemButton.BackgroundColor3 = theme.InputBg
                                btn.ItemButton.TextColor3 = theme.TextSecondary
                                btn.SelectedIcon.Visible = false
                            end
                            selectedItems = {tostring(option)}
                            ItemButton.BackgroundColor3 = theme.Accent
                            ItemButton.TextColor3 = Color3.new(1, 1, 1)
                            SelectedIcon.Visible = true
                        end
                        
                        if opts.Callback then
                            pcall(opts.Callback, multiSelect and selectedItems or selectedItems[1])
                        end
                    end
                    
                    ItemButton.MouseButton1Click:Connect(updateSelection)
                    
                    ItemButton.MouseEnter:Connect(function()
                        if not isMobile and ItemButton.BackgroundColor3 ~= theme.Accent then
                            tween(ItemButton, {BackgroundColor3 = theme.ButtonHover}, 0.15)
                        end
                    end)
                    
                    ItemButton.MouseLeave:Connect(function()
                        if not isMobile and ItemButton.BackgroundColor3 ~= theme.Accent then
                            tween(ItemButton, {BackgroundColor3 = theme.InputBg}, 0.15)
                        end
                    end)
                    
                    return {
                        ItemButton = ItemButton,
                        SelectedIcon = SelectedIcon,
                        Value = tostring(option)
                    }
                end
                
                opts.Items = opts.Items or {}
                
                local function refreshItems()
                    for _, item in pairs(items) do
                        if item.ItemButton then
                            item.ItemButton:Destroy()
                        end
                    end
                    items = {}
                    selectedItems = {}
                    
                    for i, option in ipairs(opts.Items) do
                        local item = createItem(option, i)
                        table.insert(items, item)
                    end
                end
                
                refreshItems()
                
                table.insert(self.Elements, ListFrame)
                
                return {
                    Frame = ListFrame,
                    GetSelected = function() 
                        return multiSelect and selectedItems or selectedItems[1]
                    end,
                    SetItems = function(newItems)
                        opts.Items = newItems
                        refreshItems()
                    end,
                    AddItem = function(item)
                        table.insert(opts.Items, item)
                        local newItem = createItem(item, #opts.Items)
                        table.insert(items, newItem)
                    end,
                    RemoveItem = function(item)
                        for i, v in ipairs(opts.Items) do
                            if tostring(v) == tostring(item) then
                                table.remove(opts.Items, i)
                                break
                            end
                        end
                        refreshItems()
                    end,
                    ClearSelection = function()
                        selectedItems = {}
                        for _, item in pairs(items) do
                            item.ItemButton.BackgroundColor3 = theme.InputBg
                            item.ItemButton.TextColor3 = theme.TextSecondary
                            item.SelectedIcon.Visible = false
                        end
                    end,
                    SelectItem = function(item)
                        for _, v in ipairs(items) do
                            if v.Value == tostring(item) then
                                if multiSelect then
                                    v.ItemButton.BackgroundColor3 = theme.Accent
                                    v.ItemButton.TextColor3 = Color3.new(1, 1, 1)
                                    v.SelectedIcon.Visible = true
                                    table.insert(selectedItems, tostring(item))
                                else
                                    for _, btn in pairs(items) do
                                        btn.ItemButton.BackgroundColor3 = theme.InputBg
                                        btn.ItemButton.TextColor3 = theme.TextSecondary
                                        btn.SelectedIcon.Visible = false
                                    end
                                    selectedItems = {tostring(item)}
                                    v.ItemButton.BackgroundColor3 = theme.Accent
                                    v.ItemButton.TextColor3 = Color3.new(1, 1, 1)
                                    v.SelectedIcon.Visible = true
                                end
                                break
                            end
                        end
                    end
                }
            end,
            
            -- ===== CREATE SEARCH BAR =====
            CreateSearchBar = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local SearchFrame = Instance.new("Frame")
                SearchFrame.Name = opts.Name or "Search_" .. #self.Elements + 1
                SearchFrame.Size = UDim2.new(0.95, 0, 0, 110 * scale)
                SearchFrame.BackgroundColor3 = theme.ContentCard
                SearchFrame.BackgroundTransparency = 0
                SearchFrame.BorderSizePixel = 2
                SearchFrame.BorderColor3 = theme.BorderLight
                SearchFrame.LayoutOrder = #self.Elements + 1
                SearchFrame.Parent = TabContent
                
                local FrameCorner = Instance.new("UICorner")
                FrameCorner.CornerRadius = UDim.new(0, 8 * scale)
                FrameCorner.Parent = SearchFrame
                
                local InnerFrame = Instance.new("Frame")
                InnerFrame.Name = "InnerFrame"
                InnerFrame.Size = UDim2.new(1, -4, 1, -4)
                InnerFrame.Position = UDim2.new(0, 2, 0, 2)
                InnerFrame.BackgroundColor3 = theme.ContentCard
                InnerFrame.BackgroundTransparency = 0
                InnerFrame.BorderSizePixel = 0
                InnerFrame.Parent = SearchFrame
                
                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 6 * scale)
                InnerCorner.Parent = InnerFrame
                
                local SearchLabel = Instance.new("TextLabel")
                SearchLabel.Name = "SearchLabel"
                SearchLabel.Size = UDim2.new(0.6, 0, 0, 22 * scale)
                SearchLabel.Position = UDim2.new(0, 13 * scale, 0, 8 * scale)
                SearchLabel.Text = opts.Text or opts.Name or "Search"
                SearchLabel.TextColor3 = theme.Text
                SearchLabel.BackgroundTransparency = 1
                SearchLabel.TextSize = 13 * scale
                SearchLabel.Font = Enum.Font.GothamBlack
                SearchLabel.TextXAlignment = Enum.TextXAlignment.Left
                SearchLabel.Parent = InnerFrame
                
                local SearchBox = Instance.new("TextBox")
                SearchBox.Name = "SearchBox"
                SearchBox.Size = UDim2.new(1, -90, 0, 34 * scale)
                SearchBox.Position = UDim2.new(0, 13 * scale, 0, 34 * scale)
                SearchBox.Text = ""
                SearchBox.PlaceholderText = opts.Placeholder or "Cari..."
                SearchBox.PlaceholderColor3 = theme.TextMuted
                SearchBox.TextColor3 = theme.Text
                SearchBox.BackgroundColor3 = theme.InputBg
                SearchBox.BackgroundTransparency = 0
                SearchBox.TextSize = 13 * scale
                SearchBox.Font = Enum.Font.Gotham
                SearchBox.TextXAlignment = Enum.TextXAlignment.Left
                SearchBox.ClearTextOnFocus = false
                SearchBox.Parent = InnerFrame
                
                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 6 * scale)
                BoxCorner.Parent = SearchBox
                
                local SearchIcon = Instance.new("TextLabel")
                SearchIcon.Name = "SearchIcon"
                SearchIcon.Size = UDim2.new(0, 30, 0, 34)
                SearchIcon.Position = UDim2.new(1, -75, 0, 34)
                SearchIcon.Text = "🔍"
                SearchIcon.TextColor3 = theme.TextMuted
                SearchIcon.BackgroundTransparency = 1
                SearchIcon.TextSize = 16 * scale
                SearchIcon.Font = Enum.Font.Gotham
                SearchIcon.Parent = InnerFrame
                
                local ClearButton = Instance.new("TextButton")
                ClearButton.Name = "ClearButton"
                ClearButton.Size = UDim2.new(0, 30, 0, 34)
                ClearButton.Position = UDim2.new(1, -40, 0, 34)
                ClearButton.Text = "✕"
                ClearButton.TextColor3 = theme.TextMuted
                ClearButton.BackgroundTransparency = 1
                ClearButton.TextSize = 14 * scale
                ClearButton.Font = Enum.Font.Gotham
                ClearButton.Visible = false
                ClearButton.Parent = InnerFrame
                
                local ResultsContainer = Instance.new("Frame")
                ResultsContainer.Name = "ResultsContainer"
                ResultsContainer.Size = UDim2.new(1, -26, 0, 0)
                ResultsContainer.Position = UDim2.new(0, 13 * scale, 0, 72 * scale)
                ResultsContainer.BackgroundColor3 = theme.InputBgFocus
                ResultsContainer.BackgroundTransparency = 0
                ResultsContainer.BorderSizePixel = 0
                ResultsContainer.ClipsDescendants = true
                ResultsContainer.Visible = false
                ResultsContainer.Parent = InnerFrame
                
                local ResultsCorner = Instance.new("UICorner")
                ResultsCorner.CornerRadius = UDim.new(0, 6 * scale)
                ResultsCorner.Parent = ResultsContainer
                
                local ResultsList = Instance.new("ScrollingFrame")
                ResultsList.Name = "ResultsList"
                ResultsList.Size = UDim2.new(1, -2, 1, -2)
                ResultsList.Position = UDim2.new(0, 1, 0, 1)
                ResultsList.BackgroundTransparency = 1
                ResultsList.BorderSizePixel = 0
                ResultsList.ScrollBarThickness = 3 * scale
                ResultsList.ScrollBarImageColor3 = theme.Accent
                ResultsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
                ResultsList.ScrollingDirection = Enum.ScrollingDirection.Y
                ResultsList.ElasticBehavior = Enum.ElasticBehavior.Always
                ResultsList.Parent = ResultsContainer
                
                local ResultLayout = Instance.new("UIListLayout")
                ResultLayout.Padding = UDim.new(0, 2 * scale)
                ResultLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ResultLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ResultLayout.Parent = ResultsList
                
                local data = opts.Data or {}
                local filteredData = {}
                local debounce = false
                
                local function updateContainerSize()
                    local itemCount = #filteredData
                    local height = math.min(itemCount * 32 * scale + 4 * scale, 120 * scale)
                    ResultsContainer.Size = UDim2.new(1, -26, 0, height)
                    
                    local totalHeight = 110 * scale
                    if #filteredData > 0 then
                        totalHeight = 110 * scale + height + 4 * scale
                    end
                    SearchFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
                end
                
                local function clearResults()
                    for _, child in pairs(ResultsList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                end
                
                local function filterData(query)
                    query = query:lower()
                    filteredData = {}
                    
                    if query == "" then
                        ResultsContainer.Visible = false
                        updateContainerSize()
                        return
                    end
                    
                    for _, item in ipairs(data) do
                        if item:lower():find(query, 1, true) then
                            table.insert(filteredData, item)
                        end
                    end
                    
                    clearResults()
                    
                    if #filteredData > 0 then
                        for i, result in ipairs(filteredData) do
                            local ResultButton = Instance.new("TextButton")
                            ResultButton.Name = "Result_" .. i
                            ResultButton.Size = UDim2.new(1, -4 * scale, 0, 30 * scale)
                            ResultButton.Text = result
                            ResultButton.TextColor3 = theme.TextSecondary
                            ResultButton.BackgroundColor3 = theme.InputBg
                            ResultButton.BackgroundTransparency = 0
                            ResultButton.TextSize = 12 * scale
                            ResultButton.Font = Enum.Font.Gotham
                            ResultButton.AutoButtonColor = false
                            ResultButton.LayoutOrder = i
                            ResultButton.Parent = ResultsList
                            
                            local ResultCorner = Instance.new("UICorner")
                            ResultCorner.CornerRadius = UDim.new(0, 4 * scale)
                            ResultCorner.Parent = ResultButton
                            
                            ResultButton.MouseEnter:Connect(function()
                                tween(ResultButton, {BackgroundColor3 = theme.ButtonHover}, 0.15)
                            end)
                            
                            ResultButton.MouseLeave:Connect(function()
                                tween(ResultButton, {BackgroundColor3 = theme.InputBg}, 0.15)
                            end)
                            
                            ResultButton.MouseButton1Click:Connect(function()
                                SearchBox.Text = result
                                ResultsContainer.Visible = false
                                updateContainerSize()
                                
                                if opts.Callback then
                                    pcall(opts.Callback, result)
                                end
                            end)
                        end
                        
                        ResultsContainer.Visible = true
                    else
                        local NoResult = Instance.new("TextLabel")
                        NoResult.Name = "NoResult"
                        NoResult.Size = UDim2.new(1, -4 * scale, 0, 30 * scale)
                        NoResult.Text = "Tidak ada hasil"
                        NoResult.TextColor3 = theme.TextMuted
                        NoResult.BackgroundTransparency = 1
                        NoResult.TextSize = 12 * scale
                        NoResult.Font = Enum.Font.Gotham
                        NoResult.Parent = ResultsList
                    end
                    
                    updateContainerSize()
                end
                
                SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    ClearButton.Visible = SearchBox.Text ~= ""
                    
                    if debounce then return end
                    debounce = true
                    
                    task.wait(0.3)
                    
                    filterData(SearchBox.Text)
                    
                    debounce = false
                end)
                
                SearchBox.Focused:Connect(function()
                    tween(SearchBox, {BackgroundColor3 = theme.InputBgFocus}, 0.15)
                    tween(SearchFrame, {BorderColor3 = theme.BorderRed}, 0.15)
                    
                    if SearchBox.Text ~= "" then
                        filterData(SearchBox.Text)
                    end
                end)
                
                SearchBox.FocusLost:Connect(function()
                    tween(SearchBox, {BackgroundColor3 = theme.InputBg}, 0.15)
                    tween(SearchFrame, {BorderColor3 = theme.BorderLight}, 0.15)
                    
                    task.wait(0.2)
                    ResultsContainer.Visible = false
                    updateContainerSize()
                end)
                
                ClearButton.MouseButton1Click:Connect(function()
                    SearchBox.Text = ""
                    SearchBox:CaptureFocus()
                end)
                
                ClearButton.MouseEnter:Connect(function()
                    tween(ClearButton, {TextColor3 = theme.Error}, 0.15)
                end)
                
                ClearButton.MouseLeave:Connect(function()
                    tween(ClearButton, {TextColor3 = theme.TextMuted}, 0.15)
                end)
                
                table.insert(self.Elements, SearchFrame)
                
                return {
                    Frame = SearchFrame,
                    GetText = function() return SearchBox.Text end,
                    SetText = function(text)
                        SearchBox.Text = text
                        filterData(text)
                    end,
                    SetData = function(newData)
                        data = newData
                    end,
                    AddData = function(item)
                        table.insert(data, item)
                    end,
                    Clear = function()
                        SearchBox.Text = ""
                        filteredData = {}
                        clearResults()
                        ResultsContainer.Visible = false
                        updateContainerSize()
                    end,
                    Focus = function()
                        SearchBox:CaptureFocus()
                    end
                }
            end,
            
            -- ===== CREATE TAB GROUP =====
            CreateTabGroup = function(self, options)
                local opts = options or {}
                local scale = windowData.Scale
                
                local GroupFrame = Instance.new("Frame")
                GroupFrame.Name = opts.Name or "TabGroup_" .. #self.Elements + 1
                GroupFrame.Size = UDim2.new(0.95, 0, 0, 0)
                GroupFrame.BackgroundTransparency = 1
                GroupFrame.LayoutOrder = #self.Elements + 1
                GroupFrame.Parent = TabContent
                
                local TabBar = Instance.new("Frame")
                TabBar.Name = "TabBar"
                TabBar.Size = UDim2.new(1, 0, 0, 40 * scale)
                TabBar.BackgroundColor3 = theme.ContentCard
                TabBar.BackgroundTransparency = 0
                TabBar.BorderSizePixel = 2
                TabBar.BorderColor3 = theme.BorderLight
                TabBar.Parent = GroupFrame
                
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(0, 8 * scale)
                BarCorner.Parent = TabBar
                
                local TabContainer = Instance.new("Frame")
                TabContainer.Name = "TabContainer"
                TabContainer.Size = UDim2.new(1, -4, 1, -4)
                TabContainer.Position = UDim2.new(0, 2, 0, 2)
                TabContainer.BackgroundColor3 = theme.ContentCard
                TabContainer.BackgroundTransparency = 0
                TabContainer.BorderSizePixel = 0
                TabContainer.Parent = TabBar
                
                local TabBarCorner = Instance.new("UICorner")
                TabBarCorner.CornerRadius = UDim.new(0, 6 * scale)
                TabBarCorner.Parent = TabContainer
                
                local TabList = Instance.new("Frame")
                TabList.Name = "TabList"
                TabList.Size = UDim2.new(1, 0, 1, 0)
                TabList.BackgroundTransparency = 1
                TabList.Parent = TabContainer
                
                local TabLayout = Instance.new("UIListLayout")
                TabLayout.FillDirection = Enum.FillDirection.Horizontal
                TabLayout.Padding = UDim.new(0, 4 * scale)
                TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
                TabLayout.Parent = TabList
                
                local TabPadding = Instance.new("UIPadding")
                TabPadding.PaddingLeft = UDim.new(0, 8 * scale)
                TabPadding.PaddingRight = UDim.new(0, 8 * scale)
                TabPadding.Parent = TabList
                
                local ContentFrame = Instance.new("Frame")
                ContentFrame.Name = "ContentFrame"
                ContentFrame.Size = UDim2.new(1, 0, 0, 0)
                ContentFrame.Position = UDim2.new(0, 0, 0, 44 * scale)
                ContentFrame.BackgroundTransparency = 1
                ContentFrame.ClipsDescendants = true
                ContentFrame.Parent = GroupFrame
                
                local ContentContainer = Instance.new("Frame")
                ContentContainer.Name = "ContentContainer"
                ContentContainer.Size = UDim2.new(1, 0, 0, 0)
                ContentContainer.BackgroundTransparency = 1
                ContentContainer.Parent = ContentFrame
                
                local ContentLayout = Instance.new("UIListLayout")
                ContentLayout.Padding = UDim.new(0, 8 * scale)
                ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ContentLayout.Parent = ContentContainer
                
                ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    ContentContainer.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                    ContentFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                    
                    local totalHeight = 44 * scale + ContentLayout.AbsoluteContentSize.Y + 8 * scale
                    GroupFrame.Size = UDim2.new(0.95, 0, 0, totalHeight)
                end)
                
                local tabs = {}
                local activeTab = nil
                
                local function createTabButton(tabName, tabData)
                    local TabButton = Instance.new("TextButton")
                    TabButton.Name = tabName .. "_GroupTab"
                    TabButton.Size = UDim2.new(0, 70 * scale, 0, 30 * scale)
                    TabButton.Text = tabName
                    TabButton.TextColor3 = theme.TextSecondary
                    TabButton.BackgroundColor3 = theme.TabNormal
                    TabButton.BackgroundTransparency = 0
                    TabButton.TextSize = 11 * scale
                    TabButton.Font = Enum.Font.GothamBlack
                    TabButton.AutoButtonColor = false
                    TabButton.LayoutOrder = #tabs + 1
                    TabButton.Parent = TabList
                    
                    local ButtonCorner = Instance.new("UICorner")
                    ButtonCorner.CornerRadius = UDim.new(0, 6 * scale)
                    ButtonCorner.Parent = TabButton
                    
                    TabButton.MouseButton1Click:Connect(function()
                        for _, t in pairs(tabs) do
                            t.Button.BackgroundColor3 = theme.TabNormal
                            t.Button.TextColor3 = theme.TextSecondary
                            t.Content.Visible = false
                        end
                        
                        TabButton.BackgroundColor3 = theme.TabActive
                        TabButton.TextColor3 = Color3.new(1, 1, 1)
                        tabData.Content.Visible = true
                        activeTab = tabName
                    end)
                    
                    TabButton.MouseEnter:Connect(function()
                        if TabButton.BackgroundColor3 ~= theme.TabActive then
                            tween(TabButton, {BackgroundColor3 = theme.TabHover}, 0.15)
                        end
                    end)
                    
                    TabButton.MouseLeave:Connect(function()
                        if TabButton.BackgroundColor3 ~= theme.TabActive then
                            tween(TabButton, {BackgroundColor3 = theme.TabNormal}, 0.15)
                        end
                    end)
                    
                    return TabButton
                end
                
                local groupObj = {
                    Frame = GroupFrame,
                    Tabs = tabs,
                    ActiveTab = activeTab,
                    
                    CreateSubTab = function(self, name)
                        local tabName = name or "Tab_" .. (#tabs + 1)
                        
                        local TabContent = Instance.new("Frame")
                        TabContent.Name = tabName .. "_Content"
                        TabContent.Size = UDim2.new(1, 0, 0, 0)
                        TabContent.BackgroundTransparency = 1
                        TabContent.Visible = false
                        TabContent.Parent = ContentContainer
                        
                        local TabLayout = Instance.new("UIListLayout")
                        TabLayout.Padding = UDim.new(0, 8 * scale)
                        TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
                        TabLayout.Parent = TabContent
                        
                        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                            TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
                        end)
                        
                        local tabButton = createTabButton(tabName, {Content = TabContent})
                        
                        local tabData = {
                            Button = tabButton,
                            Content = TabContent,
                            Elements = {},
                            
                            CreateButton = function(self, btnOpts)
                                btnOpts = btnOpts or {}
                                local Button = Instance.new("TextButton")
                                Button.Name = btnOpts.Name or "Button_" .. #self.Elements + 1
                                Button.Size = UDim2.new(0.95, 0, 0, 36 * scale)
                                Button.Text = btnOpts.Text or Button.Name
                                Button.TextColor3 = theme.Text
                                Button.BackgroundColor3 = theme.Button
                                Button.BackgroundTransparency = 0
                                Button.TextSize = 12 * scale
                                Button.Font = Enum.Font.GothamBlack
                                Button.AutoButtonColor = false
                                Button.LayoutOrder = #self.Elements + 1
                                Button.Parent = TabContent
                                
                                local Corner = Instance.new("UICorner")
                                Corner.CornerRadius = UDim.new(0, 6 * scale)
                                Corner.Parent = Button
                                
                                Button.MouseButton1Click:Connect(function()
                                    if btnOpts.Callback then
                                        pcall(btnOpts.Callback)
                                    end
                                end)
                                
                                table.insert(self.Elements, Button)
                                return Button
                            end,
                            
                            CreateLabel = function(self, lblOpts)
                                lblOpts = lblOpts or {}
                                local Label = Instance.new("TextLabel")
                                Label.Name = lblOpts.Name or "Label_" .. #self.Elements + 1
                                Label.Size = UDim2.new(0.95, 0, 0, 28 * scale)
                                Label.Text = lblOpts.Text or Label.Name
                                Label.TextColor3 = lblOpts.Color or theme.TextSecondary
                                Label.BackgroundTransparency = 1
                                Label.TextSize = lblOpts.Size or 12 * scale
                                Label.Font = Enum.Font.GothamBlack
                                Label.TextXAlignment = lblOpts.Alignment or Enum.TextXAlignment.Left
                                Label.LayoutOrder = #self.Elements + 1
                                Label.Parent = TabContent
                                
                                table.insert(self.Elements, Label)
                                return Label
                            end
                        }
                        
                        tabs[tabName] = tabData
                        table.insert(self.Tabs, tabData)
                        
                        if #tabs == 1 then
                            tabButton.BackgroundColor3 = theme.TabActive
                            tabButton.TextColor3 = Color3.new(1, 1, 1)
                            TabContent.Visible = true
                            activeTab = tabName
                        end
                        
                        return tabData
                    end
                }
                
                self.TabGroups[opts.Name or #self.TabGroups + 1] = groupObj
                table.insert(self.Elements, GroupFrame)
                
                return groupObj
            end
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
    
    -- MINIMIZE FUNCTIONALITY
    local originalSize = windowData.Size
    local isMinimized = false
    
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
    
    return windowObj
end

-- GLOBAL NOTIFICATION
function SimpleGUI:CreateNotification(options)
    local opts = options or {}
    local theme = self:GetTheme()
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification_" .. os.clock()
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, -320, 0, 20 + (#self.Notifications * 90))
    notifFrame.BackgroundColor3 = theme.ContentCard
    notifFrame.BackgroundTransparency = 0
    notifFrame.BorderSizePixel = 2
    notifFrame.BorderColor3 = opts.Type == "success" and theme.Success or 
                              opts.Type == "error" and theme.Error or
                              opts.Type == "warning" and theme.Warning or
                              theme.BorderRed
    notifFrame.Parent = self.ScreenGui
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = notifFrame
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 40, 1, 0)
    IconLabel.Text = opts.Type == "success" and "✓" or
                     opts.Type == "error" and "✗" or
                     opts.Type == "warning" and "⚠" or
                     "ℹ"
    IconLabel.TextColor3 = opts.Type == "success" and theme.Success or
                           opts.Type == "error" and theme.Error or
                           opts.Type == "warning" and theme.Warning or
                           theme.Accent
    IconLabel.BackgroundTransparency = 1
    IconLabel.TextSize = 24
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Parent = notifFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -50, 0, 25)
    TitleLabel.Position = UDim2.new(0, 45, 0, 10)
    TitleLabel.Text = opts.Title or "Notification"
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = notifFrame
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Size = UDim2.new(1, -50, 0, 35)
    MessageLabel.Position = UDim2.new(0, 45, 0, 30)
    MessageLabel.Text = opts.Message or ""
    MessageLabel.TextColor3 = theme.TextSecondary
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.TextSize = 12
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.Parent = notifFrame
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = theme.TextMuted
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.Parent = notifFrame
    
    local NotifGlow = createGlow(notifFrame, theme.AccentGlow, UDim2.new(1, 10, 1, 10))
    NotifGlow.ImageTransparency = 0.7
    
    notifFrame.Position = UDim2.new(1, -320, 0, 20 + (#self.Notifications * 90))
    notifFrame.Size = UDim2.new(0, 0, 0, 0)
    tween(notifFrame, {Size = UDim2.new(0, 300, 0, 80)}, 0.3, Enum.EasingStyle.Back)
    
    local notification = {
        Frame = notifFrame,
        Close = function()
            for i, n in ipairs(self.Notifications) do
                if n.Frame == notifFrame then
                    table.remove(self.Notifications, i)
                    break
                end
            end
            
            tween(notifFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            notifFrame:Destroy()
            
            for i, n in ipairs(self.Notifications) do
                local newPos = UDim2.new(1, -320, 0, 20 + ((i-1) * 90))
                tween(n.Frame, {Position = newPos}, 0.2)
            end
        end
    }
    
    CloseButton.MouseButton1Click:Connect(notification.Close)
    
    if opts.Duration ~= 0 then
        task.wait(opts.Duration or 3)
        if notifFrame and notifFrame.Parent then
            notification.Close()
        end
    end
    
    table.insert(self.Notifications, notification)
    return notification
end

-- GLOBAL MODAL
function SimpleGUI:CreateModal(options)
    local opts = options or {}
    local theme = self:GetTheme()
    
    local Overlay = Instance.new("Frame")
    Overlay.Name = "ModalOverlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Parent = self.ScreenGui
    
    local ModalFrame = Instance.new("Frame")
    ModalFrame.Name = "Modal_" .. os.clock()
    ModalFrame.Size = UDim2.new(0, 400, 0, 200)
    ModalFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    ModalFrame.BackgroundColor3 = theme.ContentCard
    ModalFrame.BackgroundTransparency = 0
    ModalFrame.BorderSizePixel = 2
    ModalFrame.BorderColor3 = theme.BorderRed
    ModalFrame.Parent = Overlay
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 10)
    FrameCorner.Parent = ModalFrame
    
    local InnerFrame = Instance.new("Frame")
    InnerFrame.Name = "InnerFrame"
    InnerFrame.Size = UDim2.new(1, -4, 1, -4)
    InnerFrame.Position = UDim2.new(0, 2, 0, 2)
    InnerFrame.BackgroundColor3 = theme.ContentCard
    InnerFrame.BackgroundTransparency = 0
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Parent = ModalFrame
    
    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(0, 8)
    InnerCorner.Parent = InnerFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -30, 0, 40)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.Text = opts.Title or "Modal"
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = InnerFrame
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Size = UDim2.new(1, -30, 0, 60)
    MessageLabel.Position = UDim2.new(0, 15, 0, 50)
    MessageLabel.Text = opts.Message or ""
    MessageLabel.TextColor3 = theme.TextSecondary
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.TextSize = 14
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.Parent = InnerFrame
    
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "ButtonFrame"
    ButtonFrame.Size = UDim2.new(1, -30, 0, 40)
    ButtonFrame.Position = UDim2.new(0, 15, 1, -50)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = InnerFrame
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Name = "CancelButton"
    CancelButton.Size = UDim2.new(0.5, -5, 1, 0)
    CancelButton.Position = UDim2.new(0, 0, 0, 0)
    CancelButton.Text = opts.CancelText or "Batal"
    CancelButton.TextColor3 = theme.Text
    CancelButton.BackgroundColor3 = theme.Button
    CancelButton.BackgroundTransparency = 0
    CancelButton.TextSize = 14
    CancelButton.Font = Enum.Font.GothamBlack
    CancelButton.AutoButtonColor = false
    CancelButton.Parent = ButtonFrame
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 6)
    CancelCorner.Parent = CancelButton
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Name = "ConfirmButton"
    ConfirmButton.Size = UDim2.new(0.5, -5, 1, 0)
    ConfirmButton.Position = UDim2.new(0.5, 5, 0, 0)
    ConfirmButton.Text = opts.ConfirmText or "OK"
    ConfirmButton.TextColor3 = Color3.new(1, 1, 1)
    ConfirmButton.BackgroundColor3 = theme.Accent
    ConfirmButton.BackgroundTransparency = 0
    ConfirmButton.TextSize = 14
    ConfirmButton.Font = Enum.Font.GothamBlack
    ConfirmButton.AutoButtonColor = false
    ConfirmButton.Parent = ButtonFrame
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 6)
    ConfirmCorner.Parent = ConfirmButton
    
    local function closeModal(confirmed)
        tween(ModalFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        tween(Overlay, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.2)
        Overlay:Destroy()
        
        if opts.Callback then
            pcall(opts.Callback, confirmed)
        end
    end
    
    CancelButton.MouseButton1Click:Connect(function()
        closeModal(false)
    end)
    
    ConfirmButton.MouseButton1Click:Connect(function()
        closeModal(true)
    end)
    
    CancelButton.MouseEnter:Connect(function()
        tween(CancelButton, {BackgroundColor3 = theme.ButtonHover}, 0.15)
    end)
    
    CancelButton.MouseLeave:Connect(function()
        tween(CancelButton, {BackgroundColor3 = theme.Button}, 0.15)
    end)
    
    ConfirmButton.MouseEnter:Connect(function()
        tween(ConfirmButton, {BackgroundColor3 = theme.AccentDark}, 0.15)
    end)
    
    ConfirmButton.MouseLeave:Connect(function()
        tween(ConfirmButton, {BackgroundColor3 = theme.Accent}, 0.15)
    end)
    
    local ModalGlow = createGlow(ModalFrame, theme.AccentGlow, UDim2.new(1, 15, 1, 15))
    
    return {
        Frame = ModalFrame,
        Overlay = Overlay,
        Close = closeModal
    }
end

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
    
    for _, notif in pairs(self.Notifications) do
        if notif.Frame then
            notif.Frame:Destroy()
        end
    end
    
    for _, modal in pairs(self.Modals) do
        if modal.Overlay then
            modal.Overlay:Destroy()
        end
    end
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Windows = {}
    self.MinimizedIcons = {}
    self.Notifications = {}
    self.Modals = {}
end

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

function SimpleGUI:GetVersion()
    return "8.0 - Bee Futuristic Edition (Complete)"
end

return SimpleGUI