/*
  Author: BarboneDiLusso
  steam : http://steamcommunity.com/id/barbonedilusso
  gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
    WORK IN PROGRESS

  Example :
    WORK IN PROGRESS
*/

[]spawn {
  while {true} do {
    waitUntil {inputAction "zeroingUp" > 0};
    if (typeOf (vehicle player) in ["C_Van_01_transport_F"] ) then {
      _cassonetto = nearestObject [((vehicle player) modelToWorld [0,-4,-2]),"Land_WheelieBin_01_F"];
      if (isNull attachedTo _cassonetto) then {
        if ((((vehicle player) modelToWorld [0,-4,-2]) distance position _cassonetto) < 3) then {
          if ((typeOf _cassonetto) in ["Land_WheelieBin_01_F"]) then {
            [_cassonetto]call BDL_FNC_RACCOGLI_SPAZZATURA;
          }
        }
      }
    }
  };
};
[]spawn {
  while {true} do {
    waitUntil {inputAction "zeroingDown" > 0};
    if (typeOf (vehicle player) in ["C_Van_01_transport_F"] ) then {
      _tmp = vehicle player getVariable ["BDL_spazzatura",[]];
      if ((count _tmp) > 0) then {
          []call BDL_FNC_LASCIA_SPAZZATURA;
      }
    }
  };
};
