-- ULX Module: Coloured Physgun Lasers
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module for setting colour for physguns.

-- Configuration
ulx.physColours = {}

-- Think of the vector as a RGB colour code. 5/255, 220/255, 240/255 means RGB(5, 220, 240)
-- ulx.physColours.group = Vector(color_red/255, color_green/255, colour_blue/255)
ulx.physColours.user = Vector(5/255, 220/255, 240/255)
ulx.physColours.donator = Vector(5/255, 220/255, 240/255)
ulx.physColours.operator = Vector(255/255, 255/255, 40/255)
ulx.physColours.admin = Vector(255/255, 10/255, 10/255)
ulx.physColours.superadmin = Vector(255/255, 10/255, 10/255)
-- END CONFIG

function ulx.setPGunColHelper()
	for _, i in pairs(player.GetAll()) do
		ulx.setPhysgunColor(i)
	end
end

function ulx.setPhysgunColor(ply)
	if ply.customPhysColor then
		ply:SetWeaponColor(ply.customPhysColor)
	elseif ply.customPhysGroup then
		ply:SetWeaponColor(ulx.physColours[ply.customPhysGroup])
	else
		ply:SetWeaponColor(ulx.physColours[ply:GetUserGroup()])
	end
end

function ulx.setCustomWeaponColor(calling_ply, target_ply, color_r, color_g, color_b)
hook.Add("UCLChanged" "net_phys_color_change", ulx.setPGunColHelper)
hook.Add("UCLAuthed" "net_phys_color_auth", ulx.setPhysgunColor)
hook.Add("PhysColorChanged", "net_phys_color_onfunc", ulx.setPhysgunColor)
