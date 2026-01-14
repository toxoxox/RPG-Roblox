# Anime Clash: Simple RPG - Architecture Steering Document

## Project Overview

This document outlines the complete system architecture for Anime Clash, a beginner-friendly Roblox RPG. Each section explains **why** systems exist, **how** they connect, and **what** you need to build.

**Core Philosophy:** Small, focused modules that do one thing well. No over-engineering.

---

## Rojo Folder Structure

```
src/
├── server/
│   ├── init.server.luau              (Server bootstrap)
│   ├── Services/
│   │   ├── CombatService.luau        (Handles damage, attacks)
│   │   ├── EnemyService.luau         (Spawns/manages enemies)
│   │   ├── DataService.luau          (Save/load with ProfileStore)
│   │   └── ShopService.luau          (Weapon purchases)
│   └── Modules/
│       ├── EnemyAI.luau              (Enemy behavior logic)
│       └── LevelScaling.luau         (Stat calculations)
│
├── client/
│   ├── init.client.luau              (Client bootstrap)
│   ├── Controllers/
│   │   ├── CombatController.luau     (Attack input, UI updates)
│   │   ├── UIController.luau         (HUD management)
│   │   └── ShopController.luau       (Shop UI logic)
│   └── Modules/
│       └── CameraShake.luau          (Visual feedback)
│
└── shared/
    ├── Config/
    │   ├── GameConfig.luau           (Global settings)
    │   ├── WeaponData.luau           (Weapon stats)
    │   └── EnemyData.luau            (Enemy templates)
    ├── Modules/
    │   ├── PlayerData.luau           (Player stat structure)
    │   └── CombatMath.luau           (Damage formulas)
    └── Network/
        └── RemoteEvents.luau         (All RemoteEvents/Functions)
```

**Why this structure?**
- **Server/Client/Shared** separation prevents exploits
- **Services** = systems that run continuously
- **Controllers** = client-side managers
- **Modules** = reusable logic with no side effects
- **Config** = data tables (easy to balance without code changes)

---

## System Breakdown

### 1. Data System (Server)

**Module:** `DataService.luau`

**Purpose:** Save and load player progress using ProfileStore.

**Responsibilities:**
- Load player data when they join
- Auto-save every 5 minutes
- Save on player leave
- Provide data to other services

**Data Structure (stored):**
```lua
{
    Level = 1,
    XP = 0,
    HP = 100,
    MaxHP = 100,
    Damage = 10,
    Coins = 0,
    EquippedWeapon = "Starter Sword"
}
```

**Dependencies:**
- ProfileStore (external library)
- `PlayerData.luau` (shared module for default values)

**Outputs:**
- `DataService:GetData(player)` → returns player's data table
- `DataService:UpdateData(player, key, value)` → safely modifies data

**Beginner Pitfalls:**
- ❌ Don't modify data directly (use UpdateData method)
- ❌ Don't forget to handle ProfileStore session locks
- ❌ Never trust client to send stat values

**Incremental Tasks:**
1. Set up ProfileStore with default data structure
2. Add join/leave handlers
3. Test data persistence by rejoining game
4. Add auto-save loop

---

### 2. Combat System (Server + Client)

#### Server: `CombatService.luau`

**Purpose:** Validate attacks and apply damage.

**Responsibilities:**
- Listen for attack requests from client
- Check if attack is valid (cooldown, range, alive)
- Calculate damage using `CombatMath.luau`
- Apply damage to target
- Award XP if enemy dies

**Inputs:**
- RemoteEvent: `AttackRequested(target: Model)`

**Outputs:**
- RemoteEvent: `DamageDealt(target, amount, isCrit)`
- Calls `DataService:UpdateData()` for XP/level changes

**Dependencies:**
- `CombatMath.luau` (damage formulas)
- `DataService` (get player damage stat)
- `LevelScaling.luau` (XP requirements)

