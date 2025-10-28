-- Пример использования Neverlose UI v2.0
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/W3bs1teH0st3d/neverpuzo-UI/main/neverlose_v2.lua"))()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/W3bs1teH0st3d/neverpuzo-UI/main/neverlose_v2.lua"))()

-- Создание окна
local Window = Library:CreateWindow({
    Title = "NEVERLOSE",
    Keybind = Enum.KeyCode.Insert
})

-- ========== RAGEBOT TAB ==========
local RageTab = Window:CreateTab("Ragebot", "⚡")

-- Left Column - Main
local MainSection = RageTab:CreateSection("Main", "left")

MainSection:CreateToggle("Enabled", false, function(value)
    print("Ragebot Enabled:", value)
end)

MainSection:CreateToggle("Peek Assist", false, function(value)
    print("Peek Assist:", value)
end)

MainSection:CreateToggle("Hide Shots", false, function(value)
    print("Hide Shots:", value)
end)

MainSection:CreateToggle("Double Tap", false, function(value)
    print("Double Tap:", value)
end)

MainSection:CreateSlider("Field of View", 0, 180, 90, function(value)
    print("FOV:", value)
end)

-- Left Column - Selection
local SelectionSection = RageTab:CreateSection("Selection", "left")

SelectionSection:CreateMultiDropdown("Hitboxes", {"Head", "Stomach", "Chest", "Arms", "Legs"}, function(selected)
    print("Selected hitboxes:", selected)
end)

SelectionSection:CreateDropdown("Multipoint", {"Head, Stomach", "Head", "Custom"}, "Head, Stomach", function(value)
    print("Multipoint:", value)
end)

SelectionSection:CreateSlider("Hit Chance", 0, 100, 60, function(value)
    print("Hit Chance:", value)
end)

SelectionSection:CreateSlider("Minimum Damage", 0, 100, 30, function(value)
    print("Min Damage:", value)
end)

SelectionSection:CreateToggle("Penetrate Walls", false, function(value)
    print("Penetrate Walls:", value)
end)

-- Right Column - Accuracy
local AccuracySection = RageTab:CreateSection("Accuracy", "right")

AccuracySection:CreateToggle("Auto Scope", false, function(value)
    print("Auto Scope:", value)
end)

AccuracySection:CreateToggle("Auto Stop", false, function(value)
    print("Auto Stop:", value)
end)

-- Right Column - Safety
local SafetySection = RageTab:CreateSection("Safety", "right")

SafetySection:CreateDropdown("Body Aim", {"Default", "Force", "Prefer"}, "Default", function(value)
    print("Body Aim:", value)
end)

SafetySection:CreateDropdown("Safe Points", {"Prefer", "Force", "Off"}, "Prefer", function(value)
    print("Safe Points:", value)
end)

SafetySection:CreateDropdown("Ensure Hitbox Safety", {"Select", "Head", "Chest"}, "Select", function(value)
    print("Hitbox Safety:", value)
end)

-- ========== ANTI AIM TAB ==========
local AntiAimTab = Window:CreateTab("Anti Aim", "↻")

-- Left Column
local AAMainSection = AntiAimTab:CreateSection("Main", "left")

AAMainSection:CreateToggle("Enabled", false, function(value)
    print("Anti Aim Enabled:", value)
end)

AAMainSection:CreateDropdown("Pitch", {"Off", "Down", "Up", "Fake Down", "Fake Up"}, "Down", function(value)
    print("Pitch:", value)
end)

AAMainSection:CreateDropdown("Yaw Base", {"Local View", "At Targets"}, "Local View", function(value)
    print("Yaw Base:", value)
end)

AAMainSection:CreateSlider("Yaw", -180, 180, 0, function(value)
    print("Yaw:", value)
end)

AAMainSection:CreateSlider("Jitter", 0, 180, 0, function(value)
    print("Jitter:", value)
end)

-- Right Column
local AADesyncSection = AntiAimTab:CreateSection("Desync", "right")

AADesyncSection:CreateToggle("Enabled", false, function(value)
    print("Desync Enabled:", value)
end)

AADesyncSection:CreateSlider("Amount", 0, 100, 50, function(value)
    print("Desync Amount:", value)
end)

AADesyncSection:CreateDropdown("Side", {"Left", "Right", "Random"}, "Left", function(value)
    print("Desync Side:", value)
end)

