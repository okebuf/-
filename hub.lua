-- RHTU Hub - Delta Script GUI Full Features -- Author: ChatGPT + User (NFKhoa Giap) -- NOTE: Requires executor that supports UI creation (e.g., Delta, Hydrogen)

-- SERVICES local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Camera = workspace.CurrentCamera local LocalPlayer = Players.LocalPlayer

-- UI SETUP local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) ScreenGui.Name = "RHTU_Hub" ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0, 400, 0, 300) MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) MainFrame.BorderSizePixel = 0 MainFrame.Active = true MainFrame.Draggable = true MainFrame.Parent = ScreenGui

-- Rainbow Border local function updateRainbow() local hue = tick() % 5 / 5 return Color3.fromHSV(hue, 1, 1) end

local RainbowBorder = Instance.new("UIStroke", MainFrame) RainbowBorder.Thickness = 2 RainbowBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border RunService.RenderStepped:Connect(function() RainbowBorder.Color = updateRainbow() end)

-- Hide/Show Toggle Keybind (RightShift) local visible = true UserInputService.InputBegan:Connect(function(input, gpe) if gpe then return end if input.KeyCode == Enum.KeyCode.RightShift then visible = not visible MainFrame.Visible = visible end end)

-- UI Elements local UIListLayout = Instance.new("UIListLayout", MainFrame) UIListLayout.FillDirection = Enum.FillDirection.Vertical UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder UIListLayout.Padding = UDim.new(0, 4)

local function createButton(text, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -10, 0, 30) btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) btn.TextColor3 = Color3.fromRGB(255, 255, 255) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.Parent = MainFrame btn.MouseButton1Click:Connect(callback) return btn end

local function createTextbox(label, default, callback) local box = Instance.new("TextBox") box.Size = UDim2.new(1, -10, 0, 30) box.PlaceholderText = label box.Text = default box.BackgroundColor3 = Color3.fromRGB(50, 50, 50) box.TextColor3 = Color3.fromRGB(255, 255, 255) box.Font = Enum.Font.Gotham box.TextSize = 14 box.ClearTextOnFocus = false box.Parent = MainFrame box.FocusLost:Connect(function() callback(box.Text) end) return box end

-- SPEED SLIDER local speed = 16 createTextbox("WalkSpeed (1-100)", tostring(speed), function(value) local val = tonumber(value) if val then speed = math.clamp(val, 1, 100) LocalPlayer.Character.Humanoid.WalkSpeed = speed end end)

-- NOCLIP TOGGLE local noclip = false createButton("Toggle Noclip", function() noclip = not noclip end) RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)

-- FOV CHANGER createButton("FOV = 120", function() Camera.FieldOfView = 120 end) createButton("FOV = 60", function() Camera.FieldOfView = 60 end)

-- ESP PLAYER local function createESP(player) local Billboard = Instance.new("BillboardGui") Billboard.Name = "ESP" Billboard.Size = UDim2.new(0, 100, 0, 40) Billboard.Adornee = player.Character and player.Character:FindFirstChild("Head") Billboard.AlwaysOnTop = true Billboard.Parent = player.Character

local Text = Instance.new("TextLabel", Billboard)
Text.Size = UDim2.new(1, 0, 1, 0)
Text.BackgroundTransparency = 1
Text.TextColor3 = Color3.new(1, 1, 1)
Text.TextScaled = true
Text.Font = Enum.Font.Gotham

local function update()
    if player.Character and player:FindFirstChild("Humanoid") then
        local hp = math.floor(player.Humanoid.Health)
        local pos = player:DistanceFromCharacter(LocalPlayer.Character.HumanoidRootPart.Position)
        Text.Text = player.Name .. "\nHP: " .. hp .. "\n" .. math.floor(pos) .. " studs"
    end
end
RunService.RenderStepped:Connect(update)

end

createButton("ESP Player", function() for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("ESP") then createESP(plr) end end end)

-- AIMBOT local aimTarget = nil createTextbox("Tên player để Aimbot", "", function(name) aimTarget = Players:FindFirstChild(name) end)

createButton("Headsit (Aim at Head)", function() if aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("Head") then Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimTarget.Character.Head.Position) end end)

createButton("Teleport", function() if aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:PivotTo(aimTarget.Character.HumanoidRootPart.CFrame) end end)

createButton("View Player", function() if aimTarget then Camera.CameraSubject = aimTarget.Character:FindFirstChild("Humanoid") end end)

-- Done!

