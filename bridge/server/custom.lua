local Config = require("shared.sh_config")
local Locales = require("shared.sh_locales")

if Config.Framework ~= "custom" then return end

--- Processes payment of the fine for death and notifies the player.
---@param source number  -- The player’s source ID
---@return boolean  -- Returns true if the fine was successfully paid, false otherwise
local function PayFine(source)
	local player = GetPlayerId(source) -- Retrieve the player object using their source ID
	if not player then return false end

	local amount = Config.PriceForDeath -- Fine amount to be paid
	local moneyAvailable = player.GetMoney("cash") -- Player’s available cash balance
	local bankAvailable = player.GetMoney("bank") -- Player’s available bank balance

	-- Attempt to pay with cash first, then bank, and notify accordingly
	if moneyAvailable >= amount then
		player.RemoveMoney("cash", amount) -- Remove Player’s cash
		ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
		return true
	elseif bankAvailable >= amount then
		player.RemoveMoney("bank", amount) -- Remove Player’s bank money
		ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
		return true
	else
		ServerNotify(source, Locales.Notify.NoMoney, "error")
		return false
	end
end

-- Registers the PayFine function as a server callback
lib.callback.register("cloud-deathscreen:server:PayFine", PayFine)
