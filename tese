local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Client = LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local GetPlayers = Players.GetPlayers
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TPservice= game:GetService("TeleportService")
local GetPlayers = Players.GetPlayers
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local CurrentCamera = Workspace.CurrentCamera
local TeleportService = game:GetService("TeleportService")
local GetGuiInset = GuiService.GetGuiInset
local Circle1 = Drawing.new("Circle")
local Circle2 = Drawing.new("Circle")
local Plr,Plr2,IsTargetting

function WallCheck (destination, ignore)
    if (getgenv().XYD["Checks"].Wall) then
        local Origin = Camera.CFrame.p
        local CheckRay = Ray.new(Origin, destination - Origin)
        local Hit = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(CheckRay, ignore)
        return Hit == nil
    else
        return true
    end
end

local WTS = (function(Object)
	local ObjectVector = CurrentCamera:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end)

local Filter = (function(obj)
	if (obj:IsA('BasePart')) then
		return true
	end
end)

local MousePosVector2 = (function()
	return Vector2.new(Mouse.X, Mouse.Y) 
end)

if getgenv().XYD["Options"].Loader and getgenv().XYD["Options"].LoaderType == "Notifications" then
wait(0.3)
    StarterGui:SetCore("SendNotification",{
        Title = "XYD",
        Text = "Loaded"
    })
wait(0.5)
elseif getgenv().XYD["Options"].Loader and getgenv().XYD["Options"].LoaderType == "Image" then
wait(0.3)
        --
wait(0.5)
end

function AimbotFOV()
    if not (Circle1) then
        return
    end
    Circle1.Visible = getgenv().XYD["Fov"]["Aimbot"].Visible
    Circle1.Radius =  getgenv().XYD["Fov"]["Aimbot"].Size * 2.1
    Circle1.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
    Circle1.Filled = getgenv().XYD["Fov"]["Aimbot"].Filled
    Circle1.Transparency = getgenv().XYD["Fov"]["Aimbot"].Transparency
    Circle1.Thickness = getgenv().XYD["Fov"]["Aimbot"].Thickness
    Circle1.NumSides = getgenv().XYD["Fov"]["Aimbot"].Sides
    Circle1.Color = getgenv().XYD["Fov"]["Aimbot"].Color
    return Circle1
end

function SilentFOV()
  if not (Circle2) then
      return
  end
  Circle2.Visible = getgenv().XYD["Fov"]["Silent"].Visible
  Circle2.Radius =  getgenv().XYD["Fov"]["Silent"].Size * 2.1
  Circle2.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
  Circle2.Filled = getgenv().XYD["Fov"]["Silent"].Filled
  Circle2.Transparency = getgenv().XYD["Fov"]["Silent"].Transparency
  Circle2.Thickness = getgenv().XYD["Fov"]["Silent"].Thickness
  Circle2.NumSides = getgenv().XYD["Fov"]["Silent"].Sides
  Circle2.Color = getgenv().XYD["Fov"]["Silent"].Color
  return Circle2
end
RunService.Heartbeat:Connect(function() AimbotFOV() SilentFOV()end)


