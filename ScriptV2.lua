-- Load the DrRay library from the GitHub repository Library
local DrRayLibrary = loadstring(game:HttpGet("https://pastebin.com/raw/4TJNx6LJ"))()

-- Create a new window and set its title and theme
local window = DrRayLibrary:Load("ICheats V2", "Default")

-- Create the first tab with an image ID
local AimTab = DrRayLibrary.newTab("Aimbot", "ImageIdHere")

-- Add elements to the first tab
AimTab.newLabel("Aimbot comming soon")

local VisTab = DrRayLibrary.newTab("Visuals", "ImageIdLogoHere")

-- Add elements to the second tab
VisTab.newLabel("Player Visuals")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
 
-- Check for Drawing API availability
local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end
 
local Find_Required = API_Check()
 
if Find_Required == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Unsupported Exploit",
        Text = "Tracer script could not load due to an unsupported exploit.",
        Duration = 10,
        Button1 = "OK"
    })
    return
end
 
-- Global settings
_G.TeamCheck = false         -- Tracers for all players, not just enemies
_G.FromMouse = false         -- Tracers from mouse (off by default)
_G.FromCenter = false        -- Tracers from center (off by default)
_G.FromBottom = true         -- Tracers from bottom (default)
_G.TracersVisible = false     -- Tracers start enabled
_G.TracerColor = Color3.fromRGB(255, 255, 255) -- White tracers
_G.TracerThickness = 1       -- Thin tracers
_G.TracerTransparency = 0.7  -- Slightly transparent

_G.TeamCheck = false            -- Boxes for all players, not just enemies
_G.SquaresVisible = false        -- Boxes start enabled
_G.SquareColor = Color3.fromRGB(255, 255, 255) -- White boxes
_G.SquareThickness = 1          -- Thin boxes
_G.SquareFilled = false         -- Outline only (not filled)
_G.SquareTransparency = 0.7     -- Slightly transparent
_G.HeadOffset = Vector3.new(0, 0.5, 0) -- Offset for head position
_G.LegsOffset = Vector3.new(0, 3, 0)   -- Offset for legs position

local function CreateTracers()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= Players.LocalPlayer.Name then
            local TracerLine = Drawing.new("Line")
 
            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) and workspace[v.Name]:FindFirstChild("HumanoidRootPart") then
                    local rootPart = workspace[v.Name].HumanoidRootPart
                    local rootPos = rootPart.CFrame * CFrame.new(0, -rootPart.Size.Y, 0).p
                    local vector, onScreen = Camera:WorldToViewportPoint(rootPos)
 
                    TracerLine.Thickness = _G.TracerThickness
                    TracerLine.Transparency = _G.TracerTransparency
                    TracerLine.Color = _G.TracerColor
 
                    if _G.FromMouse then
                        TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    elseif _G.FromCenter then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elseif _G.FromBottom then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    end
 
                    if onScreen then
                        TracerLine.To = Vector2.new(vector.X, vector.Y)
                        if _G.TeamCheck then
                            TracerLine.Visible = Players.LocalPlayer.Team ~= v.Team and _G.TracersVisible
                        else
                            TracerLine.Visible = _G.TracersVisible
                        end
                    else
                        TracerLine.Visible = false
                    end
                else
                    TracerLine.Visible = false
                end
            end)
 
            Players.PlayerRemoving:Connect(function()
                TracerLine.Visible = false
            end)
        end
    end
 
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if player.Name ~= Players.LocalPlayer.Name then
                local TracerLine = Drawing.new("Line")
 
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(player.Name) and workspace[player.Name]:FindFirstChild("HumanoidRootPart") then
                        local rootPart = workspace[player.Name].HumanoidRootPart
                        local rootPos = rootPart.CFrame * CFrame.new(0, -rootPart.Size.Y, 0).p
                        local vector, onScreen = Camera:WorldToViewportPoint(rootPos)
 
                        TracerLine.Thickness = _G.TracerThickness
                        TracerLine.Transparency = _G.TracerTransparency
                        TracerLine.Color = _G.TracerColor
 
                        if _G.FromMouse then
                            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        elseif _G.FromCenter then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif _G.FromBottom then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end
 
                        if onScreen then
                            TracerLine.To = Vector2.new(vector.X, vector.Y)
                            if _G.TeamCheck then
                                TracerLine.Visible = Players.LocalPlayer.Team ~= player.Team and _G.TracersVisible
                            else
                                TracerLine.Visible = _G.TracersVisible
                            end
                        else
                            TracerLine.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                    end
                end)
 
                Players.PlayerRemoving:Connect(function()
                    TracerLine.Visible = false
                end)
            end
        end)
    end)
