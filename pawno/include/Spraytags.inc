

/*
native CreateSprayTag(spraytag, Float:X, Float:Y, Float:Z, Float:A);
native GetSprayModel(sprayid);
native GetSprayPos(sprayid, &Float:X, &Float:Y, &Float:Z, &Float:A);
native SetPlayerSprayTag(playerid, spraytag);
native GetPlayerSprayTag(playerid);
native GetPlayerSprayedSprayTags(playerid);
native HasPlayerSprayedSprayTag(playerid, sprayid)
native Spray_OnPlayerConnect(playerid);
*/



#define MAX_SPRAYS 100
#define MAX_DISTANCE 3

enum SpInfo {
	Float:sX, 
	Float:sY, 
	Float:sZ, 
	Float:sA, 
	Float:sModel
};

new SprayInfo[MAX_SPRAYS][SpInfo];

enum PlSpray {
	pSpraytag,
	pSprays
}

new PlayerSpray[MAX_PLAYERS][PlSpray];
new PlayerSprayed[MAX_PLAYERS][MAX_SPRAYS];

new Sprays=-1;

#define SPRAY_GROVE       1528
#define SPRAY_BALLAS      1529
#define SPRAY_VAGOS       1530
#define SPRAY_AZTECAS     1531

forward SprayTimer();
forward OnPlayerSpraySprayTag(playerid, sprayid);
forward OnPlayerSprayedAllSprayTags(playerid);


stock CreateSprayTag(spraytag, Float:X, Float:Y, Float:Z, Float:A)
{
	if(Sprays == -1)
	{
		SetTimer("SprayTimer", 200, 1);
	}
	if(Sprays == MAX_SPRAYS-1) return 0;
	Sprays++;
	CreateObject(spraytag, X, Y, Z, 0, 0, A);
	SprayInfo[Sprays][sX]=X;
	SprayInfo[Sprays][sY]=Y;
	SprayInfo[Sprays][sZ]=Z;
	SprayInfo[Sprays][sA]=A;
	SprayInfo[Sprays][sModel]=spraytag;
	return Sprays;
}

stock GetSprayModel(sprayid) return SprayInfo[sprayid][sModel];
stock GetSprayPos(sprayid, &Float:X, &Float:Y, &Float:Z, &Float:A)
{
	X=SprayInfo[sprayid][sX];
	Y=SprayInfo[sprayid][sY];
	Z=SprayInfo[sprayid][sZ];
	A=SprayInfo[sprayid][sA];
}

stock SetPlayerSprayTag(playerid, spraytag)
{
	PlayerSpray[playerid][pSpraytag]=spraytag;
}

stock GetPlayerSprayTag(playerid) return PlayerSpray[playerid][pSpraytag];
stock GetPlayerSprayedSprayTags(playerid) return PlayerSpray[playerid][pSprays];

stock HasPlayerSprayedSprayTag(playerid, sprayid)
{
	if(PlayerSprayed[playerid][spraytag] != 1) return 0;
	return 1;
}

stock Spray_OnPlayerConnect(playerid)
{
	PlayerSpray[playerid][pSpraytag]=SPRAY_GROVE;
	for(new a=0; a<MAX_SPRAYS; a++)
	{
		PlayerSprayed[playerid][a]=0;
	}
	PlayerSpray[playerid][pSprays]=0;
}

public SprayTimer()
{
	new keys, updown, leftright, Float:Xn, Float:Yn, string[256];
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerKeys(i, keys, updown, leftright);
			for(new a=0; a<MAX_SPRAYS; a++)
			{
				if((GetDisToPointInfrontOfSprayTag(i, a) < MAX_DISTANCE))
				{
					if(LooksPlayerToSprayTag(i, a))
					{
						if(GetPlayerWeapon(i) == 41) 
						{
							if(keys == KEY_FIRE) 
							{
								if(PlayerSprayed[i][a] != 1)
								{
									GetXYInFrontOfSprayTag(a, Xn, Yn, 0.05);
									CreatePlayerObject(i, PlayerSpray[i][pSpraytag], Xn, Yn, SprayInfo[a][sZ], 0, 0, SprayInfo[a][sA]);
									PlayerSprayed[i][a]=1;
									PlayerSpray[i][pSprays]++;
									format(string, 256, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~%d~g~/~y~%d", PlayerSpray[i][pSprays], Sprays+1);
									GameTextForPlayer(i, string, 2000, 3);
									PlayerPlaySound(i, 1057, 0, 0, 0);
									OnPlayerSpraySprayTag(i, a);
									if(PlayerSpray[i][pSprays] == Sprays+1)
									{
										OnPlayerSprayedAllSprayTags(i);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

stock GetXYInFrontOfSprayTag(sprayid, &Float:gX, &Float:gY, Float:distance)
{
	gX = SprayInfo[sprayid][sX] + (distance * floatsin(-(SprayInfo[sprayid][sA]+90), degrees));
	gY = SprayInfo[sprayid][sY] + (distance * floatcos(-(SprayInfo[sprayid][sA]+90), degrees));
}

stock GetAllowedFacingAngle(sprayid, &Float:minA, &Float:maxA)
{
	minA = ((SprayInfo[sprayid][sA]-90)-30);
	maxA = ((SprayInfo[sprayid][sA]-90)+30);
}

stock LooksPlayerToSprayTag(playerid, sprayid)
{
	new Float:A, Float:A1, Float:A2;
	GetPlayerFacingAngle(playerid, A);
	GetAllowedFacingAngle(sprayid, A1, A2);
	if((A >= A1 && A <= A2) || (A+360 >= A1 && A+360 <= A2) || (A-360 >= A1 && A-360 <= A2)) return 1;
	return 0;
}

stock GetDisToPointInfrontOfSprayTag(playerid, sprayid)
{
	new Float:x1,Float:y1,Float:z1, Float:x2, Float:y2;
	GetPlayerPos(playerid, x1, y1, z1);
	GetXYInFrontOfSprayTag(sprayid, x2, y2, MAX_DISTANCE);
	return floatround(floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)));
}