**Beginner Pitfalls:**
- ❌ Never let client decide damage amount
- ❌ Always validate target exists and is in range
- ❌ Don't forget attack cooldowns (exploiters will spam)

#### Client: `CombatController.luau`

**Purpose:** Detect player input and request attacks.

**Responsibilities:**
- Listen for mouse click or key press
- Raycast to find target under cursor
- Send attack request to server
- Play attack animation

**Outputs:**
- Fires `AttackRequested` RemoteEvent

**Dependencies:**
- `RemoteEvents.luau`
- Player's character model

**Beginner Pitfalls:**
- ❌ Don't calculate damage on client (server decides)
- ❌ Don't forget to debounce input (prevent spam)

#### Shared: `CombatMath.luau`

**Purpose:** Pure math functions for damage calculation.

**Responsibilities:**
- Calculate base damage
- Apply crit chance
- Apply weapon multipliers

**Example Function:**
```lua
function CombatMath.CalculateDamage(attackerDamage, weaponMultiplier, isCrit)
    -- Your formula here
end
```

**Why separate this?**
- Easy to test without running game
- Server can use same formulas
- Easy to balance by tweaking numbers

**Incremental Tasks:**
1. Build basic attack input detection (client)
2. Add server validation (just print "attack received")
3. Implement damage calculation
4. Connect to enemy HP system
5. Add visual feedback (damage numbers, animations)

---

### 3. Enemy System (Server)

#### `EnemyService.luau`

**Purpose:** Spawn and manage all enemies in the game.

**Responsibilities:**
- Spawn enemies at designated spawn points
- Track all active enemies
- Handle enemy death (drop rewards, respawn timer)
- Assign AI behavior to each enemy

**Data Structure (per enemy):**
```lua
{
    Model = workspace.Enemy1,
    HP = 50,
    MaxHP = 50,
    Damage = 5,
    Level = 1,
    AIState = "Idle" -- or "Chasing", "Attacking"
}
```

**Dependencies:**
- `EnemyData.luau` (enemy templates)
- `EnemyAI.luau` (behavior logic)
- `LevelScaling.luau` (scale stats by level)

**Outputs:**
- Provides enemy list to `CombatService`
- Fires `EnemyDied` event for rewards

**Beginner Pitfalls:**
- ❌ Don't create enemies on client (exploitable)
- ❌ Clean up enemies properly when they die
- ❌ Don't run AI for every enemy every frame (use Heartbeat wisely)

#### `EnemyAI.luau`

**Purpose:** Control individual enemy behavior.

**Responsibilities:**
- Detect nearby players
- Chase player if in range
- Attack when close enough
- Return to spawn if player too far

**State Machine:**
```
Idle → (player nearby) → Chasing → (in range) → Attacking
Attacking → (player far) → Chasing → (too far) → Idle
```

**Dependencies:**
- Enemy's current position
- Player positions

**Beginner Pitfalls:**
- ❌ Don't use `while true do` loops (use Heartbeat)
- ❌ Don't pathfind every frame (expensive)
- ❌ Check if player is still alive before attacking

**Incremental Tasks:**
1. Spawn a single static enemy
2. Add HP and death detection
3. Implement "Idle" state (just stand there)
4. Add "Chasing" state (move toward player)
5. Add "Attacking" state (deal damage)
6. Add respawn logic

---

### 4. Progression System (Server + Shared)

#### `LevelScaling.luau` (Shared)

**Purpose:** Calculate stat growth and XP requirements.

**Responsibilities:**
- Calculate XP needed for next level
- Calculate stat increases per level
- Provide formulas for enemy scaling

**Example Functions:**
```lua
function LevelScaling.GetXPForLevel(level)
    return level * 100 -- Simple linear scaling
end

function LevelScaling.GetStatsForLevel(level)
    return {
        MaxHP = 100 + (level * 10),
        Damage = 10 + (level * 2)
    }
end
```

**Why shared?**
- Client can show "XP to next level" without asking server
- Server uses same formulas for consistency

