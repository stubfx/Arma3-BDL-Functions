/*
	Author: BarboneDiLusso    // steam : http://steamcommunity.com/id/barbonedilusso
														// gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description: this script will restore a vehicle which is kind of Car on the platform
							i recommend to use it in addaction like a restore base
							PS. PLATFORM MUST BE AN OBJECT IN GAME (mission.sqm) LIKE AN HELI PLATFORM

	params : platform of rearm - Object

	Example:
		[platform]call BDL_restoreVehicle;
*/
BDL_limitDistanceForRestoreVehicle = {
	_f = false;
	_old = _this select 0;
	_old_x = _old select 0;
	_old_y = _old select 1;
	_old_z = _old select 2;
	_new = _this select 1;
	_new_x = _new select 0;
	_new_y = _new select 1;
	_new_z = _new select 2;
	if ((_new_x - _old_x) < 3) then {
		if ((_new_y - _old_y) < 3) then {
			if ((_new_z - _old_z) < 3) then {_f = true;};
		};
	};
	_f //return f
};
BDL_restoreVehicle = {
[_this select 0] spawn {
	  _platform = _this select 0;
	  _count = 0;
	  _f = false;
	  _v = "";
	  {
	  	if ((_x isKindOf "Car") || (_x isKindOf "Air")) then {
	  		_f = true;
	  		_v = _x;
	  	};
	  }forEach (_platform nearobjects 5);
	  if (_f) then {
	  	hint "I will restore your vehicle, please, don't move it";
	  	_old_pos = getpos _v;
	  	while {(_count < 101) && ([_old_pos,getpos _v]call BDL_limitDistanceForRestoreVehicle)} do {
	  		systemchat format ["Restoring Vehicle: %1%2",_count,toString [37]];
	  		sleep 1;
	  		_count = _count + 1;
	  		};
	  	if (_count >= 100) then {
	  		_ammo = weapons _v;
	  		{_v setammo [_x,1000];}foreach _ammo;
	  		_v setfuel 1;
	  		_v setdamage 0;
	  		hint "I have restored your vehicle";
	  	}else {
	  		hint "You moved your vehicle,f*ck you";
	  	};
	  }else{
	  	hint "Are you kidding me?!?";
	  };
	};
};
