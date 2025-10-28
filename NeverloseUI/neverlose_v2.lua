--[[
    Neverlose UI Library v2.0
    Оригинальный стиль с категориями и двухколоночной системой
    
    Loadstring:
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/W3bs1teH0st3d/neverpuzo-UI/main/neverlose_v2.lua"))()
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}

-- Создание главного окна
function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NEVERLOSE"
    local Keybind = config.Keybind or Enum.KeyCode.Insert
    
    local Window = {Tabs = {}}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NeverloseUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(13, 15, 18)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -400, 0.5, -250)
    Main.Size = UDim2.new(0, 800, 0, 500)
    Main.Active = true
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    
    local TopBarCorner = Instance.new("UICorner", TopBar)
    TopBarCorner.CornerRadius = UDim.new(0, 6)
    
    local TopBarFix = Instance.new("Frame", TopBar)
    TopBarFix.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 1, -6)
    TopBarFix.Size = UDim2.new(1, 0, 0, 6)
    
    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 20, 0, 0)
    Logo.Size = UDim2.new(0, 150, 1, 0)
    Logo.Font = Enum.Font.GothamBold
    Logo.Text = Title
    Logo.TextColor3 = Color3.new(1, 1, 1)
    Logo.TextSize = 18
    Logo.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Save Button
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Parent = TopBar
    SaveBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
    SaveBtn.BorderSizePixel = 0
    SaveBtn.Position = UDim2.new(0, 250, 0.5, -15)
    SaveBtn.Size = UDim2.new(0, 80, 0, 30)
    SaveBtn.Font = Enum.Font.Gotham
    SaveBtn.Text = "💾 Save"
    SaveBtn.TextColor3 = Color3.new(1, 1, 1)
    SaveBtn.TextSize = 13
    SaveBtn.AutoButtonColor = false
    Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 4)
    
    -- Config Dropdown
    local ConfigBtn = Instance.new("TextButton")
    ConfigBtn.Parent = TopBar
    ConfigBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
    ConfigBtn.BorderSizePixel = 0
    ConfigBtn.Position = UDim2.new(0, 350, 0.5, -15)
    ConfigBtn.Size = UDim2.new(0, 120, 0, 30)
    ConfigBtn.Font = Enum.Font.Gotham
    ConfigBtn.Text = "Global ▼"
    ConfigBtn.TextColor3 = Color3.new(1, 1, 1)
    ConfigBtn.TextSize = 13
    ConfigBtn.AutoButtonColor = false
    Instance.new("UICorner", ConfigBtn).CornerRadius = UDim.new(0, 4)
    
    -- Left Sidebar
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(16, 18, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 180, 1, -50)
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Color3.fromRGB(14, 142, 212)
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 2)
    
    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 180, 0, 50)
    Content.Size = UDim2.new(1, -180, 1, -50)
    Content.ClipsDescendants = true
    
    -- Player Info
    local PlayerInfo = Instance.new("Frame")
    PlayerInfo.Parent = Sidebar
    PlayerInfo.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    PlayerInfo.BorderSizePixel = 0
    PlayerInfo.Position = UDim2.new(0, 0, 1, -60)
    PlayerInfo.Size = UDim2.new(1, 0, 0, 60)
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Parent = PlayerInfo
    Avatar.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    Avatar.BorderSizePixel = 0
    Avatar.Position = UDim2.new(0, 10, 0.5, -20)
    Avatar.Size = UDim2.new(0, 40, 0, 40)
    Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
    
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Parent = PlayerInfo
    PlayerName.BackgroundTransparency = 1
    PlayerName.Position = UDim2.new(0, 60, 0, 10)
    PlayerName.Size = UDim2.new(1, -70, 0, 20)
    PlayerName.Font = Enum.Font.GothamSemibold
    PlayerName.Text = "Loading..."
    PlayerName.TextColor3 = Color3.new(1, 1, 1)
    PlayerName.TextSize = 13
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    
    local SubText = Instance.new("TextLabel")
    SubText.Parent = PlayerInfo
    SubText.BackgroundTransparency = 1
    SubText.Position = UDim2.new(0, 60, 0, 30)
    SubText.Size = UDim2.new(1, -70, 0, 20)
    SubText.Font = Enum.Font.Gotham
    SubText.Text = "Till: 02.10 15:04"
    SubText.TextColor3 = Color3.fromRGB(100, 150, 200)
    SubText.TextSize = 11
    SubText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Load player info
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
    
    -- Toggle visibility
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Keybind then
            visible = not visible
            if visible then
                Main.Visible = true
                TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -400, 0.5, -250)}):Play()
            else
                local tween = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -400, -0.5, -250)})
                tween:Play()
                tween.Completed:Connect(function() if not visible then Main.Visible = false end end)
            end
        end
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Create Tab Function
    function Window:CreateTab(name, icon)
        local Tab = {Name = name, Categories = {}}
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.AutoButtonColor = false
        TabBtn.Text = ""
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 15, 0, 0)
        TabIcon.Size = UDim2.new(0, 20, 1, 0)
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.Text = icon or "•"
        TabIcon.TextColor3 = Color3.fromRGB(14, 142, 212)
        TabIcon.TextSize = 16
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Parent = TabBtn
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.Text = name
        TabLabel.TextColor3 = Color3.new(1, 1, 1)
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tab Content (2 columns)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = Content
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(14, 142, 212)
        TabContent.Visible = false
        
        local ContentPadding = Instance.new("UIPadding", TabContent)
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.PaddingBottom = UDim.new(0, 15)
        
        -- Left Column
        local LeftColumn = Instance.new("Frame")
        LeftColumn.Parent = TabContent
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Position = UDim2.new(0, 0, 0, 0)
        LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Parent = LeftColumn
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 15)
        
        -- Right Column
        local RightColumn = Instance.new("Frame")
        RightColumn.Parent = TabContent
        RightColumn.BackgroundTransparency = 1
        RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
        RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Parent = RightColumn
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 15)
        
        -- Auto update canvas
        local function updateCanvas()
            local leftHeight = LeftLayout.AbsoluteContentSize.Y
            local rightHeight = RightLayout.AbsoluteContentSize.Y
            TabContent.CanvasSize = UDim2.new(0, 0, 0, math.max(leftHeight, rightHeight) + 30)
        end
        
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        
        -- Tab switching
        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundTransparency = 1
                tab.Content.Visible = false
            end
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Color3.fromRGB(14, 142, 212)
            TabContent.Visible = true
        end)
        
        Tab.Button = TabBtn
        Tab.Content = TabContent
        Tab.LeftColumn = LeftColumn
        Tab.RightColumn = RightColumn
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Color3.fromRGB(14, 142, 212)
            TabContent.Visible = true
        end
        
        -- Create Section (Category)
        function Tab:CreateSection(sectionName, column)
            column = column or "left"
            local parent = column == "left" and LeftColumn or RightColumn
            
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Parent = parent
            SectionFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 4)
            
            local SectionPadding = Instance.new("UIPadding", SectionFrame)
            SectionPadding.PaddingLeft = UDim.new(0, 12)
            SectionPadding.PaddingRight = UDim.new(0, 12)
            SectionPadding.PaddingTop = UDim.new(0, 10)
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = SectionFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 0, 25)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Color3.new(1, 1, 1)
            SectionLabel.TextSize = 14
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Parent = SectionFrame
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Position = UDim2.new(0, 0, 0, 30)
            ElementsContainer.Size = UDim2.new(1, 0, 0, 0)
            ElementsContainer.AutomaticSize = Enum.AutomaticSize.Y
            
            local ElementsLayout = Instance.new("UIListLayout")
            ElementsLayout.Parent = ElementsContainer
            ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ElementsLayout.Padding = UDim.new(0, 8)
            
            Section.Frame = SectionFrame
            Section.Container = ElementsContainer
            
            -- Toggle
            function Section:CreateToggle(text, default, callback)
                local Toggle = {Value = default or false}
                callback = callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Parent = ElementsContainer
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Parent = ToggleFrame
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = text
                ToggleLabel.TextColor3 = Color3.new(1, 1, 1)
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local SettingsBtn = Instance.new("TextButton")
                SettingsBtn.Parent = ToggleFrame
                SettingsBtn.BackgroundTransparency = 1
                SettingsBtn.Position = UDim2.new(1, -50, 0, 0)
                SettingsBtn.Size = UDim2.new(0, 20, 0, 24)
                SettingsBtn.Font = Enum.Font.Gotham
                SettingsBtn.Text = "⚙"
                SettingsBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
                SettingsBtn.TextSize = 14
                SettingsBtn.AutoButtonColor = false
                
                local ToggleBtn = Instance.new("Frame")
                ToggleBtn.Parent = ToggleFrame
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 46)
                ToggleBtn.Position = UDim2.new(1, -25, 0.5, -8)
                ToggleBtn.Size = UDim2.new(0, 16, 0, 16)
                Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
                
                local function update()
                    if Toggle.Value then
                        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(14, 142, 212)}):Play()
                    else
                        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 42, 46)}):Play()
                    end
                    pcall(callback, Toggle.Value)
                end
                
                local ClickDetector = Instance.new("TextButton")
                ClickDetector.Parent = ToggleFrame
                ClickDetector.BackgroundTransparency = 1
                ClickDetector.Size = UDim2.new(1, 0, 1, 0)
                ClickDetector.Text = ""
                ClickDetector.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    update()
                end)
                
                update()
                function Toggle:Set(v) Toggle.Value = v update() end
                return Toggle
            end
            
            -- Slider
            function Section:CreateSlider(text, min, max, default, callback)
                local Slider = {Value = default or min}
                callback = callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Parent = ElementsContainer
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Parent = SliderFrame
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Size = UDim2.new(1, -40, 0, 20)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = text
                SliderLabel.TextColor3 = Color3.new(1, 1, 1)
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Parent = SliderFrame
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(1, -40, 0, 0)
                ValueLabel.Size = UDim2.new(0, 40, 0, 20)
                ValueLabel.Font = Enum.Font.GothamSemibold
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Color3.fromRGB(14, 142, 212)
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
                SliderBar.Position = UDim2.new(0, 0, 0, 24)
                SliderBar.Size = UDim2.new(1, 0, 0, 4)
                Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = Color3.fromRGB(14, 142, 212)
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
                
                local dragging = false
                
                local function update(v)
                    Slider.Value = math.clamp(v, min, max)
                    local percent = (Slider.Value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(math.floor(Slider.Value))
                    pcall(callback, Slider.Value)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        update(min + (max - min) * percent)
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        update(min + (max - min) * percent)
                    end
                end)
                
                update(default)
                function Slider:Set(v) update(v) end
                return Slider
            end
            
            -- Dropdown
            function Section:CreateDropdown(text, options, default, callback)
                local Dropdown = {Value = default or (options[1] or "None"), Options = options}
                callback = callback or function() end
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Parent = ElementsContainer
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, 0, 0, 24)
                DropdownFrame.ClipsDescendants = false
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Parent = DropdownFrame
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = text
                DropdownLabel.TextColor3 = Color3.new(1, 1, 1)
                DropdownLabel.TextSize = 12
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local DropdownBtn = Instance.new("TextButton")
                DropdownBtn.Parent = DropdownFrame
                DropdownBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                DropdownBtn.Position = UDim2.new(0.5, 5, 0, 0)
                DropdownBtn.Size = UDim2.new(0.5, -5, 0, 24)
                DropdownBtn.Font = Enum.Font.Gotham
                DropdownBtn.Text = Dropdown.Value
                DropdownBtn.TextColor3 = Color3.new(1, 1, 1)
                DropdownBtn.TextSize = 11
                DropdownBtn.AutoButtonColor = false
                Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 4)
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Parent = DropdownBtn
                DropdownList.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                DropdownList.Position = UDim2.new(0, 0, 1, 2)
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Visible = false
                DropdownList.ZIndex = 10
                Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 4)
                
                local ListLayout = Instance.new("UIListLayout", DropdownList)
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local isOpen = false
                
                DropdownBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        DropdownList.Size = UDim2.new(1, 0, 0, #options * 24)
                        DropdownList.Visible = true
                    else
                        DropdownList.Visible = false
                    end
                end)
                
                for _, option in ipairs(options) do
                    local OptionBtn = Instance.new("TextButton")
                    OptionBtn.Parent = DropdownList
                    OptionBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                    OptionBtn.BorderSizePixel = 0
                    OptionBtn.Size = UDim2.new(1, 0, 0, 24)
                    OptionBtn.Font = Enum.Font.Gotham
                    OptionBtn.Text = option
                    OptionBtn.TextColor3 = Color3.new(1, 1, 1)
                    OptionBtn.TextSize = 11
                    OptionBtn.AutoButtonColor = false
                    OptionBtn.ZIndex = 11
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        Dropdown.Value = option
                        DropdownBtn.Text = option
                        DropdownList.Visible = false
                        isOpen = false
                        pcall(callback, option)
                    end)
                end
                
                function Dropdown:Set(v) Dropdown.Value = v DropdownBtn.Text = v pcall(callback, v) end
                return Dropdown
            end
            
            -- Button
            function Section:CreateButton(text, callback)
                callback = callback or function() end
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Parent = ElementsContainer
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(14, 142, 212)
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
                ButtonFrame.AutoButtonColor = false
                ButtonFrame.Font = Enum.Font.GothamSemibold
                ButtonFrame.Text = text
                ButtonFrame.TextColor3 = Color3.new(1, 1, 1)
                ButtonFrame.TextSize = 13
                Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 4)
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(10, 110, 170)}):Play()
                    wait(0.1)
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(14, 142, 212)}):Play()
                    pcall(callback)
                end)
                
                return ButtonFrame
            end
            
            -- Label
            function Section:CreateLabel(text)
                local LabelFrame = Instance.new("TextLabel")
                LabelFrame.Parent = ElementsContainer
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Size = UDim2.new(1, 0, 0, 20)
                LabelFrame.Font = Enum.Font.Gotham
                LabelFrame.Text = text
                LabelFrame.TextColor3 = Color3.fromRGB(180, 180, 180)
                LabelFrame.TextSize = 12
                LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
                
                function LabelFrame:Set(t) LabelFrame.Text = t end
                return LabelFrame
            end
            
            -- Textbox
            function Section:CreateTextbox(text, placeholder, callback)
                callback = callback or function() end
                
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Parent = ElementsContainer
                TextboxFrame.BackgroundTransparency = 1
                TextboxFrame.Size = UDim2.new(1, 0, 0, 24)
                
                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Parent = TextboxFrame
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Size = UDim2.new(0.5, 0, 1, 0)
                TextboxLabel.Font = Enum.Font.Gotham
                TextboxLabel.Text = text
                TextboxLabel.TextColor3 = Color3.new(1, 1, 1)
                TextboxLabel.TextSize = 12
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local Textbox = Instance.new("TextBox")
                Textbox.Parent = TextboxFrame
                Textbox.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                Textbox.Position = UDim2.new(0.5, 5, 0, 0)
                Textbox.Size = UDim2.new(0.5, -5, 0, 24)
                Textbox.Font = Enum.Font.Gotham
                Textbox.PlaceholderText = placeholder or ""
                Textbox.Text = ""
                Textbox.TextColor3 = Color3.new(1, 1, 1)
                Textbox.TextSize = 11
                Textbox.ClearTextOnFocus = false
                Instance.new("UICorner", Textbox).CornerRadius = UDim.new(0, 4)
                
                Textbox.FocusLost:Connect(function(enter)
                    if enter then
                        pcall(callback, Textbox.Text)
                    end
                end)
                
                return Textbox
            end
            
            -- Keybind
            function Section:CreateKeybind(text, default, callback)
                callback = callback or function() end
                local currentKey = default or Enum.KeyCode.E
                local listening = false
                
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Parent = ElementsContainer
                KeybindFrame.BackgroundTransparency = 1
                KeybindFrame.Size = UDim2.new(1, 0, 0, 24)
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Parent = KeybindFrame
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
                KeybindLabel.Font = Enum.Font.Gotham
                KeybindLabel.Text = text
                KeybindLabel.TextColor3 = Color3.new(1, 1, 1)
                KeybindLabel.TextSize = 12
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local KeybindBtn = Instance.new("TextButton")
                KeybindBtn.Parent = KeybindFrame
                KeybindBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                KeybindBtn.Position = UDim2.new(0.6, 5, 0, 0)
                KeybindBtn.Size = UDim2.new(0.4, -5, 0, 24)
                KeybindBtn.Font = Enum.Font.Gotham
                KeybindBtn.Text = currentKey.Name
                KeybindBtn.TextColor3 = Color3.new(1, 1, 1)
                KeybindBtn.TextSize = 11
                KeybindBtn.AutoButtonColor = false
                Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 4)
                
                KeybindBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindBtn.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input, gp)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindBtn.Text = currentKey.Name
                        listening = false
                    end
                    
                    if not gp and input.KeyCode == currentKey then
                        pcall(callback)
                    end
                end)
                
                return KeybindBtn
            end
            
            -- Multi Dropdown (Checkbox list)
            function Section:CreateMultiDropdown(text, options, callback)
                callback = callback or function() end
                local selected = {}
                
                local MultiFrame = Instance.new("Frame")
                MultiFrame.Parent = ElementsContainer
                MultiFrame.BackgroundTransparency = 1
                MultiFrame.Size = UDim2.new(1, 0, 0, 24)
                MultiFrame.ClipsDescendants = false
                
                local MultiLabel = Instance.new("TextLabel")
                MultiLabel.Parent = MultiFrame
                MultiLabel.BackgroundTransparency = 1
                MultiLabel.Size = UDim2.new(0.5, 0, 1, 0)
                MultiLabel.Font = Enum.Font.Gotham
                MultiLabel.Text = text
                MultiLabel.TextColor3 = Color3.new(1, 1, 1)
                MultiLabel.TextSize = 12
                MultiLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local MultiBtn = Instance.new("TextButton")
                MultiBtn.Parent = MultiFrame
                MultiBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                MultiBtn.Position = UDim2.new(0.5, 5, 0, 0)
                MultiBtn.Size = UDim2.new(0.5, -5, 0, 24)
                MultiBtn.Font = Enum.Font.Gotham
                MultiBtn.Text = "Select..."
                MultiBtn.TextColor3 = Color3.new(1, 1, 1)
                MultiBtn.TextSize = 11
                MultiBtn.AutoButtonColor = false
                Instance.new("UICorner", MultiBtn).CornerRadius = UDim.new(0, 4)
                
                local MultiList = Instance.new("Frame")
                MultiList.Parent = MultiBtn
                MultiList.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                MultiList.Position = UDim2.new(0, 0, 1, 2)
                MultiList.Size = UDim2.new(1, 0, 0, 0)
                MultiList.Visible = false
                MultiList.ZIndex = 10
                Instance.new("UICorner", MultiList).CornerRadius = UDim.new(0, 4)
                
                local ListLayout = Instance.new("UIListLayout", MultiList)
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local isOpen = false
                
                MultiBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        MultiList.Size = UDim2.new(1, 0, 0, #options * 24)
                        MultiList.Visible = true
                    else
                        MultiList.Visible = false
                    end
                end)
                
                for _, option in ipairs(options) do
                    local OptionFrame = Instance.new("Frame")
                    OptionFrame.Parent = MultiList
                    OptionFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 28)
                    OptionFrame.BorderSizePixel = 0
                    OptionFrame.Size = UDim2.new(1, 0, 0, 24)
                    OptionFrame.ZIndex = 11
                    
                    local OptionLabel = Instance.new("TextLabel")
                    OptionLabel.Parent = OptionFrame
                    OptionLabel.BackgroundTransparency = 1
                    OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                    OptionLabel.Size = UDim2.new(1, -30, 1, 0)
                    OptionLabel.Font = Enum.Font.Gotham
                    OptionLabel.Text = option
                    OptionLabel.TextColor3 = Color3.new(1, 1, 1)
                    OptionLabel.TextSize = 11
                    OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                    OptionLabel.ZIndex = 11
                    
                    local Checkbox = Instance.new("Frame")
                    Checkbox.Parent = OptionFrame
                    Checkbox.BackgroundColor3 = Color3.fromRGB(40, 42, 46)
                    Checkbox.Position = UDim2.new(1, -20, 0.5, -6)
                    Checkbox.Size = UDim2.new(0, 12, 0, 12)
                    Checkbox.ZIndex = 11
                    Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(0, 2)
                    
                    local OptionBtn = Instance.new("TextButton")
                    OptionBtn.Parent = OptionFrame
                    OptionBtn.BackgroundTransparency = 1
                    OptionBtn.Size = UDim2.new(1, 0, 1, 0)
                    OptionBtn.Text = ""
                    OptionBtn.ZIndex = 12
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        if selected[option] then
                            selected[option] = nil
                            Checkbox.BackgroundColor3 = Color3.fromRGB(40, 42, 46)
                        else
                            selected[option] = true
                            Checkbox.BackgroundColor3 = Color3.fromRGB(14, 142, 212)
                        end
                        pcall(callback, selected)
                    end)
                end
                
                return MultiBtn
            end
            
            -- Color Picker
            function Section:CreateColorPicker(text, default, callback)
                callback = callback or function() end
                local currentColor = default or Color3.fromRGB(255, 255, 255)
                
                local ColorFrame = Instance.new("Frame")
                ColorFrame.Parent = ElementsContainer
                ColorFrame.BackgroundTransparency = 1
                ColorFrame.Size = UDim2.new(1, 0, 0, 24)
                
                local ColorLabel = Instance.new("TextLabel")
                ColorLabel.Parent = ColorFrame
                ColorLabel.BackgroundTransparency = 1
                ColorLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ColorLabel.Font = Enum.Font.Gotham
                ColorLabel.Text = text
                ColorLabel.TextColor3 = Color3.new(1, 1, 1)
                ColorLabel.TextSize = 12
                ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ColorBtn = Instance.new("TextButton")
                ColorBtn.Parent = ColorFrame
                ColorBtn.BackgroundColor3 = currentColor
                ColorBtn.Position = UDim2.new(0.85, 0, 0.5, -10)
                ColorBtn.Size = UDim2.new(0, 20, 0, 20)
                ColorBtn.Text = ""
                ColorBtn.AutoButtonColor = false
                Instance.new("UICorner", ColorBtn).CornerRadius = UDim.new(0, 4)
                
                local ColorPicker = Instance.new("Frame")
                ColorPicker.Parent = ColorFrame
                ColorPicker.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
                ColorPicker.Position = UDim2.new(1, 5, 0, 0)
                ColorPicker.Size = UDim2.new(0, 200, 0, 180)
                ColorPicker.Visible = false
                ColorPicker.ZIndex = 15
                Instance.new("UICorner", ColorPicker).CornerRadius = UDim.new(0, 6)
                
                local Hue = 0
                local Sat = 1
                local Val = 1
                
                -- RGB Picker
                local RGBFrame = Instance.new("ImageButton")
                RGBFrame.Parent = ColorPicker
                RGBFrame.BackgroundColor3 = Color3.new(1, 1, 1)
                RGBFrame.Position = UDim2.new(0, 10, 0, 10)
                RGBFrame.Size = UDim2.new(0, 140, 0, 140)
                RGBFrame.Image = "rbxassetid://4155801252"
                RGBFrame.ZIndex = 16
                
                local RGBCursor = Instance.new("Frame")
                RGBCursor.Parent = RGBFrame
                RGBCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                RGBCursor.BorderColor3 = Color3.new(0, 0, 0)
                RGBCursor.BorderSizePixel = 2
                RGBCursor.Size = UDim2.new(0, 8, 0, 8)
                RGBCursor.ZIndex = 17
                Instance.new("UICorner", RGBCursor).CornerRadius = UDim.new(1, 0)
                
                -- Hue Bar
                local HueBar = Instance.new("ImageButton")
                HueBar.Parent = ColorPicker
                HueBar.BackgroundColor3 = Color3.new(1, 1, 1)
                HueBar.Position = UDim2.new(0, 160, 0, 10)
                HueBar.Size = UDim2.new(0, 30, 0, 140)
                HueBar.Image = "rbxassetid://3641079629"
                HueBar.ImageColor3 = Color3.new(1, 1, 1)
                HueBar.ZIndex = 16
                
                local HueCursor = Instance.new("Frame")
                HueCursor.Parent = HueBar
                HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                HueCursor.BorderColor3 = Color3.new(0, 0, 0)
                HueCursor.BorderSizePixel = 2
                HueCursor.Size = UDim2.new(1, 0, 0, 4)
                HueCursor.ZIndex = 17
                
                local HexBox = Instance.new("TextBox")
                HexBox.Parent = ColorPicker
                HexBox.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
                HexBox.Position = UDim2.new(0, 10, 0, 155)
                HexBox.Size = UDim2.new(0, 180, 0, 20)
                HexBox.Font = Enum.Font.Gotham
                HexBox.Text = "#FFFFFF"
                HexBox.TextColor3 = Color3.new(1, 1, 1)
                HexBox.TextSize = 11
                HexBox.ZIndex = 16
                Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 4)
                
                local function updateColor()
                    currentColor = Color3.fromHSV(Hue, Sat, Val)
                    ColorBtn.BackgroundColor3 = currentColor
                    RGBFrame.ImageColor3 = Color3.fromHSV(Hue, 1, 1)
                    HexBox.Text = string.format("#%02X%02X%02X", 
                        math.floor(currentColor.R * 255),
                        math.floor(currentColor.G * 255),
                        math.floor(currentColor.B * 255))
                    pcall(callback, currentColor)
                end
                
                local rgbDragging = false
                local hueDragging = false
                
                RGBFrame.MouseButton1Down:Connect(function()
                    rgbDragging = true
                end)
                
                HueBar.MouseButton1Down:Connect(function()
                    hueDragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        rgbDragging = false
                        hueDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if rgbDragging then
                            local mouse = UserInputService:GetMouseLocation()
                            local relX = math.clamp((mouse.X - RGBFrame.AbsolutePosition.X) / RGBFrame.AbsoluteSize.X, 0, 1)
                            local relY = math.clamp((mouse.Y - RGBFrame.AbsolutePosition.Y) / RGBFrame.AbsoluteSize.Y, 0, 1)
                            Sat = relX
                            Val = 1 - relY
                            RGBCursor.Position = UDim2.new(relX, -4, relY, -4)
                            updateColor()
                        elseif hueDragging then
                            local mouse = UserInputService:GetMouseLocation()
                            local relY = math.clamp((mouse.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            Hue = relY
                            HueCursor.Position = UDim2.new(0, 0, relY, -2)
                            updateColor()
                        end
                    end
                end)
                
                ColorBtn.MouseButton1Click:Connect(function()
                    ColorPicker.Visible = not ColorPicker.Visible
                end)
                
                updateColor()
                
                return ColorBtn
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Library
