BDL_FNC_SPAWN_BIDONI = {
  _edifici_spazzatura = [
  "Land_i_House_Big_01_b_yellow_F",[1.13184,-8.27881,-3.0337],
  "Land_i_House_Big_02_b_pink_F",[-1.42822,6.62646,-3.15594],
  "Land_i_Shop_02_V1_F",[2.49609,-6.02441,-3.09999],
  "Land_i_Shop_01_V2_F",[5.86865,2.4126,-2.81184],
  "Land_i_House_Small_02_b_white_F",[-0.239258,-5.51025,-1.25667],
  "Land_Slum_House02_F",[1.09424,4.87354,-1.17412],
  "Land_i_House_Big_02_V1_F",[1.69287,6.3418,-3.10284],
  "Land_i_House_Small_01_b_pink_F",[-1.07227,-5.61182,-1.27905],
  "Land_i_Addon_02_V1_F",[0.347412,-2.00195,-0.20422],
  "Land_i_House_Small_02_V3_F",[-4.81934,-0.534912,-1.22858],
  "Land_i_House_Big_01_V3_F",[-5.58179,2.38965,-3.12411],
  "Land_i_House_Big_02_b_brown_F",[1.42358,6.33301,-3.13908],
  "Land_i_Stone_Shed_V3_F",[-0.0710449,-1.9668,-0.45129],
  "Land_i_Stone_HouseBig_V3_F",[-3.29688,5.43359,-1.84943],
  "Land_i_Stone_Shed_01_b_clay_F",[-2.25659,2.94531,-0.319553],
  "Land_i_House_Big_01_V1_F",[-5.58789,2.79785,-3.05318],
  "Land_i_House_Small_01_V1_F",[-1.1958,-5.59961,-1.34085],
  "Land_i_House_Small_02_V2_F",[-4.81812,-0.384766,-1.12219]
  ];
  _bidoni_count = 0;
  {
    _tmp = _edifici_spazzatura find typeOf _x;
    if (_tmp > -1) then {
      _tmp = _edifici_spazzatura select (_tmp + 1);
      _bidone = createVehicle ["Land_WheelieBin_01_F",(_x modelToWorld _tmp),[],0,"CAN_COLLIDE"];
      _bidoni_count = _bidoni_count + 1;
    };
  }forEach ([0,0,0] nearObjects 100000);
  diag_log format ["Ho creato %1 bidoni per i netturbini",_bidoni_count];
};
