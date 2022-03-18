PillCrusher = RegisterMod("Pill Crusher", 1);
local mod = PillCrusher

CollectibleType.COLLECTIBLE_PILL_CRUSHER = Isaac.GetItemIdByName("Pill Crusher");

rangedown = 0
luckdown = 0
tearsdown = 0

local PCDesc = "Gives a random {{Pill}} pill when picked up#Increase pill drop rate when held#Consumes currently held pill and applies an effect to the entire room depending on the type of pill"
local PCDescSpa = "Otorga una {{Pill}} pildora aleatoria al tomarlo#Las pildoras aparecen con mas frecuencia#Consume la pildora que posees y aplica un efecto a la sala, basado en la pildora"
local PCDescRu = "Дает случайную {{Pill}} пилюлю#Увеличивает шанс появления пилюль#Использует текущую пилюлю и накладывает зависимый от её типа эффект на всю комнату"
local PCDescPt_Br = "Gere uma pílula {{Pill}} aleatória quando pego#Almente a taxa de queda de pílulas# Consome a pílula segurada e aplique um efeito na sala inteira dependendo no tipo de pílula"

if EID then
	EID:addCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDesc, "Pill Crusher", "en_us")
	EID:addCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDescSpa, "Triturador de Pildoras", "spa")
	EID:addCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDescRu, "Дробилка пилюль", "ru")
	EID:addCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDesc, "Triturador de Pílula", "pt_br")
end

function mod:AddPill(player)
    local data = player:GetData()
    data.pilldrop = data.pilldrop or player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PILL_CRUSHER)

    if data.pilldrop < player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PILL_CRUSHER) then
        Isaac.Spawn(5, 70, 0, player.Position, Vector(0,0), player):ToPickup()
        data.pilldrop = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PILL_CRUSHER)
    end   
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.AddPill)

