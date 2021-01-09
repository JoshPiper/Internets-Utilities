-- ULX Module: Weapons and Ammunition Integration
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with various functions for use with weapons and ammunition.
-- Includes: 
--		Setting Ammo (AmmoID / Currently Selected Weapon)
--		Stripping Ammo (Including from held weapon clips.)
--		Striping Weapons (Currently held, by entname or all)
--		Dropping Weapons (Currently held, by entname or all)
--		Getting the ammoIDs for currently held weapon
--		Getting the ammo name for predefined weapons.
--		Giving fake items.
--		Giving weapons.

if not ulx then
	print("Attempted to Load Internet's Utilities - Ammunition Module, but ULX was not present.")
	return
end
local CATEGORY_NAME = "Ammo" -- Constant for the file.

-- Setup the ammo types table.
ulx.ammotypes = {}
ulx.ammotypes[1] = "AR2"
ulx.ammotypes[2] = "Combine Balls"
ulx.ammotypes[3] = "Pistol"
ulx.ammotypes[4] = "SMG Ammo"
ulx.ammotypes[5] = ".357"
ulx.ammotypes[6] = "Crossbow Bolts"
ulx.ammotypes[7] = "12 Gauge Shells"
ulx.ammotypes[8] = "RPG"
ulx.ammotypes[9] = "SMG Grenades"
ulx.ammotypes[10] = "Grenades"
ulx.ammotypes[11] = "SLAM Explosives" 

-- Ammo IDs Table
ulx.ammoids = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}

-- Initialize the weapon table.
ulx.weaponData = {}

-- Half Life 2 Weapons
ulx.weaponData.weapon_crowbar = {name = "Crowbar", creator = "Valve Software"}
ulx.weaponData.weapon_physcannon = {name = "Zero Point Energy Field Manipulator", creator = "Valve Software"}
ulx.weaponData.weapon_pistol = {name = "H&K USP Match", creator = "Valve Software"}
ulx.weaponData.weapon_357 = {name = "Colt Python Elite", creator = "Valve Software"}
ulx.weaponData.weapon_smg1 = {name = "H&K MP7", creator = "Valve Software"}
ulx.weaponData.weapon_ar2 = {name = "OSIPR", creator = "Valve Software"}
ulx.weaponData.weapon_shotgun = {name = "SPAS 12", creator = "Valve Software"}
ulx.weaponData.weapon_crossbow = {name = "Crossbow", creator = "Valve Software"}
ulx.weaponData.weapon_frag = {name = "M-83 Fragmentation Grenade", creator = "Valve Software"}
ulx.weaponData.weapon_rpg = {name = "Rocket Propelled Grenade Launcher", creator = "Valve Software"}

-- Garry's Weapons
ulx.weaponData.weapon_physgun = {name = "Garry's Physics Manipulator", creator = "Facepunch Studios"}
ulx.weaponData.gmod_camera = {name = "Camera", creator = "Facepunch Studios"}
ulx.weaponData.gmod_tool = {name = "Tool Gun", creator = "Facepunch Studios"}
ulx.weaponData.weapon_fists = {name = "Fists", creator = "Facepunch Studios"}
ulx.weaponData.weapon_empty_hands = {name = "Empty Hands", creator = "Facepunch Studios"}
ulx.weaponData.weapon_flechettegun = {name = "Flechett Gun", creator = "Facepunch Studios"}
ulx.weaponData.manhack_welder = {name = "Manhack/Rollermine Dispenser", creator = "Facepunch Studios"}
ulx.weaponData.weapon_medkit = {name = "Medical Kit", creator = "Facepunch Studios"}

-- Customisable Weaponry 2.0
ulx.weaponData.cw_ak74 = {name = "AK-74", creator = "Spy"}
ulx.weaponData.cw_ar15 = {name = "AR-15", creator = "Spy"}
ulx.weaponData.cw_scarh = {name = "FN SCAR-H", creator = "Spy"}
ulx.weaponData.cw_g3a3 = {name = "G3A3", creator = "Spy"}
ulx.weaponData.cw_g18 = {name = "Glock 18", creator = "Spy"}
ulx.weaponData.cw_g36c = {name = "G36 Compact", creator = "Spy"}
ulx.weaponData.cw_ump45 = {name = "UMP .45", creator = "Spy"}
ulx.weaponData.cw_mp5 = {name = "MP5", creator = "Spy"}
ulx.weaponData.cw_deagle = {name = "IMI Desert Eagle", creator = "Spy"}
ulx.weaponData.cw_m14 = {name = "M14 EBR", creator = "Spy"}
ulx.weaponData.cw_m3super90 = {name = "M3 Super 90", creator = "Spy"}
ulx.weaponData.cw_mr96 = {name = "MR-96", creator = "Spy"}

