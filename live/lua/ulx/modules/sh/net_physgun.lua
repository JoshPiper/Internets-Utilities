-- ULX Module: Player Freeze Module
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with various functions for FUN!
-- Includes: 
--		Freezing Players
--		Unfreezing Players on Grab
--		Unfreezing Players with "R" Key

if not ulx then
	print("Attempted to Load Internet's Utilities - Physgun Module, but ULX was not present.")
	return
end

--[[ Code Shamelessly borrowed from ULX ]]--
local cl_cvar_pickup = "cl_pickupplayers"
function ulx.physgunPickup(calling_ply, ent)
	local access, tag = calling_ply:query("ulx physgunplayer")
	if ent:IsPlayer() and ULib.isSandbox() and access and not ent.NoNoclip and not ent.frozen and calling_ply:GetInfoNum( cl_cvar_pickup, 1 ) == 1 then
		-- Extra restrictions! UCL wasn't designed to handle this sort of thing so we're putting it in by hand...
		local restrictions = {}
		ULib.cmds.PlayerArg.processRestrictions( restrictions, calling_ply, {}, tag and ULib.splitArgs( tag )[ 1 ] )
		if restrictions.restrictedTargets == false or (restrictions.restrictedTargets and not table.HasValue( restrictions.restrictedTargets, ent )) then
			return
		end
		ent:SetMoveType(MOVETYPE_NONE)
		ent:Freeze(false)
		return true
	end
end

function ulx.physgunDrop(calling_ply, ent)
	if ent:IsValid() and ent:IsPlayer() then
		if ent.freezingPly == calling_ply or calling_ply:query("ulx unfreezeany") then
			ent:Freeze(false)
			ent:SetMoveType(MOVETYPE_WALK)
			ent.freezingPly = nil
		end	
		if calling_ply:KeyDown(IN_ATTACK2) then
			if calling_ply:query("ulx freezeplayers") then
				ent:Freeze(true)
				ent:SetMoveType(MOVETYPE_NONE)
				ent.freezingPly = calling_ply
				return true
			end
		end
	end
end

function ulx.onPhysgunReload(wpn, ply)
	local target = ply:GetEyeTrace().Entity
	if target:IsValid() and target:IsPlayer() then
		if target.freezingPly and target.freezingPly == ply then
			target:Freeze(false)
			target:SetMoveType(MOVETYPE_WALK)
			target.freezingPly = nil
			return true
		elseif ply:query("ulx unfreezeany") then
			target:Freeze(false)
			target:SetMoveType(MOVETYPE_WALK)
			target.freezingPly = nil
			return true
		end
	end
	return
end

if SERVER then
	ULib.ucl.registerAccess("ulx freezeplayers", ULib.ACCESS_ADMIN, "Allows freezing of players with the physgun.", "Utility")
	ULib.ucl.registerAccess("ulx unfreezeany", ULib.ACCESS_ADMIN, "Allows unfreezing of any player, rather than just the ones you froze.", "Utility")
	hook.Remove("PhysgunPickup", "ulxPlayerPickup")
	hook.Add("PhysgunPickup", "IntUtil_PickupPly", ulx.physgunPickup)
	hook.Add("PhysgunDrop", "IntUtil_DropPly", ulx.physgunDrop)
	hook.Add("OnPhysgunReload", "IntUtil_ReloadPly", ulx.onPhysgunReload)
end