#if defined _gtaeuro_included
	#endinput
#endif
#define _gtaeuro_included
#pragma library gtaeuro


#define F Float
#define AMI AddMenuItem
#define SMCH SetMenuColumnHeader
#define M Menu


#define fix(%1) for(new i=0;i<strlen(%1);i++)if(%1[i]<0)%1[i]+=256
#define never 4294

#define COLOR_CLAN 	0x7D75FFAA

stock GetIP(playerid)
{
	new ip[15];
    GetPlayerIp(playerid,ip,sizeof(ip));
	return ip;
}

stock SCM(playerid,COLOR,tmp[])
{
	fix(tmp);
	SendClientMessage(playerid,COLOR,tmp);
	return 1;
}

stock SCMA(COLOR,tmp[])
{
	fix(tmp);
	SendClientMessageToAll(COLOR,tmp);
	return 1;
}

stock GetTagName(playerid)
{
	new name[24];
	name=GetFullName(playerid);
	new f=strlen(GetTagClan(playerid));
	if(f>0||(name[0]=='['&&name[1]==']')) strdel(name,0,f+2);
	return name;
}

stock GetFullName(playerid)
{
	new txt[24];
	GetPlayerName(playerid,txt,sizeof(txt));
	return txt;
}

stock GetTagClan(playerid)
{
	new name[24];
	new clan[24];
	name=GetFullName(playerid);
	if (name[0]=='[')
	{
		if (name[1]==']')
		{
			return clan;
		}
		for (new i=1;i<MAX_PLAYER_NAME;i++)
		{
			if (name[i]==']')
			{
				strdel(name,0,1);
				strdel(name,i-1,sizeof(name));
			    return name;
			}
		}
	}
	return clan;
}



stock IsPlayerInRadius(playerid,Float:x,Float:y,Float:r)
{
	new Float:xp,Float:yp,Float:zp;
	GetPlayerPos(playerid, xp, yp, zp);
	if (floatsqroot(floatpower(xp-x,2) + floatpower(yp-y,2)) < r) return 1;
	else return 0;
}

stock AdminMessage(playerid,cmdtext[]) {
	for (new i=0;i<MAX_PLAYERS;i++) {
		if (IsPlayerConnected(i)) {
			new string[256];
			new thisplayer[MAX_PLAYER_NAME];

			GetPlayerName(playerid,thisplayer,sizeof(thisplayer));
			format(string, sizeof(string), "%s[%d]: %s",thisplayer,playerid,cmdtext);
			if (IsPlayerAdmin(i)) {
				SCM(i, 0xFFFF00AA, string);
			}
		}
	}
}

stock SaveName(playerid)
{
	new string[256];
	format(string, sizeof(string), "%s.player",udb_encode(GetTagName(playerid)));
	return string;
}

stock SaveClan(playerid)
{
	new string[256];
	format(string, sizeof(string), "%s.clan",udb_encode(Clan(playerid)));
	return string;
}

stock VehicleDriver(vehicleid)
{
	for (new i=0;i<MAX_PLAYERS;i++) {
		if (IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == 2)  return i;
	}
	return -1;
}

