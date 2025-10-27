-- Пример использования Neverlose UI Library
-- Загрузка через loadstring:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/neverlose_library.lua"))()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/neverlose_library.lua"))()

-- Создание окна
local Window = Library:CreateWindow({
    Title = "NEVERLOSE",
    Keybind = Enum.KeyCode.Insert
})

-- Создание вкладки Rage
local RageTab = Window:CreateTab("Rage", "🎯")

RageTab:CreateSection("Aimbot Settings")

RageTab:CreateToggle("Enable Aimbot", false, function(value)
    print("Aimbot:", value)
end)

RageTab:CreateToggle("Silent Aim", false, function(value)
    print("Silent Aim:", value)
end)

RageTab:CreateSlider("FOV", 0, 360, 90, function(value)
    print("FOV:", value)
end)

RageTab:CreateSection("Triggerbot")

RageTab:CreateToggle("Enable Triggerbot", false, function(value)
    print("Triggerbot:", value)
end)

RageTab:CreateSlider("Delay (ms)", 0, 500, 50, function(value)
    print("Delay:", value)
end)

-- Создание вкладки Legit
local LegitTab = Window:CreateTab("Legit", "🎮")

LegitTab:CreateSection("Legit Aimbot")

LegitTab:CreateToggle("Enable", false, function(value)
    print("Legit Aimbot:", value)
end)

LegitTab:CreateSlider("Smoothness", 1, 100, 50, function(value)
    print("Smoothness:", value)
end)

LegitTab:CreateSlider("FOV", 0, 180, 45, function(value)
    print("Legit FOV:", value)
end)

LegitTab:CreateSection("Recoil Control")

LegitTab:CreateToggle("No Recoil", false, function(value)
    print("No Recoil:", value)
end)

-- Создание вкладки Visuals
local VisualsTab = Window:CreateTab("Visuals", "👁️")

VisualsTab:CreateSection("ESP Settings")

VisualsTab:CreateToggle("Box ESP", false, function(value)
    print("Box ESP:", value)
end)

VisualsTab:CreateToggle("Name ESP", false, function(value)
    print("Name ESP:", value)
end)

VisualsTab:CreateToggle("Health ESP", false, function(value)
    print("Health ESP:", value)
end)

VisualsTab:CreateToggle("Distance ESP", false, function(value)
    print("Distance ESP:", value)
end)

VisualsTab:CreateSection("World")

VisualsTab:CreateToggle("Fullbright", false, function(value)
    print("Fullbright:", value)
end)

VisualsTab:CreateSlider("Ambient", 0, 100, 50, function(value)
    print("Ambient:", value)
end)

-- Создание вкладки Skinchanger
local SkinTab = Window:CreateTab("Skinchanger", "🎨")

SkinTab:CreateSection("Weapon Skins")

SkinTab:CreateLabel("Select your weapon skin")

SkinTab:CreateButton("Random Skin", function()
    print("Random skin applied!")
end)

SkinTab:CreateToggle("Force Skin", false, function(value)
    print("Force Skin:", value)
end)

-- Создание вкладки Miscellaneous
local MiscTab = Window:CreateTab("Miscellaneous", "⚙️")

MiscTab:CreateSection("Movement")

MiscTab:CreateToggle("Bunny Hop", false, function(value)
    print("Bunny Hop:", value)
end)

MiscTab:CreateSlider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed:", value)
    if value > 16 then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

MiscTab:CreateSlider("Jump Power", 50, 200, 50, function(value)
    print("Jump Power:", value)
    if value > 50 then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

MiscTab:CreateSection("Utilities")

MiscTab:CreateToggle("Anti-AFK", false, function(value)
    print("Anti-AFK:", value)
end)

MiscTab:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

-- Создание вкладки Configs
local ConfigTab = Window:CreateTab("Configs", "💾")

ConfigTab:CreateSection("Configuration")

ConfigTab:CreateLabel("Save and load your settings")

ConfigTab:CreateButton("Save Config", function()
    print("Config saved!")
end)

ConfigTab:CreateButton("Load Config", function()
    print("Config loaded!")
end)

ConfigTab:CreateButton("Reset Config", function()
    print("Config reset!")
end)

ConfigTab:CreateSection("Info")

ConfigTab:CreateLabel("Neverlose UI v1.0")
ConfigTab:CreateLabel("Press INSERT to toggle menu")

print("Neverlose UI loaded successfully!")
