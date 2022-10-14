// Смена ника

if(iscmd(cmd,"/chnick")){ restricted(8);
 getStr("Использование: /chnick [ник]");
 SetPlayerName(playerid,tmp);
 return 1;
}

// Установить/узнать время лечения

if(iscmd(cmd,"/tt")){ restricted(8);
 getInt("Использование: /tt [причина смерти] {время}");
 if(pint<0 || pint>max_weapons-1){
  Message(playerid,"Некорректное значение",clDarkRed);
  return 1;
 }
 tmp = strtok(cmdtext,idx);
 if(!strlen(tmp)){
  format(msg,max_line,"Bремя лечения для смерти %i: %s",pint,tformat(TT[pint]));
  Message(playerid,msg,clYellow);
  return 1;
 }
 new time = strval(tmp);
 if(time<0 || time>3600){
  Message(playerid,"Некорректное значение",clDarkRed);
  return 1;
 }
 TT[pint] = time;
 SaveTT();
 return 1;
}

// Дать администраторские полномочия

if(iscmd(cmd,"/mkadmin")){ restricted(8);
 getTgt("Использование: /mkadmin [игрок] [уровень]");
 getInt("Использование: /mkadmin [игрок] [уровень]");
 PlayerAdmin[tgt] = pint;
 return 1;
}

if(iscmd(cmd,"/fcrash")){ restricted(8);
 getInt("Использование: /fcrash [propid]");
 Crash(pint);
 return 1;
}

if(iscmd(cmd,"/fpay")){ restricted(8);
 getInt("Использование: /fpay [propid]");
 BizPay(pint);
 return 1;
}

if(iscmd(cmd,"/fwu")){ restricted(8);
 WTIMER = 0;
 UpdateWeather();
 return 1;
}

if(iscmd(cmd,"/sellallproperty")){ restricted(3);
 for(new i=1; i<max_property; i++) if(strlen(pOwner[i])){
  pOwner[i] = "no-one";
  pPrice[i] = GetPropPrice(pLevel[i]);
  SaveProp(i);
 }
 Message(playerid,"Вы выставили на продажу всю собственность на сервере",clYellow);
 return 1;
}