stock TuningCar(vid)
{
	switch(GetVehicleModel(vid))
	{
		case 400..404,406..429,431..434,436..445,451,455..459,466,467,470,471,474,475,477..480,482,483,485,486,489..492,494,495,498..508,514..518,524..533,540..547,549..552,554..557,566,568..574,578,579,582,583,585,587..589,596..603:
		{
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
//			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			return 1;
		}
		case 534:
		{	//Remington
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1124);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1106);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1127);//Exhaust Type 2
			AddVehicleComponent(vid,1185);//Front Bumper type 2
			AddVehicleComponent(vid,1180);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 535:
		{	//Slamvan
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1121);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1119);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1114);//Exhaust Type 2
			AddVehicleComponent(vid,1116);//Front Bullbars type 2
			AddVehicleComponent(vid,1110);//Rear Bullbars type 2
			AddVehicleComponent(vid,1117);//Front Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 536:
		{	//Blade
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1107);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1108);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1105);//Exhaust Type 2
			AddVehicleComponent(vid,1181);//Front Bumper type 2
			AddVehicleComponent(vid,1183);//Rear Bumper type 2
			AddVehicleComponent(vid,1103);//Roof type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 558:
		{	//Uranus
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1163);//Spoiler type 2
			AddVehicleComponent(vid,1095);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1093);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1091);//Roof Scoop type 2
			AddVehicleComponent(vid,1092);//Exhaust Type 2
			AddVehicleComponent(vid,1165);//Front Bumper type 2
			AddVehicleComponent(vid,1166);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 559:
		{	//Jester
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1158);//Spoiler type 2
			AddVehicleComponent(vid,1072);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1070);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1068);//Roof Scoop type 2
			AddVehicleComponent(vid,1066);//Exhaust Type 2
			AddVehicleComponent(vid,1173);//Front Bumper type 2
			AddVehicleComponent(vid,1161);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 560:
		{   //Sultan
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1139);//Spoiler type 2
			AddVehicleComponent(vid,1030);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1031);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1033);//Roof Scoop type 2
			AddVehicleComponent(vid,1029);//Exhaust Type 2
			AddVehicleComponent(vid,1170);//Front Bumper type 2
			AddVehicleComponent(vid,1140);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 561:
		{	//Stratum
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1060);//Spoiler type 2
			AddVehicleComponent(vid,1063);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1057);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1061);//Roof Scoop type 2
			AddVehicleComponent(vid,1059);//Exhaust Type 2
			AddVehicleComponent(vid,1157);//Front Bumper type 2
			AddVehicleComponent(vid,1156);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 562:
		{	//Elegy
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1146);//Spoiler type 2
			AddVehicleComponent(vid,1041);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1039);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1038);//Roof Scoop type 2
			AddVehicleComponent(vid,1037);//Exhaust Type 2
			AddVehicleComponent(vid,1172);//Front Bumper type 2
			AddVehicleComponent(vid,1148);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 565:
		{	//Flash
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1050);//Spoiler type 2
			AddVehicleComponent(vid,1052);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1048);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1053);//Roof Scoop type 2
			AddVehicleComponent(vid,1045);//Exhaust Type 2
			AddVehicleComponent(vid,1152);//Front Bumper type 2
			AddVehicleComponent(vid,1151);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 567:
		{	//Savanna
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1102);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1133);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1132);//Exhaust Type 2
			AddVehicleComponent(vid,1188);//Front Bumper type 2
			AddVehicleComponent(vid,1186);//Rear Bumper type 2
			AddVehicleComponent(vid,1131);//Roof type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}

		case 575:
		{	//Broadway
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1042);//Side Skirt (R)
			AddVehicleComponent(vid,1099);//Side Skirt (L)
			AddVehicleComponent(vid,1043);//Exhaust Type 2
			AddVehicleComponent(vid,1175);//Front Bumper type 2
			AddVehicleComponent(vid,1177);//Rear Bumper type 2
			return 1;
		}
		case 576:
		{	//Tornado
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1137);//Side Skirt Type 2 (R)
			AddVehicleComponent(vid,1134);//Side Skirt Type 2 (L)
			AddVehicleComponent(vid,1135);//Exhaust Type 2
			AddVehicleComponent(vid,1193);//Front Bumper type 2
			AddVehicleComponent(vid,1191);//Rear Bumper type 2
			ChangeVehiclePaintjob(vid,random(3)-1);
			return 1;
		}
		case 405:
		{
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1018);
			AddVehicleComponent(vid,1000);
			return 1;
		}
		case 496:
		{
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1011);
			AddVehicleComponent(vid,1143);
			AddVehicleComponent(vid,1019);
			AddVehicleComponent(vid,1006);
			AddVehicleComponent(vid,1003);
			AddVehicleComponent(vid,1007);
			return 1;
		}
		case 580:
		{
			AddVehicleComponent(vid,1010);//Nitro - 10 Shots
			AddVehicleComponent(vid,1087);//Hydralics
			AddVehicleComponent(vid,1081);//Wheel Arch Angels Wheel type 4
			AddVehicleComponent(vid,1018);
			AddVehicleComponent(vid,1006);
			AddVehicleComponent(vid,1023);
			AddVehicleComponent(vid,1007);
			return 1;
		}
		default:
		{
			return 1;
		}
	}
	return 1;
}

