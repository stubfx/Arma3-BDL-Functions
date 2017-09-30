/*
  Author: BarboneDiLusso    // steam : http://steamcommunity.com/id/barbonedilusso
                            // gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
	Earthquake simulation

	Parameter(s):
		_this select 0: Obj - epicenter
		_this select 1:	INT - intensity {1,2,3,4}
		_this select 2: bool - house destriction true/false

    Example :
      [player,10,true] spawn BDL_earthquake;
*/
BDL_earthquake = {
	_this spawn {
		private ["_magnitude", "_power", "_duration", "_frequency", "_fatigue", "_epicenter"];
		_epicenter = _this select 0;
		_magnitude = _this select 1;
		_isDangerous = _this select 2;
		if (_magnitude < 1) exitWith {};
		_power = 0.3 * _magnitude;
		_duration = 20;
		_frequency = 200/_magnitude;
		_fatigue = 0.5;
		if( isNil "BDL_earthquakeInProgress" ) then {BDL_earthquakeInProgress = false;};
		enableCamShake true;
		BDL_earthquakeInProgress = true;
		playsound "Earthquake_04";
		"DynamicBlur" ppEffectEnable true;
		"DynamicBlur" ppEffectAdjust [_magnitude/2];
		"DynamicBlur" ppEffectCommit 0.1;
		sleep 0.1;
		if (_isDangerous) then {
			{
					_x setdamage (random floor ((_magnitude/10) + 0.2));
			}foreach nearestTerrainObjects [_epicenter, ["House"], 200*_magnitude];
		};
		"DynamicBlur" ppEffectAdjust [0];
		"DynamicBlur" ppEffectCommit (_duration);
		player setFatigue _fatigue;
		addCamShake [_power, _duration, _frequency];
		Sleep 3;
		BDL_earthquakeInProgress = false;
	};
};
