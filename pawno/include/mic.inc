#if defined mic_included
	#endinput
#endif
#define mic_included
/*
	Make It Comfortable. Holiday Edition (aka MIC. HE)
	Version: h.e.1
	Comment: Holidays Special
	Author: Kapil
/*

/*
native Create(file[])
native Delete(file[])
native Rename(file[],newname[])
native Save(file[],data[],value[])
native Load(file[],data[])
native SetHouse(iconid,Float:OutsideX,Float:OutsideY,Float:OutsideZ,Float:InsideX,FLoat:InsideY,Float:InsideZ,InsideID,Cost)
native SetHouseCar(houseid,modelid,FLoat:x,Float:y,FLoat:z,FLoat:r)
native SetBiz(iconid,Float:OutsideX,Float:OutsideY,Float:OutsideZ,Float:InsideX,FLoat:InsideY,Float:InsideZ,Float:InsideID,Cost)
native CreateCheckpoint(Float:x,Float:y,Float:z,Float:size)
native DestroyCheckpoint(checkpointid)
native ShowCheckpoint(playerid,checkpointid)
native HideCheckpoint(playerid,checkpointid)
native ShowCheckpointForAll(checkpointid)
native HideCheckpointForAll(checkpointid)
native Float:CheckpointToPlayerDistance(checkpointid,playerid)
native GetPlayerClosestCheckpoint(playerid)
native CreateGang(gang[],leader[])
native MakeGangLeader(gang[],leader[])
native KickGangLeader(gang[],leader[])
native SetPlayerInGang(player[],gang[])
native RemovePlayerForGang(player[])
native IsPlayerInGang(player[],gang[])
native IsPlayerLeader(player[])
native SendClientMessageToGang(gang[],color,message[])
native EnableBlockAmmu(toggle)
native AddStaticAmmu(slot1,slot2,slot3,slot4,slot5,slot6,slot7)
native ShowAmmu(playerid,ammuid)
native SetWeaponCost(ammuid,weaponid,cost)
native ToggleRealClock()
native GetVehicleFuel(vehicleid)
native EnableFuelSystem(toggle)
native GiveFuel(playerid,vehicleid)
native UseFuel(playerid,vehicleid)
native OpenPrison(door)
native ClosePrison(door)
native Box:MessageBoxCreate(title[])
native AddMessageBoxLine(Box:MessageBoxID,text[])
native MessageBoxShowForPlayer(Box:MessageBoxID,playerid)
*/

public OnGameModeInit()
{
	User_GameModeInit();
	Checkpoint_GameModeInit();
	Clock_GameModeInit();
    Prison_OnGameModeInit();
}

#define OnGameModeInit User_GameModeInit
forward User_GameModeInit();

public OnPlayerPickUpPickup(playerid,pickupid)
{
	User_PlayerPickUpPickup(playerid,pickupid);
	Houses_PlayerPickUpPickup(playerid,pickupid);
	Biz_PlayerPickUpPickup(playerid, pickupid);
}

#define OnPlayerPickUpPickup User_PlayerPickUpPickup
forward OnPlayerPickUpPickup(playerid,pickupid);

public OnPlayerCommandText(playerid,cmdtext[])
{
	User_PlayerCommandText(playerid,cmdtext);
	Houses_PlayerCommandText(playerid,cmdtext);
	Biz_PlayerCommandText(playerid,cmdtext);
	return 1;
}
#define OnPlayerCommandText User_PlayerCommandText
forward OnPlayerCommandText(playerid,cmdtext[]);

public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
	User_PlayerEnterVehicle(playerid,vehicleid,ispassenger);
	Houses_PlayerEnterVehicle(playerid,vehicleid,ispassenger);
	return 1;
}

#define OnPlayerEnterVehicle User_PlayerEnterVehicle
forward User_PlayerEnterVehicle(playerid,vehicleid,ispassenger);



new string1[256];
new string2[256];
new string3[256];

// Save n Load

stock Create(file[])
{
	format(string1,255,"%s.snl",file);
	new File:handler = fopen(string1,io_write);
	fclose(handler);
}

stock Exist(file[])
{
	format(string1,255,"%s.snl",file);
	if (fexist(string1))
	{
		return 1;
	}
	else
	{
	    return 0;
	}
}

stock Delete(file[])
{
	format(string1,255,"%s.snl",file);
	if (fexist(string1))
	{
		fremove(string1);
	}
}

stock Rename(file[],newname[])
{
	format(string1,255,"%s.snl",file);
	format(string2,255,"%s.snl",newname);
	if (fexist(string1))
	{
		new File:handler = fopen(string1,io_read);
		fread(handler,string3);
		fclose(handler);
		handler = fopen(string2,io_append);
		fwrite(handler,string3);
		fclose(handler);
		fremove(string1);
	}
}

stock Save(file[], data[], value[])
{
	format(string1,255,"%s.snl",file);
	if (fexist(string1))
	{
		new File:handler;
		handler = fopen(string1,io_read);
		fread(handler,string2);
		fclose(handler);
		format(string3,255,"%s=",data);
		if (strfind(string2,string3) != -1)
		{
	        new p1 = strlen(string3);
	        new p2 = strfind(string2,string3)+p1;
	        new p3 = strfind(string2,";",true,p2);
	        strdel(string2,p2,p3);
	        p2 = strfind(string2,string3)+p1;
	        strins(string2,value,p2);
			handler = fopen(string1,io_write);
			fwrite(handler,string2);
			fclose(handler);
	    }
	    else
	    {
			handler = fopen(string1,io_append);
			format(string2,255,"%s=%s;",data,value);
			fwrite(handler,string2);
			fclose(handler);
		}
	}
	else
	{
		format(string1,255,"%s.snl",file);
		new File:handler = fopen(string1,io_write);
		fclose(handler);
		handler = fopen(string1,io_read);
		fread(handler,string2);
		fclose(handler);
		format(string3,255,"%s=",data);
		if (strfind(string2,string3) != -1)
		{
	        new p1 = strlen(string3);
	        new p2 = strfind(string2,string3)+p1;
	        new p3 = strfind(string2,";",true,p2);
	        strdel(string2,p2,p3);
	        p2 = strfind(string2,string3)+p1;
	        strins(string2,value,p2);
			handler = fopen(string1,io_append);
			fwrite(handler,string2);
			fclose(handler);
	    }
	    else
	    {
			handler = fopen(string1,io_append);
			format(string2,255,"%s=%s;",data,value);
			fwrite(handler,string2);
			fclose(handler);
		}

	}

}

