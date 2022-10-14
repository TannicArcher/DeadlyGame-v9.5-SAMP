#if defined _UAS_AMC_included
	#endinput
#endif
#define _UAS_AMC_included

/* UAS Anti-Money Cheats by XAOC(www.samp-rus.com) */
#define MAX_VALUE_MONEY 999999999
#define MIN_VALUE_MONEY -999999999
new PlayerMoneyVal[MAX_PLAYERS];
new Text:TextDrawMoney[MAX_PLAYERS];
new gmonstr[256],gmonstrup[256];
new strmoney[MAX_PLAYERS];
new activepanel[MAX_PLAYERS]=0;


/*
native UAS_CreateMoneySysForPlayer(playerid);
//создать анти-чит систему денег для игрока

native UAS_DeleteMoneySysForPlayer(playerid);
//Удалить анти-чит систему денег для игрока

native UAS_MoneyTextDrawShowForPlayer(playerid);
//Показать строку денег для игрока

native UAS_MoneyTextDrawHideForPlayer(playerid);
//Скрыть строку денег для игрока

native UAS_UpdateTextDrawMoney(playerid);
//Обновить данные о деньгах

native UAS_SetPlayerMoney(playerid,money);
//Установить кол-во денег игрока

native UAS_SetPlayerMoneyToAll(money);
//Задать Кол-во денег у всех

native UAS_GetValPlayerMoney(playerid);
//Узнать кол-во денег игрока, возвращает число

native UAS_GetStrPlayerMoney(playerid);
//Узнать кол-во денег игрока, возвращает строку

native UAS_GivePlayerMoney(playerid,money);
//Прибавить n кол-во денег игроку

native UAS_SendACMoneyToNormalMoney(playerid,money);
//Перенести n кол-во денег на обычный баланс

native UAS_ResetPlayerMoney(playerid);
//Обнулить деньги у игрока

native UAS_IsPlayerPanelActive(playerid);
//Проверить существует-ли панель
//Возвращает: 1 - существует, 0 - не существует.


*/



stock UAS_IsPlayerPanelActive(playerid){
if(activepanel[playerid]==1){
return 1;}
else return 0;
}




stock UAS_CreateMoneySysForPlayer(playerid){
if(activepanel[playerid]==0){
OnCreateMoneySysForPlayer(playerid);
PlayerMoneyVal[playerid]=0;
format(gmonstr, sizeof(gmonstr),"$:%d",PlayerMoneyVal[playerid]);
TextDrawMoney[playerid]=TextDrawCreate(480.0, 100.0,gmonstr);
TextDrawFont(TextDrawMoney[playerid],2);
TextDrawColor(TextDrawMoney[playerid], 0x99FF00AA);
TextDrawSetShadow(TextDrawMoney[playerid],0);
TextDrawTextSize(TextDrawMoney[playerid], 0.8, 0.4);
TextDrawSetOutline(TextDrawMoney[playerid],1);
activepanel[playerid]=1;}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_CreateMoneySysForPlayer):Panel already exists");
printf("playerid:%d Error(UAS_CreateMoneySysForPlayer):Panel already exists",playerid);

}
}

stock UAS_DeleteMoneySysForPlayer(playerid){
if(UAS_IsPlayerPanelActive(playerid)==1){
OnDeleteMoneySysForPlayer(playerid);
if(activepanel[playerid]==1){
TextDrawDestroy(TextDrawMoney[playerid]);
activepanel[playerid]=0;}
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_DeleteMoneySysForPlayer):Panel not exists");
printf("playerid:%d Error(UAS_DeleteMoneySysForPlayer):Panel not exists",playerid);
}
}

stock UAS_MoneyTextDrawShowForPlayer(playerid){
if(activepanel[playerid]==1){
OnMoneyTextDrawShowForPlayer(playerid);
TextDrawShowForPlayer(playerid,TextDrawMoney[playerid]);
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_MoneyTextDrawShowForPlayer):Panel not exists");
printf("playerid:%d Error(UAS_MoneyTextDrawShowForPlayer):Panel not exists",playerid);
}
}

stock UAS_MoneyTextDrawHideForPlayer(playerid){
if(activepanel[playerid]==1){
OnMoneyTextDrawHideForPlayer(playerid);
TextDrawHideForPlayer(playerid,TextDrawMoney[playerid]);}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_MoneyTextDrawHideForPlayer):Panel not exists");
printf("playerid:%d Error(UAS_MoneyTextDrawHideForPlayer):Panel not exists",playerid);
}
}


