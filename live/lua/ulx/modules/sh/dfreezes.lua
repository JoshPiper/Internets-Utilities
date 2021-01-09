-- ULX Module: .50 Cal Desert Eagle's Commands.
-- Made For: .50 Cal Desert Eagle
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with stuff for the people.
-- Includes:

if not ulx then
	print("Attempted to Load .50 Cal Desert Eagle's Commands, but ULX was not present.")
	return
end


local gunshotPath = "sounds/deagles_ulx/akgunshot.wav" -- The path for the gunshot sound.
local nukePath = "sounds/deagles_ulx/nuke.wav" -- ^ for the nuke.

resource.AddFile(gunshotPath) -- Make sure that the file is sent to clients, so they can hear it.
resource.AddFile(nukePath)
-- Can be commented out if you're using the workshop to send sounds.

-- Copied directly from the Git.
-- Utility function to give a place for a player to stand.
local function playerSend(from, to, force)
	if not to:IsInWorld() and not force then return false end -- No way we can do this one

	local yawForward = to:EyeAngles().yaw
	local directions = { -- Directions to try
		math.NormalizeAngle( yawForward - 180 ), -- Behind first
		math.NormalizeAngle( yawForward + 90 ), -- Right
		math.NormalizeAngle( yawForward - 90 ), -- Left
		yawForward,
	}

	local t = {}
	t.start = to:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
	t.filter = { to, from }

	local i = 1
	t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
	local tr = util.TraceEntity( t, from )
	while tr.Hit do -- While it's hitting something, check other angles
		i = i + 1
		if i > #directions then	 -- No place found
			if force then
				from.ulx_prevpos = from:GetPos()
				from.ulx_prevang = from:EyeAngles()
				return to:GetPos() + Angle( 0, directions[ 1 ], 0 ):Forward() * 47
			else
				return false
			end
		end

		t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47

		tr = util.TraceEntity( t, from )
	end

	from.ulx_prevpos = from:GetPos()
	from.ulx_prevang = from:EyeAngles()
	return tr.HitPos
end


function ulx.freeze2(calling_ply, target_plys, time, reason)
	local effected = {}
	
	for i = 1, #target_plys do
		local target_ply = target_plys[i]
		
		if calling_ply:IsValid() and not should_unfreeze then
			if ulx.getExclusive(calling_ply, calling_ply) then
				ULib.tsayError(calling_ply, ulx.getExclusive( calling_ply, calling_ply), true)
				return
			end
			
			if ulx.getExclusive(target_ply, calling_ply ) then
				ULib.tsayError(calling_ply, ulx.getExclusive( target_ply, calling_ply ), true)
				return
			end
	
			if not target_ply:Alive() then
				ULib.tsayError(calling_ply, target_ply:Nick() .. " is dead!", true)
				return
			end
			if not calling_ply:Alive() then
				return
			end
			
			if calling_ply:InVehicle() then
				ULib.tsayError(calling_ply, "Please leave the vehicle first!", true)
				return
			end
		
			if target_ply:InVehicle() then
				target_ply:ExitVehicle()
			end
			
			local newpos = playerSend(target_ply, calling_ply, target_ply:GetMoveType() == MOVETYPE_NOCLIP)
			if not newpos then
				ULib.tsayError(calling_ply, "Can't find a place to put " .. target_ply:Nick(), true)
			end
			target_ply:SetPos(newpos)
			target_ply:SetLocalVelocity(Vector(0, 0, 0))
		end
		
		if not should_unfreeze then
			target_ply:Lock()
			target_ply.frozen = true
			ulx.setExclusive(target_ply, "being executed")
		end
		
		timer.Simple(time, function()
			
	end
end