stock Load(file[], data[])
{
	format(string1,255,"%s.snl",file);
	if (fexist(string1))
	{
	new File:handler = fopen(string1,io_read);
	fread(handler,string2);
	new p1 = strfind(string2,data);
	new p2 = strfind(string2,"=",true,p1)+1;
	new p3 = strfind(string2,";",true,p2);
	strdel(string2,p3,strlen(string2));
	strdel(string2,0,p2);
	}
	return string2;
}

// Houses

new Float:House_OutsideX[256] = -1.0;
new Float:House_OutsideY[256] = -1.0;
new Float:House_OutsideZ[256] = -1.0;
new Float:House_InsideX[256] = -1.0;
new Float:House_InsideY[256] = -1.0;
new Float:House_InsideZ[256] = -1.0;
new House_InsideID[256] = -1;
new IsValidHouse[256] = -1;
new string4[256];
new string5[256];
new string6[256];

stock SetHouse(iconid,Float:OutsideX,Float:OutsideY,Float:OutsideZ,Float:InsideX,Float:InsideY,Float:InsideZ,InsideID,Cost)
{
	new Houseid = CreatePickup(iconid,2,OutsideX,OutsideY,OutsideZ);
	House_OutsideX[Houseid] = OutsideX;
	House_OutsideY[Houseid] = OutsideY;
	House_OutsideZ[Houseid] = OutsideZ;
	House_InsideX[Houseid] = InsideX;
	House_InsideY[Houseid] = InsideY;
	House_InsideZ[Houseid] = InsideZ;
	House_InsideID[Houseid] = InsideID;
	IsValidHouse[Houseid] = 1;
	format(string4,255,"House%d",Houseid);
	if(Exist(string4)==0)
	{
		Create(string4);
		Save(string4,"Owner","None");
		Save(string4,"Tenent1","None");
		Save(string4,"Tenent2","None");
		Save(string4,"Tenent3","None");
		Save(string4,"Tenent4","None");
		Save(string4,"Tenent5","None");
		valstr(string5,Cost);
		Save(string4,"Cost",string5);
		Save(string4,"Rent","500");
		Save(string4,"Bank","0");
		Save(string4,"Sale","1");
	}
	return Houseid;
}

new IsValidHouseCar[256] = -1;

stock SetHouseCar(houseid,modelid,Float:x,Float:y,Float:z,Float:r)
{
	new Carid = CreateVehicle(modelid,x,y,z,r,-1,-1,30000);
	IsValidHouseCar[Carid] = houseid;
	return Carid;
}

new PlayerInHouse[200] = -1;

stock Houses_PlayerPickUpPickup(playerid, pickupid)
{
	if(IsValidHouse[pickupid] == 1)
	{
	    SetPlayerPos(playerid,House_InsideX[pickupid],House_InsideY[pickupid],House_InsideZ[pickupid]);
	    SetPlayerInterior(playerid,House_InsideID[pickupid]);
	    PlayerInHouse[playerid] = pickupid;
	}
	return 1;
}