-- Customisable Weaponry 2.0 | Unofficial Extra Customisable Weaponry
ulx.weaponData.cw_g4p_usp40 = {name = "USP .40"}
ulx.weaponData.cw_g4p_an94 = {name = "AN-94"}
ulx.weaponData.cw_g4p_an94 = {name = "Arctic Warfare Magnum"}
ulx.weaponData.cw_g4p_m98b = {name = "M98 Bravo"}
ulx.weaponData.cw_g4p_fn_fal = {name = "FN FAL"}
ulx.weaponData.cw_g4p_fiveseven = {name = "Five Seven"}
ulx.weaponData.cw_g4p_g2contender = {name = "G2 Contender"}
ulx.weaponData.cw_g4p_glock17 = {name = "Glock 17"}
ulx.weaponData.cw_g4p_g36c = {name = "G36 Compact"}
ulx.weaponData.cw_g4p_ump45 = {name = "UMP .45"}
ulx.weaponData.cw_g4p_xm8 = {name = "HK XM8"}
ulx.weaponData.cw_g4p_m16a2 = {name = "M16 A2"}
ulx.weaponData.cw_g4p_m16a4 = {name = "M16 A4"}
ulx.weaponData.cw_g4p_m4a1 = {name = "M4A1"}
ulx.weaponData.cw_g4p_magpul_masada = {name = "Magpul Masada"}
ulx.weaponData.cw_g4p_masada_acr = {name = "Masada ACR"}
ulx.weaponData.cw_g4p_mp412_rex = {name = "MP-412 REX"}

-- Customisable Weaponry 2.0 | Other
ulx.weaponData.cw_p220 = {name = "P220"}
ulx.weaponData.cw_m1911 = {name = "M1911"}
ulx.weaponData.weapon_cw_p226v2 = {name = "P226"}
ulx.weaponData.cw_winchester1897 = {name = "Winchester 1897"}

-- TTT Weapons | Base

-- TTT Weapons | Custom
ulx.weaponData.weapon_ttt_jihadbomb = {name = "Jihad Bomb"}
ulx.weaponData.ttt_weapon_portalgun = {name = "Aperture Science Dual Portal Device"}

-- DarkRP | Weapons

-- DarkRP | Tools
ulx.weaponData.keypad_cracker = {name = "Keypad Cracker"}

-- Other Stuff
ulx.weaponData.weapon_molotov_c = {name = "Molotov Cocktail"}
ulx.weaponData.basebat = {name = "Baseball Bat"}

--[[ Weaponry / Ammunition Stripping ]]--
---- Strip Ammunition ----
function ulx.stripAmmo(calling_ply, target_plys)
	if not target_plys then
		target_plys = {calling_ply}
	end

	for _, ply in pairs(target_plys) do
		ply:StripAmmo()
		for _, i in pairs(v:GetWeapons()) do -- Bug fix, since strip ammo doesn't count clips as ammo.
			i:SetClip1(0)
			i:SetClip2(0)
		end
	end

	ulx.fancyLogAdmin(calling_ply, "#A stripped ammo from #T", target_plys)
end
local stripAmmo = ulx.command(CATEGORY_NAME, "ulx stripammo", ulx.stripAmmo, "!stripammo")
stripAmmo:addParam{type=ULib.cmds.PlayersArg, ULib.cmds.optional}
stripAmmo:defaultAccess(ULib.ACCESS_ADMIN)
stripAmmo:help("Strips the ammo from target player(s).")

---- Strip Weapons ----
function ulx.stripWeapons(calling_ply, target_plys)
	if not target_plys then
		target_plys = {calling_ply}
	end
	
	for _, ply in pairs(target_plys) do
		ply:StripWeapons()
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A stripped weapons from #T.", target_plys)
end
local stripWeapons = ulx.command(CATEGORY_NAME, "ulx strip", ulx.stripWeapons, "!strip")
stripWeapons:defaultAccess(ULib.ACCESS_ADMIN)
stripWeapons:addParam{type=ULib.cmds.PlayersArg, ULib.cmds.optional}
stripWeapons:help("Strips weapons from the target.")