**Beginner Pitfalls:**
- ❌ Don't make leveling too fast or too slow (playtest!)
- ❌ Remember to update MaxHP when leveling up

**Incremental Tasks:**
1. Write XP formula on paper first
2. Implement `GetXPForLevel()`
3. Test by printing XP requirements for levels 1-10
4. Add stat scaling formulas
5. Connect to DataService for level-ups

---

### 5. Shop System (Server + Client)

#### Server: `ShopService.luau`

**Purpose:** Handle weapon purchases.

**Responsibilities:**
- Validate purchase requests
- Check if player has enough coins
- Deduct coins and equip weapon
- Update player data

**Inputs:**
- RemoteFunction: `PurchaseWeapon(weaponName)`

**Outputs:**
- Returns success/failure
- Updates `DataService`

**Dependencies:**
- `WeaponData.luau` (prices, stats)
- `DataService` (coins, equipped weapon)

**Beginner Pitfalls:**
- ❌ Never trust client to send price (server looks it up)
- ❌ Check if player already owns weapon
- ❌ Use RemoteFunction (needs return value), not RemoteEvent

#### Client: `ShopController.luau`

**Purpose:** Display shop UI and handle clicks.

**Responsibilities:**
- Show weapon list with prices
- Handle "Buy" button clicks
- Update UI after purchase

**Dependencies:**
- `WeaponData.luau` (to display items)
- `RemoteEvents.luau`

**Incremental Tasks:**
1. Create `WeaponData.luau` with 3 weapons
2. Build basic shop UI (ScreenGui)
3. Display weapon names and prices
4. Add "Buy" button that prints weapon name
5. Connect to server purchase logic
6. Add feedback (success/error messages)

---

### 6. Configuration Files (Shared)

#### `GameConfig.luau`

**Purpose:** Global game settings.

```lua
return {
    ATTACK_COOLDOWN = 1.0,
    ENEMY_RESPAWN_TIME = 10,
    AUTO_SAVE_INTERVAL = 300,
    MAX_LEVEL = 50
}
```

#### `WeaponData.luau`

**Purpose:** All weapon definitions.

```lua
return {
    ["Starter Sword"] = {
        Damage = 10,
        Price = 0,
        Description = "A basic sword"
    },
    ["Iron Blade"] = {
        Damage = 20,
        Price = 100,
        Description = "Stronger than starter"
    }
}
```

#### `EnemyData.luau`

**Purpose:** Enemy templates.

```lua
return {
    ["Slime"] = {
        MaxHP = 50,
        Damage = 5,
        XPReward = 10,
        CoinReward = 5,
        ModelName = "SlimeModel"
    }
}
```

**Why separate config files?**
- Balance game without touching code
- Easy to add new content
- Designers can edit without breaking systems

---

## Network Layer

### `RemoteEvents.luau` (Shared)

**Purpose:** Centralize all client-server communication.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")

return {
    AttackRequested = RemotesFolder.AttackRequested,
    DamageDealt = RemotesFolder.DamageDealt,
    PurchaseWeapon = RemotesFolder.PurchaseWeapon
    -- etc.
}
```

**Why centralize?**
- Easy to see all network traffic
- Prevents typos in remote names
- One place to add security checks

**Beginner Pitfalls:**
- ❌ Don't create remotes in scripts (create in Studio first)
- ❌ Always validate data sent from client

---

## System Interaction Diagram

```
Player Joins
    ↓
DataService loads profile
    ↓
Client receives initial stats
    ↓
UIController displays HP/Level
    ↓
Player clicks to attack
    ↓
CombatController raycasts target
    ↓
Sends AttackRequested to server
    ↓
CombatService validates
    ↓
CombatMath calculates damage
    ↓
EnemyService updates enemy HP
    ↓
If enemy dies:
    - Award XP/Coins
    - Check for level up
    - Respawn enemy after delay
    ↓
Server sends DamageDealt to client
    ↓