stock code(codetxt[])
{
	new txt[256];
	
	new mass[64][2]={
	{'à','a'},
	{'á','—'},
	{'â','¢'},
	{'ã','™'},
	{'ä','š'},
	{'å','e'},
	{'æ','›'},
	{'ç','Ÿ'},
	{'è','œ'},
	{'é',''},
	{'ê','k'},
	{'ë','ž'},
	{'ì','¯'},
	{'í','®'},
	{'î','o'},
	{'ï','£'},
	{'ð','p'},
	{'ñ','c'},
	{'ò','¦'},
	{'ó','y'},
	{'ô','˜'},
	{'õ','x'},
	{'ö',' '},
	{'÷','¤'},
	{'ù','¡'},
	{'ø','¥'},
	{'ú','§'},
	{'ü','©'},
	{'ý','ª'},
	{'û','¨'},
	{'þ','«'},
	{'ÿ','¬'},
	{'À','A'},
	{'Á','€'},
	{'Â','‹'},
	{'Ã','‚'},
	{'Ä','ƒ'},
	{'Å','E'},
	{'Æ','„'},
	{'Ç','ˆ'},
	{'È','…'},
	{'É','†'},
	{'Ê','K'},
	{'Ë','‡'},
	{'Ì','–'},
	{'Í','­'},
	{'Î','O'},
	{'Ï','Œ'},
	{'Ð','P'},
	{'Ñ','C'},
	{'Ò',''},
	{'Ó','Y'},
	{'Ô',''},
	{'Õ','X'},
	{'Ö','‰'},
	{'×',''},
	{'Ù','Š'},
	{'Ø','Ž'},
	{'Ú',''},
	{'Ü','’'},
	{'Ý','“'},
	{'Û','‘'},
	{'Þ','”'},
	{'ß','•'}
	};
	for (new s;s<strlen(codetxt);s++)
	{
		for (new i;i<64;i++)
		{
			if (codetxt[s]==mass[i][0])
			{
				codetxt[s]=mass[i][1];
			}
		}
	}
	format(txt,sizeof(txt),"%s",codetxt);
	fix(txt);
	return txt;
}

stock GetModel()
{
	new model[250];
	new nummodel;
	for (new i=1;i<VehicleSize()+1;i++)
	{
		model[GetVehicleModel(i)-400]++;
	}

	for (new i=0;i<250;i++)
	{
	    if (model[i]!=0)
	    {
	        nummodel++;
		}
	}
	return nummodel;
}


stock VehicleSize()
{
	new Float:x;
	new Float:y;
	new Float:z;
	new maxv;
	for(new i=0;i<MAX_VEHICLES;i++)
	{
		GetVehiclePos(i,x,y,z);
		if(z != 0 && x!= 0 && y != 0)
		{
			maxv++;
		}
	}
	return maxv;
}

stock VehicleInfo()
{
	new string[256];
	format(string, sizeof(string), " VehSize: %d Mod: %d ", VehicleSize() ,  VehicleModel());
	return string;
}

#pragma unused VehicleInfo