end
 
-- Initialize tracers
local Success, Error = pcall(function()
    CreateTracers()
end)
 

local function CreateSquares()
    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            local Square = Drawing.new("Square")
            Square.Thickness = _G.SquareThickness
            Square.Transparency = _G.SquareTransparency
            Square.Color = _G.SquareColor
            Square.Filled = _G.SquareFilled
            Square.Visible = false -- Start invisible, enable only when valid
 
            RunService.RenderStepped:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                    local rootPos = v.Character.HumanoidRootPart.Position
                    local headPos = v.Character.Head.Position + _G.HeadOffset
                    local legsPos = rootPos - _G.LegsOffset
 
                    local rootViewport, onScreen = Camera:WorldToViewportPoint(rootPos)
                    local headViewport = Camera:WorldToViewportPoint(headPos)
                    local legsViewport = Camera:WorldToViewportPoint(legsPos)
 
                    if onScreen and _G.SquaresVisible then
                        local height = math.abs(headViewport.Y - legsViewport.Y)
                        local width = height * 0.6 -- Proportional width
                        Square.Size = Vector2.new(width, height)
                        -- Center the box on the player by using rootViewport.Y adjusted by half the height
                        Square.Position = Vector2.new(rootViewport.X - width / 2, rootViewport.Y - height / 2)
                        Square.Visible = _G.TeamCheck and v.Team ~= LocalPlayer.Team or true
                    else
                        Square.Visible = false
                    end
                else
                    Square.Visible = false
                end
            end)
 
            Players.PlayerRemoving:Connect(function(player)
                if player == v then
                    Square:Remove()
                end
            end)
        end
    end
 
    Players.PlayerAdded:Connect(function(v)
        if v ~= LocalPlayer then
            local Square = Drawing.new("Square")
            Square.Thickness = _G.SquareThickness
            Square.Transparency = _G.SquareTransparency
            Square.Color = _G.SquareColor
            Square.Filled = _G.SquareFilled
            Square.Visible = false
 
            RunService.RenderStepped:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                    local rootPos = v.Character.HumanoidRootPart.Position
                    local headPos = v.Character.Head.Position + _G.HeadOffset
                    local legsPos = rootPos - _G.LegsOffset
 
                    local rootViewport, onScreen = Camera:WorldToViewportPoint(rootPos)
                    local headViewport = Camera:WorldToViewportPoint(headPos)
                    local legsViewport = Camera:WorldToViewportPoint(legsPos)
 
                    if onScreen and _G.SquaresVisible then
                        local height = math.abs(headViewport.Y - legsViewport.Y)
                        local width = height * 0.6
                        Square.Size = Vector2.new(width, height)
                        Square.Position = Vector2.new(rootViewport.X - width / 2, rootViewport.Y - height / 2)
                        Square.Visible = _G.TeamCheck and v.Team ~= LocalPlayer.Team or true
                    else
                        Square.Visible = false
                    end
                else
                    Square.Visible = false
                end
            end)
 
            Players.PlayerRemoving:Connect(function(player)
                if player == v then
                    Square:Remove()
                end
            end)
        end
    end)
end
 
-- Initialize GUI and boxes
local Success, Error = pcall(function()
    CreateSquares()
end)

-- Visual state variables
local espMasterEnabled = false
local chamsEnabled = false
local nameTagsEnabled = false
local teamCheckEnabled = true  -- NEW: Ignore teammates when ON

local visualElements = {} -- {player = {Highlight, Billboard}}

