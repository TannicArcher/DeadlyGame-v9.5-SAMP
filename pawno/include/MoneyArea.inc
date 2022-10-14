/*
This MoneyArea-include is made by =>Sandra<= on the 12th of March 2008
Do not remove any credits!
*/

#include <a_samp>

#define MAX_MONEY_AREAS 10

/*
native AddMoneyArea(AreaID, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY, earnings, frequency);
native UseMoneyArea(areaID, toggle);
native UseAllMoneyAreas(toggle);
native ShowMoneyAreasAsGangZones(toggle);
native GetPlayerArea(playerid);
*/

enum ainfo
{
	IsEnabled,
	Float:areaminX,
	Float:areamaxX,
	Float:areaminY,
	Float:areamaxY,
	areaearnings,
	areafrequency,
	gangzone
};

new AreaInfo[MAX_MONEY_AREAS][ainfo];
new GlobalCount[MAX_MONEY_AREAS];
new AreasCount;

stock AddMoneyArea(AreaID, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY, earnings, frequency)
{
	if(AreasCount == 0)
	{
	    SetTimer("MoneyAreaPayout", 1000, 1);
	}
	AreasCount++;
	AreaInfo[AreaID][IsEnabled] = 1;
	AreaInfo[AreaID][areaminX] = MinX;
	AreaInfo[AreaID][areamaxX] = MaxX;
	AreaInfo[AreaID][areaminY] = MinY;
	AreaInfo[AreaID][areamaxY] = MaxY;
	AreaInfo[AreaID][areaearnings] = earnings;
	AreaInfo[AreaID][areafrequency] = frequency;
}

stock UseMoneyArea(areaID, toggle)
{
	switch(toggle)
	{
	    case 0: {AreaInfo[areaID][IsEnabled] = 0;}
		case 1: {AreaInfo[areaID][IsEnabled] = 1;}
	}
}
stock UseAllMoneyAreas(toggle)
{
	for(new a; a<MAX_MONEY_AREAS; a++)
	{
		switch(toggle)
		{
		    case 0: {AreaInfo[a][IsEnabled] = 0;}
			case 1: {AreaInfo[a][IsEnabled] = 1;}
		}
	}
}

stock ShowMoneyAreasAsGangZones(toggle)
{
	for(new a; a<MAX_MONEY_AREAS; a++)
	{
	    if(AreaInfo[a][IsEnabled])
	    {
	        if(toggle == 1)
	        {
				GangZoneDestroy(AreaInfo[a][gangzone]);
	        	AreaInfo[a][gangzone] = GangZoneCreate(AreaInfo[a][areaminX], AreaInfo[a][areaminY], AreaInfo[a][areamaxX], AreaInfo[a][areamaxY]);
	        	GangZoneShowForAll(AreaInfo[a][gangzone], 0x00FF00AA);
			}
			else if(toggle == 0)
			{
				GangZoneDestroy(AreaInfo[a][gangzone]);
			}
		}
	}
}

stock GetPlayerArea(playerid)
{
	for(new a; a<MAX_MONEY_AREAS; a++)
	{
	    if(AreaInfo[a][IsEnabled])
	    {
	    	if(IsPlayerInArea(playerid, AreaInfo[a][areaminX], AreaInfo[a][areamaxX], AreaInfo[a][areaminY], AreaInfo[a][areamaxY]))
      		{
	        	return a;
			}
		}
	}
	return -1;
}

forward IsPlayerInArea(playerID, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY);
public IsPlayerInArea(playerID, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY)
{
	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerID, X, Y, Z);
	if(X >= MinX && X <= MaxX&& Y >= MinY && Y <= MaxY)
	{
		return 1;
	}
	return 0;
}

forward MoneyAreaPayout();
public MoneyAreaPayout()
{
	for(new a; a<MAX_MONEY_AREAS; a++)
	{
	    if(AreaInfo[a][IsEnabled])
	    {
	        GlobalCount[a]++;
	        if(GlobalCount[a] == AreaInfo[a][areafrequency])
	        {
	            GlobalCount[a] = 0;
	            for(new i; i<MAX_PLAYERS; i++)
	            {
	                if(IsPlayerConnected(i))
	                {
	                    if(IsPlayerInArea(i, AreaInfo[a][areaminX], AreaInfo[a][areamaxX], AreaInfo[a][areaminY], AreaInfo[a][areamaxY]))
	                    {
	                        GivePlayerMoney(i, AreaInfo[a][areaearnings]);
						}
					}
				}
			}
		}
	}
}
	                
	            