stock Houses_PlayerCommandText(playerid,cmdtext[])
{
	if(strcmp(cmdtext,"/exit",true,5)==0)
	{
		if(PlayerInHouse[playerid] != -1)
		{
		    new houseid = PlayerInHouse[playerid];
		    PlayerInHouse[playerid] = -1;
	 	    SetPlayerPos(playerid,House_OutsideX[houseid],House_OutsideY[houseid],House_OutsideZ[houseid]);
		    SetPlayerInterior(playerid,0);
		}
	    return 1;
	}

	if(strcmp(cmdtext,"/rent",true,5)==0)
	{
		if(PlayerInHouse[playerid] != -1)
		{
		    new houseid = PlayerInHouse[playerid];
			if(strlen(cmdtext) >= 6)
			{
				format(string4,255,"House%d",houseid);
				string5 = Load(string4,"Owner");
				GetPlayerName(playerid,string6,255);
				if(strcmp(string6,string5,true)==0)
				{
				    Save(string4,"Rent",cmdtext[6]);
				}
				else
				{
				    SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this HOUSE.");
				}
			}
			else
			{
			    format(string4,255,"House%d",houseid);
			    string5 = Load(string4,"Tenent1");
			    if(strcmp(string5,"None",true)==0)
			    {
					GetPlayerName(playerid,string6,255);
					Save(string4,"Tenent1",string6);
			 		string5 = Load(string4,"Tenent2");
			 		SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats. now you rent this HOUSE.");
					string6 = Load(string4,"Rent");
					new p1 = strval(string6);
					GivePlayerMoney(playerid,-p1);
					string6 = Load(string4,"Bank");
					new p2 = strval(string6);
					new p3 = p1 + p2;
					valstr(string6,p3);
					Save(string4,"Bank",string6);
					GetPlayerName(playerid,string6,255);
					format(string4,255,"%s.mic",string6);
					format(string5,255,"%f", House_OutsideX[PlayerInHouse[playerid]]);
					Save(string4,"SpawnX",string5);
					format(string5,255,"%f", House_OutsideY[PlayerInHouse[playerid]]);
					Save(string4,"SpawnY",string5);
					format(string5,255,"%f", House_OutsideZ[PlayerInHouse[playerid]]);
					Save(string4,"SpawnZ",string5);
				}
			    else if(strcmp(string5,"None",true)==0)
			    {
					GetPlayerName(playerid,string6,255);
					Save(string4,"Tenent2",string6);
					string5 = Load(string4,"Tenent3");
			 		SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats. now you rent this HOUSE.");
					string6 = Load(string4,"Rent");
					new p1 = strval(string6);
					GivePlayerMoney(playerid,-p1);
					string6 = Load(string4,"Bank");
					new p2 = strval(string6);
					new p3 = p1 + p2;
					valstr(string6,p3);
					Save(string4,"Bank",string6);
					GetPlayerName(playerid,string6,255);
					format(string4,255,"%s.mic",string6);
					format(string5,255,"%f", House_OutsideX[PlayerInHouse[playerid]]);
					Save(string4,"SpawnX",string5);
					format(string5,255,"%f", House_OutsideY[PlayerInHouse[playerid]]);
					Save(string4,"SpawnY",string5);
					format(string5,255,"%f", House_OutsideZ[PlayerInHouse[playerid]]);
					Save(string4,"SpawnZ",string5);
			    }
		     	else if(strcmp(string5,"None",true)==0)
			    {
					GetPlayerName(playerid,string6,255);
					Save(string4,"Tenent3",string6);
					string5 = Load(string4,"Tenent4");
			 		SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats. now you rent this HOUSE.");
					string6 = Load(string4,"Rent");
					new p1 = strval(string6);
					GivePlayerMoney(playerid,-p1);
					string6 = Load(string4,"Bank");
					new p2 = strval(string6);
					new p3 = p1 + p2;
					valstr(string6,p3);
					Save(string4,"Bank",string6);
					GetPlayerName(playerid,string6,255);
					format(string4,255,"%s.mic",string6);
					format(string5,255,"%f", House_OutsideX[PlayerInHouse[playerid]]);
					Save(string4,"SpawnX",string5);
					format(string5,255,"%f", House_OutsideY[PlayerInHouse[playerid]]);
					Save(string4,"SpawnY",string5);
					format(string5,255,"%f", House_OutsideZ[PlayerInHouse[playerid]]);
					Save(string4,"SpawnZ",string5);
			    }
			    else if(strcmp(string5,"None",true)==0)
			    {
					GetPlayerName(playerid,string6,255);
					Save(string4,"Tenent4",string6);
					string5 = Load(string4,"Tenent5");
			 		SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats. now you rent this HOUSE.");
					string6 = Load(string4,"Rent");
					new p1 = strval(string6);
					GivePlayerMoney(playerid,-p1);
					string6 = Load(string4,"Bank");
					new p2 = strval(string6);
					new p3 = p1 + p2;
					valstr(string6,p3);
					Save(string4,"Bank",string6);
					GetPlayerName(playerid,string6,255);
					format(string4,255,"%s.mic",string6);
					format(string5,255,"%f", House_OutsideX[PlayerInHouse[playerid]]);
					Save(string4,"SpawnX",string5);
					format(string5,255,"%f", House_OutsideY[PlayerInHouse[playerid]]);
					Save(string4,"SpawnY",string5);
					format(string5,255,"%f", House_OutsideZ[PlayerInHouse[playerid]]);
					Save(string4,"SpawnZ",string5);
			    }
			    else if(strcmp(string5,"None",true)==0)
			    {
					GetPlayerName(playerid,string6,255);
					Save(string4,"Tenent5",string6);
			 		SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats. now you rent this HOUSE.");
					string6 = Load(string4,"Rent");
					new p1 = strval(string6);
					GivePlayerMoney(playerid,-p1);
					string6 = Load(string4,"Bank");
					new p2 = strval(string6);
					new p3 = p1 + p2;
					valstr(string6,p3);
					Save(string4,"Bank",string6);
					GetPlayerName(playerid,string6,255);
					format(string4,255,"%s.mic",string6);
					format(string5,255,"%f", House_OutsideX[PlayerInHouse[playerid]]);
					Save(string4,"SpawnX",string5);
					format(string5,255,"%f", House_OutsideY[PlayerInHouse[playerid]]);
					Save(string4,"SpawnY",string5);
					format(string5,255,"%f", House_OutsideZ[PlayerInHouse[playerid]]);
					Save(string4,"SpawnZ",string5);
			    }
			    else
			    {
			        SendClientMessage(playerid,0xFFFFFFAA,"GAME: This HOUSE is full, there are no empty ROOMS to spare.");
			    }
			}
		}
	    return 1;
	}

	if(strcmp(cmdtext,"/unrent",true,7)==0)
	{
		if(PlayerInHouse[playerid] != -1)
		{
			new houseid = PlayerInHouse[playerid];
			format(string4,255,"House%d",houseid);
			GetPlayerName(playerid,string5,255);
			string6 = Load(string4,"Tenent1");
			if(strcmp(string6,string5,true)==0) Save(string4,"Tenent1","None");
			string6 = Load(string4,"Tenent2");
			if(strcmp(string6,string5,true)==0) Save(string4,"Tenent2","None");
			string6 = Load(string4,"Tenent3");
			if(strcmp(string6,string5,true)==0) Save(string4,"Tenent3","None");
			string6 = Load(string4,"Tenent4");
			if(strcmp(string6,string5,true)==0) Save(string4,"Tenent4","None");
			string6 = Load(string4,"Tenent5");
			if(strcmp(string6,string5,true)==0) Save(string4,"Tenent5","None");
		 	SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not renting this house anymore.");
			format(string4,255,"%s.mic",string5);
			Delete(string4);
		}
		return 1;
	}

	if(strcmp(cmdtext,"/buy",true,4)==0)
	{
		if(PlayerInHouse[playerid] != -1)
		{
			new houseid = PlayerInHouse[playerid];
			format(string4,255,"House%d",houseid);
			string5 = Load(string4,"Sale");
			if(strcmp(string5,"1",true)==0)
			{
				string5 = Load(string4,"Cost");
				new cost = strval(string5);
				if(GetPlayerMoney(playerid) >= cost)
				{
				    GetPlayerName(playerid,string6,255);
				    Save(string4,"Owner",string6);
					Save(string4,"Sale","0");
				    SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats for your new HOUSE.");
					GetPlayerName(playerid,string6,255);
					format(string4,255,"%s.mic",string6);
					format(string5,255,"%f", House_OutsideX[PlayerInHouse[playerid]]);
					Save(string4,"SpawnX",string5);
					format(string5,255,"%f", House_OutsideY[PlayerInHouse[playerid]]);
					Save(string4,"SpawnY",string5);
					format(string5,255,"%f", House_OutsideZ[PlayerInHouse[playerid]]);
					Save(string4,"SpawnZ",string5);
				}
				else
				{
				    SendClientMessage(playerid,0xFFFFFFAA,"GAME: You dont have enough money to buy this HOUSE.");
				}
			}
		}
	    return 1;
	}

	if(strcmp(cmdtext,"/sell",true,5)==0)
	{
		if(PlayerInHouse[playerid] != -1)
		{
			new houseid = PlayerInHouse[playerid];
			format(string4,255,"House%d",houseid);
			string5 = Load(string4,"Owner");
			GetPlayerName(playerid,string6,255);
			if(strcmp(string5,string6,true)==0)
			{
				Save(string4,"Owner","None");
				Save(string4,"Sale","1");
				string5 = Load(string4,"Bank");
				new p1 = strval(string5);
				Save(string4,"Bank","0");
				GivePlayerMoney(playerid,p1);
				string5 = Load(string4,"Cost");
				p1 = strval(string5);
				GivePlayerMoney(playerid,p1);
				format(string4,255,"%s.mic",string6);
				Delete(string4);
			    SendClientMessage(playerid,0xFFFFFFAA,"GAME: You have successfully sold your HOUSE.");
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this HOUSE.");
			}
		}
	    return 1;
	}

	if(strcmp(cmdtext,"/info",true,5)==0)
	{
		if(PlayerInHouse[playerid] != -1)
		{
			SendClientMessage(playerid,0xFFFFFFAA,"    House Info    ");
			SendClientMessage(playerid,0xFFFFFFAA,"      ");
			new houseid = PlayerInHouse[playerid];
			format(string4,255,"House%d",houseid);

			string5 = Load(string4,"Owner");
			format(string6,255,"Owner: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Cost");
			format(string6,255,"Cost: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Rent");
			format(string6,255,"Rent: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Sale");
			format(string6,255,"Sale: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Tenent1");
			format(string6,255,"Tenent1: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Tenent2");
			format(string6,255,"Tenent2: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Tenent3");
			format(string6,255,"Tenent3: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Tenent4");
			format(string6,255,"Tenent4: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			string5 = Load(string4,"Tenent5");
			format(string6,255,"Tenent5: %s.",string5);
			SendClientMessage(playerid,0xFFFFFFAA,string6);

			SendClientMessage(playerid,0xFFFFFFAA,"      ");
		}
	    return 1;
	}
	if(strcmp(cmdtext,"/withdraw",true,9)==0)
	{
			new houseid = PlayerInHouse[playerid];
			format(string4,255,"House%d",houseid);
			string5 = Load(string4,"Owner");
			GetPlayerName(playerid,string6,255);
			if(strcmp(string5,string6,true)==0)
			{
				string5 = Load(string4,"Bank");
				new p1 = strval(string5);
				GivePlayerMoney(playerid,p1);
				Save(string4,"Bank","0");
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this HOUSE.");
			}

		    return 1;
	}
	return 0;
}

stock Houses_OnPlayerSpawn(playerid)
{
	GetPlayerName(playerid,string4,255);
	format(string5,255,"%s.mic.snl",string4);
	if(fexist(string5))
	{
	    format(string5,255,"%s.mic",string4);
		string6 = Load(string5,"SpawnX");
		new Float:x = floatstr(string6);
		string6 = Load(string5,"SpawnY");
		new Float:y = floatstr(string6);
		string6 = Load(string5,"SpawnZ");
		new Float:z = floatstr(string6);
		SetPlayerPos(playerid,x,y,z);
	}
}

stock Houses_PlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
	if(IsValidHouseCar[vehicleid] != -1)
	{
		if(!ispassenger)
		{
			new houseid = PlayerInHouse[playerid];
			format(string4,255,"House%d",houseid);
			string5 = Load(string4,"Owner");
			GetPlayerName(playerid,string6,255);
			new allowed = 0;
			if(strcmp(string5,string6,true)==0) allowed = 1;
			string5 = Load(string4,"Tenent1");
			if(strcmp(string5,string6,true)==0) allowed = 1;
			string5 = Load(string4,"Tenent2");
			if(strcmp(string5,string6,true)==0) allowed = 1;
			string5 = Load(string4,"Tenent3");
			if(strcmp(string5,string6,true)==0) allowed = 1;
			string5 = Load(string4,"Tenent4");
			if(strcmp(string5,string6,true)==0) allowed = 1;
			string5 = Load(string4,"Tenen5");
			if(strcmp(string5,string6,true)==0) allowed = 1;
			if(allowed == 1)
			{
				SetVehicleParamsForPlayer(vehicleid,playerid,0,0);
			}
			else
			{
				SetVehicleParamsForPlayer(vehicleid,playerid,0,1);
			}
		}
	}

}

