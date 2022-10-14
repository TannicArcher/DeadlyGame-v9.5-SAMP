// Телепортировать к себе указанный автомобиль

if(iscmd(cmd,"/vgth")){ restricted(4);
 getInt("Использование: /vgth [id машины]");
 if(!GetVehicleModel(pint)){
  Message(playerid,"Такого автомобиля не существует",clDarkRed);
  return 1;
 }
 if(GetPlayerVehicleID(playerid)==pint){
  Message(playerid,"Вы сидите в этой машине",clDarkRed);
  return 1;
 }
 SetVehicleInterior(pint,GetPlayerInterior(playerid));
 SetVehicleVirtualWorld(pint,GetPlayerVirtualWorld(playerid));
 GetPlayerFacingPoint(playerid,x,y,z,8.0);
 PutPlayerInVehicle(playerid,pint,0);
 SetVehiclePos(pint,x,y,z);
 return 1;
}

// Телепортироваться к указанному автомобилю

if(iscmd(cmd,"/vgoto")){ restricted(4);
 getInt("Использование: /vgoto [id машины]");
 if(!GetVehicleModel(pint)){
  Message(playerid,"Такой машины не существует",clDarkRed);
  return 1;
 }
 if(GetPlayerVehicleID(playerid)==pint){
  Message(playerid,"Вы сидите в этой машине",clDarkRed);
  return 1;
 }
 GetVehiclePos(pint,x,y,z);
 SetPlayerInterior(playerid,GetVehicleInterior(pint));
 SetPlayerVW(playerid,GetVehicleVirtualWorld(pint));
 TeleportPlayer(playerid,x,y,z+2.0);
 GetVehicleZAngle(tgt,x);
 SetPlayerFacingAngle(playerid,x);
 return 1;
}

// Узнать ID ближайшей машины

if(iscmd(cmd,"/nc")){ restricted(4);
 new vid = GetNearestVehicle(playerid,2000.0);
 if(!vid){
  Message(playerid,"Нет автомобилей в радиусе 2000 юнитов",clDarkRed);
  return 1;
 }
 new Float: d = GetDistancePV(playerid,vid);
 format(msg,max_line,"[%.2f] %s: %i",d,CarName[GetVehicleModel(vid)-400],vid);
 Message(playerid,msg,clYellow);
 return 1;
}

// Получить подробную информацию о ближайщей машине

if(iscmd(cmd,"/vinfo")){ restricted(4);
 new v = 0;
 getInt("Использование: /vinfo [id автомобиля]");
 m = GetVehicleModel(v); if(!m){
  Message(playerid,"Такого автомобиля не существует",clDarkRed);
  return 1;
 }
 format(msg,max_line,"V #%i: model %i \"%s\", src: %i.%i, f: %i.%i, vw: %i, intr: %i, cat: %s",v,m,CarName[m-400],
  SourceAMT[v],SourceSpawn[v],VFaction[v],VRank[v],GetVehicleVirtualWorld(v),GetVehicleInterior(v),CatName[GetVehicleCategory(v)]);
 Message(playerid,msg);
 format(msg,max_line,"OWNER: %s, PJ: %i, CC: %i/%i, DATE: %i (%s), A: %s, LD: %s",
  Owner[v],PJ[v],Color1[v],Color2[v],Date[v],ftime(v),Allow[v],LastDriver[v]);
 Message(playerid,msg);
 return 1;
}

// Привязать автомобиль к фракции

if(iscmd(cmd,"/mkvf")){ restricted(4);
 new vid = GetNearestVehicle(playerid,distance_megaphone);
 getInt("Использование: /mkvf [фракция] [ранг]");
 new f = pint;
 getInt("Использование: /mkvf [фракция] [ранг]");
 VFaction[vid] = f;
 VRank[vid] = pint;
 SaveVehicle(vid,1);
 Message(playerid,"Изменения сохранены");
 return 1;
}

// Изменить количество топлива

