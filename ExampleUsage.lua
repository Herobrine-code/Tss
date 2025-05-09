-- Example Usage of CustomUILibrary
local UILibrary = require(game.ReplicatedStorage:WaitForChild("CustomUILibrary")) -- Adjust path as needed

-- Create a window
local window = UILibrary.CreateWindow("Example UI", UDim2.new(0, 300, 0, 350))

-- Add a label
local statusLabel = window.CreateLabel("Status: Ready")

-- Create a section for settings
local settingsSection = window.CreateSection("Settings")

-- Add a toggle for enabling/disabling a feature
local toggleButton = window.CreateToggle("Feature Enabled", false, function(state)
    if state then
        statusLabel.SetText("Status: Feature is enabled")
    else
        statusLabel.SetText("Status: Feature is disabled")
    end
end)

-- Add an input field
local inputField = window.CreateTextInput("Value:", "100", function(text)
    print("Input value changed to: " .. text)
end)

-- Create a section for hotkeys
local hotkeysSection = window.CreateSection("Hotkeys")

-- Add keybinds
local speedIncreaseKey = window.CreateKeybind("Increase Value:", Enum.KeyCode.E, function()
    local currentValue = tonumber(inputField.GetText()) or 0
    inputField.SetText(tostring(currentValue + 10))
end)

local speedDecreaseKey = window.CreateKeybind("Decrease Value:", Enum.KeyCode.Q, function()
    local currentValue = tonumber(inputField.GetText()) or 0
    inputField.SetText(tostring(math.max(0, currentValue - 10)))
end)

-- Create action buttons
local actionsSection = window.CreateSection("Actions")

local applyButton = window.CreateButton("Apply Changes", Color3.fromRGB(0, 120, 40), function()
    statusLabel.SetText("Status: Changes applied!")
    wait(2)
    statusLabel.SetText("Status: Ready")
end)

local resetButton = window.CreateButton("Reset All", Color3.fromRGB(180, 40, 40), function()
    toggleButton.SetState(false)
    inputField.SetText("100")
    statusLabel.SetText("Status: All settings reset")
end)

-- Set a custom key to hide/show the UI
window.SetHideKey(Enum.KeyCode.RightControl)

-- Notice to console
print("UI Library Example loaded! Press RightControl to hide/show the UI.") 