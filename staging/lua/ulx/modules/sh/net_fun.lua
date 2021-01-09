-- ULX Module: Extra Fun Module
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with various functions for FUN!
-- Includes: 
--		Model Changing
if not ulx then
	print("Attempted to Load Internet's Utilities - Fun Module, but ULX was not present.")
	return
end
function ulx.model(calling_ply, target_plys, model)
	for id, ply in pairs(target_plys) do
		if not ply:Alive() then
			ULib.tsayError(calling_ply, target_plys[i]:Nick().." is dead!", true)
		else
			ply:SetModel(model)
		end
	end
	ulx.fancyLogAdmin(calling_ply, "#A set the model for #T to #s", target_plys, model)
end
local model = ulx.command("Fun", "ulx model", ulx.model, "!model")
model:addParam{type=ULib.cmds.PlayersArg}
model:addParam{type=ULib.cmds.StringArg, hint="Model Path"}
model:defaultAccess(ULib.ACCESS_ADMIN)
model:help("Set a player's model.")