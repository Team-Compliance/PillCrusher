--old horse pill mechanic, unused
local mod = RegisterMod("Pill Crusher", 1);
local game = Game();
rangedown = 0
luckdown = 0
tearsdown = 0

local pillcrusher = Isaac.GetItemIdByName("Pill Crusher");

local PCDesc = "Gives a random {{Pill}} pill when picked up#Increase pill drop rate when held#Consumes currently held pill and applies an effect to the entire room depending on the type of pill"
local PCDescSpa = "Otorga una {{Pill}} pildora aleatoria al tomarlo#Las pildoras aparecen con mas frecuencia#Consume la pildora que posees y aplica un efecto a la sala, basado en la pildora"

if EID then
	EID:addCollectible(pillcrusher, PCDesc, "Pill Crusher", "en_us")
	EID:addCollectible(pillcrusher, PCDescSpa, "Triturador de Pildoras", "spa")
end

function mod:AddPill(player)
    local data = player:GetData()
    data.pilldrop = data.pilldrop or player:GetCollectibleNum(pillcrusher)

    if data.pilldrop < player:GetCollectibleNum(pillcrusher) then
        Isaac.Spawn(5, 70, 0, player.Position, Vector(0,0), player):ToPickup()
        data.pilldrop = player:GetCollectibleNum(pillcrusher)
    end   
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.AddPill)

function mod:use_pillcrusher(boi, rng, p, slot, data)
--for i, e in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, 0, -1, false, false)) do; local p = e:ToPlayer();
  pillcolor = p:GetPill(0)