// Bizs

new Float:Biz_OutsideX[256] = -1.0;
new Float:Biz_OutsideY[256] = -1.0;
new Float:Biz_OutsideZ[256] = -1.0;
new Float:Biz_InsideX[256] = -1.0;
new Float:Biz_InsideY[256] = -1.0;
new Float:Biz_InsideZ[256] = -1.0;
new Biz_InsideID[256] = -1;
new IsValidBiz[256] = -1;
new string7[256];
new string8[256];
new string9[256];

stock SetBiz(iconid,Float:OutsideX,Float:OutsideY,Float:OutsideZ,Float:InsideX,Float:InsideY,Float:InsideZ,InsideID,Cost)
{
	new Bizid = CreatePickup(iconid,2,OutsideX,OutsideY,OutsideZ);
	Biz_OutsideX[Bizid] = OutsideX;
	Biz_OutsideY[Bizid] = OutsideY;
	Biz_OutsideZ[Bizid] = OutsideZ;
	Biz_InsideX[Bizid] = InsideX;
	Biz_InsideY[Bizid] = InsideY;
	Biz_InsideZ[Bizid] = InsideZ;
	Biz_InsideID[Bizid] = InsideID;
	IsValidBiz[Bizid] = 1;
	format(string7,255,"Biz%d",Bizid);
	if(Exist(string7)==0)
	{
		Create(string7);
		Save(string7,"Owner","None");
		valstr(string8,Cost);
		Save(string7,"Cost",string8);
		Save(string7,"Fee","500");
		Save(string7,"Bank","0");
		Save(string7,"Sale","1");
		Save(string7,"Status","Open");
	}
	return Bizid;
}

