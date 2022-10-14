#include <a_samp>
#pragma tabsize 0
new StuntObjects[700];
new Pickups[700];
new Micon[700];
new Vehic[700];
new pick1 = 0;
new pick2 = 0;
new pick3 = 0;
new pick4 = 0;
#define VERSION 2.0
new vehName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car LS", "Police Car SF", "Police Car LV",
    "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale Shit", "Sadler Shit", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

new RandomPlayerWheels[][] = {
	{1073},
	{1074},
	{1075},
	{1076},
	{1077},
	{1078},
	{1079},
	{1080},
	{1081},
	{1082},
	{1083},
	{1084},
	{1085},
	{1096},
	{1097},
	{1098},
	{1025}
};

forward SetPlayerRandomWheels(vehicleid);

/*new SkinName[][] =
{
"CJ", //0
"Truth",//1
"Masser",//2
"XZ",//3
"",//4
"",//5
"",//6
"",//7
"",//8
"",//9
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",

};*/
#define COLOR_TEAM_GROVE 0x33AA33AA
#define COLOR_TEAM_CITIZEN 0xAA3333AA
#define COLOR_TEAM_COP 0x0000BBAA
#define COLOR_TEAM_DPS 0x0000BBAA
#define COLOR_TEAM_CLAUDE 0xFF9900AA
#define COLOR_TEAM_RICH 0xFFC0CBAA
#define COLOR_TEAM_PIMP 0xFF00FFAA
#define COLOR_TEAM_AIR 0xCCCCAAAA
#define COLOR_TEAM_CONTRY 0xAAFF00FF
#define COLOR_TEAM_HOMELESS 0xFFFFFF00
#define COLOR_TEAM_BEACH 0xFFFF00AA
#define COLOR_TEAM_TRAIN 0x808000AA
#define COLOR_TEAM_WHORE 0x33CCFFAA
#define COLOR_TEAM_AZ 0x2641FEAA
#define COLOR_TEAM_KITTY 0xC2A2DAAA
#define COLOR_TEAM_GOLF 0x80F3145FF
#define COLOR_ELVIS_TEAM 0x32CD32AA
#define COLOR_TEAM_RAP 0xC2A2DAAA
#define COLOR_FARM_COLOR 0x00004444
#define COLOR_DPS 0x00000000

#define OBJECTIVE_VEHICLE_BLUE 1
#define OBJECTIVE_COLOR 0x660000AA
#define TEAM_YELLOW_COLOR 0xFFFF00AA
#define TEAM_BLUE_COLOR 0x1C86EEAA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIGHTBLUE 0x1C86EEAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_BLUE 0x33AAAFFF
#define COLOR_GREEN 0x33AA43AA
#define COLOR_RED 0xAA4333AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_DARKRED 0x660000AA
#define COLOR_LIME 0x32CD32AA
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD1 0xB4B5B7FF

#define fix(%1) for(new i=0;i<strlen(%1);i++)if(%1[i]<0)%1[i]+=256
#define FixConsole(%1) for(new rSt;rSt<strlen(%1);rSt++) if(%1[rSt]>191 && %1[rSt]<240) %1[rSt]-=64; else if(%1[rSt]>239 && %1[rSt]<256) %1[rSt]-=16; else if (%1[rSt] == 168 ) %1[rSt]+=72; else if (%1[rSt] == 184) %1[rSt]+=57

forward SendAdminMessage(color, string[]);
forward AddAllClass(Float:x,Float:y,Float:z,Float:r,w1,a1,w2,a2,w3,a3);
forward IsValidSkin(skinid);
forward smta(const str[]);
forward cobj( modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ );
forward dobj();
forward PayPlayerInArea(Float:radi, playerid, Float:x, Float:y, Float:z, cash);
forward printr(message[]);
forward ourskins();

public printr(message[]) {
FixConsole(message);
print(message);
return 1;
}

stock M(playerid,COLOR,tmp[])
{
	fix(tmp);
	SendClientMessage(playerid,COLOR,tmp);
	return 1;
}

