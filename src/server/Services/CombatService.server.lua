local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CombatMath = require(ReplicatedStorage.Shared.Modules.CombatMath)

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local attackRequested = remotes:WaitForChild("AttackRequested")

local MAX_ATTACK_RANGE = 20 

local function onAttackRequested(player, target)

    if not target or not target:FindFirstChild("Humanoid") then
        warn("Invalid target")
        return
    end

    local targetHumanoid = target:FindFirstChild("Humanoid")

    if targetHumanoid.Health <= 0 then
        warn("Target already dead")
        return
    end

    local character = player.Character
    if not character then return end

    local playerRoot = character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target:FindFirstChild("HumanoidRootPart")

    if not playerRoot or not targetRoot then return end

    local distance = (playerRoot.Position - targetRoot.Position).Magnitude

    if distance > MAX_ATTACK_RANGE then
        warn("Target too far:", distance)
        return
    end 

    local stats = player:FindFirstChild("Stats")
    if not stats then return end

    local damageValue = stats:FindFirstChild("Damage")
    if not damageValue then return end

    local damage, isCrit = CombatMath.CalculateDamage(damageValue.Value, 1.0)

    targetHumanoid:TakeDamage(damage)

    if isCrit then
        print("CRIT! Dealt", damage, "damage to", target.Name)
    else 
        print("Dealt", damage, "damage to", target.Name)
    end
end

attackRequested.OnServerEvent:Connect(onAttackRequested)

print("CombatService loaded")