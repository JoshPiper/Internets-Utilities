function ulx.checkNoclip(calling_ply, desired_state)
	if ULib.ucl.query(calling_ply, "ulx noclip") then
		return true
	end
end

hook.Add("PlayerNoClip", "CheckNoclipULX", ulx.checkNoclip)