stock MA(COLOR,tmp[])
{
	fix(tmp);
	SendClientMessageToAll(COLOR,tmp);
	return 1;
}

public AddAllClass(Float:x,Float:y,Float:z,Float:r,w1,a1,w2,a2,w3,a3)
	for(new i; i < 300; i++)
	    if(IsValidSkin(i)) AddPlayerClass(i,x,y,z,r,w1,a1,w2,a2,w3,a3);
public IsValidSkin(skinid)
{
	#define	MAX_BAD_SKINS   14
	new badSkins[MAX_BAD_SKINS] = {
		3, 4, 5, 6, 8, 42, 65, 74, 86,
		119, 149, 208, 273, 289
	};
	if  (skinid < 0 || skinid > 299) return false;
	for (new i = 0; i < MAX_BAD_SKINS; i++) {
	    if (skinid == badSkins[i]) return false;
	}
	#undef MAX_BAD_SKINS
	return true;
}

public cobj( modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ )
{
	new objectid = CreateObject( modelid, X, Y, Z, rX, rY, rZ );
	StuntObjects[objectid] = true;
        pick2++;
        printf("Object %d created! Number %d",modelid, pick2);
}

public dobj( )
{
	for( new i = 0; i < sizeof( StuntObjects ); i ++ )
	{
		if( StuntObjects[ i ])
		{
			DestroyObject( i );
			StuntObjects[i] = false;
                        pick2 = 0;
		}
	}
}

public smta(const str[])
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
    if (IsPlayerConnected(i)) {
    if (IsPlayerAdmin(i)) {
    SendClientMessage(i, COLOR_TEAM_AZ, str);
    }
    }
    }
}

public SendAdminMessage(color, string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) && IsPlayerAdmin(i))
	{
		M(i, color, string);
		}
	}
}

public ourskins()
{
AddPlayerClass(101,1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(108,1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(98,1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
}

forward cpick( modelid, type, Float:X, Float:Y, Float:Z );

public cpick( modelid, type, Float:X, Float:Y, Float:Z )
{
	new pickid = CreatePickup( modelid, type, X, Y, Z);
	Pickups[pickid] = true;
        pick1++;
        printf("Pickup %d created! Number %d",modelid, pick1);
}

forward dpick( );
public dpick( )
{
	for( new i = 0; i < sizeof( Pickups ); i ++ )
	{
		if( Pickups[ i ])
		{
			DestroyPickup( i );
			Pickups[i] = false;
		}
	}
}

forward cic( playerid, Float:X, Float:Y, Float:Z,iconid,col);
public cic( playerid, Float:X, Float:Y, Float:Z,iconid,col)
{
	new icid = SetPlayerMapIcon( playerid, pick3, X, Y, Z,iconid,col);
	Micon[icid] = true;
        pick3++;
}

forward dic(playerid);
public dic(playerid)
{
	for( new i = 0; i < sizeof( Micon ); i ++ )
	{
		if( Micon[ i ])
		{
			RemovePlayerMapIcon(playerid, i );
			Micon[i] = false;
		}
	}
}

forward cveh( vehicleid, Float:X, Float:Y, Float:Z,Float:Angle,color1,color2,respawn,havetun);
public cveh( vehicleid, Float:X, Float:Y, Float:Z,Float:Angle,color1,color2,respawn,havetun)
{
    pick4++;
	new vehid = CreateVehicle( vehicleid, Float:X, Float:Y, Float:Z,Float:Angle,color1,color2,respawn);
	Vehic[vehid] = true;
	SetVehicleNumberPlate(vehid, "DPS_SERV");
	SetVehicleToRespawn(vehid);
    printf("Vehicle %s (ID %d) created! Tunning %d Number %d",vehName[GetVehicleModel(vehid)-400][0], vehicleid, havetun, pick4);
    if(havetun==1)
    {
    Tuncar(vehid);
    }
	else{}
}

forward dveh();
public dveh()
{
	for( new i = 0; i < sizeof( Vehic ); i ++ )
	{
		if( Vehic[ i ])
		{
			DestroyVehicle(i);
			Vehic[i] = false;
		}
	}
}

stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
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
    return 0;
}

public PayPlayerInArea(Float:radi, playerid, Float:x, Float:y, Float:z, cash)
{

	if(IsPlayerConnected(playerid))
	{
		new Float:X, Float:Y, Float:Z;

		GetPlayerPos(playerid, X, Y, Z);
		if(PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z))
		{
			GivePlayerMoney(playerid, cash);
			return 1;
		}
	}
	return 0;
}

forward Float:GetDistanceBetweenPlayers(p1,p2);
public Float:GetDistanceBetweenPlayers(p1,p2){
new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
if (!IsPlayerConnected(p1) || !IsPlayerConnected(p2)){
return -1.00;
}
GetPlayerPos(p1,x1,y1,z1);
GetPlayerPos(p2,x2,y2,z2);
return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

forward IsStringAName(string[]);
forward GetPlayerID(string[]);
//=========================[IsStringAName]======================================
public IsStringAName(string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	{
	new testname[MAX_PLAYER_NAME];
	GetPlayerName(i, testname, sizeof(testname));
	if(strcmp(testname, string, true, strlen(string)) == 0)
	{
	return 1;
}
	}
}
	return 0;
}
//=========================[GetPlayerID]========================================
public GetPlayerID(string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	{
	new testname[MAX_PLAYER_NAME];
	GetPlayerName(i, testname, sizeof(testname));
	if(strcmp(testname, string, true, strlen(string)) == 0)
	{
	return i;
}
	}
}
	return INVALID_PLAYER_ID;
}

