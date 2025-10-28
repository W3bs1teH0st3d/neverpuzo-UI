# Neverlose UI Library v2.0

Полнофункциональная UI библиотека для Roblox инжекторов в стиле Neverlose CS2.

## ✨ Особенности

- 🎨 **Оригинальный дизайн** - 1 в 1 как в Neverlose CS2
- 📦 **Двухколоночная система** - Left/Right columns с категориями
- 🎯 **10 типов элементов** - Toggle, Slider, Dropdown, Button, Label, Textbox, Keybind, MultiDropdown, ColorPicker
- ⚡ **Плавные анимации** - TweenService для всех элементов
- 🔧 **Легкая интеграция** - Один loadstring для загрузки

## 📦 Установка

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/W3bs1teH0st3d/neverpuzo-UI/main/NeverloseUI/neverlose_v2.lua"))()
```

## 🚀 Быстрый старт

```lua
-- Создание окна
local Window = Library:CreateWindow({
    Title = "NEVERLOSE",
    Keybind = Enum.KeyCode.Insert
})

-- Создание таба
local Tab = Window:CreateTab("Ragebot", "⚡")

-- Создание секции (категории)
local MainSection = Tab:CreateSection("Main", "left") -- "left" или "right"

-- Добавление элементов
MainSection:CreateToggle("Enabled", false, function(value)
    print("Enabled:", value)
end)

MainSection:CreateSlider("FOV", 0, 180, 90, function(value)
    print("FOV:", value)
end)

MainSection:CreateDropdown("Mode", {"Option 1", "Option 2"}, "Option 1", function(value)
    print("Selected:", value)
end)
```

## 📚 Документация

### CreateWindow(config)
Создает главное окно.

**Параметры:**
- `Title` (string) - Название окна
- `Keybind` (KeyCode) - Клавиша для открытия/закрытия

### Window:CreateTab(name, icon)
Создает новую вкладку.

**Параметры:**
- `name` (string) - Название вкладки
- `icon` (string) - Иконка (emoji или символ)

### Tab:CreateSection(name, column)
Создает категорию (как Main, Selection, Accuracy в Neverlose).

**Параметры:**
- `name` (string) - Название секции
- `column` (string) - "left" или "right"

### Элементы UI

#### CreateToggle(text, default, callback)
Переключатель с иконкой настроек.

```lua
Section:CreateToggle("Enable Feature", false, function(value)
    print(value)
end)
```

#### CreateSlider(text, min, max, default, callback)
Слайдер с цветным значением.

```lua
Section:CreateSlider("FOV", 0, 180, 90, function(value)
    print(value)
end)
```

#### CreateDropdown(text, options, default, callback)
Выпадающий список.

```lua
Section:CreateDropdown("Mode", {"Option 1", "Option 2"}, "Option 1", function(value)
    print(value)
end)
```

#### CreateMultiDropdown(text, options, callback)
Множественный выбор с чекбоксами.

```lua
Section:CreateMultiDropdown("Hitboxes", {"Head", "Chest", "Legs"}, function(selected)
    for option, enabled in pairs(selected) do
        print(option, enabled)
    end
end)
```

#### CreateButton(text, callback)
Кнопка.

```lua
Section:CreateButton("Click Me", function()
    print("Clicked!")
end)
```

#### CreateLabel(text)
Текстовая метка.

```lua
local label = Section:CreateLabel("Info text")
label:Set("New text") -- Обновить текст
```

#### CreateTextbox(text, placeholder, callback)
Текстовое поле.

```lua
Section:CreateTextbox("Enter value", "Placeholder...", function(text)
    print("Entered:", text)
end)
```

#### CreateKeybind(text, default, callback)
Привязка клавиши.

```lua
Section:CreateKeybind("Keybind", Enum.KeyCode.E, function()
    print("Key pressed!")
end)
```

#### CreateColorPicker(text, default, callback)
Выбор цвета с RGB picker.

```lua
Section:CreateColorPicker("Color", Color3.fromRGB(255, 255, 255), function(color)
    print("Color:", color)
end)
```

## 🎮 Управление

- **INSERT** - Открыть/закрыть меню
- **ЛКМ** - Перетаскивание окна
- Все элементы полностью функциональны

## 📊 Статистика

- **994 строки** кода
- **10 типов** UI элементов
- **Двухколоночная** система
- **Полный пример** включен

## 📝 Пример

Смотрите `example_v2.lua` для полного примера со всеми функциями.

## 🔗 Ссылки

- GitHub: https://github.com/W3bs1teH0st3d/neverpuzo-UI
- Loadstring: `loadstring(game:HttpGet("https://raw.githubusercontent.com/W3bs1teH0st3d/neverpuzo-UI/main/NeverloseUI/neverlose_v2.lua"))()`

## 📜 Лицензия

MIT License