new PlayerInBiz[200] = -1;


stock Biz_PlayerPickUpPickup(playerid, pickupid)
{
	if(IsValidBiz[pickupid] == 1)
	{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Owner");
			GetPlayerName(playerid,string9,255);
			if(strcmp(string8,string9,true,255)==0)
			{
				SetPlayerPos(playerid,Biz_InsideX[pickupid],Biz_InsideY[pickupid],Biz_InsideZ[pickupid]);
			    SetPlayerInterior(playerid,Biz_InsideID[pickupid]);
				PlayerInBiz[playerid] = pickupid;
			}
			else
			{
			    string8 = Load(string7,"Status");
			    if(strcmp(string8,"Open",true)==0)
			    {
					SetPlayerPos(playerid,Biz_InsideX[pickupid],Biz_InsideY[pickupid],Biz_InsideZ[pickupid]);
				    SetPlayerInterior(playerid,Biz_InsideID[pickupid]);
					PlayerInBiz[playerid] = pickupid;
				}
				else
				{
				    SendClientMessage(playerid,0xFFFFFFAA,"GAME: This BIZ is closed, come back later.");
				}
			}

	}
	return 1;
}

stock Biz_PlayerCommandText(playerid,cmdtext[])
{


	if(strcmp(cmdtext,"/exit",true,5)==0)
	{
		if(PlayerInBiz[playerid] != -1)
		{
		    new Bizid = PlayerInBiz[playerid];
		    PlayerInBiz[playerid] = -1;
	 	    SetPlayerPos(playerid,Biz_OutsideX[Bizid],Biz_OutsideY[Bizid],Biz_OutsideZ[Bizid]);
		    SetPlayerInterior(playerid,0);
		}
	    return 1;
	}
	if(strcmp(cmdtext,"/buy",true,4)==0)
	{
		if(PlayerInBiz[playerid] != -1)
		{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Sale");
			if(strcmp(string8,"1",true)==0)
			{
				string8 = Load(string7,"Cost");
				new cost = strval(string8);
				if(GetPlayerMoney(playerid) >= cost)
				{
				    GetPlayerName(playerid,string9,255);
				    Save(string7,"Owner",string9);
					Save(string7,"Sale","0");
				    SendClientMessage(playerid,0xFFFFFFAA,"GAME: Congrats for your new BIZ.");
				}
				else
				{
				    SendClientMessage(playerid,0xFFFFFFAA,"GAME: You dont have enough money.");
				}
			}
		}
	    return 1;
	}

	if(strcmp(cmdtext,"/sell",true,5)==0)
	{
		if(PlayerInBiz[playerid] != -1)
		{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Owner");
			GetPlayerName(playerid,string9,255);
			if(strcmp(string8,string9,true)==0)
			{
				Save(string7,"Owner","None");
				Save(string7,"Sale","1");
				string8 = Load(string7,"Bank");
				new p1 = strval(string8);
				Save(string7,"Bank","0");
				GivePlayerMoney(playerid,p1);
				string8 = Load(string7,"Cost");
				p1 = strval(string8);
				GivePlayerMoney(playerid,p1);
			    SendClientMessage(playerid,0xFFFFFFAA,"GAME: You have successfully sold your BIZ.");
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this BIZ.");
			}
		}
	    return 1;
	}

	if(strcmp(cmdtext,"/info",true,5)==0)
	{
		if(PlayerInBiz[playerid] != -1)
		{
			SendClientMessage(playerid,0xFFFFFFAA,"    Biz Info    ");
			SendClientMessage(playerid,0xFFFFFFAA,"      ");
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);

			string8 = Load(string7,"Owner");
			format(string9,255,"Owner: %s.",string8);
			SendClientMessage(playerid,0xFFFFFFAA,string9);

			string8 = Load(string7,"Cost");
			format(string9,255,"Cost: %s.",string8);
			SendClientMessage(playerid,0xFFFFFFAA,string9);

			string8 = Load(string7,"Fee");
			format(string9,255,"Fee: %s.",string8);
			SendClientMessage(playerid,0xFFFFFFAA,string9);

			string8 = Load(string7,"Sale");
			format(string9,255,"Sale: %s.",string8);
			SendClientMessage(playerid,0xFFFFFFAA,string9);

			string8 = Load(string7,"Status");
			format(string9,255,"Status: %s.",string8);
			SendClientMessage(playerid,0xFFFFFFAA,string9);

			SendClientMessage(playerid,0xFFFFFFAA,"      ");
		}
	    return 1;
	}
	if(strcmp(cmdtext,"/withdraw",true,9)==0)
	{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Owner");
			GetPlayerName(playerid,string9,255);
			if(strcmp(string8,string9,true)==0)
			{
				string8 = Load(string7,"Bank");
				new p1 = strval(string8);
				GivePlayerMoney(playerid,p1);
				Save(string7,"Bank","0");
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this BIZ.");
			}

		    return 1;
	}

	if(strcmp("/Fee ",cmdtext,true,5)==0)
	{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Owner");
			GetPlayerName(playerid,string9,255);
			if(strcmp(string8,string9,true)==0)
			{
				new fee = strval(cmdtext[5]);
				Bizid = PlayerInBiz[playerid];
				format(string7,255,"Biz%d",Bizid);
				valstr(string8,fee);
				Save(string7,"Fee",string8);
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this BIZ.");
			}
		    return 1;
	}

	if(strcmp("/close",cmdtext,true,5)==0)
	{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Owner");
			GetPlayerName(playerid,string9,255);
			if(strcmp(string8,string9,true)==0)
			{
				Save(string7,"Status","Closed");
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this BIZ.");
			}
		    return 1;
	}
	if(strcmp("/open",cmdtext,true,4)==0)
	{
			new Bizid = PlayerInBiz[playerid];
			format(string7,255,"Biz%d",Bizid);
			string8 = Load(string7,"Owner");
			GetPlayerName(playerid,string9,255);
			if(strcmp(string8,string9,true)==0)
			{
				Save(string7,"Status","Open");
			}
			else
			{
				SendClientMessage(playerid,0xFFFFFFAA,"GAME: You are not the owner of this BIZ.");
			}
		    return 1;
	}
	return 0;
}