if getgenv().XYD["Fov"]["Aimbot"].UseFov == true then
    function NearestPerson()
        local closestPlayer
        local shortestDistance = getgenv().XYD["Fov"]["Aimbot"].Size
        for i, v in ipairs(game.Players:GetPlayers()) do
            pcall(function()
                if v ~= game.Players.LocalPlayer and v.Character and
                    v.Character:FindFirstChild("Humanoid") and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character})  then
                    local pos = CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local magnitude =
                    (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                    if (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude < shortestDistance then
                        closestPlayer = v
                        shortestDistance = magnitude
                    end
                end
            end)
        end
    return closestPlayer
  end
    elseif getgenv().XYD["Fov"]["Aimbot"].UseFov == false then
        function NearestPerson()
            local closestPlayer
            local shortestDistance = getgenv().XYD["Aimbot"].Distance
            for i, v in ipairs(game.Players:GetPlayers()) do
                pcall(function()
                    if v ~= game.Players.LocalPlayer and v.Character and
                        v.Character:FindFirstChild("Humanoid") and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
                        local pos = CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                        local magnitude =
                        (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                        if (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude < shortestDistance then
                            closestPlayer = v
                            shortestDistance = magnitude
                        end
                    end
                end)
            end
        return closestPlayer
    end
end

local ClosestPlrFromMouse = function()
    local Target = nil
    Closest = 1 / 0
    for _ ,v in ipairs(Players:GetPlayers()) do
        if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character})  then
            local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if (Circle2.Radius > Distance and Distance < Closest and OnScreen and Position) then
                Closest = Distance
                Target = v
            end
        end
    end
    return Target
end

local GetClosestBodyPart = (function()
	local ShortestDistance = math.huge
	local BodyPart = nil
	for _, v in next, game.Players:GetPlayers() do
		if (v ~= Client and v.Character and v.Character:FindFirstChild("Humanoid")) then
			for k, x in next, v.Character:GetChildren() do
				if (Filter(x)) then
					local Distance = (WTS(x) - MousePosVector2()).magnitude
					if (Distance < ShortestDistance) then
						ShortestDistance = Distance
						BodyPart = x
					end
				end
			end
		end
	end
	return BodyPart
end)

task.spawn(function ()
    while task.wait() do
            if Plr then
                if getgenv().XYD["Aimbot"].Enabled == true and getgenv().XYD["Aimbot"].HitboxAimType == "Closest" then
                    getgenv().XYD["Aimbot"].Hitbox = tostring(GetClosestBodyPart(Plr.Character))
                elseif getgenv().XYD["Aimbot"].Enabled == true and getgenv().XYD["Aimbot"].HitboxAimType == "Default" then
                    getgenv().XYD["Aimbot"].Hitbox = getgenv().XYD["Aimbot"].Hitbox
                elseif getgenv().XYD["Aimbot"].Enabled == true and getgenv().XYD["Aimbot"].HitboxAimType == "Point" then
                    getgenv().XYD["Aimbot"].Hitbox = tostring(ClosestPoint(Plr.Character))
                end
                if Plr2 then
                    if getgenv().XYD["Silent"].Enabled == true and getgenv().XYD["Silent"].HitboxAimType == "Closest" then
                        getgenv().XYD["Silent"].Hitboxes = tostring(GetClosestBodyPart(Plr2.Character))
                    elseif getgenv().XYD["Silent"].Enabled == true and getgenv().XYD["Silent"].HitboxAimType == "Default" then
                        getgenv().XYD["Silent"].Hitboxes = getgenv().XYD["Silent"].Hitboxes
                    elseif getgenv().XYD["Silent"].Enabled == true and getgenv().XYD["Silent"].HitboxAimType == "Point" then
                        getgenv().XYD["Silent"].Hitboxes = tostring(ClosestPoint(Plr2.Character))
                    end
               end
           end
      end
end)

if getgenv().XYD["Aimbot"].HitAirshots == true then
    if Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        getgenv().XYD["Aimbot"].Hitbox = getgenv().XYD["Aimbot"].HitAirshotsHitbox
    else
        Plr.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old,new)
            if new == Enum.HumanoidStateType.Freefall then
                getgenv().XYD["Aimbot"].Hitbox = getgenv().XYD["Aimbot"].HitAirshotsHitbox
            else
                getgenv().XYD["Aimbot"].Hitbox = getgenv().XYD["Aimbot"].Hitbox
            end
        end)
    end
end

Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().XYD["Aimbot"].AimbotKeybind:lower()
    if (Key == Keybind) then
        if getgenv().XYD["Aimbot"].Enabled == true then
            IsTargetting = not IsTargetting
            if IsTargetting then
            Plr = NearestPerson()
            else
                if Plr ~= nil then
                    Plr = nil
                end
            end
       end
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().XYD["Aimbot"].Enabled == true and Plr and Plr.Character ~= nil then
        if getgenv().XYD["Aimbot"].Shaking then
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Query["Aimbot"].Hitbox].Position + Plr.Character[getgenv().Query["Aimbot"].Hitbox].Velocity*getgenv().Query["Aimbot"].Prediction +
            Vector3.new(
                math.random(-getgenv().XYD["Aimbot"].SX,getgenv().XYD["Aimbot"].SX),
                math.random(-getgenv().XYD["Aimbot"].SY,getgenv().XYD["Aimbot"].SZ),
                math.random(-getgenv().XYD["Aimbot"].SZ,getgenv().XYD["Aimbot"].SZ)
            )*1)
            Camera.CFrame = Camera.CFrame:Lerp(Main,getgenv().XYD["Aimbot"].Smoothness,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)
        else
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().XYD["Aimbot"].Hitbox].Position + Plr.Character[getgenv().XYD["Aimbot"].Hitbox].Velocity*getgenv().XYD["Aimbot"].Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(Main,getgenv().XYD["Aimbot"].Smoothness,Enum.EasingStyle[getgenv().XYD["Aimbot"]["Easing"].Style],Enum.EasingDirection[getgenv().XYD["Aimbot"]["Easing"].Direction])
        end
    end
