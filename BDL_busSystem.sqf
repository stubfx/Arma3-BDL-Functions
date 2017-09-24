/*
  Author: BarboneDiLusso    // steam : http://steamcommunity.com/id/barbonedilusso
                            // gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
	simple bus system.

  Example :
    []spawn BDL_busSystem;
*/

BDL_busSystem = {
  _veh = "agora_ratp";//bus cfg name
  _bus_stop_count = 0;
  _bus_stop_list = [bus_stop_1,bus_stop_2,bus_stop_3];
  _bus_stop_max = count _bus_stop_list - 1;
  while {typeOf vehicle player == _veh} do {
    if (_bus_stop_count <= _bus_stop_max) then {
      waitUntil {speed vehicle player == 0};
      if ((vehicle player distance (_bus_stop_list select _bus_stop_count)) < 5) then {
        hint "sei alla fermata";
        vehicle player setfuel 0;
        _arrived = time;
        waitUntil {time - _arrived > 5};
        vehicle player setfuel 1;
        hint "vai via";
        // life_cash = life_cash + 20;
        _bus_stop_count = _bus_stop_count + 1;
      }
    }else{
      //se siamo arrivati al massimo ricomiciamo
      _bus_stop_count = 0;
    }
  }
};
