local MorphBug = {}
MorphBug.OptionEnable = Menu.AddOption({"mlambers", "Morph Alce Bug"}, "1. Enable", "")
MorphBug.OptionKey = Menu.AddKeyOption({"mlambers", "Morph Alce Bug"}, "2. Key to execute Alchemist", Enum.ButtonCode.KEY_D)
MorphBug.OptionKeyTiny = Menu.AddKeyOption({"mlambers", "Morph Alce Bug"}, "3. Key to execute Tiny", Enum.ButtonCode.KEY_D)
MorphBug.OptionKeyBrood = Menu.AddKeyOption({"mlambers", "Morph Alce Bug"}, "4. Key to execute Brood", Enum.ButtonCode.KEY_D)

local Ab = nil
local Ab2 = nil
local Ab3 = nil
local MyHero = nil
local Victim = nil

function MorphBug.OnScriptLoad()
    MyHero = nil
	Ab = nil
    Ab2 = nil
    Ab3 = nil
    Victim = nil
end

function MorphBug.Alchemist()
	-- go through abilities because morphling doesn't actually "have" the ability
    -- and a new ability is created if concoction is manually casted again.
    if Ab == nil or not Abilities.Contains(Ab) or Entity.GetOwner(Ab) ~= MyHero then
        for i=1, Abilities.Count() do
            local potential_ability = Abilities.Get(i)

            if Entity.GetOwner(potential_ability) == MyHero then
                if Ability.GetName(potential_ability) == 'alchemist_unstable_concoction_throw' then
                    Ab = potential_ability
                    break
                end
            end
        end
    end

    if Ab == nil then return end

    if  Menu.IsKeyDown(MorphBug.OptionKey) and Input.IsInputCaptured() == false  then
        Victim = Input.GetNearestHeroToCursor(Entity.GetTeamNum(MyHero), Enum.TeamType.TEAM_ENEMY)

        if Victim == nil then return end
        Ability.CastTarget(Ab, Victim)
	end
end

function MorphBug.Tiny()
	if Ab2 == nil or not Abilities.Contains(Ab2) or Entity.GetOwner(Ab2) ~= MyHero then
		if Ability.GetName( NPC.GetAbilityByIndex(MyHero, 2) ) == 'tiny_toss_tree' then
			Ab2 = NPC.GetAbilityByIndex(MyHero, 2)
		end
	end
	
	if Ab2 == nil or Entity.IsAbility(Ab2) == false then return end

	if  Menu.IsKeyDown(MorphBug.OptionKeyTiny) and Input.IsInputCaptured() == false  then
		Ability.CastPosition(Ab2, Input.GetWorldCursorPos())
	end
end

function MorphBug.Brood()
    if Ab3 == nil or not Abilities.Contains(Ab3) or Entity.GetOwner(Ab3) ~= MyHero then
        if Ability.GetName( NPC.GetAbilityByIndex(MyHero, 1) ) == 'broodmother_spin_web' then
			Ab3 = NPC.GetAbilityByIndex(MyHero, 1)
        end
    else
        -- Refresh Web
        if 
            NPC.HasModifier(MyHero, "modifier_morphling_replicate")
            and Ability.GetName( NPC.GetAbilityByIndex(MyHero, 1) ) == 'broodmother_spin_web'
            and Ability.GetLevelSpecialValueFor(Ab3, "count") ~= Ability.GetLevelSpecialValueFor(NPC.GetAbilityByIndex(MyHero, 1), "count")
        then
            Ab3 = NPC.GetAbilityByIndex(MyHero, 1)
        end

        if  Menu.IsKeyDownOnce(MorphBug.OptionKeyBrood) and Input.IsInputCaptured() == false  then
            Ability.CastPosition(Ab3, Input.GetWorldCursorPos())
        end
	end
end

function MorphBug.OnUpdate()
    if Menu.IsEnabled(MorphBug.OptionEnable) == false then return end

    if MyHero == nil or MyHero ~= Heroes.GetLocal() then
        MyHero = Heroes.GetLocal()
		Ab = nil
        Ab2 = nil
        Ab3 = nil
        Victim = nil
        Console.Print("Script init MorphBug.lua")
        return
    end

    if Entity.GetClassName(MyHero) ~= 'C_DOTA_Unit_Hero_Morphling' then return end
   
    if Entity.IsAlive(MyHero) then
		MorphBug.Alchemist()
        MorphBug.Tiny()
        MorphBug.Brood()
    end
end

return MorphBug