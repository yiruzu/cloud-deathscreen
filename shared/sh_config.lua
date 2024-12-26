--? For support, join our Discord server: https://discord.gg/jAnEnyGBef
--? Dont forget to check out the Documentation: https://cloud-resources.gitbook.io/docs/free-resources/cloud-deathscreen

return {
	--[[ GENERAL SETTINGS ]]
	Framework = "esx", -- Supported: "esx", "qbcore" or "custom"
	Voice = "pma-voice", -- Supported: "pma-voice" or "saltychat". Set to `false` to disable the voice chat deafen feature when dead.

	--[[ TIMER SETTINGS ]]
	MainTimer = 600, -- Time (in seconds) until the player is fully dead
	FaceDeathTimer = 5, -- Time (in seconds) until the player can click the "FACE DEATH" button
	PriceForDeath = 1000, -- Cost for clicking the "FACE DEATH" button

	--[[ UI SETTINGS ]]
	SoundVolume = 0.35,
	BlurUIBackground = true, -- Enable or disable background blur for the death screen UI

	--[[ DEATH ANIMATION ]]
	DeathAnim = {
		enabled = true, -- Toggle death animation on/off
		animDict = "combat@damage@writhe",
		animName = "writhe_loop",
	},

	--[[ ENABLED CONTROLS ]]
	EnabledControls = {
		245, -- Control key code for chat ([T] by default)
		-- Add other control key codes here if needed
	},
}
