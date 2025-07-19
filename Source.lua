l-- QuickGuiLib.lua
local UserInputService = game:GetService("UserInputService")

local QuickGuiLib = {}
QuickGuiLib.__index = QuickGuiLib

function QuickGuiLib.new(guiName)
    local self = setmetatable({}, QuickGuiLib)

    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "QuickGuiLib"
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main window frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.Active = true
    self.MainFrame.Parent = self.ScreenGui
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 12)

    -- Title bar frame (top)
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.TitleBar.Parent = self.MainFrame
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 12)

    -- Title label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = guiName or "QuickGuiLib"
    self.TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    self.TitleLabel.Font = Enum.Font.SourceSansBold
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar

    -- Minimize button
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 30, 0, 24)
    self.MinimizeButton.Position = UDim2.new(1, -70, 0, 3)
    self.MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    self.MinimizeButton.Text = "_"
    self.MinimizeButton.TextColor3 = Color3.new(1,1,1)
    self.MinimizeButton.Font = Enum.Font.SourceSansBold
    self.MinimizeButton.TextSize = 20
    self.MinimizeButton.Parent = self.TitleBar
    Instance.new("UICorner", self.MinimizeButton).CornerRadius = UDim.new(0, 6)

    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 24)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 3)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = Color3.new(1,1,1)
    self.CloseButton.Font = Enum.Font.SourceSansBold
    self.CloseButton.TextSize = 20
    self.CloseButton.Parent = self.TitleBar
    Instance.new("UICorner", self.CloseButton).CornerRadius = UDim.new(0, 6)

    -- Content container (below title bar)
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame

    -- Tabs container (left side)
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0, 120, 1, 0)
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 0)
    self.TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.TabsFrame.Parent = self.ContentFrame

    -- Buttons container (right side)
    self.ButtonsFrame = Instance.new("Frame")
    self.ButtonsFrame.Name = "ButtonsFrame"
    self.ButtonsFrame.Size = UDim2.new(1, -120, 1, 0)
    self.ButtonsFrame.Position = UDim2.new(0, 120, 0, 0)
    self.ButtonsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    self.ButtonsFrame.Parent = self.ContentFrame

    -- Variables
    self.Tabs = {}
    self.Buttons = {}
    self.CurrentTab = nil
    self.Minimized = false

    -- Draggable main frame
    do
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        self.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = self.MainFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        self.TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    -- Resize handle
    do
        local resizeCorner = Instance.new("Frame")
        resizeCorner.Name = "ResizeCorner"
        resizeCorner.Size = UDim2.new(0, 20, 0, 20)
        resizeCorner.Position = UDim2.new(1, -20, 1, -20)
        resizeCorner.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        resizeCorner.BorderSizePixel = 0
        resizeCorner.Parent = self.MainFrame
        Instance.new("UICorner", resizeCorner).CornerRadius = UDim.new(0, 6)

        local resizing = false
        local resizeStartPos, resizeStartSize

        resizeCorner.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStartPos = input.Position
                resizeStartSize = self.MainFrame.Size

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        resizing = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - resizeStartPos
                local newWidth = math.clamp(resizeStartSize.X.Offset + delta.X, 200, 800)
                local newHeight = math.clamp(resizeStartSize.Y.Offset + delta.Y, 100, 600)
                self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end)
    end

    -- Minimize button behavior
    self.MinimizeButton.MouseButton1Click:Connect(function()
        if self.Minimized then
            -- Restore
            self.ContentFrame.Visible = true
            self.Minimized = false
            -- Reset size to default or keep current width but full height
            local currentWidth = self.MainFrame.Size.X.Offset
            self.MainFrame.Size = UDim2.new(0, currentWidth, 0, 300)
        else
            -- Minimize (hide content, shrink height)
            self.ContentFrame.Visible = false
            self.Minimized = true
            local currentWidth = self.MainFrame.Size.X.Offset
            self.MainFrame.Size = UDim2.new(0, currentWidth, 0, 30)
        end
    end)

    -- Close button behavior
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    return self
end

-- AddTab, AddButton, SwitchTab functions remain the same as before:

function QuickGuiLib:AddTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 45) + 5)
    tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    tabButton.Text = name
    tabButton.Parent = self.TabsFrame

    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = name .. "Buttons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 1, 0)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Visible = false
    tabButtonsFrame.Parent = self.ButtonsFrame

    local tabData = {
        Name = name,
        Button = tabButton,
        ButtonsFrame = tabButtonsFrame,
        Buttons = {}
    }
    table.insert(self.Tabs, tabData)

    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)

    if #self.Tabs == 1 then
        self:SwitchTab(name)
    end

    return tabData
end

function QuickGuiLib:AddButton(tabData, name, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (#tabData.Buttons * 35) + 5)
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.Text = name
    btn.Parent = tabData.ButtonsFrame

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    table.insert(tabData.Buttons, btn)
    return btn
end

function QuickGuiLib:SwitchTab(name)
    for _, tab in pairs(self.Tabs) do
        if tab.Name == name then
            tab.Button.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            tab.ButtonsFrame.Visible = true
            self.CurrentTab = tab
        else
            tab.Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            tab.ButtonsFrame.Visible = false
        end
    end
end

return QuickGuiLib