end)

RunService.Heartbeat:Connect(function()
                if getgenv().XYD["Aimbot"].Enabled == true and Plr and Plr.Character ~= nil then
        if getgenv().XYD["Checks"].Knock then
            if Plr.Character.BodyEffects["K.O"].Value then Plr = nil 
            end
        end
        end
end)

RunService.Heartbeat:Connect(function()
    if getgenv().XYD["Fov"]["Dynamic"].Enabled and getgenv().XYD["Fov"]["Dynamic"].Circle == "Silent" and Client ~= nil and
        (Client.Character) and Plr2 and Plr2.Character then
        if (Client.Character.HumanoidRootPart.Position - Plr2.Character.HumanoidRootPart.Position).Magnitude <
        getgenv().XYD["Fov"]["Dynamic"].Close_Studs then
            getgenv().XYD["Fov"]["Silent"].Size = getgenv().XYD["Fov"]["Dynamic"].Close
        elseif (Client.Character.HumanoidRootPart.Position - Plr2.Character.HumanoidRootPart.Position).Magnitude <
        getgenv().XYD["Fov"]["Dynamic"].Mid_Studs then
            getgenv().XYD["Fov"]["Silent"].Size = getgenv().XYD["Fov"]["Dynamic"].Mid
        elseif (Client.Character.HumanoidRootPart.Position - Plr2.Character.HumanoidRootPart.Position).Magnitude <
        getgenv().XYD["Fov"]["Dynamic"].Far_Studs then
            getgenv().XYD["Fov"]["Silent"].Size = getgenv().XYD["Fov"]["Dynamic"].Far
        elseif (Client.Character.HumanoidRootPart.Position - Plr2.Character.HumanoidRootPart.Position).Magnitude <
        getgenv().XYD["Fov"]["Dynamic"].VeryFar_Studs then
            getgenv().XYD["Fov"]["Silent"].Size = getgenv().XYD["Fov"]["Dynamic"].VeryFar
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().XYD["Aimbot"].Smoothing and getgenv().XYD["Aimbot"].Enabled  == true then
        local Main = CFrame.new(workspace.CurrentCamera.CFrame.p, Plr.Character[getgenv().XYD["Aimbot"].Hitbox].Position + Plr.Character[getgenv().XYD["Aimbot"].Hitbox].Velocity*getgenv().XYD["Aimbot"].Prediction)
                                     workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(Main,getgenv().XYD["Aimbot"].Smoothness,Enum.EasingStyle[getgenv().XYD["Aimbot"]["Easing"].Style],Enum.EasingDirection[getgenv().Query["Aimbot"]["Easing"].Direction])
    elseif getgenv().XYD["Aimbot"].Smoothing == false and  getgenv().XYD["Aimbot"].Enabled == true then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Plr.Character[getgenv().XYD["Aimbot"].Hitbox].Position + Plr.Character[getgenv().XYD["Aimbot"].Hitbox].Velocity*getgenv().Query["Aimbot"].Prediction)
                                end
end)

local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index = newcclosure(function(self, v)
if (getgenv().XYD["Silent"].Enabled and Mouse and tostring(v) == "Hit") then
    Plr2 = ClosestPlrFromMouse()
    if Plr2 then
        local endpoint = game.Players[tostring(Plr2)].Character[getgenv().XYD["Silent"]["Hitboxes"]].CFrame + (
            game.Players[tostring(Plr2)].Character[getgenv().XYD["Silent"]["Hitboxes"]].Velocity *getgenv().XYD["Silent"].Prediction
        )
        return (tostring(v) == "Hit" and endpoint)
    end
end
return backupindex(self, v)
end)

