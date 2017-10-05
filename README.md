# Welcome!
### Here you can find my free Arma 3 functions!


# How to import my functions?

  1. create new folder called BDL (keep your mission folder in order!)
  1. copy and paste one (or more) functions from my repository
  1. open your init.sqf file and add on the top: 
  
  Ex. i want to import my earthquake function...
  ```
  []execVm "BDL/BDL_earthquake.sqf";
  ```  
  thats it!

# After the import you can use it... but how?
  if you want to try it in console just copy and paste:
  
  Ex. use this if you need to call BDL_earthquake
  ```
  [player,10,true]spawn BDL_earthquake;
  ```  
  easy right?
  
  and is the same if you want to use it in a script...  
  Let me show an example.  
  Next snippet will open house doors when you shoot it...  
  
  ```
  //first import my function BDL_openHouseDoors
  []execVm "BDL/BDL_openHouseDoors.sqf"
  
  //next use it in a player event handler...
  player addEventHandler ["fired",{
    [cursorObject,1]call BDL_openHouseDoors;
  }];
  ```