new VehicleNames[212][] = {	// Vehicle Names - Betamaster
	{"Landstalker"},
	{"Bravura"},
	{"Buffalo"},
	{"Linerunner"},
	{"Perrenial"},
	{"Sentinel"},
	{"Dumper"},
	{"Firetruck"},
	{"Trashmaster"},
	{"Stretch"},
	{"Manana"},
	{"Infernus"},
	{"Voodoo"},
	{"Pony"},
	{"Mule"},
	{"Cheetah"},
	{"Ambulance"},
	{"Leviathan"},
	{"Moonbeam"},
	{"Esperanto"},
	{"Taxi"},
	{"Washington"},
	{"Bobcat"},
	{"Mr Whoopee"},
	{"BF Injection"},
	{"Hunter"},
	{"Premier"},
	{"Enforcer"},
	{"Securicar"},
	{"Banshee"},
	{"Predator"},
	{"Bus"},
	{"Rhino"},
	{"Barracks"},
	{"Hotknife"},
	{"Trailer 1"}, //artict1
	{"Previon"},
	{"Coach"},
	{"Cabbie"},
	{"Stallion"},
	{"Rumpo"},
	{"RC Bandit"},
	{"Romero"},
	{"Packer"},
	{"Monster"},
	{"Admiral"},
	{"Squalo"},
	{"Seasparrow"},
	{"Pizzaboy"},
	{"Tram"},
	{"Trailer 2"}, //artict2
	{"Turismo"},
	{"Speeder"},
	{"Reefer"},
	{"Tropic"},
	{"Flatbed"},
	{"Yankee"},
	{"Caddy"},
	{"Solair"},
	{"Berkley's RC Van"},
	{"Skimmer"},
	{"PCJ-600"},
	{"Faggio"},
	{"Freeway"},
	{"RC Baron"},
	{"RC Raider"},
	{"Glendale"},
	{"Oceanic"},
	{"Sanchez"},
	{"Sparrow"},
	{"Patriot"},
	{"Quad"},
	{"Coastguard"},
	{"Dinghy"},
	{"Hermes"},
	{"Sabre"},
	{"Rustler"},
	{"ZR-350"},
	{"Walton"},
	{"Regina"},
	{"Comet"},
	{"BMX"},
	{"Burrito"},
	{"Camper"},
	{"Marquis"},
	{"Baggage"},
	{"Dozer"},
	{"Maverick"},
	{"News Chopper"},
	{"Rancher"},
	{"FBI Rancher"},
	{"Virgo"},
	{"Greenwood"},
	{"Jetmax"},
	{"Hotring"},
	{"Sandking"},
	{"Blista Compact"},
	{"Police Maverick"},
	{"Boxville"},
	{"Benson"},
	{"Mesa"},
	{"RC Goblin"},
	{"Hotring Racer A"}, //hotrina
	{"Hotring Racer B"}, //hotrinb
	{"Bloodring Banger"},
	{"Rancher"},
	{"Super GT"},
	{"Elegant"},
	{"Journey"},
	{"Bike"},
	{"Mountain Bike"},
	{"Beagle"},
	{"Cropdust"},
	{"Stunt"},
	{"Tanker"}, //petro
	{"Roadtrain"},
	{"Nebula"},
	{"Majestic"},
	{"Buccaneer"},
	{"Shamal"},
	{"Hydra"},
	{"FCR-900"},
	{"NRG-500"},
	{"HPV1000"},
	{"Cement Truck"},
	{"Tow Truck"},
	{"Fortune"},
	{"Cadrona"},
	{"FBI Truck"},
	{"Willard"},
	{"Forklift"},
	{"Tractor"},
	{"Combine"},
	{"Feltzer"},
	{"Remington"},
	{"Slamvan"},
	{"Blade"},
	{"Freight"},
	{"Streak"},
	{"Vortex"},
	{"Vincent"},
	{"Bullet"},
	{"Clover"},
	{"Sadler"},
	{"Firetruck LA"}, //firela
	{"Hustler"},
	{"Intruder"},
	{"Primo"},
	{"Cargobob"},
	{"Tampa"},
	{"Sunrise"},
	{"Merit"},
	{"Utility"},
	{"Nevada"},
	{"Yosemite"},
	{"Windsor"},
	{"Monster A"}, //monstera
	{"Monster B"}, //monsterb
	{"Uranus"},
	{"Jester"},
	{"Sultan"},
	{"Stratum"},
	{"Elegy"},
	{"Raindance"},
	{"RC Tiger"},
	{"Flash"},
	{"Tahoma"},
	{"Savanna"},
	{"Bandito"},
	{"Freight Flat"}, //freiflat
	{"Streak Carriage"}, //streakc
	{"Kart"},
	{"Mower"},
	{"Duneride"},
	{"Sweeper"},
	{"Broadway"},
	{"Tornado"},
	{"AT-400"},
	{"DFT-30"},
	{"Huntley"},
	{"Stafford"},
	{"BF-400"},
	{"Newsvan"},
	{"Tug"},
	{"Trailer 3"}, //petrotr
	{"Emperor"},
	{"Wayfarer"},
	{"Euros"},
	{"Hotdog"},
	{"Club"},
	{"Freight Carriage"}, //freibox
	{"Trailer 3"}, //artict3
	{"Andromada"},
	{"Dodo"},
	{"RC Cam"},
	{"Launch"},
	{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},
	{"Police Ranger"},
	{"Picador"},
	{"S.W.A.T. Van"},
	{"Alpha"},
	{"Phoenix"},
	{"Glendale"},
	{"Sadler"},
	{"Luggage Trailer A"}, //bagboxa
	{"Luggage Trailer B"}, //bagboxb
	{"Stair Trailer"}, //tugstair
	{"Boxville"},
	{"Farm Plow"}, //farmtr1
	{"Utility Trailer"} //utiltr1
};

