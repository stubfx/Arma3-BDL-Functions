/*
  Author: BarboneDiLusso
  steam : http://steamcommunity.com/id/barbonedilusso
  gitHub : https://github.com/LucaM97/Arma3_BDL_Functions


	Description:
    WORK IN PROGRESS

  Example :
    WORK IN PROGRESS
*/

BDL_FNC_RACCOGLI_SPAZZATURA = {
  _cassonetto = _this select 0;
  _vehicle = vehicle player;
  _fuel = fuel _vehicle;
  _vehicle setvelocity [0,0,0];
  _vehicle say2D "beep_target";
  // _cassonetto attachTo [vehicle player,[0,-5,-2]];
  _tmp = vehicle player getVariable ["BDL_spazzatura",[]];
  if (count _tmp > 5) then {
    hint "Il Camion è pieno!"
  }else{
    _vehicle setFuel 0;
    _tmp pushBack _cassonetto;
    vehicle player setVariable ["BDL_spazzatura",_tmp,true];
    _tmp = count _tmp;
    //poi vediamo se metterlo sulla destra o sulla sinistra
    _tmp_asseX = -0.5 + ((_tmp - 1)%2);
    _tmp_asseY = -((floor((_tmp - 1)/2)) + 1);
    //tiriamo su il cassonetto
    _i = -2;
    while {_i < -0.1} do {
      _vehicle setvelocity [0,0,0];
      _cassonetto attachTo [vehicle player,[_tmp_asseX,-4,_i]];
      _i = _i + 0.1;
      sleep 0.1;
    };
    //adesso lo spostiamo in avanti fino alla sua posizione
    _i = -4;
    while {_i < _tmp_asseY} do {
      _vehicle setvelocity [0,0,0];
      _cassonetto attachTo [vehicle player,[_tmp_asseX,_i,-0.1]];
      _i = _i + 0.1;
      sleep 0.05;
    };
    _vehicle setFuel _fuel;
  };
  _cassonetto setVariable ["BLD_owner_cassonetto",clientOwner,true];
};
