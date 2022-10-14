/*
(c) 2008 - 2009 By BlackFoX_UD_
-=-=-=- BFX STREAM -=-=-=-
[ BETA 3.5 RELEASE ]
*/
/*
native b_CreateObject(modelid,Float:xx,Float:yy,Float:zz,Float:rxx,Float:ryy,Float:rzz,virtual_ww = -1);
native b_SetObjectRot(objectid,Float:nxr,Float:nyr,Float:nzr);
native b_MoveObject(objectid,Float:tox,Float:toy,Float:toz,Speedx);
native b_SetObjectPos(objectid,Float:val_x,Float:val_y,Float:val_z);
native b_DestroyObject(objectid);
native b_PlayerDisconnect(playerid);
native b_OnPlayerUpdate(playerid);
native b_LinkToVirtualWorld(objectid,vw_id);
*/
/*
Es kann zu Crashes kommen , bei ...

- Der Distanz Einstellung
- Maximale Zonen Objekt Anzahl

Have Fun

Mfg. BlackFoX_UD_
*/
//#include <a_samp> /* Nicht gebraucht */
#define MAX_OBJEKTE 5000
#define OBJEKTE_ERSTELLEN 1
#define DISTANZ 200.0
#define VERSIONA "v3.5 c"
#define MAX_AREA_OBJEKTE 250
new PLAYER_OBJEKTE[MAX_PLAYERS];
//------------------------------------------------------------------------------
enum objects
{
	modelu,
	Float:x_val,
	Float:y_val,
	Float:z_val,
	Float:rx_val,
	Float:ry_val,
	Float:rz_val,
	exist,
	obj_id,
	virtual_world_object,
}
new Objekte[MAX_OBJEKTE][objects];
new bool:CreatedObjekte[MAX_PLAYERS][MAX_OBJEKTE];
new CreatedID[MAX_PLAYERS][MAX_OBJEKTE];
//new Streamer;
new now_idx;
new UPDATE;
//------------------------------------------------------------------------------
stock b_CreateObject(modelid,Float:xx,Float:yy,Float:zz,Float:rxx,Float:ryy,Float:rzz,virtual_ww = -1)
{
	now_idx++;
	Objekte[now_idx][modelu] = modelid;
	Objekte[now_idx][x_val] = Float:xx;
	Objekte[now_idx][y_val] = Float:yy;
	Objekte[now_idx][z_val] = Float:zz;
	Objekte[now_idx][rx_val] = Float:rxx;
	Objekte[now_idx][ry_val] = Float:ryy;
	Objekte[now_idx][rz_val] = Float:rzz;
	Objekte[now_idx][exist] = 1;
	Objekte[now_idx][obj_id] = now_idx;
	Objekte[now_idx][virtual_world_object] = virtual_ww;
	return now_idx;
}
//------------------------------------------------------------------------------
stock b_LinkToVirtualWorld(objectid,vw_id)
{
	for(new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
		if(Objekte[objectid][exist] == 1)
		{
		    Objekte[objectid][virtual_world_object] = vw_id;
			if(CreatedObjekte[playerid][objectid] == true)
			{
		        DestroyPlayerObject(playerid,CreatedID[playerid][objectid]);
		        CreatedObjekte[playerid][objectid] = false;
			}
		}
	}
}
//------------------------------------------------------------------------------
stock b_MoveObject(objectid,Float:tox,Float:toy,Float:toz,Float:Speedx)
{
	for(new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
 		if(Objekte[objectid][exist] == 1)
   		{
  			Objekte[objectid][x_val] = Float:tox;
 			Objekte[objectid][y_val] = Float:toy;
	 		Objekte[objectid][z_val] = Float:toz;
    		if(CreatedObjekte[playerid][objectid] == true)
     		{
		 		MovePlayerObject(playerid,CreatedID[playerid][objectid],tox,toy,toz,Speedx);
     		}
   		}
	}
}
//------------------------------------------------------------------------------
stock b_SetObjectRot(objectid,Float:nxr,Float:nyr,Float:nzr)
{
	for(new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
 		if(Objekte[objectid][exist] == 1)
   		{
  			Objekte[objectid][rx_val] = Float:nxr;
 			Objekte[objectid][ry_val] = Float:nyr;
 			Objekte[objectid][rz_val] = Float:nzr;
    		if(CreatedObjekte[playerid][objectid] == true)
     		{
     			SetPlayerObjectRot(playerid,CreatedID[playerid][objectid],nxr,nyr,nzr);
     		}
   		}
	}
}
stock b_PlayerDisconnect(playerid)
{
	for(new oxt = 0;oxt<now_idx;oxt++)
	{
		if(CreatedObjekte[playerid][oxt] == true)
		{
			CreatedID[playerid][oxt] = -1;
			CreatedObjekte[playerid][oxt] = false;
		}
		else
		{
		    DestroyPlayerObject(playerid,CreatedID[playerid][oxt]);
			CreatedID[playerid][oxt] = -1;
			CreatedObjekte[playerid][oxt] = false;
		}
	}
	PLAYER_OBJEKTE[playerid] = 0;
}
//------------------------------------------------------------------------------
stock b_SetObjectPos(objectid,Float:val_x,Float:val_y,Float:val_z)
{
	for(new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
 		if(Objekte[objectid][exist] == 1)
   		{
  			Objekte[objectid][x_val] = Float:val_x;
 			Objekte[objectid][y_val] = Float:val_y;
 			Objekte[objectid][z_val] = Float:val_z;
    		if(CreatedObjekte[playerid][objectid] == true)
     		{
     			SetPlayerObjectPos(playerid,CreatedID[playerid][objectid],val_x,val_y,val_z);
     		}
   		}
	}
}
//------------------------------------------------------------------------------
stock b_DestroyObject(objectid)
{
	for(new playerid = 0;playerid<MAX_PLAYERS;playerid++)
	{
 		if(Objekte[objectid][exist] == 1)
   		{
   		    Objekte[objectid][exist] = 0;
    		if(CreatedObjekte[playerid][objectid] == true)
     		{
     			DestroyPlayerObject(playerid,CreatedID[playerid][objectid]);
                CreatedObjekte[playerid][objectid] = false;
     		}
   		}
	}
}
//------------------------------------------------------------------------------
forward ObjektStream(playerid);
public ObjektStream(playerid)
{
	/*for(new playerid = 0;playerid<GetMaxPlayers();playerid++)
	{*/
		for(new o = 0;o<now_idx;o++)
		{
		    if(IsPlayerConnected(playerid))
		    {
					if(IsPlayerInRangeOfPoint(playerid,DISTANZ,Objekte[o][x_val],Objekte[o][y_val],Objekte[o][z_val]))
   					{
						if(PLAYER_OBJEKTE[playerid] < MAX_AREA_OBJEKTE)
						{
      						if(Objekte[o][exist] == 1)
      						{
      						    if(Objekte[o][virtual_world_object]!=-1)
      						    {
      						        if(GetPlayerVirtualWorld(playerid) == Objekte[o][virtual_world_object])
      						        {
        								if(CreatedObjekte[playerid][o] == false)
		        						{
												CreatedID[playerid][o] = CreatePlayerObject(playerid,Objekte[o][modelu],Objekte[o][x_val],Objekte[o][y_val],Objekte[o][z_val],Objekte[o][rx_val],Objekte[o][ry_val],Objekte[o][rz_val]);
												CreatedObjekte[playerid][o] = true;
												PLAYER_OBJEKTE[playerid]++;
	        							}
	        						}
	        					}
	        					else if(Objekte[o][virtual_world_object] == -1)
	        					{
       								if(CreatedObjekte[playerid][o] == false)
		        					{
											CreatedID[playerid][o] = CreatePlayerObject(playerid,Objekte[o][modelu],Objekte[o][x_val],Objekte[o][y_val],Objekte[o][z_val],Objekte[o][rx_val],Objekte[o][ry_val],Objekte[o][rz_val]);
											CreatedObjekte[playerid][o] = true;
											PLAYER_OBJEKTE[playerid]++;
	        						}
	        					}
     						}
     					}
		    		}
		    		else
	    			{
						if(Objekte[o][exist] == 1)
    					{
  							if(CreatedObjekte[playerid][o] == true)
    						{
								if(CreatedID[playerid][o] !=INVALID_OBJECT_ID)
								{
									CreatedObjekte[playerid][o] = false;
									DestroyPlayerObject(playerid,CreatedID[playerid][o]);
									CreatedID[playerid][o] = -1;
									PLAYER_OBJEKTE[playerid]--;
								}
    						}
       					}
		    		}
		    }
		}

	//}
 		return 1;
}
//------------------------------------------------------------------------------
/*forward FreierSlot();
public FreierSlot()
{
new freeS = 0;
for(new i = 0;i<MAX_OBJEKTE;i++)
{
	if(freeS == 0)
	{
		if(Objekte[i][exist] == 0)
		{
		freeS = i;
		}
	}
}
return freeS;
}*/
//------------------------------------------------------------------------------
stock ProzentWert(const Anteil,const Grundwert)return Anteil*100/Grundwert;
//------------------------------------------------------------------------------
stock b_OnPlayerUpdate(playerid)
{
    UPDATE++;
	if(UPDATE == OBJEKTE_ERSTELLEN)
	{
	    if(IsPlayerConnected(playerid))
	    {
			ObjektStream(playerid);
			UPDATE = (2+2-4+8/2-4);
		}
	}
}
//------------------------------------------------------------------------------
