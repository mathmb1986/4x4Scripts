
local timer = 10;
local ActualVehicule = {}

local VehiculeConfig = {}

VehiculeConfig.fourwheelActivable = false
VehiculeConfig.Scanned = false
VehiculeConfig.fourwheelsc  = false
VehiculeConfig.Name = ''
VehiculeConfig.FWR = false;

local display = false -- pas utuliser
local fourwheelsc = true
local isPauseMenu = false


RegisterNetEvent('nui:on')
AddEventHandler('nui:on', function()
  checkwheelnum()
  SendNUIMessage({
    type = "ui",
    display = true,
    fourwheels = VehiculeConfig.fourwheelsc
  })

end)

  RegisterNetEvent('nui:off')
  AddEventHandler('nui:off', function()
    SendNUIMessage({
      type = "ui",
      display = false
    })
  end)

  RegisterNetEvent('nui:4wheels')
  AddEventHandler('nui:4wheels', function()
    VehiculeConfig.fourwheelsc = true
    SendNUIMessage({
      type = "ui",
      display = true,
      fourwheels = true,
      rearDrive = false,
    })
    --fourwheelsf()

    GetVehicleHandlingFloat(ActualVehicule,'CHandlingData','fDriveBiasFront')
    SetVehicleHandlingField(ActualVehicule, 'CHandlingData', 'fDriveBiasFront', 0.4500000)

  end)


  RegisterNetEvent('nui:2wheels')

  AddEventHandler('nui:2wheels', function()
    VehiculeConfig.fourwheelsc = false


    SendNUIMessage({
      type = "ui",
      display = true,
      fourwheels = false,
      rearDrive = true
    })

    GetVehicleHandlingFloat(ActualVehicule,'CHandlingData','fDriveBiasFront')
    SetVehicleHandlingField(ActualVehicule, 'CHandlingData', 'fDriveBiasFront', 0.000000)
    --twowheelsf()
  end)


  RegisterNetEvent('nui:2wheelsFWD')  
  AddEventHandler('nui:2wheelsFWD', function()
    VehiculeConfig.fourwheelsc = false
    SendNUIMessage({
      type = "ui",
      display = true,
      fourwheels = false,
      rearDrive = false
    })


    GetVehicleHandlingFloat(ActualVehicule,'CHandlingData','fDriveBiasFront')
    SetVehicleHandlingField(ActualVehicule, 'CHandlingData', 'fDriveBiasFront', 1.000000)
    --twowheelsf()
  end)


local time = 0
local DriverSeat = false

