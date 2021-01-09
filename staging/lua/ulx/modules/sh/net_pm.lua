local CATEGORY_NAME = "Chat"
local seepsayAccess = "ulx seepsay"

if SERVER then ULib.ulc.registerAccess( seepsayAccess ,Ulib.ACCESS_NONE, "Ability to see 'ulx psay'", "Other") end -- Give no-one access to see other's PMs (by default)
------------------------------ Psay ------------------------------
function ulx.psay( calling_ply, target_ply, message )
	ulx.fancyLog( { target_ply, calling_ply }, "#P to #P: " .. message, calling_ply, target_ply )
	sendPlayers = {}
	plys = players.GetAll()
	for i, v in ipairs(plys) do
		if not v == calling_ply and not v == target_ply and v:query(seepsayAccess) then
			table.insert(sendPlayers, v)
		end
	end
	ulx.fancyLog( sendPlayers, "(LOG) PM from #P to #P: " .. message, calling_ply, target_ply )
end
local psay = ulx.command( CATEGORY_NAME, "ulx psay", ulx.psay, "!p", true )
psay:addParam{ type=ULib.cmds.PlayerArg, hint = "PM Target Player"target="!^", ULib.cmds.ignoreCanTarget }
psay:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
psay:defaultAccess( ULib.ACCESS_ALL )
psay:help( "Send a private message to target." )

------------------------------ PSayMulti ------------------------------
function ulx.psaymulti(calling_ply, target_plys, message)
	table.insert(target_plys, calling_ply)
	ulx.fancyLog( target_plys, "#P to #P: " .. message, calling_ply, target_ply )
	sendPlayers = {}
	for i, v in ipairs(plys) do
		if not v in target_plys and v:query(seepsayAccess) then
			table.insert(sendPlayers, v)
		end
	end
	ulx.fancyLog( sendPlayers, "(LOG) PM from #P to #P: " .. message, calling_ply, target_plys )
*end

local psaymulti = ulx.command( CATEGORY_NAME, "ulx psaymulti", ulx.psaymulti, "!ps", true )
psaymulti:addParam{ type=ULib.cmds.PlayersArg, hint = "PM Target Players"target="!^", ULib.cmds.ignoreCanTarget }
psaymulti:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
psaymulti:defaultAccess( ULib.ACCESS_ALL )
psaymulti:help( "Send a private message several targets." )