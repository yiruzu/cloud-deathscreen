return {
	Framework = "esx", -- "esx" or "qbcore"

	Voice = "pma-voice", -- "pma-voice" or "saltychat"
	-- set to "Voice = false," if you don't want the voice chat deafen feature when dead

	Timer = 600, -- time until death in seconds

	PriceForDeath = 1000, -- the price the player has to pay for clicking "FACE DEATH"

	BlurUIBackground = true,

	EnabledControls = {
		245, -- [T] allows players to open the chat while dead
		-- add more to your liking
	},

	DeathAnim = {
		enabled = true, -- enables the death animation
		animDict = "combat@damage@writhe",
		animName = "writhe_loop",
	},

	Locales = {
		MoneyRemoved = "You paid ~b~$%s~s~ for your hospital bill!",
		NoMoney = "You dont have enough Money!",
	},

	RespawnCoords = vec4(305.6880, -587.5449, 43.2676, 69.8893), --! only for esx bridge
}
