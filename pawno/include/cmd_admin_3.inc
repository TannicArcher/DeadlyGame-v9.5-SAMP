// Очистить лог IP-адреса игрока

if(iscmd(cmd,"/clearip")){ restricted(3);
 getTgt("Использование: /clearip [игрок]");
 ClearIP(tgt,playerid);
 return 1;
}

// Телепортировать указанного игрока к себе

if(iscmd(cmd,"/gethere")){ restricted(3);
 getTgt("Использование: /gethere [игрок]");
 GetPlayerFacingPoint(playerid,x,y,z,2.0);
 SetPlayerInterior(tgt,GetPlayerInterior(playerid));
 SetPlayerVW(tgt,GetPlayerVirtualWorld(playerid));
 TeleportPlayer(tgt,x,y,z);
 GetPlayerFacingAngle(playerid,x);
 SetPlayerFacingAngle(tgt,x);
 return 1;
}

if(iscmd(cmd,"/baninfo") || iscmd(cmd,"/i") ){ restricted(1);
 if(!fexist("/var/banned.lst")) {
  Message(playerid,"Список банов пуст",clDarkRed);
  return 1;
 }
 getStr("Использование: /baninfo [аккаунт]");
 new f = fopen("/var/banned.lst",io_read), buff[max_line], found = 0,
 idx, time, g = gtime(), account[max_line], info[max_line];
 while(fread(f,buff)){
  idx = 0; time = strval(strtok(buff,idx));
  new account[max_line]; account = strtok(buff,idx);
  if(iscmd(account,tmp)){
   found++;
   if(time>g) format(msg,max_line,"[Осталось%s]",ftime(time-g)); else msg = "[Разбанен]";
   strtok(buff,idx); // Пропускаем айпи
   strmid(info,buff,idx,strlen(buff));
   format(msg,max_line,"%s %s",msg,info);
   Message(playerid,msg,clYellow);
  }
 }
 fclose(f);
 format(msg,max_line,"Hайдено банов: %i",found);
 Message(playerid,msg,clYellow);
 return 1;
}

// Узнать последний адрес, с которого заходили на указанный аккаунт

if(iscmd(cmd,"/lastip")){ restricted(3);
 getStr("Использование: /ip [аккаунт]");
 new r = LastIP(tmp,playerid);
 if(r==1) Message(playerid,"Аккаунт не найден",clDarkRed); else
 if(r==2) Message(playerid,"Невозможно получить доступ к файлу, игрок онлайн",clDarkRed);
 return 1;
}

// Заключить игрока в тюрьму или госпиталь

if(iscmd(cmd,"/jail")){ restricted(3);
 getTgt("Использование: /jail [игрок] [время(минуты)] {место}");
 checkplayer(tgt);
 getInt("Использование: /jail [игрок] [время(минуты)] {место}");
 new place = strval(strtok(cmdtext,idx));
 if(!place) place = 1;
 JailPlayer(tgt,place,pint*60);
 SavePlayer(tgt);
 return 1;
}

// Освободить игрока из тюрьмы или госпиталя

if(iscmd(cmd,"/unjail")){ restricted(3);
 getTgt("Использование: /unjail [игрок]");
 checkplayer(tgt);
 UnjailPlayer(tgt);
 SavePlayer(tgt);
 return 1;
}

// Разбанить указанный аккаунт

if(iscmd(cmd,"/unban")){ restricted(3);
 getStr("Использование: /unban [аккаунт]");
 new r = Unban(tmp);
 switch(r){
  case 0: Message(playerid,"Игрок успешно разбанен",clYellow);
  case 1: Message(playerid,"Ошибка: Аккаунт не найден",clDarkRed);
  case 2: Message(playerid,"Флаг бана снят (игрок онлайн)",clYellow);
  case 3: Message(playerid,"Ошибка: Игрок не в бане",clDarkRed);
 }
 return 1;
}

// Переход в режим наблюдения за указанным игроком и обратно

if(iscmd(cmd,"/watch")){ restricted(3);
 getStr("Использование: /watch [игрок | off]");
 if(iscmd(tmp,"off")){
  sop[playerid] = 1;
  TogglePlayerSpectating(playerid,0);
  return 1;
 }
 tgt = ReturnUser(tmp); checkplayer(tgt);
 TogglePlayerSpectating(playerid,1);
 SetPlayerInterior(playerid,GetPlayerInterior(tgt));
 SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(tgt));
 new vid = GetPlayerVehicleID(tgt);
 if(!vid) PlayerSpectatePlayer(playerid,tgt);
  else PlayerSpectateVehicle(playerid,vid);
 Watching[playerid] = tgt;
 return 1;
}