---- Strip Current Weapon ----
function ulx.stripWeapon(calling_ply, target_plys)
	if not target_plys then
		target_plys = {calling_ply}
	end
	
	for _, ply in pairs(target_plys) do
		ply:StripWeapon(ply:GetActiveWeapon():GetClass())
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A stripped the current weapon from #T.", target_plys)
end
local stripWeapon = ulx.command(CATEGORY_NAME, "ulx stripcurrent", ulx.stripWeapon, "!stripcurrent")
stripWeapon:defaultAccess(ULib.ACCESS_ADMIN)
stripWeapon:addParam{type=ULib.cmds.PlayersArg, ULib.cmds.optional}
stripWeapon:help("Strips weapons from the target.")

---- Strip By Entname ----
function ulx.stripEnt(calling_ply, entName, target_plys)
	if not target_plys then
		target_plys = {calling_ply}
	end
	
	for _, ply in pairs(target_plys) do
		ply:StripWeapon(entName)
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A stripped #s from #T", entName, target_plys)
end
local stripEnt = ulx.command(CATEGORY_NAME, "ulx stripent", ulx.stripEnt, "!stripent")
stripEnt:defaultAccess(ULib.ACCESS_ADMIN)
stripEnt:addParam{type=ULib.cmds.StringArg}
stripEnt:addParam{type=ULib.cmds.PlayersArg, ULib.cmds.optional}
stripEnt:help("Strips the selected weapon from the target.")


------ Set Current Ammo ------
function ulx.setCurrentAmmo(calling_ply, target_ply, amount, secondary)
	local affected_plys = {}
	if not target_ply then
		target_ply = calling_ply
	end
	if not secondary then
		if ammotypes[target_ply:GetActiveWeapon():GetPrimaryAmmoType()] ~= nil then
			target_ply:SetAmmo(amount, target_ply:GetActiveWeapon():GetPrimaryAmmoType())
				ulx.fancyLogAdmin(calling_ply, "#A set ammotype #s (#s) of #T to #s", target_ply:GetActiveWeapon():GetPrimaryAmmoType(), ammotypes[target_ply:GetActiveWeapon():GetPrimaryAmmoType()], target_ply, amount)
			else
				ULib.tsayError(calling_ply, "No Primary Ammo Type Defined - Try Secondary?", true)
			end
		else
			if ammotypes[target_ply:GetActiveWeapon():GetSecondaryAmmoType()] ~= nil then
				target_ply:SetAmmo(amount, target_ply:GetActiveWeapon():GetSecondaryAmmoType())
				ulx.fancyLogAdmin(calling_ply, "#A set ammotype #s (#s) of #T to #s",target_ply:GetActiveWeapon():GetSecondaryAmmoType() ,ammotypes[target_ply:GetActiveWeapon():GetSecondaryAmmoType()], target_ply, amount)
			else
				ULib.tsayError(calling_ply, "No Secondary Ammo Type Defined - Try Primary?", true)
			end
		end
	end
local stripamd = ulx.command( CATEGORY_NAME, "ulx setcurrentammo", ulx.setCurrentAmmo, "!setcurrentammo" )
stripamd:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
stripamd:addParam{ type=ULib.cmds.NumArg, min=0, hint="Amount" }
stripamd:addParam{ type=ULib.cmds.BoolArg, hint="Set Secondary Ammo", ULib.cmds.optional }
stripamd:defaultAccess( ULib.ACCESS_ADMIN )
stripamd:help( "Sets the ammo for the currently selected weapon for targeted player(s)." )


------ Get Ammo Data ------
function ulx.getAmmoData(calling_ply)
	local weapon = calling_ply:GetActiveWeapon()
	local primary, secondary = weapon:GetPrimaryAmmoType(), weapon:GetSecondaryAmmoType()
	local strP = game.GetAmmoName(primary) or "Null"
	local strS = game.GetAmmoName(secondary) or "Null"
	--calling_ply:SendLua("SetClipboardText(LocalPlayer():GetActiveWeapon():GetClass())")
	
	
	ULib.tsay(calling_ply, "---- "..weapon:GetClass().." ----")
	
	if ulx.weaponData[weapon:GetClass()] and ulx.weaponData[weapon:GetClass()].name then
		ULib.tsay(calling_ply, "Weapon Name: "..ulx.weaponData[weapon:GetClass()].name)
	end
	
	if ulx.weaponData[weapon:GetClass()] and ulx.weaponData[weapon:GetClass()].creator then
		ULib.tsay(calling_ply, "Weapon Creator: "..ulx.weaponData[weapon:GetClass()].creator)
	end
	
	if strP ~= "Null" then
		local maxP = game.GetAmmoMax(primary)
		ULib.tsay(calling_ply, "Primary Ammo: "..primary)
		ULib.tsay(calling_ply, "Primary Name: "..strP)
		ULib.tsay(calling_ply, "Primary Max: "..maxP)
	end
	if strS ~= "Null" then
		local maxS = game.GetAmmoMax(secondary)
		ULib.tsay(calling_ply, "Secondary Ammo: "..secondary)
		ULib.tsay(calling_ply, "Secondary Name: "..strS)
		ULib.tsay(calling_ply, "Secondary Max: "..maxS)
	end
	if strP == "Null" and strS == "Null" then
		ULib.tsay(calling_ply, "This weapon has no ammotypes defined.")
	end
