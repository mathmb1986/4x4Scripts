Config	= {}
Config.Locale = 'fr'

Config.HubAlwaysvisible = true
Config.AutoGestion = true -- If Detect 4wd Car Activate Function

--Config.VehiculeGroups = {}
-- https://wiki.gtanet.work/index.php?title=Vehicle_Classes
Config.VehiculeGroups = {2,9,12,17,18,20}

--Config.VehiculeGroups = {0,1,2,9,17,20,18}
-- https://wiki.gtanet.work/index.php?title=Vehicle_Models

--Config.VehiculeGroupsExeption = {}

Config.VehiculeGroupsExeption =
 {"BLAZER",
  "BLAZER2",
  "BLAZER3",
  "BLAZER5",
  "BFINJECT",
 }

Config.InputToPresse = 132
Config.InputToKeepPresse = 86

--https://docs.fivem.net/docs/game-references/controls/

Config.TorqueBoost = 1.8
Config.PowerIncreasse = 1.1


--  CheatPowerIncrease
--
-- <1.0 - Decreased torque
-- =1.0 - Default torque
-- >1.0 - Increased torque
-- Negative values will cause the vehicle to go backwards instead of forwards while accelerating.
-- value - is between 0.2 and 1.8 in the decompiled scripts.
-- his needs to be called every frame to take effect.
--
--