RunService.RenderStepped:Connect(function()
    if getgenv().XYD["TriggerBot"].Enabled then
        if Mouse.Target then
            if Mouse.Target.Parent:FindFirstChild('Humanoid') and Mouse.Target.Parent:FindFirstChild('Head') and Mouse.Target.Parent:FindFirstChild('LowerTorso') and Mouse.Target.Parent:FindFirstChild('UpperTorso') then
                if getgenv().XYD["TriggerBot"].Delay then
                    wait(getgenv().XYD["TriggerBot"].Delayness)
                    mouse1click()
                    mouse1release()
                else
                    mouse1click()
                    mouse1release()
                end
            end
        end
    end
end)

Mouse.KeyDown:Connect(
  function(Key)
    if getgenv().XYD["TriggerBot"].EnabledTriggerKey then
    if (Key ==  getgenv().XYD["TriggerBot"].TriggerKeybind:lower()) then
        if  getgenv().XYD["TriggerBot"].Enabled == true then
            getgenv().XYD["TriggerBot"].Enabled = false
            StarterGui:SetCore("SendNotification",{
                Title = "XYD",
                Text = "TB Disabled"
            })
        else
            getgenv().XYD["TriggerBot"].Enabled = true
            StarterGui:SetCore("SendNotification",{
                Title = "XYD",
                Text = "TB Enabled"
            })
        end
    end
  end
end
)

task.spawn(function()
    if getgenv().XYD["Checks"].NoGroundShots and Plr2.Character[getgenv().XYD["Silent"].Hitboxes].Velocity.Y < -15 then
        pcall(function()
            local Target = Plr2.Character[getgenv().XYD["Silent"].Hitboxes]
            Target.Velocity = Vector3.new(Target.Velocity.X, (Target.Velocity.Y / 5), Target.Velocity.Z)
            Target.AssemblyLinearVelocity = Vector3.new(Target.Velocity.X, (Target.Velocity.Y / 5), Target.Velocity.Z)
        end)
    end
end)

Client.Chatted:Connect(function(message)
    if getgenv().XYD["Chat"].Enabled then
        local args = string.split(message, " ")
        if args[1] == getgenv().XYD["Chat"].CircleSize and getgenv().XYD["Chat"].Circle == "Silent" and args[2] ~= nil then
            getgenv().XYD["Fov"]["Silent"].Size = tonumber(args[2])
        elseif args[1] == getgenv().XYD["Chat"].CircleSize and getgenv().XYD["Chat"].Circle == "Aimbot" and args[2] ~= nil then
            getgenv().XYD["Fov"]["Aimbot"].Size = tonumber(args[2])
        end
    end
    if getgenv().XYD["Chat"].Enabled then
        local args = string.split(message, " ")
        if args[1] == getgenv().XYD["Chat"].PredictionAmount and getgenv().XYD["Chat"].Prediction == "Silent" and args[2] ~= nil then
            getgenv().XYD["Silent"].Prediction = tonumber(args[2])
        elseif args[1] == getgenv().XYD["Chat"].PredictionAmount and getgenv().XYD["Chat"].Prediction == "Aimbot" and args[2] ~= nil then
            getgenv().XYD["Aimbot"].Prediction = tonumber(args[2])
        end
    end
end)

Mouse.KeyDown:Connect(
  function(Key)
    if getgenv().XYD["Silent"].EnabledSilentKeybind then
    if (Key ==  getgenv().XYD["Silent"].SilentKeybind:lower()) then
        if getgenv().XYD["Silent"].Enabled == true then
            getgenv().XYD["Silent"].Enabled = false
            StarterGui:SetCore("SendNotification",{
                Title = "XYD",
                Text = "SA Disabled"
            })
        else
            getgenv().XYD["Silent"].Enabled = true
            StarterGui:SetCore("SendNotification",{
                Title = "XYD",
                Text = "SA Enabled"
            })
        end
    end
  end
end
)
