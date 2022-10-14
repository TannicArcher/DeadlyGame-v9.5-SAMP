// Анонимное сообщение в общий чат

if(iscmd(cmd,"/mole")){ restricted(2);
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"Использование: /mole [текст]");
  return 1;
 }
 if(PlayerAdmin[playerid]<6) format(msg,max_line,"*** Модератор: %s",tmp);
 else format(msg,max_line,"*** Aдмин: %s",tmp);
 AMessage(msg,clLightBlue);
 return 1;
}

// Анонимное сообщение конкретному игроку

if(iscmd(cmd,"/molemsg")){ restricted(1);
 getTgt("Использование: /msg [игрок] [текст]");
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"Использование: /molemsg [игрок] [текст]");
  return 1;
 }
 format(msg,max_line,"*** Сообщение администрации: %s",tmp);
 Message(playerid,msg,clLightBlue);
 return 1;
}

// Просмотреть, кто и когда входил с IP-адреса игрока кроме него самого

if(iscmd(cmd,"/checkip")){ restricted(2);
 getTgt("Использование: /checkip [игрок]");
 CheckIP(tgt,playerid);
 return 1;
}

// Телепортироваться к указанному игроку

if(iscmd(cmd,"/goto")){ restricted(1);
 getTgt("Использование: /goto [игрок]");
 GetPlayerFacingPoint(tgt,x,y,z,-2.0);
 SetPlayerInterior(playerid,GetPlayerInterior(tgt));
 SetPlayerVW(playerid,GetPlayerVirtualWorld(tgt));
 TeleportPlayer(playerid,x,y,z);
 GetPlayerFacingAngle(tgt,x);
 SetPlayerFacingAngle(playerid,x);
 return 1;
}