-- Update visuals for one player (with team check)
local function updatePlayerVisuals(player)
    if player == game.Players.LocalPlayer then return end

    local char = player.Character
    if not char or not char:FindFirstChild("Head") or not char:FindFirstChildOfClass("Humanoid") then
        -- Cleanup
        if visualElements[player] then
            if visualElements[player].Highlight then visualElements[player].Highlight:Destroy() end
            if visualElements[player].Billboard then visualElements[player].Billboard:Destroy() end
            visualElements[player] = nil
        end
        return
    end

    local head = char.Head
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid.Health <= 0 then return end

    -- Team check: Skip if same team and teamCheckEnabled
    if teamCheckEnabled and player.Team == LocalPlayer.Team and player.Team ~= nil then
        -- Cleanup visuals if previously shown
        if visualElements[player] then
            if visualElements[player].Highlight then visualElements[player].Highlight:Destroy() end
            if visualElements[player].Billboard then visualElements[player].Billboard:Destroy() end
            visualElements[player] = nil
        end
        return
    end

    if not visualElements[player] then visualElements[player] = {} end

    local teamColor = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(200, 200, 200)

    -- Chams (Team-colored Highlight)
    if espMasterEnabled and chamsEnabled then
        if not visualElements[player].Highlight then
            local hl = Instance.new("Highlight")
            hl.Name = "ChamsHighlight"
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillTransparency = 0.4
            hl.OutlineTransparency = 0
            hl.FillColor = teamColor
            hl.OutlineColor = teamColor:Lerp(Color3.new(1,1,1), 0.5)
            hl.Parent = char
            visualElements[player].Highlight = hl
        else
            visualElements[player].Highlight.FillColor = teamColor
            visualElements[player].Highlight.OutlineColor = teamColor:Lerp(Color3.new(1,1,1), 0.5)
        end
    else
        if visualElements[player].Highlight then
            visualElements[player].Highlight:Destroy()
            visualElements[player].Highlight = nil
        end
    end

    -- Name Tags (Team-colored text)
    if espMasterEnabled and nameTagsEnabled then
        if not visualElements[player].Billboard then
            local bb = Instance.new("BillboardGui")
            bb.Name = "NameTag"
            bb.Adornee = head
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.StudsOffset = Vector3.new(0, 3.5, 0)
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.MaxDistance = 150

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextStrokeTransparency = 0.6
            label.TextStrokeColor3 = Color3.new(0,0,0)
            label.TextColor3 = teamColor
            label.Text = player.Name
            label.Parent = bb

            bb.Parent = head
            visualElements[player].Billboard = bb
        else
            visualElements[player].Billboard.Adornee.TextLabel.TextColor3 = teamColor
        end
    else
        if visualElements[player].Billboard then
            visualElements[player].Billboard:Destroy()
            visualElements[player].Billboard = nil
        end
    end
end

game.Players.PlayerAdded:Connect(function(plr)
   plr.CharacterAdded:Connect(function()
      task.wait(0.5)
      if espMasterEnabled then
         updatePlayerVisuals(plr)
      end
   end)
   plr.CharacterRemoving:Connect(function()
      if visualElements[plr] then
         if visualElements[plr].Highlight then visualElements[plr].Highlight:Destroy() end
         if visualElements[plr].Billboard then visualElements[plr].Billboard:Destroy() end
         visualElements[plr] = nil
      end
   end)
end)

-- Initial scan
for _, plr in ipairs(game.Players:GetPlayers()) do
   if plr.Character then
      task.spawn(updatePlayerVisuals, plr)
   end
   plr.CharacterAdded:Connect(function()
      task.wait(0.5)
      if espMasterEnabled then
         updatePlayerVisuals(plr)
      end
   end)
   plr.CharacterRemoving:Connect(function()
      if visualElements[plr] then
         if visualElements[plr].Highlight then visualElements[plr].Highlight:Destroy() end
         if visualElements[plr].Billboard then visualElements[plr].Billboard:Destroy() end
         visualElements[plr] = nil
      end
   end)
end

-- Local player respawn handler
game.Players.LocalPlayer.CharacterAdded:Connect(function()
   task.wait(0.5)
   if espMasterEnabled then
      for _, plr in ipairs(game.Players:GetPlayers()) do
         updatePlayerVisuals(plr)
      end
   end
end)

VisTab.newToggle("Tracers", "Toggles tracers", false, function(toggleState)
    if toggleState then
        _G.TracersVisible = true
    else
        _G.TracersVisible = false
    end
end)

VisTab.newToggle("Boxes", "Toggles boxes", false, function(toggleState)
    if toggleState then
           _G.SquaresVisible = true
    else
           _G.SquaresVisible = false
    end
end)
