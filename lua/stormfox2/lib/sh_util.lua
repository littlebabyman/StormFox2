--[[-------------------------------------------------------------------------
Useful functions
---------------------------------------------------------------------------]]

StormFox2.util = {}
local cache = {}
--[[<Shared>-----------------------------------------------------------------
Returns the OBBMins and OBBMaxs of a model.
---------------------------------------------------------------------------]]
function StormFox2.util.GetModelSize(sModel)
	if cache[sModel] then return cache[sModel][1],cache[sModel][2] end
	if not file.Exists(sModel,"GAME") then
		cache[sModel] = {Vector(0,0,0),Vector(0,0,0)}
		return cache[sModel]
	end
	local f = file.Open(sModel,"r", "GAME")
	f:Seek(104)
	local hullMin = Vector( f:ReadFloat(),f:ReadFloat(),f:ReadFloat())
	local hullMax = Vector( f:ReadFloat(),f:ReadFloat(),f:ReadFloat())
	f:Close()
	cache[sModel] = {hullMin,hullMax}
	return hullMin,hullMax
end

if CLIENT then
	--[[-----------------------------------------------------------------
	Calcview results
	---------------------------------------------------------------------------]]
	local view = {}
		view.pos = Vector(0,0,0)
		view.ang = Angle(0,0,0)
		view.fov = 0
		view.drawviewer = false
	hook.Add("PreDrawTranslucentRenderables", "StormFox2.util.EyeHack", function() EyePos() end)
	hook.Add("PreRender","StormFox2.util.EyeFix",function()
		view.pos = LocalPlayer():EyePos()
		view.ang = LocalPlayer():EyeAngles()
		view.fov = LocalPlayer():GetFOV()
		view.drawviewer = LocalPlayer():ShouldDrawLocalPlayer()
	end)
	--[[<Client>-----------------------------------------------------------------
	Returns the last calcview result.
	---------------------------------------------------------------------------]]
	function StormFox2.util.GetCalcView()
		return view
	end
	--[[<Client>-----------------------------------------------------------------
	Returns the last camera position.
	---------------------------------------------------------------------------]]
	function StormFox2.util.RenderPos()
		return view.pos or EyePos()
	end
		--[[<Client>-----------------------------------------------------------------
	Returns the current viewentity
	---------------------------------------------------------------------------]]
	function StormFox2.util.ViewEntity()
		local lp = LocalPlayer()
		if not IsValid(lp) then return end
		local p = lp:GetViewEntity() or lp
		if p.InVehicle and p:InVehicle() and p == lp then
			p = p:GetVehicle() or p
		end
		return p
	end
end