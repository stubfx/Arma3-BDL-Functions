/*
  Author: BarboneDiLusso
  steam : http://steamcommunity.com/id/barbonedilusso
  gitHub : https://github.com/LucaM97/Arma3_BDL_Functions


	Description:
    WORK IN PROGRESS

  Example :
    WORK IN PROGRESS
*/

BDL_FNC_LASCIA_SPAZZATURA = {
  _tmp = vehicle player getVariable ["BDL_spazzatura",[]];
  _vehicle = vehicle player;
  _vehicle say2D "beep_target";
  _cassonetto = _tmp select ((count _tmp) - 1);
  _cassonetto_arr = [_cassonetto];
  vehicle player setVariable ["BDL_spazzatura",(_tmp - _cassonetto_arr),true];
  //adesso lo spostiamo all'indietro fino a dietro il camion
  _tmp = _cassonetto worldToModel (position (vehicle player));
  _tmp_asseX =_tmp select 0;// asse x
  _i = _tmp select 1;// asse y
  _i = -_i;
  while {_i > -4} do {
    _cassonetto attachTo [vehicle player,[-_tmp_asseX,_i,-0.1]];
    _i = _i - 0.1;
    sleep 0.05;
  };
  detach _cassonetto;
  _cassonetto setpos getpos _cassonetto;// assicuriamoci che non rimanga buggato a mezz'aria
};
