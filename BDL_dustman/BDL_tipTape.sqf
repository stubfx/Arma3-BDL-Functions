/*
  Author: BarboneDiLusso    // steam : http://steamcommunity.com/id/barbonedilusso
                            // gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
    WORK IN PROGRESS

  Example :
    WORK IN PROGRESS
*/

BDL_FNC_NASTRO_SPAZZATURA = {
  _tmp_nastro_offset = 0;
  BDL_NASTRO_SPAZZATURA = nastro_discarica;
  while {true} do {
    _cassonetto = nearestObject [(BDL_NASTRO_SPAZZATURA modelToWorld [0,_tmp_nastro_offset - 10,(_tmp_nastro_offset/4.5) + 1.5]),"Land_WheelieBin_01_F"];
    if ((typeOf _cassonetto) in ["Land_WheelieBin_01_F"]) then {
      if (isNull attachedTo _cassonetto) then {
        if (((BDL_NASTRO_SPAZZATURA modelToWorld [0,_tmp_nastro_offset - 10,(_tmp_nastro_offset/4.5) + 1.5]) distance position _cassonetto) < 10) then{
          [_cassonetto]spawn {
            private ["_cassonetto","_i"];
            _cassonetto = _this select 0;
            _i = 0;
            while {_i < 37} do {
              _cassonetto attachTo [BDL_NASTRO_SPAZZATURA,[0,_i - 10,(_i/4.5) + 1.5]];
              _i = _i + 0.1;
              sleep 0.05;
            };
            //diamo i soldi al player che l'ha portato
            _tmp_owner_cassonetto = _cassonetto getVariable ["BLD_owner_cassonetto",-1];
            if (_tmp_owner_cassonetto != -1) then {
              [] remoteExec ["BDL_add_soldi_per_bidone",_tmp_owner_cassonetto];
            };
            //poi lo cancelliamo
            deleteVehicle _cassonetto;
          };
        };
      };
    };
    sleep 3;
  };
};
