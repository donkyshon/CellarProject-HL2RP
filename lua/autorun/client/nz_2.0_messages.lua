killicons_color = Color( 255, 0, 0, 0 )

local function AddKillicon(class, material)
	killicon.Add(class,material,killicons_color)
end

if CLIENT then
-- Kill Messages
language.Add("nz_infested", "Infested")
language.Add("nz_infested_torso", "Infested Torso")
language.Add("nz_necrotic_zombie", "Necrotic Zombie")
language.Add("nz_zombine", "Zombine")
language.Add("nz_risen", "Risen")
language.Add("nz_infected", "Infected")
language.Add("nz_crazies", "Type 1")
language.Add("nz_corrupt", "Type 2")
language.Add("nz_grabber", "Type 3")
language.Add("nz_reanimated", "Re-Animated")
language.Add("nz_abnormal_zombie", "Abnormal Zombie")
language.Add("nz_seekers", "Seekers")

language.Add("nz_boss_zombine", "ZSS")
language.Add("nz_berserker", "Berserker")
language.Add("nz_behemoth", "Behemoth")

language.Add("nz_elite_zombine", "Elite Zombine")
language.Add("ent_fakeprop", "Elite Zombine")
end