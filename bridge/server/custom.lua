local Config = require("shared.sh_config")
local Locales = require("shared.sh_locales")

if Config.Framework ~= "custom" then return end

--- Retrieves the Player ID for the given source
---@param source number  -- The player's source ID
---@return number  -- The Player ID
function GetPlayerId(source)
	return GetPlayer(source)
end

--- Processes payment of the fine for death and notifies the player.
---@param source number  -- The player’s source ID
---@return boolean  -- Returns true if the fine was successfully paid, false otherwise
local function PayFine(source)
	-- Retrieve the player object using their source ID
	local Player = GetPlayerId(source)

	if Player then
		local amount = Config.PriceForDeath -- Fine amount to be paid
		local moneyAvailable = Player.GetMoney("cash") -- Player’s available cash balance
		local bankAvailable = Player.GetMoney("bank") -- Player’s available bank balance

		-- Attempt to pay with cash first, then bank, and notify accordingly
		if moneyAvailable >= amount then
			Player.RemoveMoney("cash", amount) -- Remove Player’s cash
			ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
			return true
		elseif bankAvailable >= amount then
			Player.RemoveMoney("bank", amount) -- Remove Player’s bank money
			ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
			return true
		else
			ServerNotify(source, Locales.Notify.NoMoney, "error")
			return false
		end
	end
	return false
end

-- Registers the PayFine function as a server callback
lib.callback.register("cloud-deathscreen:server:PayFine", PayFine)
