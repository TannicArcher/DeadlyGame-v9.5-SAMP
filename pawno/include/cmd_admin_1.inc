///////////////////
// SA Mafia Wars //
///////////////////

// Админ-чат

if(iscmd(cmd,"/a")){ restricted(1);
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"Использование: /a [текст]");
  return 1;
 }
 format(msg,max_line,"* %i админ %s: %s",PlayerAdmin[playerid],name,tmp);
 for(new i=0; i<max_players; i++) if(PlayerAdmin[i]) Message(i,msg,clYellow);
 return 1;
}

// Просмотреть статистику игрока

if(iscmd(cmd,"/check")){ restricted(1);
 getTgt("Использование: /check [игрок]");
 ShowStats(tgt,playerid);
 return 1;
}

// Забанить игрока

if(iscmd(cmd,"/ban")){ restricted(1);
 getTgt("Использование: /ban [игрок] [причина]");
 if(PlayerAdmin[playerid]<PlayerAdmin[tgt]){
  Message(playerid,"Вы не можете забанить вышестоящего администратора",clDarkRed);
  return 1;
 }
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 BanFW(tgt,tmp,pint);
 return 1;
}

// Выписать предупреждение указанному игроку

if(iscmd(cmd,"/warn")){ restricted(1);
 getTgt("Использование: /warn [игрок] {причина}");
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"Использование: /warn [игрок] {причина}");
  return 1;
 }
 if(PlayerAdmin[tgt]>=PlayerAdmin[playerid]){
  Message(playerid,"Вы не можете выписать предупреждение администратору");
  return 1;
 }
 PlayerWarns[tgt]++;
 format(msg,max_line,"%s, вы получили предупреждение от администрации: \"%s\"",GetName(tgt),tmp);
 Message(tgt,msg,clLightRed);
 if(PlayerWarns[tgt]>2){
  PlayerWarns[tgt] = 0;
  BanFW(tgt,tmp,0);
 } else {
  format(msg,max_line,"Hапоминаем, 3 предупреждения влекут за собой автоматический бан (вы имеете %i)",PlayerWarns[tgt]);
  Message(tgt,msg,clLightRed);
 }
 format(msg,max_line,"Bы успешно выписали предупреждение игроку %s (\"%s\")",GetName(tgt),tmp);
 Message(playerid,msg,clYellow);
 return 1;
}

// Кикнуть указанного игрока с сервера

if(iscmd(cmd,"/kick")){ restricted(1);
 getTgt("Использование: /kick [игрок] {причина}");
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 KickEx(tgt,tmp,1);
 return 1;
}

// Заткнуть/открыть рот указанному игроку

if(iscmd(cmd,"/mute")){ restricted(1);
 getTgt("Использование: /mute [игрок]");
 if(playerid==tgt && PlayerAdmin[playerid]<6) {
  Message(playerid,"Эту команду нельзя использовать на самом себе",clDarkRed);
  return 1;
 }
 if(PlayerAdmin[tgt]>=PlayerAdmin[playerid]){
  Message(playerid,"Вы не можете заткнуть рот администратору");
  return 1;
 }
 if(PlayerMuted[tgt]) {
  format(msg,max_line,"%s открыл рот %s",name,GetName(tgt));
  PlayerMuted[tgt] = 0;
 } else {
  format(msg,max_line,"%s заткнул рот %s",name,GetName(tgt));
  PlayerMuted[tgt] = 2;
 }
 AdminMessage(msg,clDarkRed);
 return 1;
}

// Забанить игрока на указанный срок

if(iscmd(cmd,"/banfw")){ restricted(1);
 getTgt("Использование: /ban [игрок] [срок] [причина]");
 if(PlayerAdmin[playerid]<PlayerAdmin[tgt]){
  Message(playerid,"Вы не можете забанить вышестоящего администратора",clDarkRed);
  return 1;
 }
 getStr("Использование: /ban [игрок] [срок] [причина]"); scopy(cmd,tmp);
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 BanFW(tgt,tmp,ptime(cmd),GetName(playerid));
 return 1;
}
