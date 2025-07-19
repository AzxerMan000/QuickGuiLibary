-- QuickGuiLib.lua
local QuickGuiLib = {}
QuickGuiLib.__index = QuickGuiLib

function QuickGuiLib.new(guiName)
    local self = setmetatable({}, QuickGuiLib)

    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "QuickGuiLib"
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 12)
    

    -- Tabs container (left side)
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0, 120, 1, 0)
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 0)
    self.TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.TabsFrame.Parent = self.ScreenGui

    -- Buttons container (right side)
    self.ButtonsFrame = Instance.new("Frame")
    self.ButtonsFrame.Name = "ButtonsFrame"
    self.ButtonsFrame.Size = UDim2.new(1, -120, 1, 0)
    self.ButtonsFrame.Position = UDim2.new(0, 120, 0, 0)
    self.ButtonsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    self.ButtonsFrame.Parent = self.ScreenGui

    self.Tabs = {}
    self.Buttons = {}

    self.CurrentTab = nil

    return self
end

function QuickGuiLib:AddTab(name)
    -- Create Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 45) + 5)
    tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    tabButton.Text = name
    tabButton.Parent = self.TabsFrame

    -- Create buttons container for this tab (initially hidden)
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

    -- When clicked, show this tab's buttons, hide others
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)

    -- Auto switch to first tab
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