Tuncar(vehicleid)
{
new cartype = GetVehicleModel(vehicleid);

if(cartype == 562){ //ELEGY
AddVehicleComponent(vehicleid,1146);// спойлер
AddVehicleComponent(vehicleid,1034);
AddVehicleComponent(vehicleid,1035);
AddVehicleComponent(vehicleid,1036);
AddVehicleComponent(vehicleid,1040);
AddVehicleComponent(vehicleid,1149);
AddVehicleComponent(vehicleid,1171);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 560){ //SULTAN
AddVehicleComponent(vehicleid,1139);// спойлер
AddVehicleComponent(vehicleid,1026);
AddVehicleComponent(vehicleid,1027);
AddVehicleComponent(vehicleid,1029);
AddVehicleComponent(vehicleid,1032);
AddVehicleComponent(vehicleid,1149);
AddVehicleComponent(vehicleid,1141);
AddVehicleComponent(vehicleid,1169);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 559){ //JESTER
AddVehicleComponent(vehicleid,1158);// спойлер
AddVehicleComponent(vehicleid,1162);
AddVehicleComponent(vehicleid,1159);
AddVehicleComponent(vehicleid,1160);
AddVehicleComponent(vehicleid,1069);
AddVehicleComponent(vehicleid,1070);
AddVehicleComponent(vehicleid,1067);
AddVehicleComponent(vehicleid,1065);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 575){ //BROADWAY
AddVehicleComponent(vehicleid,1042);
AddVehicleComponent(vehicleid,1044);
AddVehicleComponent(vehicleid,1174);
AddVehicleComponent(vehicleid,1176);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 558){ //URANUS
AddVehicleComponent(vehicleid,1164);// спойлер
AddVehicleComponent(vehicleid,1088);
AddVehicleComponent(vehicleid,1092);
AddVehicleComponent(vehicleid,1090);
AddVehicleComponent(vehicleid,1094);
AddVehicleComponent(vehicleid,1166);
AddVehicleComponent(vehicleid,1168);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 561){ //STRATUM
AddVehicleComponent(vehicleid,1058);// спойлер
AddVehicleComponent(vehicleid,1055);
AddVehicleComponent(vehicleid,1056);
AddVehicleComponent(vehicleid,1062);
AddVehicleComponent(vehicleid,1064);
AddVehicleComponent(vehicleid,1154);
AddVehicleComponent(vehicleid,1155);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 565){//FLASH
AddVehicleComponent(vehicleid,1049);
AddVehicleComponent(vehicleid,1046);
AddVehicleComponent(vehicleid,1047);
AddVehicleComponent(vehicleid,1051);
AddVehicleComponent(vehicleid,1054);
AddVehicleComponent(vehicleid,1150);
AddVehicleComponent(vehicleid,1153);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 576){ //TORNADO
AddVehicleComponent(vehicleid,1134);
AddVehicleComponent(vehicleid,1136);
AddVehicleComponent(vehicleid,1137);
AddVehicleComponent(vehicleid,1190);
AddVehicleComponent(vehicleid,1192);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1076);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 534){ //REMINGTON
AddVehicleComponent(vehicleid,1124);
AddVehicleComponent(vehicleid,1106);
AddVehicleComponent(vehicleid,1126);
AddVehicleComponent(vehicleid,1125);
AddVehicleComponent(vehicleid,1179);
AddVehicleComponent(vehicleid,1180);
AddVehicleComponent(vehicleid,1010);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 567){ //SAVANNA
AddVehicleComponent(vehicleid,1133); //
AddVehicleComponent(vehicleid,1130); //
AddVehicleComponent(vehicleid,1186); //
AddVehicleComponent(vehicleid,1188); //
AddVehicleComponent(vehicleid,1129); //
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 535){ //SLAMVAN
AddVehicleComponent(vehicleid,1110);
AddVehicleComponent(vehicleid,1111);
AddVehicleComponent(vehicleid,1113);
AddVehicleComponent(vehicleid,1115);
AddVehicleComponent(vehicleid,1117);
AddVehicleComponent(vehicleid,1118);
AddVehicleComponent(vehicleid,1120);
AddVehicleComponent(vehicleid,1010);
AddVehicleComponent(vehicleid,1079);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 536){ //BLADE
AddVehicleComponent(vehicleid,1182);
AddVehicleComponent(vehicleid,1184);
AddVehicleComponent(vehicleid,1107);
AddVehicleComponent(vehicleid,1108);
AddVehicleComponent(vehicleid,1010);
SetPlayerRandomWheels(vehicleid);
AddVehicleComponent(vehicleid,1087);
}

