local Changevehsuspension = false

function SuspensionControl(bool)
    local playerPed = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(playerPed, false)
    if Vehicle ~= 0 and GetPedInVehicleSeat(Vehicle, -1) == playerPed then
        Changevehsuspension = bool
        SetReduceDriftVehicleSuspension(Vehicle, Changevehsuspension)
    end
end

RegisterCommand("suspensionup", function()		   
 SuspensionControl(false)
end)
 
RegisterCommand("suspensiondn", function()		   
 SuspensionControl(true)	
end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 314) then
                PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(playerPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SuspensionControl(false)
            end
            if IsControlJustPressed(0, 315) then
                PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(playerPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SuspensionControl(true)
            end
		end	
	end)

-- 在调整悬挂的函数后添加网络事件触发
function AdjustSuspension(height, stiffness)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        -- 本地调整
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionHeight", height)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionForce", stiffness)
        
        -- 获取网络ID并发送到服务器
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent('aq233_suspension:sync', netId, height, stiffness)
    end
end

RegisterNetEvent('aq233_suspension:update')
AddEventHandler('aq233_suspension:update', function(netId, height, stiffness)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    
    if DoesEntityExist(vehicle) and GetEntityType(vehicle) == 2 then
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionHeight", height)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSuspensionForce", stiffness)
        
        -- 强制物理更新
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fSuspensionForce', stiffness)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fSuspensionHeight', height)
    end
end)
