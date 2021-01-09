-- ULX Module: Entity Functions Module
-- Made For: Gold Rush Gaming
-- Made By: Dr. Internet
-- Version: 1.1
-- Author Contact: Steam.
-- Description: ULX Module with commands designed for entity use.
-- Includes: 
--		Getting aimed Ent.
--		Removing aimed Ent.
--		Breaking aimed Ent.
--		Removing Props.
--		Removing Ragdolls.
--		Breaking Props.
--		Breaking Func_surfs.

if not ulx then
	print("Attempted to Load Internet's Utilities - Entity Module, but ULX was not present.")
	return
end

local breakables = {
["models/props/cs_office/file_box.mdl"] = true,
["models/props/cs_office/phone.mdl"] = true,
["models/props/cs_office/computer_keyboard.mdl"] = true,
["models/props/cs_office/computer_monitor.mdl"] = true,
["models/props/cs_office/computer_caseb.mdl"] = true,
["models/props/cs_office/computer_mouse.mdl"] = true,
["models/props/cs_office/trash_can.mdl"] = true,
["models/props/cs_office/projector.mdl"] = true,
["models/props/cs_militia/bathroomwallhole01_wood_broken.mdl"] = true,
["models/props/cs_militia/skylight_glass.mdl"] = true,
["models/props/cs_militia/militiawindow02_breakable.mdl"] = true,
["models/props/cs_militia/wndw01.mdl"] = true,
["models/props_junk/garbage_glassbottle003a.mdl"] = true,
["models/props_junk/garbage_glassbottle001a.md"] = true,
["models/props_junk/garbage_glassbottle002a.mdl"] = true,
["models/props/cs_militia/barstool01.mdl"] = true,
["models/props/cs_militia/bottle02.mdl"] = true,
["models/props/cs_militia/vent01.mdl"] = true,
}


function ulx.getEnt(calling_ply)
	local ent = calling_ply:GetEyeTrace().Entity
	ULib.tsay(calling_ply, "Targeted Entity: "..tostring(ent))
	ULib.tsay(calling_ply, "Entity ID: "..tostring(ent:EntIndex()))
	ULib.tsay(calling_ply, "Entity Class: "..tostring(ent:GetClass()))
	if string.StartWith(ent:GetClass(), "prop_physics") then
		ULib.tsay(calling_ply, "Entity Model: "..tostring(ent:GetModel()))
		if breakables[ent:GetModel()] then
			ULib.tsay(calling_ply, "Entity Model is Breakable.")
		end
	end
	
end
local getEnt = ulx.command("Entity", "ulx getent", ulx.getEnt, "!getent")
getEnt:defaultAccess(ULib.ACCESS_SUPERADMIN)
getEnt:help("Get the Entity you are looking at.")

function ulx.removeEnt(calling_ply)
	local ent = calling_ply:GetEyeTrace().Entity
	
	if IsValid(ent) then
		local entID = ent:EntIndex()
		if entID == 0 then
			ULib.tsayError(calling_ply, "Tried to remove world...")
			return
		end
		if ent:IsPlayer() then
			ULib.tsayError(calling_ply, "Tried to remove player ent...")
			return
		end
		ent:Remove()
	end
end
local removeEnt = ulx.command("Entity", "ulx removeent", ulx.removeEnt, "!removeent")
removeEnt:defaultAccess(ULib.ACCESS_SUPERADMIN)
removeEnt:help("Remove the Entity you are Looking At")

function ulx.breakEnt(calling_ply)
	local ent = calling_ply:GetEyeTrace().Entity
	if IsValid(ent) then
		local entID = ent:EntIndex()
		if entID == 0 then
			ULib.tsayError(calling_ply, "Tried to break world...")
			return
		end
		if ent:IsPlayer() then
			ULib.tsayError(calling_ply, "Tried to break player ent...")
			return
		end
		ent:Fire("break", "", 0)
	end
