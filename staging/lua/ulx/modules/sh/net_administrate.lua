-- ULX Module: Administrative Mode
-- Made For: Steam Workshop
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with an administrative mode.
-- Includes:
--		Toggled Admin Mode

--------- Administrator Mode ---------
function ulx.administrate(calling_ply, target_ply)
	if not target_ply then
		target_ply = calling_ply
	end
	
	if not target_ply:IsValid() then
		Msg("You are God, you command everything, no matter what people think of you.")
		return
	end

	if not target_ply.adminMode then -- Player or Not Defined. Either way, go admin.
		target_ply.adminMode = true
		target_ply:GodEnable()
		target_ply:SetMoveType(MOVETYPE_NOCLIP)
		ULib.invisible(target_ply, true, 0)
		ulx.fancyLogAdmin(calling_ply, true, "#A set #T to administrative mode.", target_ply)
	else
		target_ply.adminMode = false
		target_ply:GodDisable()
		target_ply:SetMoveType(MOVETYPE_WALK)
		ULib.invisible(target_ply, false, 0)
		ulx.fancyLogAdmin(calling_ply, true, "#A set #T to player mode.", target_ply)
	end
end

local administrativeMode = ulx.command("Utility", "ulx administrate", ulx.administrate, "!admin")
administrativeMode:addParam{type=ULib.cmds.PlayerArg, ULib.cmds.optional, hint="Player to set to Admin Mode. (Defaults to self.)"}
administrativeMode:defaultAccess( ULib.ACCESS_ADMIN )
administrativeMode:help("Sets the target to administrative mode.")