// Checkpoints

new MapIconID = 0;
new checkpointid = -1;
new Float:CheckpointX[256];
new Float:CheckpointY[256];
new Float:CheckpointZ[256];
new Float:CheckpointS[256];
new IsCheckpointVisible[256][MAX_PLAYERS];


stock CreateCheckpoint(Float:x,Float:y,Float:z,Float:size)
{
	checkpointid++;
	CheckpointX[checkpointid] = x;
	CheckpointY[checkpointid] = y;
	CheckpointZ[checkpointid] = z;
	CheckpointS[checkpointid] = size;
	return checkpointid;
}

stock DestroyCheckpoint(cpid)
{
	CheckpointX[cpid] = 0.0;
	CheckpointY[cpid] = 0.0;
	CheckpointZ[cpid] = 0.0;
	CheckpointS[cpid] = 0.0;

}

stock ShowCheckpoint(playerid,cpid)
{
	MapIconID++;
	IsCheckpointVisible[cpid][playerid] = 1;
}

stock HideCheckpoint(playerid,cpid)
{
	IsCheckpointVisible[cpid][playerid] = 0;
}

stock ShowCheckpointForAll(cpid)
{
 	new i;
	for(i=0;i<=MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i)==1)
	    {
	    	ShowCheckpoint(i,cpid);
		}
	}
}

stock HideCheckpointForAll(cpid)
{
 	new i;
	for(i=0;i<=MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i)==1)
	    {
			IsCheckpointVisible[i][cpid] = 0;
		}
	}
}

stock Float:CheckpointToPlayerDistance(cpid,playerid)
{
	new Float:x1,Float:y1,Float:z1;
	new Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);
	x2 = CheckpointX[cpid];
	y2 = CheckpointY[cpid];
	z2 = CheckpointZ[cpid];

	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

stock GetPlayerClosestCheckpoint(playerid)
{
	new i,j = -1,Float:Handle,Float:Closest = 999999.999;
	for(i=0;i<=checkpointid;i++)
	{
		if (IsCheckpointVisible[i][playerid] == 1){
			Handle = CheckpointToPlayerDistance(i,playerid);
			if(Handle <= Closest)
			{
				Closest = Handle;
				j = i;
			}
		}
	}
	return j;
}

forward CheckpointHandler();
public CheckpointHandler()
{
	new i;
	new checkpoint;
	for(i=0;i<=MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i)==1)
	    {
			checkpoint = GetPlayerClosestCheckpoint(i);
			if(CheckpointS[checkpoint] != 0)
			{
				SetPlayerCheckpoint(i,CheckpointX[checkpoint],CheckpointY[checkpoint],CheckpointZ[checkpoint],CheckpointS[checkpoint]);
			}
		}
	}
}

stock Checkpoint_GameModeInit()
{
    SetTimer("CheckpointHandler",1000,1);
}

// Gangs


stock CreateGang(gang[],leader[])
{
	format(string1,255,"%s.mic",leader);
	Save(string1,"Gang",gang);
	Save(string1,"Leader","1");
}

stock MakeGangLeader(gang[],leader[])
{
	format(string1,255,"%s.mic",leader);
	Save(string1,"Gang",gang);
	Save(string1,"Leader","1");
}

stock KickGangLeader(gang[],leader[])
{
	format(string1,255,"%s.mic",leader);
	Save(string1,"Gang",gang);
	Save(string1,"Leader","0");
}

stock SetPlayerInGang(player[],gang[])
{
   	format(string1,255,"%s.mic",player);
	Save(string1,"Gang",gang);
	Save(string1,"Leader","0");
}

stock RemovePlayerForGang(player[])
{
   	format(string1,255,"%s.mic",player);
	Save(string1,"Gang","None");
	Save(string1,"Leader","0");
}

stock IsPlayerInGang(player[],gang[])
{
	format(string1,255,"%s.mic",player);
	string2 = Load(string1,"Gang");
	if(strcmp(string2,gang,true)==0)
	{
		return 1;
	}
	else
	{
	    return 0;
	}
}

stock IsPlayerLeader(player[])
{
	format(string1,255,"%s.mic",player);
	string2 = Load(string1,"Leader");
	if(strcmp(string2,"1",true)==0)
	{
		return 1;
	}
	else
	{
	    return 0;
	}
}

