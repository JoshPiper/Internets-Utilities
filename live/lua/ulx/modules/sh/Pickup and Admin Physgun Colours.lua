-- sv_rankphysguncolours.lua
local ranks = {}
local function AddExtraRank(id,col)
        ranks[id] = {}
        ranks[id].Color = col
end
       
AddExtraRank("superadmin",Color(255,0,0))
AddExtraRank("admin",Color(0,0,255))
AddExtraRank("user",Color(0,128,255))
-- don't remove these three. just add more as necessary.
 
local function GetRankPhysgunColor(ply)
        if ucl then -- I took this code from a join colour thing I made in another thread a while back.
                if ranks[ply:GetUserGroup()] then
                        return ranks[ply:GetUserGroup()].Color
                else
                        return Color(255,255,255)
                end
        else
                if ply:IsSuperAdmin() then
                        return ranks["superadmin"].Color
                elseif ply:IsAdmin() then
                        return ranks["admin"].Color
                else
                        return ranks["user"].Color
                end
        end
end
 
hook.Add( "PlayerSpawn", "AdminPhysgunCol", function( ply )
        local color = GetRankPhysgunColor(ply)
        timer.Create("setphysguncolour",0.1,1,function()
        ply:SetWeaponColor(Vector(color.r / 255, color.g / 255, color.b / 255))
        end)
end)
 
hook.Add( "PlayerInitialSpawn", "AdminPhysgunCol2", function( ply )
        local color = GetRankPhysgunColor(ply)
        timer.Create("setinitialphysguncolour",0.1,1,function()
        ply:SetWeaponColor(Vector(color.r / 255, color.g / 255, color.b / 255))
        end)
end)
 
function FGod( ply, dmginfo )
                if(ply:GetNetworkedVar("FGod") == 1) then
                                dmginfo:ScaleDamage( 0 )
                end
end
hook.Add("EntityTakeDamage", "FGod", FGod)
 
hook.Add("PhysgunDrop", "ply_physgunfreeze", function(pl, ent)
        hook.Remove( "PhysgunDrop", "ulxPlayerDrop" ) --This hook from ULX seems to break this script that's why we are removing it here.
       
        ent._physgunned = false
       
        if( ent:IsPlayer() ) then                          
                -- predicted?
                ent:SetMoveType(pl:KeyDown(IN_ATTACK2) and MOVETYPE_NOCLIP or MOVETYPE_WALK)
               
                if(pl:KeyDown(IN_ATTACK2)) then
                        ent:Freeze(true)
                        ent:SetNetworkedVar("FGod", 1)
                else
                        ent:Freeze(false)
                        ent:SetNetworkedVar("FGod", 0)
                end
                   
                if SERVER then
                        -- NO UUUU FKR
                        if !ent:Alive() then
                                ent:Spawn()
                                self:PlayerSpawn(ent)
                                ent:SetPos(pl:GetEyeTrace().HitPos)
                        end
                end
               
                return --self.BaseClass:PhysgunDrop( pl , ent )  
        end
end)
 
hook.Add( "PhysgunPickup", "ply_physgunned", function(pl, ent)
        ent._physgunned = true
end)
 
function playerDies( pl, weapon, killer )
        if(pl._physgunned) then
                return false
        else
                return true
        end
end
hook.Add( "CanPlayerSuicide", "playerNoDeath", playerDies )