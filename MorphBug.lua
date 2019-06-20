local MorphBug = {}
MorphBug.OptionEnable = Menu.AddOption({"mlambers", "Morph Alce Bug"}, "1. Enable spin", "")
MorphBug.OptionKey = Menu.AddKeyOption({"mlambers", "Morph Alce Bug"}, "2. Key to execute", Enum.ButtonCode.KEY_D)

local Ab = nil
local MyHero = nil
local Victim = nil

function MorphBug.OnScriptLoad()
	MyHero = nil
	Ab = nil
	Victim = nil
end

function MorphBug.OnUpdate()
	if Menu.IsEnabled(MorphBug.OptionEnable) == false then return end

	if MyHero == nil or MyHero ~= Heroes.GetLocal() then
		MyHero = Heroes.GetLocal()
		Ab = nil
		Victim = nil
		Console.Print("Script init MorphBug.lua")
		return
	end

	if Entity.GetClassName(MyHero) ~= 'C_DOTA_Unit_Hero_Morphling' then return end
	
	if Entity.IsAlive(MyHero) then
		if Ab == nil and NPC.GetAbility(MyHero, 'alchemist_unstable_concoction_throw') then
			Ab = NPC.GetAbility(MyHero, 'alchemist_unstable_concoction_throw')
			return
		end

		if	Menu.IsKeyDown(MorphBug.OptionKey) and Input.IsInputCaptured() == false  then
			if Ab == nil then return end
			Victim = Input.GetNearestHeroToCursor(Entity.GetTeamNum(MyHero), Enum.TeamType.TEAM_ENEMY)

			if Victim == nil then return end

			Ability.CastTarget(Ab, Victim)
		end
	end
end

return MorphBug