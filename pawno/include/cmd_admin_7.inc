// Информация о воротах

if(iscmd(cmd,"/ginfo")){ restricted(7);
 new id = GetNearestGates(playerid,12.0,1);
 if(id<0){
  Message(playerid,"Поблизости нет никаких ворот",clDarkRed);
  return 1;
 }
 format(msg,max_line,"ID: %i, F: %i",id,gFaction[id]);
 Message(playerid,msg,clYellow);
 return 1;
}

// Создание ворот

if(iscmd(cmd,"/gc")){ restricted(7);
 getInt("Использование: /gc [id]");
 gCreate(pint,playerid);
 return 1;
}

// Удаление ворот

if(iscmd(cmd,"/gcd")){ restricted(7);
 getInt("Использование: /gcd [id]");
 gDestroy(pint,playerid);
 return 1;
}


// Установить фракцию для ворот

if(iscmd(cmd,"/gcf")){ restricted(7);
 getInt("Использование: /gc [id] [фракция]");
 new id = pint;
 getInt("Использование: /gc [id] [фракция]");
 gFaction[id] = pint;
 Message(playerid,"Информация обновлена");
 gSave();
 return 1;
}

// Сохранить позицию закрытых ворот

if(iscmd(cmd,"/gsc")){ restricted(7);
 getInt("Использование: /gsc [id]");
 GetObjectPos(gID[pint],gClosedPos[pint][0],gClosedPos[pint][1],gClosedPos[pint][2]);
 GetObjectRot(gID[pint],gClosedPos[pint][3],gClosedPos[pint][4],gClosedPos[pint][5]);
 Message(playerid,"Позиция закрытых ворот сохранена");
 gSave();
 return 1;
}

// Сохранить позицию открытых ворот

if(iscmd(cmd,"/gso")){ restricted(7);
 getInt("Использование: /gso [id]");
 GetObjectPos(gID[pint],gOpenPos[pint][0],gOpenPos[pint][1],gOpenPos[pint][2]);
 Message(playerid,"Позиция открытых ворот сохранена");
 gSave();
 return 1;
}

// Передвинуть ворота

if(iscmd(cmd,"/gm")){ restricted(7);
 getInt("Использование: /gm [id] {x} {y} {z}");
 x = floatstr(strtok(cmdtext,idx));
 y = floatstr(strtok(cmdtext,idx));
 z = floatstr(strtok(cmdtext,idx));
 gMove(pint,x,y,z);
 return 1;
}

// Повернуть ворота

if(iscmd(cmd,"/gr")){ restricted(7);
 getInt("Использование: /gr [id] {x} {y} {z}");
 x = floatstr(strtok(cmdtext,idx));
 y = floatstr(strtok(cmdtext,idx));
 z = floatstr(strtok(cmdtext,idx));
 gRotate(pint,x,y,z);
 return 1;
}

// Создать телепорт

if(iscmd(cmd,"/tpc")){ restricted(7);
 tpCreate(playerid);
 return 1;
}

// Привязать телепорт ко фракции

if(iscmd(cmd,"/tpf")){ restricted(7);
 getInt("Использование: /tpf [id] [фракция]");
 new id = pint;
 getInt("Использование: /tpf [id] [фракция]");
 tpFaction[id] = pint;
 Message(playerid,"Фракция изменена");
 return 1;
}

// Привязать телепорт к собстенности

if(iscmd(cmd,"/tpz")){ restricted(7);
 getInt("Использование: /tpz [id] [бизнес]");
 new id = pint;
 getInt("Использование: /tpz [id] [бизнес]");
 tpBiz[id] = pint;
 Message(playerid,"Бизнес изменен");
 return 1;
}

// Список активных телепортов

if(iscmd(cmd,"/tplist")){ restricted(7);
 Message(playerid,"Active TPs:",clYellow);
 for(new i=0; i<max_tps; i++) if(tpSPos[i][0]!=0.0) {
  format(msg,max_line,"TP #%i: from (%.2f,%.2f,%.2f) to (%.2f,%.2f,%.2f,%.2f in %i), f: %i, biz: %i, puid: %i",i,tpSPos[i][0],tpSPos[i][1],tpSPos[i][2],
   tpDPos[i][0],tpDPos[i][1],tpDPos[i][2],tpDPos[i][3],tpDIntr[i],tpFaction[i],tpBiz[i],tpID[i]);
  Message(playerid,msg);
 }
 return 1;
}

// Телепортироваться в исходную позицию указанного телепорта

if(iscmd(cmd,"/tpgoto")){ restricted(7);
 getInt("Использование: /tpgoto [id]");
 SetPlayerPosEx(playerid,tpSPos[pint][0],tpSPos[pint][1],tpSPos[pint][2]);
 return 1;
}

// Задать исходную позицию указанного телепорта

if(iscmd(cmd,"/tps")){ restricted(7);
 getInt("Использование: /tps [id]");
 tpSetSPos(pint,playerid);
 return 1;
}

// Задать конечную позицию указанного телепорта

if(iscmd(cmd,"/tpd")){ restricted(7);
 getInt("Использование: /tpd [id]");
 tpSetDPos(pint,playerid);
 return 1;
}

if(iscmd(cmd,"/restart")){ restricted(3);
 getInt("Испльзование: /restart [таймер]");
 if(pint>120) {
  Message(playerid,"Таймер рестарта нельзя установить больше, чем на 2 минуты",clDarkRed);
  return 1;
 }
 if(!pint && gmxTD){
  TextDrawDestroy(gmxTD);
 }
 gmxTD = TextDrawCreate(320.0,100.0," ");
 TextDrawFont(gmxTD,3);
 TextDrawAlignment(gmxTD,2);
 TextDrawLetterSize(gmxTD,0.9,1.2);
 TextDrawSetOutline(gmxTD,1);
 TextDrawShowForAll(gmxTD);
 gmxTimer = pint;
 return 1;
}

