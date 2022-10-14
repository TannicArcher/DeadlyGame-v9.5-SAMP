
	/*----------------------------------------------|
	|												|
	|	* IsraelPawnoTeam money include        		|
	|	                                    		|
	|	* This include add money foncations			|
	|												|
	|	* (c) Copyright 2007, by Amit_B          	|
	|												|
	|	* GTA.Vgames.co.il                     		|
	|												|
	-----------------------------------------------*/

#if defined _money_included
  #endinput
#endif

#define _money_included
#pragma library money

#include <a_samp>

forward CheckMaxMoney(maximum);
forward GiveMoneyToPlayerInArea(playerid,Float:X1,Float:Y1,Float:X2,Float:Y2,money);
forward GiveMoneyToAllInArea(Float:X1,Float:Y1,Float:X2,Float:Y2,money);

new MoneyPickup,MoneySackPickup;

/*
	New Functions:
	
	native GiveMoney(playerid,money);
	native SetMoney(playerid,money);
	native GetMoney(playerid);
	native RemoveMoney(playerid,money);
	native ResetMoney(playerid);
	native MultiplyMoney(playerid,money);
	native DividedMoney(playerid,money);
	native GiveAllMoney(money);
	native SetAllMoney(money);
	native RemoveAllMoney(playerid,money);
	native ResetAllMoney();
	native MultiplyAllMoney(playerid,money);
	native DividedAllMoney(playerid,money);
	native SetMaxMoney(maxmoney);
	native CreateMoneyPickup(Float:X,Float:Y,Float:Z);
	native CreateMoneySackPickup(Float:X,Float:Y,Float:Z);
	native DestroyAllMoneyPickup();
	native DestroyAllMoneySackPickup();
	native CreateMoneyAreaForPlayer(playerid,second,Float:X1,Float:Y1,Float:X2,Float:Y2,money);
	native CreateMoneyAreaForAll(Float:X1,Float:Y1,Float:X2,Float:Y2,money);
	native IsPlayerMoney(playerid,money);
*/

stock GiveMoney(playerid,money)
{
	GivePlayerMoney(playerid,money);
}

stock SetMoney(playerid,money)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,money);
}

stock GetMoney(playerid)
{
	GetPlayerMoney(playerid);
}

stock RemoveMoney(playerid,money)
{
	GivePlayerMoney(GetPlayerMoney(playerid)-money);
}

stock ResetMoney(playerid)
{
	ResetPlayerMoney(playerid);
}

stock MultiplyMoney(playerid,money)
{
	GivePlayerMoney(GetPlayerMoney(playerid)*money);
}

stock DividedMoney(playerid,money)
{
	GivePlayerMoney(GetPlayerMoney(playerid)/money);
}

stock GiveAllMoney(money)
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
		if(IsPlayerConnected(all))
		{
			GivePlayerMoney(all,money);
		}
	}
}

stock SetAllMoney(money)
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
		if(IsPlayerConnected(all))
		{
			ResetPlayerMoney(all);
			GivePlayerMoney(all,money);
		}
	}
}

stock RemoveAllMoney(money)
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
		if(IsPlayerConnected(all))
		{
			GivePlayerMoney(GetPlayerMoney(all)-money);
		}
	}
}

stock ResetAllMoney()
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
		if(IsPlayerConnected(all))
		{
			ResetPlayerMoney(all);
		}
	}
}

stock MultiplyAllMoney(money)
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
		if(IsPlayerConnected(all))
		{
			GivePlayerMoney(GetPlayerMoney(all)*money);
		}
	}
}

stock DividedAllMoney(money)
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
		if(IsPlayerConnected(all))
		{
			GivePlayerMoney(GetPlayerMoney(all)/money);
		}
	}
}

stock SetMaxMoney(maxmoney)
{
	SetTimerEx("CheckMaxMoney",1000,1,"d",maxmoney);
}

stock CreateMoneyPickup(Float:X,Float:Y,Float:Z)
{
	MoneyPickup=CreatePickup(1212,15,X,Y,Z);
}

stock CreateMoneySackPickup(Float:X,Float:Y,Float:Z)
{
	MoneySackPickup=CreatePickup(1550,15,X,Y,Z);
}

stock DestroyAllMoneyPickup()
{
	DestroyPickup(MoneyPickup);
}

stock DestroyAllMoneySackPickup()
{
	DestroyPickup(MoneySackPickup);
}

stock CreateMoneyAreaForPlayer(playerid,second,Float:X1,Float:Y1,Float:X2,Float:Y2,money)
{
	SetTimerEx("GiveMoneyToPlayerInArea",second*1000,1,"dddddd",playerid,X1,Y1,X2,Y2,money);
}

stock CreateMoneyAreaForAll(second,Float:X1,Float:Y1,Float:X2,Float:Y2,money)
{
	SetTimerEx("GiveMoneyToAllInArea",second*1000,1,"dddddd",playerid,X1,Y1,X2,Y2,money);
}

stock IsPlayerMoney(playerid,money)
{
	if(GetPlayerMoney(playerid)==money)
	{
	    return 1;
	}
	return 0;
}

public CheckMaxMoney(maximum)
{
	for(new i=0;i<=MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(GetPlayerMoney(i)>maximum)
	        {
	            new string[256],name[MAX_PLAYER_NAME];
	            GetPlayerName(i,name,sizeof(name));
	            format(string,sizeof(string),"%s has been kicked. (reason: %d money, maximum: %d$)",name,GetPlayerMoney(i),maximum);
	            SendClientMessageToAll(0xAA3333AA,string);
	            Kick(i);
	        }
	    }
	}
	return 1;
}

public GiveMoneyToPlayerInArea(playerid,Float:X1,Float:Y1,Float:X2,Float:Y2,money)
{
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	if(X >= X1 && X <= X2 && Y >= Y1 && Y <= Y2)
	{
	    GivePlayerMoney(playerid,money);
	}
}

public GiveMoneyToAllInArea(Float:X1,Float:Y1,Float:X2,Float:Y2,money)
{
	for(new all=0;all<=MAX_PLAYERS;all++)
	{
	    if(IsPlayerConnected(all))
	    {
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(all,X,Y,Z);
			if(X >= X1 && X <= X2 && Y >= Y1 && Y <= Y2)
			{
			    GivePlayerMoney(all,money);
			}
		}
	}
}