end
local breakEnt = ulx.command("Entity", "ulx breakent", ulx.breakEnt, "!breakent")
breakEnt:defaultAccess(ULib.ACCESS_SUPERADMIN)
breakEnt:help("Breaks the Entity you are Looking At")

function ulx.removeProps(calling_ply)
	local props = ents.FindByClass("prop_*")
	local num = 0
	local id, prop
	ULib.tsay(calling_ply, "Printed List of Props to Console")
	ULib.console(calling_ply, "----< List of Removed Props >----")
	for id, prop in pairs(props) do
		if IsValid(prop) then 
			ULib.console(calling_ply, "Removed Prop ID: "..prop:EntIndex().." "..tostring(prop).." - "..tostring(prop:GetModel()))
			num = num + 1
			prop:Remove() 
		end
	end
	-- for id, prop in pairs(mpprops) do
		-- if IsValid(prop) then 
			-- ULib.console(calling_ply, "Removed Prop ID: "..prop:EntIndex().." "..tostring(prop).." - "..tostring(prop:GetModel()))
			-- num = num + 1
			-- prop:Remove() 
		-- end
	-- end
	ULib.tsay(calling_ply, "Removed "..tostring(num).." props.")
end
local removeProps = ulx.command("Entity", "ulx removeprops", ulx.removeProps, "!removeprops")
removeProps:defaultAccess(ULib.ACCESS_SUPERADMIN)
removeProps:help("Remove all props on the map.")

function ulx.removeRagdolls(calling_ply)
	local ragdolls = ents.FindByClass("prop_ragdoll")
	local num = 0
	local id, prop
	ULib.console(calling_ply, "----< List of Removed Ragdolls >----")
	for id, prop in pairs(ragdolls) do
		if IsValid(prop) then 
			ULib.console(calling_ply, "Removed Prop ID: "..prop:EntIndex().." "..tostring(prop))
			num = num + 1
			prop:Remove() 
		end
	end
	ULib.tsay(calling_ply, "Removed "..tostring(num).." ragdolls.")
end
local removeRagdolls = ulx.command("Entity", "ulx removeragdolls", ulx.removeRagdolls, "!removeragdolls")
removeProps:defaultAccess(ULib.ACCESS_SUPERADMIN)
removeProps:help("Remove all ragdolls.")

function ulx.breakEnts(ply)
	local ent1 = ents.FindByClass("func_breakable*")
	--local ent2 = ents.FindByClass("func_breakable_*")
	local num = 0
	if istable(ent1) then
		ULib.console(calling_ply, "----< List of Broken Entities>----")
		for id, ent in pairs(ent1) do
			if IsValid(ent) then 
				ULib.console(calling_ply, "Broke Entity ID: "..ent:EntIndex().." "..tostring(ent))
				num = num + 1
				ent:Fire("break", "", 0) 
			end
		end
		ULib.tsay(ply, "Broke "..tostring(num).." entities.")
	end
end
local breakents = ulx.command("Entity", "ulx breakents", ulx.breakEnts, "!breakents")
breakents:defaultAccess(ULib.ACCESS_SUPERADMIN)
breakents:help("Breaks all func_breakable's on the map.")

function ulx.breakProps(ply)
	local props = ents.FindByClass("prop_*")
	local num = 0
	ULib.console(calling_ply, "----< List of Broken Props>----")
	for id, prop in pairs(props) do
		if IsValid(prop) then
			if breakables[prop:GetModel()] then
				ULib.console(calling_ply, "Broke Prop ID: "..prop:EntIndex().." "..tostring(prop).." - "..tostring(prop:GetModel()))
				num = num + 1
				prop:Fire("break", "", 0) 
			end
		end
	end
	ULib.tsay(ply, "Broke "..tostring(num).." props.")
end
local breakprops = ulx.command("Entity", "ulx breakprops", ulx.breakProps, "!breakprops")
breakprops:defaultAccess(ULib.ACCESS_SUPERADMIN)
breakprops:help("Breaks all breakable props on the map.")