Citizen.CreateThread(
function()
  while true do
    Wait(timer)
    MenuActive()
    local playerPed = GetPlayerPed(-1)
     if IsPedSittingInAnyVehicle(playerPed)  then
        timer = 5

        time = (time + GetGameTimer() / 1000000)
        if time >= 500 then
               local resul =  GetPedInVehicleSeat(vehicle , -1) 
               if resul == 0 then
                DriverSeat  = true
                else
                DriverSeat = false    
               end
             time =0

        end

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsUsing(ped)    
        if vehicle == ActualVehicule and  DriverSeat and VehiculeConfig.Scanned then


          if VehiculeConfig.fourwheelActivable then
            UpdateWheel()
            if IsControlPressed(0, Config.InputToPresse ) and IsControlJustPressed(0, Config.InputToKeepPresse ) then
              VehiculeConfig.fourwheelsc = not VehiculeConfig.fourwheelsc 
              checkwheelnum()
            end                  
          else

            if IsControlPressed(0, Config.InputToPresse ) and IsControlJustPressed(0, Config.InputToKeepPresse) then
              
              if Config.HubAlwaysvisible == false then
                TriggerEvent('nui:off', true)  -- safety
              end

              local test = 'VehicleNotSupported'
              exports['mythic_notify']:DoHudText('inform', test, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            end

          end



        else
          --print('NEW Vehicule')
          ActualVehicule = vehicle  
          --test = false
          -- Scan Vehicule !
          ScanVehicule(vehicle)
        end
     else
        timer = 350;
	      TriggerEvent('nui:off', true) 

        if VehiculeConfig.Scanned then
          VehiculeConfig = {}
          VehiculeConfig.Scanned = false 
        end
    end
  end
end)


function ScanVehicule(vehicle)
	local retval = GetVehicleHasKers(vehicle)
	 VehiculeConfig.Name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	 if VehicleClasse(vehicle) then 
  		TriggerEvent('nui:on', true)
  		checkwheelnum()
      SendMessage('Vehicle Support 4x4')
  		VehiculeConfig.fourwheelActivable = true; 
	 else
	   TriggerEvent('nui:off', true) 
	   -- Rajouter ici Set image Traction Avant ou Arriere si le hub est tjrs activer
	   VehiculeConfig.fourwheelActivable = false; 
	 end
    VehicleTraction(vehicle)
   --LookVehicleExeption()
end

function VehicleTraction(vehicle)

   local vehicleTraction =  GetVehicleHandlingFloat(vehicle,'CHandlingData','fDriveBiasFront')
   --print(vehicleTraction)


   if vehicleTraction == 1.0  and Config.HubAlwaysvisible  == true then
     TriggerEvent('nui:on', true)  
     TriggerEvent('nui:2wheelsFWD', true) 
   end


   if vehicleTraction >= 0.1 and vehicleTraction <= 0.8 then
      if Config.HubAlwaysvisible or Config.AutoGestion then
        TriggerEvent('nui:on', true)  
        if Config.AutoGestion then
           VehiculeConfig.fourwheelActivable = true; 
          TriggerEvent('nui:4wheels', true)
          SendMessage('Vehicle Support 4x4')
        end
      end
   end
   if vehicleTraction == 0 and Config.HubAlwaysvisible  == true then    
     TriggerEvent('nui:on', true)  
     TriggerEvent('nui:2wheels', true) 
   end

   --   Fin Du Scann Du Vehicule
   VehiculeConfig.Scanned = true


end

 function VehicleClasse(vehicle)
    for i, item in pairs(Config.VehiculeGroups) do -- for i in pairs loop goes through all the items in an array/table
      if GetVehicleClass(vehicle) == item then
          return LookVehicleExeption(vehicle)
      end
    end
    return false
 end 


function LookVehicleExeption(vehicle)
    for i, item in pairs(Config.VehiculeGroupsExeption) do
      if VehiculeConfig.Name == item then
          print('VehicleExeption', item) 
          return false
      end
    end
    return true
end




function checkwheelnum()

  if VehiculeConfig.fourwheelsc == true then
    TriggerEvent('nui:4wheels', true)
  else
    TriggerEvent('nui:2wheels', true) 

  end
end


-- okey
function MenuActive()
    if IsPauseMenuActive() then
      if not isPauseMenu then
        isPauseMenu = not isPauseMenu
        SendNUIMessage({
           type = 'ui',
           display = false,
           })
        display = false
      end
    else
      if isPauseMenu then
        isPauseMenu = not isPauseMenu
        if VehiculeConfig.fourwheelActivable == true  or Config.HubAlwaysvisible == true then       
        SendNUIMessage({ 
          type = 'ui',
          display = true,
         })
          display = true;
        end 
      end
    end


end

function UpdateWheel( )
  if VehiculeConfig.fourwheelsc  == true then
      fourwheelsf()
    else
      twowheelsf()
  end
end

 function fourwheelsf()
  SetVehicleEngineTorqueMultiplier(ActualVehicule,1.0000)
  --SetVehicleCheatPowerIncrease(ActualVehicule,  Config.PowerIncreasse)
 end
 

 function twowheelsf()
  SetVehicleEngineTorqueMultiplier(ActualVehicule,Config.TorqueBoost)
 -- SetVehicleCheatPowerIncrease(ActualVehicule, Config.PowerIncreasse)
 end



function SendMessage(message)
  exports['mythic_notify']:DoHudText('inform', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
end