stock SendClientMessageToGang(gang[],color,message[])
{
	new i = 0;
	for(i = 0; i <= 200; i++ )
	{
	    if(IsPlayerConnected(i)==1)
	    {
			GetPlayerName(i,string1,255);
			format(string2,255,"%s.mic",string1);
			string3 = Load(string2,"Gang");
			if(strcmp(string3,gang,true)==0)
			{
			    SendClientMessage(i,color,message);
			}
		}
	}
}

// Gadgets

	// Clock
new Clock_String[256];
new Text:Clock;

stock Clock_GameModeInit()
{
	Clock = TextDrawCreate(549,24,"00:00");
}
forward ToggleRealClock();
public ToggleRealClock()
{
	TextDrawLetterSize(Clock,0.55,2);
	TextDrawFont(Clock,3);
	TextDrawBackgroundColor(Clock,0x000000AA);
	TextDrawSetOutline(Clock,2);
	new hour,minute,second;
	gettime(hour,minute,second);

	if (minute <= 9)
	{
		format(Clock_String,255,"%d:0%d",hour,minute);
	}
	else
	{
		format(Clock_String,255,"%d:%d",hour,minute);
	}
	TextDrawSetString(Clock,Clock_String);
	new i;
	for(i = 0; i <= 200;i++)
	{
	    if(IsPlayerConnected(i)==1)
	    {
			TextDrawShowForPlayer(i,Clock);
	    }
	}
	if (hour == 0){SetWorldTime(0);}
	if (hour == 1){SetWorldTime(1);}
	if (hour == 2){SetWorldTime(2);}
	if (hour == 3){SetWorldTime(3);}
	if (hour == 4){SetWorldTime(4);}
	if (hour == 5){SetWorldTime(5);}
	if (hour == 6){SetWorldTime(6);}
	if (hour == 7){SetWorldTime(7);}
	if (hour == 8){SetWorldTime(8);}
	if (hour == 9){SetWorldTime(9);}
	if (hour == 10){SetWorldTime(10);}
	if (hour == 11){SetWorldTime(11);}
	if (hour == 12){SetWorldTime(12);}
	if (hour == 13){SetWorldTime(13);}
	if (hour == 14){SetWorldTime(14);}
	if (hour == 15){SetWorldTime(15);}
	if (hour == 16){SetWorldTime(16);}
	if (hour == 17){SetWorldTime(17);}
	if (hour == 18){SetWorldTime(18);}
	if (hour == 19){SetWorldTime(19);}
	if (hour == 20){SetWorldTime(20);}
	if (hour == 21){SetWorldTime(21);}
	if (hour == 22){SetWorldTime(22);}
	if (hour == 23){SetWorldTime(23);}
	if (hour == 24){SetWorldTime(24);}
	SetTimer("ToggleRealClock",30000,0);
}

	// Ammu

stock SelectedMenuAmmu(playerid,row)
{
	new i;
	new Menu:Cur = GetPlayerMenu(playerid);
	for (i=0;i<=150;i++)
	{
		if (Cur == AN[i])
		{
			switch (row)
			{
				case 0:
				{
					ShowMenuForPlayer(AN1,playerid);
				}
				case 1:
				{
					ShowMenuForPlayer(AN2,playerid);
				}
				case 2:
				{
					ShowMenuForPlayer(AN3,playerid);
				}
				case 3:
				{
					ShowMenuForPlayer(AN4,playerid);
				}
				case 4:
				{
					ShowMenuForPlayer(AN5,playerid);
				}
				case 5:
				{
					ShowMenuForPlayer(AN6,playerid);
				}
				case 6:
				{
					ShowMenuForPlayer(AN7,playerid);
				}
			}
		}
		else if (Cur == AN1)
		{
			switch(row)
			{
				case 0:
				{
					GivePlayerWeapon(playerid,22,50);
					GivePlayerMoney(playerid,-st11[i]);
				}
				case 1:
				{
					GivePlayerWeapon(playerid,23,50);
					GivePlayerMoney(playerid,-st12[i]);
				}
				case 2:
				{
					GivePlayerWeapon(playerid,24,50);
					GivePlayerMoney(playerid,-st13[i]);
				}
			}
		}
		else if (Cur == AN2)
		{
			switch(row)
			{
				case 0:
				{
					GivePlayerWeapon(playerid,32,50);
					GivePlayerMoney(playerid,-st21[i]);
				}
				case 1:
				{
					GivePlayerWeapon(playerid,28,50);
					GivePlayerMoney(playerid,-st22[i]);
				}
			}
		}
		else if (Cur == AN3)
		{
			switch(row)
			{
				case 0:
				{
					GivePlayerWeapon(playerid,25,50);
					GivePlayerMoney(playerid,-st31[i]);
				}
				case 1:
				{
					GivePlayerWeapon(playerid,26,50);
					GivePlayerMoney(playerid,-st32[i]);
				}
			}
		}
		else if (Cur == AN4)
		{
			switch(row)
			{
				case 0:
				{
					SetPlayerArmour(playerid,100);
					GivePlayerMoney(playerid,-st41[i]);
				}
			}
		}
		else if (Cur == AN5)
		{
			switch(row)
			{
				case 0:
				{
		 			GivePlayerWeapon(playerid,29,50);
					GivePlayerMoney(playerid,-st51[i]);
				}
			}
		}
		else if (Cur == AN6)
		{
			switch(row)
			{
				case 0:
				{
					GivePlayerWeapon(playerid,33,50);
					GivePlayerMoney(playerid,-st61[i]);
				}
				case 1:
				{
					GivePlayerWeapon(playerid,34,50);
					GivePlayerMoney(playerid,-st62[i]);
				}
			}
		}
		else if (Cur == AN7)
		{
			switch(row)
			{
				case 0:
				{
					GivePlayerWeapon(playerid,30,50);
					GivePlayerMoney(playerid,-st71[i]);
				}
				case 1:
				{
					GivePlayerWeapon(playerid,31,50);
					GivePlayerMoney(playerid,-st72[i]);
				}
			}
		}
	}
}
forward EnableBlockAmmu(toggle);
public EnableBlockAmmu(toggle)
{
	if (toggle == 0)
	{
		new i;
		for(i =0; i<= MAX_PLAYERS; i++)
		{
		    if(IsPlayerConnected(i)==1)
		    {
					if 	(IsPlayerInAmmu(20, i,292.0274,-36.0291,1001.5156))
					{
						new Float:ht = GetPlayerHealth(i,ht);
						SetPlayerHealth(i,ht-10);
					}
					else if(IsPlayerInAmmu(20, i,308.2740,-141.2833,999.6016))
					{
						new Float:ht = GetPlayerHealth(i,ht);
						SetPlayerHealth(i,ht-10);
					}
					else if(IsPlayerInAmmu(20, i,294.3212,-108.7869,1001.5156))
					{
						new Float:ht = GetPlayerHealth(i,ht);
						SetPlayerHealth(i,ht-10);
					}
					else if(IsPlayerInAmmu(20, i,288.8592,-80.4535,1001.5156))
					{
						new Float:ht = GetPlayerHealth(i,ht);
						SetPlayerHealth(i,ht-10);
					}
					else if(IsPlayerInAmmu(20, i,316.9583,-165.4707,999.6010))
					{
						new Float:ht = GetPlayerHealth(i,ht);
						SetPlayerHealth(i,ht-10);
					}
			}
		}
	}
	SetTimerEx("EnableBlockAmmu",700,0,"i",0);
}