#pragma unused VehicleNames

stock isPlayerInRectangle(playerID, F:data[8])
{
	new F:X, F:Y, F:Z;

	GetPlayerPos(playerID, X, Y, Z);

	//first triangle
	new F:t1,F:t2,F:t3,F:t4;
	new F:a1,F:a2,F:a3;

	t1 = (((data[2] - data[4])*(data[5] - Y)) - ((data[4] - X)*(data[3] - data[5])));
	t2 = (((data[0] - data[4])*(data[3] - data[5])) - ((data[2] - data[4])*(data[1] - data[5])));
	t3 = (((data[0] - data[4])*(data[5] - Y)) - ((data[4] - X)*(data[1] - data[5])));
	t4 = (((data[2] - data[4])*(data[1] - data[5])) - ((data[0] - data[4])*(data[3] - data[5])));

	if(t2 != 0) {
		a1 = t1/t2;
	} else {
		a1 = 0;
	}
	if(t4 != 0) {
		a2 = t3/t4;
	} else {
		a2 = 0;
	}
	a3 = 1.0-a1-a2;
	if((a1 < 0) || (a2 < 0) || (a3 < 0)){
		// then the point is not inside the first triang
  		//second triangle
		t1 = (((data[6] - data[4])*(data[5] - Y)) - ((data[4] - X)*(data[7] - data[5])));
		t2 = (((data[0] - data[4])*(data[7] - data[5])) - ((data[6] - data[4])*(data[1] - data[5])));
		t3 = (((data[0] - data[4])*(data[5] - Y)) - ((data[4] - X)*(data[1] - data[5])));
		t4 = (((data[6] - data[4])*(data[1] - data[5])) - ((data[0] - data[4])*(data[7] - data[5])));

		if(t2 != 0) {
			a1 = t1/t2;
		} else {
			a1 = 0;
		}
		if(t4 != 0) {
			a2 = t3/t4;
		} else {
			a2 = 0;
		}
		a3 = 1.0-a1-a2;
		if((a1 < 0) || (a2 < 0) || (a3 < 0)){
	  		// then the point is not inside the second triang
	  		return 0;
		}
	}
	return 1;
}

#pragma unused isPlayerInRectangle

/*
native GetIP(playerid);
native GetTagName(playerid);
native GetTagClan(playerid);
native GetFullName(playerid);
native SCM(playerid,COLOR,tmp[]);
native SCMA(COLOR,tmp[]);
native AdminMessage(playerid,text[]);
native VehicleDriver(vehicleid);
native TuningCar(vid);
native GetModel();
native VehicleSize();
native isPlayerInRectangle(playerID, F:data[8]);
native IsPlayerInRadius(playerid,Float:x,Float:y,Float:r);
*/
