# Anime Clash: Development Checklist

## 🎯 MVP Goal
Build a playable loop: Spawn → Fight → Level Up → Buy Weapon → Repeat

---

## Phase 1: Foundation (Do this first)

### Map & World
- [x] Create spawn town (safe zone)
- [x] Build Zone 1: Grass Field
- [x] Add invisible barriers between zones
- [x] Test: Can player walk around without falling?

### Player Setup
- [x] Player spawns with basic stats (HP, Level, Damage)
- [x] HP bar displays correctly
- [x] Level and coins display on UI
- [x] Test: Do stats show up when you join?

---

## Phase 2: Combat (The core loop)

### Basic Attack System
- [x] M1 click = basic attack
- [x] Attack has cooldown (prevent spam)
- [ ] Attack animation plays
- [x] Damage calculation works (Weapon + Level bonus)
- [x] Test: Can you hit a dummy part and see damage?

### Enemy System
- [ ] Spawn 1 weak mob in Zone 1
- [ ] Enemy has HP bar above head
- [ ] Enemy takes damage when hit
- [ ] Enemy dies when HP = 0
- [ ] Enemy respawns after X seconds
- [ ] Test: Can you kill an enemy and see it respawn?

### Enemy AI (Keep it dumb)
- [ ] Enemy detects player in range
- [ ] Enemy walks toward player
- [ ] Enemy attacks player when close
- [ ] Enemy stops chasing if player runs far
- [ ] Test: Does enemy follow you and attack?

---

## Phase 3: Progression

### EXP & Leveling
- [ ] Killing enemy gives EXP
- [ ] EXP bar fills up visually
- [ ] Level up when EXP bar full
- [ ] Level up increases HP + Damage
- [ ] Level up plays effect/sound
- [ ] Test: Kill enemies until you level up

### Coins
- [ ] Killing enemy drops coins
- [ ] Coins add to player total
- [ ] Coin count displays on UI
- [ ] Test: Do coins increase when you kill stuff?

---

## Phase 4: Weapons

### Weapon Shop
- [ ] Create shop NPC or UI in town
- [ ] Shop shows 2-3 weapons with prices
- [ ] Player can buy weapon if enough coins
- [ ] Buying weapon equips it automatically
- [ ] Test: Can you buy and equip a weapon?

### Weapon System
- [ ] Each weapon has different damage value
- [ ] Equipped weapon shows in player's hand
- [ ] Weapon changes attack animation (optional)
- [ ] Test: Does new weapon deal more damage?

---

## Phase 5: Data Saving

### ProfileStore Setup
- [ ] Install ProfileService module
- [ ] Create data template (Level, Coins, Weapon)
- [ ] Save data when player leaves
- [ ] Load data when player joins
- [ ] Test: Leave and rejoin - do stats persist?

### Data Safety
- [ ] If data fails to load → kick player with message
- [ ] Test: Does game handle data errors?

---

## Phase 6: Polish (Make it feel good)

### UI Improvements
- [ ] HP bar turns red when low
- [ ] EXP bar has smooth fill animation
- [ ] Level up shows big text effect
- [ ] Test: Does UI feel responsive?

### Visual Feedback
- [ ] Hit effects when attacking
- [ ] Enemy death effect (particles/fade)
- [ ] Damage numbers pop up (optional)
- [ ] Test: Does combat feel satisfying?

### Audio (If time allows)
- [ ] Attack sound
- [ ] Enemy death sound
- [ ] Level up sound
- [ ] Background music in zones

---

## Phase 7: Expansion (After MVP works)

### More Enemies
- [ ] Add Strong Mob (higher HP/damage)
- [ ] Add Mini-Boss for Zone 1
- [ ] Test: Are enemies balanced?

### Zone 2
- [ ] Build Zone 2 map
- [ ] Add level requirement to enter
- [ ] Spawn Zone 2 enemies
- [ ] Test: Does progression feel natural?

### Skills System
- [ ] Add 1 skill with cooldown
- [ ] Skill button on UI
- [ ] Skill deals more damage than M1
- [ ] Test: Is skill worth using?

---

## 🚫 DO NOT ADD (Scope creep zone)

- ❌ Multiple skills per weapon
- ❌ Combo system
- ❌ Crafting system
- ❌ Party/multiplayer features
- ❌ Complex stat systems (crit, dodge, etc.)
- ❌ Quests (add later if needed)

---

## ✅ Definition of "Done"

A task is complete when:
1. It works without errors
2. You tested it in-game
3. You understand WHY it works
4. You could rebuild it from scratch

---

## 📝 Notes

- Work top to bottom
- Don't skip to "fun" parts
- Test after every checkbox
- If stuck on one task for 2+ hours → ask for help
- Learning > Speed

---

**Current Focus:** ___________________________

**Blockers:** ___________________________