stock AddStaticAmmu(slot1,slot2,slot3,slot4,slot5,slot6,slot7)
{

	sto++;
	st1[sto] = slot1;
	st2[sto] = slot2;
	st3[sto] = slot3;
	st4[sto] = slot4;
	st5[sto] = slot5;
	st6[sto] = slot6;
	st7[sto] = slot7;

	AN[sto] = CreateMenu("Ammu-Nation",1,25,150,150,150);
	AddMenuItem(AN[sto],0,"Pistols");
	AddMenuItem(AN[sto],0,"Micro SMGs");
	AddMenuItem(AN[sto],0,"Shotguns");
	AddMenuItem(AN[sto],0,"Armor");
	AddMenuItem(AN[sto],0,"SMG");
	AddMenuItem(AN[sto],0,"Rifles");
	AddMenuItem(AN[sto],0,"Assault");

	if(st1[sto] == 0)
	{
		DisableMenuRow(AN[sto],0);
	}
	if(st2[sto] == 0)
	{
		DisableMenuRow(AN[sto],1);
	}
	if(st3[sto] == 0)
	{
		DisableMenuRow(AN[sto],2);
	}
	if(st4[sto] == 0)
	{
		DisableMenuRow(AN[sto],3);
	}
	if(st5[sto] == 0)
	{
		DisableMenuRow(AN[sto],4);
	}
	if(st6[sto] == 0)
	{
		DisableMenuRow(AN[sto],5);
	}
	if(st7[sto] == 0)
	{
		DisableMenuRow(AN[sto],6);
	}

	return sto;
}

stock ShowAmmu(playerid,ammuid)
{
	ShowMenuForPlayer(AN[ammuid],playerid);
}

stock SetWeaponCost(ammuid,weaponid,cost)
{
	switch(weaponid)
	{
		case 11:
		{
			st11[ammuid] = cost;
		}
		case 12:
		{
			st12[ammuid] = cost;
		}
		case 13:
		{
			st13[ammuid] = cost;
		}
		case 21:
		{
			st21[ammuid] = cost;
		}
		case 22:
		{
			st22[ammuid] = cost;
		}
		case 31:
		{
			st31[ammuid] = cost;
		}
		case 32:
		{
			st32[ammuid] = cost;
		}
		case 41:
		{
			st41[ammuid] = cost;
		}
		case 51:
		{
			st51[ammuid] = cost;
		}
		case 61:
		{
			st61[ammuid] = cost;
		}
		case 62:
		{
			st62[ammuid] = cost;
		}
		case 72:
		{
			st72[ammuid] = cost;
		}
	}
}

stock IsPlayerInAmmu(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}

	// LSPD Prison
	new LSPD_DOOR_OBJECT_ONE;
	new LSPD_DOOR_OBJECT_TWO;

stock Prison_OnGameModeInit()
{
    LSPD_DOOR_OBJECT_ONE = CreateObject(1500,266.2812,82.4017,1000.0000,0,0,90);
	LSPD_DOOR_OBJECT_TWO = CreateObject(1500,266.2812,86.8504,1000.0000,0,0,90);
}

stock OpenPrison(door)
{
	if(door == 1)
	{
   		MoveObject(LSPD_DOOR_OBJECT_ONE,266.2812,80.4017,1000.0000,1);
	}
	else if(door == 2)
	{
		MoveObject(LSPD_DOOR_OBJECT_TWO,266.2812,84.8504,1000.0000,1);
	}
}

stock ClosePrison(door)
{
	if(door == 1)
	{
   		MoveObject(LSPD_DOOR_OBJECT_ONE,266.2812,82.4017,1000.0000,1);
	}
	else if(door == 2)
	{
		MoveObject(LSPD_DOOR_OBJECT_TWO,266.2812,86.8504,1000.0000,1);

	}
}

// Message Box
#define Box: Menu:
stock Box:MessageBoxCreate(title[])
{
	new Box:id = CreateMenu(title,1,20,20,200,0);
	return id;
}
stock AddMessageBoxLine(Box:MessageBoxID,text[])
{
	DisableMenuRow(messageboxid,AddMenuItem(MessageBoxID,0,text));
}

stock MessageBoxShowForPlayer(Box:MessageBoxID,playerid)
{
	ShowMenuForPlayer(MessageBoxID,playerid);
}

