return {
	Framework = "esx", -- "esx" or "qbcore"

	Voice = "pma-voice", -- "pma-voice" or "saltychat". Set to "Voice = false," to disable the voice chat deafen feature when dead

	MainTimer = 600, -- Time (in seconds) until the player is fully dead
	FaceDeathTimer = 5, -- Time (in seconds) until the player can click the "FACE DEATH" button

	PriceForDeath = 1000, -- The amount of money the player has to pay for clicking the "FACE DEATH" button

	BlurUIBackground = true, -- Enables or disables blurring the UI background when the death screen is active

	EnabledControls = {
		245, -- Allows players to open the chat while dead ([T] by default)
		-- Add additional control key codes if needed
	},

	DeathAnim = {
		enabled = true, -- Toggle to enable or disable the death animation
		animDict = "combat@damage@writhe",
		animName = "writhe_loop",
	},

	Locales = {
		MoneyRemoved = "You paid ~b~$%s~s~ for your hospital bill!",
		NoMoney = "You don't have enough Money!",
	},

	RespawnCoords = vec4(305.6880, -587.5449, 43.2676, 69.8893), -- Respawn coordinates --! (ONLY FOR ESX)
}
