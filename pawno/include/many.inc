/*
 *      Easy Money Anticheat by KapaT
 */

#if defined _maccer_anticheat_included
  #endinput
#endif
#define _maccer_anticheat_included

#define	MAX_MONEY_ADDS_IGNORE	(99)
#define	MAX_MONEY_ADDS			(1000)
#define	UPDATE_INTERVAL			(5000)
#define	CHEATERS_LOG_FILE		"cheaters.log"
#define	MAX_STRING				(256)

new PlayerMoney[MAX_PLAYERS];
new anticheattimerid;

forward PlayersMoneyUpdate();
AnticheatInitialize(){
	anticheattimerid = SetTimer("PlayersMoneyUpdate", UPDATE_INTERVAL, 1);
}
AnticheatUnInitialize(){
	KillTimer(anticheattimerid);
}

/*GetMoney(playerid){
	return PlayerMoney[playerid];
}*/
#define GetMoney(%1) PlayerMoney[%1]

GiveMoney(playerid, money){
	PlayerMoney[playerid] += money;
	GivePlayerMoney(playerid,PlayerMoney[playerid]-GetPlayerMoney(playerid));
}
ResetMoney(playerid){
	PlayerMoney[playerid] = 0;
	ResetPlayerMoney(playerid);
}
CheateLog(playerid, startmoney, endmoney, isdeleted)
{
	new CheatLog[MAX_STRING];
	new PlName[MAX_PLAYER_NAME];
	new IpStr[16];
	GetPlayerName(playerid, PlName, sizeof(PlName));
	GetPlayerIp(playerid, IpStr, sizeof(IpStr));
	format(CheatLog, sizeof(CheatLog), " %s[%d](%s): было %d стало %d (+$%d)",
	PlName, playerid, IpStr, startmoney, endmoney, endmoney-startmoney);
	if(isdeleted) format(CheatLog, sizeof(CheatLog), "%s <=", CheatLog);
	for(new i=0;i<MAX_PLAYERS;i++)	if(IsPlayerAdmin(i))	SendClientMessage(i, 0xFFFF00AA, CheatLog);
	format(CheatLog, sizeof(CheatLog), "%s\n", CheatLog);
	new File:file=fopen(CHEATERS_LOG_FILE, io_append);
	fwrite(file, CheatLog);
	fclose(file);
}
UpdateGameMoney(playerid){
	new gamemoney = GetPlayerMoney(playerid);
	if(gamemoney < PlayerMoney[playerid])
	{
	    PlayerMoney[playerid] = gamemoney;
	    return;
	}
	if(gamemoney > PlayerMoney[playerid])
	{
	    if( gamemoney-PlayerMoney[playerid] < MAX_MONEY_ADDS_IGNORE ){
	        return;
	    }
	    if(gamemoney - PlayerMoney[playerid] > MAX_MONEY_ADDS){
	        CheateLog(playerid, PlayerMoney[playerid], gamemoney, 1);
	        GivePlayerMoney(playerid, PlayerMoney[playerid] - gamemoney);
	    }
	    else{
	        CheateLog(playerid, PlayerMoney[playerid], gamemoney, 0);
	        PlayerMoney[playerid] = gamemoney;
	    }
	}
}
public PlayersMoneyUpdate(){
	for(new i=0;i<MAX_PLAYERS;i++){
	    if(IsPlayerConnected(i)){
			UpdateGameMoney(i);
	    }
	}
}

#define GetPlayerMoney(%1) (GetMoney(%1))
#define GivePlayerMoney(%1,%2) (GiveMoney(%1,%2))
#define ResetPlayerMoney(%1) (ResetMoney(%1))

