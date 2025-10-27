-- Neverlose UI Library v1.0
-- Loadstring: loadstring(game:HttpGet("YOUR_GITHUB_RAW_URL"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Library = {}

function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NEVERLOSE"
    local Keybind = config.Keybind or Enum.KeyCode.Insert
    
    local Window = {Tabs = {}, CurrentTab = nil}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeverloseUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.3, 0, 0.15, 0)
    Main.Size = UDim2.new(0, 661, 0, 486)
    Main.Active = true
    Main.ClipsDescendants = true
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 5)
    
    -- Left Panel
    local LeftPanel = Instance.new("ScrollingFrame")
    LeftPanel.Name = "LeftPanel"
    LeftPanel.Parent = Main
    LeftPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    LeftPanel.BorderSizePixel = 0
    LeftPanel.Size = UDim2.new(0, 151, 1, 0)
    LeftPanel.ScrollBarThickness = 3
    LeftPanel.ScrollBarImageColor3 = Color3.fromRGB(14, 75, 191)
    LeftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 5)
    
    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Parent = LeftPanel
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 0, 0, 10)
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.Font = Enum.Font.SourceSansBold
    Logo.Text = Title
    Logo.TextColor3 = Color3.new(1, 1, 1)
    Logo.TextSize = 28
    Logo.ZIndex = 10
    
    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Parent = LeftPanel
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Position = UDim2.new(0, 0, 0, 70)
    TabsContainer.Size = UDim2.new(1, 0, 1, -140)
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Parent = TabsContainer
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 5)
    
    -- Account Details
    local AccountFrame = Instance.new("Frame")
    AccountFrame.Parent = LeftPanel
    AccountFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    AccountFrame.BorderSizePixel = 0
    AccountFrame.Position = UDim2.new(0, 5, 1, -52)
    AccountFrame.Size = UDim2.new(1, -10, 0, 47)
    AccountFrame.ZIndex = 10
    
    Instance.new("UICorner", AccountFrame).CornerRadius = UDim.new(0, 5)
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Parent = AccountFrame
    Avatar.BackgroundColor3 = Color3.new(1, 1, 1)
    Avatar.BorderSizePixel = 0
    Avatar.Position = UDim2.new(0, 8, 0, 7)
    Avatar.Size = UDim2.new(0, 32, 0, 32)
    Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
    
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Parent = AccountFrame
    PlayerName.BackgroundTransparency = 1
    PlayerName.Position = UDim2.new(0, 45, 0, 8)
    PlayerName.Size = UDim2.new(1, -50, 0, 15)
    PlayerName.Font = Enum.Font.SourceSansSemibold
    PlayerName.Text = "Loading..."
    PlayerName.TextColor3 = Color3.new(1, 1, 1)
    PlayerName.TextSize = 14
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    
    local SubText = Instance.new("TextLabel")
    SubText.Parent = AccountFrame
    SubText.BackgroundTransparency = 1
    SubText.Position = UDim2.new(0, 45, 0, 24)
    SubText.Size = UDim2.new(1, -50, 0, 15)
    SubText.Font = Enum.Font.SourceSansSemibold
    SubText.Text = "Till: never"
    SubText.TextColor3 = Color3.fromRGB(153, 165, 181)
    SubText.TextSize = 12
    SubText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Top Panel
    local TopPanel = Instance.new("Frame")
    TopPanel.Parent = Main
    TopPanel.BackgroundTransparency = 1
    TopPanel.Position = UDim2.new(0, 151, 0, 0)
    TopPanel.Size = UDim2.new(1, -151, 0, 60)
    
    local TopTitle = Instance.new("TextLabel")
    TopTitle.Parent = TopPanel
    TopTitle.BackgroundTransparency = 1
    TopTitle.Position = UDim2.new(0, 20, 0, 0)
    TopTitle.Size = UDim2.new(1, -40, 1, 0)
    TopTitle.Font = Enum.Font.SourceSansBold
    TopTitle.Text = "Welcome"
    TopTitle.TextColor3 = Color3.new(1, 1, 1)
    TopTitle.TextSize = 20
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Content Container
    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 151, 0, 60)
    Content.Size = UDim2.new(1, -151, 1, -60)
    Content.ClipsDescendants = true
    
    -- Load Player Info
    task.spawn(function()
        local player = Players.LocalPlayer
        if player then
            PlayerName.Text = player.Name
            local success, thumb = pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if success then Avatar.Image = thumb end
        end
    end)
    
    -- Toggle Visibility
    local visible = true
    local function toggle()
        visible = not visible
        if visible then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.3, 0, 0.15, 0)}):Play()
        else
            local tween = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.3, 0, -1, 0)})
            tween:Play()
            tween.Completed:Connect(function() if not visible then Main.Visible = false end end)
        end
    end
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Keybind then toggle() end
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Create Tab
    function Window:CreateTab(name, icon)
        local Tab = {Name = name, Elements = {}}
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabsContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(14, 75, 191)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, -20, 0, 30)
        TabBtn.AutoButtonColor = false
        TabBtn.Text = ""
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Parent = TabBtn
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 35, 0, 0)
        TabLabel.Size = UDim2.new(1, -35, 1, 0)
        TabLabel.Font = Enum.Font.SourceSansSemibold
        TabLabel.Text = name
        TabLabel.TextColor3 = Color3.new(1, 1, 1)
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Parent = TabBtn
        IconLabel.BackgroundTransparency = 1
        IconLabel.Position = UDim2.new(0, 10, 0, 0)
        IconLabel.Size = UDim2.new(0, 20, 1, 0)
        IconLabel.Font = Enum.Font.SourceSansBold
        IconLabel.Text = icon or "•"
        IconLabel.TextColor3 = Color3.new(1, 1, 1)
        IconLabel.TextSize = 16
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = Content
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(14, 75, 191)
        TabContent.Visible = false
        
        local Padding = Instance.new("UIPadding")
        Padding.Parent = TabContent
        Padding.PaddingLeft = UDim.new(0, 10)
        Padding.PaddingRight = UDim.new(0, 10)
        Padding.PaddingTop = UDim.new(0, 10)
        Padding.PaddingBottom = UDim.new(0, 10)
        
        local Layout = Instance.new("UIListLayout")
        Layout.Parent = TabContent
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 8)
        
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
        end)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Button.BackgroundTransparency = 1
                t.Content.Visible = false
            end
            TabBtn.BackgroundTransparency = 0.8
            TabContent.Visible = true
            Window.CurrentTab = Tab
            TopTitle.Text = name
        end)
        
        Tab.Button = TabBtn
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabBtn.BackgroundTransparency = 0.8
            TabContent.Visible = true
            Window.CurrentTab = Tab
            TopTitle.Text = name
        end
        
        function Tab:CreateSection(text)
            local Section = Instance.new("TextLabel")
            Section.Parent = TabContent
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 25)
            Section.Font = Enum.Font.SourceSansBold
            Section.Text = text
            Section.TextColor3 = Color3.fromRGB(153, 165, 181)
            Section.TextSize = 16
            Section.TextXAlignment = Enum.TextXAlignment.Left
            return Section
        end
        
        function Tab:CreateToggle(text, default, callback)
            local Toggle = {Value = default or false}
            callback = callback or function() end
            
            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Font = Enum.Font.SourceSansSemibold
            Label.Text = text
            Label.TextColor3 = Color3.new(1, 1, 1)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Btn = Instance.new("Frame")
            Btn.Parent = Frame
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Btn.Position = UDim2.new(1, -50, 0.5, -8)
            Btn.Size = UDim2.new(0, 40, 0, 16)
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
            
            local Indicator = Instance.new("Frame")
            Indicator.Parent = Btn
            Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Indicator.Position = UDim2.new(0, 2, 0.5, -6)
            Indicator.Size = UDim2.new(0, 12, 0, 12)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
            
            local function update()
                if Toggle.Value then
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(14, 75, 191)}):Play()
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                else
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
                pcall(callback, Toggle.Value)
            end
            
            local Click = Instance.new("TextButton")
            Click.Parent = Frame
            Click.BackgroundTransparency = 1
            Click.Size = UDim2.new(1, 0, 1, 0)
            Click.Text = ""
            Click.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                update()
            end)
            
            update()
            function Toggle:Set(v) Toggle.Value = v update() end
            return Toggle
        end
        
        function Tab:CreateSlider(text, min, max, default, callback)
            local Slider = {Value = default or min}
            callback = callback or function() end
            
            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 50)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.Size = UDim2.new(0.6, 0, 0, 18)
            Label.Font = Enum.Font.SourceSansSemibold
            Label.Text = text
            Label.TextColor3 = Color3.new(1, 1, 1)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Value = Instance.new("TextLabel")
            Value.Parent = Frame
            Value.BackgroundTransparency = 1
            Value.Position = UDim2.new(0.6, 0, 0, 5)
            Value.Size = UDim2.new(0.4, -12, 0, 18)
            Value.Font = Enum.Font.SourceSansSemibold
            Value.Text = tostring(default)
            Value.TextColor3 = Color3.fromRGB(14, 75, 191)
            Value.TextSize = 14
            Value.TextXAlignment = Enum.TextXAlignment.Right
            
            local Bar = Instance.new("Frame")
            Bar.Parent = Frame
            Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Bar.Position = UDim2.new(0, 12, 0, 28)
            Bar.Size = UDim2.new(1, -24, 0, 8)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Color3.fromRGB(14, 75, 191)
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local Dot = Instance.new("Frame")
            Dot.Parent = Bar
            Dot.BackgroundColor3 = Color3.new(1, 1, 1)
            Dot.Position = UDim2.new(0, -6, 0.5, -6)
            Dot.Size = UDim2.new(0, 12, 0, 12)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            
            local function update(v)
                Slider.Value = math.clamp(v, min, max)
                local percent = (Slider.Value - min) / (max - min)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                Dot.Position = UDim2.new(percent, -6, 0.5, -6)
                Value.Text = tostring(math.floor(Slider.Value))
                pcall(callback, Slider.Value)
            end
            
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    update(min + (max - min) * percent)
                end
            end)
            
            Bar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    update(min + (max - min) * percent)
                end
            end)
            
            update(default)
            function Slider:Set(v) update(v) end
            return Slider
        end
        
        function Tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Frame = Instance.new("TextButton")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(14, 75, 191)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Frame.AutoButtonColor = false
            Frame.Font = Enum.Font.SourceSansSemibold
            Frame.Text = text
            Frame.TextColor3 = Color3.new(1, 1, 1)
            Frame.TextSize = 14
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
            
            Frame.MouseButton1Click:Connect(function()
                TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(10, 60, 150)}):Play()
                wait(0.1)
                TweenService:Create(Frame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(14, 75, 191)}):Play()
                pcall(callback)
            end)
            
            return Frame
        end
        
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabContent
            Label.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Label.BorderSizePixel = 0
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.Font = Enum.Font.SourceSansSemibold
            Label.Text = text
            Label.TextColor3 = Color3.new(1, 1, 1)
            Label.TextSize = 14
            Instance.new("UICorner", Label).CornerRadius = UDim.new(0, 5)
            
            function Label:Set(t) Label.Text = t end
            return Label
        end
        
        return Tab
    end
    
    return Window
end

return Library