UIController shows damage number
```

---

## Implementation Order (Recommended)

### Phase 1: Foundation
1. Set up Rojo folder structure
2. Create all config files with placeholder data
3. Build `RemoteEvents.luau` and create remotes in Studio
4. Implement `PlayerData.luau` with default values

### Phase 2: Data Persistence
1. Install ProfileStore
2. Build `DataService` (load/save only)
3. Test by printing data on join
4. Add auto-save

### Phase 3: Basic Combat
1. Create `CombatMath.luau` with simple damage formula
2. Build `CombatController` (detect clicks, print target)
3. Build `CombatService` (receive requests, print validation)
4. Connect damage calculation
5. Test with a dummy part as "enemy"

### Phase 4: Enemy System
1. Create one enemy model in workspace
2. Build `EnemyService` (spawn single enemy)
3. Add HP tracking
4. Connect to combat system (take damage)
5. Implement death and respawn
6. Add `EnemyAI` (Idle state only)
7. Add Chasing state
8. Add Attacking state

### Phase 5: Progression
1. Build `LevelScaling.luau`
2. Award XP on enemy kill
3. Implement level-up logic
4. Update stats on level up
5. Test by killing enemies and leveling

### Phase 6: Shop
1. Create `WeaponData.luau` with 3 weapons
2. Build shop UI
3. Implement `ShopService` (purchase logic)
4. Connect `ShopController` to UI
5. Test purchasing and equipping

### Phase 7: Polish
1. Add UI for HP/XP bars
2. Add damage numbers
3. Add attack animations
4. Add sound effects
5. Balance numbers through playtesting

---

## Common Beginner Mistakes

### 1. **Trusting the Client**
- ❌ Client sends damage amount
- ✅ Client sends "I want to attack", server calculates damage

### 2. **Not Using Modules**
- ❌ All code in one giant script
- ✅ Small, focused modules with clear responsibilities

### 3. **Hardcoding Values**
- ❌ `local damage = 10` scattered everywhere
- ✅ `local damage = WeaponData[weaponName].Damage`

### 4. **Forgetting to Clean Up**
- ❌ Enemies pile up in workspace
- ✅ Destroy enemy model on death, track in table

### 5. **Over-Engineering**
- ❌ Building a complex event bus system
- ✅ Simple RemoteEvents work fine

---

## Testing Checklist

After each phase, verify:
- [ ] No errors in output
- [ ] System works in solo mode
- [ ] System works in local server (2+ players)
- [ ] Data saves and loads correctly
- [ ] Client can't exploit server logic

---

## Project Checklist

**Primary Guide:** Follow `CHECKLIST.md` for task-by-task implementation order.

The checklist breaks down the architecture into concrete, testable tasks. Use this architecture document to understand:
- **Why** each system exists
- **How** systems connect
- **What** modules you need to create

Use the checklist to know:
- **Which** task to do next
- **When** a task is complete
- **What** to test after each step

The checklist phases map to the architecture like this:
- **Checklist Phase 1 (Foundation)** → Architecture Phase 1 + basic PlayerData
- **Checklist Phase 2 (Combat)** → Architecture Phase 3 (Combat System + Enemy System)
- **Checklist Phase 3 (Progression)** → Architecture Phase 4 (Progression System)
- **Checklist Phase 4 (Weapons)** → Architecture Phase 5 (Shop System)
- **Checklist Phase 5 (Data Saving)** → Architecture Phase 2 (Data Persistence)

**Note:** The checklist intentionally delays data persistence until after core gameplay works. This lets you test and iterate faster without worrying about save/load bugs.

---

## Next Steps

1. Read through this architecture document to understand the big picture
2. Open `CHECKLIST.md` and start checking off tasks
3. When you need to understand HOW to build something, come back here
4. Ask questions before writing code
5. Test after every checkbox

**Remember:** You're building this to learn, not to ship fast. Take your time, understand each system, and ask "why" before writing code.

Good luck! 🎮