if(cartype == 415){ //CHEETAH
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 402){ //BUFFALO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 541){ //BULLET
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 602){ //ALFA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 480){ //COMET
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 405){ //SENTINEL
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 411){ //INFERNUS
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 429){ //BANSHEE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 439){ //STALLION
AddVehicleComponent(vehicleid,1013); //Фары на бампере
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 400){ //LANDSTALKER
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 445){ //ADMIRAL
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 409){ //STRETCH
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 506){ //SUPERGT
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 470){ //PATRIOT
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 489){ //RANCHER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 475){ //SABRE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 477){ //ZR350
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 479){ //REGINA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 404){ //PERENIAL
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1013); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 410){ //MANANA
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 478){ //WALTON
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1013); //Фары на бампере
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 414){ //MULE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 589){ //CLUB
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 413){ //PONY
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 401){ //BRAVURA
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 406){ //DUMPER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 407){ //FIRETRUCK
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 408){ //TRASH
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 412){ //VOODOO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 416){ //AMBULAN
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 418){ //MOONBEAM
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 419){ //ESPERANT
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 420){ //TAXI
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 421){ //WASHING
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 422){ //BOBCAT
AddVehicleComponent(vehicleid,1013); //Фары на бампере
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 423){ //MR.WHOOPY
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 424){ //BF INJECTION
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 427){ //ENFORCER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 426){ //PREMIER
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 428){ //SECURITY CAR
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 431){ //BUS
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 432){ //RHINO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 433){ //BARACKS
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 434){ //HOTKNIFE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 436){ //PREVION
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 437){ //COACH
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 438){ //CABBIE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 440){ //RUMPO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 442){ //ROMERO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 443){ //PACKER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 444){ //MONSTER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 451){ //TURISMO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 455){ //FLATBED
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 456){ //YANKEE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 457){ //CADDY
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 458){ //SOLAIR
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 459){ //TOPFUN
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 466){ //GLENDALE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 467){ //OCEANIC
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 474){ //HERMES
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 482){ //BURRITO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 483){ //CAMPER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 485){ //BAGAGE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 486){ //DOZER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 490){ //FBIRANCHER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 491){ //VIRGO
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 492){ //GREENWOOD
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 494){ //HOTRING
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 495){ //SANDKING
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 496){ //BLISTA COMPACT
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 498){ //BOXVILLE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 499){ //BENSON
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 500){ //MESA
AddVehicleComponent(vehicleid,1013); //Фары на бампере
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 502){ //HOTRINA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 503){ //HOTRINB
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 504){ //BLOODRA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 505){ //RANCHER 2
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 507){ //ELEGANT
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 508){ //JOURNEY
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 514){ //TANKER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 515){ //ROADTRAIN
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 516){ //NEBULA
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 517){ //NEBULA
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 518){ //BUCCANNEER
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1013); //Фары на бампере
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 525){ //TOWTRUCK
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 526){ //FORTUNE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 527){ //CADRONA
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 528){ //FBITRUCK
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 529){ //WILLARD
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 530){ //FORKLIFT
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 531){ //TRACTOR
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 532){ //COMBAINE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 533){ //FELTZER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 539){ //VORTEX
AddVehicleComponent(vehicleid,1010); //Nitro
}