function mod:use_pillcrusher(boi, rng, p, slot, data)
	--for i, e in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, 0, -1, false, false)) do; local p = e:ToPlayer();
	local pillcolor = p:GetPill(0)
	if pillcolor == 0 then return false end
	
	-- horf and bad gas: poison all enemies (horse pill: poison lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 0 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 44 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				if pillcolor > 2000 then
					entity:AddPoison(EntityRef(p), 10000, 3.5)
				end
				if pillcolor < 2000 then
					entity:AddPoison(EntityRef(p), 100, 3.5)
				end
			end
		end
	end
	--bad trip, modded pills: deal 50 damage to all enemies (horse: deals 100 damage)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 1 or Game():GetItemPool():GetPillEffect(pillcolor, p) > 49 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				if pillcolor < 2000 then
					entity:TakeDamage(50, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				end
				if pillcolor > 2000 then
					entity:TakeDamage(100, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				end
			end
		end
	end
	--balls of steel, addicted, percs: add weakness (reverse strenght effect) to all enemies (horse: adds bleed)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 2 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 28 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 29 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
				if pillcolor > 2000 then
					entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
				end
			end
		end
	end
	--bombs are keys: use dad's key and tower card (horse: more troll bombs)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 3 or pillcolor == 14 or pillcolor == 2062 then
		p:UseActiveItem(Isaac.GetItemIdByName("Dad's Key", false))
		p:UseCard(17)
		if pillcolor > 2000 then
			p:UseCard(17)
		end
	end
	--explosive diarrhea, horf: explode all enemies (horse: explosion deals more damage)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 4 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 44 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then                
				if pillcolor < 2000 then
					Isaac.Explode(entity.Position, p, 8)
				end
				if pillcolor > 2000 then
					Isaac.Explode(entity.Position, p, 30)
				end
			end
		end
	end
	--full health: kill all non-boss enemies (horse: deals 100 damage to bosses)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 5 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
				entity:TakeDamage(5000000, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
			end
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == true and pillcolor > 2000 then
				entity:TakeDamage(100, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
			end
		end
	end
	--hp up, hp down: add bleed effect to all non-boss enemies (horse: deals 100 damage to bosses)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 6 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 7 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
				entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
			end
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == true and pillcolor > 2000 then
				entity:TakeDamage(100, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
			end
		end
	end
	--pretty fly, friends till the end: deal 30 damage to all enemies, every enemy spawns a blue fly (horse: more blue flies)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 10 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 38 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:TakeDamage(30, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				p:AddBlueFlies(1, entity.Position, nil)
				if pillcolor > 2000 then
					p:AddBlueFlies(1, entity.Position, nil)
				end
			end
		end
	end
	--range down, range up, shot speed up, shot speed down: range down to all enemies (horse: range down lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 11 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 12 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 47 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 48 or pillcolor == 14 or pillcolor == 2062 then
		rangedown = 300
		if pillcolor > 2000 then
			rangedown = 500
		end
	end
	--speed up, speed down, im drowsy, im excited: slow down all enemies (horse: range down)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 13 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 14 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 41 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 42 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				slowColor = Color(1, 0, 0, 1, 0, 0, 0)
				entity:AddSlowing(EntityRef(p), 30, 5, slowColor)
			end
			if pillcolor > 2000 then
				rangedown = 100
			end
		end
	end
	--tears down, tears up: removes all projectiles for few seconds (horse: tears down lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 15 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 16 or pillcolor == 14 or pillcolor == 2062 then
		tearsdown = 200
		if pillcolor > 2000 then
			tearsdown = 400
		end
	end
	--luck down, luck up: removes all projectile flags(homing, explosive) for few seconds (horse: luck down lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 17 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 18 or pillcolor == 14 or pillcolor == 2062 then
		luckdown = 300
		if pillcolor > 2000 then
			luckdown = 700
		end
	end
	--48 hour energy: three uses of dead sea scrolls (horse pill: another dead sea scolls use)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 20 or pillcolor == 14 or pillcolor == 2062 then
		p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
		p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
		p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
		if pillcolor > 2000 then
			p:UseActiveItem(Isaac.GetItemIdByName("Dead Sea Scrolls", false))
		end
	end
	--hematemesis: deals random damage to all enemies (horse: more damage)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 21 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:TakeDamage(mod:GetRandomNumber(10,90,rng), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				if pillcolor > 2000 then
					entity:TakeDamage(mod:GetRandomNumber(10,20,rng), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				end
			end
		end
	end
	--paralysis: freezes all non-boss enemies (horse: Watch what happens when I cast spell I don't know!)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 22 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
				entity:AddFreeze(EntityRef(p), 100, 3.5)
				if pillcolor > 2000 then
					entity:AddEntityFlags(EntityFlag.FLAG_ICE)
					entity:TakeDamage(9999999, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				end
			end
		end
	end
	--pheromones: adds charm to all enemies (horse: every enemy becomes contagious)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 24 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:AddCharmed(EntityRef(p), 100, 3.5)
			end
			if pillcolor > 2000 then
				entity:AddEntityFlags(EntityFlag.FLAG_CONTAGIOUS)
			end
		end
	end
	--amnesia, r u a wizard, ???, retro vision: adds confusion to all enemies (horse: confusion lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 25 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 27 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 31 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 37 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:AddConfusion(EntityRef(p), 60, 3.5)
				if pillcolor > 2000 then
					entity:AddConfusion(EntityRef(p), 600, 3.5)
				end
			end
		end
	end
	--lemon party: every enemy spawns lemon mishap creep (horse: adds poison)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 26 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, 32, 0, entity.Position, Vector(0,0), p):ToEffect()
			end
			if pillcolor > 2000 then
				entity:AddPoison(EntityRef(p), 100, 3.5)
			end
		end
	end
	--relax, xlax: funi fart (horse: uses flush)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 30 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 39 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				Game():ButterBeanFart(entity.Position, 100, p, true)
			end
		end
		if pillcolor > 2000 then
			p:UseActiveItem(Isaac.GetItemIdByName("Flush!", false))
		end
	end
	--infested: deals 30 damage to all enemies, every enemy spawns a blue spider (horse: more blue spider)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 34 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 35 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:TakeDamage(30, DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				p:AddBlueSpider(entity.Position)
				if pillcolor > 2000 then
					p:AddBlueSpider(entity.Position)
				end
			end
		end
	end
	--somethings wrong: every enemy spawns creep (horse: range down)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 40 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, 45, 0, entity.Position, Vector(0,0), p):ToEffect()
			end
			if pillcolor > 2000 then
				rangedown = 100
			end
		end
	end
	--gulp: spawns random trinket (horse: gives 2 trinkets)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 43 or pillcolor == 14 or pillcolor == 2062 then
		Isaac.Spawn(5, 350, 0, p.Position, Vector.FromAngle(mod:GetRandomNumber(0,360,rng)):Resized(3), p)
		if pillcolor > 2000 then
			Isaac.Spawn(5, 350, 0, p.Position, Vector.FromAngle(mod:GetRandomNumber(0,360,rng)):Resized(3), p)
		end
	end
	--experimental pill: d8 (horse: gives another experimental pill)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 49 or pillcolor == 14 or pillcolor == 2062 then
		p:UseActiveItem(Isaac.GetItemIdByName("D8", false))
		if pillcolor > 2000 and pillcolor < 2062 then
			Isaac.Spawn(5, 70, pillcolor-2048, p.Position, Vector(0,0), p):ToPickup()
		end
	end
	--one makes you small, one makes you larger: shrinks all non-boss enemies in room (horse: shrink effect lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 33 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 32 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
				entity:AddShrink(EntityRef(p), 30)
				if pillcolor > 2000 then
					entity:AddShrink(EntityRef(p), 100)
				end
			end
		end
	end
	--feels like im walking on sunshine, power pill: add rotten tomato effect to all non-boss enemies (horse: adds bleed)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 45 or Game():GetItemPool():GetPillEffect(pillcolor, p) == 36 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false then
				entity:AddEntityFlags(EntityFlag.FLAG_BAITED)
				if pillcolor > 2000 then
					entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
				end                   
			end
		end
	end
	--telepill: teleports enemies to random position (Why would you use it?????) (horse: nothing :3)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 19 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity.Position = Isaac.GetRandomPosition()
			end
		end
	end
	--vurp: spawns 3 random pills (horse: spawns 4 random pills)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 46 or pillcolor == 14 or pillcolor == 2062 then
		Isaac.Spawn(5, 70, 0, p.Position, Vector.FromAngle(mod:GetRandomNumber(0,360,rng)):Resized(3), p)
		Isaac.Spawn(5, 70, 0, p.Position, Vector.FromAngle(mod:GetRandomNumber(0,360,rng)):Resized(3), p)
		Isaac.Spawn(5, 70, 0, p.Position, Vector.FromAngle(mod:GetRandomNumber(0,360,rng)):Resized(3), p)
		if pillcolor > 2000 then
			Isaac.Spawn(5, 70, 0, p.Position, Vector.FromAngle(mod:GetRandomNumber(0,360,rng)):Resized(3), p)
		end 
	end
	--puberty: adds fear to all enemies (horse: fear lasts longer)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 9 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:AddFear(EntityRef(p), 100, 3.5)
				if pillcolor > 2000 then
					entity:AddFear(EntityRef(p), 1000, 3.5)
				end 
			end
		end
	end
	--i found pills: heals or damages enemies (idk) (horse: 100% to damage enemies)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 8 or pillcolor == 14 or pillcolor == 2062 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type >= 10 and entity.Type <= 999 and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
				entity:TakeDamage(mod:GetRandomNumber(0,60,rng), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				if mod:GetRandomNumber(0,2,rng) == 2 then
					entity:TakeDamage(mod:GetRandomNumber(0,60,rng), DamageFlag.DAMAGE_LASER, EntityRef(p), 0)
				end
				if pillcolor < 2000 then
					entity:AddHealth(mod:GetRandomNumber(0,30,rng))
				end                   
			end
		end
	end
	--i can see forever: shows secret room and super secret room on the floor, gives compass effect (horse: shows map)
	if Game():GetItemPool():GetPillEffect(pillcolor, p) == 23 or pillcolor == 14 or pillcolor == 2062 then
		Game():GetLevel():ApplyBlueMapEffect()
		Game():GetLevel():ApplyCompassEffect()
		if pillcolor > 2000 then
			Game():GetLevel():ApplyMapEffect()
		end
	end
	--old horse pill mechanic
	--   if pillcolor > 2000 then
	--    Isaac.Spawn(5, 70, pillcolor-2048, p.Position, Vector(0,0), p):ToPickup()
	--                SFXManager():Play(462, 1, 2, false, 1, 0)
	--   end
	if pillcolor ~= 0 then
		Game():GetItemPool():IdentifyPill(pillcolor)
		p:SetPill(0,0)
	end
	SFXManager():Play(462, 1, 2, false, 1, 0)
	return true
	--end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.use_pillcrusher, CollectibleType.COLLECTIBLE_PILL_CRUSHER)

function mod:player_effect( p )
	for i, e in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, 0, -1, false, false)) do
		local p = e:ToPlayer()
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
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.player_effect, EntityType.ENTITY_PLAYER)

function mod:spawnPill(rng, pos)
	local spawnposition = Game():GetRoom():FindFreePickupSpawnPosition(pos)
	for i=0, Game():GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER) == true and mod:GetRandomNumber(1,3,rng) == 1 then
			print("should spawn")
			Isaac.Spawn(5, 70, 0, spawnposition, Vector.Zero, player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.spawnPill)

--spawns 3 pills on greed mode
function mod:item_effect()
	local room = Game():GetRoom()
	for i=0, Game():GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER) == true and Game():IsGreedMode() == true then
			Isaac.Spawn(5, 70, 0, player.Position, Vector.FromAngle(math.random(0,360)):Resized(3), player)
			Isaac.Spawn(5, 70, 0, player.Position, Vector.FromAngle(math.random(0,360)):Resized(3), player)
			Isaac.Spawn(5, 70, 0, player.Position, Vector.FromAngle(math.random(0,360)):Resized(3), player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.item_effect)

function mod:DefaultWispInit(wisp)
	local player = wisp.Player
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PILL_CRUSHER) then
		if wisp.SubType == CollectibleType.COLLECTIBLE_PILL_CRUSHER then
			wisp.SubType = 102
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.DefaultWispInit, FamiliarVariant.WISP)

function mod:GetRandomNumber(numMin, numMax, rng)
	if not numMax then
		numMax = numMin
		numMin = nil
	end

	if type(rng) == "number" then
		local seed = rng
		rng = RNG()
		rng:SetSeed(seed, 1)
	end
	
	if numMin and numMax then
		return rng:Next() % (numMax - numMin + 1) + numMin
	elseif numMax then
		return rng:Next() % numMin
	end
	return rng:Next()
end
