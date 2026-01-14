local Players = game:GetService("Players")

local PlayerData = require(game.ReplicatedStorage.Shared.PlayerData)

local function onPlayerAdded(player)

    local statsFolder = Instance.new("Folder")
    statsFolder.Parent = player
    statsFolder.Name = "Stats"

    local levelValue = Instance.new("IntValue")
    levelValue.Name = "Level"
    levelValue.Value = PlayerData.Level
    levelValue.Parent = statsFolder

    local xpValue = Instance.new("IntValue")
    xpValue.Name = "XP"
    xpValue.Value = PlayerData.XP
    xpValue.Parent = statsFolder

    local hpValue = Instance.new("IntValue")
    hpValue.Name = "HP"
    hpValue.Value = PlayerData.HP
    hpValue.Parent = statsFolder

    local MaxHPValue = Instance.new("IntValue")
    MaxHPValue.Name = "MaxHP"
    MaxHPValue.Value = PlayerData.MaxHP
    MaxHPValue.Parent = statsFolder

    local damageValue = Instance.new("IntValue")
    damageValue.Name = "Damage"
    damageValue.Value = PlayerData.Damage
    damageValue.Parent = statsFolder

    local coinsValue = Instance.new("IntValue")
    coinsValue.Name = "Coins"
    coinsValue.Value = PlayerData.Coins
    coinsValue.Parent = statsFolder

    local equippedWeaponValue = Instance.new("StringValue")
    equippedWeaponValue.Name = "EquippedWeapon"
    equippedWeaponValue.Value = PlayerData.EquippedWeapon
    equippedWeaponValue.Parent = statsFolder

end

Players.PlayerAdded:Connect(onPlayerAdded)