/////////////////////////////////
/*
Author:
BarboneDiLusso - http://steamcommunity.com/id/barbonedilusso/
gitHub : https://github.com/LucaM97/Arma3_BDL_Functions
Description:
Drag system + vehicle load
//how to use it
just insert this in your core/init.sqf file 	-------------> []spawn {[]execVm "BDL_dragSystem.sqf";};
Ts3:
Twgitalia.eu
*/

/////////////////////////////////
BDL_HospitalMarkers = ["marker_99"];//enable ONLY if u are in a life server
//inserire il tipo di veicolo in cui si puo trasportare il corpo
BDL_DROP_LoadOnVehicleType = ["Car","support","ship","Armored","Air"];
// max time in bleeding out ---- if time is over player dies
BDL_BleedingOut_maxTime = 60*1;
BDL_BleedingOut_stabTime = 60*1;
/////////////////////////////////
player addEventHandler["Respawn",{deleteVehicle (_this select 1);disableUserInput false;life_respawned = true; [] call life_fnc_spawnMenu;}];
/////////////////////////////////

BDL_dragBodyBleedingOut = {
	private "_time";
	_stab_time = 0;
	_time = 0;
	_wasStabilized = false;
	player setVariable ["BDL_BleedingOut_stabilized",false,true];
	while {(alive player) && (lifeState player == "INCAPACITATED")} do {
		sleep 1;
		_time = _time + 1;
		"colorCorrections" ppEffectEnable true;
		"colorCorrections" ppEffectAdjust [1, 1, -0.6, [1, 0, 0, 0.5], [1,1,1,1], [0.199, 0.587, 0.114, 0]];
		"colorCorrections" ppEffectCommit BDL_BleedingOut_maxTime;
		if (_time >= BDL_BleedingOut_maxTime) then {
			player setDamage 1;
		};
		if (!_wasStabilized) then {
			if (player getVariable ["BDL_BleedingOut_stabilized",true]) then {
				_wasStabilized = true;
				player setVariable ["BDL_BleedingOut_stabilized",true,true];
				while {(alive player) && (lifeState player == "INCAPACITATED") && (_stab_time < BDL_BleedingOut_stabTime)} do {
					sleep 1;
					_stab_time = _stab_time + 1;
				};
			};
		};
	};
	"colorCorrections" ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1,1,1,1], [0.199, 0.587, 0.114, 0]];
	"colorCorrections" ppEffectCommit 0;
	//and just for be sure...
	"colorCorrections" ppEffectEnable false;
};

BDL_dragBodyRevive = {
	player switchMove "";
	player setUnconscious false;
	player setdamage 0.5;
	disableUserInput false;
};

BDL_addEventHandlers = {
	private "_unit";
	_unit = _this select 0;
	//BDL_fake_bob addEventHandler ["getOutMan",{[(BDL_fake_bob getVariable "My_real_bob"),"vehicle"]call BDL_dropAction;}];
};

BDL_PlayerEventHandlers = {
	if ((_this select 0) == "add") then{
		BDL_DROP_PLAYER_EH = player addEventHandler ["GetInMan",{
			moveOut player;
			[player,"grabDrag"]remoteExec["playAction"];
			player forceWalk true;
			hint "non puoi salire nell'auto mentre trasporti qualcuno!";
		}];
	}else{
		player removeEventHandler ["GetInMan",BDL_DROP_PLAYER_EH];
	};
};

BDL_startDrag = {
	private "_unit";
	_unit = _this select 0;
	[player,"grabDrag"]remoteExec["playAction"];
	player forceWalk true;
	[_unit,"AinjPpneMrunSnonWnonDb"] remoteExec ["switchMove"];
	_unit attachto [player,[0,1,0]];
	_unit forceAddUniform (uniform _unit);
	[_unit,0.8]remoteExec["setdamage"];
	[_unit,180]remoteExec["setDir"];
};

BDL_stopDrag = {
	private "_unit";
	_unit = _this select 0;
	detach _unit;
	player forceWalk false;
	BDL_isDRAGGING = false;
	[player,""]remoteExec["switchMove"];
};

BDL_loadInVehicle = {
	private ["_unit","_veh","_app","_app1"];
	_unit = _this select 0;//sempre il solito bob originale
	_veh = _this select 1;
	BDL_STOP_FOLLOW_BOB = true;
	[_unit]call BDL_stopDrag;
	//[BDL_fake_bob]call BDL_addEventHandlers;
	detach _unit;
	[_unit,_veh] remoteExec ["moveinCargo"];
	BDL_isDRAGGING = false;
	["remove"]call BDL_PlayerEventHandlers;
	BDL_DRAG = -2;
};

