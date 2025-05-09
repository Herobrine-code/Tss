-- Custom UI Library
local UILibrary = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Creation Functions
function UILibrary.CreateWindow(title, size)
    local window = {}
    
    -- Default parameters
    title = title or "UI Window"
    size = size or UDim2.new(0, 300, 0, 350)
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer.PlayerGui
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size
    mainFrame.Position = UDim2.new(0.8, -150, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = ScreenGui
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = mainFrame
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    titleBar.Parent = mainFrame
    
    -- Round corners for title bar
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    -- Fix corners for title bar
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Name = "CornerFix"
    titleCornerFix.Size = UDim2.new(1, 0, 0, 10)
    titleCornerFix.Position = UDim2.new(0, 0, 1, -10)
    titleCornerFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.ZIndex = 2
    titleCornerFix.Parent = titleBar
    
    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 2
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.ZIndex = 3
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -45)
    contentFrame.Position = UDim2.new(0, 10, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Set up hover effect for close button
    UILibrary.SetupButtonHover(closeButton, Color3.fromRGB(180, 0, 0), Color3.fromRGB(210, 0, 0))
    
    -- Hide GUI variable
    local isGuiVisible = true
    local hideKey = Enum.KeyCode.H
    
    -- Function to toggle GUI visibility
    function window.ToggleVisibility()
        isGuiVisible = not isGuiVisible
        mainFrame.Visible = isGuiVisible
        
        if not isGuiVisible then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = "GUI скрыт. Нажмите " .. hideKey.Name .. " чтобы показать.",
                Duration = 3
            })
        end
    end
    
    -- Set hide key function
    function window.SetHideKey(keyCode)
        hideKey = keyCode
    end
    
    -- Function to handle close
    function window.Close()
        ScreenGui:Destroy()
    end
    
    -- Connect close button
    closeButton.MouseButton1Click:Connect(window.Close)
    
    -- Connect hide key press
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == hideKey then
            window.ToggleVisibility()
        end
    end)
    
    -- Elements container
    window.Elements = {}
    window.ContentFrame = contentFrame
    window.MainFrame = mainFrame
    window.ScreenGui = ScreenGui
    
    -- Track element Y position for automatic layout
    window.NextElementYPosition = 0
    
    -- Create tabs function
    function window.CreateSection(sectionTitle)
        -- Add section separator
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(1, 0, 0, 1)
        separator.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        separator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        separator.BorderSizePixel = 0
        separator.Parent = contentFrame
        
        window.NextElementYPosition = window.NextElementYPosition + 5
        
        -- Add section title
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Name = "SectionTitle"
        sectionLabel.Size = UDim2.new(1, 0, 0, 20)
        sectionLabel.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = sectionTitle
        sectionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        sectionLabel.TextSize = 14
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = contentFrame
        
        window.NextElementYPosition = window.NextElementYPosition + 25
        
        return {
            AddElement = function(elementFunc, ...)
                return elementFunc(...)
            end
        }
    end
    
    -- Create label function
    function window.CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        
        window.NextElementYPosition = window.NextElementYPosition + 25
        
        local labelObj = {
            Instance = label,
            SetText = function(newText)
                label.Text = newText
            end
        }
        
        table.insert(window.Elements, labelObj)
        return labelObj
    end
    
    -- Create button function
    function window.CreateButton(text, color, callback)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = "ButtonFrame"
        buttonFrame.Size = UDim2.new(1, 0, 0, 30)
        buttonFrame.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Parent = contentFrame
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundColor3 = color or Color3.fromRGB(0, 120, 215)
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.GothamBold
        button.Parent = buttonFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = button
        
        -- Set up hover effect
        UILibrary.SetupButtonHover(button, color or Color3.fromRGB(0, 120, 215), UILibrary.LightenColor(color or Color3.fromRGB(0, 120, 215), 20))
        
        -- Connect callback
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        window.NextElementYPosition = window.NextElementYPosition + 35
        
        local buttonObj = {
            Instance = button,
            SetText = function(newText)
                button.Text = newText
            end,
            SetColor = function(newColor)
                button.BackgroundColor3 = newColor
                UILibrary.SetupButtonHover(button, newColor, UILibrary.LightenColor(newColor, 20))
            end
        }
        
        table.insert(window.Elements, buttonObj)
        return buttonObj
    end
    
    -- Create toggle button function
    function window.CreateToggle(text, defaultState, callback)
        local state = defaultState or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "ToggleFrame"
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = contentFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(120, 120, 120)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = state and "ENABLED" or "DISABLED"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextSize = 14
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.Parent = toggleFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 5)
        toggleCorner.Parent = toggleButton
        
        -- Add hover effect
        UILibrary.SetupButtonHover(
            toggleButton, 
            state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(120, 120, 120), 
            state and Color3.fromRGB(0, 140, 235) or Color3.fromRGB(140, 140, 140)
        )
        
        window.NextElementYPosition = window.NextElementYPosition + 35
        
        local toggleObj = {
            Instance = toggleButton,
            State = state,
            Toggle = function()
                state = not state
                toggleButton.Text = state and "ENABLED" or "DISABLED"
                toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(120, 120, 120)
                UILibrary.SetupButtonHover(
                    toggleButton, 
                    state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(120, 120, 120), 
                    state and Color3.fromRGB(0, 140, 235) or Color3.fromRGB(140, 140, 140)
                )
                
                if callback then
                    callback(state)
                end
                
                return state
            end,
            SetState = function(newState)
                if state ~= newState then
                    state = newState
                    toggleButton.Text = state and "ENABLED" or "DISABLED"
                    toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(120, 120, 120)
                    UILibrary.SetupButtonHover(
                        toggleButton, 
                        state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(120, 120, 120), 
                        state and Color3.fromRGB(0, 140, 235) or Color3.fromRGB(140, 140, 140)
                    )
                    
                    if callback then
                        callback(state)
                    end
                end
            end,
            GetState = function()
                return state
            end
        }
        
        toggleButton.MouseButton1Click:Connect(toggleObj.Toggle)
        
        table.insert(window.Elements, toggleObj)
        return toggleObj
    end
    
    -- Create slider function (to be implemented)
    
    -- Create text input function
    function window.CreateTextInput(labelText, defaultValue, callback)
        local inputFrame = Instance.new("Frame")
        inputFrame.Name = "InputFrame"
        inputFrame.Size = UDim2.new(1, 0, 0, 25)
        inputFrame.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        inputFrame.BackgroundTransparency = 1
        inputFrame.Parent = contentFrame
        
        local inputLabel = Instance.new("TextLabel")
        inputLabel.Name = "InputLabel"
        inputLabel.Size = UDim2.new(0.4, 0, 1, 0)
        inputLabel.BackgroundTransparency = 1
        inputLabel.Text = labelText
        inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        inputLabel.TextSize = 14
        inputLabel.Font = Enum.Font.Gotham
        inputLabel.TextXAlignment = Enum.TextXAlignment.Left
        inputLabel.Parent = inputFrame
        
        local textInput = Instance.new("TextBox")
        textInput.Name = "TextInput"
        textInput.Size = UDim2.new(0.55, 0, 1, 0)
        textInput.Position = UDim2.new(0.45, 0, 0, 0)
        textInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        textInput.BorderSizePixel = 0
        textInput.Text = defaultValue or ""
        textInput.PlaceholderText = "Enter text..."
        textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        textInput.TextSize = 14
        textInput.Font = Enum.Font.Gotham
        textInput.Parent = inputFrame
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 5)
        inputCorner.Parent = textInput
        
        window.NextElementYPosition = window.NextElementYPosition + 30
        
        local inputObj = {
            Instance = textInput,
            GetText = function()
                return textInput.Text
            end,
            SetText = function(text)
                textInput.Text = text
            end
        }
        
        textInput.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textInput.Text)
            end
        end)
        
        table.insert(window.Elements, inputObj)
        return inputObj
    end
    
    -- Create key binding function
    function window.CreateKeybind(labelText, defaultKey, callback)
        local keybindFrame = Instance.new("Frame")
        keybindFrame.Name = "KeybindFrame"
        keybindFrame.Size = UDim2.new(1, 0, 0, 20)
        keybindFrame.Position = UDim2.new(0, 0, 0, window.NextElementYPosition)
        keybindFrame.BackgroundTransparency = 1
        keybindFrame.Parent = contentFrame
        
        local keybindLabel = Instance.new("TextLabel")
        keybindLabel.Name = "KeyLabel"
        keybindLabel.Size = UDim2.new(0.5, 0, 1, 0)
        keybindLabel.BackgroundTransparency = 1
        keybindLabel.Text = labelText
        keybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        keybindLabel.TextSize = 12
        keybindLabel.Font = Enum.Font.Gotham
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        keybindLabel.Parent = keybindFrame
        
        local keybindButton = Instance.new("TextButton")
        keybindButton.Name = "KeyButton"
        keybindButton.Size = UDim2.new(0.45, 0, 1, 0)
        keybindButton.Position = UDim2.new(0.55, 0, 0, 0)
        keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        keybindButton.BorderSizePixel = 0
        keybindButton.Text = defaultKey and defaultKey.Name or "None"
        keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        keybindButton.TextSize = 12
        keybindButton.Font = Enum.Font.Gotham
        keybindButton.Parent = keybindFrame
        
        local keybindCorner = Instance.new("UICorner")
        keybindCorner.CornerRadius = UDim.new(0, 3)
        keybindCorner.Parent = keybindButton
        
        -- Set up hover effect
        UILibrary.SetupButtonHover(keybindButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
        
        window.NextElementYPosition = window.NextElementYPosition + 25
        
        -- Variables for changing key
        local changingKey = false
        local currentKey = defaultKey
        
        local keybindObj = {
            Instance = keybindButton,
            GetKey = function()
                return currentKey
            end,
            SetKey = function(keyCode)
                currentKey = keyCode
                keybindButton.Text = keyCode and keyCode.Name or "None"
            end
        }
        
        -- Changing key logic
        keybindButton.MouseButton1Click:Connect(function()
            if changingKey then return end
            
            changingKey = true
            keybindButton.Text = "Press any key..."
            keybindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end)
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if changingKey and input.KeyCode ~= Enum.KeyCode.Unknown then
                keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                UILibrary.SetupButtonHover(keybindButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
                
                currentKey = input.KeyCode
                keybindButton.Text = currentKey.Name
                changingKey = false
                
                if callback then
                    callback(currentKey)
                end
            elseif not gameProcessed and input.KeyCode == currentKey and callback then
                callback(currentKey)
            end
        end)
        
        table.insert(window.Elements, keybindObj)
        return keybindObj
    end
    
    -- Create dropdown function (to be implemented)
    
    return window
end

-- Utility Functions
-- Lighten color function
function UILibrary.LightenColor(color, amount)
    return Color3.new(
        math.min(color.R + amount/255, 1),
        math.min(color.G + amount/255, 1),
        math.min(color.B + amount/255, 1)
    )
end

-- Button hover effect
function UILibrary.SetupButtonHover(button, defaultColor, hoverColor)
    -- Store original properties
    button.BackgroundColor3 = defaultColor
    
    -- Remove existing connections if they exist
    if button.MouseEnterConnection then
        button.MouseEnterConnection:Disconnect()
    end
    
    if button.MouseLeaveConnection then
        button.MouseLeaveConnection:Disconnect()
    end
    
    -- Create new connections
    button.MouseEnterConnection = button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeaveConnection = button.MouseLeave:Connect(function()
        button.BackgroundColor3 = defaultColor
    end)
end

return UILibrary 