-- ========== LEGITBOT TAB ==========
local LegitTab = Window:CreateTab("Legitbot", "🎯")

-- Left Column
local LegitMainSection = LegitTab:CreateSection("Main", "left")

LegitMainSection:CreateToggle("Enabled", false, function(value)
    print("Legitbot Enabled:", value)
end)

LegitMainSection:CreateSlider("Smoothness", 1, 100, 50, function(value)
    print("Smoothness:", value)
end)

LegitMainSection:CreateSlider("FOV", 0, 180, 45, function(value)
    print("Legit FOV:", value)
end)

LegitMainSection:CreateToggle("Recoil Control", false, function(value)
    print("Recoil Control:", value)
end)

-- Right Column
local LegitTriggerSection = LegitTab:CreateSection("Triggerbot", "right")

LegitTriggerSection:CreateToggle("Enabled", false, function(value)
    print("Triggerbot Enabled:", value)
end)

LegitTriggerSection:CreateSlider("Delay", 0, 500, 50, function(value)
    print("Trigger Delay:", value)
end)

-- ========== VISUALS TAB ==========
local VisualsTab = Window:CreateTab("Visuals", "👁")

-- Left Column - Players
local PlayersSection = VisualsTab:CreateSection("Players", "left")

PlayersSection:CreateToggle("Box ESP", false, function(value)
    print("Box ESP:", value)
end)

PlayersSection:CreateToggle("Name ESP", false, function(value)
    print("Name ESP:", value)
end)

PlayersSection:CreateToggle("Health ESP", false, function(value)
    print("Health ESP:", value)
end)

PlayersSection:CreateToggle("Distance ESP", false, function(value)
    print("Distance ESP:", value)
end)

PlayersSection:CreateToggle("Skeleton ESP", false, function(value)
    print("Skeleton ESP:", value)
end)

PlayersSection:CreateColorPicker("Box Color", Color3.fromRGB(255, 255, 255), function(color)
    print("Box Color:", color)
end)

-- Right Column - World
local WorldSection = VisualsTab:CreateSection("World", "right")

WorldSection:CreateToggle("Fullbright", false, function(value)
    print("Fullbright:", value)
    if value then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 100000
    end
end)

WorldSection:CreateSlider("Ambient", 0, 100, 50, function(value)
    print("Ambient:", value)
end)

WorldSection:CreateToggle("Remove Fog", false, function(value)
    print("Remove Fog:", value)
end)

-- ========== MISCELLANEOUS TAB ==========
local MiscTab = Window:CreateTab("Miscellaneous", "⚙")

-- Left Column - Movement
local MovementSection = MiscTab:CreateSection("Movement", "left")

MovementSection:CreateToggle("Bunny Hop", false, function(value)
    print("Bunny Hop:", value)
end)

MovementSection:CreateSlider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed:", value)
    if value > 16 then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

MovementSection:CreateSlider("Jump Power", 50, 200, 50, function(value)
    print("Jump Power:", value)
    if value > 50 then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

-- Right Column - Utilities
local UtilitiesSection = MiscTab:CreateSection("Utilities", "right")

UtilitiesSection:CreateToggle("Anti-AFK", false, function(value)
    print("Anti-AFK:", value)
end)

UtilitiesSection:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

UtilitiesSection:CreateKeybind("Menu Toggle", Enum.KeyCode.Insert, function()
    print("Menu toggled!")
end)

UtilitiesSection:CreateTextbox("Custom Text", "Enter text...", function(text)
    print("Entered text:", text)
end)

-- ========== CONFIGS TAB ==========
local ConfigTab = Window:CreateTab("Configs", "💾")

-- Left Column
local ConfigSection = ConfigTab:CreateSection("Configuration", "left")

ConfigSection:CreateLabel("Save and load your settings")

ConfigSection:CreateButton("Save Config", function()
    print("Config saved!")
end)

ConfigSection:CreateButton("Load Config", function()
    print("Config loaded!")
end)

ConfigSection:CreateButton("Reset Config", function()
    print("Config reset!")
end)

-- Right Column
local InfoSection = ConfigTab:CreateSection("Info", "right")

InfoSection:CreateLabel("Neverlose UI v2.0")
InfoSection:CreateLabel("Press INSERT to toggle menu")
InfoSection:CreateLabel("Made with ❤️")

print("✅ Neverlose UI v2.0 loaded successfully!")
print("📌 Press INSERT to toggle menu")
