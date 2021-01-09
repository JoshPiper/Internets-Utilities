-- local GAMEM = GAMEMODE.Name or GM.Name or "darkrp"
--if GAMEM ~= "darkrp" and GAMEM ~= "DarkRP" then return end -- DarkRP Only.

/*-------------------------------------------------------------------------------------------------------------------------
	RP EndHit for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/
function ulx.rpEndHit( calling_ply, target_plys )
	local affected_plys = {}
	
	for  i=1, #target_plys do
		local v = target_plys[ i ]
		if( v and IsValid(v) and v:hasHit() ) then
			v.finishHit()
			table.insert(affected_plys, v)
		end
	end
	
	if( #affected_plys <= 0 ) then
		calling_ply:ChatPrint("Selected Player(s) does not have a hit.")
	else
		ulx.fancyLogAdmin( calling_ply, "#A ended hit for #T", affected_plys )
	end
end
local rpEndHit = ulx.command( "Roleplay Utility", "ulx rpendhit", ulx.rpEndHit, "!endhit" )
rpEndHit:addParam{ type=ULib.cmds.PlayersArg }
rpEndHit:defaultAccess( ULib.ACCESS_SUPERADMIN )
rpEndHit:help( "End the hit of the target(s)." )

/*-------------------------------------------------------------------------------------------------------------------------
	RP SetMoney for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/
local startingcash = ( GM and GM.Config and GM.Config.startingmoney) or ( GAMEMODE and GAMEMODE.Config and GAMEMODE.Config.startingmoney ) or 500

function ulx.rpSetMoney( calling_ply, target_ply, amount )
	local target = target_ply
	local amount = math.floor(tonumber(amount)) or 0

	DarkRP.storeMoney(target, amount)
	target:setDarkRPVar("money", amount)
	target:PrintMessage(2, DarkRP.getPhrase("x_set_your_money", "ULX", DarkRP.formatMoney(amount), ""))

	ulx.fancyLogAdmin( calling_ply, "#A set money for #T to "..tostring(amount)..".", target_ply )
end
local rpSetMoney = ulx.command( "Roleplay Utility", "ulx rpsetmoney", ulx.rpSetMoney, "!setmoney" )
rpSetMoney:addParam{ type=ULib.cmds.PlayerArg }
rpSetMoney:addParam{ type=ULib.cmds.NumArg, min=0, default=startingcash, hint="amount", ULib.cmds.round, ULib.cmds.optional }
rpSetMoney:defaultAccess( ULib.ACCESS_SUPERADMIN )
rpSetMoney:help( "Set the money of the target." )


/*-------------------------------------------------------------------------------------------------------------------------
	RP UnOwn for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/
function ulx.rpUnOwn( calling_ply, target_plys )
	for  i=1, #target_plys do
		local v = target_plys[ i ]
		v:keysUnOwnAll()
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A unowned the entities of #T", target_plys )
end
local rpUnOwn = ulx.command( "Roleplay Utility", "ulx rpunown", ulx.rpUnOwn, "!rpunown" )
rpUnOwn:addParam{ type=ULib.cmds.PlayersArg }
rpUnOwn:defaultAccess( ULib.ACCESS_SUPERADMIN )
rpUnOwn:help( "UnOwn the items of the target(s)." )

/*-------------------------------------------------------------------------------------------------------------------------
	ULX RPName for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/

function ulx.rpname( calling_ply, target_ply, newname )
	local target = target_ply
	local name = tostring(newname)
	------------
	local oldname = target:Nick()
	oldname = tostring(oldname)
	------------
	DarkRP.storeRPName(target, name)
	target:setDarkRPVar("rpname", name)
	target:PrintMessage(2, DarkRP.getPhrase("x_set_your_name", "ULX", name))

	ulx.fancyLogAdmin( calling_ply, "#A set the name of #T(" .. oldname .. ") to " .. name .. ".", target_ply )
end
local rpName = ulx.command( "Roleplay Utility", "ulx rpname", ulx.rpname, "!rpname" )
rpName:addParam{ type=ULib.cmds.PlayerArg }
rpName:addParam{ type=ULib.cmds.StringArg, hint="John Doe", ULib.cmds.takeRestOfLine }
rpName:defaultAccess( ULib.ACCESS_ADMIN )
rpName:help( "Set a persons RP name." )


/*-------------------------------------------------------------------------------------------------------------------------
	RP Veto for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/
function ulx.rpveto( calling_ply )
	DarkRP.destroyLastVote()
	ulx.fancyLogAdmin( calling_ply, "#A called veto on the last DarkRP vote.", target_plys )
end
local rpveto = ulx.command( "Roleplay Utility", "ulx rpveto", ulx.rpveto, "!rpveto" )
rpveto:defaultAccess( ULib.ACCESS_SUPERADMIN )
rpveto:help( "Stop the latest RP vote. (EXPERIMENTAL)" )

/*-------------------------------------------------------------------------------------------------------------------------
	RP Arrest for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/
function ulx.rparrest( calling_ply, target_plys, override, should_unarrest )
	if ( should_unarrest or string.len(tostring(override)) >= 1 ) then
		for  i=1, #target_plys do
			local v = target_plys[ i ]
			v:unArrest( calling_ply )
		end
	else
		for  i=1, #target_plys do
			local v = target_plys[ i ]
			v:arrest( _, calling_ply )
		end
	end
	
	if ( should_unarrest or string.len(tostring(override)) >= 1 ) then
		ulx.fancyLogAdmin( calling_ply, "#A unarrested #T", target_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A arrested #T", target_plys )
	end
end
local rparrest = ulx.command( "Roleplay Utility", "ulx rparrest", ulx.rparrest, "!arrest" )
rparrest:addParam{ type=ULib.cmds.PlayersArg }
rparrest:addParam{ type=ULib.cmds.StringArg, hint="Force Unarrest", ULib.cmds.optional }
rparrest:defaultAccess( ULib.ACCESS_SUPERADMIN )
rparrest:help( "Arrest a player(s)." )
rparrest:setOpposite( "ulx rpunarrest", {_, _, true}, "!unarrest" )

/*-------------------------------------------------------------------------------------------------------------------------
	RP Lockdown for ULX Git/ULib Git by LuaTenshi
-------------------------------------------------------------------------------------------------------------------------*/
function ulx.rplockdown( calling_ply, _, end_lockdown )
	if tobool(GetConVarNumber("DarkRP_Lockdown")) then
		RunConsoleCommand("rp_unlockdown")
		ulx.fancyLogAdmin( calling_ply, "#A ended the lockdown.", target_plys )
	else
		RunConsoleCommand("rp_lockdown")
		ulx.fancyLogAdmin( calling_ply, "#A started a lockdown.", target_plys )
	end
end
local rplockdown = ulx.command( "Roleplay Utility", "ulx rplockdown", ulx.rplockdown, "!lockdown" )
rplockdown:defaultAccess( ULib.ACCESS_SUPERADMIN )
rplockdown:help( "Start a lockdown." )