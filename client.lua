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