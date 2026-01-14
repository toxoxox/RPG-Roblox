local Players = game:GetService("Players")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")
local playerHUD = playerGui:WaitForChild("PlayerHUD")
local statsFrame = playerHUD:WaitForChild("StatsFrame")

local levelLabel = statsFrame:WaitForChild("LevelLabel")
local coinsLabel = statsFrame:WaitForChild("CoinsLabel")
local hpBarBackground = statsFrame:WaitForChild("HPBarBackground")
local hpBarFill = hpBarBackground:WaitForChild("HPBarFill")

local stats = player:WaitForChild("Stats")
local level = stats:WaitForChild("Level")
local coins = stats:WaitForChild("Coins")
local hp = stats:WaitForChild("HP")
local maxHP = stats:WaitForChild("MaxHP")

local function updateUI()

    levelLabel.Text = "Level " .. level.Value
    coinsLabel.Text = "Coins: " .. coins.Value

    local hpPercent = hp.Value / maxHP.Value
    hpBarFill.Size = UDim2.new(hpPercent, 0, 1, 0)

end

updateUI()

level.Changed:Connect(updateUI)
coins.Changed:Connect(updateUI)
hp.Changed:Connect(updateUI)
maxHP.Changed:Connect(updateUI)