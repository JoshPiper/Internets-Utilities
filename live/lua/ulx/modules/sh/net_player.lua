-- ULX Module: Player Module
-- Made For: Gold Rush Gaming
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with various functions for use with players.
-- Includes:
--		No-Collide (Not hit by players or traces.)

if not ulx then
	print("Attempted to Load Internet's Utilities - Player Module, but ULX was not present.")
	return
end

function ulx.nocollide(ply, shouldRevoke)
	if not ply._NoCollided then
		ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) 
		ply._NoCollided = true
		ULib.tsay(ply, "No-Collide Mode Enable.")
	else
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		ply._NoCollided = false
		ULib.tsay(ply, "No-Collide Mode Disabled.")
	end
end
local nocollide = ulx.command("Player", "ulx nocollide", ulx.nocollide, "!nocollide")
nocollide:defaultAccess(ULib.ACCESS_SUPERADMIN)
nocollide:help("Toggles the player's no-collide mode.")