end
local getammodata = ulx.command(CATEGORY_NAME, "ulx getammodata", ulx.getAmmoData, "!getammodata")
getammodata:defaultAccess(ULib.ACCESS_SUPERADMIN)
getammodata:help("Returns the numerical/string AmmoID/Names for the currently selected weapon.")

----- Get Ammo Name ------
-- function ulx.getAmmoName(calling_ply)
	-- primary = ammotypes[calling_ply:GetActiveWeapon():GetPrimaryAmmoType()] or "Undefined (ID: "..tostring(calling_ply:GetActiveWeapon():GetPrimaryAmmoType())..")"
	-- secondary = ammotypes[calling_ply:GetActiveWeapon():GetSecondaryAmmoType()] or "Undefined (ID: "..tostring(calling_ply:GetActiveWeapon():GetSecondaryAmmoType())..")"
	-- if primary == "Undefined (ID: "..tostring(calling_ply:GetActiveWeapon():GetPrimaryAmmoType())..")" and calling_ply:GetActiveWeapon():GetPrimaryAmmoType() == -1 then
		-- primary = "Nil"
	-- end
	-- if secondary == "Undefined (ID: "..tostring(calling_ply:GetActiveWeapon():GetSecondaryAmmoType())..")" and calling_ply:GetActiveWeapon():GetSecondaryAmmoType() == -1 then
		-- secondary = "Nil"
	-- end
	-- ULib.tsay(calling_ply, "---- "..calling_ply:GetActiveWeapon():GetClass().." ----")
	-- ULib.tsay(calling_ply, "Primary Ammo: "..primary)
	-- ULib.tsay(calling_ply, "Secondary Ammo: "..secondary)
-- end
-- local getammoname = ulx.command(CATEGORY_NAME, "ulx getammoname", ulx.getAmmoName, "!getammoname")
-- getammoname:defaultAccess(ULib.ACCESS_SUPERADMIN)
-- getammoname:help("Returns the name for the ammos of the currently selected weapon (or undefined) - Mostly for debug use.")

------ Drop Current Weapon ------
function ulx.dropCurrentWeapon(calling_ply, target_ply)
	if not target_ply then
		target_ply = calling_ply
	end
	target_ply:DropWeapon(target_ply:GetActiveWeapon())
	ulx.fancyLogAdmin(calling_ply, "#A forced #T to drop their current weapon.", target_ply)
end
dropweapon = ulx.command(CATEGORY_NAME, "ulx dropcurrentweapon", ulx.dropCurrentWeapon, "!dropcurrentweapon")
dropweapon:defaultAccess(ULib.ACCESS_ADMIN)
dropweapon:addParam{type=ULib.cmds.PlayerArg, ULib.cmds.optional}
dropweapon:help("Forces the target to drop their weapon")

------ Drop All Weapons ------
function ulx.dropAllWeapons(calling_ply, target_ply)
	if not target_ply then
		target_ply = calling_ply
	end
	for _, i in pairs(target_ply:GetWeapons()) do
		target_ply:DropWeapon(i)
	end
	ulx.fancyLogAdmin(calling_ply, "#A forced #T to drop all their weapons.", target_ply)
end
dropweapons = ulx.command(CATEGORY_NAME, "ulx dropweapons", ulx.dropAllWeapons, "!dropweapons")
dropweapons:defaultAccess(ULib.ACCESS_ADMIN)
dropweapons:addParam{type=ULib.cmds.PlayerArg, ULib.cmds.optional}
dropweapons:help("Forces the target to drop all their weapons.")



