/*
  Author: BarboneDiLusso
  steam : http://steamcommunity.com/id/barbonedilusso
  gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
	Earthquake simulation

	Parameter(s):
		_this select 0: Obj - epicenter
		_this select 1:	INT - intensity {1,2,3,4}
		_this select 2: bool - house destriction true/false

    Example :
      [player,10,true] spawn BDL_earthquake;
*/

BDL_setOnFire = {
  _obj = _this select 0;
  _fire_list = [];
  _obj setdamage 0.1;
  _fire = createVehicle ["test_EmptyObjectForFireBig",((getPos _obj) vectorAdd [0,0,1]),[],0,"CAN COLLIDE"];
  _fire_list pushBack _fire;
  _fire = createVehicle ["test_EmptyObjectForFireBig",((getPos _obj) vectorAdd [0,-3,1]),[],0,"CAN COLLIDE"];
  _fire_list pushBack _fire;
  _fire = createVehicle ["test_EmptyObjectForFireBig",((getPos _obj) vectorAdd [0,3,1]),[],0,"CAN COLLIDE"];
  _fire_list pushBack _fire;
  _obj setVariable ["BDL_fire_list",_fire_list];
  _obj spawn {
    _tmp_obj = _this;
    while {getDammage _tmp_obj > 0 && getDammage _tmp_obj != 1 && ((count(_tmp_obj getVariable ["BDL_fire_list",[]])) > 0)} do {
      sleep 1;
      _tmp_obj setdamage (getDammage _tmp_obj + 0.005);
      hintSilent format ["%1",getDammage _tmp_obj];
    };
    {
      deleteVehicle _x;
      _tmp_obj setVariable ["BDL_fire_list",[],true];
    }foreach (_tmp_obj getVariable ["BDL_fire_list",[]]);
  };
};

player addEventHandler ["fired",{
  if ((typeOf(_this select 6)) == "SmokeShell") then {
    if ((random 100) <= 5) then {
      []spawn{
        call {
          hint "spengo...";
          sleep 5;
          {
            deleteVehicle _x;
            cursorObject setVariable ["BDL_fire_list",[],true];
          }foreach (cursorObject getVariable ["BDL_fire_list",[]]);
        };
      };
    };
  };
}];
