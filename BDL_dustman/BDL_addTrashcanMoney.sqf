/*
  Author: BarboneDiLusso    // steam : http://steamcommunity.com/id/barbonedilusso
                            // gitHub : https://github.com/LucaM97/Arma3_BDL_Functions

	Description:
    WORK IN PROGRESS

  Example :
    WORK IN PROGRESS
*/

BDL_add_soldi_per_bidone = {
  _soldi_per_bidone = 35;
  life_cash = life_cash + _soldi_per_bidone;
  hint format ["Hai guadagnato %1€ per aver consegnato un bidone",_soldi_per_bidone];
};