-- horf and bad gas: poison all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 0 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 44 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:AddPoison(EntityRef(p), 100, 3.5)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--bad trip, modded pills: deal 50 damage to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 1 or Game():GetItemPool():GetPillEffect(pillcolor, p) > 49 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:TakeDamage(50, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--balls of steel, addicted, percs: add weakness (reverse strenght effect) to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 2 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 28 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 29 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--bombs are keys: use dad's key and tower card
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 3 or pillcolor == 14 or pillcolor == 2062 then
                  p:UseActiveItem(Isaac.GetItemIdByName("Dad's Key", false))
                  p:UseCard(17)
  end
--explosive diarrhea, horf: explode all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 4 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 44 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  Isaac.Explode(entity.Position, p, 8)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--full health: kill all non-boss enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 5 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
                  entity:TakeDamage(5000000, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--hp up, hp down: add bleed effect to all non-boss enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 6 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 7 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
                  entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--pretty fly, friends till the end: deal 30 damage to all enemies, every enemy spawns a blue fly
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 10 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 38 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                   entity:TakeDamage(30, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                   p:AddBlueFlies(1, entity.Position, nil)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--range down, range up, shot speed up, shot speed down: range down to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 11 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 12 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 47 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 48 or pillcolor == 14 or pillcolor == 2062 then
	        rangedown = 300
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--speed up, speed down, im drowsy, im excited: slow down all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 13 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 14 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 41 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 42 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                   slowColor = Color(1, 0, 0, 1, 0, 0, 0)
                   entity:AddSlowing(EntityRef(p), 30, 5, slowColor)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--tears down, tears up: removes all projectiles for few seconds
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 15 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 16 or pillcolor == 14 or pillcolor == 2062 then
	        tearsdown = 200
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--luck down, luck up: removes all projectile flags(homing, explosive) for few seconds
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 17 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 18 or pillcolor == 14 or pillcolor == 2062 then
	        luckdown = 300
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--48 hour energy: three uses of dead sea scrolls
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 20 or pillcolor == 14 or pillcolor == 2062 then
                  p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
                  p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
                  p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--hematemesis: deals random damage to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 21 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:TakeDamage(math.random(10,90), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--paralysis: freezes all non-boss enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 22 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
                  entity:AddFreeze(EntityRef(p), 100, 3.5)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--pheromones: adds charm to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 24 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:AddCharmed(EntityRef(p), 100, 3.5)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--amnesia, r u a wizard, ???, retro vision: adds confusion to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 25 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 27 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 31 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 37 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:AddConfusion(EntityRef(p), 100, 3.5)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--lemon party: every enemy spawns lemon mishap creep
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 26 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  Isaac.Spawn(EntityType.ENTITY_EFFECT, 32, 0, entity.Position, Vector(0,0), p):ToEffect()
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--relax, xlax: funi fart
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 30 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 39 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  game:ButterBeanFart(entity.Position, 100, p, true)

                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--infested: deals 30 damage to all enemies, every enemy spawns a blue spider
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 34 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 35 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                   entity:TakeDamage(30, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                   p:AddBlueSpider(entity.Position)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--somethings wrong: every enemy spawns creep
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 40 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  Isaac.Spawn(EntityType.ENTITY_EFFECT, 45, 0, entity.Position, Vector(0,0), p):ToEffect()
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--gulp: spawns random trinket
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 43 or pillcolor == 14 or pillcolor == 2062 then
	        Isaac.Spawn(5, 350, 0, p.Position, Vector(0,0), p)
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--experimental pill: d8
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 49 or pillcolor == 14 or pillcolor == 2062 then
                  p:UseActiveItem(Isaac.GetItemIdByName("D8", false))
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--one makes you small, one makes you larger: shrinks all non-boss enemies in room
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 33 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 32 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
                  entity:AddShrink(EntityRef(p), 30)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--feels like im walking on sunshine, power pill: add rotten tomato effect to all non-boss enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 45 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 36 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
                  entity:AddEntityFlags(EntityFlag.FLAG_BAITED)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--telepill: teleports enemies to random position (Why would you use it?????)
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 19 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity.Position = Isaac.GetRandomPosition()
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--vurp: spawns 3 random pills
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 43 or pillcolor == 14 or pillcolor == 2062 then
	        Isaac.Spawn(5, 70, 0, p.Position, Vector(0,0), p)
	        Isaac.Spawn(5, 70, 0, p.Position, Vector(0,0), p)
	        Isaac.Spawn(5, 70, 0, p.Position, Vector(0,0), p)
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--puberty: adds fear to all enemies
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 9 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:AddFear(EntityRef(p), 100, 3.5)
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--i found pills: heals or damages enemies (idk)
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 8 or pillcolor == 14 or pillcolor == 2062 then
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                  entity:TakeDamage(math.random(0,60), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                   if math.random(0,2) == 2 then
                    entity:TakeDamage(math.random(0,60), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
                   end
                  entity:AddHealth(math.random(0,30))
                  end
                end
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
--i can see forever: shows secret room and super secret room on the floor, gives compass effect
  if Game():GetItemPool():GetPillEffect(pillcolor, p) == 23 or pillcolor == 14 or pillcolor == 2062 then
	        Game():GetLevel():ApplyBlueMapEffect()
                Game():GetLevel():ApplyCompassEffect()
                SFXManager():Play(462, 1, 2, false, 1, 0)
  end
   if pillcolor > 2000 then
    Isaac.Spawn(5, 70, pillcolor-2048, p.Position, Vector(0,0), p):ToPickup()
                SFXManager():Play(462, 1, 2, false, 1, 0)
   end
   p:SetPill(0,0)
  return true
--end
end

mod:AddCallback( ModCallbacks.MC_USE_ITEM, mod.use_pillcrusher, pillcrusher);

function mod:player_effect( p )
	for i, e in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, 0, -1, false, false)) do; local p = e:ToPlayer();
	        for _, entity in pairs(Isaac.GetRoomEntities()) do
		  if entity.Type == 9 then
                   if rangedown > 0 then
                     local proj = entity:ToProjectile()
                     proj.Height = proj.Height + 7
                   end
                   if tearsdown > 0 then
                     local proj = entity:ToProjectile()
                     proj:Remove()
                   end
                   if luckdown > 0 then
                     local proj = entity:ToProjectile()
                     proj.ProjectileFlags = 0
                   end
                  end
                end
                rangedown = rangedown - 1
                luckdown = luckdown - 1
                tearsdown = tearsdown - 1
	end
end

mod:AddCallback( ModCallbacks.MC_POST_UPDATE  , mod.player_effect, EntityType.ENTITY_PLAYER );

function mod:gameRoom()
local room = game:GetRoom()
 for i=0, game:GetNumPlayers()-1 do
    local player = Isaac.GetPlayer(i)
    if room:IsFirstVisit() and player:HasCollectible(pillcrusher) == true and math.random(1,2) == 2 then
     Isaac.Spawn(5, 70, 0, player.Position, Vector(0,0), player):ToPickup()
    end
 end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.gameRoom);