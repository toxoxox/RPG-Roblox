local CombatMath = {}

function CombatMath.CalculateDamage(attackerDamage, weaponMultiplier)
    local baseDamage = attackerDamage * weaponMultiplier

    local isCrit = math.random() < 0.2

    if isCrit then
        return baseDamage * 1.5, true
    else 
        return baseDamage, false
    end
end

return CombatMath