if(cartype == 540){ //VINCENT
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 542){ //CLOVER
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 543){ //SADLER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 544){ //FIRELA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 545){ //HUSTLER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 546){ //INTRUDER
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 547){ //PRIMO
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 549){ //TAMPA
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 550){ //SUNRISE
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 551){ //MERIT
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 552){ //UTILITY
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 554){ //YOSEMITE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 555){ //WINDSOR
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 556){ //MONSTERA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 557){ //MONSTERB
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 566){ //TAHOMA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 568){ //BANDITO
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 571){ //KART
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 572){ //MOWER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 573){ //DUNERIDE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 574){ //SWEEPER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 579){ //HUNTLEY
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 580){ //STAFFORD
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 582){ //NEWSVAN
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 583){ //TUG
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 587){ //EUROS
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 585){ //EMPEROR
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 588){ //HOT-DOG
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 596){ //COPCAR LA
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 597){ //COPCAR SF
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 598){ //COPCAR VG
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 599){ //COPCAR RANCHER
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 600){ //PICADOR
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1012); //Капот (Ковш)
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 601){ //SWAT VAN
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 603){ //PHOENIX
AddVehicleComponent(vehicleid,1145); //Капот
AddVehicleComponent(vehicleid,1023); //Спойлер
AddVehicleComponent(vehicleid,1024); //Фары на бампере
AddVehicleComponent(vehicleid,1018); //Глушитель
AddVehicleComponent(vehicleid,1007); //Юбка Левая
AddVehicleComponent(vehicleid,1017); //Юбка Правая
AddVehicleComponent(vehicleid,1006); //Крыша
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}

if(cartype == 609){ //BOXVILLE
AddVehicleComponent(vehicleid,1010); //Nitro
SetPlayerRandomWheels(vehicleid); //Колеса
AddVehicleComponent(vehicleid,1087); //Гидравлика
}
}

public SetPlayerRandomWheels(vehicleid)
{
new rand = random(sizeof(RandomPlayerWheels));
AddVehicleComponent(vehicleid,RandomPlayerWheels[rand][0]);
return 1;
}


strtok(const string[], &index)
{
new length = strlen(string);
while ((index < length) && (string[index] <= ' '))
{
index++;
}
new offset = index;
new result[20];
while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
{
result[index - offset] = string[index];
index++;
}
result[index - offset] = EOS;
return result;
}