if(iscmd(cmd,"/setfuel")){ restricted(2);
 getInt("Использование: /fuel [id автомобиля] [количество топлива]");
 new vid = pint; if(!GetVehicleModel(vid)){
  Message(playerid,"Такого автомобиля не существует",clDarkRed);
  return 1;
 }
 getInt("Использование: /setfuel [id автомобиля] [количество топлива]");
 if(pint<0 || pint>100){
  Message(playerid,"Некорректное количество",clDarkRed);
  return 1;
 }
 Fuel[vid] = pint;
 SaveVehicle(vid);
 CheckFuel(GetVehicleDriver(vid));
 Message(playerid,"Количество топлива изменено",clYellow);
 return 1;
}

// Список всех авторынков

if(iscmd(cmd,"/ams")){ restricted(3);
 for(new i=0; i<max_ams; i++)
  if(strlen(AMName[i])) AMShowInfo(i,playerid);
 return 1;
}

// Создание авторынка

if(iscmd(cmd,"/amtcreate")){ restricted(3);
 AMCreate(playerid);
 return 1;
}

// Управление авторынком

if(iscmd(cmd,"/amt")){ restricted(6);
 new id = strval(strtok(cmdtext,idx)), action[max_line], p, p2, sp[max_line];
 if(!strlen(AMName[id])){
  Message(playerid,"Указанный вами авторынок не существует");
  return 1;
 }
 action = strtok(cmdtext,idx);
 if(!strlen(action)){
  Message(playerid,"Использование: /amt [id] [действие] {параметры...}");
  return 1;
 }
 strmid(sp,cmdtext,idx,strlen(cmdtext));
 p = strval(strtok(cmdtext,idx)); 
 p2 = strval(strtok(cmdtext,idx)); 
 if(iscmd("ex",action)) {
  if(p<1 || p>1000){
   Message(playerid,"Разрешены значения от 1 до 1000",clDarkRed);
   return 1;
  }
  for(new i=0; i<AMCarsCount[id]; i++)
   AMCars[id][i][1] = floatround(float(AMCars[id][i][1])*float(p)/100.0);
 } else if(iscmd("name",action)) AMSetName(id,playerid,sp); else
 if(iscmd("info",action)) AMShowInfo(id,playerid); else
 if(iscmd("create",action)) AMCreate(playerid); else
 if(iscmd("nitro",action)) AMNitro[id] = 1; else
 if(iscmd("hydr",action)) AMHydr[id] = 1; else
 if(iscmd("pj",action)) AMPaintjob[id] = 1; else
 if(iscmd("cars",action)) AMShowCars(id,playerid); else
 if(iscmd("spawns",action)) AMShowSpawns(id,playerid); else
 if(iscmd("spawn",action)) AMShowSpawn(id,p,playerid); else
 if(iscmd("addspawn",action)) AMAddSpawn(id,playerid); else
 if(iscmd("rmspawn",action)) AMRmSpawn(id,p,playerid); else
 if(iscmd("addcar",action)) AMAddCar(id,p,p2,playerid); else
 if(iscmd("rmcar",action)) AMRmCar(id,p,playerid); else
 if(iscmd("spawncar",action)) AMSpawnCar(id); else
 if(iscmd("fill",action)) AMFill(id); else
 if(iscmd("gt",action)) {
  AMGoto(id,-1,playerid);
  SetPlayerInterior(playerid,0);
 } else if(iscmd("goto",action)) {
  AMGoto(id,p,playerid);
  SetPlayerInterior(playerid,0);
 } else if(iscmd("clear",action)) AMClear(id); else
 if(iscmd("return",action)) {
  for(new i=1; i<max_vehicles; i++)
   if(SourceAMT[i]==id && GetVehicleModel(i)) VehicleDestroy(i);
  for(new i=0; i<max_ams_spawns; i++) AMFreeSpawn[id][i] = 1;
  AMFill(id);
 }
 FindIconPos(id);
 SaveAMT(id);
 return 1;
}