BDL_canLoadInThatVehicle = {
	private ["_bool","_veh"];
	_bool = false;
	_veh = (_this select 0);
	{
		if (_veh isKindOf _x) then {_bool = true;};
	}foreach BDL_DROP_LoadOnVehicleType;
	_bool;//return _bool
};

BDL_dropType = {
	//lo mettiamo nel veicolo o lo lasciamo a terra?
	private ["_unit","_action1","_action2"];//aggiungere una variabile per ogni addaction
	_unit = _this select 0;//il nuovo bob che è in attesa
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_action1 = player addaction ["<t color='#ff0000'>Lascia</t>",
	{
		[(_this select 3),"hand"]call BDL_dropAction;
	},_unit/*qui gli passo il nuovo bob*/];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_action2 = player addaction ["<t color='#ffff00'>carica nel Veicolo</t>",
	{
		private "_veh";
		_veh = cursorObject;
		if ([_veh]call BDL_canLoadInThatVehicle) then {
			if ((player distance _veh) < 5) then {
				if ((_veh emptypositions "cargo") > 0) then {
					//se è tutto apposto...
					[(_this select 3),_veh]call BDL_loadInVehicle;
				}else{
					hint "non c'è posto nel veicolo!";//vabbe dai, questa è ovvia
				};
			}else{
				hint "si, è gia che ci siamo ti teletrasporto e ti regalo 100k";//se è troppo distante
			};
		}else{
			hint "l'importante è esserne convinti...";//se non è un veicolo
		};
	},_unit/*qui gli passo il nuovo bob per...boh, cazzo ne so*/];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	waitUntil{BDL_DRAG == -2};
	{player removeaction _x;} forEach [_action1,_action2];
};

BDL_dropAction = {
	private ["_unit","_app"];
	_unit = _this select 0;//il nuovo bob che è in attesa
	BDL_isDRAGGING = true;
	if ((_this select 1) == "hand") then {
		[_unit]call BDL_stopDrag;
		["remove"]call BDL_PlayerEventHandlers;
	};
	BDL_isDRAGGING = false;
	[_unit,"AinjPpneMstpSnonWrflDb_release"] remoteExec ["switchMove"];
	BDL_DRAG = -2;
};

BDL_nearHospital = {
	//controlla se l'unità passata come parametro, è vicina ad un marker dell'ospedale
	//aggiungi markers alla variabile BDL_HospitalMarkers in testa al documento se vuoi aggiungere altri ospedali
	//ma ricorda, i marker sono indipendenti dalla struttura a cui sono vicini,
	//quindi se lo metti in un cimitero ,piu che rianima,
	//metti resuscita
	private ["_unit","_bool"];
	_unit = (_this select 0);
	_bool = false;
	{
		if (((_unit distance getMarkerPos _x) < 50) && !(_bool)) then {_bool = true;};
	}foreach BDL_HospitalMarkers;
	_bool;
};

BDL_dragAddaction = {
	private ["_unit","_app"];
	_unit = _this select 0;
	BDL_DRAG = _unit addaction ["<t color='#00ff00'>Trascina</t>",
	{
		private "_unit";
		_unit = (_this select 0);
		BDL_isDRAGGING = true;
		[_unit]call BDL_startDrag;
		["add"]call BDL_PlayerEventHandlers;
		_unit removeaction BDL_DRAG;
		if (BDL_REVIVEADDACTION > -1) then {
			player removeaction BDL_REVIVEADDACTION;

		};
		//[(_this select 0),BDL_fake_bob]spawn BDL_seguiMorto; //unit 1 segue unit 2
		[(_this select 0)]call BDL_dropType;
	}
	];
	if((count BDL_HospitalMarkers) > 0) then {
		if ((BDL_REVIVEADDACTION < 0) && (lifeState _unit == "INCAPACITATED") && (!BDL_isDRAGGING)) then {
			if ([_unit]call BDL_nearHospital) then {
				//per motivi miei ho deciso di attaccare l'azione al player e non a _unit
				//zitto e incassa coglione
				BDL_REVIVEADDACTION = player addaction ["<t color='#ff8000'>Rianima</t>",
				{
					player removeaction BDL_REVIVEADDACTION;
					[(_this select 3)] call life_fnc_revivePlayer;
				},_unit
				];
			};
		};
		if ((BDL_STABILIZEADDACTION < 0) && (lifeState _unit == "INCAPACITATED") && (!BDL_isDRAGGING)) then {
			_app = _unit getVariable ["BDL_BleedingOut_stabilized",true];//per stab deve essere false
			if (!_app) then {
				//per motivi miei ho deciso di attaccare l'azione al player e non a _unit
				//zitto e incassa coglione
				BDL_STABILIZEADDACTION = player addaction ["<t color='#ff8000'>Stabilizza</t>",
				{
					(_this select 3) setVariable ["BDL_BleedingOut_stabilized",true,true];
					player removeaction BDL_STABILIZEADDACTION;
					BDL_STABILIZEADDACTION = -1;
					[player,"AinvPknlMstpSnonWnonDnon_medic_1"] remoteExecCall ["playMove"];
				},_unit
				];
			};
		};
	};
};

