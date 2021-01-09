function ulx.getSortedPlayer(calling_ply)
	local plys = player.GetAll()
	local cats = DarkRP.getCategories().jobs
	local sortedPlys = {}
	
	for id, cat in pairs(cats) do -- Already Sorted by SortOrder.
		for jobid, job in pairs(cat) do -- Get Each Job.
			for plyid, ply in pairs(plys) do
				if RPExtraTeams[ply:Team()] == job then
					table.insert(sortedPlys, ply)
				end
			end
		end
	end
	
	for k, v in pairs(sortedPlys) do
		ULib.console(calling_ply, "Ply "..k..": "..v:Name().." with team: "..v:Team())
	end
end

local getplys = ulx.command("Testing", "ulx getsortedplys", ulx.getSortedPlayer, "!getsorted")
getplys:defaultAccess(ULib.ACCESS_SUPERADMIN)
getplys:help("FOR INTERNET DON'T USE PLS")