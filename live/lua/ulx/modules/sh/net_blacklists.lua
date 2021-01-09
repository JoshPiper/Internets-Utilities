function ulx.addBlacklist(calling_ply, target_ply, type, time)
	if not reverseBlacklists[type] then
		return
	end
	type = reverseBlacklists[type]
	
	if not time then
		local time = 0
	end
	time = time * 60
	
	target_ply.blacklists[type] = time
	ulx.fancyLogAdmin(calling_ply, "#A took #s access from #T", type, target_ply)
end
local blacklist = ulx.command("Blacklists", "ulx blacklist", ulx.addBlacklist, "!blacklist")
blacklist:addParam{type=ULib.cmds.PlayerArg}
blacklist:addParam{type=ULib.cmds.StringArg, completes=sortedBlacklists}
blacklist:addParam(type=ULib.cmds.NumArg, ULib.cmds.optional, ULib.cmds.allowTimeString, min=0}
blacklist:defaultAccess(ULib.ACCESS_ADMIN)
blacklist:help("Blacklists a target.")