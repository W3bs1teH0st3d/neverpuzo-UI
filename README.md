# Stable

- Коммиты небольшие делайте (что-то одно сделали и коммитнули, а не переписали пол проекта и коммитнули, коммиты маленькие должны быть)

## КАК КОММИТИТЬ???
### Начало
- качаешь GitHub CLI (https://cli.github.com/)
- устанавливаешь
- перезагрузи комп
- **перейди** в https://github.com/settings/tokens
- нажми “Generate new token (classic)”
- **выбери права**:
- repo (полный доступ к приватным репозиториям)
- workflow (если нужны GitHub Actions)
- скопируй токен (после закрытия страницы он не будет показан снова).
- `gh auth login`
- **выбери**:
- GitHub.com
- HTTPS
- Yes, authenticate with your GitHub credentials
- **вводи** токен, который копировал
### Сам коммит и пуш
- `git add <файл или папка, в которой изменения сделали>`
- `git commit -m "<комментарий к коммиту>"`
- `git push`

# Neverlose UI Library

Современная UI библиотека для Roblox инжекторов в стиле Neverlose.

## Особенности

- 🎨 Современный дизайн в стиле Neverlose
- 🔧 Легкая интеграция через loadstring
- 📱 Полностью функциональные элементы UI
- ⚡ Оптимизированная производительность
- 🎯 Поддержка табов, тогглов, слайдеров, кнопок

## Установка

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/neverlose_library.lua"))()
```

## Быстрый старт

```lua
-- Создание окна
local Window = Library:CreateWindow({
    Title = "NEVERLOSE",
    Keybind = Enum.KeyCode.Insert
})

-- Создание таба
local Tab = Window:CreateTab("Main", "🎯")

-- Создание секции
Tab:CreateSection("Settings")

-- Создание тоггла
Tab:CreateToggle("Enable Feature", false, function(value)
    print("Toggle:", value)
end)

-- Создание слайдера
Tab:CreateSlider("FOV", 0, 360, 90, function(value)
    print("FOV:", value)
end)

-- Создание кнопки
Tab:CreateButton("Click Me", function()
    print("Button clicked!")
end)

-- Создание лейбла
Tab:CreateLabel("Information text")
```

## Документация

### CreateWindow(config)
Создает главное окно UI.

**Параметры:**
- `Title` (string) - Название окна (по умолчанию: "NEVERLOSE")
- `Keybind` (KeyCode) - Клавиша для открытия/закрытия (по умолчанию: Insert)

**Возвращает:** Window объект

### Window:CreateTab(name, icon)
Создает новую вкладку.

**Параметры:**
- `name` (string) - Название вкладки
- `icon` (string) - Иконка вкладки (emoji или текст)

**Возвращает:** Tab объект

### Tab:CreateSection(text)
Создает секцию-заголовок.

**Параметры:**
- `text` (string) - Текст секции

### Tab:CreateToggle(text, default, callback)
Создает переключатель.

**Параметры:**
- `text` (string) - Название тоггла
- `default` (boolean) - Начальное значение
- `callback` (function) - Функция вызываемая при изменении

**Возвращает:** Toggle объект с методом `:Set(value)`

### Tab:CreateSlider(text, min, max, default, callback)
Создает слайдер.

**Параметры:**
- `text` (string) - Название слайдера
- `min` (number) - Минимальное значение
- `max` (number) - Максимальное значение
- `default` (number) - Начальное значение
- `callback` (function) - Функция вызываемая при изменении

**Возвращает:** Slider объект с методом `:Set(value)`

### Tab:CreateButton(text, callback)
Создает кнопку.

**Параметры:**
- `text` (string) - Текст кнопки
- `callback` (function) - Функция вызываемая при нажатии

### Tab:CreateLabel(text)
Создает текстовый лейбл.

**Параметры:**
- `text` (string) - Текст лейбла

**Возвращает:** Label объект с методом `:Set(text)`

## Пример использования

Смотрите `example.lua` для полного примера со всеми функциями.

## Лицензия

MIT License