BDL_delAddactionOnDistance = {
	//_this select 0 = _unit a cui è legata l'addaction
	if(((((player distance (_this select 0)) > 3) || (cursorObject != (_this select 0))) && (!BDL_isDRAGGING)) || (lifeState player == "INCAPACITATED")) then {
		(_this select 0) removeaction BDL_DRAG;
		if (BDL_REVIVEADDACTION > -1) then {
			player removeaction BDL_REVIVEADDACTION;
			BDL_REVIVEADDACTION = -1;
		};
		if (BDL_STABILIZEADDACTION > -1) then {
			player removeaction BDL_STABILIZEADDACTION;
			BDL_STABILIZEADDACTION = -1;
		};
		BDL_DRAG = -2;
	}else{
		if (BDL_isDRAGGING) then {
			if (BDL_REVIVEADDACTION > -1) then {
				player removeaction BDL_REVIVEADDACTION;
				BDL_REVIVEADDACTION = -1;
			};
			if (BDL_STABILIZEADDACTION > -1) then {
				player removeaction BDL_STABILIZEADDACTION;
				BDL_STABILIZEADDACTION = -1;
			};
		};
	};
};

BDL_cercaCorpiNelVeicolo = {
	private ["_veh","_ret"];
	_veh = _this select 0;
	_ret = false;
	{
		if ((lifeState _x) == "INCAPACITATED") then {
			_ret = true;
		};
	}foreach units _veh;
	//return _ret
	_ret;
};

BDL_ALLOUT = {
	private "_veh";
	_veh = _this select 0;
	{
		if (lifeState _x == "INCAPACITATED") then {
			[_x,getPos player]remoteExec["setPos"];
		};
	} forEach crew _veh;
};

BDL_ACTIONDRAGFORVEHICLES = {
	private "_unit";
	_unit = _this select 0;
	BDL_CHECKINGVEHICLEFORDRAG = false;
	if ([_unit]call BDL_canLoadInThatVehicle) then {
		if ((player distance _unit) < 3) then {
			if ([_unit]call BDL_cercaCorpiNelVeicolo) then {
				BDL_DRAG = player addaction ["<t color='#ffff00'>Estrai Corpo</t>",{
					private ["_unit"];
					_unit = _this select 3;
					[_unit]call BDL_ALLOUT;
					player removeaction BDL_DRAG;
					BDL_DRAG = -2;
				},_unit/*vehicle cursorObject*/];
				waitUntil{(_unit != cursorObject) || (BDL_DRAG == -2) || ((player distance _unit) > 3)};//aspettiamo che il player non guardi piu il veicolo e...
				if (BDL_DRAG != -2) then {
					player removeaction BDL_DRAG;
					BDL_DRAG = -2;
				};
			};
		};
	};
};

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

private ["_unit"];
BDL_fake_bob = nil;
BDL_STOP_FOLLOW_BOB = false;
BDL_DROP_PLAYER_EH = nil;
BDL_isDRAGGING = false;
BDL_REVIVEADDACTION = -2;
BDL_STABILIZEADDACTION = -2;
BDL_DROP_PLAYER_EH = -2;

while {true} do {
	sleep 1;
	if (!BDL_isDRAGGING) then {
		_unit = cursorObject;
		BDL_DRAG = -2;
		BDL_isDRAGGING = false;
		if (lifeState player != "INCAPACITATED") then {
			if ((_unit isKindOf "man") && ((lifeState _unit) == "INCAPACITATED") && ((player distance _unit) < 3) && (BDL_DRAG == -2)) then {
				[_unit]call BDL_dragAddaction;
				while {BDL_DRAG >= 0} do {
					[_unit]call BDL_delAddactionOnDistance;
				};
			}else{
				if (BDL_DRAG == -2) then {
					[_unit]call BDL_ACTIONDRAGFORVEHICLES;
				};
			};
		};
	}else{
		//se era true, allora _unit era ancora attaccato a player
		["remove"]call BDL_PlayerEventHandlers;
		detach _unit;
		BDL_isDRAGGING = false;
	};
};
