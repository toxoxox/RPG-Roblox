local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local weaponsFolder = ReplicatedStorage:WaitForChild("Weapons")

-- Equip weapon to player
local function equipWeapon(character, weaponName)
    -- Find the weapon model
    local weaponTemplate = weaponsFolder:FindFirstChild(weaponName)
    if not weaponTemplate then
        warn("Weapon not found:", weaponName)
        return
    end
    
    -- Clone the weapon
    local weapon = weaponTemplate:Clone()
    
    -- Find player's right hand
    local rightHand = character:WaitForChild("RightHand", 5)
    if not rightHand then
        warn("RightHand not found")
        weapon:Destroy()
        return
    end
    
    -- Find the weapon's handle
    local handle = weapon:FindFirstChild("Handle")
    if not handle then
        warn("Weapon has no Handle")
        weapon:Destroy()
        return
    end
    
    -- Weld weapon to hand
    local weld = Instance.new("Weld")
    weld.Part0 = rightHand
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, -1.4, 0) * CFrame.Angles(math.rad(90), 0, (90))  -- Position and rotate
    weld.Parent = handle
    
    -- Parent weapon to character
    weapon.Parent = character
    
    print("Equipped", weaponName, "to", character.Name)
end

-- When player's character spawns
local function onCharacterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    -- Wait for stats to load
    local stats = player:WaitForChild("Stats", 5)
    if not stats then return end
    
    local equippedWeapon = stats:WaitForChild("EquippedWeapon", 5)
    if not equippedWeapon then return end
    
    -- Equip the weapon
    equipWeapon(character, equippedWeapon.Value)
end

-- When player joins
local function onPlayerAdded(player)
    -- Equip weapon when character spawns
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- If character already exists
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Connect to all players
Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle players already in game
for _, player in Players:GetPlayers() do
    onPlayerAdded(player)
end

print("WeaponService loaded")
