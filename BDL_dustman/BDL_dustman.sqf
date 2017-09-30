/*
  Author: BarboneDiLusso
  steam : http://steamcommunity.com/id/barbonedilusso
  gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
    WORK IN PROGRESS

  Example :
    WORK IN PROGRESS
*/

_BDL_tmp = []execVm "BDL_spawnTrashcan.sqf";
waitUntil {scriptDone _BDL_tmp;};
_BDL_tmp = []execVm "BDL_tipTape.sqf";
waitUntil {scriptDone _BDL_tmp;};
_BDL_tmp = []execVm "BDL_pickUpTrash.sqf";
waitUntil {scriptDone _BDL_tmp;};
_BDL_tmp = []execVm "BDL_releaseTrash.sqf";
waitUntil {scriptDone _BDL_tmp;};
_BDL_tmp = []execVm "BDL_addTrashcanMoney.sqf";
waitUntil {scriptDone _BDL_tmp;};

if (!isServer) then {
  _BDL_tmp = []execVm "BDL_dustmanKeys.sqf";
  waitUntil {scriptDone _BDL_tmp;};
}else{
  //SERVER ONLY!!
  []call BDL_FNC_SPAWN_BIDONI;
  []spawn BDL_FNC_NASTRO_SPAZZATURA;
}
