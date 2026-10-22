-- Tribes 3v3 VIP Script Hub - Ultra Stable Version
if _G.TribesLoaded then return end
_G.TribesLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- تنظيف الواجهات القديمة
pcall(function()
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "VIP_FloatingToggle" or v.Name == "Orion" then
            v:Destroy()
        end
    end
end)

-- تحميل مكتبة الواجهة بأمان
local successLib, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
end)

if not successLib or not OrionLib then
    warn("فشل تحميل مكتبة الواجهة!")
    return
end

local Window = OrionLib:MakeWindow({
    Name = "Tribes 3v3 - VIP Hub 👑",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "TribesVIP"
})

-- زر العرض والإخفاء العائم
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "VIP_FloatingToggle"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "👑 VIP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.TextSize = 16
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

ToggleButton.Activated:Connect(function()
    pcall(function()
        local OrionGui = game:GetService("CoreGui"):FindFirstChild("Orion") or (gethui and gethui():FindFirstChild("Orion"))
        if OrionGui then
            OrionGui.Enabled = not OrionGui.Enabled
        end
    end)
end)

-- دالة فحص التيم البسيطة والسريعة
local function isTeammate(player)
    if player == LocalPlayer then return true end
    if player.Team and LocalPlayer.Team then
        return player.Team == LocalPlayer.Team
    end
    return false
end

-- تبويب الحركة
local MainTab = Window:MakeTab({
    Name = "اللاعب والحركة",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSlider({
    Name = "السرعة (WalkSpeed)",
    Min = 16,
    Max = 150,
    Default = 16,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 1,
    ValueName = "سرعة",
    Callback = function(s)
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = s
        end)
    end
})

-- تبويب كشف الأماكن (ESP)
local VisualTab = Window:MakeTab({
    Name = "كشف الأماكن",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ESP_Enabled = false

VisualTab:AddToggle({
    Name = "تفعيل كشف الأماكن التلقائي",
    Default = false,
    Callback = function(state)
        ESP_Enabled = state
    end
})

RunService.Stepped:Connect(function()
    if not ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESP_Highlight") then
                p.Character.ESP_Highlight:Destroy()
            end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESP_Highlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.Parent = player.Character
            end

            if isTeammate(player) then
                highlight.FillColor = Color3.fromRGB(0, 255, 0)   -- أخضر للتيم
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0)   -- أحمر للخصم
            end
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Enabled = true
        end
    end
end)

OrionLib:Init()