------ Set Ammo ------
function ulx.setAmmoHelper(calling_ply)
	ULib.console(calling_ply, "------ Ammo Types -------")
	for i = 1, #ammoids do
		ULib.console(calling_ply, ammoids[i]..": "..ammotypes[ammoids[i]])
	end
end
gettypes = ulx.command(CATEGORY_NAME, "ulx getammotypes", ulx.setAmmoHelper, "!getammotypes")
gettypes:defaultAccess(ULib.ACCESS_ADMIN)
gettypes:help("Returns ammo types.")

function ulx.setAmmo(calling_ply, target_ply, ammo, amount)
	if not target_ply then
		target_ply = calling_ply
	end
	local isValidAmmo = false
	for i = 1, #ammoids do
		if ammo == ammoids[i] then
			isValidAmmo = true
		end
	end
	if not isValidAmmo then
		ULib.tsayError(calling_ply, "Ammotype not defined.")
	else
	target_ply:SetAmmo(amount, ammo)
	ulx.fancyLogAdmin(calling_ply, "#A set ammotype #s (#s) to #s for #T", ammo, ammotypes[ammo], amount, target_ply)
	end
end
setammo = ulx.command(CATEGORY_NAME, "ulx setammo", ulx.setAmmo, "!setammo")
setammo:defaultAccess(ULib.ACCESS_ADMIN)
setammo:addParam{type=ULib.cmds.PlayerArg, ULib.cmds.optional}
setammo:addParam{type=ULib.cmds.NumArg, min=1, max=ammoids[-1], hint="AmmoID"}
setammo:addParam{type=ULib.cmds.NumArg, min=0, hint="Amount"}
setammo:help("Sets selected ammo for target player.")

function ulx.getWeaponName(calling_ply)
	ULib.tsay(calling_ply, "Current Weapon: "..calling_ply:GetActiveWeapon():GetClass(), true)
end
getweaponname = ulx.command(CATEGORY_NAME, "ulx getweaponname", ulx.getWeaponName, "!getweaponname")
getweaponname:defaultAccess(ULib.ACCESS_SUPERADMIN)
getweaponname:help("Returns the Classname for the currently selected weapon.")

function ulx.getWeaponNames(calling_ply)
	ULib.console(calling_ply, "---- Weapon Class Names ----", true)
	for i = 1, #weapontypes do
		ULib.console(calling_ply, weapontypes[i])
	end
end
getweaponclassnames = ulx.command(CATEGORY_NAME, "ulx getweaponclassnames", ulx.getWeaponNames, "!getweaponclasses")
getweaponclassnames:defaultAccess(ULib.ACCESS_ADMIN)
getweaponclassnames:help("Returns the classnames for use in the giveweapon command.")

function ulx.giveWeapon(calling_ply, target_plys, weapon)
	if not target_plys then
		target_plys = {}
		table.insert(target_plys, calling_ply)
	end
	validweapon = false
	for _, i in pairs(weapontypes) do
		print(i)
		if i == weapon then
			validweapon = true
		end
	end
	if not validweapon then
		ULib.tsayError(calling_ply, "Invalid Weapon Classname")
	else
		affected_plys = {}
		for i = 1, #target_plys do
			target_plys[i]:Give(weapon)
			table.insert(affected_plys, target_plys[i])
		end
		ulx.fancyLogAdmin(calling_ply, "#A gave #T #s", affected_plys, weapon)
	end
end
giveweapon = ulx.command(CATEGORY_NAME, "ulx giveweapon", ulx.giveWeapon, "!giveweapon")
giveweapon:defaultAccess(ULib.ACCESS_ADMIN)
giveweapon:addParam{type=ULib.cmds.PlayersArg, ULib.cmds.optional}
giveweapon:addParam{type=ULib.cmds.StringArg, hint="Weapon Classname", completes=weapontypes, ULib.cmds.restrictToCompletes}
giveweapon:help("Gives a weapon to targeted players.")

function ulx.fakeGive(calling_ply, target_plys, item)
	ulx.fancyLogAdmin(calling_ply, "#A gave #s to #T", item, target_plys)
end
fakegive = ulx.command(CATEGORY_NAME, "ulx giveitem", ulx.fakeGive, "!giveitem")
fakegive:defaultAccess(ULib.ACCESS_ADMIN)
fakegive:addParam{type=ULib.cmds.PlayersArg, ULib.cmds.optional}
fakegive:addParam{type=ULib.cmds.StringArg}
fakegive:help("Gives an item to targeted players (fake)")
