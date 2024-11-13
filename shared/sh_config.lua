--! DONT FORGET TO CHECK THE DOCUMENTATION TO ENSURE EVERYTHING WORKS CORRECTLY: https://cloud-service-1.gitbook.io/docs/free-resources/cloud-deathscreen

return {
	--[[ FRAMEWORK SETTINGS ]]
	Framework = "esx", -- Options: "esx", "qbcore" or "custom"
	Voice = "pma-voice", -- Options: "pma-voice" or "saltychat". Set to `false` to disable the voice chat deafen feature when dead.

	--[[ TIMERS ]]
	MainTimer = 600, -- Time (in seconds) until the player is fully dead
	FaceDeathTimer = 5, -- Time (in seconds) until the player can click the "FACE DEATH" button
	PriceForDeath = 1000, -- Cost for clicking the "FACE DEATH" button

	--[[ UI SETTINGS ]]
	SoundVolume = 0.35,
	BlurUIBackground = true, -- Enable or disable background blur for the death screen UI

	--[[ DEATH ANIMATION SETTINGS ]]
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
