local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local attackRequested = remotes:WaitForChild("AttackRequested")

local canAttack = true
local ATTACK_COOLDOWN = 1.0

local function onMouseClick()

    if not canAttack then return end

    canAttack = false

    local camera = workspace.CurrentCamera
    local mousePosition = mouse.Hit.Position

    local rayOrigin = camera.CFrame.Position
    local rayDirection = (mousePosition - rayOrigin).unit * 100

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {player.Character}

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        local hitModel = hitPart.Parent

        local humanoid = hitModel:FindFirstChild("Humanoid")

        if humanoid then
            print("Hit:", hitModel.Name)

            attackRequested:FireServer(hitModel)
        end
    end

    task.wait(ATTACK_COOLDOWN)
    canAttack = true
end


mouse.Button1Down:Connect(onMouseClick)