stock UAS_UpdateTextDrawMoney(playerid){
if(activepanel[playerid]==1){
OnUpdateTextDrawMoney(playerid);
format(gmonstrup, sizeof(gmonstrup),"$:%d",PlayerMoneyVal[playerid]);
TextDrawSetString(TextDrawMoney[playerid], gmonstrup);
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_UpdateTextDrawMoney):Panel not exists");
printf("playerid:%d Error(UAS_UpdateTextDrawMoney):Panel not exists",playerid);
}
}


stock UAS_SetPlayerMoney(playerid,money){
if(activepanel[playerid]==1){
if(money>MAX_VALUE_MONEY||money<MIN_VALUE_MONEY){
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_SetPlayerMoney):Incorrect Value,MAX=999999999,MIN=-999999999");
printf("playerid:%d Error(UAS_SetPlayerMoney):Incorrect Value,MAX=999999999,MIN=-999999999",playerid);
return 0;
}
OnSetPlayerMoney(playerid,money);
PlayerMoneyVal[playerid]=money;
UAS_UpdateTextDrawMoney(playerid);
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_SetPlayerMoney):Panel not exists");
printf("playerid:%d Error(UAS_SetPlayerMoney):Panel not exists",playerid);
}
return 1;
}

stock UAS_SetPlayerMoneyToAll(money){
if(money<MAX_VALUE_MONEY||money>MIN_VALUE_MONEY){
OnSetPlayerMoneyToAll(money);
for(new i=0;i<MAX_PLAYERS;i++){
if(IsPlayerConnected(i)){
if(activepanel[i]==1){
PlayerMoneyVal[i]=money;
UAS_UpdateTextDrawMoney(i);}}}}else{
print("Error(UAS_SetPlayerMoneyToAll):Incorrect Value,MAX=999999999,MIN=-999999999");
}
return 1;
}

stock UAS_GetValPlayerMoney(playerid){
if(activepanel[playerid]==1){
return PlayerMoneyVal[playerid];
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_GetValPlayerMoney):Panel not exists");
printf("playerid:%d Error(UAS_GetValPlayerMoney):Panel not exists",playerid);
}
return 0;
}

stock UAS_GetStrPlayerMoney(playerid){
if(activepanel[playerid]==1){
valstr(strmoney[playerid],PlayerMoneyVal[playerid]);
return strmoney[playerid];
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_GetStrPlayerMoney):Panel not exists");
printf("playerid:%d Error(UAS_GetStrPlayerMoney):Panel not exists",playerid);
}
return 0;
}

stock UAS_GivePlayerMoney(playerid,money){
if(activepanel[playerid]==1){
if(money+UAS_GetValPlayerMoney(playerid)<MAX_VALUE_MONEY||money+UAS_GetValPlayerMoney(playerid)>MIN_VALUE_MONEY){
OnGivePlayerMoney(playerid,money);
{
PlayerMoneyVal[playerid]+=money;
UAS_UpdateTextDrawMoney(playerid);
}
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_GivePlayerMoney):Panel not exists");
printf("playerid:%d Error(UAS_GivePlayerMoney):Panel not exists",playerid);
}}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_GivePlayerMoney):Incorrect Value,MAX=999999999,MIN=-999999999");
printf("playerid:%d Error(UAS_GivePlayerMoney):Incorrect Value,MAX=999999999,MIN=-999999999",playerid);
}
return 1;
}

stock UAS_ResetPlayerMoney(playerid){
if(activepanel[playerid]==1){
OnResetPlayerMoney(playerid);
UAS_SetPlayerMoney(playerid,0);
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_ResetPlayerMoney):Panel not exists");
printf("playerid:%d Error(UAS_ResetPlayerMoney):Panel not exists",playerid);
}
}

stock UAS_SendACMoneyToNormalMoney(playerid,money){
if(activepanel[playerid]==1){
if(money<=0){
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_SendACMoneyToNormalMoney):Incorrect Value");
return 0;
}
OnSendACMoneyToNormalMoney(playerid,money);
UAS_GivePlayerMoney(playerid,-money);
GivePlayerMoney(playerid,money);
}else{
SendClientMessage(playerid, 0xCC3333AA, "Error(UAS_SendACMoneyToNormalMoney):Panel not exists");
printf("playerid:%d Error(UAS_SendACMoneyToNormalMoney):Panel not exists",playerid);
}

return 1;
}
