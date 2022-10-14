#include <a_samp>
#include <lethaldudb2>
#include <dini>
#include "../include/gl_common.inc"
#include <streamer>

#pragma dynamic 145000

#define SAVE_LOGS          
#define ENABLE_SPEC         
#define USE_STATS           
#define ANTI_MINIGUN
#define ENABLE_FAKE_CMDS   	
#define MAX_WARNINGS 3      
#define MAX_REPORTS 7
#define MAX_CHAT_LINES 7
#define SPAM_MAX_MSGS 5
#define SPAM_TIMELIMIT 8 
#define PING_MAX_EXCEEDS 4
#define PING_TIMELIMIT 60
#define MAX_FAIL_LOGINS 5
#define PM_DLG_ID   31337
#define DIALOG_LOGIN 2221
#define SKINMENU 1337
#define DIALOG_REGISTER 2223
#define DIALOG_CHANGEPASS 2224
#define DIALOG_CARCOLORS 2225
#define DIALOG_CARCOLORS2 2226
#define pVip pVipp
#define pVipp pVippp
#define GivePlayerMoney GivePlayerMoneyByKRYPTODEN
#define GetPlayerMoney GetPlayerMoneyByKRYPTODEN
#define blue 0x1BA3FEFF
#define red 0xFF0000FF
#define green 0x33FF33FF
#define yellow 0xFFFF00FF
#define COLOR_RED 0xAA3333AA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define MaxSumma 20000
#define Distance 50
#define FreezeTimeDUEL 5
#define DuelAmmo 999
#define SetPlayerHoldingObject(%1,%2,%3,%4,%5,%6,%7,%8,%9) SetPlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1,%2,%3,%4,%5,%6,%7,%8,%9)
#define StopPlayerHoldingObject(%1) RemovePlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)
#define IsPlayerHoldingObject(%1) IsPlayerAttachedObjectSlotUsed(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)
#define fixchars(%1) for(new charfixloop=0;charfixloop<strlen(%1);charfixloop++)if(%1[charfixloop]<0)%1[charfixloop]+=256
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define UpperToLower(%1) for ( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32
#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2
forward CheckHealth();
forward CheckArmour();
forward ColorUpdate(playerid);
forward MSeconds();//vip colors
forward RazgruzFurui(playerid);
forward TogglePlayer(playerid);//church
forward LoadObjects();//church
forward DropPlayerWeapons(playerid);
forward DeletePickup(pickupid);
forward GetWeaponModel(weaponid);
forward Counter();
forward OnPlayerPrivmsg(playerid, recieverid, text[]);
forward SetPlayerRandomWheels(playerid);
forward SetPlayerRandomPaintjob(playerid);
new Float: PlayerHealth[MAX_PLAYERS];//античит на хп
new Float:PlayerArmor[MAX_PLAYERS];//античит на броню
new CountDown = -1;
new Colors[25] = {
0xFF0000FF, 0xFF2C00FF, 0xFF5000FF, 0xFF8700FF, 0xFFA700FF,
0xFFDC00FF, 0xFFFB00FF, 0xC4FF00FF, 0x7BFF00FF, 0x00FF00FF,
0x00FF1EFF, 0x00FF3BFF, 0x00FF7CFF, 0x00FFAEFF, 0x00FFD5FF,
0x00FFFFFF, 0x00CCFFFF, 0x00ACFFFF, 0x0083FFFF, 0x0054FFFF,
0x0000FFFF, 0x2C00FFFF, 0x5F00FFFF, 0x9B00FFFF, 0xCB00FFFF
};
new ViP[MAX_PLAYERS];
new MSecondsTimer;
new ViPColor;
new ViPColors[14] = {
0xFF0004FF,0xFF00AAFF,0xB700FFFF,0x2A00FFFF,0x00C4FFFF,0x00FFBFFF,0x00FF66FF,
0x00FF00FF,0xBFFF00FF,0xFFFB00FF,0xFF7B00FF,0xFF1500FF,0x000000FF,0xFFFFFFFF,
};
new AccType[128];
new zonezapret[MAX_PLAYERS];
new TempVehColor[MAX_PLAYERS];
new Text3D:Label[MAX_PLAYERS];
new Hentum[MAX_PLAYERS];
new numberr[MAX_PLAYERS];
new countt[MAX_PLAYERS];
new lustra[MAX_PLAYERS];
new telesnew[11][] = {
    {"{00FF00}Los Santos\t\t\t{FFFFFF}|    {00FF00}Лос Сантос\n"},
    {"{00FF1E}Las Venturas\t\t\t{FFFFFF}|    {00FF1E}Лас Вентурас\n"},
    {"{00FF3B}San Fierro\t\t\t{FFFFFF}|   {00FF3B}Сан Фиерро\n"},
    {"{00FF7C}Развлекательные Зоны\t{FFFFFF}|    {00FF7C}Stunt , Fun Zone\n"},
    {"{00FFAE}Интересные места сервера\t{FFFFFF}|    {00FFAE}Planes Zone\n"},
    {"{00FFD5}Интерьеры\t\t\t{FFFFFF}|    {00FFD5}Interior\n"},
    {"{00FFD5}Мини-города\t\t\t{FFFFFF}|    {00FFD5}Mini-City\n"},
    {"{00FFFF}Базы кланов/team\t\t{FFFFFF}|    {00FFFF}The base of the clan/team\n"},
    {"{00FFFF}Мой телепорт\t\t\t{FFFFFF}|    {00FFFF}My teleport\n"},
    {"{00FFFF}ViP Телепорты\t\t\t{FFFFFF}|    {00FFFF}ViP teleports\n"},
   {""}
};
new textdraw[11][] = {
    {"{00FF40}[Включить] {85D0F1}Часы\n"},
    {"{00FF40}[Включить] {85D0F1}GM : Deadly Game v9.4\n"},
    {"{00FF40}[Включить] {85D0F1}Level\n"},
    {"{00FF40}[Включить] {85D0F1}SCORE\n"},
    {"{00FF40}[Включить] {85D0F1}t.me/e_centersamp\n"},
    {"{FF0000}[Выключить] {85D0F1}Часы\n"},
    {"{FF0000}[Выключить] {85D0F1}GM : Deadly Game v9.4\n"},
    {"{FF0000}[Выключить] {85D0F1}Level\n"},
    {"{FF0000}[Выключить] {85D0F1}SCORE\n"},
    {"{FF0000}[Выключить] {85D0F1}t.me/e_centersamp\n"},
    {""}
};
new helpy[15][] = {
    {"{0000FF}1.{FFFF00}FAQ\n"},
    {"{0000FF}2.{FFFF00}Правила\n"},
    {"{0000FF}3.{FFFF00}Правила для Администрации\n"},
    {"{0000FF}4.{FFFF00}Команды\n"},
    {"{0000FF}5.{FFFF00}Платные услуги\n"},
    {"{0000FF}6.{FFFF00}Топ-5 Клан/Tm\n"},
    {"{0000FF}7.{FFFF00}Info Server\n"},
    {"{0000FF}8.{FFFF00}Info GangZona\n"},
    {"{0000FF}9.{FFFF00}Ранги\n"},
    {"{0000FF}10.{FFFF00}Работы\n"},
    {"{0000FF}11.{FFFF00}Новости Сервера\n"},
    {"{0000FF}12.{FFFF00}Инфо Мода\n"},
    {"{0000FF}13.{FFFF00}Создатели проекта Р-Ц\n"},
    {"{0000FF}14.{FFFF00}Связь\n"},
    {""}
};
new
	sfb[ MAX_PLAYERS ],
	gUsesBoard[ MAX_PLAYERS ],
	btimer[ MAX_PLAYERS ]
;
new church_f;//пикап входа в церковь
new church_b; //пикап выхода из церкви
new divorce; //развод
new info;   //инфо
new church;   //основной пикап церкви//church
new accept[MAX_PLAYERS]; //принятие предложения//church
new id_newlywed[MAX_PLAYERS];//ид противоположного человека//church
new newlywed[MAX_PLAYERS][256]; //имя противоположного человека//church
new Sex[MAX_PLAYERS]; //пол игрока//church
new Text3D:Rang3D[MAX_PLAYERS];//rangs
new RangStatus[MAX_PLAYERS];//rangs
new ConnectTimed[MAX_PLAYERS];
new IsConnected[MAX_PLAYERS char];
new Ceniantifloodcmd[MAX_PLAYERS];
#include <core>
#include <float>
new DropLimit=6;
static const MaxPassengers[27] =
{
    0x10331113, 0x11311131, 0x11331313, 0x80133301,
    0x1381F110, 0x10311103, 0x10001F10, 0x11113311,
    0x13113311, 0x31101100, 0x30001301, 0x11031311,
    0x11111331, 0x10013111, 0x01131100, 0x11111110,
    0x11100031, 0x11130221, 0x33113311, 0x11111101,
    0x33101133, 0x101001F0, 0x03133111, 0xFF11113F,
    0x13330111, 0xFF131111, 0x0000FF3F
}; 
new DuelOffer[MAX_PLAYERS];
new DuelPrice[MAX_PLAYERS];
new DuelStatus;
new Glava[MAX_PLAYERS];
new Duel[MAX_PLAYERS];
new Duelant[2];
new Float:MG[7][3] = {
{1733.7892,-1645.1265,23.7451},
{1708.3885,-1671.1348,20.2188},
{1713.9194,-1644.3219,20.2232},
{1710.0509,-1668.9293,27.1953},
{1733.6892,-1660.4459,27.2236},
{1709.9806,-1659.6285,23.6953},
{1726.5604,-1640.9821,23.7178}
};
new Float:MINI[7][3] = {
{959.1342,2124.6387,1011.0234},
{936.7671,2109.4885,1011.0234},
{950.5421,2146.3901,1011.0236},
{935.9015,2176.4485,1011.0234},
{964.4105,2174.9490,1011.0234},
{961.9873,2150.1130,1011.0234},
{934.2798,2144.9971,1011.0234}
};
new Float:CSS[9][3] = {
{-1326.0520,2465.1553,87.0469},
{-1300.8862,2430.1450,88.9397},
{-1270.3370,2494.7798,87.0376},
{-1297.9652,2546.9521,87.6461},
{-1313.4711,2504.7434,87.0420},
{-1344.4460,2467.4185,87.0469},
{-1387.4132,2485.0715,110.3767},
{-1345.8717,2523.3367,87.0843},
{-1365.5496,2460.4363,89.0028}
};
new StringBYVIRuS[256], Name[24];
new Float:Coords[3] =
{
270.18, 
-1836.92,
3.61
};
new BugTicks[MAX_PLAYERS] = 0;
#define SLOT 1 
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
new countpos[MAX_PLAYERS];
new Flame[MAX_PLAYERS][2];
new Fura[2];
new Pricep[10];
new Text3D:Pricep3dtext[10];
new Checkpoint[MAX_PLAYERS];
new BxodtauHa;
new tauHapriz;
new BblxodtauHa;
new pm2player_id[MAX_PLAYERS];
new pm1playerid[MAX_PLAYERS];
new FgoTimer[MAX_PLAYERS];
new BlindTimer[MAX_PLAYERS];
new ReceiverID[MAX_PLAYERS];
new gPlayerUsingLoopingAnim[MAX_PLAYERS];
new gPlayerAnimLibsPreloaded[MAX_PLAYERS];
//new WorldWeather;
new sw1,sw2,sw3,sw4,sw5,sw6,sw7,sw8,sw9,sw10,sw11,sw12;
new kissstatus[MAX_PLAYERS];
new engine,lights,alarm,doors,bonnet,boot,objective;
new neon[MAX_PLAYERS][2];
/*new RandomWeather[19][1] = {
    {0},{1},{2},{3},{4},{5},
	{6},{10},{12},{0},{1},
	{2},{8},{3},{4},{5},
	{6},{10},{12}
};*/
new iSpawnSet[MAX_PLAYERS];
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
new RandomPlayerPaintjob[][] = {
	{0},
	{1},
	{2}
};
new strR[255][255];
new Text:white;
new Text:white123;
new Text:white123321;
new Float:AnaRandomTele[8][3] = {
{2626.1492,2728.0376,36.5386},
{2637.5557,2824.1318,36.3222},
{2593.1521,2638.1763,114.0313},
{2727.2363,2687.2886,59.0234},
{2707.5530,2729.3728,10.8203},
{2649.6519,2748.3933,10.8203},
{2545.6858,2846.7632,10.8203},
{2504.3555,2823.3657,10.8203}
};
new Float:RpgTele[5][3] = {
{1614.5476,2655.1399,23.7614},
{1563.1396,2707.2427,23.7595},
{1608.4199,2705.1128,23.7891},
{1587.2338,2705.6294,23.7891},
{1592.5629,2760.9456,23.7811}
};
new Float:MRandomTele[4][3] = {
{1449.8163,-1063.7456,213.3828},
{1449.8163,-1063.7456,213.3828},
{1449.8163,-1063.7456,213.3828},
{1449.8163,-1063.7456,213.3828}
};
// Enums
enum PlayerData
{
    RanG[50],
	Registered,
	LoggedIn,
	Level,
	Muted,
	MutedTime,
	Caps,
	Jailed,
	JailTime,
	Blinded,
	BlindTime,
	Fgoed,
	FgoTime,
	Cameraed,
    CameraTime,
    Dialoged,
	DialogTime,
	Frozen,
	FreezeTime,
	Kills,
    Moneys,
	Deaths,
 	MuteWarnings,
	Warnings,
	BanWarnings,
	Spawned,
	TimesSpawned,
	God,
	GodCar,
	DoorsLocked,
	Invis,
	SpamCount,
	SpamTime,
	PingCount,
	PingTime,
	BotPing,
	pPing[PING_MAX_EXCEEDS],
	blip,
	blipS,
	pColour,
	pCar,
	SpecID,
	SpecType,
	bool:AllowedIn,
	FailLogin,
	pVip,
};
new PlayerInfo[MAX_PLAYERS][PlayerData];
enum ServerData
{
	MaxPing,
	ReadPMs,
	ReadCmds,
	MaxAdminLevel,
	AdminOnlySkins,
	AdminSkin,
	AdminSkin2,
	NameKick,
	PartNameKick,
	AntiBot,
	AntiSpam,
 	AntiSwear,
 	NoCaps,
	Locked,
	Password[128],
	GiveWeap,
	GiveMoney,
	ConnectMessages,
	AdminCmdMsg,
	AutoLogin,
	MaxMuteWarnings,
	DisableChat,
	MustLogin,
};
new ServerInfo[ServerData];
new Float:Pos[MAX_PLAYERS][4];
new Chat[MAX_CHAT_LINES][128];
new InvisTimer;
new PingTimer;
new GodTimer;
new MutedTimer[MAX_PLAYERS];
new BlipTimer[MAX_PLAYERS];
new JailTimer[MAX_PLAYERS];
new FreezeTimer[MAX_PLAYERS];
new CameraTimer[MAX_PLAYERS];
new DialogTimer[MAX_PLAYERS];
new LockKickTimer[MAX_PLAYERS];
// Forbidden Names & Words
new BadNames[100][100], // Whole Names
    BadNameCount = 0,
	BadPartNames[100][100], // Part of name
    BadPartNameCount = 0,
    ForbiddenWords[100][100],
    ForbiddenWordCount = 0;
// Report
new Reports[MAX_REPORTS][128];
new BackOut[MAX_PLAYERS];

OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
BackAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp,animback)
{
    BackOut[playerid] = animback;
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}
LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    gPlayerUsingLoopingAnim[playerid] = 1;
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}

StopLoopingAnim(playerid)
{
	gPlayerUsingLoopingAnim[playerid] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}
// Ping Kick
new PingPos;

new VehicleNames[212][] = {
"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
"Stair Trailer","Boxville","Farm Plow","Utility Trailer" };

public SetPlayerRandomWheels(playerid)
{
if (iSpawnSet[playerid] == 0)
{
new car = GetPlayerVehicleID(playerid);
new rand = random(sizeof(RandomPlayerWheels));
AddVehicleComponent(car,RandomPlayerWheels[rand][0]);
}
return 1;
}
public SetPlayerRandomPaintjob(playerid)
{
if (iSpawnSet[playerid] == 0)
{
new car = GetPlayerVehicleID(playerid);
new rand = random(sizeof(RandomPlayerPaintjob));
ChangeVehiclePaintjob(car,RandomPlayerPaintjob[rand][0]);
}
return 1;
}

public OnFilterScriptInit()
{
	print("[=========[*********]=========]");
	print("[=============================]");
	print("[=======[ FS v9.4 ]===========]");
	print("[=======[Deadly Game]=========]");
	print("[=============================]");
	print("[=========[*********]=========]");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	ConnectTimed[i] = 0;
	IsConnected{i} = 0;
	}

    BxodtauHa = CreatePickup(19130, 2, 1489.16, -1719.70, 8.24, 0);
    tauHapriz = CreatePickup(1276, 2, 313.24, -164.72, 999.60, 0);
    BblxodtauHa = CreatePickup(19130, 1, 306.76, -159.30, 999.59, 0);
    //новые дальнобойщики===========================================================
    Fura[0] = AddStaticVehicleEx(515,12.1930,-224.1917,6.4553,90.0913,-1,-1,800); 
    AddStaticVehicleEx(515,12.2435,-232.4889,6.4411,89.7957,-1,-1,800); 
    AddStaticVehicleEx(515,12.2912,-240.7080,6.4506,89.8790,-1,-1,800); 
	AddStaticVehicleEx(403,12.8029,-248.9818,6.0362,90.7330,-1,-1,800); 
	AddStaticVehicleEx(403,12.9481,-257.2370,6.0355,90.5530,-1,-1,800); 
	AddStaticVehicleEx(403,12.8305,-265.2685,6.0354,89.7056,-1,-1,800); 
	AddStaticVehicleEx(514,-18.8261,-220.4126,6.0162,175.5331,-1,-1,800); 
	AddStaticVehicleEx(514,-26.6368,-219.4905,6.0159,175.7046,-1,-1,800); 
	Fura[1] = AddStaticVehicleEx(514,-34.4157,-218.6096,6.0108,175.0944,-1,-1,800); 
    Pricep[0] = AddStaticVehicleEx(435,-55.1299,-224.4092,6.0257,266.6206,-1,-1,200); 
    Pricep[1] = AddStaticVehicleEx(435,-23.1413,-274.3386,6.0080,180.5373,-1,-1,200); 
    Pricep[2] = AddStaticVehicleEx(435,-14.7631,-274.5206,6.0191,180.1252,-1,-1,200); 
	Pricep[3] = AddStaticVehicleEx(584,-61.6196,-321.5299,6.0160,270.4092,-1,-1,200); 
	Pricep[4] = AddStaticVehicleEx(591,-61.4658,-307.4087,6.0192,270.4079,-1,-1,200); 
	Pricep[5] = AddStaticVehicleEx(450,-1.2615,-339.9842,6.0233,89.0408,-1,-1,200); 
	Pricep[6] = AddStaticVehicleEx(450,-1.2152,-322.3202,6.0038,89.9523,-1,-1,200); 
	Pricep[7] = AddStaticVehicleEx(450,-1.1001,-301.1582,6.0088,89.6910,-1,-1,200); 
	Pricep[8] = AddStaticVehicleEx(591,-116.4185,-322.6622,2.0134,179.6741,-1,-1,200); 
	Pricep[9] = AddStaticVehicleEx(584,-231.7576,-190.1307,2.0194,259.2906,-1,-1,200); 

    Pricep3dtext[0] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Аммуниция{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[0], Pricep[0], 0.0, 0.0, 0.0);
   	Pricep3dtext[1] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Спиртные напитки{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[1], Pricep[1], 0.0, 0.0, 0.0);
   	Pricep3dtext[2] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Одежда{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[2], Pricep[2], 0.0, 0.0, 0.0);
	Pricep3dtext[3] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Бензин{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[3], Pricep[3], 0.0, 0.0, 0.0);
	Pricep3dtext[4] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Замороженные продукты{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[4], Pricep[4], 0.0, 0.0, 0.0);
	Pricep3dtext[5] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Щебень{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[5], Pricep[5], 0.0, 0.0, 0.0);
	Pricep3dtext[6] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Песок{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[6], Pricep[6], 0.0, 0.0, 0.0);
	Pricep3dtext[7] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Известняк{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[7], Pricep[7], 0.0, 0.0, 0.0);
	Pricep3dtext[8] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Замороженные продукты{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[8], Pricep[8], 0.0, 0.0, 0.0);
	Pricep3dtext[9] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Бензин{ffa500}]", 0xFF9900AA, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[9], Pricep[9], 0.0, 0.0, 0.0);

//конец========================================================================
	MSecondsTimer = SetTimer("MSeconds", 100, 1);
	//SetTimer("Weather",150000,1);
	SetTimer("Counter",1000,1);//азот на мото
    SetTimer("CheckHealth",1000,1);//healthchit
    SetTimer("CheckArmour",5000,1);//armourchit1000
    SetTimer("MoneyByKRYPTODEN",2000,1);
    new Max = GetMaxPlayers();
    for(new i=0; i<Max; i++)
    {
      Rang3D[i] = Create3DTextLabel(" ",0xFFFFFFAA,0.000,0.000,-4.000,18.0,0,1);
    }
    //////church
    divorce = CreatePickup(1254,23,367.5533,2329.3040,1890.6047);
    info = CreatePickup(18631,23,368.3625,2319.4121,1890.6047);
    church = CreatePickup(1239,23,369.4337,2323.8674,1890.6047);
    church_f = CreatePickup(1239,23,561.4527,-1506.6196,14.5479);
    church_b = CreatePickup(1239,23,388.06,2324.30,1889.58);
    Create3DTextLabel("{AA22EE}[{ffcc00}Инфо{AA22EE}]",1,368.3625,2319.4121,1891.1047,261.8778,0,1);
    Create3DTextLabel("{AA22EE}[{ffcc00}Здесь Вы можете обвенчаться!!!{AA22EE}]",1,369.4337,2323.8674,1891.1047,192.7265,0,1);
    Create3DTextLabel("{AA22EE}[{ffcc00}Развод{AA22EE}]",1,367.5533,2329.3040,1891.1047,86.4329,0,1);
    LoadObjects();
    //////church
	if(!fexist("ladmin/"))
	{
	    print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
	  	SetTimerEx("PrintWarning",2500,0,"s","ladmin");
		return 1;
	}
	if(!fexist("ladmin/logs/"))
	{
	    print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
	  	SetTimerEx("PrintWarning",2500,0,"s","ladmin/logs");
		return 1;
	}
	if(!fexist("ladmin/config/"))
	{
	    print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
	  	SetTimerEx("PrintWarning",2500,0,"s","ladmin/config");
		return 1;
	}
	if(!fexist("ladmin/users/"))
	{
	    print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
	  	SetTimerEx("PrintWarning",2500,0,"s","ladmin/users");
		return 1;
	}

	UpdateConfig();

	#if defined DISPLAY_CONFIG
	ConfigInConsole();
	#endif

	///=============================================[Знак SAMP места Виневуд!]========================================
    CreateObject(18750, 1418.10, -807.83, 94.23,   91.00, 0.00, 0.00);
    CreateObject(18658, 1374.63, -804.15, 104.38,   -236.00, -251.00, 308.80);
    CreateObject(18658, 1463.63, -807.38, 96.92,   -236.00, -251.00, 32.99);
    CreateObject(18657, 1409.60, -805.79, 107.45,   105.00, 0.00, 326.61);
    CreateObject(18657, 1441.49, -806.55, 102.71,   105.00, 0.00, 0.00);

	CreateObject(19129, 1475.83398, -1415.82056, 37.75900,   0.00000, 0.00000, 0.00000);
	CreateObject(2406, 1480.95752, -1418.10913, 39.03235,   0.00000, 0.00000, 0.00000);
	CreateObject(19318, 1477.08813, -1419.86084, 38.48990,   -8.00000, 0.00000, 0.00000);
	CreateObject(19279, 1470.26184, -1411.64087, 38.00197,   0.00000, 0.00000, 0.00000);
	CreateObject(19056, 1477.09314, -1419.20178, 38.44100,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, 1466.13892, -1418.18518, 37.75900,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, 1466.01831, -1414.26221, 37.75900,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, 1466.10242, -1410.37109, 37.75900,   0.00000, 0.00000, 0.00000);
	CreateObject(19624, 1476.20642, -1416.79651, 39.81020,   0.00000, 0.00000, 0.00000);
	CreateObject(19623, 1476.39709, -1416.79871, 39.83570,   0.00000, 0.00000, 25.00000);
	CreateObject(19528, 1472.01331, -1418.75146, 38.64537,   0.00000, 0.00000, 0.00000);
	CreateObject(19078, 1474.76440, -1418.72388, 40.15800,   -11.00000, -91.00000, -171.00000);
	CreateObject(19588, 1477.34717, -1417.14636, 38.47116,   0.00000, 0.00000, 8.43351);
	CreateObject(2405, 1483.44031, -1417.83728, 38.01010,   -40.00000, -91.00000, 357.80469);
	CreateObject(180, 1477.74695, -1416.83545, 40.36380,   90.00000, 0.00000, 0.00000);
	CreateObject(18649, 1470.24451, -1418.31018, 37.87346,   0.00000, 0.00000, 8.61092);
	CreateObject(18649, 1484.45215, -1416.00403, 37.87346,   0.00000, 0.00000, 8.61092);
	CreateObject(19315, 1480.49097, -1416.66919, 39.57170,   0.00000, -8.00000, -171.00000);
	CreateObject(19338, 1466.47754, -1420.66296, 37.71236,   0.00000, 0.00000, 0.00000);
	CreateObject(643, 1473.31714, -1412.09326, 17.50710,   0.00000, 0.00000, 17.18570);
	CreateObject(641, 1468.42737, -1414.49426, 34.33858,   0.00000, 0.00000, 0.00000);
	CreateObject(641, 1485.46399, -1411.24268, 34.33858,   0.00000, 0.00000, 0.00000);
	CreateObject(641, 1484.62024, -1418.66565, 34.33858,   0.00000, 0.00000, 0.00000);
	CreateObject(19279, 1474.02893, -1411.57861, 38.00197,   0.00000, 0.00000, 0.00000);
	CreateObject(19279, 1477.71411, -1411.55286, 38.00197,   0.00000, 0.00000, 0.00000);
	CreateObject(19279, 1481.55566, -1411.61438, 38.00197,   0.00000, 0.00000, 0.00000);

	sw1 = CreateObject(19174, 1470.43701, -1409.63189, 40.39370,   0.00000, -25.00000, 0.00000);
	SetObjectMaterialText(sw1,"{6500CA}John_Vibers",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",43,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw2 = CreateObject(19174, 1472.68115, -1409.63189, 40.04620,   0.00000, -10.00000, 0.00000);
	SetObjectMaterialText(sw2,"{00FF00}UNCLERUS",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",43,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw3 = CreateObject(19174, 1472.16187, -1409.63189, 39.07050,   0.00000, 18.00000, 0.00000);
	SetObjectMaterialText(sw3,"{FF80FF}VladSem",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",43,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw4 = CreateObject(19174, 1472.68115, -1409.63189, 41.06720,   0.00000, 11.00000, 0.00000);
	SetObjectMaterialText(sw4,"{FF0000}TimyrSem",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",43,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw5 = CreateObject(19174, 1474.51013, -1409.64490, 38.76650,   0.00000, 34.00000, 0.00000);
	SetObjectMaterialText(sw5,"{FFFFFF}SeriousSam",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",32,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw6 = CreateObject(19174, 1474.81812, -1409.63189, 40.52520,   0.00000, -4.00000, 0.00000);
	SetObjectMaterialText(sw6,"{F0E68C}Saintunclesam",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",45,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw7 = CreateObject(19174, 1476.46704, -1409.63189, 39.06750,   0.00000, 33.00000, 0.00000);
	SetObjectMaterialText(sw7,"{383838}John_Marston",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",35,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw8 = CreateObject(19329, 1480.26672, -1409.65112, 40.29221,   0.00000, 0.00000, 0.00000);
	SetObjectMaterialText(sw8,"{FF0000}Развлекательный",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",43,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw9 = CreateObject(19329, 1480.98669, -1409.65112, 39.67810,   0.00000, 0.00000, 0.10400);
	SetObjectMaterialText(sw9,"{FF0000}Центр",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",48,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw10 = CreateObject(19329, 1478.54663, -1409.65698, 40.67770,   0.00000, -33.00000, 0.00000);
	SetObjectMaterialText(sw10,"{FC911B}A",0,OBJECT_MATERIAL_SIZE_256x128,"Wingdings",130,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw11 = CreateObject(19329, 1482.16675, -1409.65112, 38.85030,   0.00000, 0.00000, 0.00000);
	SetObjectMaterialText(sw11,"{FC911B}C",0,OBJECT_MATERIAL_SIZE_256x128,"Wingdings",130,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	sw12 = CreateObject(19329, 1479.74670, -1409.65112, 38.95030,   0.00000, 0.00000, 0.00000);
	SetObjectMaterialText(sw12,"{FF0000}<< 2021 >>",0,OBJECT_MATERIAL_SIZE_256x128,"Comic Sans MS",70,1,0xFFFFFFFF,0x00, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);


   	/*//=============================================[Выбор скинов с оленями v9.4]========================================
    CreateObject(16133,465.2700000,-1856.7600000,-0.7700000,0.0000000,0.0000000,266.1700000);
    CreateObject(18841,469.7200000,-1861.1400000,4.4600000,-4.0000000,75.0000000,0.8200000);
    CreateObject(19129,463.5000000,-1872.5000000,2.4100000,0.0000000,0.0000000,0.0000000);
    CreateObject(19129,481.0000000,-1872.4900000,2.4100000,0.0000000,0.0000000,0.0000000);
    CreateObject(19129,453.9000000,-1872.4900000,-7.5700000,0.0000000,-92.0000000,0.0000000);
    CreateObject(19129,463.5500000,-1882.1100000,-7.6700000,0.0000000,-92.0000000,90.0200000);
    CreateObject(19129,481.0100000,-1882.0800000,-7.6700000,0.0000000,-92.0000000,90.0200000);
    CreateObject(19129,490.6400000,-1872.4400000,-7.5700000,0.0000000,-92.0000000,180.0300000);
    CreateObject(3437,457.8900000,-1869.2700000,1.7000000,0.0000000,0.0000000,0.0000000);
    CreateObject(3437,486.1100000,-1869.2900000,1.7000000,0.0000000,0.0000000,-6.0000000);
    CreateObject(3437,462.8400000,-1869.0300000,4.4000000,0.0000000,0.0000000,0.0000000);
    CreateObject(3437,480.9000000,-1869.4500000,4.4000000,0.0000000,0.0000000,354.3500000);
    CreateObject(3437,468.4100000,-1869.0500000,7.0200000,0.0000000,0.0000000,354.3500000);
    CreateObject(3437,475.5000000,-1869.2900000,7.0200000,0.0000000,0.0000000,354.3500000);
    CreateObject(2232,468.3700000,-1869.4100000,5.6900000,0.0000000,0.0000000,355.9800000);
    CreateObject(8615,451.7000000,-1883.3300000,0.6600000,0.0000000,0.0000000,359.9000000);
    CreateObject(621,449.5000000,-1878.6500000,0.5500000,0.0000000,0.0000000,0.0000000);
    CreateObject(621,493.2900000,-1879.3200000,0.1500000,0.0000000,0.0000000,0.0000000);
    CreateObject(2232,475.7000000,-1869.7000000,5.6900000,0.0000000,0.0000000,355.9800000);
    CreateObject(18102,468.1000000,-1867.5100000,11.8300000,0.0000000,0.0000000,-185.0000000);
    CreateObject(2232,468.3700000,-1869.4100000,9.9200000,0.0000000,0.0000000,355.9800000);
    CreateObject(2232,475.5600000,-1869.6600000,9.8600000,0.0000000,0.0000000,355.9800000);
    CreateObject(18646,457.2100000,-1882.4000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,458.4800000,-1882.3800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,459.7300000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,462.2700000,-1882.4200000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,460.9900000,-1882.3800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,463.4700000,-1882.4200000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,464.7200000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,465.9700000,-1882.4000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,467.2200000,-1882.4000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,468.5300000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,471.0800000,-1882.4300000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,469.7900000,-1882.4100000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,472.2800000,-1882.4200000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,473.4700000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,474.7600000,-1882.4000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,475.9900000,-1882.3700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,477.2600000,-1882.3800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,478.5200000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,479.7800000,-1882.3700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,481.0000000,-1882.3600000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,482.2600000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,483.4900000,-1882.3700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,484.7300000,-1882.3800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,486.0100000,-1882.3600000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,487.2800000,-1882.3700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,488.5300000,-1882.3900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,489.7900000,-1882.3600000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8900000,-1882.3700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9600000,-1881.2700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9500000,-1880.0300000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9300000,-1878.7700000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9100000,-1877.5000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8900000,-1876.2200000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8800000,-1874.9800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8900000,-1873.7500000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8900000,-1872.4800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8900000,-1871.2400000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9200000,-1869.9600000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9100000,-1868.7200000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.9200000,-1867.4800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8900000,-1866.1600000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,490.8100000,-1864.7100000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,456.0000000,-1882.4300000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5900000,-1882.4000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5900000,-1881.2000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.6000000,-1879.9800000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.6000000,-1878.7100000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.6100000,-1877.4900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5600000,-1876.2100000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5700000,-1875.0000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5700000,-1873.7300000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5700000,-1872.4900000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5900000,-1871.2200000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5900000,-1869.9300000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5800000,-1868.7300000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.6200000,-1867.5000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.6000000,-1866.2100000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(18646,453.5600000,-1865.0000000,2.5700000,0.0000000,0.0000000,0.0000000);
    CreateObject(3438,466.0300000,-1881.8100000,4.0500000,0.0000000,0.0000000,89.4600000);
    CreateObject(18102,462.1200000,-1879.7500000,8.9600000,0.0000000,0.0000000,177.6600000);
    CreateObject(3438,478.5700000,-1881.9000000,4.0500000,0.0000000,0.0000000,89.4600000);
    CreateObject(18102,474.2700000,-1879.6900000,8.9600000,0.0000000,0.0000000,177.6600000);
    CreateObject(19081,480.7200000,-1869.4400000,9.8300000,0.0000000,0.0000000,247.0000000);
    CreateObject(19084,462.8900000,-1869.3900000,9.0000000,0.0000000,0.0000000,-84.0000000);
    CreateObject(19123,472.3600000,-1881.8500000,2.8700000,0.0000000,0.0000000,0.0000000);
    CreateObject(19159,478.4700000,-1881.8800000,9.3900000,0.0000000,0.0000000,0.0000000);
    CreateObject(19159,465.9900000,-1881.8200000,9.3900000,0.0000000,0.0000000,0.0000000);
    CreateObject(19315,473.2100000,-1883.3700000,1.6100000,0.0000000,0.0000000,0.0000000);
    CreateObject(19315,474.6100000,-1887.0500000,1.6100000,0.0000000,0.0000000,-171.0000000);
    CreateObject(19315,478.8500000,-1884.8400000,1.6100000,0.0000000,0.0000000,-207.0000000);
    CreateObject(19315,479.0900000,-1884.9300000,1.8100000,4.0000000,-40.0000000,-207.0000000);
    CreateObject(19346,473.6400000,-1883.3400000,1.8900000,-40.0000000,-4.0000000,0.0000000);
   	///=============================================[Выбор скинов с оленями v9.2]========================================
    CreateObject(19128, 1992.18, 990.16, 38.10,   0.00, 0.00, 0.00);
    CreateObject(19128, 1988.26, 990.14, 38.10,   0.00, 0.00, 0.00);
    CreateObject(19128, 1984.31, 990.12, 38.10,   0.00, 0.00, 0.00);
    CreateObject(19128, 1985.90, 994.10, 38.10,   0.00, 0.00, 0.00);
    CreateObject(19128, 1985.88, 996.47, 38.10,   0.00, 0.00, 0.00);
    CreateObject(19129, 1997.74, 1001.36, 38.10,   0.00, 0.00, 0.00);
    CreateObject(2406, 1983.91, 974.37, 42.00,   5.00, 0.00, 91.00);
    CreateObject(2406, 1983.87, 975.38, 43.32,   0.00, 69.00, 89.00);
    CreateObject(2406, 1983.92, 975.44, 41.13,   0.00, 71.00, 84.00);
    CreateObject(2406, 1984.03, 976.30, 40.42,   0.00, -4.00, 86.26);
    CreateObject(2406, 1984.04, 975.40, 38.81,   0.00, 69.00, 89.00);
    CreateObject(2406, 1983.86, 980.23, 42.40,   1.00, -8.00, 91.00);
    CreateObject(2406, 1983.86, 980.54, 40.09,   1.00, -8.00, 91.00);
    CreateObject(2406, 1983.86, 981.22, 40.09,   1.00, 25.00, 91.00);
    CreateObject(2406, 1983.85, 982.21, 40.09,   1.00, -25.00, 91.00);
    CreateObject(2406, 1983.90, 983.07, 40.09,   1.00, 18.00, 91.00);
    CreateObject(2406, 1983.89, 983.77, 42.27,   1.00, 18.00, 91.00);
    CreateObject(2405, 1983.87, 978.30, 41.20,   -183.00, -271.00, -91.00);
    CreateObject(19317, 1984.13, 992.56, 38.90,   -18.00, -4.00, 84.00);
    CreateObject(19318, 1984.22, 994.02, 38.74,   -25.00, 11.00, 120.00);
    CreateObject(19123, 1994.03, 988.27, 38.71,   0.00, 0.00, 0.00);
    CreateObject(19125, 1984.07, 994.88, 38.61,   0.00, 0.00, 0.00);
    CreateObject(19056, 1984.57, 988.73, 38.71,   0.00, 0.00, 0.00);
    CreateObject(19167, 1983.91, 991.10, 39.27,   -89.00, 2.00, 91.00);
    CreateObject(19279, 1983.99, 975.43, 37.90,   33.00, 0.00, 91.00);
    CreateObject(19315, 1995.86, 992.75, 38.65,   0.00, 0.00, 113.00);
    CreateObject(19314, 1995.74, 993.02, 39.10,   33.00, -273.00, 25.00);
    CreateObject(19315, 1992.27, 996.01, 38.65,   0.00, 0.00, -40.00);
    CreateObject(19315, 1992.11, 996.15, 38.75,   4.00, -25.00, -40.00);
    CreateObject(19125, 1983.79, 989.03, 42.70,   0.00, 0.00, 0.00);
    CreateObject(19125, 1983.79, 989.03, 41.78,   0.00, 0.00, 0.00);
    CreateObject(19125, 1983.83, 989.79, 41.58,   0.00, 0.00, 0.00);
    CreateObject(19125, 1983.83, 989.79, 42.59,   0.00, 0.00, 0.00);
    CreateObject(19125, 1983.82, 990.28, 42.08,   -88.00, -6.00, 354.00);
    CreateObject(19125, 1983.81, 990.60, 41.67,   0.00, 0.00, 0.00);
    CreateObject(19125, 1983.82, 990.28, 43.00,   -88.00, -6.00, 354.00);
    CreateObject(19125, 1983.82, 990.28, 41.07,   -88.00, -6.00, 354.00);
    CreateObject(19125, 1983.79, 989.03, 41.48,   0.00, 0.00, 0.00);
    CreateObject(19125, 1983.80, 991.65, 42.08,   -88.00, -6.00, 354.00);
    CreateObject(19125, 1983.80, 991.57, 42.08,   0.00, 0.00, 0.00);
    CreateObject(19279, 1984.02, 982.55, 37.90,   33.00, 0.00, 91.00);
    CreateObject(19279, 1984.05, 982.05, 44.22,   -47.00, 181.00, 90.16);
    CreateObject(19279, 1984.00, 975.94, 44.22,   -47.00, 181.00, 90.16);
    *///================================================================================================
	
    white = TextDrawCreate(0,0," white");
	TextDrawFont(white,1);
	TextDrawLetterSize(white,1000,1000);
	TextDrawBoxColor(white,0xFFFFFFAA);
	TextDrawUseBox(white,1);
	white123 = TextDrawCreate(0,0," black");
	TextDrawFont(white123,1);
	TextDrawLetterSize(white123,1000,1000);
	TextDrawBoxColor(white123,0xFFFFFFAA);
	TextDrawUseBox(white123,1);
	white123321 = TextDrawCreate(0,0," blue");
	TextDrawFont(white123321,1);
	TextDrawLetterSize(white123321,1000,1000);
	TextDrawBoxColor(white123321,0xFFFFFFAA);
	TextDrawUseBox(white123321,1);

	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) OnPlayerConnect(i);
	for(new i = 1; i < MAX_CHAT_LINES; i++) Chat[i] = "<none>";
	for(new i = 1; i < MAX_REPORTS; i++) Reports[i] = "<none>";

	PingTimer = SetTimer("PingKick",5000,1);
	GodTimer = SetTimer("GodUpdate",2000,1);

	new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);

	print("|========================================|");
	print("| =========[Deadly Game FS 9.4]========= |");
	print("|  =============[Loaded]===============  |");
	print("|   ==================================   |");
	printf("|   = Date: %d/%d/%d  Time: %d:%d:%d =   |",day,month,year, hour, minute, second);
	print("|   ==================================   |");
	print("|  ====================================  |");
	print("| ====================================== |\n");

//важно=========================================================================
    if(!fexist("wedding/"))
    {
        print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
        SetTimerEx("PrintWarningstole",2500,0,"s","simpledm");
        return 1;
    }
    if(!fexist("afk/"))
    {
        print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
        SetTimerEx("PrintWarningstole",2500,0,"s","simpledm");
        return 1;
    }
    if(!fexist("matoff/"))
    {
        print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
        SetTimerEx("PrintWarningstole",2500,0,"s","simpledm");
        return 1;
    }
    if(!fexist("musor/"))
    {
        print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
        SetTimerEx("PrintWarningstole",2500,0,"s","simpledm");
        return 1;
    }
    if(!fexist("afker/"))
    {
        print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
        SetTimerEx("PrintWarningstole",2500,0,"s","simpledm");
        return 1;
    }
	return 1;
}

public OnFilterScriptExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	ConnectTimed[i] = 0;
	IsConnected{i} = 0;
	}
	KillTimer(PingTimer);
	KillTimer(GodTimer);
	KillTimer(MSecondsTimer);
	if(InvisTimer) KillTimer(InvisTimer);

	new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);
	print("\n________________________________________");
	print("________________________________________");
	print("       Deadly Game FS 9.4 Unloaded      ");
	print("________________________________________");
	printf("     Date: %d/%d/%d  Time: %d:%d :%d   ",day,month,year, hour, minute, second);
	print("________________________________________");
	print("________________________________________\n");
	return 1;
}
////church
stock PlayerNamerr(playerid){
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid,pname,sizeof(pname));
return pname;}
IsNumericc(const stringg[])
{
    for (new i = 0, j = strlen(stringg); i < j; i++)
    {
        if (stringg[i] > '9' || stringg[i] < '0') return 0;
    }
    return 1;
}////church

public OnPlayerConnect(playerid)
{
	if((GetTickCount() - ConnectTimed[playerid]) <= 500) return BanEx(playerid,"MainProtectBot");
	ConnectTimed[playerid] = GetTickCount();

	if(IsConnected{playerid} == 2)return BanEx(playerid,"BotProtect");
	IsConnected{playerid} += 1;

	new ip[2][16];
	GetPlayerIp(playerid,ip[0],16);
	for(new i, m = GetMaxPlayers(), x; i != m; i++)
	{
	if(!IsPlayerConnected(i) || i == playerid) continue;
	GetPlayerIp(i,ip[1],16);
	if(!strcmp(ip[0],ip[1],true)) x++;
	if(x > 2) return Kick(i),print("Kick Bot");
	}

//анти лоад зашита
	BugTicks[playerid] = 0;
//Зашита NPC
	if(IsPlayerNPC(playerid)) return BanEx(playerid,"Автоматический бан: NPC");

    ViP[playerid] = 0;
//азот на мото
	countpos[playerid] = 0;
	Ceniantifloodcmd[playerid] = 0;
//дальнобойщики новые===
	Checkpoint[playerid]=0;
//adminlabel=================================
	KillTimer(countt[playerid]);
	numberr[playerid] = 0;
    Hentum[playerid] = 0;
    Label[playerid] = Create3DTextLabel("",0,30.0,40.0,50.0,70.0,0,1); //По стандарту 0,30.0,40.0,50.0,70.0,0,1
    Attach3DTextLabelToPlayer(Label[playerid], playerid, 0.0, 0.0, 0.4);

//adminlabel=================================
    PlayerHealth[playerid] = 0;
	gPlayerUsingLoopingAnim[playerid] = 0;
	gPlayerAnimLibsPreloaded[playerid] = 0;
    zonezapret[playerid] = 1000;
    kissstatus[playerid] = 0;
	PlayerInfo[playerid][Deaths] = 0;
	PlayerInfo[playerid][Kills] = 0;
	PlayerInfo[playerid][Jailed] = 0;
	PlayerInfo[playerid][Frozen] = 0;
	PlayerInfo[playerid][Level] = 0;
	PlayerInfo[playerid][LoggedIn] = 0;
	PlayerInfo[playerid][Registered] = 0;
	PlayerInfo[playerid][God] = 0;
	PlayerInfo[playerid][GodCar] = 0;
	PlayerInfo[playerid][Dialoged] = 0;
	PlayerInfo[playerid][Cameraed] = 0;
	PlayerInfo[playerid][Blinded] = 0;
	PlayerInfo[playerid][pVippp] = 0;
	PlayerInfo[playerid][Fgoed] = 0;
	PlayerInfo[playerid][TimesSpawned] = 0;
	PlayerInfo[playerid][Muted] = 0;
	PlayerInfo[playerid][MuteWarnings] = 0;
	PlayerInfo[playerid][Warnings] = 0;
	PlayerInfo[playerid][BanWarnings] = 0;
	PlayerInfo[playerid][Caps] = 0;
	PlayerInfo[playerid][Invis] = 0;
	PlayerInfo[playerid][DoorsLocked] = 0;
	PlayerInfo[playerid][pCar] = -1;
	for(new i; i<PING_MAX_EXCEEDS; i++) PlayerInfo[playerid][pPing][i] = 0;
	PlayerInfo[playerid][SpamCount] = 0;
	PlayerInfo[playerid][SpamTime] = 0;
	PlayerInfo[playerid][PingCount] = 0;
	PlayerInfo[playerid][PingTime] = 0;
	PlayerInfo[playerid][FailLogin] = 0;

	new PlayerName[MAX_PLAYER_NAME], file[256];
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	new tmp3[256]; tmp3 = dini_Get(file,"ip");
	
	if(ServerInfo[ConnectMessages] == 1)
	{
		new string[255], str[254];
	    new pAKA[256]; pAKA = dini_Get("ladmin/config/aka.txt",tmp3);
		if (strlen(pAKA) < 3) format(str,sizeof(str),"{8b00ff}*** {FF0000}%s (%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
		else if (!strcmp(pAKA,PlayerName,true)) format(str,sizeof(str),"{8b00ff}*** {FF0000}%s (%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
		else format(str,sizeof(str),"{8b00ff}*** {FF0000}%s (%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
		format(string, sizeof(string), "{8b00ff}*** {FF0000}%s (%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
        print(string);

		for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i)
		{
			if(PlayerInfo[i][Level] >= 5) SendClientMessage(i,green,str);
			else {
				format(string,sizeof(string),"{8b00ff}*** {FF0000}%s (%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
			 	SendClientMessage(i,green,string);
			}
		}
	}

/*	if(ServerInfo[ConnectMessages] == 1)
	{
		new string[255], str[254];
	    new pAKA[256]; pAKA = dini_Get("ladmin/config/aka.txt",tmp3);
		if (strlen(pAKA) < 3) format(str,sizeof(str),"{8b00ff}*  {FF0000}%s(%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
		else if (!strcmp(pAKA,PlayerName,true)) format(str,sizeof(str),"{8b00ff}*  {FF0000}%s(%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
		else format(str,sizeof(str),"{8b00ff}*** {FF0000}%s(%d) {8b00ff}вошел(ла) в игру (ники: %s)", PlayerName, playerid, pAKA );

		for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i)
		{
			if(PlayerInfo[i][Level] > 2) SendClientMessage(i,0xC0C0C0FF,str);
			else {
				format(string,sizeof(string),"{8b00ff}* {FF0000}%s(%d) {8b00ff}вошел(ла) в игру", PlayerName, playerid);
			 	SendClientMessage(i,0xC0C0C0FF,string);
			}
		}
	}
	  if (dUserINT(PlayerName2(playerid)).("banned") == 1)
    {
		new string[240];
        SendClientMessage(playerid, red, "Ты забанен на этом сервере!");
		format(string,sizeof(string)," %s(%d) был автоматически забанен. (Причина: Обход Бана!)",PlayerName,playerid);
		SendClientMessageToAll(COLOR_RED, string);  print(string);
		SaveToFile("KickLog",string);
		BanEx(playerid,"BannedName - ReBanned");
    }*/
	if(ServerInfo[NameKick] == 1) {
    new string[213];
	for(new s = 0; s < BadNameCount; s++) {
	if(!strcmp(BadNames[s],PlayerName,true)) {
	SendClientMessage(playerid,red, "Ваше имя находится в черном списке!");
	format(string,sizeof(string)," %s(%d) был автоматически кикнут. (Причина: Имя в черном списке)",PlayerName,playerid);
	SendClientMessageToAll(COLOR_RED, string);  print(string);
	SaveToFile("KickLog",string);  Kick(playerid);
	}
	}
	}
	if(ServerInfo[PartNameKick] == 1) {
	  new string[225];
      for(new s = 0; s < BadPartNameCount; s++) {
			new pos;
			while((pos = strfind(PlayerName,BadPartNames[s],true)) != -1) for(new i = pos, j = pos + strlen(BadPartNames[s]); i < j; i++)
			{
				SendClientMessage(playerid,red, "Ваш ник запрещен на сервере.");
				format(string,sizeof(string)," %s(%d) был автоматически кикнут. (Причина: Запрещенный ник)",PlayerName,playerid);
				SendClientMessageToAll(COLOR_RED, string);  print(string);
				SaveToFile("KickLog",string);  Kick(playerid);
			}
		}
	}
	if(ServerInfo[Locked] == 1) {

		SendClientMessage(playerid,red,"Сервер закрыт!  Вы можете открыть сервер или через 20сек. вас кикнет!");
		SendClientMessage(playerid,red," Используйте команду /password [пароль]");
		LockKickTimer[playerid] = SetTimerEx("AutoKick", 20000, 0, "i", playerid);
	}
	if(strlen(dini_Get("ladmin/config/aka.txt", tmp3)) == 0) dini_Set("ladmin/config/aka.txt", tmp3, PlayerName);
 	else
	{
	    if( strfind( dini_Get("ladmin/config/aka.txt", tmp3), PlayerName, true) == -1 )
		{
			new string[230];
		    format(string,sizeof(string),"%s,%s", dini_Get("ladmin/config/aka.txt",tmp3), PlayerName);
		    dini_Set("ladmin/config/aka.txt", tmp3, string);
		    return 1;
		}
	}
/////church
    Sex[playerid] = 0;
    new fn[256];
    format (fn,256,"wedding/%s.ini",PlayerNamerr(playerid));
    if(!dini_Exists(fn))
    {
        dini_Create(fn);
        dini_IntSet(fn,"newlywed",0);
    }
    else
    {
        newlywed[playerid] = dini_Get(fn,"newlywed");
    }

/////church»
//	new rstring[1000];
//	if(!udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
//	format(rstring,1000,"\n{42aaff}Добро пожаловать на {00ff00}..::Развлекательный Центр::..\n\n{42aaff}» Официальная группа сервера {00ff00}https://t.me/e_centersamp\n{42aaff}» Официальная сайт сервера {00ff00}https://t.me/e_centersamp\n\n{42aaff}Гл.Теам сервера : {FF0000}ELISIYM\n\n{42aaff}Аккаунт {ff0000}'%s' {42aaff}не зарегистрирован!\n\n{42aaff}Пожалуйста, введите Ваш будущий пароль от аккаунта:\n\n",pName(playerid));
//	ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,"{00FFD5}Регистрация",rstring,"Ок","");
    GivePlayerMoney(playerid,20000);
    
	return 1;
	}

forward AutoKick(playerid);
public AutoKick(playerid)
{
	if( IsPlayerConnected(playerid) && ServerInfo[Locked] == 1 && PlayerInfo[playerid][AllowedIn] == false) {
		new string[128];
		SendClientMessage(playerid,COLOR_RED," Вы были кикнуты системой. (Причина: Сервер закрыт)");
		format(string,sizeof(string)," %s(%d) был автоматически кикнут. (Причина: Сервер закрыт)",PlayerName2(playerid),playerid);
		SaveToFile("KickLog",string);  Kick(playerid);
		SendClientMessageToAll(COLOR_RED, string); print(string);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    zonezapret[playerid] = 1000;
    IsConnected{playerid} = 0;
    //отключяет автоматом команду  миргание ника====================================
    new count[MAX_PLAYERS];
    new number[MAX_PLAYERS];
    KillTimer(count[playerid]);
    Update3DTextLabelText(Label[playerid], Colors[number[playerid]], "");
    Hentum[playerid] = 0;
    //2 миганик красный зелённый====================================================
    new player1;
    KillTimer( BlipTimer[player1] );
    PlayerInfo[player1][blip] = 0;
    SetPlayerColor(playerid, PlayerInfo[playerid][pColour] );
    //конец 2 команды===============================================================
	if( gUsesBoard[ playerid ] == 1 ) {
	    KillTimer( btimer[ playerid ] );
	    gUsesBoard[ playerid ] = 0;
	    DestroyObject( sfb[ playerid ] );
	}
    //дуэль=========================================================================
    if(Duel[playerid] != 0)
	{
        new givename[255];
        GetPlayerName(DuelOffer[playerid],givename,sizeof(givename));
        new string[256];
	    new ammo = GetPlayerAmmo(DuelOffer[playerid]);
		GivePlayerWeapon(DuelOffer[playerid],25,-ammo);
		SendClientMessage(DuelOffer[playerid],-1,"{CC00DD}[Дуэль]{993344}Вы выйграли!!");
		SpawnPlayer(DuelOffer[playerid]);
		SpawnPlayer(playerid);//mine
		Duel[DuelOffer[playerid]] = 0;
		DuelOffer[DuelOffer[playerid]] = 999;
		DuelPrice[DuelOffer[playerid]] = 0;
		Duel[playerid] = 0;
		DuelOffer[playerid] = 999;
		DuelPrice[playerid] = 0;
		TogglePlayerControllable(DuelOffer[playerid],1);
		DuelStatus = 0;
		format(string, sizeof(string), "{CC00DD}[НОВОСТИ]: {993344}В Дуэли победил {88FF00}%s",givename);//
        SendClientMessageToAll(0xB0B0FFAA,string);//
		new name[255];//проигравший
  		GetPlayerName(playerid,name,sizeof(name));
   		if(udb_UserIsset(givename,"duelwin")) udb_UserSetInt(givename,"duelwin", udb_UserInt(givename,"duelwin") + 1); else udb_UserSetInt(givename,"duelwin", 1);
		if(udb_UserIsset(name,"duelloose")) udb_UserSetInt(name,"duelloose", udb_UserInt(name,"duelloose") + 1); else udb_UserSetInt(name,"duelloose", 1);
	}
    ///дуэль
    //азот на мото
    if(countpos[playerid] != 0)
	{
		countpos[playerid] = 0;
		DestroyObject(Flame[playerid][0]);
		DestroyObject(Flame[playerid][1]);
	}

	if(PlayerInfo[playerid][LoggedIn] == 1)	SavePlayer(playerid);
	if(udb_Exists(PlayerName2(playerid))) dUserSetINT(PlayerName2(playerid)).("loggedin",0);
  	PlayerInfo[playerid][LoggedIn] = 0;
	PlayerInfo[playerid][Level] = 0;
	PlayerInfo[playerid][Jailed] = 0;
	PlayerInfo[playerid][Frozen] = 0;
	PlayerInfo[playerid][Cameraed] = 0;
	PlayerInfo[playerid][Dialoged] = 0;
	PlayerInfo[playerid][Fgoed] = 0;
	PlayerInfo[playerid][Blinded] = 0;
	PlayerInfo[playerid][pVippp] = 0;
	PlayerInfo[playerid][Muted] = 0;
	PlayerInfo[playerid][Moneys] = 0;
	if(PlayerInfo[playerid][Dialoged] == 1)
	{
		KillTimer( DialogTimer[playerid] );
	}
	if(PlayerInfo[playerid][Fgoed] == 1)
	{
		KillTimer( FgoTimer[playerid] );
	}
	if(PlayerInfo[playerid][Blinded] == 1)
	{
		KillTimer( BlindTimer[playerid] );
	}
	if(PlayerInfo[playerid][pCar] != -1 )
    {
    	CarDeleter(PlayerInfo[playerid][pCar]);
    }
	if(PlayerInfo[playerid][Cameraed] == 1)
	{
		KillTimer( CameraTimer[playerid] );
	}
    if(PlayerInfo[playerid][Muted] == 1) KillTimer( MutedTimer[playerid] );
	if(PlayerInfo[playerid][Jailed] == 1) KillTimer( JailTimer[playerid] );
	if(PlayerInfo[playerid][Frozen] == 1) KillTimer( FreezeTimer[playerid] );
	if(ServerInfo[Locked] == 1)	KillTimer( LockKickTimer[playerid] );

	if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);

	new str[256];
    switch (reason) {
         case 0: format(str, sizeof(str), "{8b00ff}***{FF0000} %s(%d) {8b00ff}вышел(ла) из игры {FF0000}(Вылет)", PlayerName2(playerid), playerid),SendClientMessageToAll(0xC0C0C0FF, str);
         case 1: format(str, sizeof(str), "{8b00ff}***{FF0000} %s(%d) {8b00ff}вышел(ла) из игры {FF0000}(Выход)", PlayerName2(playerid), playerid),SendClientMessageToAll(0xC0C0C0FF, str);
		}

	#if defined ENABLE_SPEC
	for(new x=0; x<MAX_PLAYERS; x++)
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid)
   		   	AdvanceSpectate(x);
	#endif

 	return 1;
}

forward DelayKillPlayer(playerid);
public DelayKillPlayer(playerid)
{
	SetPlayerHealth(playerid,0.0);
	ForceClassSelection(playerid);
}

public OnPlayerRequestClass(playerid, classid)
{
// Request Register
    new plName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, plName, MAX_PLAYER_NAME);
	if(!udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
	{
		new rstring[4000];
		strins(rstring,"{42aaff}Добро пожаловать на {00ff00}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\r\n",strlen(rstring));
		strins(rstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(rstring));
		strins(rstring,"{42aaff}» Официальная группа сервера {00ff00}t.me/e_centersamp\r\n",strlen(rstring));
		strins(rstring,"{42aaff}» Официальный сайт сервера {00ff00}t.me/e_centersamp\r\n",strlen(rstring));
		strins(rstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(rstring));
		strins(rstring,"{42aaff}Вы можете у нас:\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Купить себе дом в Los Santos'e!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Поездить по большим Stunt-зонам нашего сервера!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Провести мероприятие в барах, в кафе, в ресторанах!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Положить деньги в банк!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Получить деньги за работу: Курьер , Археолог , Водолаз , Дальнобойщик , Грузчик , Золотник!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Пополнить себе жизни в ларьках по всему SA!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Купить оружие в автоматах по всему SA!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Употребить наркотики на пляже Los Santos!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Поиграть в Мини-Игры и получить приз!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Погонять на гоночных трассах!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Постреляться на разных оружиях SA!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Пожениться и поцеловаться со своей второй половинкой!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Прокачать себе Level , чтобы имень лучше оружие и стиль боя!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Прикрепить к себе объекты для развлечения или снятия ролика!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Телепортируйтесь по новой системе телепортов!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Купить себе одноразовую машину!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Купить себе админский уровень [1 - 10 lvl]!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Заказать своему клану/team базу , спавн , и гангзону!\n",strlen(rstring));
		strins(rstring,"{42aaff}» {00ff00}Поиграть в TDM режиме!\n",strlen(rstring));
		strins(rstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(rstring));
		strins(rstring,"{42aaff}Пожалуйста, введите Ваш будущий пароль от аккаунта от 4 до 20 Букв|Цифр:\r\n",strlen(rstring));
	    ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"{00FFD5}Регистрация | Развлекательный Центр™!",rstring,"Войти","");
		return 1;
	}
// Request Login
	if(udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
    {
	    new lstring[2000];
	    strins(lstring,"{42aaff}Мы рады опять Вас видеть на сервере {00ff00}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\r\n",strlen(lstring));
	    strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}Я думаю, ты успел ознакомиться с сервером ещё при регистрации ;)\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}Если не успел , залогинься и заспавнись , а дальше просто нажми кнопку 'Y' , там вся информация о сервере :)\r\n",strlen(lstring));
	    strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}Чтобы выбрать TDM режим , при выборе скина нажмите в 'Лево <'!\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}Чтобы выбрать DM режим , при выборе скина нажмите в 'Право >'!\r\n",strlen(lstring));
	    strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}» Официальная группа сервера {00ff00}t.me/e_centersamp\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}» Официальный сайт сервера {00ff00}t.me/e_centersamp\r\n",strlen(lstring));
	    strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	    strins(lstring,"{42aaff}Введите пароль от Вашего аккаунта :\r\n",strlen(lstring));
	    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"{00FFD5}Пожалуйста, залогиньтесь!",lstring,"Войти","");
		return 1;
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	SetPlayerTime(playerid, 7, 0);
    new String[1024];
    strins(String,"{42aaff}Вы хотите дослушать трек?\n",strlen(String));
    strins(String,"{42aaff}Название трека : {00ff00}30 Seconds To Mars - Edge of the Earth\n",strlen(String));
    ShowPlayerDialog(playerid,57,DIALOG_STYLE_MSGBOX,"{33FF00}Музыка",String,"»]Выкл.[«","»]Слушать[«");
  	return true;
}

public OnPlayerSpawn(playerid)
{
	zonezapret[playerid] = 1000;
	SetPlayerArmorAC(playerid,100.0);
	SetPlayerHealthAC(playerid,100.0);
    ////rangs////
    new Score = GetPlayerScore(playerid);
    if(Score < 0) format(PlayerInfo[playerid][RanG],50,"»] Новичок [«");
    if(Score >= 0 && Score < 10) format(PlayerInfo[playerid][RanG],50,"»] Новичок [«"); //1
    if(Score >= 10 && Score < 50) format(PlayerInfo[playerid][RanG],50,"»] Рядовой [«"); //2
    if(Score >= 50 && Score < 100) format(PlayerInfo[playerid][RanG],50,"»] Ефрейтор [«"); //3
    if(Score >= 100 && Score < 200) format(PlayerInfo[playerid][RanG],50,"»] Младший сержант [«"); //4
    if(Score >= 200 && Score < 350) format(PlayerInfo[playerid][RanG],50,"»] Сержант [«"); //5
    if(Score >= 350 && Score < 500) format(PlayerInfo[playerid][RanG],50,"»] Старший сержант [«"); //6
    if(Score >= 500 && Score < 750) format(PlayerInfo[playerid][RanG],50,"»] Старшина [«"); //7
    if(Score >= 750 && Score < 1000) format(PlayerInfo[playerid][RanG],50,"»] Прапорщик [«"); //8
    if(Score >= 1000 && Score < 1350) format(PlayerInfo[playerid][RanG],50,"»] Старший прапорщик [«"); //9
    if(Score >= 1350 && Score < 1800) format(PlayerInfo[playerid][RanG],50,"»] Младший лейтенант [«");
    if(Score >= 1800 && Score < 2600) format(PlayerInfo[playerid][RanG],50,"»] Лейтенант [«");
    if(Score >= 2600 && Score < 3500) format(PlayerInfo[playerid][RanG],50,"»] Старший лейтенант [«");
    if(Score >= 3500 && Score < 5000) format(PlayerInfo[playerid][RanG],50,"»] Капитан [«");
    if(Score >= 5000 && Score < 6000) format(PlayerInfo[playerid][RanG],50,"»] Майор [«");
    if(Score >= 6000 && Score < 8000) format(PlayerInfo[playerid][RanG],50,"»] Подполковник [«");
    if(Score >= 8000 && Score < 9500) format(PlayerInfo[playerid][RanG],50,"»] Полковник [«");
    if(Score >= 9500 && Score < 11000) format(PlayerInfo[playerid][RanG],50,"»] Генерал-майор [«");
    if(Score >= 11000 && Score < 15000) format(PlayerInfo[playerid][RanG],50,"»] Генерал-лейтенант [«");
    if(Score >= 15000 && Score < 20000) format(PlayerInfo[playerid][RanG],50,"»] Генерал-полковник [«");
    if(Score >= 20000) format(PlayerInfo[playerid][RanG],50,"»] Генерал Р-Ц [«");
	if(RangStatus[playerid] == 0) Attach3DTextLabelToPlayer(Rang3D[playerid],playerid,0.0,0.0,0.47);
	Update3DTextLabelText(Rang3D[playerid],0x00f9fcFF,PlayerInfo[playerid][RanG]);
	RangStatus[playerid] = 1;
	/////rangs////
//	SetPlayerWeather(playerid,WorldWeather);
	if(!gPlayerAnimLibsPreloaded[playerid])
	{
   		PreloadAnimLib(playerid,"BOMBER");
   		PreloadAnimLib(playerid,"RAPPING");
    	PreloadAnimLib(playerid,"SHOP");
   		PreloadAnimLib(playerid,"BEACH");
   		PreloadAnimLib(playerid,"SMOKING");
    	PreloadAnimLib(playerid,"FOOD");
    	PreloadAnimLib(playerid,"ON_LOOKERS");
    	PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD");
		gPlayerAnimLibsPreloaded[playerid] = 1;
	}
////church
    switch(GetPlayerSkin(playerid))
    {
        case 9..13, 31, 38..41, 54..56, 63..64, 69, 75..77, 85..93, 129..131, 138..141, 145, 148..152, 157, 169, 172, 178, 190..199, 201, 205, 207, 211, 214..216, 218..219, 224..226, 231..233, 237..238, 243..246, 251, 256..257, 263, 298:
        {
            Sex[playerid] = 1;
        }
        default:
        {
            Sex[playerid] = 2;
        }
    }
/////church

    {
        SetPVarInt(playerid,"K_Times",0);
    }
	if(ServerInfo[Locked] == 1 && PlayerInfo[playerid][AllowedIn] == false)
	{
		GameTextForPlayer(playerid,"~r~CEPBEP 3AKPST ~n~OTKPONTE EFO KOMAHDON~n~/password <ZAPOLJ>",4000,3);
		SetTimerEx("DelayKillPlayer", 2500,0,"d",playerid);
		return 1;
	}

	if(udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
	{
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}Ошибка", "{FF3300}Вы ввели неверный пароль\n  {FF6600}Введите заново!", "Ок", "Выйти");
	}
	if(dUserINT(PlayerName2(playerid)).("dialoged") == 1)
    {
        PlayerInfo[playerid][Dialoged] = 1;
        DialogSet(playerid);
        SendClientMessage(playerid,red," Вам не поможет перезаход, Вы наказаны и все еще сидите с окошечком");
        return 1;
    }
    if(dUserINT(PlayerName2(playerid)).("jailed") == 1)
    {
        PlayerInfo[playerid][Jailed] = 1;
        JailPlayer(playerid);
        SendClientMessage(playerid,red," Вам не поможет перезаход, Вы наказаны и все еще сидите в тюрьме");
        return 1;
    }
   	if(dUserINT(PlayerName2(playerid)).("cameraed") == 1)
    {
        PlayerInfo[playerid][Cameraed] = 1;
        Camera(playerid);
        SendClientMessage(playerid,red," Вам не поможет перезаход, Вы наказаны и все еще с камерой в жопе");
        return 1;
    }
    if(dUserINT(PlayerName2(playerid)).("frozen") == 1)
	{
		TogglePlayerControllable(playerid,false);
		SendClientMessage(playerid,red," Вам не поможет перезаход, Вы наказаны и все еще заморожены");
		return 1;
	}
	if(dUserINT(PlayerName2(playerid)).("blinded") == 1)
	{
		BlindSet(playerid);
		SendClientMessage(playerid,red," Вам не поможет перезаход, Вы наказаны и все еще ослеплены");
		return 1;
	}
	if(dUserINT(PlayerName2(playerid)).("muted") == 1)
	{
		PlayerInfo[playerid][Muted] = 1;
		SendClientMessage(playerid,red," Вам не поможет перезаход, Вы наказаны и все еще заткнуты");
		return 1;
	}
	if(ServerInfo[MustLogin] == 1 && PlayerInfo[playerid][Registered] == 1 && PlayerInfo[playerid][LoggedIn] == 0)
	{
		GameTextForPlayer(playerid,"~r~BS DOLGHS 3ALOFNHNTJCR!",4000,3);
		SetTimerEx("DelayKillPlayer", 5000,0,"d",playerid);
		return 1;
	}
	if(ServerInfo[AdminOnlySkins] == 1) {
		if( (GetPlayerSkin(playerid) == ServerInfo[AdminSkin]) || (GetPlayerSkin(playerid) == ServerInfo[AdminSkin2]) ) {
			if(PlayerInfo[playerid][Level] >= 1)
				GameTextForPlayer(playerid,"~b~DO6PO ZOGALOBATJ~n~ ~w~ADMNH",3000,1);
			else {
				GameTextForPlayer(playerid,"~r~CKNH DLR ~n~ADMNHNCTPATOPOB",4000,1);
				SetTimerEx("DelayKillPlayer", 2500,0,"d",playerid);
				return 1;
			}
		}
	}
	
	PlayerInfo[playerid][Spawned] = 1;

	if((dUserINT(PlayerName2(playerid)).("UseSkin")) == 1)
		if((PlayerInfo[playerid][Level] >= 0) && (PlayerInfo[playerid][LoggedIn] == 1))
    		SetPlayerSkin(playerid,(dUserINT(PlayerName2(playerid)).("FavSkin")) );

	if(ServerInfo[GiveWeap] == 1) {
		if(PlayerInfo[playerid][LoggedIn] == 1) {
			PlayerInfo[playerid][TimesSpawned]++;
			if(PlayerInfo[playerid][TimesSpawned] == 1)
			{
 				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap1"), dUserINT(PlayerName2(playerid)).("weap1ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap2"), dUserINT(PlayerName2(playerid)).("weap2ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap3"), dUserINT(PlayerName2(playerid)).("weap3ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap4"), dUserINT(PlayerName2(playerid)).("weap4ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap5"), dUserINT(PlayerName2(playerid)).("weap5ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap6"), dUserINT(PlayerName2(playerid)).("weap6ammo")	);
			}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
///дуэль
    if(IsPlayerConnected(playerid))
	{
	    if(Duel[playerid] != 0)
		{
		    if(killerid == DuelOffer[playerid])
		    {
                new givename[255];
                GetPlayerName(DuelOffer[playerid],givename,sizeof(givename));
                new string[256];
				new ammo = GetPlayerAmmo(DuelOffer[playerid]);
				GivePlayerWeapon(DuelOffer[playerid],25,-ammo);
				GivePlayerMoney(playerid,-DuelPrice[playerid]);
				GivePlayerMoney(DuelOffer[playerid],DuelPrice[DuelOffer[playerid]]);
				SendClientMessage(playerid,-1,"{CC00DD}[Дуэль]{993344}Вы проиграли!");
				SendClientMessage(DuelOffer[playerid],-1,"{CC00DD}[Дуэль]{993344}]Вы выйграли!");
			    SpawnPlayer(DuelOffer[playerid]);
			    SpawnPlayer(playerid);//mine
				Duel[DuelOffer[playerid]] = 0;
				DuelOffer[DuelOffer[playerid]] = 999;
				DuelPrice[DuelOffer[playerid]] = 0;
				Duel[playerid] = 0;
				DuelOffer[playerid] = 999;
				DuelPrice[playerid] = 0;
				DuelStatus = 0;
				format(string, sizeof(string), "{CC00DD}[НОВОСТИ]: {993344}В Дуэли победил {88FF00}%s",givename);//
                SendClientMessageToAll(0xB0B0FFAA,string);//
			}
			else
			{
			    SpawnPlayer(DuelOffer[playerid]);
				Duel[DuelOffer[playerid]] = 0;
				DuelOffer[DuelOffer[playerid]] = 999;
				DuelPrice[DuelOffer[playerid]] = 0;
				Duel[playerid] = 0;
				DuelOffer[playerid] = 999;
				DuelPrice[playerid] = 0;
				DuelStatus = 0;

			}

		}
	}
///дуэль..
    DropPlayerWeapons(playerid);//dropweapon
///////rangs//
    if(IsPlayerConnected(killerid) && killerid != INVALID_PLAYER_ID)
    {
        new Score = GetPlayerScore(killerid);
        if(Score < 0) format(PlayerInfo[killerid][RanG],50,"»] Новичок [«");
        if(Score >= 0 && Score < 10) format(PlayerInfo[killerid][RanG],50,"»] Новичок [«"); //1
        if(Score >= 10 && Score < 50) format(PlayerInfo[killerid][RanG],50,"»] Рядовой [«"); //2
        if(Score >= 50 && Score < 100) format(PlayerInfo[killerid][RanG],50,"»] Ефрейтор [«"); //3
        if(Score >= 100 && Score < 200) format(PlayerInfo[killerid][RanG],50,"»] Младший сержант [«"); //4
        if(Score >= 200 && Score < 350) format(PlayerInfo[killerid][RanG],50,"»] Сержант [«"); //5
        if(Score >= 350 && Score < 500) format(PlayerInfo[killerid][RanG],50,"»] Старший сержант [«"); //6
        if(Score >= 500 && Score < 750) format(PlayerInfo[killerid][RanG],50,"»] Старшина [«"); //7
        if(Score >= 750 && Score < 1000) format(PlayerInfo[killerid][RanG],50,"»] Прапорщик [«"); //8
        if(Score >= 1000 && Score < 1350) format(PlayerInfo[killerid][RanG],50,"»] Старший прапорщик [«"); //9
        if(Score >= 1350 && Score < 1800) format(PlayerInfo[killerid][RanG],50,"»] Младший лейтенант [«");
        if(Score >= 1800 && Score < 2600) format(PlayerInfo[killerid][RanG],50,"»] Лейтенант [«");
        if(Score >= 2600 && Score < 3500) format(PlayerInfo[killerid][RanG],50,"»] Старший лейтенант [«");
        if(Score >= 3500 && Score < 5000) format(PlayerInfo[killerid][RanG],50,"»] Капитан [«");
        if(Score >= 5000 && Score < 6000) format(PlayerInfo[killerid][RanG],50,"»] Майор [«");
        if(Score >= 6000 && Score < 8000) format(PlayerInfo[killerid][RanG],50,"»] Подполковник [«");
        if(Score >= 8000 && Score < 9500) format(PlayerInfo[killerid][RanG],50,"»] Полковник [«");
        if(Score >= 9500 && Score < 11000) format(PlayerInfo[killerid][RanG],50,"»] Генерал-майор [«");
        if(Score >= 11000 && Score < 15000) format(PlayerInfo[killerid][RanG],50,"»] Генерал-лейтенант [«");
        if(Score >= 15000 && Score < 20000) format(PlayerInfo[killerid][RanG],50,"»] Генерал-полковник [«");
        if(Score >= 20000) format(PlayerInfo[killerid][RanG],50,"»] Генерал Р-Ц [«");
        Update3DTextLabelText(Rang3D[killerid],0x00f9fcFF,PlayerInfo[killerid][RanG]);
    }
 
    {
        SetPVarInt(playerid,"K_Times",GetPVarInt(playerid,"K_Times") + 1);
        if(GetPVarInt(playerid,"K_Times") > 1) return Kick(playerid);
    }
///////rangs//
	if(gPlayerUsingLoopingAnim[playerid]) {
    gPlayerUsingLoopingAnim[playerid] = 0;
	}

	#if defined ENABLE_SPEC
	for(new x=0; x<MAX_PLAYERS; x++)
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid)
	       AdvanceSpectate(x);
	#endif

	#if defined USE_STATS
    PlayerInfo[playerid][Deaths]++;
	PlayerInfo[killerid][Kills]++;
	#endif
    
    if(udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
    {
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}Ошибка", "{FF3300}Вы ввели неверный пароль\n  {FF6600}Введите заново!", "Ок", "Отмена");
    }

	return 1;
}
public OnPlayerText(playerid, text[])
{
//маленькая зашита==============================================================
    for(new i = 0; i < strlen(text); i++)
	{
	    if(text[i] != '%') continue;
	    text[i] = '#';
	    continue;
	}
//усё===========================================================================
	fixchars(text);
	if(text[0] == '#' && PlayerInfo[playerid][Level] >= 1) {
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
		format(string,sizeof(string)," Админ чат: %s(%d)[Level: %d]: %s",string,playerid,PlayerInfo[playerid][Level],text[1]);
		MessageToAdmins(green,string);
	    return 0;
	}
	if(text[0] == '№' && PlayerInfo[playerid][Level] >= 1) {
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
		format(string,sizeof(string)," Админ чат: %s(%d)[Level: %d]: %s",string,playerid,PlayerInfo[playerid][Level],text[1]);
		MessageToAdmins(green,string);
	    return 0;
	}

    new is1=0;
	new r=0;
	while(strlen(text[is1]))
	{
	    if('0'<=text[is1]<='9')
	    {
	    	new is2=is1+1;
	    	new p=0;
	    	while(p==0)
	    	{
	    	    if('0'<=text[is2]<='9'&&strlen(text[is2])) is2++;
				else
    			{
					strmid(strR[r],text,is1,is2,255);
					if(strval(strR[r])<255) r++;
					is1=is2;
					p=1;
				}
	    	}
	    }
	    is1++;
	}
	if(r>=4)
	{
	    new strMy[255];
	    new STRname[255];
	    GetPlayerName(playerid,STRname,255);
		format(strMy, sizeof(strMy), " Подозрение на рекламу %s(%d): %s",STRname,playerid,text);
		for(new j1=0; j1 < MAX_PLAYERS;j1++)
	      if(IsPlayerAdmin(j1)) SendClientMessage(j1, 0xFF0000FF, strMy);
		for(new z=0;z<r;z++)
		{
			new pr2;
			while((pr2=strfind(text,strR[z],true))!=-1) for(new i=pr2,j=pr2+strlen(strR[z]);i<j;i++) text[i]='*';
		}
	}
	
	if(ServerInfo[DisableChat] == 1) {
		SendClientMessage(playerid,red," Чат отключен");
	 	return 0;
    }
 //запас >>		if(PlayerInfo[playerid][LoggedIn] == 0) return SendClientMessage(playerid,red," [Ошибка] Вы должны быть залогинены чтобы пользываться ТАБ....");
	if(PlayerInfo[playerid][LoggedIn] == 0)
  		{
		SendClientMessage(playerid,red," {ff0000}[Ошибка] {ff3300}Вы {ff6600}должны {ff9900}быть {ffcc00}залогинены чтобы пользоваться чатом....");
		return 0;
 	}
    	
 	if(PlayerInfo[playerid][Muted] == 1)
	{
 		PlayerInfo[playerid][MuteWarnings]++;
 		new string[128];
		if(PlayerInfo[playerid][MuteWarnings] < ServerInfo[MaxMuteWarnings]) {
			format(string, sizeof(string)," ПРЕДУПРЕЖДЕНИЕ: Вы заткнуты, если будете продолжать писать, то вас кикнет. (Предупреждения:%d/%d)", PlayerInfo[playerid][MuteWarnings], ServerInfo[MaxMuteWarnings] );
			SendClientMessage(playerid,red,string);
		} else {
			SendClientMessage(playerid,red," Вас предупреждали ! Вы кикнуты");
			format(string, sizeof(string)," ***%s(%d) был кикнут за превышеный лимит предупреждений", PlayerName2(playerid), playerid);
			SendClientMessageToAll(COLOR_RED,string);
			SaveToFile("KickLog",string); Kick(playerid);
		} return 0;
	}
	
	if(ServerInfo[AntiSpam] == 1 && (PlayerInfo[playerid][Level] == 0 && !IsPlayerAdmin(playerid)) )
	{
		if(PlayerInfo[playerid][SpamCount] == 0) PlayerInfo[playerid][SpamTime] = TimeStamp();

	    PlayerInfo[playerid][SpamCount]++;
		if(TimeStamp() - PlayerInfo[playerid][SpamTime] > SPAM_TIMELIMIT) { // Its OK your messages were far enough apart
			PlayerInfo[playerid][SpamCount] = 0;
			PlayerInfo[playerid][SpamTime] = TimeStamp();
		}
		else if(PlayerInfo[playerid][SpamCount] == SPAM_MAX_MSGS) {
			new string[128]; format(string,sizeof(string),"[Р-Ц]: %s был кикнут системой Р-Ц [Причина : Flood]", PlayerName2(playerid));
			SendClientMessageToAll(COLOR_RED,string); print(string);
			SaveToFile("KickLog",string);
			Kick(playerid);
		}
		else if(PlayerInfo[playerid][SpamCount] == SPAM_MAX_MSGS-1) {
			SendClientMessage(playerid,red," ПРЕДУПРЕЖДЕНИЕ: Дальше кик.");
			return 0;
		}
	}

/*	if(ServerInfo[AntiSwear] == 1 && PlayerInfo[playerid][Level] < ServerInfo[MaxAdminLevel])
	for(new s = 0; s < ForbiddenWordCount; s++)
    {
		new pos;
		while((pos = strfind(text,ForbiddenWords[s],true)) != -1) for(new i = pos, j = pos + strlen(ForbiddenWords[s]); i < j; i++) text[i] = '*';
	}
	if(PlayerInfo[playerid][Caps] == 1) UpperToLower(text);
	if(ServerInfo[NoCaps] == 1) UpperToLower(text);
*/
    for(new i = 1; i < MAX_CHAT_LINES-1; i++) Chat[i] = Chat[i+1];
 	new ChatSTR[128]; GetPlayerName(playerid,ChatSTR,sizeof(ChatSTR)); format(ChatSTR,128,"[lchat]%s: %s",ChatSTR, text[0] );
	Chat[MAX_CHAT_LINES-1] = ChatSTR;

    if(PlayerInfo[playerid][pVippp] >= 1)
    {
	    new str1[512];
		new plName[MAX_PLAYER_NAME];
		GetPlayerName(playerid,plName,sizeof(plName));
	    format(str1, sizeof(str1), "[.ViP.] %s {00FD00}(ID: %d): {FFFFFF}%s", plName, playerid, text);
	    SendClientMessageToAll(GetPlayerColor(playerid), str1);
	    return 0;
    }

    if(text[0] == '!')
    {
	    new str[256], name[24], Float:P[3];
	    GetPlayerName(playerid,name,24);
	    GetPlayerPos(playerid,P[0],P[1],P[2]);
	    format(str,256,"{00DDFF}Местный чат: %s(ID: %d): %s",name,playerid,text[1]);
	    for(new i = 0; i < MAX_PLAYERS; i++)
	    {
		    if(!IsPlayerConnected(i) || !IsPlayerInRangeOfPoint(i,30.0,P[0],P[1],P[2])) continue;
		    SendClientMessage(i,0xFFFFFFAA,str);
		    continue;
	    }
	    return 0;
    }
    return 1;
}

public OnPlayerPrivmsg(playerid, recieverid, text[])
{
    fixchars(text);
	if(ServerInfo[ReadPMs] == 1 && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
	{
    	new string[128],recievername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, string, sizeof(string)); GetPlayerName(recieverid, recievername, sizeof(recievername));
		format(string, sizeof(string), "***ЛС: %s пишет %s: %s", string, recievername, text);
		for (new a = 0; a < MAX_PLAYERS; a++) if (IsPlayerConnected(a) && (PlayerInfo[a][Level] >= ServerInfo[MaxAdminLevel]) && a != playerid)
		SendClientMessage(a, yellow, string);
	}

 	if(PlayerInfo[playerid][Muted] == 1)
	{
		new string[128];
 		PlayerInfo[playerid][MuteWarnings]++;
		if(PlayerInfo[playerid][MuteWarnings] < ServerInfo[MaxMuteWarnings])
		{
			format(string, sizeof(string)," ПРЕДУПРЕЖДЕНИЕ: Вы что тупой? Сказали же что вы заткнуты,если будете далее писать, вас кикнет. (Предупреждения: %d/%d)", PlayerInfo[playerid][MuteWarnings], ServerInfo[MaxMuteWarnings] );
			SendClientMessage(playerid,red,string);
		}
		else {
			SendClientMessage(playerid,red," Вас предупреждали! Вы кикнуты");
			GetPlayerName(playerid, string, sizeof(string));
			format(string, sizeof(string)," %s [ID %d] Кикнут за высокий лимит предупреждений", string, playerid);
			SendClientMessageToAll(COLOR_RED,string);
			SaveToFile("KickLog",string); Kick(playerid);
		}
		return 0;
	}
	return 1;
}
//===================== [ DCMD Commands ]=======================================
dcmd_giveweapon(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /giveweapon [id игрока] [id оружия или название] [патроны] (наколдовать оружие)");
		new player1 = strval(tmp), weap, ammo, WeapName[32], string[128];
		if(!strlen(tmp3) || !IsNumeric(tmp3) || strval(tmp3) <= 0 || strval(tmp3) > 99999) ammo = 500; else ammo = strval(tmp3);
		if(!IsNumeric(tmp2)) weap = GetWeaponIDFromName(tmp2); else weap = strval(tmp2);
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
        	if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red," ОШИБКА: Неверный ID оружия");
			CMDMessageToAdmins(playerid,"GIVEWEAPON");
			GetWeaponName(weap,WeapName,32);
			format(string, sizeof(string), " Вы дали игроку %s оружие %s(ID: %d) с %d патронами", PlayerName2(player1), WeapName, weap, ammo); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s дал вам оружие %s(ID:%d) с %d патронами", PlayerName2(playerid), WeapName, weap, ammo); SendClientMessage(player1,COLOR_GREEN,string); }
   			return GivePlayerWeapon(player1, weap, ammo);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_dialog(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 11 || IsPlayerAdmin(playerid)) {
		    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /dialog [id игрока] [минуты] [причина] (дать игроку окошечко счастья)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][Frozen] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new dialogtime = strval(tmp2);
					if(dialogtime == 0) dialogtime = 9999;

			       	CMDMessageToAdmins(playerid,"DIALOG");
					PlayerInfo[player1][DialogTime] = dialogtime*1000*60;
			        DialogTimer[player1] = SetTimerEx("DialogReset",PlayerInfo[player1][DialogTime],0,"d",player1);
			        DialogSet(player1);

					if(dialogtime == 9999) {
						if(!params[2]) format(string,sizeof(string),"{FF0000}*** Админ %s подарил окошечко счастья игроку %s ",adminname, playername);
						else format(string,sizeof(string),"{FF0000}*** Админ %s подарил окошечко счастья игроку %s [причина: %s]",adminname, playername, params[2] );
	   				} else {
						if(!params[3+1]) format(string,sizeof(string),"{FF0000}*** Админ %s подарил окошечко счастья игроку %s на %d минут",adminname, playername, dialogtime);
						else format(string,sizeof(string),"{FF0000}*** Админ %s подарил окошечко счастья игроку %s на %d минут [причина: %s]",adminname, playername, dialogtime, params[3+1] );
					}
		    		return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, " Игрок уже с окошечком");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_undialog(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
	    if(PlayerInfo[playerid][Level] >= 11 || IsPlayerAdmin(playerid)) {
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /undialog [id игрока] (забрать у игрока окошечко счастья)");
	    	new player1, string[128];
			player1 = strval(params);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		 	    if(PlayerInfo[player1][Dialoged] == 1) {
		 	        CMDMessageToAdmins(playerid,"UNDIALOG");
			       	DialogReset(player1);
					format(string,sizeof(string),"{FF0000}*** Админ %s отобрал окошечко счастья у вас", PlayerName2(playerid) ); SendClientMessage(player1,COLOR_GREEN,string);
					format(string,sizeof(string),"{FF0000}*** Админ %s(%d) отобрал окошечко счастья у %s(%d)", PlayerName2(playerid),playerid, PlayerName2(player1),player1);
		    		return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не с окошечком");
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_dialogall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
		CMDMessageToAdmins(playerid,"DIALOGALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
			DialogSet(i);
			}
		}
		new string[128]; format(string,sizeof(string),"{FF0000}*** Админ %s подарил всем игрокам окошечко счастья", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_undialogall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
		CMDMessageToAdmins(playerid,"UNDIALOGALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
            DialogReset(i);
			}
		}
		new string[128]; format(string,sizeof(string),"{FF0000}*** Админ %s отобрал у всех игроков окошечко счастья", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_sethealth(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /sethealth [id игрока] [кол-во здоровья] (установить здоровье)");
		if(strval(tmp2) < 0 || strval(tmp2) > 100 && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid, red, " ОШИБКА: Не допустимое кол-во здоровья");
		new player1 = strval(tmp), health = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETHEALTH");
			format(string, sizeof(string), " Вы установили игроку %s здоровье %d", pName(player1), health); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000}*** Админ %s установил вам здоровье на %d", pName(playerid), health); SendClientMessage(player1,COLOR_GREEN,string); }
   			return SetPlayerHealthAC(player1, health);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 5 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setarmour(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setarmour [id игрока] [кол-во брони] (установить броню)");
		if(strval(tmp2) < 0 || strval(tmp2) > 100 && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid, red, " ОШИБКА: Не допустимое кол-во брони");
		new player1 = strval(tmp), armour = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETARMOUR");
			format(string, sizeof(string), " Вы установили игроку %s броню %d", pName(player1), armour); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам броню на %d", pName(playerid), armour); SendClientMessage(player1,COLOR_GREEN,string); }
   			return SetPlayerArmorAC(player1, armour);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 5 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setcash(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setcash [id игрока] [сумма] (установить сумму игроку)");
		new player1 = strval(tmp), cash = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETCASH");
			format(string, sizeof(string), " Вы установили игроку %s сумму $%d", pName(player1), cash); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000}*** Создатель {FFFFFF}%s {FF0000}дал вам сумму деньги {FFFFFF}$%d", pName(playerid), cash); SendClientMessage(player1,COLOR_GREEN,string); }
			ResetPlayerMoney(player1);
   			return GivePlayerMoney(player1, cash);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_admin(playerid,params[]) {
#pragma unused params
      if(PlayerInfo[playerid][Level] >= 3)
      {

        if(Hentum[playerid] == 0)
        {
            Hentum[playerid] = 1;
            ColorUpdate(playerid);
            SendClientMessage(playerid, 0x33CCFFAA, "* Вы включили статус админа!");

        }
        else
        {
			new count[MAX_PLAYERS];
			new number[MAX_PLAYERS];
			KillTimer(count[playerid]);
            Update3DTextLabelText(Label[playerid], Colors[number[playerid]], "");
            Hentum[playerid] = 0;
            SendClientMessage(playerid, 0x33CCFFAA, "* Вы выключили статус админа!");
        }
		}
      return 1;
      }

dcmd_setscore(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setscore [id игрока] [score] (установить уровень очков игроку");
		new player1 = strval(tmp), score = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETSCORE");
			PlayerInfo[player1][Kills] = score;
			format(string, sizeof(string), "{FF0000}*** Вы установили игроку %s фраги %d", pName(player1), score); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000}*** Создатель {FFFFFF}%s {FF0000}установил вам {FFFFFF}%d {FF0000}SCORE!", pName(playerid), score); SendClientMessage(player1,COLOR_GREEN,string); }
   			return SetPlayerScore(player1, score);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setskin(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setskin [id игрока] [id скина] (установить скин игроку)");
		new player1 = strval(tmp), skin = strval(tmp2), string[128];
		if(!IsValidSkin(skin)) return SendClientMessage(playerid, red, " ОШИБКА: Invaild Skin ID");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETSKIN");
			format(string, sizeof(string), " Вы установили игроку %s скин %d", pName(player1), skin); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000}*** Админ %s установил вам скин %d", pName(playerid), skin); SendClientMessage(player1,COLOR_GREEN,string); }
   			return SetPlayerSkin(player1, skin);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setwanted(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setwanted [id игрока] [уровень] (установить кол. звёзд розыска игроку)");
		new player1 = strval(tmp), wanted = strval(tmp2), string[128];
//		if(wanted > 6) return SendClientMessage(playerid, red, " ОШИБКА: Invaild wanted level");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETWANTED");
			format(string, sizeof(string), " Вы установили игроку %s уровень розыскиваемости %d", pName(player1), wanted); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000}*** Админ %s установил вам уровень розыскиваемости %d", pName(playerid), wanted); SendClientMessage(player1,COLOR_GREEN,string); }
   			return SetPlayerWantedLevel(player1, wanted);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setcolour(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) {
			SendClientMessage(playerid, red, " ПРАВКА: /setcolour [id игрока] [№ цвета] (установить новый цвет в чате игроку)");
			return SendClientMessage(playerid, red, " Допустимые цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
		}
		new player1 = strval(tmp), Colour = strval(tmp2), string[128], colour[24];
		if(Colour > 9) return SendClientMessage(playerid, red, " Допустимые цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
	        CMDMessageToAdmins(playerid,"SETCOLOUR");
			switch (Colour)
			{
			    case 0: { SetPlayerColor(player1,0x2C2727FF); colour = "черный"; }
			    case 1: { SetPlayerColor(player1,COLOR_WHITE); colour = "белый"; }
			    case 2: { SetPlayerColor(player1,red); colour = "красный"; }
			    case 3: { SetPlayerColor(player1,0xFF9900FF); colour = "оранжевый"; }
				case 4: { SetPlayerColor(player1,0xFF9900FF); colour = "желтый"; }
				case 5: { SetPlayerColor(player1,0x33AA33FF); colour = "зеленый"; }
				case 6: { SetPlayerColor(player1,COLOR_BLUE); colour = "синий"; }
				case 7: { SetPlayerColor(player1,0x330066AA); colour = "фиолетовый"; }
				case 8: { SetPlayerColor(player1,0xA52A2AAA); colour = "коричневый"; }
				case 9: { SetPlayerColor(player1,0xFFC0CBAA); colour = "розовый"; }
			}
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000}*** Админ %s сменил вам цвет на %s ", pName(playerid), colour); SendClientMessage(player1,COLOR_GREEN,string); }
			format(string, sizeof(string), " Вы сменили цвет игрока %s на %s", pName(player1), colour);
   			return SendClientMessage(playerid,COLOR_GREEN,string);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setweather(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setweather [id игрока] [id погоды] (сменить погоду)");
		new player1 = strval(tmp), weather = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETWEATHER");
			format(string, sizeof(string), " Вы сменили погоду %s на %d", pName(player1), weather); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s сменил погоду на %d", pName(playerid), weather); SendClientMessage(player1,COLOR_GREEN,string); }
			SetPlayerWeather(player1,weather); PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 5 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_settime(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /settime [id игрока] [время] (сменить время)");
		new player1 = strval(tmp), time = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETTIME");
			format(string, sizeof(string), " Вы сменили игроку %s время на %d:00", pName(player1), time); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s сменил вам время на %d:00", pName(playerid), time); SendClientMessage(player1,COLOR_GREEN,string); }
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return SetPlayerTime(player1, time, 0);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 5 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setworld(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 10) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setworld [id игрока] [виртуальный мир] (сменить мир)");
		new player1 = strval(tmp), time = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETWORLD");
			format(string, sizeof(string), " Вы установили игроку %s виртуальный мир на %d", pName(player1), time); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам виртуальный мир на %d", pName(playerid), time); SendClientMessage(player1,COLOR_GREEN,string); }
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return SetPlayerVirtualWorld(player1, time);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 10 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setinterior(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setinterior [id игрока] [interior] (сменить интерьер игроку)");
		new player1 = strval(tmp), time = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETINTERIOR");
			format(string, sizeof(string), " Вы установили интерьер игроку %s на %d", pName(player1), time); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам интерьер на %d", pName(playerid), time); SendClientMessage(player1,COLOR_GREEN,string); }
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
   			return SetPlayerInterior(player1, time);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setmytime(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setmytime [время] (установить время)");
		new time = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETMYTIME");
		format(string,sizeof(string)," Вы установили себе время %d:00", time); SendClientMessage(playerid,COLOR_GREEN,string);
		return SetPlayerTime(playerid, time, 0);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_force(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /force [id игрока] (заставить игрока заново выбрать скин)");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"FORCE");
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s заставил вас заного выбрать скин", pName(playerid) ); SendClientMessage(player1,COLOR_RED,string); }
			format(string,sizeof(string)," Вы заставили игрока %s заного выбрать скин", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			ForceClassSelection(player1);
			return SetPlayerHealth(player1,0.0);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_eject(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /eject [id игрока] (выкинуть игрока из машины)");
		new player1 = strval(params), string[128], Float:x, Float:y, Float:z;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(IsPlayerInAnyVehicle(player1)) {
		       	CMDMessageToAdmins(playerid,"EJECT");
				if(player1 != playerid) { format(string,sizeof(string)," {FF0000}Админ %s выкинул вас из транспорта", pName(playerid) ); SendClientMessage(player1,COLOR_RED,string); }
				format(string,sizeof(string)," {FF0000}Вы выкинули игрока %s из транспорта", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
    		   	GetPlayerPos(player1,x,y,z);
				return SetPlayerPos(player1,x,y,z+3);
			} else return SendClientMessage(playerid,red," ОШИБКА: Игрок не в транспорте");
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lockcar(playerid,params[]) {
	#pragma unused params
    if(PlayerInfo[playerid][Level] >= 1) {
	    if(IsPlayerInAnyVehicle(playerid)) {
		 	for(new i = 0; i < MAX_PLAYERS; i++) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,true);
			CMDMessageToAdmins(playerid,"LOCKCAR");
			PlayerInfo[playerid][DoorsLocked] = 1;
			new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}закрыл двери своего транспорта", pName(playerid));
			return SendClientMessageToAll(COLOR_GREEN,string);
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы не можете закрыть двери в этом транспорте");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_unlockcar(playerid,params[]) {
	#pragma unused params
    if(PlayerInfo[playerid][Level] >= 1) {
	    if(IsPlayerInAnyVehicle(playerid)) {
		 	for(new i = 0; i < MAX_PLAYERS; i++) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,false);
			CMDMessageToAdmins(playerid,"UNLOCKCAR");
			PlayerInfo[playerid][DoorsLocked] = 0;
			new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}открыл двери своего транспорта", pName(playerid));
			return SendClientMessageToAll(COLOR_GREEN,string);
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы не можете открыть двери в этом транспорте");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_burn(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /burn [id игрока] (поджечь игрока)");
		new player1 = strval(params), string[128], Float:x, Float:y, Float:z;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"BURN");
			format(string, sizeof(string), " {FF0000}Вы подожгли %s", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			if(player1 != playerid) { format(string,sizeof(string)," {FF0000}Админ %s вас поджог", pName(playerid)); SendClientMessage(player1,COLOR_RED,string); }
			GetPlayerPos(player1, x, y, z);
			return CreateExplosion(x, y , z + 3, 1, 10);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_spawnplayer(playerid,params[])
{
	return dcmd_spawn(playerid,params);
}

dcmd_spawn(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /spawn [id игрока] (вернуть игрока на место спавна)");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SPAWNPLAYER");
			format(string, sizeof(string), " Вы вернули игрока %s на место спавна", pName(player1)); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s вернул вас на место спавна", pName(playerid)); SendClientMessage(player1,COLOR_GREEN,string); }
			SetPlayerPos(player1, 0.0, 0.0, 0.0);
			return SpawnPlayer(player1);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_disarm(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /disarm [id игрока] (обезаружить игрока)");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"DISARM");  PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			format(string, sizeof(string), " {FF0000}Вы разоружили игрока %s", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			if(player1 != playerid) { format(string,sizeof(string),"{FF0000} Админ %s разоружил вас", pName(playerid)); SendClientMessage(player1,COLOR_RED,string); }
			ResetPlayerWeapons(player1);
			return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_crash(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /crash [id игрока] (заставить игрока вылететь)");
		new player1 = strval(params), string[128], Float:X,Float:Y,Float:Z;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
   			CMDMessageToAdmins(playerid,"CRASH");
	        GetPlayerPos(player1,X,Y,Z);
	   		new objectcrash = CreatePlayerObject(player1,11111111,X,Y,Z,0,0,0);
			DestroyObject(objectcrash);
			format(string, sizeof(string), " {FF0000}Вы заставили вылететь игрока %s из игры", pName(player1) );
			return SendClientMessage(playerid,COLOR_RED, string);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_ip(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /ip [id игрока] (посмотреть ip игрока)");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"IP");
			new tmp3[50]; GetPlayerIp(player1,tmp3,50);
			format(string,sizeof(string)," IP игрока %s - %s", pName(player1), tmp3);
			return SendClientMessage(playerid,COLOR_GREEN,string);
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 9 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_ccd(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 4) {
        SendDeathMessage(500,500,500);
        SendDeathMessage(500,500,500);
        SendDeathMessage(500,500,500);
        SendDeathMessage(500,500,500);
        SendDeathMessage(500,500,500);
		CMDMessageToAdmins(playerid,"CCD"); return 1;
 	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_kill(playerid,params[]) {
	#pragma unused params
	return SetPlayerHealth(playerid,0.0);
}

dcmd_time(playerid,params[]) {
	#pragma unused params
	new string[64], hour,minuite,second; gettime(hour,minuite,second);
	format(string, sizeof(string), "~g~|~w~%d:%d~g~|", hour, minuite);
	return GameTextForPlayer(playerid, string, 5000, 1);
}

dcmd_ubound(playerid,params[]) {
 	if(PlayerInfo[playerid][Level] >= 10) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /ubound [id игрока] (убрать мировый границы)");
	    new string[128], player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"UBOUND");
			SetPlayerWorldBounds(player1, 9999.9, -9999.9, 9999.9, -9999.9 );
			format(string, sizeof(string)," {FF0000}Админ %s удалил ваши мировые границы", PlayerName2(playerid)); if(player1 != playerid) SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," {FF0000}Вы удалили с игрока %s все мировые границы", PlayerName2(player1));
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 10 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lcmds(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] > 0)
	{
		SendClientMessage(playerid,blue,"    ---= [ Все комады по категориям] ==---");
		SendClientMessage(playerid,0x33CCFFFF," ОСНОВНЫЕ: getinfo, lmenu, announce, write, miniguns, richlist, lspec(off), move, lweaps, countdown, giveweapon");
		SendClientMessage(playerid,0x33CCFFFF," ОСНОВНЫЕ: slap, burn, warn, kick, ban, explode, jail, freeze, mute, crash, ubound, god, godcar, invis, ping, (un)dialog, (un)camera");
		SendClientMessage(playerid,0x33CCFFFF," ОСНОВНЫЕ: setping, lockserver, enable/disable, setlevel, setinterior, givecar, jetpack, force, spawn, (un)blind, ccd");
		SendClientMessage(playerid,0x33CCFFFF," МАШИНЫ: flip, fix, repair, lockcar, eject, ltc [1-13], car, lcar, lbike, lplane, lheli, lboat, lnos, cm");
		SendClientMessage(playerid,0x33CCFFFF," ТЕЛЕПОРТ: goto, gethere, get, teleplayer, ltele, vgoto, lgoto, moveplayer");
		SendClientMessage(playerid,0x33CCFFFF," УСТАНОВИТЬ: set(cash/health/armour/gravity/name/time/weather/skin/colour/wanted/templevel)");
		SendClientMessage(playerid,0x33CCFFFF," УСТАН.ВСЕ: setall(world/weather/wanted/time/score/cash)");
		SendClientMessage(playerid,0x33CCFFFF," ВСЕМ: giveallweapon, healall, armourall, freezeall, kickall, ejectall, killall, disarmall, slapall, spawnall");
	}
	return 1;
}

dcmd_lcommands(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] > 0) {
		SendClientMessage(playerid,green,"(1) FLIP, FIX, REPAIR, LP, CARCOLOUR, LTUNE, SETMYTIME, TIME, GETID, LINKCAR, LNOS, LHY");
		SendClientMessage(playerid,green,"(1) (UN) LOCKCAR, DISARM, GOTO, LCAR, LBIKE, LTC, CM(giveme), JETPACK");
	}
	if(PlayerInfo[playerid][Level] > 1) {
		SendClientMessage(playerid,COLOR_GREEN,"(2) SLAP, BURN, WARN, MUTE, UNMUTE, GIVEWEAPON, GETINFO, LASTON, CLEARCHAT, ASAY");
	}
	if(PlayerInfo[playerid][Level] > 2) {
	    SendClientMessage(playerid,green,"(3) SETSKIN, SETCOLOUR, SETWANTED, LMENU, LTELE, LVEHICLE, SETINTERIOR, LWEAPONS, LTMENU, SPAWN");
		SendClientMessage(playerid,green,"(3) KICK, EXPLODE, EJECT, JAIL, UNJAIL, FREEZE, UNFREEZE, LWEAPS, LAMMO, BOTCHECK, ADMIN");
    }
	if(PlayerInfo[playerid][Level] > 3) {
	    SendClientMessage(playerid,COLOR_GREEN,"(4) GETHERE, TELEPLAYER, CAR, CARHEALTH, DESTROY, LTIME, LWEATHER, CAPS, FORCE, (UN) DIALOG");
	}
	if(PlayerInfo[playerid][Level] > 4) {
    	SendClientMessage(playerid,green,"(5) SETHEALTH, SETARMOUR, SETWEATHER, SETTIME, SETWORLD, HEALALL, ARMOURALL");
	}
    if(PlayerInfo[playerid][Level] > 5) {
	    SendClientMessage(playerid,COLOR_GREEN,"(6) SETALLWORLD, SETALLWEATHER, SETALLWANTED, SETALLTIME, GIVEALLWEAPON");
	}
	if(PlayerInfo[playerid][Level] > 6) {
    	SendClientMessage(playerid,green,"(7) BAN, SETPING, DISABLE, ENABLE, FORBID(NAME/WORD), CC, UCONFIG");
	}
	if(PlayerInfo[playerid][Level] > 7) {
	    SendClientMessage(playerid,COLOR_GREEN,"(8) KILLALL, DISARMALL, KICKALL, EJECTALL, FREEZEALL, UNFREEZEALL, SPAWNALL");
	    SendClientMessage(playerid,COLOR_GREEN,"(8) MUTEALL, DIALOGALL, UNDIALOGALL, GETALL, (UN) LOCKSERVER, GOD, GODCAR");
	}
	if(PlayerInfo[playerid][Level] > 8) {
	    SendClientMessage(playerid,COLOR_GREEN,"(9) CRASH, IP, UBOUND, DIE, SLAPALL, EXPLODEALL, SETCASH");
	}
	if(PlayerInfo[playerid][Level] < 1 ) {
		SendClientMessage(playerid,green, " Ваши команды: /register, /login, /report, /stats, /time, /changepass, /resetstats, /getid");
	}
	return 1;
}

dcmd_lconfig(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] > 0)
	{
	    new string[128];
		SendClientMessage(playerid,blue,"    ---=== LAdmin5 Конфигурации ===---");
		format(string, sizeof(string), " Максимальный пинг: %dms | Читать приваты %d | Читать команды %d | Максимальный уровень %d | Админ скины %d", ServerInfo[MaxPing],  ServerInfo[ReadPMs],  ServerInfo[ReadCmds],  ServerInfo[MaxAdminLevel],  ServerInfo[AdminOnlySkins] );
		SendClientMessage(playerid,blue,string);
		format(string, sizeof(string), " Админ скин1 %d | Админскин2 %d | Кик по нику %d | Анти-бот %d | Анти-спам %d | Анти-мат %d", ServerInfo[AdminSkin], ServerInfo[AdminSkin2], ServerInfo[NameKick], ServerInfo[AntiBot], ServerInfo[AntiSpam], ServerInfo[AntiSwear] );
		SendClientMessage(playerid,blue,string);
		format(string, sizeof(string), " Анти-капс %d | Закрыт %d | Пароль %s | Сохран. оруж. %d | Сохран. деньги %d | Коннект-сообщ. %d | Читать АДМ-команды %d", ServerInfo[NoCaps], ServerInfo[Locked], ServerInfo[Password], ServerInfo[GiveWeap], ServerInfo[GiveMoney], ServerInfo[ConnectMessages], ServerInfo[AdminCmdMsg] );
		SendClientMessage(playerid,blue,string);
		format(string, sizeof(string), " Авто-логин %d | Максимум предупрежд. %d | Чат %d | Должен залогиниться %d", ServerInfo[AutoLogin], ServerInfo[MaxMuteWarnings], ServerInfo[DisableChat], ServerInfo[MustLogin] );
		SendClientMessage(playerid,blue,string);
	}
	return 1;
}

dcmd_getinfo(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid,red," ПРАВКА: /getinfo [id игрока] (подробная информация об игроке)");
	    new player1, string[128];
	    player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		    new Float:player1health, Float:player1armour, playerip[128], Float:x, Float:y, Float:z, tmp2[256], file[256],
				year, month, day, P1Jailed[4], P1Frozen[4], P1Logged[4], P1Register[4], RegDate[256], TimesOn;

			GetPlayerHealth(player1,player1health);
			GetPlayerArmour(player1,player1armour);
	    	GetPlayerIp(player1, playerip, sizeof(playerip));
	    	GetPlayerPos(player1,x,y,z);
			getdate(year, month, day);
			format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(player1)));

			if(PlayerInfo[player1][Jailed] == 1) P1Jailed = "Да"; else P1Jailed = "Нет";
			if(PlayerInfo[player1][Frozen] == 1) P1Frozen = "Да"; else P1Frozen = "Нет";
			if(PlayerInfo[player1][LoggedIn] == 1) P1Logged = "Да"; else P1Logged = "Нет";
			if(fexist(file)) P1Register = "Да"; else P1Register = "Нет";
			if(dUserINT(PlayerName2(player1)).("LastOn")==0) tmp2 = "Never"; else tmp2 = dini_Get(file,"LastOn");
			if(strlen(dini_Get(file,"RegisteredDate")) < 3) RegDate = "n/a"; else RegDate = dini_Get(file,"RegisteredDate");
			TimesOn = dUserINT(PlayerName2(player1)).("TimesOnServer");

		    new Sum, Average, w;
			while (w < PING_MAX_EXCEEDS) {
				Sum += PlayerInfo[player1][pPing][w];
				w++;
			}
			Average = (Sum / PING_MAX_EXCEEDS);

	  		format(string, sizeof(string)," {ff0000}(Информация о игроке)  ---====> {ff0000}Ник: %s  {00f8ff}ID: %d <====---", PlayerName2(player1), player1);
			SendClientMessage(playerid,0x33CCFFFF,string);
		  	format(string, sizeof(string)," {ffff00}Жизни: %d  {7fff00}Броня: %d  {c7fcec}Рекорд: %d  {ccccff}Сумма: %d  {fffacd}Скин: %d  {c41e3a}IP: %s  {00ff7f}Пинг: %d  {ffff00}Средний Пинг: %d",floatround(player1health),floatround(player1armour),
			GetPlayerScore(player1),GetPlayerMoney(player1),GetPlayerSkin(player1),playerip,GetPlayerPing(player1), Average );
			SendClientMessage(playerid,red,string);
			format(string, sizeof(string)," {00fff9}Внутренняя: %d  {fde910}Виртуальный мир: %d  {ff2400}Розыск: %d  X %0.1f  Y %0.1f  Z %0.1f", GetPlayerInterior(player1), GetPlayerVirtualWorld(player1), GetPlayerWantedLevel(player1), Float:x,Float:y,Float:z);
			SendClientMessage(playerid,0xFF9900FF,string);
			format(string, sizeof(string)," {00ff5e}На сервере: %d  {f0ff00}Убил: %d  {000cff}Смертей: %d  {f8ff00}Коэфиц.: %0.2f  Админ уровень: %d", TimesOn, PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths], Float:PlayerInfo[player1][Kills]/Float:PlayerInfo[player1][Deaths], PlayerInfo[player1][Level] );
			SendClientMessage(playerid,yellow,string);
			format(string, sizeof(string)," {ff0010}Зареган: %s  {ff00ff}Залогинен: %s  {00fff8}Посажен: %s  {d53e07}Заморожен: %s", P1Register, P1Logged, P1Jailed, P1Frozen );
			SendClientMessage(playerid,green,string);
			format(string, sizeof(string)," {adff2f}Последн. на серве: %s  {2fa0ff}Дата регистрации: %s  {e49b0f}Сегоднешняя дата: %d/%d/%d", tmp2, RegDate, day,month,year );
			SendClientMessage(playerid,COLOR_GREEN,string);

			if(IsPlayerInAnyVehicle(player1)) {
				new Float:VHealth, carid = GetPlayerVehicleID(playerid); GetVehicleHealth(carid,VHealth);
				format(string, sizeof(string)," {daa520}ID Машины: %d  {da2b20}Модель: %d  {cd5c5c}Имя машины: %s  {f36223}Здоровье машины: %d",carid, GetVehicleModel(carid), VehicleNames[GetVehicleModel(carid)-400], floatround(VHealth) );
				SendClientMessage(playerid,COLOR_BLUE,string);
			}

			new slot, ammo, weap, Count, WeapName[24], WeapSTR[128], p; WeapSTR = " {f36223}Оружия: ";
			for (slot = 0; slot < 14; slot++) {	GetPlayerWeaponData(player1, slot, weap, ammo); if( ammo != 0 && weap != 0) Count++; }
			if(Count < 1) return SendClientMessage(playerid,0x33CCFFFF," У игрока нет оружия");
			else {
				for (slot = 0; slot < 14; slot++)
				{
					GetPlayerWeaponData(player1, slot, weap, ammo);
					if (ammo > 0 && weap > 0)
					{
						GetWeaponName(weap, WeapName, sizeof(WeapName) );
						if (ammo == 65535 || ammo == 1) format(WeapSTR,sizeof(WeapSTR),"%s%s (1)",WeapSTR, WeapName);
						else format(WeapSTR,sizeof(WeapSTR),"%s%s (%d)",WeapSTR, WeapName, ammo);
						p++;
						if(p >= 5) { SendClientMessage(playerid, 0x33CCFFFF, WeapSTR); format(WeapSTR, sizeof(WeapSTR), "Weaps: "); p = 0;
						} else format(WeapSTR, sizeof(WeapSTR), "%s,  ", WeapSTR);
					}
				}
				if(p <= 4 && p > 0) {
					string[strlen(string)-3] = '.';
				    SendClientMessage(playerid, 0x33CCFFFF, WeapSTR);
				}
			}
			return 1;
		} else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_disable(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 7 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) {
			SendClientMessage(playerid,red," ПРАВКА: /disable [antiswear / namekick / antispam / ping / readcmds / readpms /caps / admincmdmsgs");
			return SendClientMessage(playerid,red,"       /connectmsgs / autologin ]");
		}
	    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		if(strcmp(params,"antiswear",true) == 0) {
			ServerInfo[AntiSwear] = 0;
			dini_IntSet(file,"AntiSwear",0);
			format(string,sizeof(string)," Админ %s выключил антимат", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"namekick",true) == 0) {
			ServerInfo[NameKick] = 0;
			dini_IntSet(file,"NameKick",0);
			format(string,sizeof(string)," Админ %s выключил кик ника", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
	 	} else if(strcmp(params,"antispam",true) == 0)	{
			ServerInfo[AntiSpam] = 0;
			dini_IntSet(file,"AntiSpam",0);
			format(string,sizeof(string)," Админ %s выключил антиспам", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"ping",true) == 0)	{
			ServerInfo[MaxPing] = 0;
			dini_IntSet(file,"MaxPing",0);
			format(string,sizeof(string)," Админ %s выключил пинг кик", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"readcmds",true) == 0) {
			ServerInfo[ReadCmds] = 0;
			dini_IntSet(file,"ReadCMDs",0);
			format(string,sizeof(string)," Админ %s выключил читать команды", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"readpms",true) == 0) {
			ServerInfo[ReadPMs] = 0;
			dini_IntSet(file,"ReadPMs",0);
			format(string,sizeof(string)," Админ %s выключил читать приваты", PlayerName2(playerid));
			MessageToAdmins(blue,string);
  		} else if(strcmp(params,"caps",true) == 0)	{
			ServerInfo[NoCaps] = 1;
			dini_IntSet(file,"NoCaps",1);
			format(string,sizeof(string)," Админ %s выключил анти капс лок", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"admincmdmsgs",true) == 0) {
			ServerInfo[AdminCmdMsg] = 0;
			dini_IntSet(file,"AdminCMDMessages",0);
			format(string,sizeof(string)," Админ %s выключил коннект сообщения", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"connectmsgs",true) == 0)	{
			ServerInfo[ConnectMessages] = 0;
			dini_IntSet(file,"ConnectMessages",0);
			format(string,sizeof(string)," Админ %s выключил коннект и дисконнект сообщения", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"autologin",true) == 0)	{
			ServerInfo[AutoLogin] = 0;
			dini_IntSet(file,"AutoLogin",0);
			format(string,sizeof(string)," Админ %s выключил автологин", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else {
			SendClientMessage(playerid,red," ПРАВКА: /disable [antiswear / namekick / antispam / ping / readcmds / readpms /caps /cmdmsg ]");
		} return 1;
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_enable(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 7 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) {
			SendClientMessage(playerid,red," ПРАВКА: /enable [antiswear / namekick / antispam / ping / readcmds / readpms /caps / admincmdmsgs");
			return SendClientMessage(playerid,red,"       /connectmsgs / autologin ]");
		}
	    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		if(strcmp(params,"antiswear",true) == 0) {
			ServerInfo[AntiSwear] = 1;
			dini_IntSet(file,"AntiSwear",1);
			format(string,sizeof(string)," Админ %s включил антимат", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"namekick",true) == 0)	{
			ServerInfo[NameKick] = 1;
			format(string,sizeof(string),"*Админ %s включил кик ника", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
 		} else if(strcmp(params,"antispam",true) == 0)	{
			ServerInfo[AntiSpam] = 1;
			dini_IntSet(file,"AntiSpam",1);
			format(string,sizeof(string),"*Админ %s включил анти спам", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"ping",true) == 0)	{
			ServerInfo[MaxPing] = 800;
			dini_IntSet(file,"MaxPing",800);
			format(string,sizeof(string),"*Админ %s включил пинг кмк", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"readcmds",true) == 0)	{
			ServerInfo[ReadCmds] = 1;
			dini_IntSet(file,"ReadCMDs",1);
			format(string,sizeof(string),"*Админ %s включил читать команды", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"readpms",true) == 0) {
			ServerInfo[ReadPMs] = 1;
			dini_IntSet(file,"ReadPMs",1);
			format(string,sizeof(string),"*Админ %s включил читать приваты", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"caps",true) == 0)	{
			ServerInfo[NoCaps] = 0;
			dini_IntSet(file,"NoCaps",0);
			format(string,sizeof(string),"*Админ %s включил анти капс лок", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"admincmdmsgs",true) == 0)	{
			ServerInfo[AdminCmdMsg] = 1;
			dini_IntSet(file,"AdminCmdMessages",1);
			format(string,sizeof(string),"*Админ %s включил читать админ команды", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"connectmsgs",true) == 0) {
			ServerInfo[ConnectMessages] = 1;
			dini_IntSet(file,"ConnectMessages",1);
			format(string,sizeof(string),"*Админ %s включил читать коннект и дисконнект сообщения", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"autologin",true) == 0) {
			ServerInfo[AutoLogin] = 1;
			dini_IntSet(file,"AutoLogin",1);
			format(string,sizeof(string),"*Админ %s включил автологин", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else {
			SendClientMessage(playerid,red," ПРАВКА: /enable [antiswear / namekick / antispam / ping / readcmds / readpms /caps /cmdmsg ]");
		} return 1;
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
dcmd_lweaps(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		GivePlayerWeapon(playerid,28,500); GivePlayerWeapon(playerid,31,500); GivePlayerWeapon(playerid,34,500);
		GivePlayerWeapon(playerid,14,500); GivePlayerWeapon(playerid,16,500);	GivePlayerWeapon(playerid,42,500);
		GivePlayerWeapon(playerid,14,500); GivePlayerWeapon(playerid,46,500);	GivePlayerWeapon(playerid,9,1);
		GivePlayerWeapon(playerid,24,500); GivePlayerWeapon(playerid,26,500); return 1;
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_countdown(playerid,params[]) {
	#pragma unused params
    if(PlayerInfo[playerid][Level] >= 10) {
        if(CountDown == -1) {
			CountDown = 6;
			SetTimer("countdown",1000,0);
			return CMDMessageToAdmins(playerid,"COUNTDOWN");
		} else return SendClientMessage(playerid,red," ОШИБКА: Отчет уже запущен");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 10 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lammo(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		MaxAmmo(playerid);
		return CMDMessageToAdmins(playerid,"LAMMO");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 8 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_fix(playerid,params[])
{
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (IsPlayerInAnyVehicle(playerid)) {
			SetVehicleHealth(GetPlayerVehicleID(playerid),1250.0);
			return SendClientMessage(playerid,COLOR_GREEN," Тачка зафиксирована");
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы не в машине");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_vrepair(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 1) {
	new vehicleid = GetPlayerVehicleID(playerid);
    if (IsPlayerInAnyVehicle(playerid)) {
			RepairVehicle(GetPlayerVehicleID(playerid));
            SetVehicleHealth(vehicleid,1000);
	    	return SendClientMessage(playerid,COLOR_GREEN,"{00F200}*** {EFF600}Вы починили свой транспорт");
		} else return SendClientMessage(playerid,red,"{00F200}*** {62FF62}ОШИБКА: Вы не в машине");
	} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
}

dcmd_repair(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
	new vehicleid = GetPlayerVehicleID(playerid);
    if (IsPlayerInAnyVehicle(playerid)) {
			RepairVehicle(GetPlayerVehicleID(playerid));
            SetVehicleHealth(vehicleid,1000);
	    	return SendClientMessage(playerid,COLOR_GREEN,"{00F200}*** {0AD383}Вы починили свой транспорт");
		} else return SendClientMessage(playerid,red,"{00F200}*** {62FF62}ОШИБКА: Вы не в машине");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_ltune(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
        new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
        switch(LModel)
		{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
			return SendClientMessage(playerid,red," ОШИБКА: Вы не можете тюнинговать этот транспорт");
		}
        CMDMessageToAdmins(playerid,"LTUNE");
		SetVehicleHealth(LVehicleID,2000.0);
		TuneLCar(LVehicleID);
		return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы не в машине");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lhy(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
        new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
        switch(LModel)
		{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
			return SendClientMessage(playerid,red," ОШИБКА: Вы не можете тюнинговать этот транспорт!");
		}
        AddVehicleComponent(LVehicleID, 1087);
		return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы не в машине");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_sellhome(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 12)
	{
      CallRemoteFunction("AdminSellDom", "i",playerid);
    }
 }

dcmd_lcar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,411);
			CMDMessageToAdmins(playerid,"LCAR");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе машину");
		} else return SendClientMessage(playerid,red," ОШИБКА: У вас есть машина");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lbike(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,522);
			CMDMessageToAdmins(playerid,"LBIKE");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе мотоцикл");
		} else return SendClientMessage(playerid,red," ОШИБКА: У вас есть машина");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lnos(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
	        switch(GetVehicleModel( GetPlayerVehicleID(playerid) )) {
				case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
				return SendClientMessage(playerid,red," ОШИБКА: Вы не в машине!");
			}
	        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
			return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны быть в машине.");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_linkcar(playerid,params[]) {
	#pragma unused params
	if(IsPlayerInAnyVehicle(playerid)) {
    	LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(playerid));
	    SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(playerid));
	    return SendClientMessage(playerid,COLOR_GREEN, " Теперь ваш транспорт может находится в помещении");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны быть в транспорте.");
 }

dcmd_closemymode(playerid,params[]) {
	#pragma unused params
	
	 CallRemoteFunction("OnGameModeExit", "i",playerid);
	 CallRemoteFunction("OnFilterScriptExit", "i",playerid);

 }

dcmd_car(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
	    if(!strlen(tmp)) return SendClientMessage(playerid, red, " ПРАВКА: /car [id модели или имя] [цвет 1] [цвет 2] (наколдовать сеебе машину)");
		new car, colour1, colour2, string[128];
   		if(!IsNumeric(tmp)) car = GetVehicleModelIDFromName(tmp); else car = strval(tmp);
		if(car < 400 || car > 611) return  SendClientMessage(playerid, red, " ОШИБКА: Не верная модель транспорта");
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);
		if(PlayerInfo[playerid][pCar] != -1 && !IsPlayerAdmin(playerid) ) CarDeleter(PlayerInfo[playerid][pCar]);
		new LVehicleID,Float:X,Float:Y,Float:Z, Float:Angle,int1;	GetPlayerPos(playerid, X,Y,Z);	GetPlayerFacingAngle(playerid,Angle);   int1 = GetPlayerInterior(playerid);
		LVehicleID = CreateVehicle(car, X+3,Y,Z, Angle, colour1, colour2, -1); LinkVehicleToInterior(LVehicleID,int1);
		PlayerInfo[playerid][pCar] = LVehicleID;
		CMDMessageToAdmins(playerid,"CAR");
		format(string, sizeof(string), " %s наколдовал себе транспорт %s(ID модели:%d) с цветами (%d, %d), at %0.2f, %0.2f, %0.2f", pName(playerid), VehicleNames[car-400], car, colour1, colour2, X, Y, Z);
        SaveToFile("CarSpawns",string);
		format(string, sizeof(string), " Вы наколдовали себе транспорт %s(ID модели:%d) с цветами (%d, %d)", VehicleNames[car-400], car, colour1, colour2);
		return SendClientMessage(playerid,COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_carhealth(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /carhealth [id игрока] [здоровье] (установить здоровье машины)");
		new player1 = strval(tmp), health = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
            if(IsPlayerInAnyVehicle(player1)) {
		       	CMDMessageToAdmins(playerid,"CARHEALTH");
				format(string, sizeof(string), " Вы установили игроку %s здоровье транспорта на %d", pName(player1), health); SendClientMessage(playerid,COLOR_GREEN,string);
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил здоровье вашего транспорта на%d", pName(playerid), health); SendClientMessage(player1,COLOR_GREEN,string); }
   				return SetVehicleHealth(GetPlayerVehicleID(player1), health);
			} else return SendClientMessage(playerid,red," ОШИБКА: Игрок не в машине");
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_carcolour(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "ПРАВКА: /carcolour [id игрока] [цвет 1] [цвет 2] (установить цвет машины)");
		new player1 = strval(tmp), colour1, colour2, string[128];
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
            if(IsPlayerInAnyVehicle(player1)) {
		       	CMDMessageToAdmins(playerid,"CARCOLOUR");
				format(string, sizeof(string), " Вы изменили цвет игроку %s транспорта %s на %d,%d", pName(player1), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2 ); SendClientMessage(playerid,COLOR_GREEN,string);
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s изменил цвет вашего транспорта %s на %d,%d", pName(playerid), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2 ); SendClientMessage(player1,COLOR_GREEN,string); }
   				return ChangeVehicleColor(GetPlayerVehicleID(player1), colour1, colour2);
			} else return SendClientMessage(playerid,red,"ОШИБКА: Игрок не в машине");
	    } else return SendClientMessage(playerid,red,"ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_god(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
    	if(PlayerInfo[playerid][God] == 0)	{
   	    	PlayerInfo[playerid][God] = 1;
    	    SetPlayerHealthAC(playerid,100000);
			GivePlayerWeapon(playerid,16,50000); GivePlayerWeapon(playerid,26,50000);
           	SendClientMessage(playerid,green," ВКЛЮЧЕН РЕЖИМ БОГА");
			return CMDMessageToAdmins(playerid,"GOD");
		} else {
   	        PlayerInfo[playerid][God] = 0;
       	    SendClientMessage(playerid,red," ВЫКЛЮЧЕН РЕЖИМ БОГА");
        	SetPlayerHealthAC(playerid, 100);
		} return GivePlayerWeapon(playerid,35,0);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_sgod(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
   		if(PlayerInfo[playerid][God] == 0)	{
        	PlayerInfo[playerid][God] = 1;
	        SetPlayerHealthAC(playerid,100000);
			GivePlayerWeapon(playerid,16,50000); GivePlayerWeapon(playerid,26,50000);
            return SendClientMessage(playerid,green," ВКЛЮЧЕН РЕЖИМ БОГА");
		} else	{
   	        PlayerInfo[playerid][God] = 0;
            SendClientMessage(playerid,red," ВЫКЛЮЧЕН РЕЖИМ БОГА");
	        SetPlayerHealthAC(playerid, 100); return GivePlayerWeapon(playerid,35,0);	}
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_godcar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
		if(IsPlayerInAnyVehicle(playerid)) {
	    	if(PlayerInfo[playerid][GodCar] == 0) {
        		PlayerInfo[playerid][GodCar] = 1;
   				CMDMessageToAdmins(playerid,"GODCAR");
            	return SendClientMessage(playerid,green," ВАША ТАЧКА НЕ УЯЗВИМА");
			} else {
	            PlayerInfo[playerid][GodCar] = 0;
    	        return SendClientMessage(playerid,red," ВАША ТАЧКА УЯЗВИМА"); }
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны быть в машине");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_die(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
		new Float:x, Float:y, Float:z ;
		GetPlayerPos( playerid, Float:x, Float:y, Float:z );
		CreateExplosion(Float:x+10, Float:y, Float:z, 8,10.0);
		CreateExplosion(Float:x-10, Float:y, Float:z, 8,10.0);
		CreateExplosion(Float:x, Float:y+10, Float:z, 8,10.0);
		CreateExplosion(Float:x, Float:y-10, Float:z, 8,10.0);
		CreateExplosion(Float:x+10, Float:y+10, Float:z, 8,10.0);
		CreateExplosion(Float:x-10, Float:y+10, Float:z, 8,10.0);
		return CreateExplosion(Float:x-10, Float:y-10, Float:z, 8,10.0);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_getid(playerid,params[]) {
	if(!strlen(params)) return SendClientMessage(playerid,red," ПРАВКА: /getid [ник] (информация о игроке)");
	new found, string[128], playername[MAX_PLAYER_NAME];
	format(string,sizeof(string)," Инфо о: %s",params);
	SendClientMessage(playerid,COLOR_GREEN,string);
	for(new i=0; i <= MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
	  		GetPlayerName(i, playername, MAX_PLAYER_NAME);
			new namelen = strlen(playername);
			new bool:searched=false;
	    	for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playername,params,true) == pos)
					{
		                found++;
						format(string,sizeof(string),"%d. %s (ID: %d)",found,playername,i);
						SendClientMessage(playerid, green ,string);
						searched = true;
					}
				}
			}
		}
	}
	if(found == 0) SendClientMessage(playerid, 0x33CCFFFF, " Нет такого игрока или неверное имя");
	return 1;
}



dcmd_vsay(playerid,params[]) {
#pragma unused params
if(PlayerInfo[playerid][pVippp] >= 1) {
if(!strlen(params)) return SendClientMessage(playerid, red, " Правка: /vsay [текст] (говорить в чат от vip)");
new string[128];
if(PlayerInfo[playerid][pVippp] == 1)
{
format(string, sizeof(string), "{E6FF00}*** ViP Игрок %s: {DEDA48}%s", PlayerName2(playerid), params[0] );
SendClientMessageToAll(0x33AA33AA,string);
return true;
}
else if(PlayerInfo[playerid][pVippp] == 2)
{
format(string, sizeof(string), "{E6FF00}*** Gold ViP Игрок %s: {DEDA48}%s", PlayerName2(playerid), params[0] );
SendClientMessageToAll(0x33AA33AA,string);
return true;
}
else if(PlayerInfo[playerid][pVippp] == 3)
{
format(string, sizeof(string), "{E6FF00}*** Diamond ViP Игрок %s: {DEDA48}%s", PlayerName2(playerid), params[0] );
SendClientMessageToAll(0x33AA33AA,string);
return true;
}
return PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
}

dcmd_asay(playerid,params[]) {
#pragma unused params
if(PlayerInfo[playerid][Level] >= 2) {
if(!strlen(params)) return SendClientMessage(playerid, red, " Правка: /asay [текст] (говорить в чат от админа)");
new string[128];
if(PlayerInfo[playerid][Level] == 1)
{
format(string, sizeof(string), "{848484}*** Лидер %s: {D8D8D8}%s", PlayerName2(playerid), params[0] ); // лидер игрок
SendClientMessageToAll(0x33AA33AA,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 2)
{
format(string, sizeof(string), "{DF7401}*** Модератор %s: {FAAC58}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 3)
{
format(string, sizeof(string), "{DF7401}*** Модератор %s: {FAAC58}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 4)
{
format(string, sizeof(string), "{DF7401}*** Модератор %s: {FAAC58}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 5)
{
format(string, sizeof(string), "{DF3A01}*** Главный Модератор %s: {FE642E}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 6)
{
format(string, sizeof(string), "{FA5858}*** Админ %s: {F78181}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 7)
{
format(string, sizeof(string), "{FA5858}*** Админ %s: {F78181}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 8)
{
format(string, sizeof(string), "{FF0080}***ViP Админ %s: {F781BE}%s", PlayerName2(playerid), params[0] ); // модер
SendClientMessageToAll(yellow,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 9)
{
format(string, sizeof(string), "{FF0080}*** ViP Админ %s: {F781BE}%s", PlayerName2(playerid), params[0] ); // админ
SendClientMessageToAll(COLOR_WHITE,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 10)
{
format(string, sizeof(string), "{04B404}*** Зам Главного Админа %s: {81F781}%s", PlayerName2(playerid), params[0] ); // админ
SendClientMessageToAll(COLOR_WHITE,string);
return 1;
}
else if(PlayerInfo[playerid][Level] == 11)
{
format(string, sizeof(string), "{D7DF01}*** Главный Админ %s: {F3F781}%s", PlayerName2(playerid), params[0] ); // админ
SendClientMessageToAll(COLOR_WHITE,string);
return 1;
}
else if(PlayerInfo[playerid][Level] >= 12)
{
format(string, sizeof(string), "{8258FA}*** Создатель %s: {BCA9F5}%s", PlayerName2(playerid), params[0] ); // главный админ
SendClientMessageToAll(green,string);
return 1;
}
return PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2-11 уровней {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setping(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
 		if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setping [пинг] (0-чтобы выключить) (установить пинг для всех)");
	    new string[128], ping = strval(params);
		ServerInfo[MaxPing] = ping;
		CMDMessageToAdmins(playerid,"SETPING");
		new file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		dini_IntSet(file,"MaxPing",ping);
		for(new i = 0; i <= MAX_PLAYERS; i++) if(IsPlayerConnected(i)) PlayerPlaySound(i,1057,0.0,0.0,0.0);
		if(ping == 0) format(string,sizeof(string)," Админ %s выключил максимальный пинг", PlayerName2(playerid), ping);
		else format(string,sizeof(string)," Админ %s изменил максимальный пинг на %d", PlayerName2(playerid), ping);
		return SendClientMessageToAll(COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_ping(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /ping [id игрока] (посмотреть пинг игрока)");
		new player1 = strval(params), string[128];
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		    new Sum, Average, x;
			while (x < PING_MAX_EXCEEDS) {
				Sum += PlayerInfo[player1][pPing][x];
				x++;
			}
			Average = (Sum / PING_MAX_EXCEEDS);
			format(string, sizeof(string), " %s(%d) Его пинг: %d   (Пинг меняется: %d, %d, %d, %d)", PlayerName2(player1), player1, Average, PlayerInfo[player1][pPing][0], PlayerInfo[player1][pPing][1], PlayerInfo[player1][pPing][2], PlayerInfo[player1][pPing][3] );
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lcredits(playerid,params[]) {
	#pragma unused params
	return SendClientMessage(playerid,green,"Deadly Game v9.4. Для проекта Р-Ц Создатель: John_Vibers Версия: 9.4 Exclusive. Дата создания: 21.10.2021");
}

dcmd_serverinfo(playerid,params[]) {
	#pragma unused params
    new TotalVehicles = CreateVehicle(411, 0, 0, 0, 0, 0, 0, 1000);    DestroyVehicle(TotalVehicles);
	new numo = CreateObject(1245,0,0,1000,0,0,0);	DestroyObject(numo);
	new nump = CreatePickup(371,2,0,0,1000);	DestroyPickup(nump);
	new gz = GangZoneCreate(3,3,5,5);	GangZoneDestroy(gz);

	new model[250], nummodel;
	for(new i=1;i<TotalVehicles;i++) model[GetVehicleModel(i)-400]++;
	for(new i=0;i<250;i++)	if(model[i]!=0)	nummodel++;

	new string[256];
	format(string,sizeof(string)," Инфо о серве: [ Игроков: %d || Максимум: %d ] [Пропорция %0.2f ]",ConnectedPlayers(),GetMaxPlayers(),Float:ConnectedPlayers() / Float:GetMaxPlayers() );
	SendClientMessage(playerid,green,string);
	format(string,sizeof(string)," Инфо о серве: [ Машин: %d || Моделей %d || Игроков в машинах: %d || В тачке %d / На мотах %d ]",TotalVehicles-1,nummodel, InVehCount(),InCarCount(),OnBikeCount() );
	SendClientMessage(playerid,green,string);
	format(string,sizeof(string)," Инфо о серве: [ Объектов: %d || Пикапы %d || Ганг-зон %d ]",numo-1, nump, gz);
	SendClientMessage(playerid,green,string);
	format(string,sizeof(string)," Инфо о серве: [ посажено игроков %d || Заморожено игроков %d || Заткнуто %d ]",JailedPlayers(),FrozenPlayers(), MutedPlayers() );
	return SendClientMessage(playerid,green,string);
}

dcmd_jetpack(playerid,params[]) {
    if(!strlen(params))	{
    	if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
			SendClientMessage(playerid,blue," Вы получили летающий ранец.");
			CMDMessageToAdmins(playerid,"JETPACK");
			return SetPlayerSpecialAction(playerid, 2);
		} else return SendClientMessage(playerid,red,"ОШИБКА: У вас нет доступа к этой команде");
	} else {
	    new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
    	player1 = strval(params);
		if(PlayerInfo[playerid][Level] >= 1)	{
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)	{
				CMDMessageToAdmins(playerid,"JETPACK");		SetPlayerSpecialAction(player1, 2);
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string)," Админ %s дал вам летающий ранец",adminname); SendClientMessage(player1,COLOR_GREEN,string);
				format(string,sizeof(string)," Вы дали игроку %s летающий ранец", playername);
				return SendClientMessage(playerid,COLOR_GREEN,string);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	}
}

dcmd_flip(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) {
		    if(IsPlayerInAnyVehicle(playerid)) {
			new VehicleID, Float:X, Float:Y, Float:Z, Float:Angle; GetPlayerPos(playerid, X, Y, Z); VehicleID = GetPlayerVehicleID(playerid);
			GetVehicleZAngle(VehicleID, Angle);	SetVehiclePos(VehicleID, X, Y, Z); SetVehicleZAngle(VehicleID, Angle); SetVehicleHealth(VehicleID,1000.0);
			CMDMessageToAdmins(playerid,"FLIP"); return SendClientMessage(playerid, COLOR_GREEN," Ваша тачка флипована. Флиповать тачку игрока /flip [id]");
			} else return SendClientMessage(playerid,red,"ОШИБКА: Вы не в машине. Флиповать тачку игрока /flip [id]");
		}
	    new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
	    player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"FLIP");
			if (IsPlayerInAnyVehicle(player1)) {
				new VehicleID, Float:X, Float:Y, Float:Z, Float:Angle; GetPlayerPos(player1, X, Y, Z); VehicleID = GetPlayerVehicleID(player1);
				GetVehicleZAngle(VehicleID, Angle);	SetVehiclePos(VehicleID, X, Y, Z); SetVehicleZAngle(VehicleID, Angle); SetVehicleHealth(VehicleID,1000.0);
				CMDMessageToAdmins(playerid,"FLIP");
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string)," Админ %s флиповал вашу тачку",adminname); SendClientMessage(player1,COLOR_GREEN,string);
				format(string,sizeof(string)," Вы флиповали тачку игроку %s", playername);
				return SendClientMessage(playerid, COLOR_GREEN,string);
			} else return SendClientMessage(playerid,red,"ОШИБКА: Игрок не в машине");
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_destroy(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 4) return EraseVehicle(GetPlayerVehicleID(playerid));
	else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_ltc(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(!IsPlayerInAnyVehicle(playerid)) {
			if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
			new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
	        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); CMDMessageToAdmins(playerid,"LTunedCar");	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);
			AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
		    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
		    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,0);
	   	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
			return PlayerInfo[playerid][pCar] = LVehicleIDt;
		} else return SendClientMessage(playerid,red," ОШИБКА: У вас есть машина");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_warp(playerid,params[])
{
	return dcmd_teleplayer(playerid,params);
}

dcmd_teleplayer(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid)) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "ОШИБКА: /warp или /teleplayer [id 1-ого игрока] к [id 2-ого игрока] (телепортировать игрока к игроку)");
		new player1 = strval(tmp), player2 = strval(tmp2), string[128], Float:plocx,Float:plocy,Float:plocz;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: У вас нет доступа к этой команде");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
 		 	if(IsPlayerConnected(player2) && player2 != INVALID_PLAYER_ID) {
	 		 	CMDMessageToAdmins(playerid,"TELEPLAYER");
				GetPlayerPos(player2, plocx, plocy, plocz);
				new intid = GetPlayerInterior(player2);	SetPlayerInterior(player1,intid);
				SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(player2));
				if (GetPlayerState(player1) == PLAYER_STATE_DRIVER)
				{
					new VehicleID = GetPlayerVehicleID(player1);
					SetVehiclePos(VehicleID, plocx, plocy+4, plocz); LinkVehicleToInterior(VehicleID,intid);
					SetVehicleVirtualWorld(VehicleID, GetPlayerVirtualWorld(player2) );
				}
				else SetPlayerPos(player1,plocx,plocy+2, plocz);
				format(string,sizeof(string)," Админ %s телепортировал %s к %s", pName(playerid), pName(player1), pName(player2) );
				SendClientMessage(player1,COLOR_GREEN,string); SendClientMessage(player2,blue,string);
				format(string,sizeof(string)," Вы телепортировали игрока %s к %s", pName(player1), pName(player2) );
 		 	    return SendClientMessage(playerid,COLOR_GREEN,string);
 		 	} else return SendClientMessage(playerid, red, " Нет второго игрока");
		} else return SendClientMessage(playerid, red, " Нет первого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_goto(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid,red," ПРАВКА: /goto [id игрока] (телепортироваться к игроку)");
	    new player1 = strval(params), playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GOTO");
			new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z); SetPlayerInterior(playerid,GetPlayerInterior(player1));
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(player1));
			if(GetPlayerState(playerid) == 2)	{
				SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);	LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player1));
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(player1));
			} else SetPlayerPos(playerid,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			//format(string,sizeof(string),"Administrator %s has teleported to you",adminname);	SendClientMessage(player1,blue,string);
			format(string,sizeof(string)," Вы телепортировались к %s", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lgoto(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid)) {
		new Float:x, Float:y, Float:z;
        new tmp[256], tmp2[256], tmp3[256];
		new string[128], Index;	tmp = strtok(params,Index); tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
    	if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return SendClientMessage(playerid,red," ПРАВКА: /lgoto [x] [y] [z]");
	    x = strval(tmp);		y = strval(tmp2);		z = strval(tmp3);
		CMDMessageToAdmins(playerid,"LGOTO");
		if(GetPlayerState(playerid) == 2) SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
		else SetPlayerPos(playerid,x,y,z);
		format(string,sizeof(string)," Вы телепортированы на %f, %f, %f", x,y,z); return SendClientMessage(playerid,COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_givecar(playerid,params[]) {
if(PlayerInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid)) {
new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp)) return SendClientMessage(playerid, red, " ПРАВКА: /givecar [id] [id машины] (Дать машину игроку)");
new player1 = strval(tmp), carcar, string[128];
new nameadm[24], nameplapla[24];
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
{
if(!IsNumeric(tmp2)) carcar = GetVehicleModelIDFromName(tmp2); else carcar = strval(tmp2);
if(carcar < 400 || carcar > 611) return  SendClientMessage(playerid, red, " ОШИБКА: У игрока есть машина");
if(PlayerInfo[player1][pCar] != -1 ) CarDeleter(PlayerInfo[player1][pCar]);
new LVehicleID,Float:X,Float:Y,Float:Z, Float:Angle,int1;	GetPlayerPos(player1, X,Y,Z);	GetPlayerFacingAngle(player1,Angle);   int1 = GetPlayerInterior(player1);
LVehicleID = CreateVehicle(carcar, X+3,Y,Z, Angle, random(126), random(126), -1); LinkVehicleToInterior(LVehicleID,int1);
PlayerInfo[player1][pCar] = LVehicleID;
CMDMessageToAdmins(playerid,"GIVECAR");
GetPlayerName(playerid, nameadm, sizeof(nameadm));
GetPlayerName(player1, nameplapla, sizeof(nameplapla));
format(string,sizeof(string)," Вы дали игроку %s машину %s",nameplapla,VehicleNames[carcar-400]);
SendClientMessage(playerid,COLOR_GREEN,string);
format(string,sizeof(string)," Админ %s дал вам машину %s",nameadm,VehicleNames[carcar-400]);
return SendClientMessage(player1,COLOR_GREEN,string);
} else return SendClientMessage(playerid, red, " Нет такого игрока");
} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_gethere(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 4) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /gethere [id игрока] (телепортировать к себе игрока)");
    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GETHERE");
			new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z); SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)	{
			    new VehicleID = GetPlayerVehicleID(player1);
				SetVehiclePos(VehicleID,x+3,y,z);   LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
				SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			} else SetPlayerPos(player1,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string)," Админ %s телепортировал вас к себе",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы телепортировали %s к себе", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_get(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /get [id игрока] (телепортировать к себе игрока)");
    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GET");
			new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z); SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)	{
			    new VehicleID = GetPlayerVehicleID(player1);
				SetVehiclePos(VehicleID,x+3,y,z);   LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
				SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			} else SetPlayerPos(player1,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string)," Админ %s доставил вас к себе",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы доставили игрока %s к себе", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_warn(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 2) {
	    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /warn [id игрока] [причина] (выдать предупреждение игроку)");
    	new warned = strval(tmp), str[128];
		if(PlayerInfo[warned][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
	 	if(IsPlayerConnected(warned) && warned != INVALID_PLAYER_ID) {
 	    	if(warned != playerid) {
			    CMDMessageToAdmins(playerid,"WARN");
				PlayerInfo[warned][Warnings]++;
				if( PlayerInfo[warned][Warnings] == MAX_WARNINGS) {
					format(str, sizeof (str), "* Админ %s (%d) предупредил игрока %s (%d) [причина: %s] (Всего причин: %d/%d) *", pName(playerid),playerid, pName(warned),warned, params[1+strlen(tmp)], PlayerInfo[warned][Warnings], MAX_WARNINGS);
					SendClientMessageToAll(COLOR_RED, str);
					SaveToFile("KickLog",str);	Kick(warned);
					return PlayerInfo[warned][Warnings] = 0;
				} else {
					format(str, sizeof (str), "* Админ %s предупредил игрока %s [причина: %s] (Всего причин: %d/%d) *", pName(playerid), pName(warned), params[1+strlen(tmp)], PlayerInfo[warned][Warnings], MAX_WARNINGS);
					return SendClientMessageToAll(yellow, str);
				}
			} else return SendClientMessage(playerid, red, " ОШИБКА: Вы не можете предупредить себя");
		} else return SendClientMessage(playerid, red, " ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setlevelvip(playerid,params[])
{
	if(PlayerInfo[playerid][LoggedIn] == 1){
	    if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
		    new tmp [256];
			new tmp2[256];
			new Index;
			tmp  = strtok(params,Index);
			tmp2 = strtok(params,Index);
		    if(!strlen(params)) return
   			SendClientMessage(playerid, red, "{00F200}*** {FF0000}Используйте: /setlevelvip [ID] [1-3]");
	    	new player1, type, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
			if(!strlen(tmp2)) return
			SendClientMessage(playerid, red, "{00F200}*** {FF0000}Используйте: /setlevelvip [ID] [1-3]") &&
			SendClientMessage(playerid, 0xFF9900FF, "{00F200}*** {FF0000}1 - ViP | 2 - ViP Gold | 3 - ViP Diamond!");
			type = strval(tmp2);
			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID){
				if(PlayerInfo[player1][LoggedIn] == 1){
				if(type > 3)
				return SendClientMessage(playerid,red,"{00F200}*** {FF0000}ОШИБКА: Неверный тип аккаунта!");
				if(type == PlayerInfo[player1][pVip])
				return SendClientMessage(playerid,red,"{00F200}*** {FF0000}ОШИБКА: Игрок уже имеет этот тип аккаунта!");
				GetPlayerName(player1, playername, sizeof(playername));
				GetPlayerName(playerid, adminname, sizeof(adminname));
		       	new year,month,day;
		   		new hour,minute,second;
		  		getdate(year, month, day);
		  		gettime(hour,minute,second);
 				switch(type)
				{
					case 1: AccType = "ViP";
					case 2: AccType = "ViP Gold";
					case 3: AccType = "ViP Diamond";
				}
				if(type > 0)
				format(string,sizeof(string),"{00F200}*** {8b00ff} Создатель {FF0000}%s {8b00ff}установил вам {E6FF00}%s {8b00ff}аккаунт!",adminname,AccType);
				else
				format(string,sizeof(string),"{00F200}*** {8b00ff} Создатель %s забрал у вас {E6FF00}ViP{8b00ff}!",adminname);
				SendClientMessage(player1,0x66C178AA,string);
				if(type > PlayerInfo[player1][pVip])
				GameTextForPlayer(player1,"ViP EC", 2000, 3);
				else GameTextForPlayer(player1,"ViP EC", 2000, 3);
				format(string,sizeof(string),"{00F200}*** {8b00ff}Вы дали %s Тип аккаунта: %s в '%d/%d/%d' в '%d:%d:%d'", playername, AccType, day, month, year, hour, minute, second);
				SendClientMessage(playerid,0x00C378AA,string);
				format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель %s установил %s аккаунт {E6FF00}%s",adminname, playername, AccType);
				dUserSetINT(PlayerName2(player1)).("vippp",(type));
				PlayerInfo[player1][pVip] = type;
				return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				}else return SendClientMessage(playerid,red,"{00F200}*** {FF0000}ОШИБКА: Этот игрок не зарегестрирован или не залогинен!");
			}else return SendClientMessage(playerid,red,"{00F200}*** {FF0000}ОШИБКА: Игрок не авторизован!");
		}else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}else return SendClientMessage(playerid,red,"{00F200}*** {FF0000}ОШИБКА: Вы должны быть залогинены.");
}

dcmd_kick(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
	    if(PlayerInfo[playerid][Level] >= 3) {
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /kick [id] [причина] (кикнуть игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"KICK");
				if(!strlen(tmp2)) {
					format(string,sizeof(string)," {FF0000}Игрока %s(%d) кикнул админ %s(%d) [нет причины] ",playername,player1,adminname,playerid); SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string); print(string); return Kick(player1);
				} else {
					format(string,sizeof(string)," {FF0000}Игрок %s(%d) был кикнут админом %s(%d) [причина: %s] ",playername,player1,adminname,playerid,params[2]); SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string); print(string); return Kick(player1); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы не залогинены");
}

dcmd_vkick(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
        if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 2) { // Сразу и для Создателя!
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /vkick [id] [причина] (кикнуть игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				if(!strlen(tmp2)) {
					format(string,sizeof(string),"{EFF600}Игрока %s(%d) кикнул [G] ViP %s(%d)",playername,player1,adminname,playerid); SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string); print(string); return Kick(player1);
				} else {
					format(string,sizeof(string),"{EFF600}Игрок %s(%d) был кикнут [G] ViP'ом %s(%d) {FF9100}[причина: %s] ",playername,player1,adminname,playerid,params[2]); SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string); print(string); return Kick(player1); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Gold ViP {FF0000}Развлекательного Центра™{EFF600}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы не залогинены");
}

dcmd_ban(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 7) {
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /ban [id] [причина] (забанить игрока)");
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, " ОШИБКА: Вы должны ввести причину");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
				new year,month,day,hour,minuite,second; getdate(year, month, day); gettime(hour,minuite,second);
				CMDMessageToAdmins(playerid,"BAN");
				format(string,sizeof(string),"*** Игрок %s(%d) забанен админом %s(%d) [причина: %s] [Дата: %d/%d/%d] [Время: %d:%d]",playername,player1,adminname,playerid,params[2],day,month,year,hour,minuite);
				SendClientMessageToAll(COLOR_RED,string);
				SaveToFile("BanLog",string);
				print(string);
				if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("banned",1);
				format(string,sizeof(string)," Забанен админом %s [причина: %s]", adminname, params[2] );
				return BanEx(player1, string);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_vban(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
        if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 3) { // Сразу и для Создателя!
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /vban [id] [причина] (забанить игрока)");
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, " ОШИБКА: Вы должны ввести причину");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
				new year,month,day,hour,minuite,second; getdate(year, month, day); gettime(hour,minuite,second);
				format(string,sizeof(string),"{EFF600}*** Игрок %s(%d) забанил ViP %s(%d) {FF9100}[%s] [Дата: %d/%d/%d] [Время: %d:%d]",playername,player1,adminname,playerid,params[2],day,month,year,hour,minuite);
				SendClientMessageToAll(COLOR_RED,string);
				SaveToFile("BanLog",string);
				print(string);
				if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("banned",1);
				format(string,sizeof(string)," Забанен [D] ViP'ом %s [причина: %s]", adminname, params[2] );
				return BanEx(player1, string);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Diamond ViP {FF0000}Развлекательного Центра™{EFF600}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}


dcmd_vslap(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
        if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 2) { // Сразу и для Создателя!
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /vslap [id игрока] [причина] (пнуть игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
		        new Float:Health, Float:x, Float:y, Float:z; GetPlayerHealth(player1,Health); SetPlayerHealthAC(player1,Health-25);
				GetPlayerPos(player1,x,y,z); SetPlayerPos(player1,x,y,z+5); PlayerPlaySound(playerid,1190,0.0,0.0,0.0); PlayerPlaySound(player1,1190,0.0,0.0,0.0);
				if(strlen(tmp2)) {
					format(string,sizeof(string)," {EFF600}*** [G] ViP Игрок %s(%d) пнул игрока %s(%d) {FF9100}[Причина: %s]",adminname,playerid,playername,player1,params[2]); SendClientMessageToAll(COLOR_RED,string);
					format(string,sizeof(string)," {EFF600}Вас пнул [G] ViP {FF9100}%s {EFF600}по причине %s ",adminname,params[2]);	SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," {EFF600}Вы пнули игрока %s по причине %s ",playername,params[2]); return SendClientMessage(playerid,COLOR_RED,string);
				} else {
                    format(string,sizeof(string)," {EFF600}*** [G] ViP Игрок {FF9100}%s(%d) {EFF600}*пнул игрока {FF9100}%s(%d)",adminname,playerid,playername,player1); SendClientMessageToAll(COLOR_RED,string);
					format(string,sizeof(string)," {EFF600}Вас пнул [G] ViP {FF9100}%s{EFF600} , - 25хп........... LoL :3!",adminname);	SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," {EFF600}Вы пнули игрока {FF9100}%s",playername); return SendClientMessage(playerid,COLOR_RED,string); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Gold ViP {FF0000}Развлекательного Центра™{EFF600}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_slap(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /slap [id игрока] [причина] (пнуть игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"SLAP");
		        new Float:Health, Float:x, Float:y, Float:z; GetPlayerHealth(player1,Health); SetPlayerHealthAC(player1,Health-25);
				GetPlayerPos(player1,x,y,z); SetPlayerPos(player1,x,y,z+5); PlayerPlaySound(playerid,1190,0.0,0.0,0.0); PlayerPlaySound(player1,1190,0.0,0.0,0.0);

				if(strlen(tmp2)) {
					format(string,sizeof(string)," {FF0000}*** Администратор %s(%d) пнул игрока %s(%d) [Причина: %s]",adminname,playerid,playername,player1,params[2]); SendClientMessageToAll(COLOR_RED,string);
					format(string,sizeof(string)," {FF0000}Вас пнул администратор %s по причине %s ",adminname,params[2]);	SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," {FF0000}Вы пнули игрока %s по причине %s ",playername,params[2]); return SendClientMessage(playerid,COLOR_RED,string);
				} else {
                    format(string,sizeof(string)," {FF0000}Администратор %s(%d) пнул игрока %s(%d) [Причина не указана]",adminname,playerid,playername,player1); SendClientMessageToAll(COLOR_RED,string);
					format(string,sizeof(string)," {FF0000}Вас пнул администратор %s ",adminname);	SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," {FF0000}Вы пнули игрока %s",playername); return SendClientMessage(playerid,COLOR_RED,string); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_explode(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /explode [id игрока] [причина] (взорвать игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername)); 	GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"EXPLODE");
				new Float:burnx, Float:burny, Float:burnz; GetPlayerPos(player1,burnx, burny, burnz); CreateExplosion(burnx, burny , burnz, 7,10.0);

				if(strlen(tmp2)) {
					format(string,sizeof(string)," {FF0000}Вы были взорваны админом %s [причина: %s]",adminname,params[2]); SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," {FF0000}Вы взорвали игрока %s [причина: %s]", playername,params[2]); return SendClientMessage(playerid,COLOR_RED,string);
				} else {
					format(string,sizeof(string)," {FF0000}Вы были взорваны админом %s",adminname); SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," {FF0000}Вы взорвали игрока %s", playername); return SendClientMessage(playerid,COLOR_RED,string); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_jail(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
		    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /jail [id игрока] [минуты] [причина]");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				if(PlayerInfo[player1][Jailed] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new jtime = strval(tmp2);
					if(jtime == 0) jtime = 9999;

			       	CMDMessageToAdmins(playerid,"JAIL");
					PlayerInfo[player1][JailTime] = jtime*1000*60;
    			    SetTimerEx("JailPlayer",5000,0,"d",player1);
		    	    SetTimerEx("Jail1",1000,0,"d",player1);
		    	    dUserSetINT(PlayerName2(player1)).("jailed",1);
		        	PlayerInfo[player1][Jailed] = 1;
		        	TogglePlayerControllable(player1,false);

					if(jtime == 9999) {
						if(!params[2]) format(string,sizeof(string)," {FF0000}*** Админ %s(%d) посадил %s(%d)",adminname,playerid, playername,player1);
						else format(string,sizeof(string)," {FF0000}*** Админ %s(%d) посадил игрока %s(%d) [причина: %s]",adminname,playerid, playername,player1, params[2] );
   					} else {
						if(!params[3+1]) format(string,sizeof(string)," {FF0000}*** Админ %s(%d) посадил игрока %s(%d) на %d минут",adminname,playerid, playername,player1, jtime);
						else format(string,sizeof(string)," {FF0000}*** Админ %s(%d) посадил игрока %s(%d) на %d минут [причина: %s]",adminname,playerid, playername,player1, jtime, params[3+1] );
					}
	    			return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, " Игрок уже посажен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_unjail(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
		    new tmp[256], Index; tmp = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /unjail [id игрока]");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				if(PlayerInfo[player1][Jailed] == 1) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					format(string,sizeof(string),"*** Админ %s выпустил тебя",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
					format(string,sizeof(string),"*** Админ %s(%d) выпустил %s(%d)",adminname,playerid, playername,player1);
					JailRelease(player1);
					TogglePlayerControllable(player1,true);
					dUserSetINT(PlayerName2(player1)).("jailed",0);
					return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не посажен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_jailed(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
	 		new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Jailed]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, " Нет посаженых игроков");

		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Jailed]) {
	    		GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2) { format(string, sizeof(string), " Посаженые игроки: (%d)%s", i,adminname); First2 = true; }
		        else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
	        }
		    return SendClientMessage(playerid,COLOR_WHITE,string);
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_freeze(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
		    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /freeze [id игрока] [минуты] [причина] (заморозить игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][Frozen] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new ftime = strval(tmp2);
					if(ftime == 0) ftime = 9999;

			       	CMDMessageToAdmins(playerid,"FREEZE");
					TogglePlayerControllable(player1,false); PlayerInfo[player1][Frozen] = 1; PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					PlayerInfo[player1][FreezeTime] = ftime*1000*60;
			        FreezeTimer[player1] = SetTimerEx("UnFreezeMe",PlayerInfo[player1][FreezeTime],0,"d",player1);
			        dUserSetINT(PlayerName2(player1)).("frozen",1);

					if(ftime == 9999) {
						if(!params[2]) format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заморозил %s(%d)",adminname,playerid, playername,player1);
						else format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заморозил %s(%d) [причина: %s]",adminname,playerid, playername,player1, params[2] );
	   				} else {
						if(!params[3+1]) format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заморозил %s(%d) на %d минут",adminname,playerid, playername,player1, ftime);
						else format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заморозил %s(%d) на %d минут [причина: %s]",adminname,playerid, playername,player1, ftime, params[3+1] );
					}
		    		return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, " Игрок уже заморожен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_unfreeze(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
	    if(PlayerInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid)) {
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /unfreeze [id игрока] (разморозить игрока)");
	    	new player1, string[128];
			player1 = strval(params);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		 	    if(PlayerInfo[player1][Frozen] == 1) {
			       	CMDMessageToAdmins(playerid,"UNFREEZE");
			       	dUserSetINT(PlayerName2(player1)).("frozen",0);
					UnFreezeMe(player1);
					format(string,sizeof(string),"*** Админ %s разморозил вас", PlayerName2(playerid) ); SendClientMessage(player1,COLOR_GREEN,string);
					format(string,sizeof(string),"*** Админ %s разморозил %s", PlayerName2(playerid), PlayerName2(player1));
		    		return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не заморожен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_frozen(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
	 		new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Frozen]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, " Нет замороженых игроков");

		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Frozen]) {
	    		GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2) { format(string, sizeof(string), " Замороженые игроки: (%d)%s", i,adminname); First2 = true; }
		        else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
	        }
		    return SendClientMessage(playerid,COLOR_WHITE,string);
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_vmute(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
        if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 3) { // Сразу и для Создателя!
		    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, "** ПРАВКА: /vmute [id игрока] [минуты] [причина] (Заткнуть игрока) ");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][Muted] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new mtime = strval(tmp2);
					if(mtime == 0) mtime = 9999;
					PlayerInfo[player1][Muted] = 1; PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					PlayerInfo[player1][MuteWarnings] = 0;
					PlayerInfo[player1][MutedTime] = mtime*1000*60;
			        MutedTimer[player1] = SetTimerEx("UnMute",PlayerInfo[player1][MutedTime],0,"d",player1);
			        if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("mute",1);
					if(mtime == 9999) {
						if(!params[2]) format(string,sizeof(string),"{EFF600}*** [D] ViP Игрок {FF9100}%s(%d) {EFF600}заткнул {FF9100}%s(%d)",adminname,playerid, playername,player1);
						else format(string,sizeof(string),"{EFF600}*** [D] ViP Игрок %s(%d) заткнул %s(%d) {FF9100}[причина: %s]",adminname,playerid, playername,player1, params[2] );
	   				} else {
						if(!params[3+1]) format(string,sizeof(string),"{EFF600}*** [D] ViP Игрок %s(%d) заткнул %s(%d) на %d минут",adminname,playerid, playername,player1, mtime);
						else format(string,sizeof(string),"{EFF600}*** [D] ViP Игрок %s(%d) заткнул %s(%d) на %d минут {FF9100}[причина: %s]",adminname,playerid, playername,player1, mtime, params[3+1] );
					} return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, "** Игрок уже заткнут");
			} else return SendClientMessage(playerid, red, "** Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Diamond ViP {FF0000}Развлекательного Центра™{EFF600}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_vunmute(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
	    if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /vunmute [id игрока] (Разоткнуть игрока) ");
	    	new player1, string[128];
			player1 = strval(params);
		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		 	    if(PlayerInfo[player1][Muted] == 1) {
					KillTimer( MutedTimer[player1] );
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);	GameTextForPlayer(player1,"~g~PA3OTKHYT",3000,3);
					if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("mute",0);
					PlayerInfo[player1][Muted] = 0; PlayerInfo[player1][MuteWarnings] = 0;
					format(string,sizeof(string),"{EFF600}*** [D] ViP Игрок {FF9100}%s(%d) {EFF600}разоткнул {FF9100}%s(%d) ", PlayerName2(playerid),playerid, PlayerName2(player1),player1);
					if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("mute",0);
		    		return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не заткнут");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Diamond ViP {FF0000}Развлекательного Центра™{EFF600}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_mute(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
		    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /mute [id игрока] [минуты] [причина] (Заткнуть игрока) ");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][Muted] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new mtime = strval(tmp2);
					if(mtime == 0) mtime = 9999;

			       	CMDMessageToAdmins(playerid,"MUTE");
					PlayerInfo[player1][Muted] = 1; PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					PlayerInfo[player1][MuteWarnings] = 0;
					PlayerInfo[player1][MutedTime] = mtime*1000*60;
			        MutedTimer[player1] = SetTimerEx("UnMute",PlayerInfo[player1][MutedTime],0,"d",player1);
			        if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("mute",1);

					if(mtime == 9999) {
						if(!params[2]) format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заткнул %s(%d)",adminname,playerid, playername,player1);
						else format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заткнул %s(%d) [причина: %s]",adminname,playerid, playername,player1, params[2] );
	   				} else {
						if(!params[3+1]) format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заткнул %s(%d) на %d минут",adminname,playerid, playername,player1, mtime);
						else format(string,sizeof(string),"{FF0000}*** Админ %s(%d) заткнул %s(%d) на %d минут [причина: %s]",adminname,playerid, playername,player1, mtime, params[3+1] );
					} return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, " Игрок уже заткнут");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_unmute(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
	    if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /unmute [id игрока] (Разоткнуть игрока) ");
	    	new player1, string[128];
			player1 = strval(params);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
		 	    if(PlayerInfo[player1][Muted] == 1) {
			       	CMDMessageToAdmins(playerid,"UNMUTE");
					KillTimer( MutedTimer[player1] );
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);	GameTextForPlayer(player1,"~g~PA3OTKHYT",3000,3);
					if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("mute",0);
					PlayerInfo[player1][Muted] = 0; PlayerInfo[player1][MuteWarnings] = 0;
					format(string,sizeof(string),"*** Админ %s(%d) разоткнул %s(%d) ", PlayerName2(playerid),playerid, PlayerName2(player1),player1);
					if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("mute",0);
		    		return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не заткнут");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_muted(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
	 		new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Muted]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, " Нет заткнутых игроков");

		    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Muted]) {
	    		GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2) { format(string, sizeof(string), " Заткнутые игроки: (%d)%s", i,adminname); First2 = true; }
		        else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
	        }
		    return SendClientMessage(playerid,COLOR_WHITE,string);
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_akill(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
	    if(PlayerInfo[playerid][Level] >= 10|| IsPlayerAdmin(playerid)) {
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /akill [id игрока] (убить игрока)");
	    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);

		 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if( (PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel] ) )
					return SendClientMessage(playerid, red, " Вы не можете убить админа выше вас уровнем");
				CMDMessageToAdmins(playerid,"AKILL");
				GetPlayerName(player1, playername, sizeof(playername));	GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string),"{FF0000** Админ %s убил вас",adminname);	SendClientMessage(player1,COLOR_RED,string);
				format(string,sizeof(string)," {FF0000}Вы убили игрока %s",playername); SendClientMessage(playerid,COLOR_RED,string);
				return SetPlayerHealthAC(player1,0.0);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 10 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
}

dcmd_weaps(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /weaps [id игрока] (получить оружие)");
    	new player1, string[128], string2[64], WeapName[24], slot, weap, ammo, Count, x;
		player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string2,sizeof(string2),"[>> %s Оружия (id:%d) <<]", PlayerName2(player1), player1); SendClientMessage(playerid,COLOR_GREEN,string2);
			for (slot = 0; slot < 14; slot++) {	GetPlayerWeaponData(player1, slot, weap, ammo); if( ammo != 0 && weap != 0) Count++; }
			if(Count < 1) return SendClientMessage(playerid,COLOR_GREEN," У игрока нет оружия");

			if(Count >= 1)
			{
				for (slot = 0; slot < 14; slot++)
				{
					GetPlayerWeaponData(player1, slot, weap, ammo);
					if( ammo != 0 && weap != 0)
					{
						GetWeaponName(weap, WeapName, sizeof(WeapName) );
						if(ammo == 65535 || ammo == 1) format(string,sizeof(string),"%s%s (1)",string, WeapName );
						else format(string,sizeof(string),"%s%s (%d)",string, WeapName, ammo );
						x++;
						if(x >= 5)
						{
						    SendClientMessage(playerid, blue, string);
						    x = 0;
							format(string, sizeof(string), "");
						}
						else format(string, sizeof(string), "%s,  ", string);
					}
			    }
				if(x <= 4 && x > 0) {
					string[strlen(string)-3] = '.';
				    SendClientMessage(playerid, blue, string);
				}
		    }
		    return 1;
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_aka(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /aka [id игрока] (посмотреть все ники под которыми был зареган игрок)");
    	new player1, playername[MAX_PLAYER_NAME], str[128], tmp3[50];
		player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
  		  	GetPlayerIp(player1,tmp3,50);
			GetPlayerName(player1, playername, sizeof(playername));
		    format(str,sizeof(str),"AKA: [%s id:%d] [%s] %s", playername, player1, tmp3, dini_Get("ladmin/config/aka.txt",tmp3) );
	        return SendClientMessage(playerid,blue,str);
		} else return SendClientMessage(playerid, red, " Нет такого игрока or is yourself");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_screen(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
	    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /screen [id игрока] [текст] (сделать скрин)");
    	new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);

	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			CMDMessageToAdmins(playerid,"SCREEN");
			format(string,sizeof(string)," Админ %s отправил вам сообщение на экран",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы отправили игроку %s сообщение на экран (%s)", playername, params[2]); SendClientMessage(playerid,COLOR_GREEN,string);
			return GameTextForPlayer(player1, params[2],4000,3);
		} else return SendClientMessage(playerid, red, " Нет такого игрока или это вы или это админ выше вас уровнем");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_laston(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 2) {
    	new tmp2[256], file[256],player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], str[128];
		GetPlayerName(playerid, adminname, sizeof(adminname));

	    if(!strlen(params)) {
			format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(adminname));
			if(!fexist(file)) return SendClientMessage(playerid, red, " ОШИБКА: Нет зарегистрированых игроков которые заходили сюда ближайшее время");
			if(dUserINT(PlayerName2(playerid)).("LastOn")==0) {	format(str, sizeof(str),"Never"); tmp2 = str;
			} else { tmp2 = dini_Get(file,"LastOn"); }
			format(str, sizeof(str),"You were last on the server on %s",tmp2);
			return SendClientMessage(playerid, red, str);
		}
		player1 = strval(params);
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"LASTON");
   	    	GetPlayerName(player1,playername,sizeof(playername)); format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(playername));
			if(!fexist(file)) return SendClientMessage(playerid, red, " ОШИБКА: Нет зарегистрированых игроков которые заходили сюда ближайшее время");
			if(dUserINT(PlayerName2(player1)).("LastOn")==0) { format(str, sizeof(str),"Never"); tmp2 = str;
			} else { tmp2 = dini_Get(file,"LastOn"); }
			format(str, sizeof(str)," %s был последним на сервере %s",playername,tmp2);
			return SendClientMessage(playerid, red, str);
		} else return SendClientMessage(playerid, red, " Нет такого игрока или это вы");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_admins(playerid,params[]) {
    #pragma unused params

	if(PlayerInfo[playerid][LoggedIn] == 0) return SendClientMessage(playerid,red," [Ошибка] Вы должны быть залогинены...");

	new Count, i, string[128];
	for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
	{
		if(PlayerInfo[i][Level] > 0) Count++;
	}

    #if defined HIDE_ADMINS
	if(PlayerInfo[playerid][Level] == 0) {
		if(Count >= 1) {
			format(string, sizeof(string), " Здесь %d админов. Используйте /report <id игрока> <причина> и ваша жалоба на игрока будет отправлена администраторам", Count[0]);
			return SendClientMessage(playerid, blue, string);
		} else return SendClientMessage(playerid, blue, " Нет админов в игре");
	}
	#endif

	if(Count == 0) return ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"{0033FF}Админы Онлайн","{32D0F8}Увы но в данный момент на Сервере нет Админов...","Понятно",":(");

	if(Count == 1) {
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Level] > 0) { //{FFFF00}Посажен:{0000FF}
			format(string, sizeof(string), "{BF37F2}ID: {5C37F2}%d {BF37F2}Ник: {5C37F2}%s {BF37F2}Уровень: {5C37F2}%d\n", i, PlayerName2(i), PlayerInfo[i][Level] ); ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"{0033FF}Админы Онлайн",string,"Понятно",";)");
//			format(string, sizeof(string), "{FFFFFF}=======================================\n\n   {BF37F2}[ID:%d] {9138F1}%s {5C37F2}[lvl:%d]\n\n{FFFFFF}=======================================", i, PlayerName2(i), PlayerInfo[i][Level] ); ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"         {0033FF}Список Админов Онлайн {FF0000}E-C",string,"Понятно",";)");
		}
	}

 	if(Count > 1) {
	    new string2[1024];//350
	    new string3[1024];//400
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Level] > 0)
		{
		//			format(string,sizeof(string),"   \n\n{BF37F2}[ID:%d] {9138F1}%s {5C37F2}[lvl:%d]",i,PlayerName2(i),PlayerInfo[i][Level]);
			format(string,sizeof(string),"\n{BF37F2}ID: {5C37F2}%d {BF37F2}Ник: {5C37F2}%s {BF37F2}Уровень: {5C37F2}%d",i,PlayerName2(i),PlayerInfo[i][Level]);
			format(string2, sizeof(string2), "%s%s", string2,string);
			string[strlen(string)-3] = '.';

		}
		//		format(string3, sizeof(string3), "{FFFFFF}=======================================%s\n\n{FFFFFF}=======================================", string2);
		format(string3, sizeof(string3), "%s\n", string2);
		ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"{0033FF}Админы Онлайн",string3,"Понятно",";)");
	}

	return 1;
}

dcmd_vips(playerid,params[]) {
    #pragma unused params

	if(PlayerInfo[playerid][LoggedIn] == 0) return SendClientMessage(playerid,red," [Ошибка] Вы должны быть залогинены...");

	new Count, i, string[128];
	for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
	{
		if(PlayerInfo[i][pVip] > 0) Count++;
	}

    #if defined HIDE_ADMINS
	if(PlayerInfo[playerid][Level] == 0) {
		if(Count >= 1) {
			format(string, sizeof(string), " Здесь %d админов. Используйте /report <id игрока> <причина> и ваша жалоба на игрока будет отправлена администраторам", Count[0]);
			return SendClientMessage(playerid, blue, string);
		} else return SendClientMessage(playerid, blue, " Нет админов в игре");
	}
	#endif

	if(Count == 0) return ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"{0033FF}ViP's Онлайн","{32D0F8}Онлайн ViP'ов нет!","Понятно",":(");

	if(Count == 1) {
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][pVip] > 0) { 
			format(string, sizeof(string), "{BF37F2}ID: {5C37F2}%d {BF37F2}Ник: {5C37F2}%s {BF37F2}Уровень ViP: {5C37F2}%d\n", i, PlayerName2(i), PlayerInfo[i][pVip] ); ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"{0033FF}ViP's Онлайн",string,"Понятно",";)");
		}
	}

 	if(Count > 1) {
	    new string2[1024];//350
	    new string3[1024];//400
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][pVip] > 0)
		{
			format(string,sizeof(string),"\n{BF37F2}ID: {5C37F2}%d {BF37F2}Ник: {5C37F2}%s {BF37F2}Уровень ViP: {5C37F2}%d",i,PlayerName2(i),PlayerInfo[i][pVip]);
			format(string2, sizeof(string2), "%s%s", string2,string);
			string[strlen(string)-3] = '.';
		}
		format(string3, sizeof(string3), "%s\n", string2);
		ShowPlayerDialog(playerid,6705,DIALOG_STYLE_MSGBOX,"{0033FF}ViP's Онлайн",string3,"Понятно",";)");
	}

	return 1;
}

dcmd_setlevel(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
		    new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setlevel [id игрока] [уровень] (установить уровень админа игроку)");
	    	new player1, level, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /setlevel [id игрока] [уровень] (установить уровень админа игроку)");
			level = strval(tmp2);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][LoggedIn] == 1) {
					if(level > ServerInfo[MaxAdminLevel] ) return SendClientMessage(playerid,red," ОШИБКА: Не верный уровень");
					if(level == PlayerInfo[player1][Level]) return SendClientMessage(playerid,red," ОШИБКА: Игрок уже этого уровня");
	       			CMDMessageToAdmins(playerid,"SETLEVEL");
					GetPlayerName(player1, playername, sizeof(playername));	GetPlayerName(playerid, adminname, sizeof(adminname));
			       	new year,month,day;   getdate(year, month, day); new hour,minute,second; gettime(hour,minute,second);

					if(level > 0) format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}повысил вас в уровне {FF0000}%d",adminname, level);
					else format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s понизил вас в уровне {FF0000}%d",adminname, level);
					SendClientMessage(player1,COLOR_GREEN,string);

					if(level > PlayerInfo[player1][Level]) GameTextForPlayer(player1,"ZOBSCNLN", 2000, 3);
					else GameTextForPlayer(player1,"PONIZILI", 2000, 3);

					format(string,sizeof(string)," Вы сделали игрока %s %d уровня %d/%d/%d в %d:%d:%d", playername, level, day, month, year, hour, minute, second); SendClientMessage(playerid,COLOR_GREEN,string);
					format(string,sizeof(string)," Создатель %s сделал %s %d уровня %d/%d/%d в %d:%d:%d",adminname, playername, level, day, month, year, hour, minute, second);
					SaveToFile("AdminLog",string);
					dUserSetINT(PlayerName2(player1)).("level",(level));
					PlayerInfo[player1][Level] = level;
					return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				} else return SendClientMessage(playerid,red," ОШИБКА: Игрок должен быть зареган и залогинин");
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	} else return SendClientMessage(playerid,red,"ОШИБКА: Вы должны залогиниться");
}

dcmd_report(playerid,params[]) {
    new reported, tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /report [id игрока] [причина жалобы]");
	reported = strval(tmp);

 	if(IsPlayerConnected(reported) && reported != INVALID_PLAYER_ID) {
		if(PlayerInfo[reported][Level] == ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете пожаловаться на админа");
		if(playerid == reported) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете пожаловаться на себя");
		if(strlen(params) > 7) {
			new reportedname[MAX_PLAYER_NAME], reporter[MAX_PLAYER_NAME], str[128], hour,minute,second; gettime(hour,minute,second);
			GetPlayerName(reported, reportedname, sizeof(reportedname));	GetPlayerName(playerid, reporter, sizeof(reporter));
			format(str, sizeof(str), " [Жалоба на читера] %s(%d) жалуется на %s(%d) Причина: %s |@%d:%d:%d|", reporter,playerid, reportedname, reported, params[strlen(tmp)+1], hour,minute,second);
			MessageToAdmins(COLOR_WHITE,str);
			SaveToFile("ReportLog",str);
			format(str, sizeof(str), " ЖАЛОБА(%d:%d:%d): %s(%d) жалуется %s(%d) Причина: %s", hour,minute,second, reporter,playerid, reportedname, reported, params[strlen(tmp)+1]);
			for(new i = 1; i < MAX_REPORTS-1; i++) Reports[i] = Reports[i+1];
			Reports[MAX_REPORTS-1] = str;
			return SendClientMessage(playerid,yellow, " Ваша жалоба отправлена всем админам, которые сейчас в игре.");
		} else return SendClientMessage(playerid,red," ОШИБКА: Слишком короткая жалоба");
	} else return SendClientMessage(playerid, red, " Нет такого игрока");
}

dcmd_reports(playerid,params[]) {
    #pragma unused params
    if(PlayerInfo[playerid][Level] >= 1) {
        new ReportCount;
		for(new i = 1; i < MAX_REPORTS; i++)
		{
			if(strcmp( Reports[i], "<none>", true) != 0) { ReportCount++; SendClientMessage(playerid,COLOR_WHITE,Reports[i]); }
		}
		if(ReportCount == 0) SendClientMessage(playerid,COLOR_WHITE," Нет ни одной жалобы");
    } else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;
}

dcmd_richlist(playerid,params[]) {
    #pragma unused params
    if(PlayerInfo[playerid][Level] >= 1) {
 		new string[128], Slot1 = -1, Slot2 = -1, Slot3 = -1, Slot4 = -1, HighestCash = -9999;
 		SendClientMessage(playerid,COLOR_WHITE," Список богачей:");

		for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x)) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot1 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x) && x != Slot1) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot2 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x) && x != Slot1 && x != Slot2) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot3 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<MAX_PLAYERS; x++) if (IsPlayerConnected(x) && x != Slot1 && x != Slot2 && x != Slot3) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot4 = x;
		}
		format(string, sizeof(string), "(%d) %s - $%d", Slot1,PlayerName2(Slot1),GetPlayerMoney(Slot1) );
		SendClientMessage(playerid,COLOR_WHITE,string);
		if(Slot2 != -1)	{
			format(string, sizeof(string), "(%d) %s - $%d", Slot2,PlayerName2(Slot2),GetPlayerMoney(Slot2) );
			SendClientMessage(playerid,COLOR_WHITE,string);
		}
		if(Slot3 != -1)	{
			format(string, sizeof(string), "(%d) %s - $%d", Slot3,PlayerName2(Slot3),GetPlayerMoney(Slot3) );
			SendClientMessage(playerid,COLOR_WHITE,string);
		}
		if(Slot4 != -1)	{
			format(string, sizeof(string), "(%d) %s - $%d", Slot4,PlayerName2(Slot4),GetPlayerMoney(Slot4) );
			SendClientMessage(playerid,COLOR_WHITE,string);
		}
		return 1;
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_miniguns(playerid,params[]) {
    #pragma unused params
    if(PlayerInfo[playerid][Level] >= 1) {
		new bool:First2 = false, Count, string[128], i, slot, weap, ammo;
		for(i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i)) {
				for(slot = 0; slot < 14; slot++) {
					GetPlayerWeaponData(i, slot, weap, ammo);
					if(ammo != 0 && weap == 38) {
					    Count++;
						if(!First2) { format(string, sizeof(string), " Миниган: (%d)%s(патроны:%d)", i, PlayerName2(i), ammo); First2 = true; }
				        else format(string,sizeof(string),"%s, (%d)%s(патроны:%d) ",string, i, PlayerName2(i), ammo);
					}
				}
    	    }
		}
		if(Count == 0) return SendClientMessage(playerid,COLOR_WHITE," Нет игроков с миниганом"); else return SendClientMessage(playerid,COLOR_WHITE,string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_uconfig(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 7)
	{
		UpdateConfig();
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return CMDMessageToAdmins(playerid,"UCONFIG");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_botcheck(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		for(new i=0; i<MAX_PLAYERS; i++) BotCheck(i);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return CMDMessageToAdmins(playerid,"BOTCHECK");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_lockserver(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /lockserver [пароль] (закрыть сервер)");
    	new adminname[MAX_PLAYER_NAME], string[128];
		ServerInfo[Locked] = 1;
		strmid(ServerInfo[Password], params[0], 0, strlen(params[0]), 128);
		GetPlayerName(playerid, adminname, sizeof(adminname));
		format(string, sizeof(string), " Админ %s закрыл сервер",adminname);
  		SendClientMessageToAll(red,"________________________________________");
  		SendClientMessageToAll(red," ");
		SendClientMessageToAll(red,string);
		SendClientMessageToAll(red,"________________________________________");
		for(new i = 0; i <= MAX_PLAYERS; i++) if(IsPlayerConnected(i)) { PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][AllowedIn] = true; }
		CMDMessageToAdmins(playerid,"LOCKSERVER");
		format(string, sizeof(string), " Создатель %s закрыл сервер под паролем '%s'",adminname, ServerInfo[Password] );
		return MessageToAdmins(COLOR_WHITE, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_unlockserver(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 12) {
	    if(ServerInfo[Locked] == 1) {
	    	new adminname[MAX_PLAYER_NAME], string[128];
			ServerInfo[Locked] = 0;
			strmid(ServerInfo[Password], "", 0, strlen(""), 128);
			GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string, sizeof(string), " Создатель %s открыл сервер",adminname);
  			SendClientMessageToAll(green,"________________________________________");
	  		SendClientMessageToAll(green," ");
			SendClientMessageToAll(green,string);
			SendClientMessageToAll(green,"________________________________________");
			for(new i = 0; i <= MAX_PLAYERS; i++) if(IsPlayerConnected(i)) { PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][AllowedIn] = true; }
			return CMDMessageToAdmins(playerid,"UNLOCKSERVER");
		} else return SendClientMessage(playerid,red," ОШИБКА: Сервер не закрыт");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_password(playerid,params[]) {
	if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /password [пароль] (пароль для сервера)");
	if(ServerInfo[Locked] == 1) {
	    if(PlayerInfo[playerid][AllowedIn] == false) {
			if(!strcmp(ServerInfo[Password],params[0],true)) {
				KillTimer( LockKickTimer[playerid] );
				PlayerInfo[playerid][AllowedIn] = true;
				new string[128];
				SendClientMessage(playerid,COLOR_WHITE," Вы правильно ввели пароль сервера!");
				format(string, sizeof(string), " %s успешно ввел пароль сервера!",PlayerName2(playerid));
				return MessageToAdmins(COLOR_WHITE, string);
			} else return SendClientMessage(playerid,red," ОШИБКА: Не верный пароль");
		} else return SendClientMessage(playerid,red," ОШИБКА: Вы должны залогиниться");
	} else return SendClientMessage(playerid,red," ОШИБКА: Сервер не закрыт");
}

dcmd_forbidname(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 11) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /forbidname [ник] (занести ник в чёрный список)");
		new File:BLfile, string[128];
		BLfile = fopen("ladmin/config/ForbiddenNames.cfg",io_append);
		format(string,sizeof(string),"%s\r\n",params[1]);
		fwrite(BLfile,string);
		fclose(BLfile);
		UpdateConfig();
		CMDMessageToAdmins(playerid,"FORBIDNAME");
		format(string, sizeof(string), " Админ %s занес имя - %s в черный список", pName(playerid), params );
		return MessageToAdmins(green,string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_forbidword(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 11) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /forbidword [слово] (занести слово в чёрный список)");
		new File:BLfile, string[128];
		BLfile = fopen("ladmin/config/ForbiddenWords.cfg",io_append);
		format(string,sizeof(string),"%s\r\n",params[1]);
		fwrite(BLfile,string);
		fclose(BLfile);
		UpdateConfig();
		CMDMessageToAdmins(playerid,"FORBIDWORD");
		format(string, sizeof(string), " Админ %s занес слово - %s в антимат", pName(playerid), params );
		return MessageToAdmins(green,string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
//==========================[ CHAT COMMANDS ]===================================
dcmd_vclearchat(playerid,params[]) {
    #pragma unused params
    if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 2) { // Сразу и для Создателя!
		new string[128];
		//CMDMessageToAdmins(playerid,"CLEARCHAT");
		for(new i = 0; i < 11; i++) SendClientMessageToAll(green," "); format(string,sizeof(string),"{EFF600}** [G] ViP Игрок {FF0000}%s {EFF600}очистил чат", pName(playerid) ); SendClientMessageToAll(red,string); return 1;
 	} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Gold ViP {FF0000}Развлекательного Центра™{EFF600}!");
}
dcmd_clearchat(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		CMDMessageToAdmins(playerid,"CLEARCHAT");
		for(new i = 0; i < 11; i++) SendClientMessageToAll(green," "); return 1;
 	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 2 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_cc(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		CMDMessageToAdmins(playerid,"CC");
		for(new i = 0; i < 50; i++) SendClientMessageToAll(green," "); return 1;
 	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_caps(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 4) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /caps [id игрока] [on/off] (дать возможность игроку писать большими буквами)");
		new player1 = strval(tmp), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(strcmp(tmp2,"on",true) == 0)	{
				CMDMessageToAdmins(playerid,"CAPS");
				PlayerInfo[player1][Caps] = 0;
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s дал вам возможность писать большими буквами", pName(playerid) ); SendClientMessage(player1,COLOR_GREEN,string); }
				format(string,sizeof(string)," Вы дали возможность игроку %s писать большими буквами", pName(player1) ); return SendClientMessage(playerid,COLOR_GREEN,string);
			} else if(strcmp(tmp2,"off",true) == 0)	{
				CMDMessageToAdmins(playerid,"CAPS");
				PlayerInfo[player1][Caps] = 1;
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s отобрал у вас возможность писать большими буквами", pName(playerid) ); SendClientMessage(player1,COLOR_RED,string); }
				format(string,sizeof(string)," Вы отобрли возможность игроку %s писать большими буквами", pName(player1) ); return SendClientMessage(playerid,COLOR_RED,string);
			} else return SendClientMessage(playerid, red, " ПРАВКА: /caps [playerid] [on/off]");
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 4 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
//==================[ Invisible Commands ]======================================
dcmd_invisible(playerid,params[])
{
	return dcmd_invis(playerid,params);
}

dcmd_invis(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		if(IsPlayerInAnyVehicle(playerid)) {
			LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid)+1);
		}
		else {
			new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleID;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
			new int1 = GetPlayerInterior(playerid);
	    	LVehicleID = CreateVehicle(411,X,Y,Z,Angle,1,-1,-1); PutPlayerInVehicle(playerid,LVehicleID,0);
			LinkVehicleToInterior(LVehicleID,int1 + 1);
		}
		CMDMessageToAdmins(playerid,"INVIS");
		PlayerInfo[playerid][Invis] = 1;
		if(!InvisTimer) InvisTimer = SetTimer("HideNameTag",100,1);
		return SendClientMessage(playerid,red," Вы теперь не видимы");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_uninvis(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
	    if(PlayerInfo[playerid][Invis] == 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid));
			}
			CMDMessageToAdmins(playerid,"UNINVIS");
			PlayerInfo[playerid][Invis] = 0;
			new InvisCount;
			for(new i=0; i<MAX_PLAYERS; i++) if(PlayerInfo[i][Invis] == 1) InvisCount++;
			if(InvisCount == 0) if(InvisTimer) KillTimer(InvisTimer);
			return SendClientMessage(playerid,green," Вы теперь видимы");
		} else return SendClientMessage(playerid,red," Вы и так видимы");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_killinvis(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		KillTimer(InvisTimer);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return CMDMessageToAdmins(playerid,"KILLINVIS");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
//==================[ Object & Pickup ]=========================================
dcmd_pickup(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid,red," ПРАВКА: /pickup [id пикапа] (создать пикап)");
	    new pickup = strval(params), string[128], Float:x, Float:y, Float:z, Float:a;
	    CMDMessageToAdmins(playerid,"PICKUP");
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		x += (3 * floatsin(-a, degrees));
		y += (3 * floatcos(-a, degrees));
		CreatePickup(pickup, 2, x+2, y, z);
		format(string, sizeof(string), " CreatePickup(%d, 2, %0.2f, %0.2f, %0.2f);", pickup, x+2, y, z);
       	SaveToFile("Pickups",string);
		return SendClientMessage(playerid,yellow, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_object(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid)) {
	    if(!strlen(params)) return SendClientMessage(playerid,red," ПРАВКА: /object [id обьекта] (создать объект)");
	    new object = strval(params), string[128], Float:x, Float:y, Float:z, Float:a;
	    CMDMessageToAdmins(playerid,"OBJECT");
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		x += (3 * floatsin(-a, degrees));
		y += (3 * floatcos(-a, degrees));
		CreateObject(object, x, y, z, 0.0, 0.0, a);
		format(string, sizeof(string), " CreateObject(%d, %0.2f, %0.2f, %0.2f, 0.00, 0.00, %0.2f);", object, x, y, z, a);
       	SaveToFile("Objects",string);
		format(string, sizeof(string), " Вы создали оъбект %d, с координатами %0.2f, %0.2f, %0.2f , %0.2f", object, x, y, z, a);
		return SendClientMessage(playerid,yellow, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}
//===================[ Move ]===================================================
dcmd_move(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /move [up/down/+x/-x/+y/-y/off] (переметить что-либо)");
		new Float:X, Float:Y, Float:Z;
		if(strcmp(params,"up",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y,Z+5); SetCameraBehindPlayer(playerid); }
		else if(strcmp(params,"down",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y,Z-5); SetCameraBehindPlayer(playerid); }
		else if(strcmp(params,"+x",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X+5,Y,Z);	}
		else if(strcmp(params,"-x",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X-5,Y,Z); }
		else if(strcmp(params,"+y",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y+5,Z);	}
		else if(strcmp(params,"-y",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y-5,Z);	}
	    else if(strcmp(params,"off",true) == 0)	{
			TogglePlayerControllable(playerid,true);	}
		else return SendClientMessage(playerid,red," ПРАВКА: /move [up/down/+x/-x/+y/-y/off] (переметить что-либо)");
		return 1;
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_moveplayer(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp)) return SendClientMessage(playerid, red, " ПРАВКА: /moveplayer [id игрока] [up/down/+x/-x/+y/-y/off]");
	    new Float:X, Float:Y, Float:Z, player1 = strval(tmp);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(strcmp(tmp2,"up",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y,Z+5); SetCameraBehindPlayer(player1);	}
			else if(strcmp(tmp2,"down",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y,Z-5); SetCameraBehindPlayer(player1);	}
			else if(strcmp(tmp2,"+x",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X+5,Y,Z);	}
			else if(strcmp(tmp2,"-x",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X-5,Y,Z); }
			else if(strcmp(tmp2,"+y",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y+5,Z);	}
			else if(strcmp(tmp2,"-y",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y-5,Z);	}
			else SendClientMessage(playerid,red," ПРАВКА: /moveplayer [up/down/+x/-x/+y/-y/off]");
			return 1;
		} else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
//===================[ Fake ]===================================================
#if defined ENABLE_FAKE_CMDS
dcmd_fakedeath(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 12) {
	    new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return SendClientMessage(playerid, red, " ПРАВКА: /fakedeath [убийца] [смертник] [id оружия] (сделать ложное убийство в килл листе)");
		new killer = strval(tmp), killee = strval(tmp2), weap = strval(tmp3);
		if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red," ОШИБКА: Не верный id оружия");
		if(PlayerInfo[killer][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
		if(PlayerInfo[killee][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");

        if(IsPlayerConnected(killer) && killer != INVALID_PLAYER_ID) {
	        if(IsPlayerConnected(killee) && killee != INVALID_PLAYER_ID) {
	    	  	CMDMessageToAdmins(playerid,"FAKEDEATH");
				SendDeathMessage(killer,killee,weap);
				return SendClientMessage(playerid,COLOR_GREEN," Поддельное сообщение о смерти отправлено");
		    } else return SendClientMessage(playerid,red," ОШИБКА: Смертник не подключен к игре");
	    } else return SendClientMessage(playerid,red," ОШИБКА: Убийца не подключен к игре");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_fakechat(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 12) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /fakechat [id игрока] [текст] (писать в чат от другого игрока)");
		new player1 = strval(tmp);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
	        CMDMessageToAdmins(playerid,"FAKECHAT");
			SendPlayerMessageToAll(player1, params[strlen(tmp)+1]);
			return SendClientMessage(playerid,COLOR_GREEN," Поддельное сообщение в чат отправлено");
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_fakecmd(playerid,params[]) {
    if(PlayerInfo[playerid][Level] >= 12) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /fakecmd [id игрока] [команда] (использовать команду от другим игроком)");
		new player1 = strval(tmp);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
	        CMDMessageToAdmins(playerid,"FAKECMD");
	        CallRemoteFunction("OnPlayerCommandText", "is", player1, tmp2);
			return SendClientMessage(playerid,COLOR_GREEN," Команда у указанного игрока сработала");
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}
#endif
//all Commands
dcmd_spawnall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"SPAWNAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerPos(i, 0.0, 0.0, 0.0); SpawnPlayer(i);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}вернул на спавн всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_muteall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"MUTEALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][Muted] = 1; PlayerInfo[i][MuteWarnings] = 0;
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}заткнул всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_unmuteall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"UNMUTEAll");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][Muted] = 0; PlayerInfo[i][MuteWarnings] = 0;
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}разоткнул всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_getall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"GETAll");
		new Float:x,Float:y,Float:z, interior = GetPlayerInterior(playerid);
    	GetPlayerPos(playerid,x,y,z);
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerPos(i,x+(playerid/4)+1,y+(playerid/4),z); SetPlayerInterior(i,interior);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}телепортировал всех игроков к себе", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_vhealall(playerid,params[]) {
    #pragma unused params
    if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 2) { // Сразу и для Создателя!
		//CMDMessageToAdmins(playerid,"HEALALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerHealthAC(i,100.0);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {EFF600}[G] ViP Игрок {FF0000}%s {EFF600}вылечил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Gold ViP {FF0000}Развлекательного Центра™{EFF600}!");
}

dcmd_healall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 5) {
		CMDMessageToAdmins(playerid,"HEALALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerHealthAC(i,100.0);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}вылечил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 5 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_varmourall(playerid,params[]) {
    #pragma unused params
    if(PlayerInfo[playerid][Level] >= 12 || PlayerInfo[playerid][pVip] >= 2) { // Сразу и для Создателя!
		//CMDMessageToAdmins(playerid,"ARMOURALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerArmorAC(i,100.0);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {EFF600}[G] ViP Игрок {FF0000}%s {EFF600}подарил всем по полной броне", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{EFF600}*** Ты не Gold ViP {FF0000}Развлекательного Центра™{EFF600}!");
}

dcmd_armourall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 5) {
		CMDMessageToAdmins(playerid,"ARMOURALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerArmorAC(i,100.0);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}подарил всем по полной броне", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 5 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_killall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 12) {
		CMDMessageToAdmins(playerid,"KILLALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerHealth(i,0.0);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}убил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_freezeall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"FREEZEALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); TogglePlayerControllable(playerid,false); PlayerInfo[i][Frozen] = 1;
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}заморозил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_unfreezeall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"UNFREEZEALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); TogglePlayerControllable(playerid,true); PlayerInfo[i][Frozen] = 0;
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}разморозил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_kickall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 12) {
		CMDMessageToAdmins(playerid,"KICKALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); Kick(i);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}кикнул всех игроков", pName(playerid) );
		SaveToFile("KickLog",string);
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_slapall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"SLAPALL");
		new Float:x, Float:y, Float:z;
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1190,0.0,0.0,0.0); GetPlayerPos(i,x,y,z);	SetPlayerPos(i,x,y,z+4);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}пнул всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_explodeall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"EXPLODEALL");
		new Float:x, Float:y, Float:z;
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1190,0.0,0.0,0.0); GetPlayerPos(i,x,y,z);	CreateExplosion(x, y , z, 7, 10.0);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}взорвал всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_disarmall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
		CMDMessageToAdmins(playerid,"DISARMALL");
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); ResetPlayerWeapons(i);
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}разоружил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_givemoneybank(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12) {
	    new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " ПРАВКА: /givemoneybank [id игрока] [сумма]");
		new player1 = strval(tmp), cash = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете использовать команду на этом уровне");
        if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string, sizeof(string), " Вы дали игроку %s сумму $%d в Банке", pName(player1), cash); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Создатель %s дал вам сумму $%d в Банке", pName(playerid), cash); SendClientMessage(player1,COLOR_GREEN,string); }
            new namebank[MAX_PLAYER_NAME];
            GetPlayerName(player1, namebank, sizeof(namebank));
            if(udb_UserIsset(namebank,"bank")) udb_UserSetInt(namebank,"bank", udb_UserInt(namebank,"bank") + cash); else udb_UserSetInt(namebank,"bank", cash);
            return CMDMessageToAdmins(playerid,"GIVEMONEYBANK");
	    } else return SendClientMessage(playerid,red," ОШИБКА:  Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_ejectall(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 11) {
    	CMDMessageToAdmins(playerid,"EJECTALL");
        new Float:x, Float:y, Float:z;
	   	for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
			    if(IsPlayerInAnyVehicle(i)) {
					PlayerPlaySound(i,1057,0.0,0.0,0.0); GetPlayerPos(i,x,y,z); SetPlayerPos(i,x,y,z+3);
				}
			}
		}
		new string[128]; format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}выкинул всех из транспорта", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
//-------------==== Set All Commands ====-------------//
dcmd_kiss(playerid,params[]) {
   if(!strlen(params)) return SendClientMessage(playerid, 0xFFB0FFAA, " ПРАВКА: /kiss [id игрока]");
   new player1;
   new str[256];
   player1 = strval(params);
   if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
       new nameS[MAX_PLAYER_NAME];
       GetPlayerName(player1, nameS, sizeof(nameS));
       if(kissstatus[playerid] == 1) return SendClientMessage(playerid, 0xFFB0FFAA, " Вы не можете целоваться так часто (чтобы не было флуда)");
       if(GetDistanceBetweenPlayers(playerid, player1) > 1.1 && IsPlayerMale(player1)) return format(str, sizeof(str), "Ваш любимый %s слишком далеко от вас, подойдите к нему поближе ;)  ", nameS), SendClientMessage(playerid,0xA4A4FFAA,str);
       if(GetDistanceBetweenPlayers(playerid, player1) > 1.1 && IsPlayerFemale(player1)) return format(str, sizeof(str), "Ваша любимая %s слишком далеко от вас, подойдите к ней поближе ;)  ", nameS), SendClientMessage(playerid,0xFFB0FFAA,str);

       kissstatus[playerid] = 1;
       SetTimerEx("KiSsStaTus", 30000,0,"d",playerid);
	   if(IsPlayerMale(playerid) && IsPlayerFemale(player1) ){
            new nameM[MAX_PLAYER_NAME];
            new nameW[MAX_PLAYER_NAME];
            ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 3.0, 0, 0, 0, 0, 0);// Kiss
            GetPlayerName(playerid, nameM, sizeof(nameM));
            GetPlayerName(player1, nameW, sizeof(nameW));
            format(str, sizeof(str), "Парень %s поцеловал девушку %s в губки ;) ", nameM,nameW);

			if(udb_UserIsset(nameM,"kiss")) udb_UserSetInt(nameM,"kiss", udb_UserInt(nameM,"kiss") + 1); else udb_UserSetInt(nameM,"kiss", 1);
            if(udb_UserIsset(nameW,"kiss")) udb_UserSetInt(nameW,"kiss", udb_UserInt(nameW,"kiss") + 1); else udb_UserSetInt(nameW,"kiss", 1);

			SendClientMessageToAll(0xB0B0FFAA,str);}

       if(IsPlayerFemale(playerid) && IsPlayerMale(player1) ){
            new nameM[MAX_PLAYER_NAME];
            new nameW[MAX_PLAYER_NAME];
            ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 3.0, 0, 0, 0, 0, 0);// Kiss
            GetPlayerName(player1, nameM, sizeof(nameM));
            GetPlayerName(playerid, nameW, sizeof(nameW));
            format(str, sizeof(str), "Девушка %s поцеловала парня %s в губы ;) ", nameW,nameM);

            if(udb_UserIsset(nameM,"kiss")) udb_UserSetInt(nameM,"kiss", udb_UserInt(nameM,"kiss") + 1); else udb_UserSetInt(nameM,"kiss", 1);
            if(udb_UserIsset(nameW,"kiss")) udb_UserSetInt(nameW,"kiss", udb_UserInt(nameW,"kiss") + 1); else udb_UserSetInt(nameW,"kiss", 1);
            SendClientMessageToAll(0xFF00FFAA,str);}

       if(IsPlayerMale(playerid) && IsPlayerMale(player1)) SendClientMessage(playerid,0xA4A4FFAA, "   Найдите себе подходящую пару, вы же наверно не педик ;)");
       if(IsPlayerFemale(playerid) && IsPlayerFemale(player1)) SendClientMessage(playerid,0xFFB0FFAA, "   Найдите себе подходящую пару, вы же наверно не лизбианка ;)");
       }
   else return SendClientMessage(playerid, 0xA4A4FFAA, " Нет такого игрока");
   return 1;
}

dcmd_setallskin(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setallskin [id скина] (установить всем игрокам скин)");
		new var = strval(params), string[128];
		if(!IsValidSkin(var)) return SendClientMessage(playerid, red, " ОШИБКА: Не верный id скина");
       	CMDMessageToAdmins(playerid,"SETALLSKIN");
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerSkin(i,var);
			}
		}
		format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}установил всем скин {FF0000}%d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setallwanted(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setallwanted [уровень розыска] (установить всем игрокам уровень розыска)");
		new var = strval(params), string[128];
       	CMDMessageToAdmins(playerid,"SETALLWANTED");
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerWantedLevel(i,var);
			}
		}
		format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}установил всем уровень розыскиваемости {FF0000}%d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 6 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setallweather(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setallweather [id погоды] (установить всем игрокам погоду)");
		new var = strval(params), string[128];
       	CMDMessageToAdmins(playerid,"SETALLWEATHER");
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerWeather(i, var);
			}
		}
		format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}установил всем погоду {FF0000}%d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 6 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setalltime(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setalltime [время] (установить все игрокам время)");
		new var = strval(params), string[128];
		if(var > 24) return SendClientMessage(playerid, red, " ОШИБКА: Не верное время");
       	CMDMessageToAdmins(playerid,"SETALLTIME");
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerTime(i, var, 0);
			}
		}
		format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}установил всем время {FF0000}%d:00", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 6 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_setallworld(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 12) {
	    if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /setallworld [виртуальный мир] (установить всем игрокам мир)");
		new var = strval(params), string[128];
       	CMDMessageToAdmins(playerid,"SETALLWORLD");
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerVirtualWorld(i,var);
			}
		}
		format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}установил всем виртуальный мир {FF0000}%d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_giveallweapon(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 11) {
	    new tmp[256], tmp2[256], Index, ammo, weap, WeapName[32], string[128]; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp) ) return SendClientMessage(playerid, red, " ПРАВКА: /giveallweapon [id оружия или название оружия] [патроны] (установить всем игрокам оружие)");
		if(!strlen(tmp2) || !IsNumeric(tmp2) || strval(tmp2) <= 0 || strval(tmp2) > 99999) ammo = 500;
		if(!IsNumeric(tmp)) weap = GetWeaponIDFromName(tmp); else weap = strval(tmp);
	  	if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red," ОШИБКА: Не верный id оружия");
      	CMDMessageToAdmins(playerid,"GIVEALLWEAPON");
		for(new i = 0; i < MAX_PLAYERS; i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); GivePlayerWeapon(i,weap,ammo);
			}
		}
		GetWeaponName(weap, WeapName, sizeof(WeapName) );
		format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}дал всем оружие %s(%d) с %d патронами", pName(playerid), WeapName, weap, ammo);
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

//----------------------===== Place & Skin Saving =====-------------------------
dcmd_gotoplace(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1 && PlayerInfo[playerid][Level] >= 0)	{
	    if (dUserINT(PlayerName2(playerid)).("x")!=0) {
		    PutAtPos(playerid);
			SetPlayerVirtualWorld(playerid, (dUserINT(PlayerName2(playerid)).("world")) );
            new playername[30];
            new string[128];
            GetPlayerName(playerid,playername,sizeof(playername));
            format(string,sizeof(string),"{11F411}Игрок {B85FF3}%s(%d) {11F411}телепортировался на свой телепорт!",playername,playerid);
            SendClientMessageToAll(0xB85FF3AA, string);
			return SendClientMessage(playerid,yellow,"{0AD383}[SavePos System]: {FF0000}Вы телепортировались на свою сохраненную позицию!");
		} else return SendClientMessage(playerid,red,"{0AD383}[SavePos System]: {FF0000}У вас нет сохраненной позиции! Сох. 'Alt > Настройки аккаунта > Сохранить свою позицию'!");
	} else return SendClientMessage(playerid,red, "{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_smeposska(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1 && PlayerInfo[playerid][Level] >= 0)	{
		new Float:x,Float:y,Float:z, interior;
		GetPlayerPos(playerid,x,y,z);	interior = GetPlayerInterior(playerid);
		dUserSetINT(PlayerName2(playerid)).("x",floatround(x));
		dUserSetINT(PlayerName2(playerid)).("y",floatround(y));
		dUserSetINT(PlayerName2(playerid)).("z",floatround(z));
		dUserSetINT(PlayerName2(playerid)).("interior",interior);
//		dUserSetINT(PlayerName2(playerid)).("world", (GetPlayerVirtualWorld(playerid)) );
		return SendClientMessage(playerid,yellow,"{0AD383}[SavePos System]: {FF0000}Вы успешно сохранили эту позицию! Теперь вы можете сюда телепортироваться! 'Alt > Телепорты > Мой!'");
	} else return SendClientMessage(playerid,red, "{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_saveskin(playerid,params[]) {
 	if(PlayerInfo[playerid][Level] >= 0 && PlayerInfo[playerid][LoggedIn] == 1) {
		if(!strlen(params)) return SendClientMessage(playerid, red, "{0AD383}[Skin System]: {FF0000}/saveskin [id скина] = (сохранить свой скин)");
		new string[128], SkinID = strval(params);
		if((SkinID == 0)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299))
		{
 			dUserSetINT(PlayerName2(playerid)).("FavSkin",SkinID);
		 	format(string, sizeof(string), "{0AD383}[Skin System]: {FF0000}Вы успешно сохранили скин (ID %d)",SkinID);
		 	SendClientMessage(playerid,yellow,string);
			SendClientMessage(playerid,yellow,"{0AD383}[Skin System]: {FF0000}Запустить систему - /useskin {0AD383}| {FF0000}Остановить систему - /dontuseskin");
			dUserSetINT(PlayerName2(playerid)).("UseSkin",1);
		 	return CMDMessageToAdmins(playerid,"SAVESKIN");
		} else return SendClientMessage(playerid, green, "[Skin System]: {FF0000}Не верный id скина");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_useskin(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 0 && PlayerInfo[playerid][LoggedIn] == 1) {
	    dUserSetINT(PlayerName2(playerid)).("UseSkin",1);
    	SetPlayerSkin(playerid,dUserINT(PlayerName2(playerid)).("FavSkin"));
		return SendClientMessage(playerid,yellow,"{0AD383}[Skin System]: {FF0000}Вы запустили систему выбора скина автоматом");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}

dcmd_dontuseskin(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][Level] >= 0 && PlayerInfo[playerid][LoggedIn] == 1) {
	    dUserSetINT(PlayerName2(playerid)).("UseSkin",0);
		return SendClientMessage(playerid,yellow,"{0AD383}[Skin System]: {FF0000}Вы остановили систему скинов!");
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
}
//====================== [REGISTER  &  LOGIN] ==================================
#if defined USE_AREGISTER
dcmd_aregister(playerid,params[])
{
    if (PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Вы уже зарегистрированы и залогинены.");
    if (udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Этот ник зарегистрирован, если он ваш то залоинийтесь командой /alogin [пароль].");
    if (strlen(params) == 0) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: ПРАВКА: /aregister [пароль]'");
    if (strlen(params) < 4 || strlen(params) > 20) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Длинна пароля не должна быть большой! (4 - 20 символов)");
    if (udb_Create(PlayerName2(playerid),params))
	{
    	new file[256],name[MAX_PLAYER_NAME], tmp3[100];
    	new strdate[20], year,month,day;	getdate(year, month, day);
		GetPlayerName(playerid,name,sizeof(name)); format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(name));
     	GetPlayerIp(playerid,tmp3,100);	dini_Set(file,"ip",tmp3);
//    	dini_Set(file,"password",params);
	    dUserSetINT(PlayerName2(playerid)).("registered",1);
   		format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
		dini_Set(file,"RegisteredDate",strdate);
		dUserSetINT(PlayerName2(playerid)).("loggedin",1);
		dUserSetINT(PlayerName2(playerid)).("banned",0);
		dUserSetINT(PlayerName2(playerid)).("level",0);
	    dUserSetINT(PlayerName2(playerid)).("LastOn",0);
    	dUserSetINT(PlayerName2(playerid)).("money",0);
    	dUserSetINT(PlayerName2(playerid)).("kills",0);
	   	dUserSetINT(PlayerName2(playerid)).("deaths",0);
	    PlayerInfo[playerid][LoggedIn] = 1;
	    PlayerInfo[playerid][Registered] = 1;
	    SendClientMessage(playerid, green, "{11F244}*** {F4C522}АККАУНТ: Вы зарегистрированы, вы автоматически залогинились");
	    SendClientMessage(playerid, green, "{11F244}*** {F4C522}АККАУНТ: Для более точной информации нажмите 'Y' или введите /help!");

		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return 1;
	}
    return 1;
}

dcmd_alogin(playerid,params[])
{
    if (PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Вы уже зарегистрированы и залогинены.");
    if (!udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Ник не зарегистрирован, пожалуйста зарегистрируйтесь командой /aregister [пароль]'.");
    if (strlen(params)==0) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: ПРАВКА: '/alogin [password]'");
    if (udb_CheckLogin(PlayerName2(playerid),params))
	{
	   	new file[256], tmp3[100], string[128];
	   	format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(playerid)) );
   		GetPlayerIp(playerid,tmp3,100);
	   	dini_Set(file,"ip",tmp3);
		LoginPlayer(playerid);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		if(PlayerInfo[playerid][Level] > 0) {
			format(string,sizeof(string),"{11F244}*** {F4C522}АККАУНТ: Вы успешно залогинились. Приятной игры ;) {FF0000}(Уровень %d)", PlayerInfo[playerid][Level] );
			return SendClientMessage(playerid,green,string);
       	} else return SendClientMessage(playerid,green,"{11F244}*** {F4C522}АККАУНТ: Вы успешно залогинились. Приятной игры ;)");
	}
	else {
		PlayerInfo[playerid][FailLogin]++;
		printf("LOGIN: %s has failed to login, Wrong password (%s) Attempt (%d)", PlayerName2(playerid), params, PlayerInfo[playerid][FailLogin] );
		if(PlayerInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
		{
			new string[128]; format(string, sizeof(string), " %s кикнут системой (Ввёл не верный пароль)", PlayerName2(playerid) );
			SendClientMessageToAll(COLOR_RED, string); print(string);
			Kick(playerid);
		}
		return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Не правильный пароль! Будь внимательным!");
	}
}

dcmd_achangepass(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		if(!strlen(params)) return SendClientMessage(playerid, red, " ПРАВКА: /achangepass [пароль]");
		if(strlen(params) < 4) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}АККАУНТ: Не верный пароль");
		new string[128];
		dUserSetINT(PlayerName2(playerid)).("password_hash",udb_hash(params) );
		dUserSet(PlayerName2(playerid)).("Password",params);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
        format(string, sizeof(string),"{11F244}*** {F4C522}АККАУНТ: Вы успешно сменили свой пароль на [ %s ]",params);
		return SendClientMessage(playerid,yellow,string);
	} else return SendClientMessage(playerid,red, " ОШИБКА: Вы должны зарегистрироваться чтобы использовать эту команду");
}

#if defined USE_STATS
dcmd_aresetstats(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		// save as backup
	   	dUserSetINT(PlayerName2(playerid)).("oldkills",PlayerInfo[playerid][Kills]);
	   	dUserSetINT(PlayerName2(playerid)).("olddeaths",PlayerInfo[playerid][Deaths]);
		// stats reset
		PlayerInfo[playerid][Kills] = 0;
		PlayerInfo[playerid][Deaths] = 0;
		dUserSetINT(PlayerName2(playerid)).("kills",PlayerInfo[playerid][Kills]);
	   	dUserSetINT(PlayerName2(playerid)).("deaths",PlayerInfo[playerid][Deaths]);
        PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendClientMessage(playerid,yellow,"{11F244}*** {F4C522}АККАУНТ: Вы успешно перезагрузили вашу статистику. Вас убили и вы умерли: 0 раз");
	} else return SendClientMessage(playerid,red, " ОШИБКА: Вы должны зарегистрироваться чтобы использовать эту команду");
}

dcmd_astats(playerid,params[]) {
	new string[128], pDeaths, player1;
	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);

	if(IsPlayerConnected(player1)) {
 		if(PlayerInfo[player1][Deaths] == 0) pDeaths = 1; else pDeaths = PlayerInfo[player1][Deaths];
 		format(string, sizeof(string), " *** Статистика %s:  Убил: %d | Умер: %d | Процент: %0.2f | Денег: $%d ",PlayerName2(player1), PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths], Float:PlayerInfo[player1][Kills]/Float:pDeaths,GetPlayerMoney(player1));
		return SendClientMessage(playerid, green, string);
	} else return SendClientMessage(playerid, red, " Нет такого игрока!");
}
#endif


#else


dcmd_register(playerid,params[])
{
	#pragma unused params
	new rstring[4000];
	strins(rstring,"{42aaff}Добро пожаловать на {00ff00}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\r\n",strlen(rstring));
	strins(rstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(rstring));
	strins(rstring,"{42aaff}» Официальная группа сервера {00ff00}t.me/e_centersamp\r\n",strlen(rstring));
	strins(rstring,"{42aaff}» Официальный сайт сервера {00ff00}t.me/e_centersampchat\r\n",strlen(rstring));
	strins(rstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(rstring));
	strins(rstring,"{42aaff}Вы можете у нас:\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Купить себе дом в Los Santos'e!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Поездить по большим Stunt-зонам!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Провести мероприятие в барах , кафе , ресторанах\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Положить деньги в банк!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Получить деньги за работу : Курьер , Археолог , Водолаз , Дальнобойщик , Грузчик , Золотник!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Пополнить себе жизни в ларьках по всему SA!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Купить оружие в автоматах по всему SA!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Употребить наркотики на пляже Los Santos!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Поиграть в Мини-Игры , и получить приз!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Погонять на гоночных трассах!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Постреляться c разных оружий SA!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Пожениться и поцеловаться со своей второй половинкой!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Прокачать себе Level , чтобы иметь лучше оружие и стиль боя!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Прикрепить к себе объекты для развлечения или снятия ролика!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Телепортируйтесь по новой системе телепортов!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Купить себе одноразовую машину!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Купить себе админский уровень [1 - 10 lvl]!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Заказать своему клану/team базу , спавн , и гангзону!\n",strlen(rstring));
	strins(rstring,"{42aaff}» {00ff00}Поиграть в TDM режиме!\n",strlen(rstring));
	strins(rstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(rstring));
	strins(rstring,"{42aaff}Пожалуйста, введите Ваш будущий пароль от аккаунта от 4 до 20 Букв|Цифр:\r\n",strlen(rstring));
	ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"{00FFD5}Регистрация | Развлекательный Центр!",rstring,"Войти","");
	return 1;
}

dcmd_login(playerid,params[])
{
	#pragma unused params
	new lstring[4000];
	strins(lstring,"{42aaff}Мы рады опять вас видить у нас на сервере {00ff00}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\r\n",strlen(lstring));
	strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	strins(lstring,"{42aaff}Я думаю, ты успел ознакомится с сервером ещё при регистрации ;)\r\n",strlen(lstring));
	strins(lstring,"{42aaff}Если не успел , залогинься и заспавнись , а дальше просто нажми кнопку 'Y' , там вся информация о сервере :)\r\n",strlen(lstring));
	strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	strins(lstring,"{42aaff}Чтобы выбрать TDM режим , при выборе скина нажмите в 'Лево <'!\r\n",strlen(lstring));
	strins(lstring,"{42aaff}Чтобы выбрать DM режим , при выборе скина нажмите в 'Право >'!\r\n",strlen(lstring));
	strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	strins(lstring,"{42aaff}» Официальная группа сервера {00ff00}t.me/e_centersamp\r\n",strlen(lstring));
	strins(lstring,"{42aaff}» Официальный сайт сервера {00ff00}t.me/e_centersampchat\r\n",strlen(lstring));
	strins(lstring,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(lstring));
	strins(lstring,"{42aaff}Введите пароль от Вашего аккаунта:\r\n",strlen(lstring));
	ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"{00FFD5}Пожалуйста, залогиньтесь!",lstring,"Войти","");
}

dcmd_changepass(playerid,params[])
{
	#pragma unused params
	new passstrins[4000];
	strins(passstrins,"{80FF00}Вы хотите изменить свой пароль\r\n",strlen(passstrins));
	strins(passstrins,"{4DFF00}Для продолжения введите новый пароль в поле\r\n",strlen(passstrins));
	strins(passstrins,"{00FF00}Не забывайте, что длина пароля должна составлять от 3-х до 25-ти символов!\r\n",strlen(passstrins));
	strins(passstrins,"{00FF00}Не создавайте пароль типа '12345' ну и т.д , создавайте пароль из букв и цифр!\r\n",strlen(passstrins));
	strins(passstrins,"{00FF00}И если не хотите забыть пароль, сделайте скрин F8\r\n",strlen(passstrins));
	strins(passstrins,"{FFFFFF}              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(passstrins));
	strins(passstrins,"{FF0000}Администрация не несет ответственность за Ваши аккаунты!\n",strlen(passstrins));
	strins(passstrins,"{FF0000}Ваш аккаунт завист только от вас!\n",strlen(passstrins));
	strins(passstrins,"{FF0000}P.S Администрация сервера не требует Ваши пароли от аккаунта!\n",strlen(passstrins));
	ShowPlayerDialog(playerid,DIALOG_CHANGEPASS,DIALOG_STYLE_INPUT,"{FF7700}Смена пароля",passstrins,"Сменить","Отмена");
	return true;
}

#if defined USE_STATS
dcmd_resetstats(playerid,params[]) {
    #pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		// save as backup
	   	dUserSetINT(PlayerName2(playerid)).("oldkills",PlayerInfo[playerid][Kills]);
	   	dUserSetINT(PlayerName2(playerid)).("olddeaths",PlayerInfo[playerid][Deaths]);
		// stats reset
		PlayerInfo[playerid][Kills] = 0;
		PlayerInfo[playerid][Deaths] = 0;
		dUserSetINT(PlayerName2(playerid)).("kills",PlayerInfo[playerid][Kills]);
	   	dUserSetINT(PlayerName2(playerid)).("deaths",PlayerInfo[playerid][Deaths]);
        PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendClientMessage(playerid,yellow,"{11F244}*** {F4C522}АККАУНТ: Ваша статистика успешно перезагружена. Вас убили и вы умерли: 0 раз");
	} else return SendClientMessage(playerid,red, " ОШИБКА: Вы должны зарегистрироваться, чтобы использовать эту команду");
}
#endif

#if defined USE_STATS
dcmd_stats(playerid,params[]) {
	new string[128], pDeaths, player1;
	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);

	if(IsPlayerConnected(player1)) {
 		if(PlayerInfo[player1][Deaths] == 0) pDeaths = 1; else pDeaths = PlayerInfo[player1][Deaths];
 		format(string, sizeof(string), " *** Статистика %s:  Убил: %d | Умер: %d | Процент: %0.2f | Деньги: $%d ",PlayerName2(player1), PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths], Float:PlayerInfo[player1][Kills]/Float:pDeaths,GetPlayerMoney(player1));
		return SendClientMessage(playerid, green, string);
	} else return SendClientMessage(playerid, red, " Нет такого игрока!");
}
#endif


#endif


LoginPlayer(playerid)
{
 	PlayerInfo[playerid][Moneys] = dUserINT(PlayerName2(playerid)).("money");
	if(ServerInfo[GiveMoney] == 1) {ResetPlayerMoney(playerid); CallRemoteFunction("GivePlayerMoneyByKRYPTODENS", "id",playerid , PlayerInfo[playerid][Moneys]); }
	dUserSetINT(PlayerName2(playerid)).("loggedin",1);
	PlayerInfo[playerid][Deaths] = (dUserINT(PlayerName2(playerid)).("deaths"));
	PlayerInfo[playerid][Kills] = (dUserINT(PlayerName2(playerid)).("kills"));
 	PlayerInfo[playerid][Level] = (dUserINT(PlayerName2(playerid)).("level"));
 	PlayerInfo[playerid][Cameraed] = (dUserINT(PlayerName2(playerid)).("cameraed"));
 	PlayerInfo[playerid][Dialoged] = (dUserINT(PlayerName2(playerid)).("dialoged"));
	PlayerInfo[playerid][Registered] = 1;
 	PlayerInfo[playerid][LoggedIn] = 1;
	PlayerInfo[playerid][pVip] = (dUserINT(PlayerName2(playerid)).("vippp"));
 	SetPlayerScore(playerid,PlayerInfo[playerid][Kills]);
}

forward OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
//без него не как===============================
	for(new i = 0; i < strlen(inputtext); i++)
	{
	    if(inputtext[i] != '%') continue;
	    inputtext[i] = '#';
	    continue;
	}

	if(dialogid == DIALOG_CARCOLORS)
        {
	    if(response)
		{
		    if(!strlen(inputtext)) return ShowPlayerDialog(playerid,121,DIALOG_STYLE_INPUT,"{FF0000}Прекраска","{8b00ff}Введите ID первого цвета:","Выбор","Отмена");
		    TempVehColor[playerid] = strval(inputtext);
			ShowPlayerDialog(playerid,DIALOG_CARCOLORS2,DIALOG_STYLE_INPUT,"{FF0000}Перекраска","{8b00ff}Введите цифру второго цвета:","Ввод","Отмена");
		}
	}

	if(dialogid == DIALOG_CARCOLORS2)
    	{
	    if(response)
	    {
	        if(!strlen(inputtext)) ChangeVehicleColor(GetPlayerVehicleID(playerid),TempVehColor[playerid],-1);
			else ChangeVehicleColor(GetPlayerVehicleID(playerid),TempVehColor[playerid],strval(inputtext));
			SendClientMessage(playerid,0xFFFF00AA,"{FF0000}* {8b00ff}Вы перекрасили свой автомобиль.");
		}
	}

   	if(dialogid == 5324 && response)
	switch (listitem)
	{
		case 0: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/3.mp3");
	    case 1: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/4.mp3");
	    case 2: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/5.mp3");
	    case 3: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/6.mp3");
	    case 4: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/7.mp3");
	    case 5: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/8.mp3");
	    case 6: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/9.mp3");
	    case 7: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/10.mp3");
	    case 8: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/11.mp3");
	    case 9: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/12.mp3");
	    case 10: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/13.mp3");
	    case 11: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/14.mp3");
	    case 12: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/15.mp3");
	    case 13: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/16.mp3");
	    case 14: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/17.mp3");
	    case 15: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/18.mp3");
	    case 16: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/19.mp3");
	    case 17: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/20.mp3");
	    case 18: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/21.mp3");
	    case 19: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/22.mp3");
	    case 20: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/23.mp3");
	    case 21: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/24.mp3");
	    case 22: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/25.mp3");
	    case 23: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/26.mp3");
	    case 24: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/27.mp3");
	    case 25: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/28.mp3");
	    case 26: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/29.mp3");
	    case 27: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/30.mp3");
	    case 28: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/31.mp3");
	    case 29: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/32.mp3");
	    case 30: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/34.mp3");
	    case 31: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/35.mp3");
	    case 32: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/36.mp3");
	    case 33: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/37.mp3");
	    case 34: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/38.mp3");
	    case 35: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/39.mp3");
	    case 36: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/40.mp3");
	    case 37: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/41.mp3");
	    case 38: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/42.mp3");
	    case 39: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/43.mp3");
	    case 40: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/44.mp3");
	    case 41: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/45.mp3");
	    case 42: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/46.mp3");
	    case 43: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/47.mp3");
	    case 44: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/48.mp3");
	    case 45: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/49.mp3");
	    case 46: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/50.mp3");
	    case 47: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/51.mp3");
	    case 48: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/52.mp3");
	    case 49: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/53.mp3");
	    case 50: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/54.mp3");
	    case 51: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/55.mp3");
	    case 52: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/56.mp3");
	    case 53: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/57.mp3");
	    case 54: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/58.mp3");
	    case 55: PlayAudioStreamForPlayer(playerid,"http://onmusic.ucoz.ru/Rock/59.mp3");
	}

   	if(dialogid == 5325 && response)
	switch (listitem)
	{
		case 0: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/2.mp3");
		case 1: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/3.mp3");
		case 2: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/4.mp3");
		case 3: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/5.mp3");
		case 4: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/6.mp3");
		case 5: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/7.mp");
		case 6: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/8.mp3");
		case 7: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/9.mp3");
		case 8: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/10.mp3");
		case 9: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/11.mp3");
		case 10: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/12.mp3");
		case 11: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/13.mp3");
		case 12: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/14.mp3");
		case 13: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/15.mp3");
		case 14: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/16.mp3");
		case 15: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/17.mp3");
		case 16: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/18.mp3");
		case 17: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/19.mp3");
		case 18: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/20.mp3");
		case 19: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/21.mp3");
		case 20: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/22.mp3");
		case 21: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/23.mp3");
		case 22: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/24.mp3");
		case 23: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/25.mp3");
		case 24: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/26.mp3");
		case 25: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/27.mp3");
		case 26: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/28.mp3");
		case 27: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/29.mp3");
		case 28: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/30.mp3");
		case 29: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/31.mp3");
		case 30: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/32.mp3");
		case 31: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/33.mp3");
		case 32: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/35.mp3");
		case 33: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/36.mp3");
		case 34: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/37.mp3");
		case 35: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/38.mp3");
		case 36: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/39.mp3");
		case 37: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/40.mp3");
		case 38: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/41.mp3");
		case 39: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/42.mp3");
		case 40: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/43.mp3");
		case 41: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/44.mp3");
		case 42: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/45.mp3");
		case 43: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/46.mp3");
		case 44: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/47.mp3");
		case 45: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/48.mp3");
		case 46: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/49.mp3");
		case 47: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/50.mp3");
		case 48: PlayAudioStreamForPlayer(playerid,"http://sa-music.at.ua/51.mp3");
	}

   	if(dialogid == 5326 && response)
	switch (listitem)
	{
		case 0: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/2.mp3");
		case 1: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/3.mp3");
		case 2: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/4.mp3");
		case 3: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/5.mp3");
		case 4: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/6.mp3");
		case 5: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/7.mp3");
		case 6: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/8.mp3");
		case 7: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/9.mp3");
		case 8: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/10.mp3");
		case 9: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/11.mp3");
		case 10: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/12.mp3");
		case 11: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/13.mp3");
		case 12: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/14.mp3");
		case 13: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/15.mp3");
		case 14: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/16.mp3");
		case 15: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/17.mp3");
	    case 16: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/18.mp3");
	    case 17: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/19.mp3");
	}

	if(dialogid == 5327 && response)
	switch (listitem)
	{
		case 0: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a2.mp3");
		case 1: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a3.mp3");
		case 2: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a4.mp3");
		case 3: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a5.mp3");
		case 4: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a6.mp3");
		case 5: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a7.mp3");
		case 6: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a8.mp3");
		case 7: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a9.mp3");
		case 8: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a10.mp3");
		case 9: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a11.mp3");
		case 10: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a12.mp3");
		case 11: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a13.mp3");
		case 12: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a14.mp3");
		case 13: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a15.mp3");
		case 14: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a16.mp3");
		case 15: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a17.mp3");
		case 16: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/a18.mp3");
    }

	if(dialogid == 5328 && response)
	switch (listitem)
	{
		case 0: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e2.mp3");
		case 1: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e3.mp3");
		case 2: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e4.mp3");
		case 3: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e5.mp3");
		case 4: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e6.mp3");
		case 5: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e7.mp3");
		case 6: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e8.mp3");
		case 7: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e9.mp3");
		case 8: PlayAudioStreamForPlayer(playerid,"http://ec.3dn.ru/e.mp3");
	}

	if(dialogid == 5323)
 	{
  		if(response)
    	{
            if(listitem == 0)
            {
	            new String[4000];
	            strins(String,"{FFFFFF}1.{FE2E2E}AC-DC – Are You Ready\r\n",strlen(String));
	            strins(String,"{FFFFFF}2.{FE2E2E}AC-DC – Back In Black\r\n",strlen(String));
	            strins(String,"{FFFFFF}3.{FE2E2E}AC-DC – Big Gun \r\n",strlen(String));
	            strins(String,"{FFFFFF}4.{FE2E2E}AC-DC – Gone Shootin \r\n",strlen(String));
	            strins(String,"{FFFFFF}5.{FE2E2E}AC-DC – What Do You Do For Money Honey\r\n",strlen(String));
	            strins(String,"{FFFFFF}6.{FE2E2E}AC-DC – Shoot To Thrill\r\n",strlen(String));
	            strins(String,"{FFFFFF}7.{FE2E2E}AC-DC – War Machine\r\n",strlen(String));
	            strins(String,"{FFFFFF}8.{FE2E2E}AC-DC – What Do You Do For Money Honey\r\n",strlen(String));
	            strins(String,"{FFFFFF}9.{FE2E2E}Alkaline Trio – Mercy Me \r\n",strlen(String));
	            strins(String,"{FFFFFF}10.{FE2E2E}Bob Dylan – Knockin' On Heaven's Door\r\n",strlen(String));
	            strins(String,"{FFFFFF}11.{FE2E2E}Bon Jovi – Livin' On A Prayer\r\n",strlen(String));
	            strins(String,"{FFFFFF}12.{FE2E2E}Brainstorm – A Day Before Tomorow \r\n",strlen(String));
	            strins(String,"{FFFFFF}13.{FE2E2E}Brainstorm – Maybe\r\n",strlen(String));
	            strins(String,"{FFFFFF}14.{FE2E2E}Brother Dege  – Too Old to Die Young \r\n",strlen(String));
	            strins(String,"{FFFFFF}15.{FE2E2E}Deep Purple – Smoke on the Water\r\n",strlen(String));
	            strins(String,"{FFFFFF}16.{FE2E2E}Depeche Mode – Enjoy The Silence\r\n",strlen(String));
	            strins(String,"{FFFFFF}17.{FE2E2E}Disturbed – Decadence (Ten Thousand Fists - 2005)\r\n",strlen(String));
	            strins(String,"{FFFFFF}18.{FE2E2E}Drowning Pool – Bodies\r\n",strlen(String));
	            strins(String,"{FFFFFF}19.{FE2E2E}Green Day – American Idiot\r\n",strlen(String));
	            strins(String,"{FFFFFF}20.{FE2E2E}Green Day – Boulevard Of Broken Dreams \r\n",strlen(String));
	            strins(String,"{FFFFFF}21.{FE2E2E}Green Day – Kill The DJ \r\n",strlen(String));
	            strins(String,"{FFFFFF}22.{FE2E2E}Green Day – Wake Me Up When September End \r\n",strlen(String));
	            strins(String,"{FFFFFF}23.{FE2E2E}Guano Apes – Break The Line\r\n",strlen(String));
	            strins(String,"{FFFFFF}24.{FE2E2E}Guano Apes – Open Your Eyes\r\n",strlen(String));
	            strins(String,"{FFFFFF}25.{FE2E2E}Guano Apes – Pretty In Scarlet\r\n",strlen(String));
	            strins(String,"{FFFFFF}26.{FE2E2E}Guns N' Roses – Paradise City \r\n",strlen(String));
	            strins(String,"{FFFFFF}27.{FE2E2E}Hollywood Undead – California\r\n",strlen(String));
	            strins(String,"{FFFFFF}28.{FE2E2E}Deep Purple- Mad Dog\r\n",strlen(String));
	            strins(String,"{FFFFFF}29.{FE2E2E}KISS – Heaven's On Fire \r\n",strlen(String));
	            strins(String,"{FFFFFF}30.{FE2E2E}KISS – I Was Made For Loving You \r\n",strlen(String));
	            strins(String,"{FFFFFF}31.{FE2E2E}Marilyn Manson – Sweet Dreams\r\n",strlen(String));
	            strins(String,"{FFFFFF}32.{FE2E2E}Metallica – Enter Sandman\r\n",strlen(String));
	            strins(String,"{FFFFFF}33.{FE2E2E}Metallica – Nothing Else Matters\r\n",strlen(String));
	            strins(String,"{FFFFFF}34.{FE2E2E}Metallica – Whiskey In The Jar \r\n",strlen(String));
	            strins(String,"{FFFFFF}35.{FE2E2E}Michael Jackson  – Give in to me\r\n",strlen(String));
	            strins(String,"{FFFFFF}36.{FE2E2E}Nazareth – Little Part Of You \r\n",strlen(String));
	            strins(String,"{FFFFFF}37.{FE2E2E}Nickelback – Photograph \r\n",strlen(String));
	            strins(String,"{FFFFFF}38.{FE2E2E}Nickelback – Trying Not To Love You \r\n",strlen(String));
	            strins(String,"{FFFFFF}39.{FE2E2E}Nirvana – Heart-Shaped Box \r\n",strlen(String));
	            strins(String,"{FFFFFF}40.{FE2E2E}Nirvana – Smells Like Teen Spirit \r\n",strlen(String));
	            strins(String,"{FFFFFF}41.{FE2E2E}Pink Floyd – Comfortably Numb \r\n",strlen(String));
	            strins(String,"{FFFFFF}42.{FE2E2E}Queen – The Show Must Go On \r\n",strlen(String));
	            strins(String,"{FFFFFF}43.{FE2E2E}Red Hot Chili Peppers – By The Way \r\n",strlen(String));
	            strins(String,"{FFFFFF}44.{FE2E2E}Red Hot Chili Peppers – Californication \r\n",strlen(String));
	            strins(String,"{FFFFFF}45.{FE2E2E}Red Hot Chili Peppers – Can't Stop \r\n",strlen(String));
	            strins(String,"{FFFFFF}46.{FE2E2E}Rise Against – Give it All \r\n",strlen(String));
	            strins(String,"{FFFFFF}47.{FE2E2E}Scorpions – Holiday \r\n",strlen(String));
	            strins(String,"{FFFFFF}48.{FE2E2E}Scorpions – Humanity  \r\n",strlen(String));
	            strins(String,"{FFFFFF}49.{FE2E2E}Scorpions – Wind Of Change \r\n",strlen(String));
	            strins(String,"{FFFFFF}50.{FE2E2E}Scorpions – You And I \r\n",strlen(String));
	            strins(String,"{FFFFFF}51.{FE2E2E}Skillet – Forgiven \r\n",strlen(String));
	            strins(String,"{FFFFFF}52.{FE2E2E}Skillet – Say Goodbye \r\n",strlen(String));
	            strins(String,"{FFFFFF}53.{FE2E2E}Sum 41 – Noots  \r\n",strlen(String));
	            strins(String,"{FFFFFF}54.{FE2E2E}Supergrass – Road To Rouen \r\n",strlen(String));
	            strins(String,"{FFFFFF}55.{FE2E2E}The Cranberries – Animal Instinct \r\n",strlen(String));
	            strins(String,"{FFFFFF}56.{FE2E2E}The Cranberries – Kiss Me\r\n",strlen(String));
	            ShowPlayerDialog(playerid,5324,DIALOG_STYLE_LIST,"{00ACFF}»»» {FF0000}Rock{00ACFF} «««",String,"»[Включить]«","»[Назад]«");
            }
            if(listitem == 1)
            {
	            new String[4000];
	            strins(String,"{FFFFFF}1.{FE9A2E}David Guetta (feat. Ne-Yo & Akon) – Play Hard\r\n",strlen(String));
	            strins(String,"{FFFFFF}2.{FE9A2E}Серебро - Мало Тебя\r\n",strlen(String));
	            strins(String,"{FFFFFF}3.{FE9A2E}Pink (feat. Nate Ruess) – Just Give Me A Reason\r\n",strlen(String));
	            strins(String,"{FFFFFF}4.{FE9A2E}Alex Hepburn – Under\r\n",strlen(String));
	            strins(String,"{FFFFFF}5.{FE9A2E}PSY – Gentelman\r\n",strlen(String));
	            strins(String,"{FFFFFF}6.{FE9A2E}Anise K (feat. Snoop Dogg & Bella Blue) – Walking On Air\r\n",strlen(String));
				strins(String,"{FFFFFF}7.{FE9A2E}Rihanna (feat. Calvin Harris) – We Found Lоve\r\n",strlen(String));
	            strins(String,"{FFFFFF}8.{FE9A2E}Fly Project – La Musica\r\n",strlen(String));
	            strins(String,"{FFFFFF}9.{FE9A2E}Imagine Dragons – Demons \r\n",strlen(String));
				strins(String,"{FFFFFF}10.{FE9A2E}David Guetta (feat. Justice Crew) – Boom Boom Boom\r\n",strlen(String));
	            strins(String,"{FFFFFF}11.{FE9A2E}Lady GaGa – Applause\r\n",strlen(String));
	            strins(String,"{FFFFFF}12.{FE9A2E}Mia Martina – Tu Me Manques\r\n",strlen(String));
				strins(String,"{FFFFFF}13.{FE9A2E}Натали feat. MC Zali – О Боже Какой Мужчина\r\n",strlen(String));
	            strins(String,"{FFFFFF}14.{FE9A2E}Playmen feat. Demy – Fallin (Record Mix)\r\n",strlen(String));
	            strins(String,"{FFFFFF}15.{FE9A2E}Selena Gomez – Slow Down\r\n",strlen(String));
				strins(String,"{FFFFFF}16.{FE9A2E}Naughty Boy (feat. Sam Smith) – La La La\r\n",strlen(String));
	            strins(String,"{FFFFFF}17.{FE9A2E}Ellie Goulding – Burn\r\n",strlen(String));
	            strins(String,"{FFFFFF}18.{FE9A2E}Ани Лорак – Обними Меня Крепче \r\n",strlen(String));
				strins(String,"{FFFFFF}19.{FE9A2E}Demi Lovato – Heart Attack\r\n",strlen(String));
	            strins(String,"{FFFFFF}20.{FE9A2E}Григорий Лепс и Ани Лорак – Зеркала\r\n",strlen(String));
	            strins(String,"{FFFFFF}21.{FE9A2E}Stromae – Papaoutai\r\n",strlen(String));
				strins(String,"{FFFFFF}22.{FE9A2E}Example – Changed The Way You Kiss Me\r\n",strlen(String));
	            strins(String,"{FFFFFF}23.{FE9A2E}Dev (feat. Enrique Iglesias) – Naked\r\n",strlen(String));
	            strins(String,"{FFFFFF}24.{FE9A2E}Григорий Лепс – Самый Лучший День\r\n",strlen(String));
				strins(String,"{FFFFFF}25.{FE9A2E}Gritz – My Life Be Like\r\n",strlen(String));
	            strins(String,"{FFFFFF}26.{FE9A2E}One Republic – Good Life\r\n",strlen(String));
	            strins(String,"{FFFFFF}27.{FE9A2E}Fly Project – Back In My Life\r\n",strlen(String));
				strins(String,"{FFFFFF}28.{FE9A2E}Дмитрий Колдун – Корабли Уходят На Закат\r\n",strlen(String));
	            strins(String,"{FFFFFF}29.{FE9A2E}Oceana – Endless Summer\r\n",strlen(String));
	            strins(String,"{FFFFFF}30.{FE9A2E}Loreen – My Heart Is Refusing Me \r\n",strlen(String));
				strins(String,"{FFFFFF}31.{FE9A2E}One Republic – Counting Stars\r\n",strlen(String));
	            strins(String,"{FFFFFF}32.{FE9A2E}Kaoma – Lambada\r\n",strlen(String));
	            strins(String,"{FFFFFF}33.{FE9A2E}Rihanna – Rude Boy\r\n",strlen(String));
				strins(String,"{FFFFFF}34.{FE9A2E}Flo Rida (feat. Sia) – Wild Ones\r\n",strlen(String));
	            strins(String,"{FFFFFF}35.{FE9A2E}Flo Rida (feat. Taio Cruz) – Hangover\r\n",strlen(String));
	            strins(String,"{FFFFFF}36.{FE9A2E}Milk & Sugar – Let The Sun Shine\r\n",strlen(String));
				strins(String,"{FFFFFF}37.{FE9A2E}Lenka – Everything At Once\r\n",strlen(String));
	            strins(String,"{FFFFFF}38.{FE9A2E}Eurythmics – Sweet Dreams\r\n",strlen(String));
	            strins(String,"{FFFFFF}39.{FE9A2E}The Wanted – Drunk On Love\r\n",strlen(String));
				strins(String,"{FFFFFF}40.{FE9A2E}Flo Rida – I Cry\r\n",strlen(String));
	            strins(String,"{FFFFFF}41.{FE9A2E}Sia – She Wolf\r\n",strlen(String));
	            strins(String,"{FFFFFF}42.{FE9A2E}Pitbull – Echa Pa'lla, Pa' Arriba\r\n",strlen(String));
				strins(String,"{FFFFFF}43.{FE9A2E}OneRepublic – All The Right Moves\r\n",strlen(String));
	            strins(String,"{FFFFFF}44.{FE9A2E}Bob Sinclar – Rock This Party (Everybody Dance Now)\r\n",strlen(String));
	            strins(String,"{FFFFFF}45.{FE9A2E}Will i Am – That power \r\n",strlen(String));
				strins(String,"{FFFFFF}46.{FE9A2E}Katy Perry – Last Friday Night\r\n",strlen(String));
				strins(String,"{FFFFFF}47.{FE9A2E}Don Omar feat. Tego Calderon – Bandaleros\r\n",strlen(String));
	            strins(String,"{FFFFFF}48.{FE9A2E}Dan Balan (feat. Tany Vander & Brasco) – Lendo Calendo\r\n",strlen(String));
				strins(String,"{FFFFFF}49.{FE9A2E}Don Omar feat. Lucenzo – Danza Kuduro\r\n",strlen(String));
	            ShowPlayerDialog(playerid,5325,DIALOG_STYLE_LIST,"{00ACFF}»»» {FE9A2E}Pop{00ACFF} «««",String,"»[Включить]«","»[Назад]«");
            }
            if(listitem == 2)
            {
	            new String[4000];
	            strins(String,"{FFFFFF}1.{C8FE2E}Calvin Harris (feat. Ellie Goulding) – I Need Your Love\r\n",strlen(String));
	            strins(String,"{FFFFFF}2.{C8FE2E}Lana Del Ray – Summertime Sadness (Cedric Gervais Remix Edit)\r\n",strlen(String));
	            strins(String,"{FFFFFF}3.{C8FE2E}DJ Gollum (feat. Scarlet) – Poison (Marco Van Bassken Remix)\r\n",strlen(String));
	            strins(String,"{FFFFFF}4.{C8FE2E}Kid Cudi – Pursuit Of Happiness (Steve Aoki Dance Remix)\r\n",strlen(String));
	            strins(String,"{FFFFFF}5.{C8FE2E}Flo Rida – Good Feeling\r\n",strlen(String));
	            strins(String,"{FFFFFF}6.{C8FE2E}DJ Tiesto, Allure Feat. Jes – Show Me The Way\r\n",strlen(String));
				strins(String,"{FFFFFF}7.{C8FE2E}Basto & Yves V – Cloudbreaker (Basto Radio Edit)\r\n",strlen(String));
	            strins(String,"{FFFFFF}8.{C8FE2E}Klaas & Bodybangers – I Like (Bodybangers Mix)\r\n",strlen(String));
	            strins(String,"{FFFFFF}9.{C8FE2E}Fun – We Are Young (Slider & Magnit rmx)\r\n",strlen(String));
				strins(String,"{FFFFFF}10.{C8FE2E}TON!C feat. Tarantula Man – Big Fat \r\n",strlen(String));
	            strins(String,"{FFFFFF}11.{C8FE2E}Dj Indygo feat. Chris Antonio – Fuck this early morning (Royal XTC Remix)\r\n",strlen(String));
	            strins(String,"{FFFFFF}12.{C8FE2E}Bang La Decks – Utopia\r\n",strlen(String));
				strins(String,"{FFFFFF}13.{C8FE2E}Duke Dumont (feat. A-M-E) – Need U\r\n",strlen(String));
	            strins(String,"{FFFFFF}14.{C8FE2E}Imany – You Will Never Know\r\n",strlen(String));
	            strins(String,"{FFFFFF}15.{C8FE2E}Sarvi – Amore (Chuckie Radio Edit)\r\n",strlen(String));
				strins(String,"{FFFFFF}16.{C8FE2E}Rihanna feat. David Guetta – Right Now (Justin Prime Radio Edit) \r\n",strlen(String));
	            strins(String,"{FFFFFF}17.{C8FE2E}Azealia Banks feat. Lazy Jay – 212 \r\n",strlen(String));
	            strins(String,"{FFFFFF}18.{C8FE2E}Plastik Funk & Kurd Maverick – Blue Mondy (DJ Mikro Remix)\r\n",strlen(String));
	            ShowPlayerDialog(playerid,5326,DIALOG_STYLE_LIST,"{00ACFF}»»» {C8FE2E}House & Dance{00ACFF} «««",String,"»[Включить]«","»[Назад]«");
            }
            if(listitem == 3)
            {
	            new String[4000];
	            strins(String,"{FFFFFF}1.{D358F7}Skillet – Monster\r\n",strlen(String));
	            strins(String,"{FFFFFF}2.{D358F7}Three Days Grace – I Hate Everything About You\r\n",strlen(String));
	            strins(String,"{FFFFFF}3.{D358F7}Three Days Grace – Pain\r\n",strlen(String));
	            strins(String,"{FFFFFF}4.{D358F7}Skillet – Whispers In The Dark\r\n",strlen(String));
	            strins(String,"{FFFFFF}5.{D358F7}Skillet – Rise\r\n",strlen(String));
	            strins(String,"{FFFFFF}6.{D358F7}Linkin Park – Lost In The Echo\r\n",strlen(String));
	            strins(String,"{FFFFFF}7.{D358F7}Hollywood Undead – California\r\n",strlen(String));
	            strins(String,"{FFFFFF}8.{D358F7}Three Days Grace – Over And Over\r\n",strlen(String));
	            strins(String,"{FFFFFF}9.{D358F7}Hollywood Undead – Young\r\n",strlen(String));
	            strins(String,"{FFFFFF}10.{D358F7}System Of A Down – Radio-Video\r\n",strlen(String));
	            strins(String,"{FFFFFF}11.{D358F7}Placebo – Song To Say Goodbye\r\n",strlen(String));
	            strins(String,"{FFFFFF}12.{D358F7}Skillet – Awake and Alive\r\n",strlen(String));
	            strins(String,"{FFFFFF}13.{D358F7}Sum 41 – Some Say \r\n",strlen(String));
	            strins(String,"{FFFFFF}14.{D358F7}Styles of Beyond – Nine Thou\r\n",strlen(String));
	            strins(String,"{FFFFFF}15.{D358F7}Papa Roach – Last Resort\r\n",strlen(String));
	            strins(String,"{FFFFFF}16.{D358F7}Thousand Foot Krutch – Smack Down\r\n",strlen(String));
	            strins(String,"{FFFFFF}17.{D358F7}Placebo – First Day\r\n",strlen(String));
	            ShowPlayerDialog(playerid,5327,DIALOG_STYLE_LIST,"{00ACFF}»»» {D358F7}Alternative{00ACFF} «««",String,"»[Включить]«","»[Назад]«");
            }
            if(listitem == 4)
            {
	            new String[4000];
	            strins(String,"{FFFFFF}1.{81BEF7}Sting – Shape Of My Heart\r\n",strlen(String));
	            strins(String,"{FFFFFF}2.{81BEF7}Nancy Sinatra – Bang Bang\r\n",strlen(String));
	            strins(String,"{FFFFFF}3.{81BEF7}Sting – Englishman In New York\r\n",strlen(String));
	            strins(String,"{FFFFFF}4.{81BEF7}Kings Of Leon – Closer\r\n",strlen(String));
	            strins(String,"{FFFFFF}5.{81BEF7}Sting – Here I Am \r\n",strlen(String));
	            strins(String,"{FFFFFF}6.{81BEF7}Eli & Fur – You're so high\r\n",strlen(String));
	            strins(String,"{FFFFFF}7.{81BEF7}Sting – Fields Of Gold\r\n",strlen(String));
	            strins(String,"{FFFFFF}8.{81BEF7}Sting – Fragile\r\n",strlen(String));
	            strins(String,"{FFFFFF}9.{81BEF7}Elvis Presley – My Love\r\n",strlen(String));
	            ShowPlayerDialog(playerid,5328,DIALOG_STYLE_LIST,"{00ACFF}»»» {81BEF7}Easy Listening{00ACFF} «««",String,"»[Включить]«","»[Назад]«");
            }
    	}
    	else // Возврощение в меню
    	{
            new String[2048];
            strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
            strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
            strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
            strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
            strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
            strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
            strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
            strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
            strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
            strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
            strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
            strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
            strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
            strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
            strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
            strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
            strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
            strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
            strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
            ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
        }
    }
//Смена ника
	if(dialogid == 5006)
	{
	    if(response)
		{
			if(!strlen(inputtext)) return SendClientMessage(playerid, red, "*Вы ничего не Ввели..*");
			if(strlen(inputtext) < 3) return SendClientMessage(playerid,red,"** Слишком короткий Ник(от 3 до 20 символов)");
			if(strlen(inputtext) > 20) return SendClientMessage(playerid,red,"** Слишком длинный Ник(от 3 до 20 символов)");
			new name[MAX_PLAYER_NAME];
			new string[256];
			format(name,sizeof(name),"%s",inputtext);
			if(!udb_Exists(name))
			{
				if(PlayerInfo[playerid][Level] >= 11 || IsPlayerAdmin(playerid))
				{
					format(string,sizeof(string),"* {FFFFFF}Создатель {FF0000}%s(ID: %d) {FFFFFF}Сменил себе ник на {FF0000}%s",PlayerName2(playerid),playerid,inputtext);
					SendClientMessageToAll(0xFFFF00AA,string);
					SaveToFile("Change_Nick_Admin",string);
					udb_RenameUser(PlayerName2(playerid),inputtext);
					udb_Remove(PlayerName2(playerid));
					SetPlayerName(playerid,inputtext);
					SetTimerEx("lol",1000,0,"i",playerid);
				}
		 		else
				{
					format(string,sizeof(string),"* {FFFFFF}Игрок {FF0000}%s(ID: %d) {FFFFFF}Сменил себе ник на {FF0000}%s",PlayerName2(playerid),playerid,inputtext);
					SendClientMessageToAll(0xFFFF00AA,string);
					SaveToFile("Change_Nick",string);
					udb_RenameUser(PlayerName2(playerid),inputtext);
					udb_Remove(PlayerName2(playerid));
					SetPlayerName(playerid,inputtext);
					SetTimerEx("lol",1000,0,"i",playerid);
					}
				}
			else
			{
			SendClientMessage(playerid, red, "* Аккаунт с таким именем уже существует.");
		}
	}
}

	if(dialogid == 113)
	{
		if(response)
		{
			SendClientMessage(playerid,0xF60000AA,"");
   		}
     	else
      	{
      		SendClientMessage(playerid,0xF60000AA,"Ты нажал кнопку нет");
		}
   	}

	if(dialogid == 5000)
	{
	    if(response)
	    {
			if(strval(inputtext) == playerid) return SendClientMessage(playerid, -1, "* {FF0000}Вы не можите вызывать себя на дуэль!!!!!!");
			DuelOffer[playerid] = strval(inputtext);
	        if(IsPlayerConnected(DuelOffer[playerid]))
			{
				ShowPlayerDialog(playerid,5001,1,"{F8FF88}Введите цену","{EEDD00}Введите цену дуэли","Далее","Отмена");
			}
		}
	}
	if(dialogid == 5001)
	{
	    if(response)
	    {
			DuelPrice[playerid] = strval(inputtext);
			if(strval(inputtext) < 0) return SendClientMessage(playerid,red,"{00ff7f}Введённая вами сума отрицательная !! Вы можете вести от 0 до 20000$ !!!") && ShowPlayerDialog(playerid,5001,1,"{00ff7f}Введите цену","{7df9ff}Введите цену дуэли","Далее","Отмена");
	        if(DuelPrice[playerid] <= MaxSumma)
	        {
	            if(DuelStatus == 0)
	            {
					new name[255];
					new givename[255];
					new str[256];
                    GetPlayerName(playerid,name,sizeof(name));
					GetPlayerName(DuelOffer[playerid],givename,sizeof(givename));
                    format(str,256,"{0000CC}Вы желаете провести дуэль с игроком %s {00CCBB}|| {00EE88}Цена: {00AA11}%d",name,DuelPrice[playerid]);
					SendClientMessage(DuelOffer[playerid],-1,str);
					format(str,256,"{0000CC}Игрок %s желает провести с вами дуэль {00CCBB}|| {00EE88}Цена: {00AA11}%d {004422}Вы согласны?",name,DuelPrice[playerid]);
                    //SendClientMessage(DuelOffer[playerid],-1,str);
                    ShowPlayerDialog(DuelOffer[playerid],5002,DIALOG_STYLE_MSGBOX,"{F8FF88}Вы согласны?",str,"Да","НеТ");
					DuelPrice[DuelOffer[playerid]] = DuelPrice[playerid];
					DuelOffer[DuelOffer[playerid]] = playerid;
				}
				else
				{
				    SendClientMessage(playerid,-1,"{ff0000}Подождите пока не закончится дуэль");
				}
			}
		}
	}
    if(dialogid == 5002)
	{
	    if(response)
	    {
      		if(DuelOffer[playerid] != 999 && Glava[playerid] != 1 && Duel[playerid] == 0)
	    	{
		        if(DuelStatus == 0)
		        {
			        new str[256];
			        new str2[256];
			        new name[255];
			        new givename[255];
	                new strmine[256];
					GetPlayerName(playerid,name,sizeof(name));
			        GetPlayerName(DuelOffer[playerid],givename,sizeof(givename));
			        format(str,256,"{CC00DD}[Дуэль]{993344}Вы согласились на дуэль с игроком %s",givename);
			        SendClientMessage(playerid,-1,str);
			        format(str2,256,"{CC00DD}[Дуэль]{993344}Игрок %s согласился с вами на дуэль",name);
			        SendClientMessage(DuelOffer[playerid],-1,str2);
			        SetPlayerColor(playerid,0x10F441AA);
			        SetPlayerColor(DuelOffer[playerid],0xAFAFAFAA);
			        Duelant[0] = playerid;
			        Duelant[1] = DuelOffer[playerid];
			        SetTimerEx("DuelTimer", FreezeTimeDUEL, false, "ii", playerid,DuelOffer[playerid]);
			        SendClientMessage(playerid,-1,"{CC00DD}[Дуэль]{993344}Покажи ему кто сильнее Go Go Go!!! ");
			        SendClientMessage(DuelOffer[playerid],-1,"{CC00DD}[Дуэль]{993344}Покажи ему кто сильнее Go Go Go!!! ");
	                format(strmine, sizeof(strmine), "{CC00DD}[Р-Ц]: {993344}Игроки {88FF00}%s {993344}и {88FF00}%s {993344}Зашли на Дуэль", name,givename);
				    SendClientMessageToAll(0xB0B0FFAA,strmine);
					ResetPlayerWeapons(playerid);
					SetPlayerHealth(playerid,100);
					SetPlayerArmour(playerid,100);
	   	            new StringDuel[500];
	                strins(StringDuel,"{00FFFF}Desert Eagle\t\t| {00FF00}Players\r\n",strlen(StringDuel));
	       	        strins(StringDuel,"{00FFFF}Shotgun\t\t| {00FF00}Players\r\n",strlen(StringDuel));
	       	        strins(StringDuel,"{00FFFF}M4\t\t\t| {00FF00}Players\r\n",strlen(StringDuel));
	       	        strins(StringDuel,"{00FFFF}Combat Shotgun\t| {00FF00}9 Level\r\n",strlen(StringDuel));
	                strins(StringDuel,"{00FFFF}D.Eagle+Shotgun\t| {EFF600}ViP\r\n",strlen(StringDuel));
	                strins(StringDuel,"{00FFFF}D.Eagle+Shotgun+M4\t| {FF0000}Admin\r\n",strlen(StringDuel));
	    	        ShowPlayerDialog(playerid,3656,DIALOG_STYLE_LIST,"Weapon Duel",StringDuel,"»]Выбор[«","»]Отмена[«");
					GivePlayerWeapon(playerid,24,99999);//ид ружбайки 1 игрока
					SetPlayerArmorAC(playerid,100.0);
	                SetPlayerHealthAC(playerid,100.0);
					ResetPlayerWeapons(DuelOffer[playerid]);
					SetPlayerHealthAC(DuelOffer[playerid],100);
					SetPlayerArmorAC(DuelOffer[playerid],100);
	                new StringDuel2[500];
	                strins(StringDuel2,"{00FFFF}Desert Eagle\t\t| {00FF00}Players\r\n",strlen(StringDuel2));
	       	        strins(StringDuel2,"{00FFFF}Shotgun\t\t| {00FF00}Players\r\n",strlen(StringDuel2));
	       	        strins(StringDuel2,"{00FFFF}M4\t\t\t| {00FF00}Players\r\n",strlen(StringDuel2));
	       	        strins(StringDuel2,"{00FFFF}Combat Shotgun\t| {00FF00}9 Level\r\n",strlen(StringDuel2));
	                strins(StringDuel2,"{00FFFF}D.Eagle+Shotgun\t| {EFF600}ViP\r\n",strlen(StringDuel2));
	                strins(StringDuel2,"{00FFFF}D.Eagle+Shotgun+M4\t| {FF0000}Admin\r\n",strlen(StringDuel2));
	    	        ShowPlayerDialog(DuelOffer[playerid],3656,DIALOG_STYLE_LIST,"Weapon Duel",StringDuel2,"»]Выбор[«","»]Отмена[«");
					GivePlayerWeapon(DuelOffer[playerid],24,99999);//ид ружбайки 2 игрока
					SetPlayerPos(playerid,2611.46, 2823.29, 10.82);//Исправь на свои координаты(тп 1 игрока)
			  		SetPlayerPos(DuelOffer[playerid],2570.42, 2825.05, 10.82);//Исправь на свои координаты(тп 2 игрока)
				    TogglePlayerControllable(playerid,0);
			        TogglePlayerControllable(DuelOffer[playerid],0);
			        Duel[playerid] = 1;
			        Duel[DuelOffer[playerid]] = 1;
			        DuelStatus = 1;
	         	    if(udb_UserIsset(givename,"allduel")) udb_UserSetInt(givename,"allduel", udb_UserInt(givename,"allduel") + 1); else udb_UserSetInt(givename,"allduel", 1);
		  			if(udb_UserIsset(name,"allduel")) udb_UserSetInt(name,"allduel", udb_UserInt(name,"allduel") + 1); else udb_UserSetInt(name,"allduel", 1);
				}
				else
				{
				    SendClientMessage(playerid,-1,"{ff0000}Подождите пока не закончится дуэль");
				}
			}
		}else
		{
			new str[256];
			new str2[256];
			new name[255];
			new givename[255];
			GetPlayerName(playerid,name,sizeof(name));
			GetPlayerName(DuelOffer[playerid],givename,sizeof(givename));
			format(str,256,"{CC00DD}[Дуэль]{993344}Вы не согласились на дуэль с игроком %s",givename);
			SendClientMessage(playerid,-1,str);
			format(str2,256,"{CC00DD}[Дуэль]{993344}Игрок %s не согласился с вами на дуэль",name);
			SendClientMessage(DuelOffer[playerid],-1,str2);
			DuelOffer[DuelOffer[playerid]] = 999;
			DuelOffer[playerid] = 999;
		}
	}
//////////church
	new stringg[103];
    if(dialogid == 555)
    {
        if(response)
        {
            id_newlywed[playerid] = strval(inputtext);
            id_newlywed[id_newlywed[playerid]] = playerid;
            if(strval(inputtext) < 0 || strval(inputtext) > 500)
            {
                ShowPlayerDialog(playerid,555,DIALOG_STYLE_INPUT,"{00bdff}Сводебная церемония!!!","{00bdff}Неправильный ввод ид!\nИспользуйте только цифры(0-9)\nВведите ид невесты:","Ок","Отмена");
                return 1;
            }
            if(id_newlywed[playerid] == playerid)
            {
                ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","                      {ff00ff}Ошибка!\nВы не можете жениться на себе!", ".:Ok:.",".:Выход:.");
                return 1;
            }
            if(!IsPlayerConnected(id_newlywed[playerid]))
            {
                ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","{ff00ff}Игрока с таким id нет на сервере.", ".:Ok:.",".:Выход:.");
                return 1;
            }
            if(Sex[id_newlywed[playerid]] == 2)
            {
                ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","{ff00ff}О_о этот игрок не девушка!!!", ".:Ok:.",".:Выход:.");
                return 1;
            }
            if(!IsPlayerInRangeOfPoint(id_newlywed[playerid], 50, 369.4337,2323.8674,1890.6047))
            {
                ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","{ff00ff}Ваша Невеста не в церкви....\nА вы должны быть вместе на церемонии", ".:Ok:.",".:Выход:.");
            }
            else
            {
                 new string2[1024];
                 format(string2,1024,"{ff00ff}Дорогие новобрачные,в жизни каждого человека бывают незабываемые дни.\nСегодня такой день у вас-день рождения вашей семьи.\nСемья-это союз любящих людей и союз добровольный.\nИ прежде чем зарегистрировать свой брак я обязан спросить вас является ли\nваше желание вступить в брак искреним,свободным и хорошо обдуманным.\n\n                  Вы хотите жениться на %s ?",PlayerNamerr(id_newlywed[playerid]));
                 ShowPlayerDialog(playerid,564,0, "           {FFFF00}Свадебная церемония",string2, "Согласен", "Отмена");
                 format(string2,1024,"{ff00ff}Дорогие новобрачные,в жизни каждого человека бывают незабываемые дни.\nСегодня такой день у вас-день рождения вашей семьи.\nСемья-это союз любящих людей и союз добровольный.\nИ прежде чем зарегистрировать свой брак я обязан спросить вас является ли\nваше желание вступить в брак искреним,свободным и хорошо обдуманным.\n\n                  Вы хотите выйти замуж за %s ?",PlayerNamerr(playerid));
                 ShowPlayerDialog(id_newlywed[playerid],564,0, "           {FFFF00}Свадебная церемония",string2, "Согласна", "Отмена");
            }
        }
    }
	if(dialogid == 564)
    {
        if(response)
        {
            accept[playerid] = 1;
            if(accept[id_newlywed[playerid]] == 1)
            {
                format(stringg,256,"{ff00ff}Вы заключили брак с %s",PlayerNamerr(playerid));
                ShowPlayerDialog(id_newlywed[playerid],1,0, "           {FFFF00}Свадебная церемония",stringg, "Ок", "Отмена");
                format(stringg,256,"{ff00ff}Вы заключили брак с %s",PlayerNamerr(id_newlywed[playerid]));
                ShowPlayerDialog(playerid,1,0, "           {FFFF00}Свадебная церемония",stringg, "Ок", "Отмена");
                format(stringg, sizeof(stringg), "{FF00FF}[Р-Ц]: %s и %s обвенчались в Церкви,теперь они счастливы!!!", PlayerNamerr(playerid), PlayerNamerr(id_newlywed[playerid]));
                SendClientMessageToAll(1, stringg);
                accept[playerid] = 0;
                accept[id_newlywed[playerid]] = 0;
                format(newlywed[playerid],256,"%s",PlayerNamerr(id_newlywed[playerid]));
                format(newlywed[id_newlywed[playerid]],256,"%s",PlayerNamerr(playerid));
                new fn[256];
                format(fn,256,"wedding/%s.ini",PlayerNamerr(playerid));
                dini_Set(fn,"newlywed",newlywed[playerid]);
                //
                format(fn,256,"wedding/%s.ini",PlayerNamerr(id_newlywed[playerid]));
                dini_Set(fn,"newlywed",newlywed[id_newlywed[playerid]]);
                id_newlywed[playerid] = 0;
                id_newlywed[id_newlywed[playerid]] = 0;
            }
        }
        else
        {
            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","{ff00ff}Вы отказались!", ".:Ok:.",".:Выход:.");
            ShowPlayerDialog(id_newlywed[playerid], 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","{ff00ff}Вам отказали!", ".:Ok:.",".:Выход:.");
            accept[playerid] = 0;
            accept[id_newlywed[playerid]] = 0;
            id_newlywed[playerid] = 0;
            id_newlywed[id_newlywed[playerid]] = 0;
        }
    }
//////////church
//===========================[ Дополнение 01 ]==================================

	if(dialogid == 586)
    {
        if(response)
        {
            if(listitem == 0)//свет вкл
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,true,alarm,doors,bonnet,boot,objective);
	            SendClientMessage(playerid, 0xFF6347AA,"{00FF00}Вы включили Фары!");
            }
            else if(listitem == 1)//свет выкл
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,false,alarm,doors,bonnet,boot,objective);
	            SendClientMessage(playerid, 0xFF6347AA,"{FF0000}Вы выключили Фары!");
            }
            else if(listitem == 2)//капот отк
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,lights,alarm,doors,true,boot,objective);
	            SendClientMessage(playerid, 0xFF6347AA,"{00FF00}Вы Открыли капот!");
            }
            else if(listitem == 3)//капот зак
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,lights,alarm,doors,false,boot,objective);
	            SendClientMessage(playerid, 0xFF6347AA,"{FF0000}Вы закрыли капот!");
            }
            else if(listitem == 4)//багажник отк
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,true,objective);
	            SendClientMessage(playerid, 0xFF6347AA,"{00FF00}Вы открыли багажник!");
            }
            else if(listitem == 5)//багажник зак
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,false,objective);
	            SendClientMessage(playerid, 0xFF6347AA,"{FF0000}Вы закрыли багажник!");
            }
            else if(listitem == 6)
            {
                ShowPlayerDialog(playerid,587,DIALOG_STYLE_LIST,"Выберите цвет","{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\n{FFFF00}Желтый\n{FEBFEF}Розовый\nБелый","Выбрать","Отмена");
            }
            else if(listitem == 7)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
            }
            if(listitem == 8)
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,lights,alarm,false,bonnet,boot,objective);
	            SendClientMessage(playerid, COLOR_GREEN, "{449944}>>> Вы открыли двери своего транспорта");
            }
            if(listitem == 9 )
            {
	            new carid = GetPlayerVehicleID(playerid);
	            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	            SetVehicleParamsEx(carid,engine,lights,alarm,true,bonnet,boot,objective);
	            SendClientMessage(playerid, COLOR_GREEN, "{BB1122}<<< Вы закрыли двери своего транспорта");
            }
            if(listitem == 10 )
            {
	            new String[2048];
	            strins(String,"{00FF00}¤ Включить фары ¤\r\n",strlen(String));
	            strins(String,"{FF0000}¤ Выключить фары ¤\r\n",strlen(String));
	            strins(String,"{00FF00}¤ Открыть капот ¤\r\n",strlen(String));
	            strins(String,"{FF0000}¤ Закрыть капот ¤\r\n",strlen(String));
	            strins(String,"{00FF00}¤ Открыть багажник ¤\r\n",strlen(String));
	            strins(String,"{FF0000}¤ Закрыть багажник ¤\r\n",strlen(String));
	            strins(String,"{00FF00}¤ Включить неон ¤\r\n",strlen(String));
	            strins(String,"{FF0000}¤ Выключить неон ¤\r\n",strlen(String));
	            strins(String,"{00FF00}¤ Открыть двери ¤\r\n",strlen(String));
	            strins(String,"{FF0000}¤ Закрыть двери ¤\r\n",strlen(String));
	            strins(String,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(String));
	            strins(String,"{1CF9E8}¤ Починить ¤\r\n",strlen(String));
	            strins(String,"{1CF9E8}¤ Починить {EFF600}[V] {1CF9E8}¤\r\n",strlen(String));
	            strins(String,"{18D5FC}¤ Флипнуть ¤\r\n",strlen(String));
	            strins(String,"{18D5FC}¤ Смена номера ¤\r\n",strlen(String));
	            strins(String,"{1AACFB}¤ Смена дисков ¤\r\n",strlen(String));
	            strins(String,"{1AACFB}¤ Сменить цвет авто ¤\r\n",strlen(String));
	            strins(String,"{1C8AF9}¤ Мигалка на авто ¤\r\n",strlen(String));
	            strins(String,"{1C8AF9}¤ Убрать мигалку ¤\r\n",strlen(String));
	            strins(String,"{1D33F8}¤ Заспавнить ¤\r\n",strlen(String));
	            strins(String,"{1D33F8}¤ GodCar ¤\r\n",strlen(String));
	            ShowPlayerDialog(playerid,586,DIALOG_STYLE_LIST,"{00f9ff}Авто-Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
            }
            if(listitem == 11 )
            {
	            new zapret;
	            zapret = GetPlayerVehicleID(playerid);
	            if(GetVehicleModel(zapret) == 432) return SendClientMessage(playerid, 0xFF0000AA, "[Р-Ц™]: Вы не можете чинить Военную технику!");
	            if(GetVehicleModel(zapret) == 447) return SendClientMessage(playerid, 0xFF0000AA, "[Р-Ц™]: Вы не можете чинить Военную технику!");
	            if(GetVehicleModel(zapret) == 520) return SendClientMessage(playerid, 0xFF0000AA, "[Р-Ц™]: Вы не можете чинить Военную технику!");
	            if(GetVehicleModel(zapret) == 425) return SendClientMessage(playerid, 0xFF0000AA, "[Р-Ц™]: Вы не можете чинить Военную технику!");
	            if(GetPlayerMoney(playerid) < 5000) return SendClientMessage(playerid, 0x00FF00AA, "[Р-Ц™]: Не достаточно денег. Нужно $5.000");
	            if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0x00FF00AA,"[Р-Ц™]: Вы должны быть в машине!");
		        RepairVehicle(GetPlayerVehicleID(playerid)); // для 0.3
		        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		        GivePlayerMoney(playerid,-5000);
		        SendClientMessage(playerid,0xffffffAA,"* {FF0000}Вы починили свой транспорт.");
            }
            if(listitem == 12 )
            {
            	OnPlayerCommandText(playerid,"/vrepair");//чинилка V
            }
            if(listitem == 13 )
            {
		        if(GetPlayerMoney(playerid) < 5000)
	 	        {
		        	SendClientMessage(playerid, 0x00FF00AA, "[Р-Ц™]: Не достаточно денег. Нужно $5.000");
	          		return 1;
		        }
	            new vehicleid = (GetPlayerVehicleID(playerid));
	            new Float:x,Float:y,Float:z,Float:angle;
	            GetVehiclePos(vehicleid,x,y,z);
	            GetVehicleZAngle(vehicleid,angle);
	            SetVehiclePos(vehicleid,x,y,z+1);
	            SetVehicleZAngle(vehicleid,angle);
	            GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Flipped", 1000, 3);//Флип
	           	GivePlayerMoney(playerid, -5000);
            }
            else if(listitem == 14)
            {
	            new Float:x,Float:y,Float:z,Float:ang;
	            GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
	            GetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
	            if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFFFFFFFF,"Вы не находитесь в транспортном средстве!");
	            ShowPlayerDialog(playerid,4721,DIALOG_STYLE_INPUT,"{CCFF44}Номер машины","{FFFF44}Введите желаемый номер и нажмите ОК","ОК","Отмена");
            }
            else if(listitem == 15)//смена дисков
            {
            	ShowPlayerDialog(playerid,119,DIALOG_STYLE_LIST,"{00FFFF}Установка дисков","{FF0000}Offroad\n{FF2C00}Shadow\n{FF5000}Mega\n{FF8700}Rimshine\n{FFA700}Wires\n{FFDC00}Classic\n{FFFB00}Twist\n{C4FF00}Cutter\n{7BFF00}Switch\n{00FF00}Grove\n{00FF1E}Import\n{00FF3B}Dollar\n{00FF7C}Trance\n{00FFAE}Atomic\n{00FFD5}Ahab\n{00FFFF}Virtual\n{00CCFF}Access","Выбор","Отмена");
            }
            else if(listitem == 16)//смена цвета
            {
            	ShowPlayerDialog(playerid,DIALOG_CARCOLORS,DIALOG_STYLE_INPUT,"{FF0000}Прекраска","{8b00ff}Введите ID первого цвета:","Выбор","Отмена");
            }
            else if(listitem == 17)//мигалка на авто
            {
            	OnPlayerCommandText(playerid,"/мигалкасукаыав");//чинилка
            }
            else if(listitem == 18)//выкл мигалки
            {
            	DestroyObject(lustra[GetPlayerVehicleID(playerid)]);
            	SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}* {8b00ff}Вы Удалили все мигалки");
            }
            else if(listitem == 19)//Спавн
            {
	            new veh;
	            veh = GetPlayerVehicleID(playerid);
		    	SetVehicleToRespawn(veh);
				GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Respawned", 1000, 3);
    		}
            else if(listitem == 20)//gm car
            {
            	OnPlayerCommandText(playerid,"/godcar");//чинилка
            }
        }
    }

//===========================[Новые вывод с телепортов]====================================================
   	if(dialogid == 7127)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/aerostunt");
				case 1: OnPlayerCommandText(playerid,"/motostunt");
				case 2: OnPlayerCommandText(playerid,"/bmxpark");
				case 3: OnPlayerCommandText(playerid,"/box");
				case 4: OnPlayerCommandText(playerid,"/bigtunel");
				case 5: OnPlayerCommandText(playerid,"/stuntsf");
				case 6: OnPlayerCommandText(playerid,"/stuntlv");
				case 7: OnPlayerCommandText(playerid,"/spusk");
				case 8: OnPlayerCommandText(playerid,"/trubs");
				case 9: OnPlayerCommandText(playerid,"/platrubs");
				case 10: ShowPlayerDialog(playerid, 3147, DIALOG_STYLE_LIST, "{3CFF00}Drift Zone","{FF0000}Зона Дрифта #1\n{FC5132}Зона Дрифта #2\n{FD7331}Зона Дрифта #3\n{FEB030}Зона Дрифта #4\n{FEB030}Зона Дрифта #5 HARD","»]Выбрать[«", "»]Выход[«");
				case 11: ShowPlayerDialog(playerid, 3148, DIALOG_STYLE_LIST, "{3CFF00}Parkour Zone","{FF0000}Зона Паркура #1\n{FC5132}Зона Паркура #2\n{FD7331}Зона Паркура #3\n{FEB030}Зона Паркура #4 'HarD\n{FFD62F}Зона Паркура #5","»]Выбрать[«", "»]Выход[«");
				case 12: OnPlayerCommandText(playerid,"/sumo");
				case 13: ShowPlayerDialog(playerid, 3150, DIALOG_STYLE_LIST, "{3CFF00}Гоночные треки","{FF0000}Race Trek #1 (Круг)\n{FC5132}Race Trek #2 (Водяной-Драг)","»]Выбрать[«", "»]Выход[«");
				case 14: OnPlayerCommandText(playerid,"/jump");
				case 15: OnPlayerCommandText(playerid,"/trubssf");
		    }
		}
	    return true;
	}

   	if(dialogid == 7128)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/нло");
				case 1: OnPlayerCommandText(playerid,"/FBI");
				case 2: OnPlayerCommandText(playerid,"/weapost");
				case 3: OnPlayerCommandText(playerid,"/Hospital");
				case 4: OnPlayerCommandText(playerid,"/cinema");
				case 5: OnPlayerCommandText(playerid,"/concert");
				case 6: OnPlayerCommandText(playerid,"/rublevka");
				case 7: OnPlayerCommandText(playerid,"/ostrov");
				case 8: OnPlayerCommandText(playerid,"/turma");
				case 9: OnPlayerCommandText(playerid,"/pb");
				case 10: OnPlayerCommandText(playerid,"/ghouse");
				case 11: OnPlayerCommandText(playerid,"/vhouse");
				case 12: OnPlayerCommandText(playerid,"/ahouse");
				case 13: OnPlayerCommandText(playerid,"/bhouse");
				case 14: OnPlayerCommandText(playerid,"/restoranmore");
				case 15: OnPlayerCommandText(playerid,"/klubsf");
				case 16: OnPlayerCommandText(playerid,"/cityhall");
				case 17: OnPlayerCommandText(playerid,"/bigisland");
				case 18: OnPlayerCommandText(playerid,"/spripbar");
				case 19: OnPlayerCommandText(playerid,"/restorancezar");
				case 20: OnPlayerCommandText(playerid,"/restoranob");
				case 21: OnPlayerCommandText(playerid,"/kafemore");
		    }
		}
	    return true;
	}

   	if(dialogid == 7124)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/пляж");
				case 1: OnPlayerCommandText(playerid,"/skyscraper");
				case 2: OnPlayerCommandText(playerid,"/церковь");
				case 3: OnPlayerCommandText(playerid,"/банк");
				case 4: OnPlayerCommandText(playerid,"/банк2");
				case 5: OnPlayerCommandText(playerid,"/aerols");
				case 6: OnPlayerCommandText(playerid,"/gruv");
				case 7: OnPlayerCommandText(playerid,"/terminalls");
		    }
		}
	    return true;
	}

   	if(dialogid == 7125)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/race");
				case 1: OnPlayerCommandText(playerid,"/casino4dracon");
				case 2: OnPlayerCommandText(playerid,"/casinocaliguli");
				case 3: OnPlayerCommandText(playerid,"/pirat");
				case 4: OnPlayerCommandText(playerid,"/ammolv");
				case 5: OnPlayerCommandText(playerid,"/aerolv");
				case 6: OnPlayerCommandText(playerid,"/terminallv");
		    }
		}
	    return true;
	}

   	if(dialogid == 7126)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/terminalsf");
				case 1: OnPlayerCommandText(playerid,"/jizzy");
				case 2: OnPlayerCommandText(playerid,"/docsf");
				case 3: OnPlayerCommandText(playerid,"/aerosf");
				case 4: OnPlayerCommandText(playerid,"/wangcars");
				case 5: OnPlayerCommandText(playerid,"/ottosautos");
				case 6: OnPlayerCommandText(playerid,"/площадь");
				case 7: OnPlayerCommandText(playerid,"/tuningsf");
				case 8: OnPlayerCommandText(playerid,"/golf");
		    }
		}
	    return true;
	}

   	if(dialogid == 7129)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/rcb");
				case 1: OnPlayerCommandText(playerid,"/8track");
				case 2: OnPlayerCommandText(playerid,"/bloodbowl");
				case 3: OnPlayerCommandText(playerid,"/dtrack");
				case 4: OnPlayerCommandText(playerid,"/kickstart");
				case 5: OnPlayerCommandText(playerid,"/vstadium");
				case 6: OnPlayerCommandText(playerid,"/lsatruim");
				case 7: OnPlayerCommandText(playerid,"/bschool");
				case 8: OnPlayerCommandText(playerid,"/mroom");
				case 9: OnPlayerCommandText(playerid,"/broom");
				case 10: OnPlayerCommandText(playerid,"/miroom");
				case 11: OnPlayerCommandText(playerid,"/hroom");
				case 12: OnPlayerCommandText(playerid,"/woffice");
				case 13: OnPlayerCommandText(playerid,"/meatfactory");
				case 14: OnPlayerCommandText(playerid,"/shermandam");
		    }
		}
	    return true;
	}

   	if(dialogid == 7130)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: OnPlayerCommandText(playerid,"/fc");
				case 1: OnPlayerCommandText(playerid,"/lb");
				case 2: OnPlayerCommandText(playerid,"/ec");
				case 3: OnPlayerCommandText(playerid,"/lp");
				case 4: OnPlayerCommandText(playerid,"/sa");
				case 5: OnPlayerCommandText(playerid,"/dillimyr");
				case 6: OnPlayerCommandText(playerid,"/chirnika");
				case 7: OnPlayerCommandText(playerid,"/montgomeri");
				case 8: OnPlayerCommandText(playerid,"/rp");
		    }
		}
	    return true;
	}

   	if(dialogid == 7132)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0: SetPlayerPos(playerid,344.0263,-1832.4568,3.8524);
				case 1: SetPlayerPos(playerid,2514.3997,-1680.5311,13.4400);
				case 2: SetPlayerPos(playerid,1140.1002,-1426.2206,15.7969);
				case 3: SetPlayerPos(playerid,1430.4421,-847.1429,50.0845);
				case 4: SetPlayerPos(playerid,228.5691,-1260.3430,67.3749);
				case 5: SetPlayerPos(playerid,-689.1588,-1922.1449,11.5891);
				case 6: SetPlayerPos(playerid,404.0124,2531.2578,16.5626);
				case 7: SetPlayerPos(playerid,283.4267,1972.7113,17.6406);
				case 8: SetPlayerPos(playerid,-1998.1237,75.6171,28.0240);
				case 9: SetPlayerPos(playerid,2026.7418,1424.3066,10.8203);
				case 10: SetPlayerPos(playerid,1549.3898,-1366.1453,326.2109);
		    }
		}
	    return true;
	}

    if(dialogid == 3149)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			        new String[2000];
				    strins(String,"{8D8D8D}==============================================================================================================================\n",strlen(String));
				    strins(String,"{8D8D8D} Обновление![3.02.2014г]\n",strlen(String));
				    strins(String,"{8D8D8D}   \n",strlen(String));
				    strins(String,"{8D8D8D}   1)Новая система Level De.Game!\n",strlen(String));
				    strins(String,"{8D8D8D}   2)Новые Ранги сервера /rangs!\n",strlen(String));
				    strins(String,"{8D8D8D}   3)Новый стиль боя STREETBLOW (Доступ с 5000 SCORE)!\n",strlen(String));
				    strins(String,"{8D8D8D}   4)Стиль боя MiXCeni теперь доступен с 11000 SCORE!!\n",strlen(String));
				    strins(String,"{8D8D8D}   5)Зделано ограничение в изминении стиля боя для играков с уникальными стилями боя!\n",strlen(String));
				    strins(String,"{8D8D8D}   6)Если на вас наехали вы можите избедать DB /db!\n",strlen(String));
				    strins(String,"{8D8D8D}   7)Добавлены ID's в ЛС!\n",strlen(String));
				    strins(String,"{8D8D8D}   8)Появилась ViP System! Подробние /viphelp\n",strlen(String));
			        strins(String,"{8D8D8D}   9)Новое достижение для ViP! Доска под ногами!\n",strlen(String));
			        strins(String,"{8D8D8D}   10)Новое достижение для ViP! Оборудывание!\n",strlen(String));
			        strins(String,"{8D8D8D}   11)Новый выбор скинов!\n",strlen(String));
			        strins(String,"{8D8D8D}   12)Новые анимации при выборе скинов!\n",strlen(String));
			        strins(String,"{8D8D8D}   13)Убран тюнинг '2'!\n",strlen(String));
			        strins(String,"{8D8D8D}   14)Новые FUN Объекты - Оружие в теле!!\n",strlen(String));
			        strins(String,"{8D8D8D}   15)[ADM]Теперь Админ может накормить всех наркотиками!\n",strlen(String));
			        strins(String,"{8D8D8D}   16)Вернули Speedometer De.Game!\n",strlen(String));
			        strins(String,"{8D8D8D}   17)Исправлены ошибки в сохранение скинов! Теперь доступно всем!\n",strlen(String));
			        strins(String,"{8D8D8D}   18)Ограничение в Нарко-ларьке!\n",strlen(String));
			        strins(String,"{8D8D8D}   19)[ELISIYM]Теперь только Официальному составу будит доступны команды и телепорт!\n",strlen(String));
			        strins(String,"{8D8D8D}   20)Теперь нельзя использовать Alt,Tab,Cmd на CS & MG!\n",strlen(String));
				    strins(String,"{8D8D8D}   \n",strlen(String));
				    strins(String,"{8D8D8D}   P.S Новая версия мода Deadly Game = 9.4\n",strlen(String));
				    strins(String,"{8D8D8D}   \n",strlen(String));
				    strins(String,"{8D8D8D}   Project Deadly Game by John_Vibers©2021 - 2021.Все права защищены\n",strlen(String));
				    strins(String,"{8D8D8D}==============================================================================================================================\n",strlen(String));
					ShowPlayerDialog(playerid,8423,DIALOG_STYLE_MSGBOX,"Обновление и новая версия | Deadly Game v9.4",String,"Понятно","Выйти");
			    }
			    case 1:
			    {
			        new String[2000];
				    strins(String,"{8D8D8D}==============================================================================================================================\n",strlen(String));
				    strins(String,"{8D8D8D} Обновление![07.02.2014г]\n",strlen(String));
				    strins(String,"{8D8D8D}   \n",strlen(String));
				    strins(String,"{8D8D8D}   1)При убийстве появляется '+1 score' возле системы Level!\n",strlen(String));
				    strins(String,"{8D8D8D}   2)При неверной команды будит высвечиватся ошибка!\n",strlen(String));
				    strins(String,"{8D8D8D}   3)Улудшина ViP System'a | ViP , Gold ViP , Diamond ViP!\n",strlen(String));
				    strins(String,"{8D8D8D}   4)Новая зона для Mini Game!\n",strlen(String));
				    strins(String,"{8D8D8D}   5)Новая система выбора оружия в дуэли!!\n",strlen(String));
				    strins(String,"{8D8D8D}   \n",strlen(String));
				    strins(String,"{8D8D8D}   Project Deadly Game by John_Vibers©2021 - 2021.Все права защищены\n",strlen(String));
				    strins(String,"{8D8D8D}==============================================================================================================================\n",strlen(String));
					ShowPlayerDialog(playerid,8423,DIALOG_STYLE_MSGBOX,"Обновление | Deadly Game v9.4",String,"Понятно","Выйти");
			    }
			    case 3:
			    {
			        new String[2000];
				    strins(String,"{B85FF3}==============================================================================================================================\n",strlen(String));
				    strins(String,"{11F411} Обновление![13.09.2017г]\n",strlen(String));
				    strins(String,"{11F411}   \n",strlen(String));
				    strins(String,"{11F411}   1) Теперь пасажиры не смогут пользоватся Авто-Меню на ''2''!\n",strlen(String));
				    strins(String,"{11F411}   2) Сделана проверка на деньги в Достижениях!\n",strlen(String));
				    strins(String,"{11F411}   3) Сделана новая зона выбора скинов!\n",strlen(String));
				    strins(String,"{11F411}   4) Теперь анимации в выборе скина срабатуют с первого раза!\n",strlen(String));
				    strins(String,"{11F411}   5) Убран стандартный звук при выборе скина!\n",strlen(String));
				    strins(String,"{11F411}   6) Сделаны новые 3D Text домов!\n",strlen(String));
				    strins(String,"{11F411}   7) Теперь при покупки дома будет видно в общем чате за какую сумму игрок купил дом!\n",strlen(String));
				    strins(String,"{11F411}   8) Сделана оптимизация кода на 40#\n",strlen(String));
				    strins(String,"{11F411}   9) Теперь в тюрьме нельзя использовать Alt, Команды, Вызов на дуэль, Слежка за игроком!\n",strlen(String));
				    strins(String,"{11F411}   10) Вернуты MapIcons домов (Только свободных)!\n",strlen(String));
				    strins(String,"{11F411}   11) Добавлены новые дома по Los Santos!\n",strlen(String));
				    strins(String,"{11F411}   12) Убраные не нужные команды!\n",strlen(String));
				    strins(String,"{11F411}   13) Убрано реалистичное время, теперь игрок сам решит какое ему сделать игровое время!\n",strlen(String));
				    strins(String,"{11F411}   14) Убрано сисмема смены рандомной погоды, теперь игрок сам решит что ему лучше!\n",strlen(String));
				    strins(String,"{11F411}   15) Теперь при спавне можно выбрать между ''Слушать'' ''Выключить'' музыку!\n",strlen(String));
				    strins(String,"{11F411}   16) Покупка дома теперь возможна с 4 Уровня!\n",strlen(String));
				    strins(String,"{11F411}   17) Теперь нельзя вызывать самого себя на дуэль! (Нужен тест)\n",strlen(String));
				    strins(String,"{11F411}   18) Изменены все TextDraw сервера!\n",strlen(String));
				    strins(String,"{11F411}   19) Оптимизировано и настроено более 10.000 объектов сервера!\n",strlen(String));
				    strins(String,"{11F411}   20) Новое окно статистики игрока!\n",strlen(String));
				    strins(String,"{11F411}   \n",strlen(String));
				    strins(String,"{11F411}   Обновление от {FF0000}John_Vibers{11F411}!\n",strlen(String));
				    strins(String,"{B85FF3}==============================================================================================================================\n",strlen(String));
					ShowPlayerDialog(playerid,8423,DIALOG_STYLE_MSGBOX,"Обновление | Deadly Game v9.5",String,"Понятно","Выйти");
			    }
			}
		}
	    return 1;
	}

    if(dialogid == 3150)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
				     SetPlayerPos(playerid,-2396.8794,3012.7078,2.7469);
				     new playername[30];
				     new string[256];
				     GetPlayerName(playerid,playername,sizeof(playername));
				     format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Race Trek #1 Круг{B85FF3}( /racetrek )",playername,playerid);
				     SendClientMessageToAll(0xB85FF3AA, string);
				   	 SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Race Trek, удачной гонки :)");
				     SetPlayerInterior(playerid,0);
				     SetPlayerVirtualWorld(playerid,0);
				     SetTogglePlayerPos(playerid);
			    }
			    case 1:
			    {
				     SetPlayerPos(playerid,-1042.5651,2977.4043,39.8200);
				     new playername[30];
				     new string[256];
				     GetPlayerName(playerid,playername,sizeof(playername));
				     format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Race Trek #2 Водяной-Драг{B85FF3}( /racetrek )",playername,playerid);
				     SendClientMessageToAll(0xB85FF3AA, string);
				   	 SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Race Trek, удачной гонки :)");
				     SetPlayerInterior(playerid,0);
				     SetPlayerVirtualWorld(playerid,0);
				     SetTogglePlayerPos(playerid);
			    }
			}
		}
	    return 1;
	}

    if(dialogid == 3148)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
				    SetPlayerPos(playerid,1442.0283,-1704.4340,915.3906);
				    new playername[30];
				    new string[256];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Паркура #1 {B85FF3}( /parkour )",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Паркура #1 , давай пройди, если сможешь :)");
				    SetPlayerInterior(playerid,0);
				    SetPlayerVirtualWorld(playerid,0);
				    SetTogglePlayerPos(playerid);
			    }
			    case 1:
			    {
				     SetPlayerPos(playerid,2772.55004883,-2742.46484375,2460.37866211);
				     new playername[30];
				     new string[256];
				     GetPlayerName(playerid,playername,sizeof(playername));
				     format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Паркура #2 {B85FF3}( /parkour )",playername,playerid);
				     SendClientMessageToAll(0xB85FF3AA, string);
				   	 SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Паркура #2 , давай пройди, если сможешь :)");
				     SetPlayerInterior(playerid,0);
				     SetPlayerVirtualWorld(playerid,0);
				     SetTogglePlayerPos(playerid);
			    }
			    case 2:
			    {
				     SetPlayerPos(playerid,2099.9844,-1778.8767,274.6110);
				     new playername[30];
				     new string[256];
				     GetPlayerName(playerid,playername,sizeof(playername));
				     format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Паркура #3 {B85FF3}( /parkour )",playername,playerid);
				     SendClientMessageToAll(0xB85FF3AA, string);
				   	 SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Паркура #3 , давай пройди, если сможешь :)");
				     SetPlayerInterior(playerid,0);
				     SetPlayerVirtualWorld(playerid,0);
				     SetTogglePlayerPos(playerid);
			    }
			    case 3:
			    {
				     SetPlayerPos(playerid,-2929.7549,-1875.8765,7.4562);
				     new playername[30];
				     new string[256];
				     GetPlayerName(playerid,playername,sizeof(playername));
				     format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Паркура HARD #4 {B85FF3}( /parkour )",playername,playerid);
				     SendClientMessageToAll(0xB85FF3AA, string);
				   	 SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Паркура HARD #4 , давай пройди, если сможешь :)))");
				     SetPlayerInterior(playerid,0);
				     SetPlayerVirtualWorld(playerid,0);
				     SetTogglePlayerPos(playerid);
			    }
				case 4:
			    {
			         SetPlayerPos(playerid,-2439.281,1544.843,8.059);
				     new playername[30];
				     new string[256];
				     GetPlayerName(playerid,playername,sizeof(playername));
				     format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Паркура #5 {B85FF3}( /parkour )",playername,playerid);
				     SendClientMessageToAll(0xB85FF3AA, string);
				   	 SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Паркура #5 , тут нет финиша, так что просто попрыгай :)))");
				     SetPlayerInterior(playerid,0);
				     SetPlayerVirtualWorld(playerid,0);
				     SetTogglePlayerPos(playerid);
				}
			}
		}
	    return 1;
	}

    if(dialogid == 9376){
    if(response){
    switch(listitem){
    case 0:
    {
		new String[1000];// ELISIYM
		strins(String,"{FF0000}     _¶____________________.___\n",strlen(String));
		strins(String,"{FF3300}   /________\\___/_____________|]\n",strlen(String));
		strins(String,"{FF6600}  /__==O___________________/\n",strlen(String));
		strins(String,"{FF9900}   ), ---.(_\\(_) /\n",strlen(String));
		strins(String,"{FFCC00}  //_¤_), \n",strlen(String));
		strins(String,"{FFFF00} //_¤_//\n",strlen(String));
		strins(String,"{CCFF00}//_¤_//\n",strlen(String));
		strins(String,"\n",strlen(String));
		strins(String,"{FFFFFF}1.{05F5C6}Создатели ELISIYM : {F3FA0E}John_Vibers.\n",strlen(String));
		strins(String,"{FFFFFF}2.{05F5C6}Лидеры (в это время) : {F3FA0E}John_Vibers.\n",strlen(String));
		strins(String,"{FFFFFF}3.{05F5C6}Замы (в это время) : {F3FA0E}John_Vibers.\n",strlen(String));
		strins(String,"{FFFFFF}4.{05F5C6}Официальная группа ВК : {F3FA0E}скоро\n",strlen(String));
		strins(String,"{FFFFFF}5.{05F5C6}Сайт : {F3FA0E}-\n",strlen(String));
		strins(String,"{FFFFFF}6.{05F5C6}Набор : {F3FA0E}Открыт\n",strlen(String));
		strins(String,"{FFFFFF}7.{05F5C6}Личные команды Tm : {F3FA0E}/wartm , /wartmtp\n",strlen(String));
		strins(String,"{FFFFFF}8.{05F5C6}База : {F3FA0E}Есть\n",strlen(String));
		strins(String,"{FFFFFF}9.{05F5C6}GangZone : {F3FA0E}Есть {FF0000}Красная\n",strlen(String));
		strins(String,"{FF0000}ELISIYM production © 2020-2021.Все права защищены.\n",strlen(String));
		strins(String,"{FF0000}Последнее обновление этого окна {FFFFFF}20.10.2021г .\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Team {ff0000}ELISIYM™",String,"»]Понятно[«","»]Выход[«");
    }
    case 1:
    {
		new String[1000];
		strins(String,"{FF0000}     _¶____________________.___\n",strlen(String));
		strins(String,"{FF3300}   /________\\___/_____________|]\n",strlen(String));
		strins(String,"{FF6600}  /__==O___________________/\n",strlen(String));
		strins(String,"{FF9900}   ), ---.(_\\(_) /\n",strlen(String));
		strins(String,"{FFCC00}  //_¤_), \n",strlen(String));
		strins(String,"{FFFF00} //_¤_//\n",strlen(String));
		strins(String,"{CCFF00}//_¤_//\n",strlen(String));
		strins(String,"\n",strlen(String));
		strins(String,"{FFFFFF}1.{05F5C6}Создатели [Sunny]: {F3FA0E}[Sunny]_Frost , [Sunny]_Willie.\n",strlen(String));
		strins(String,"{FFFFFF}2.{05F5C6}Лидеры (в это время) : {F3FA0E}[Sunny]_Frost.\n",strlen(String));
		strins(String,"{FFFFFF}3.{05F5C6}Замы (в это время) : {F3FA0E}[Sunny]_Willie.\n",strlen(String));
		strins(String,"{FFFFFF}4.{05F5C6}Официальная группа ВК : {F3FA0E}-\n",strlen(String));
		strins(String,"{FFFFFF}5.{05F5C6}Сайт : {F3FA0E}-\n",strlen(String));
		strins(String,"{FFFFFF}6.{05F5C6}Набор : {F3FA0E}Открыт\n",strlen(String));
		strins(String,"{FFFFFF}7.{05F5C6}Личные команды клана : {F3FA0E}-\n",strlen(String));
		strins(String,"{FFFFFF}8.{05F5C6}База : {F3FA0E}Есть\n",strlen(String));
		strins(String,"{FFFFFF}9.{05F5C6}GangZone : {F3FA0E}-\n",strlen(String));
		strins(String,"{FF0000}[Sunny] production © 2014.Все права защищены.\n",strlen(String));
		strins(String,"{FF0000}Последнее обновление этого окна {FFFFFF}2.02.2014г .\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Клан {ff0000}[Sunny]™",String,"»]Понятно[«","»]Выход[«");
    }
    case 2:
    {
		new String[500];
		strins(String,"{ff0000}Это окно свободно!\n",strlen(String));
		strins(String,"{ff0000}Хочешь, чтобы тут был твой Клан/Тм?? Тогда заполни заявку в Топ Клан/Тм в телеграм :t.me/e_centersampchat\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Свободно",String,"Ok","Закрыть");
    }
    case 3:
    {
		new String[500];
		strins(String,"{ff0000}Это окно свободно!\n",strlen(String));
		strins(String,"{ff0000}Хочешь, чтобы тут был твой Клан/Тм?? Тогда заполни заявку в Топ Клан/Тм в телеграм :t.me/e_centersampchat\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Свободно",String,"Ok","Закрыть");
    }
	case 4:
    {
  		new String[500];
		strins(String,"{ff0000}Это окно свободно!\n",strlen(String));
		strins(String,"{ff0000}Хочешь, чтобы тут был твой Клан/Тм?? Тогда заполни заявку в Топ Клан/Тм в телеграм :t.me/e_centersampchat\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Свободно",String,"Ok","Закрыть");
	}
	case 5:
    {
  		new String[500];
		strins(String,"{ff0000}Для того, чтобы Ваш Клан/Тм оказался в Топ-5, Вам надо:!\n",strlen(String));
		strins(String,"{FFFFFF}1.{05F5C6}Количество участников Клана/Тм 7-10 игроков\n",strlen(String));
		strins(String,"{FFFFFF}2.{05F5C6}У лидера должно быть 1000-2000 фрагов (score)\n",strlen(String));
		strins(String,"{FFFFFF}3.{05F5C6}Клан/Тм должен быть нормальным, а не какими-то быдлами!\n",strlen(String));
		strins(String,"\n",strlen(String));
		strins(String,"{ff0000}Форма заявки в Топ:\n",strlen(String));
		strins(String,"{FFFFFF}1.{05F5C6}Создатели : ~ \n",strlen(String));
		strins(String,"{FFFFFF}2.{05F5C6}Лидеры : ~\n",strlen(String));
		strins(String,"{FFFFFF}3.{05F5C6}Замы : ~\n",strlen(String));
		strins(String,"{FFFFFF}4.{05F5C6}Официальная группа ВК : ~\n",strlen(String));
		strins(String,"{FFFFFF}5.{05F5C6}Сайт : ~\n",strlen(String));
		strins(String,"{FFFFFF}6.{05F5C6}Набор : ~\n",strlen(String));
		strins(String,"{ff0000}Заявку кидать в телеграм {FFFFFF}t.me/e_centersampchat\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"Инфо",String,"Ok","Закрыть");
	}}}
    return 1;}

    if(dialogid == 6257)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			        new String[1000];
			        strins(String,"{F7DC24}Админка - права Администрации\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{CB2FEC}                             Админка\n",strlen(String));
			        strins(String,"{CB2FEC}1 лвл - 40 руб (уровень Лидера)\n",strlen(String));
			        strins(String,"{CB2FEC}2 лвл - 80 руб (уровень Модератора) \n",strlen(String));
			        strins(String,"{CB2FEC}3 лвл - 100 руб (уровень Модератора)\n",strlen(String));
			        strins(String,"{CB2FEC}4 лвл - 120 руб (уровень Модератора)\n",strlen(String));
			        strins(String,"{CB2FEC}5 лвл - 150 руб (уровень Главного модератора)\n",strlen(String));
			        strins(String,"{CB2FEC}6 лвл - 200 руб (уровень Администратора)\n",strlen(String));
			        strins(String,"{CB2FEC}7 лвл - 250 руб (уровень Администратора)\n",strlen(String));
			        strins(String,"{CB2FEC}8 лвл - 300 руб (уровень VIP администратора)\n",strlen(String));
			        strins(String,"{CB2FEC}9 лвл - 400 руб (уровень VIP администратора)\n",strlen(String));
			        strins(String,"{CB2FEC}10 лвл - 500 руб (уровень Зам.гл Администратора)\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}Подробнее в телеграмм : t.me/e_centersamp\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}",String,"»]Понятно[«","");
			    }
			    case 1:
			    {
			        new String[1000];
			        strins(String,"{F7DC24}Score | Фраги - кол-во убийств; благодаря им, Ваша статитстика будет расти вверх, и уважение ;)\n",strlen(String));
			        strins(String,"{F7DC24}Возможности Score | Фраг : Достижение, Военная техника, Покупка оружия Alt, Создания своево телепорта и т.д\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{CB2FEC}                           Score | Фраги                                  \n",strlen(String));
			        strins(String,"{CB2FEC} * 10 фрагов = 3 руб | 1 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 50 фрагов = 15 руб | 5 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 100 фрагов = 30 руб | 10 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 500 фрагов = 120 руб | 40 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 1000 фрагов = 200 руб | 65 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 2000 фрагов = 350 руб | 110 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 5000 фрагов = 750 руб | 230 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 10000 фрагов = 1350 руб | 400 грн.\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}Подробнее в телеграмм : t.me/e_centersamp\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}Score | Фраги",String,"»]Понятно[«","");
			    }
			    case 2:
			    {
			        new String[1000];
			        strins(String,"{F7DC24}Деньги - это, возможно, самое важное у нас на сервере, без них Вы тут не выживите ;)\n",strlen(String));
			        strins(String,"{F7DC24}Нужны для : покупки дома, машин, оружия, еды, тюнинга, ну и т.д\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{CB2FEC}                             Деньги                                  \n",strlen(String));
			        strins(String,"{CB2FEC} * 1.000.000$ игровых денег = 15 руб | 5 грн..\n",strlen(String));
			        strins(String,"{CB2FEC} * 5.000.000$ игровых денег = 60 руб | 20 грн..\n",strlen(String));
			        strins(String,"{CB2FEC} * 10.000,.000$ игровых денег = 100 руб | 30 грн..\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}Подробнее в телеграмм : t.me/e_centersamp\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}Деньги",String,"»]Понятно[«","");
			    }
			    case 3:
			    {
			        new String[1000];
			        strins(String,"{F7DC24}Базы кланов/team - своя территория, забор и т.д ;)\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{CB2FEC}                           Базы                                  \n",strlen(String));
			        strins(String,"{CB2FEC} * Забор 1шт = 50 руб | 15 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Машина 1шт = 80 руб | 25 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Мото 1шт = 60 руб | 20 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Вертолет 1шт = 100 руб | 30 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Другой маппинг = обговаривается лично.\n",strlen(String));
			        strins(String,"{CB2FEC} * ГангЗона = 250 руб | 80 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * 3DText = 100 руб | 30 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Готовая база = 500 руб | 160 грн.\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}Подробнее в телеграмм : t.me/e_centersamp\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}Базы",String,"»]Понятно[«","");
			    }
			    case 4:
				{
			        new String[1000];
			        strins(String,"{F7DC24}Маппинг - Бары, Забор, и т.д ;)\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{CB2FEC}                           Базы                                  \n",strlen(String));
			        strins(String,"{CB2FEC} * Забор 1шт = 50 руб | 15 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Машина 1шт = 80 руб | 25 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Мото 1шт = 60 руб | 20 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Вертолет 1шт = 1шт = 100 руб | 30 грн.\n",strlen(String));
			        strins(String,"{CB2FEC} * Другой маппинг = обговаривается лично.\n",strlen(String));
			        strins(String,"{CB2FEC} * Готовый маппинг = 550 руб | 180 грн.\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}Подробнее в телеграмм : t.me/e_centersamp\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}Маппинг",String,"»]Понятно[«","");
			    }
			}
		}
	    return 1;
	}
    
    if(dialogid == 9375)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			        new String[4000];
			        strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {FF0000}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
			        strins(String,"{F7DC24}Игровой мод : {FF0000}Deadly Game v9.4\n",strlen(String));
			        strins(String,"{F7DC24}Официальный сайт сервера : {FF0000}t.me/e_centersamp\n",strlen(String));
			        strins(String,"{F7DC24}Официальная группа Телеграм : {FF0000}t.me/e_centersamp\n",strlen(String));
			        strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
			        strins(String,"{1CD8FF}Суть игры очень проста : Убивать ВСЕХ! Так как это ДМ сервер! ;D\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{1CD8FF}Вы можете :\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Купить себе дом в Los Santos'e!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Поездить по большим Stunt-зонам!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Провести мероприятие в барах , кафе , ресторанах!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Положить деньги в банк!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Получить деньги за работу: Курьер , Археолог , Водолаз , Дальнобойщик , Грузчик , Золотник!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Пополнить себе жизни в ларьках по всему SA!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Купить оружие в автоматах по всему SA!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Употребить наркотики на пляже Los Santos!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Поиграть в Мини-Игры , и получить приз!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Погонять на гоночных трассах!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Постреляться с разных оружий SA!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Пожениться и поцеловаться со своей второй половинкой!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Прокачать себе Level , чтобы имень лучше оружие и стиль боя!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Прикрепить к себе объекты для развлечения или снятия ролика!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Телепортируйтесь по новой системе телепортов!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Купить себе одноразовую машину!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Купить себе админский уровень [1 - 10 lvl]!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Заказать своему клану/team базу , спавн , и гангзону!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Поиграть в TDM режиме!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Подрифтовать на дрифт зонах!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Побегать по паркур зонам!\n",strlen(String));
			        strins(String,"{1CD8FF}-> {F7DC24}Ну и т.п вы узнаете, уже играя на нашем сервере :)\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}Обязательно прочитайте правила сервера! /help (Y) > Правила!\n",strlen(String));
			        strins(String,"{00FF00}Желаем вам приятной игры на нашем сервере! :)\n",strlen(String));
			        strins(String,"{00FF00}И не забывайте добавить наш сервер в избранные, наш IP : {FF0000}144.76.57.59:11781\n",strlen(String));
			        strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}FAQ Развлекательного Центра™",String,"»]Понятно[«","");
			    }
			    case 1:
			    {
			        new String[2000];
			        strins(String,"{FF0000}     _¶____________________._        \n",strlen(String));
			        strins(String,"{FF0000}   /________\\___/___________|]       \n",strlen(String));
			        strins(String,"{FF0000}  /__==O__________________/              \n",strlen(String));
			        strins(String,"{FF0000}   ), ---.(_\\(_) /                                \n",strlen(String));
			        strins(String,"{FF0000}  //_¤_),                                                   \n",strlen(String));
			        strins(String,"{FF0000} //_¤_//                                                      \n",strlen(String));
			        strins(String,"{FF0000}//_¤_//                                                        \n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FFFFFF}1.{FF0000}Не убивайте игроков из своей команды (Team kill) (кик/тюрьма).\n",strlen(String));
			        strins(String,"{FFFFFF}2.{FF0000}Не используйте Drive By(стрельба с водительского места транспорта) (кик/тюрьма).\n",strlen(String));
			        strins(String,"{FFFFFF}3.{FF0000}Не используйте всевозможные читы и хаки (кик/бан).\n",strlen(String));
			        strins(String,"{FFFFFF}4.{FF0000}Не флудите\n",strlen(String));
			        strins(String,"{FFFFFF}5.{FF0000}Не используйте баг * +с * (кик/тюрьма)\n",strlen(String));
			        strins(String,"{FFFFFF}6.{FF0000}Уважайте всех игроков и, тем более, администрацию\n",strlen(String));
			        strins(String,"{FFFFFF}7.{FF0000}Не мешайте проводить всяческие мероприятия (кик/тюрьма).\n",strlen(String));
			        strins(String,"{FFFFFF}8.{FF0000}Не мешайте работать другим игрокам (кик/тюрьма).\n",strlen(String));
			        strins(String,"{FFFFFF}9.{FF0000}Не убивать игроков на спавне (spawn kill) (кик/тюрьма)\n",strlen(String));
			        strins(String,"{FFFFFF}10.{FF0000}За нарушение правил, администратор может кикнуть или забанить Вас без предупреждения\n",strlen(String));
			        strins(String,"{FFFFFF}P.S.{FF0000}Жалобы на Читы/Нарушения сервера в чате не рассматриваются ( /report )!\n",strlen(String));
			        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Правила {ff0000}Развлекательного Центра™",String,"»]Понятно[«","");
			    }
			    case 2:OnPlayerCommandText(playerid,"/arules");//правила для администрации
			    case 3:
			    {
			        new String[1000];
			        strins(String,"{5959FF}Команды {FFFFFF}| {FFFF00}Развлекательного Центра™\r\n",strlen(String));
			        strins(String,"{5959FF}Команды {FFFFFF}| {FFFF00}Администрации сервера\r\n",strlen(String));
			        strins(String,"{5959FF}Команды {FFFFFF}| {FFFF00}ViP Игрока\r\n",strlen(String));
			        strins(String,"{5959FF}Команды {FFFFFF}| {FFFF00}SA-MP 0.3.7\r\n",strlen(String));
			        ShowPlayerDialog(playerid,5345,DIALOG_STYLE_LIST,"{FFFF00}Команды | Commands",String,"»]Читать[«","»]Отмена[«");
			    }
			    case 4:ShowPlayerDialog(playerid, 6257, DIALOG_STYLE_LIST, "{DFDF02}Платные услуги сервера", "{B3FF00}Админка\n{E6FF00}Score | Фраги\n{FFEA00}Деньги\n{FFEA00}Базы кланов/team\n{FFBF00}Маппинг возле дома!","»]Выбрать[«", "»]Назад[«");
			    case 5:ShowPlayerDialog(playerid, 9376, DIALOG_STYLE_LIST, "{00FFC8}Top-5 Кланов/Тм Р-Ц!", "1. {FF0000}ELISIYM\n2. {FF0000}[Sunny]\n3. {8474DC}Свободно\n4. {8474DC}Свободно\n5. {8474DC}Свободно\n{FF8080}**Заявка в Топ-5 Кланов/Тм Р-Ц**","»]Выбор[«","»]Выход[«");
			    case 6:
			    {
				    new String[500];
				    strins(String,"{FF0000}Название Сервера: ¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\n",strlen(String));
				    strins(String,"{FF3300}IP Адрес Сервера: 144.76.57.59:11781\n",strlen(String));
				    strins(String,"{FF6600}Количество Слотов: ~ / 80\n",strlen(String));
				    strins(String,"{FF9900}Название Мода: Deadly Game™ v9.4\n",strlen(String));
				    strins(String,"{FFCC00}Карта Сервера: •Russia:Dm+Fun+Stunt+RP+RPG•\n",strlen(String));
				    strins(String,"{FFFF00}Клиент Сервера: 0.3.7\n",strlen(String));
				    strins(String,"{CCFF00}Группа Телеграм:t.me/e_centersamp\n",strlen(String));
				    strins(String,"{8CFF00}Сайт Сервера: t.me/e_centersampchat\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF11}Инфо о Сервере",String,"»]Ок[«","");
			    }
			    case 7:
			    {
			       	new String[2000];
			       	strins(String,"{0088FF}У нас на сервере много территорий , и всё(кроме Stunt Zone) принадлежит каждому gTeam!\n",strlen(String));
			       	strins(String,"{0088FF}Чтобы зайти за gTeam , необходимо при входе на сервер листать скины в лево!\n",strlen(String));
			       	strins(String,"\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {0000FF}[|||||] {0088FF}- Полиция [Los Santos & Las Venturas & Sfn Fierro]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {FFFFFF}[|||||] {0088FF}- Триады [Las Venturas]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {00FFFF}[|||||] {0088FF}- Aztec [Los Santos]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {0080FF}[|||||] {0088FF}- Rifa [San Fierro]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {FFFF00}[|||||] {0088FF}- Vagos [Los Santos]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {00FF00}[|||||] {0088FF}- Groove [Los Santos]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {BF00BF}[|||||] {0088FF}- Ballas [Los Santos]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {B8860B}[|||||] {0088FF}- Криминалы [Las Venturas]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {804040}[|||||] {0088FF}- Army [Las Venturas]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {F0E68C}[|||||] {0088FF}- Данаги [San Fierro]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {FF8080}[|||||] {0088FF}- Stunt Zone [San Andreas]\n",strlen(String));
			       	strins(String,"{0088FF}Цвет {FF0000}[|||||] {0088FF}- ELISIYM [Los Santos]\n",strlen(String));
			       	ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF11}Информация о GangZone",String,"»]Понятно[«","");
			    }
			    case 8:
			    {
			       	new String[4000];
			   	   	strins(String,"    {40FF00}[Rang]\t\t\t[Level]\t\t[Score]\t\t\t[F.Style]\n",strlen(String));
			       	strins(String,"\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Новичок [«\t\t\t1\t\t0 - 10\t\t\tNORMAL\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Рядовой [«\t\t\t2\t\t10 - 50\t\t\tNORMAL\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Ефрейтор [«\t\t\t3\t\t50 - 100\t\t\tNORMAL\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Младший сержант [«\t\t4\t\t100 - 200\t\tBOXING\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Сержант [«\t\t\t5\t\t200 - 350\t\tBOXING\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Старший сержант [«\t\t6\t\t350 - 500\t\tBOXING\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Старшина [«\t\t\t7\t\t500 - 750\t\tBOXING\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Прапорщик [«\t\t8\t\t750 - 1000\t\tBOXING\n",strlen(String));
			   	   	strins(String,"{40FF00}»] Старший прапорщик [«\t9\t\t1000 - 1350\t\tKUNGFU\n",strlen(String));
				   	strins(String,"{40FF00}»] Младший лейтенант [«\t10\t\t1350 - 1800\t\tKUNGFU\n",strlen(String));
				   	strins(String,"{40FF00}»] Лейтенант [«\t\t\t11\t\t1800 - 2600\t\tKUNGFU\n",strlen(String));
				    strins(String,"{40FF00}»] Старший лейтенант [«\t12\t\t2600 - 3500\t\tGRABKICK\n",strlen(String));
				   	strins(String,"{40FF00}»] Капитан [«\t\t\t13\t\t3500 - 5000\t\tGRABKICK\n",strlen(String));
				   	strins(String,"{40FF00}»] Майор [«\t\t\t14\t\t5000 - 6000\t\tSTREETBLOW\n",strlen(String));
				   	strins(String,"{40FF00}»] Подполковник [«\t\t15\t\t6000 - 8000\t\tSTREETBLOW\n",strlen(String));
				   	strins(String,"{40FF00}»] Полковник [«\t\t\t16\t\t8000 - 9500\t\tSTREETBLOW\n",strlen(String));
				    strins(String,"{40FF00}»] Генерал-майор [«\t\t17\t\t9500 - 11000\t\tSTREETBLOW\n",strlen(String));
				   	strins(String,"{40FF00}»] Генерал-лейтенант [«\t\t18\t\t11000 - 15000\t\tMiXCENI\n",strlen(String));
				   	strins(String,"{40FF00}»] Генерал-полковник [«\t19\t\t15000 - 20000\t\tMiXCENI\n",strlen(String));
				   	strins(String,"{40FF00}»] Генерал Р-Ц [«\t\t20\t\t20000- ~\t\tMiXCENI\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF11}Ранги Развлекательного Центра™",String,"»]Понятно[«","");
			    }
			    case 9:
			    {
				    new String[4000];
				    strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {FF0000}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
				    strins(String,"{3DF12E}На данный момент у нас существуют 6 работ!\n",strlen(String));
			   	 	strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
				    strins(String,"{2742F8}1) {3DF12E}Работа Дальнобойщик , всё очень просто , вам придётся довезти товар куда вам покажут на радаре (красный маркер)!\n",strlen(String));
				    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/дальнобойщик (и дальше всё будет понятно)\n",strlen(String));
			    	strins(String,"{3DF12E}Заработная плата зависит от вас! примерно от {EB9434}10000$ {3DF12E}до {EB9434}25000$\n",strlen(String));
				    strins(String,"\n",strlen(String));
			    	strins(String,"{2742F8}2) {3DF12E}Работа Археолог , тут тоже нет нечего сложного , вам придется ездить по местности, чтобы найти разные вещи!\n",strlen(String));
				    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/археолог\n",strlen(String));
				    strins(String,"{3DF12E}Заработная плата : {EB9434}7000$\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{2742F8}3) {3DF12E}Работа Курьера , вам придется ездить по красным меткам , и достовлять груз!\n",strlen(String));
				    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/job\n",strlen(String));
				    strins(String,"{3DF12E}Заработная плата за одну метку : {EB9434}200$\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{2742F8}4) {3DF12E}Работа Водолаз, очень интересная работа , вам придется нырять и достовать сокровища!\n",strlen(String));
				    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/водолаз\n",strlen(String));
				    strins(String,"{3DF12E}Заработная плата : {EB9434}5000$\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{2742F8}5) {3DF12E}Работа Грузчика , ваша задача таскать мешки из вагона!\n",strlen(String));
				    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/gruz (и дальше подойдите к пикапу информация)\n",strlen(String));
				    strins(String,"{3DF12E}Заработная плата за один мешок : {EB9434}1000$\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{2742F8}6) {3DF12E}Работа Золотника , вы должны добывать золото и ложить в фургон!\n",strlen(String));
				    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/золотник\n",strlen(String));
				    strins(String,"{3DF12E}Заработная плата : {EB9434}2500$\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{3DF12E}Такими способами вы можете заработать деньги!\n",strlen(String));
				    strins(String,"{FF0000}ДМ на работе НАКАЗУЕТСЯ тюрьмой!\n",strlen(String));
				    strins(String,"{FF0000}Если вам мешаю на работе сообщите админам! /report\n",strlen(String));
				    strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{3CFF00}Работы Развлекательного Центра™",String,"»]Понятно[«","");
				}
			    case 10:ShowPlayerDialog(playerid, 3149, DIALOG_STYLE_LIST, "{3CFF00}Новости Развлекательного Центра™","{8D8D8D}Обновление!{8D8D8D}[3.02.2014]\n{8D8D8D}Обновление!{8D8D8D}[07.02.2014]\n{FFFF00}Обновление!{FF0000}[13.09.2017]","»]Выбор[«","»]Выход[«");
			    case 11:
			    {
				    new String[4000];
				    strins(String,"{43F529}Приветствую Вас на хорошем моде {FF0D0D}Deadly Game v9.4 ( SA:DM+TDM+Stunt+Drift+Fun+Rp ){43F529}!\n",strlen(String));
				    strins(String,"{43F529}Основа мода : Classic!\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{B368EA}1) {41BEF3}Новейшая Level система (20 уровней , с каждым уровнем всё лучше и лучше оружие , и стили боя!);\n",strlen(String));
				    strins(String,"{B368EA}2) {41BEF3}Самая новейшая система телепортов!\n",strlen(String));
				    strins(String,"{B368EA}3) {41BEF3}Вы можете прикрепить множесто объектов к себе! С каждым обновлением мода добавляются или заменяются объекты на новые!\n",strlen(String));
				    strins(String,"{B368EA}4) {41BEF3}Самые новейшие Stunt зоны по SA!\n",strlen(String));
				    strins(String,"{B368EA}5) {41BEF3}Автоматы с оружиями по всему SA!\n",strlen(String));
				    strins(String,"{B368EA}6) {41BEF3}Ларьки с едой (+100хп) по всему SA!\n",strlen(String));
				    strins(String,"{B368EA}7) {41BEF3}Множество интересных мест сервера!(Пляжи , острова и т.д)!\n",strlen(String));
				    strins(String,"{B368EA}8) {41BEF3}Множество заведений сервера!(Бары , рестораны , кафе и т.д)!\n",strlen(String));
				    strins(String,"{B368EA}9) {41BEF3}У нас можно жениться и целоваться (С кем поженились, Вы можете посмотреть у себя в инфе , и сколько раз поцеловались)!\n",strlen(String));
				    strins(String,"{B368EA}10) {41BEF3}Личное меню на Alt (Радио , Работы , Телепорты , Настройки аккаунта и т.д)\n",strlen(String));
				    strins(String,"{B368EA}11) {41BEF3}У нас есть 5 работ (Грузчик , Археолог , Водолаз , Курьер , Дальнобойщик ,Золотник)!\n",strlen(String));
				    strins(String,"{B368EA}12) {41BEF3}Также есть нарколарёк на пляже Los Santos!\n",strlen(String));
				    strins(String,"{B368EA}13) {41BEF3}Информационные MapIcon по всему SA!\n",strlen(String));
				    strins(String,"{B368EA}14) {41BEF3}Всю информацию о сервере вы можете посмотреть нажав 'Y' или ввести '/help'\n",strlen(String));
				    strins(String,"{B368EA}15) {41BEF3}Есть ускорители на дорогах, благодаря которым Вы можете ускориться! И сальто авто, благодаря которому ваш автомобиль делает сальто!\n",strlen(String));
				    strins(String,"{B368EA}16) {41BEF3}Новейшие Gang Zone по всему SA!\n",strlen(String));
				    strins(String,"{B368EA}17) {41BEF3}Множество gTeam (TDM)!(Groove , Ballas , Aztec , Vagos , COP (LS,LV,SF) , Army , Triada и т.д)!\n",strlen(String));
				    strins(String,"{B368EA}18) {41BEF3}Система покупки оружия!\n",strlen(String));
				    strins(String,"{B368EA}19) {41BEF3}Система покупки одноразового транспорта!!\n",strlen(String));
				    strins(String,"{B368EA}20) {41BEF3}Вы можете принять наркотики на пляже Los Santos'a!!\n",strlen(String));
				    strins(String,"{B368EA}21) {41BEF3}Система 'Банк'!!\n",strlen(String));
				    strins(String,"{B368EA}22) {41BEF3}Множесто домов по Los Santos'y , которые вы можете приобрести!!\n",strlen(String));
				    strins(String,"{B368EA}23) {41BEF3}Система сохранения скинов /skininfo!!\n",strlen(String));
				    strins(String,"{B368EA}24) {41BEF3}Система сохранения своих позиций!!\n",strlen(String));
				    strins(String,"{B368EA}*** Ну и т.д :) Больше Вы можете увидеть, уже играя на сервере!\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{3E46E1}Автор мода : {FF0000}John_Vibers\n",strlen(String));
				    ShowPlayerDialog(playerid,9994,DIALOG_STYLE_MSGBOX,"{03ff00}Информация мода", String, "»]Понятно[«", "");
			    }
			    case 12:
			    {
					new String[1500];
					strins(String,"{B702F2}======================================================================\n",strlen(String));
					strins(String,"{B702F2}                                   <----------------< Скриптер\n",strlen(String));
					strins(String,"{B702F2}John_Vibers      <-------------------< Мапер\n",strlen(String));
					strins(String,"{B702F2}                        <---------------< Обновление\n",strlen(String));
					strins(String,"{B702F2}                                  <--------< Cоздатель Deadly Game v9.4\n",strlen(String));
					strins(String,"{B702F2}======================================================================\n",strlen(String));
			        strins(String,"{B702F2}                                <-----< Создатель сервера\n",strlen(String));
			        strins(String,"{B702F2}John_Marston          <----------< Редактор мода\n",strlen(String));
			        strins(String,"{B702F2}                     <-----------------< Хостинг\n",strlen(String));
			        strins(String,"{B702F2}                                <-------------------< Группа [Т]елеграм\n",strlen(String));
			        strins(String,"{B702F2}                              <-------------< По всем вопросам\n",strlen(String));
					strins(String,"{B702F2}=======================================================================\n",strlen(String));
					ShowPlayerDialog(playerid,9995,DIALOG_STYLE_MSGBOX,"{03ff00}Создатели Развлекательного Центра™", String, "»]Ок[«","");
			    }
			    case 13:
			    {
				    new String[1000];
				    strins(String,"{B702F2}============================================================================\n",strlen(String));
				    strins(String,"{FFFF00}Группа [Т]елеграмм : {FF0000}t.me/e_centersamp\n",strlen(String));
				    strins(String,"{FFFF00}Сайт проекта Развлекательного Центра™ : {FF0000}t.me/e_centersampchat\n",strlen(String));
				    strins(String,"{B702F2}============================================================================\n",strlen(String));
				    strins(String,"{FFFF00}John_Vibers {FF0000}> t.me/e_centersampchat\n",strlen(String));
				    strins(String,"{FFFF00}John_Marston {FF0000}> t.me/e_centersampchat\n",strlen(String));
				    strins(String,"{B702F2}============================================================================\n",strlen(String));
				    ShowPlayerDialog(playerid,9996,DIALOG_STYLE_MSGBOX,"{03ff00}Связь Развлекательного Центра™", String, "»]Понятно[«", "");
			    }
			}
		}
	    return 1;
	}

    if(dialogid == 5345)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:OnPlayerCommandText(playerid,"/commands");
			    case 1:OnPlayerCommandText(playerid,"/acmd");
			    case 2:
			    {
				    if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, red, "{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
				    new String[1024];
				    strins(String,"{FF0000}ViP:\n",strlen(String));
				    strins(String,"{EFF600}/vsay - {33FF00}написать в чат от ViP!\n",strlen(String));
				    strins(String,"{EFF600}/vdoska - {33FF00}Доска под ноги!\n",strlen(String));
				    strins(String,"{EFF600}/vrepair - {33FF00}Починить машину!\n",strlen(String));
				    strins(String,"{EFF600}/vcolors - {33FF00}Моргающий ник ViP!\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{FF0000}Gold ViP:\n",strlen(String));
				    strins(String,"{EFF600}/vhealall - {33FF00}Выличить всех\n",strlen(String));
				    strins(String,"{EFF600}/varmourall - {33FF00}Выдать всем броню!\n",strlen(String));
				    strins(String,"{EFF600}/vslap - {33FF00}пнуть игрока!\n",strlen(String));
				    strins(String,"{EFF600}/vkick - {33FF00}кикнуть!\n",strlen(String));
				    strins(String,"{EFF600}/vclearchat - {33FF00}очистить чат!\n",strlen(String));
				    strins(String,"{FFFFFF}*** Учитывая команды ViP\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"{FF0000}Diamond ViP:\n",strlen(String));
				    strins(String,"{EFF600}/vmute - {33FF00}заткнуть!\n",strlen(String));
				    strins(String,"{EFF600}/vunmute - {33FF00}разоткнуть!\n",strlen(String));
				    strins(String,"{EFF600}/vban - {33FF00}забанить!\n",strlen(String));
				    strins(String,"{FFFFFF}*** Учитывая команды ViP & Gold ViP\n",strlen(String));
					ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Команда ViP's",String,"»]Ok[«","»]Выход[«");
			    }
			    case 3:
			    {
				    new String[1024];
				    strins(String,"{FA29D0}/pagesize 10-20 : {ccff00}Изменить кол-во строк чата\n",strlen(String));
				    strins(String,"{FA29D0}/fpslimit 20-100 : {ccff00}Установить FPS лимит (кол-во кадров в секунду)\n",strlen(String));
				    strins(String,"{FA29D0}/timestamp : {ccff00}Время каждого сообщения в чате\n",strlen(String));
				    strins(String,"{FA29D0}/headmove : {ccff00}Включает/Выключает поворот голові по направлению камеры\n",strlen(String));
				    strins(String,"{FA29D0}/interior : {ccff00}Показать ИД интерьера, в котором вы находитесь\n",strlen(String));
				    strins(String,"{FA29D0}/mem : {ccff00}Отображает сколько использует памяти SA-MP\n",strlen(String));
				    strins(String,"{FA29D0}/save : {ccff00}Сохранить позицию игрока/транспорта в savedpositions.txt\n",strlen(String));
				    strins(String,"{FA29D0}/rs : {ccff00}Сохраняет ваши координаты в rawposition.txt\n",strlen(String));
				    strins(String,"{FA29D0}/dl : {ccff00}Показывает здоровье транспорта , его координаты\n",strlen(String));
				    strins(String,"{FA29D0}/q : {ccff00}Выход из Игры\n",strlen(String));
					ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Стандартные команды SA-MP",String,"»]Ok[«","»]Выход[«");
			    }
			}
		}
	    return 1;
	}


    if(dialogid == 2727){
    if(response == 1){
    switch(listitem) {
    case 0:  ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Обычную..");
    case 1:  ApplyAnimation(playerid,"PED","WALK_civi",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Гражданскую..");
    case 2:  ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Гангстерскую 1..");
    case 3:  ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Гангстерскую 2..");
    case 4:  ApplyAnimation(playerid,"PED","WALK_old",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Старика..");
    case 5:  ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Старухи..");
    case 6:  ApplyAnimation(playerid,"PED","WALK_fat",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Женскую 1..");
    case 7:  ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Женскую 2..");
    case 8:  ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Шлюху 1..");
    case 9:  ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Шлюху 2..");
    case 10: ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Шлюху 3..");
    case 11: ApplyAnimation(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Пьяного..");
    case 12: ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1)
            ,SendClientMessage(playerid, 0xAFAFAFAA, "{FF0000}* {8b00ff}Вы изменили свой стиль походки на Слепого..");
            }
            }
            else // Возврощение в меню
            {
        new String[2048];
        strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
        strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
        strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
        strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
        strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
        strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
        strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
        strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
        strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
        strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
        strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
        strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
        strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
        strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
        strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
        strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
        strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
        strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
        strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
        ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
    }
}

    if(dialogid == 5189)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Солнечная",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(5);
			    }
			    case 1:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Песчаный шторм",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(19);
			    }
			    case 2:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Гроза",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(8);
			    }
			    case 3:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Туман",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(20);
			    }
			    case 4:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Облачная",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(9);
			    }
			    case 5:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Сильный дождь",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(16);
			    }
			    case 6:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Партуровое небо",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(45);
			    }
			    case 7:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Черно-белое небо",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(44);
			    }
			    case 8:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Темно-зеленое небо",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(22);
			    }
			    case 9:
			    {
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}сменил погоду - {FF0000}Жара",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
					SetWeather(11);
			    }
			}
		}
	    return 1;
	}

    if(dialogid == 57)
	{
    	if(response)
		{
		 	StopAudioStreamForPlayer(playerid);
	 	}
   		return true;
	}
	
   	if(dialogid == 5191 && response)
	switch (listitem)
	{
		case 0: OnPlayerCommandText(playerid,"/skexit");
		case 1: OnPlayerCommandText(playerid,"/skexithard");
	    case 2: OnPlayerCommandText(playerid,"/adminhouse");
	}

   	if(dialogid == 5190 && response)
	switch (listitem)
	{
		case 0: OnPlayerCommandText(playerid,"/giveallweapon 24 99999999");
		case 1: OnPlayerCommandText(playerid,"/giveallweapon 31 99999999");
	    case 2: OnPlayerCommandText(playerid,"/giveallweapon 28 99999999");
		case 3: OnPlayerCommandText(playerid,"/giveallweapon 26 99999999");
	    case 4: OnPlayerCommandText(playerid,"/giveallweapon 35 99999999");
	}

	if(dialogid == 5181)
	{
		if(response == 1)
		{
			if(listitem == 0)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AntiSwear] = 1;
			    dini_IntSet(file,"AntiSwear",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}АнтиМат", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 1)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[NameKick] = 1;
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}КикНика", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 2)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AntiSpam] = 1;
			    dini_IntSet(file,"AntiSpam",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}АнтиСпам", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 3)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[MaxPing] = 800;
			    dini_IntSet(file,"MaxPing",800);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}ПингКик", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 4)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[ReadCmds] = 1;
			    dini_IntSet(file,"ReadCMDs",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}Читать команды", PlayerName2(playerid));
			    MessageToAdmins(blue,string);
			}
			if(listitem == 5)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[ReadPMs] = 1;
			    dini_IntSet(file,"ReadPMs",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}Читать приваты", PlayerName2(playerid));
			    MessageToAdmins(blue,string);
			}
			if(listitem == 6)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[NoCaps] = 0;
			    dini_IntSet(file,"NoCaps",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}Анти Caps Lock", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 7)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AdminCmdMsg] = 1;
			    dini_IntSet(file,"AdminCmdMessages",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}Читать Админ команды", PlayerName2(playerid));
			    MessageToAdmins(green,string);
			}
			if(listitem == 8)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[ConnectMessages] = 1;
			    dini_IntSet(file,"ConnectMessages",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}Читать коннект и дисконнект сообщения", PlayerName2(playerid));
			    MessageToAdmins(green,string);
			}
			if(listitem == 9)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AutoLogin] = 1;
			    dini_IntSet(file,"AutoLogin",1);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {00FF40}%s {8b00ff}включил - {00FF40}Автологин", PlayerName2(playerid));
			    MessageToAdmins(green,string);
			}
			if(listitem == 10)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AntiSwear] = 0;
			    dini_IntSet(file,"AntiSwear",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}АнтиМат", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 11)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[NameKick] = 0;
			    dini_IntSet(file,"NameKick",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}КикНика", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 12)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AntiSpam] = 0;
			    dini_IntSet(file,"AntiSpam",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}АнтиСпам", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 13)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[MaxPing] = 0;
			    dini_IntSet(file,"MaxPing",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}ПингКик", PlayerName2(playerid));
			    SendClientMessageToAll(blue,string);
			}
			if(listitem == 14)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[ReadCmds] = 0;
			    dini_IntSet(file,"ReadCMDs",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}Читать команды", PlayerName2(playerid));
			    MessageToAdmins(blue,string);
			}
			if(listitem == 15)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[ReadPMs] = 0;
			    dini_IntSet(file,"ReadPMs",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}Читать приваты", PlayerName2(playerid));
			    MessageToAdmins(blue,string);
			}
			if(listitem == 16)
			{
		    	new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		    	ServerInfo[NoCaps] = 0;
		    	dini_IntSet(file,"NoCaps",0);
		    	format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}Анти Caps Lock", PlayerName2(playerid));
		    	SendClientMessageToAll(blue,string);
			}
			if(listitem == 17)
			{
		    	new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		    	ServerInfo[AdminCmdMsg] = 0;
		    	dini_IntSet(file,"AdminCmdMessages",0);
		    	format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}Читать Админ команды", PlayerName2(playerid));
		    	MessageToAdmins(green,string);
			}
			if(listitem == 18)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[ConnectMessages] = 0;
			    dini_IntSet(file,"ConnectMessages",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}Читать коннект и дисконнект сообщения", PlayerName2(playerid));
			    MessageToAdmins(green,string);
			}
			if(listitem == 19)
			{
			    new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
			    ServerInfo[AutoLogin] = 0;
			    dini_IntSet(file,"AutoLogin",0);
			    format(string,sizeof(string),"{00F200}*** {8b00ff}Создатель {FF0000}%s {8b00ff}выключил - {FF0000}Автологин", PlayerName2(playerid));
				MessageToAdmins(green,string);
			}
		}
	}

    if(dialogid == 5188)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			    	if(PlayerInfo[playerid][Level] < 12) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
			    	new String[2000];
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Антимат\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Кик ника\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Анти спам\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Пинг кик\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Читать команды\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Читать приваты\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Анти Caps Lock\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Читать админ команды\r\n",strlen(String));
					strins(String,"{00FF40}[Включить]: {FFFF00}Читать коннект и дисконнект сообщения\r\n",strlen(String));
			    	strins(String,"{00FF40}[Включить]: {FFFF00}Автологин\r\n",strlen(String));
			    	strins(String,"{FF0000}[Выключить]: {FFFF00}Антимат\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Кик ника\r\n",strlen(String));
			    	strins(String,"{FF0000}[Выключить]: {FFFF00}Анти спам\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Пинг кик\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Читать команды\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Читать приваты\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Анти Caps Lock\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Читать админ команды\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Читать коннект и дисконнект сообщения\r\n",strlen(String));
				    strins(String,"{FF0000}[Выключить]: {FFFF00}Автологин\r\n",strlen(String));
				    ShowPlayerDialog(playerid,5181,DIALOG_STYLE_LIST,"{FF0000}Включение | Выключение!",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 1:OnPlayerCommandText(playerid,"/healall");
			    case 2:OnPlayerCommandText(playerid,"/armourall");
			    case 3:OnPlayerCommandText(playerid,"/cc");
			    case 4:
			    {
				    if(PlayerInfo[playerid][Level] < 7) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор 7 уровня {FF0000}Развлекательного Центра™{0AD383}!");
				    new String[1000];
				    strins(String,"{8b00ff}Солнечная!\r\n",strlen(String));
				    strins(String,"{8b00ff}Песчаный шторм!\r\n",strlen(String));
				    strins(String,"{8b00ff}Гроза!\r\n",strlen(String));
				    strins(String,"{8b00ff}Туман!\r\n",strlen(String));
				    strins(String,"{8b00ff}Облачная!\r\n",strlen(String));
				    strins(String,"{8b00ff}Сильный дождь!\r\n",strlen(String));
					strins(String,"{8b00ff}Партуровое небо!\r\n",strlen(String));
				    strins(String,"{8b00ff}Черно-белое небо!\r\n",strlen(String));
				    strins(String,"{8b00ff}Темно-зеленое небо!\r\n",strlen(String));
				    strins(String,"{8b00ff}Жара!\r\n",strlen(String));
				    ShowPlayerDialog(playerid,5189,DIALOG_STYLE_LIST,"{FF0000}Сменить погоду!",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 5:
			    {
				    if(PlayerInfo[playerid][Level] < 11) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор 11 уровня {FF0000}Развлекательного Центра™{0AD383}!");
				    new String[500];
				    strins(String,"{8b00ff}Дать всем Deagle - 500 патрон!\r\n",strlen(String));
				    strins(String,"{8b00ff}Дать всем M4 - 500 патрон!\r\n",strlen(String));
				    strins(String,"{8b00ff}Дать всем UZI - 500 патрон!\r\n",strlen(String));
				    strins(String,"{8b00ff}Дать всем Sawn - 500 патрон!\r\n",strlen(String));
				    strins(String,"{8b00ff}Дать всем RPG - 500 патрон!\r\n",strlen(String));
				    ShowPlayerDialog(playerid,5190,DIALOG_STYLE_LIST,"{FF0000}Выдать оружие!",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 6:
			    {
			    	new String[500];
			    	strins(String,"{8b00ff}Конец Skydive!\r\n",strlen(String));
			    	strins(String,"{8b00ff}Конец Skydive HARD!\r\n",strlen(String));
				    strins(String,"{8b00ff}Сбор Админов!\r\n",strlen(String));
				    ShowPlayerDialog(playerid,5191,DIALOG_STYLE_LIST,"{FF0000}Выдать оружие!",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 7:
			    {
				    if(PlayerInfo[playerid][Level] < 8) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор 8 уровня {FF0000}Развлекательного Центра™{0AD383}!");
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s(%d) {8b00ff}накормил всех наркотиками!",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SetWeather(-66);
				}
			    case 8:OnPlayerCommandText(playerid,"/lbike");
			    case 9:OnPlayerCommandText(playerid,"/lcar");
			    case 10:OnPlayerCommandText(playerid,"/lrest");
			    case 11:OnPlayerCommandText(playerid,"/scars");
			    case 12:OnPlayerCommandText(playerid,"/jetpack");
			    case 13:OnPlayerCommandText(playerid,"/reports");
			    case 14:OnPlayerCommandText(playerid,"/god");
				}
			}
	    return 1;
	}

    if(dialogid == 3147)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
				    SetPlayerPos(playerid,-302.7817,1522.0492,75.3594);
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Дрифта #1 {B85FF3}( /drift )",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Дрифта #1!");
				    SetPlayerInterior(playerid,0);
				    SetPlayerVirtualWorld(playerid,0);
				    SetTogglePlayerPos(playerid);
			    }
			    case 1:
			    {
					SetPlayerPos(playerid,-2372.7214,-589.3887,132.1172);
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Дрифта #2 {B85FF3}( /drift )",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Дрифта #2!");
				    SetPlayerInterior(playerid,0);
				    SetPlayerVirtualWorld(playerid,0);
				    SetTogglePlayerPos(playerid);
			    }
			    case 2:
			    {
					SetPlayerPos(playerid,2245.4031,1957.0907,32.0078);
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Дрифта #3 {B85FF3}( /drift )",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Дрифта #3!");
				    SetPlayerInterior(playerid,0);
				    SetPlayerVirtualWorld(playerid,0);
				    SetTogglePlayerPos(playerid);
			    }
			    case 3:
			    {
				    SetPlayerPos(playerid,3087.1345,-3194.6936,47.6537);
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Дрифта #4 {B85FF3}( /drift )",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Дрифта #4!");
				    SetPlayerInterior(playerid,0);
				    SetPlayerVirtualWorld(playerid,0);
				    SetTogglePlayerPos(playerid);
			    }
			    case 4:
			    {
				    SetPlayerPos(playerid,942.8232,1498.8528,175.5703);
				    new playername[30];
				    new string[128];
				    GetPlayerName(playerid,playername,sizeof(playername));
				    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на зону Дрифта #5 NARD {B85FF3}( /drift )",playername,playerid);
				    SendClientMessageToAll(0xB85FF3AA, string);
				    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Телепорты] {20FFFF}Добро пожаловать на Зону Дрифта #5 HARD , ну давай покажи мастер класс ;D");
				    SetPlayerInterior(playerid,0);
				    SetPlayerVirtualWorld(playerid,0);
				    SetTogglePlayerPos(playerid);
				}
			}
		}
	    return 1;
	}

    if(dialogid == 3656)
	{
	    if(response)
		{
		    switch(listitem)
			{
		    case 0:
		    {
		  		ResetPlayerWeapons(playerid);
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        GivePlayerWeapon(playerid,24,99999);
		   	    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}Вы выбрали Desert Eagle! Удачной дуэли! :)");
			}
		    case 1:
		    {
		  		ResetPlayerWeapons(playerid);
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        GivePlayerWeapon(playerid,25,99999);
		   	    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}Вы выбрали Shotgun! Удачной дуэли! :)");
		    }
		    case 2:
		    {
		  		ResetPlayerWeapons(playerid);
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        GivePlayerWeapon(playerid,31,99999);
		   	    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}Вы выбрали M4! Удачной дуэли! :)");
		    }
		    case 3:
		    {
      			if(GetPlayerScore(playerid) < 1000) return SendClientMessage(playerid, -1, "* {FF0000}Для Combat Shotgun нужен 9 Level!");
		  		ResetPlayerWeapons(playerid);
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        GivePlayerWeapon(playerid,27,99999);
		   	    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}Вы выбрали Combat Shotgun! Удачной дуэли! :)");
		    }
		    case 4:
		    {
		        if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, red, "{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        GivePlayerWeapon(playerid,24,99999);
		        GivePlayerWeapon(playerid,25,99999);
		   	    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}Вы выбрали Desert Eagle + Shotgun! Удачной дуэли! :)");
		    }
		    case 5:
		    {
			    if(PlayerInfo[playerid][Level] < 1) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор {FF0000}Развлекательного Центра™{0AD383}!");
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        GivePlayerWeapon(playerid,24,99999);
		        GivePlayerWeapon(playerid,31,99999);
		        GivePlayerWeapon(playerid,25,99999);
		   	    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}Вы выбрали Desert Eagle + Shotgun + M4! Удачной дуэли! :)");
		    }
		}
	}
		else//если игрок нажал "отмена" & Esc , серавно застовляем выбрать оружие!
    	{
	        new StringDuel[500];
	        strins(StringDuel,"{00FFFF}Desert Eagle\t\t| {00FF00}Players\r\n",strlen(StringDuel));
	       	strins(StringDuel,"{00FFFF}Shotgun\t\t| {00FF00}Players\r\n",strlen(StringDuel));
	       	strins(StringDuel,"{00FFFF}M4\t\t\t| {00FF00}Players\r\n",strlen(StringDuel));
	       	strins(StringDuel,"{00FFFF}Combat Shotgun\t| {00FF00}9 Level\r\n",strlen(StringDuel));
	        strins(StringDuel,"{00FFFF}D.Eagle+Shotgun\t| {EFF600}ViP\r\n",strlen(StringDuel));
	        strins(StringDuel,"{00FFFF}D.Eagle+Shotgun+M4\t| {FF0000}Admin\r\n",strlen(StringDuel));
	        ShowPlayerDialog(playerid,3656,DIALOG_STYLE_LIST,"ДАВАЙ ВЫБИРАЙ ОРУЖИЕ!",StringDuel,"»]Выбор[«","");
        }
    }


    if(dialogid == 7123)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			    	new String[500];
			    	strins(String,"{E44374}Пляж\r\n",strlen(String));
			    	strins(String,"{E64252}Небоскрёб\r\n",strlen(String));
			    	strins(String,"{E64A42}Церковь\r\n",strlen(String));
			    	strins(String,"{E68442}Банк #1\r\n",strlen(String));
			    	strins(String,"{E79C41}Банк #2\r\n",strlen(String));
			    	strins(String,"{E7C141}Аэропорт\r\n",strlen(String));
			    	strins(String,"{E7E741}Грув\r\n",strlen(String));
			    	strins(String,"{C0E443}Вокзал\r\n",strlen(String));
			    	ShowPlayerDialog(playerid,7124,DIALOG_STYLE_LIST,"Телепорты по Los Santos'y",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 1:
			    {
			    	new String[500];
			    	strins(String,"{C0E443}Гонки\r\n",strlen(String));
			    	strins(String,"{E7E741}Казино '4 Дракона'\r\n",strlen(String));
			    	strins(String,"{E7C141}Казино 'Калигули'\r\n",strlen(String));
			    	strins(String,"{E79C41}Пиратский Корабль\r\n",strlen(String));
			    	strins(String,"{E68442}Аммунация\r\n",strlen(String));
			    	strins(String,"{E64A42}Аэропорт\r\n",strlen(String));
			    	strins(String,"{E64252}Вокзал\r\n",strlen(String));
			    	ShowPlayerDialog(playerid,7125,DIALOG_STYLE_LIST,"Телепорты по Las Venturas'y",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 2:
			    {
			    	new String[500];
			    	strins(String,"{684ADD}Вокзал\r\n",strlen(String));
			    	strins(String,"{8949DE}Клуб 'Джиззи'\r\n",strlen(String));
			    	strins(String,"{A348DF}Доки\r\n",strlen(String));
			    	strins(String,"{B647E0}Аэропорт\r\n",strlen(String));
			    	strins(String,"{DD46E1}Wang Cars\r\n",strlen(String));
			    	strins(String,"{E245B7}Otto's Autos\r\n",strlen(String));
			    	strins(String,"{E34494}Площадь\r\n",strlen(String));
			    	strins(String,"{E44374}Тюнинг\r\n",strlen(String));
			    	strins(String,"{E64252}Гольф Парк\r\n",strlen(String));
			    	ShowPlayerDialog(playerid,7126,DIALOG_STYLE_LIST,"Телепорты по San Fierro",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 3:
			    {
			    	new String[500];
			    	strins(String,"{684ADD}АэроСтант\r\n",strlen(String));
			    	strins(String,"{8949DE}МотоСтант\r\n",strlen(String));
			    	strins(String,"{A348DF}ВМХ Парк\r\n",strlen(String));
			    	strins(String,"{B647E0}Бокс Арена\r\n",strlen(String));
			   		strins(String,"{DD46E1}БигТунель\r\n",strlen(String));
			   		strins(String,"{E245B7}Stunt Аэро San Fierro\r\n",strlen(String));
				    strins(String,"{E34494}Stunt Аэро Las Venturas\r\n",strlen(String));
				    strins(String,"{E44374}Mega Spusk\r\n",strlen(String));
				    strins(String,"{E68442}Трубы на небоскрёбе\r\n",strlen(String));
				    strins(String,"{E79C41}Трубы на пляже\r\n",strlen(String));
				    strins(String,"{E7C141}Дрифт зоны\r\n",strlen(String));
				    strins(String,"{E7E741}Паркур зоны\r\n",strlen(String));
				    strins(String,"{C0E443}Сумо арена\r\n",strlen(String));
				    strins(String,"{98E642}Race Treks\r\n",strlen(String));
				    strins(String,"{98E642}Прыжки с небоскрёба\r\n",strlen(String));
				    strins(String,"{45E284}Трубы San Fierro\r\n",strlen(String));
				    ShowPlayerDialog(playerid,7127,DIALOG_STYLE_LIST,"{FF8080}Развлекателные зоны Развлекательного Центра™",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 4:
			    {
			    	new String[500];
			    	strins(String,"{45E284}НЛО\r\n",strlen(String));
			    	strins(String,"{46E14E}FBI Deportament\r\n",strlen(String));
			    	strins(String,"{98E642}Weapon\r\n",strlen(String));
			    	strins(String,"{C0E443}Hospital\r\n",strlen(String));
			    	strins(String,"{E7E741}Cinema\r\n",strlen(String));
			    	strins(String,"{E7C141}Концерт Сцена\r\n",strlen(String));
			    	strins(String,"{E79C41}Рублёвка\r\n",strlen(String));
			    	strins(String,"{E68442}Остров\r\n",strlen(String));
			    	strins(String,"{E64A42}Тюрьма\r\n",strlen(String));
			    	strins(String,"{E64252}Приват-Банк\r\n",strlen(String));
			    	strins(String,"{E44374}Gruv House\r\n",strlen(String));
			    	strins(String,"{E34494}Vagos House\r\n",strlen(String));
			   	 	strins(String,"{E245B7}Aztec House\r\n",strlen(String));
			    	strins(String,"{DD46E1}Ballas House\r\n",strlen(String));
			    	strins(String,"{DD46E1}Ресторан у моря\r\n",strlen(String));
			   	    strins(String,"{DD46E1}Ночной клуб\r\n",strlen(String));
			    	strins(String,"{B647E0}City Hall\r\n",strlen(String));
			    	strins(String,"{A348DF}Большой Остров\r\n",strlen(String));
			    	strins(String,"{A348DF}Стриптиз Бар\r\n",strlen(String));
				    strins(String,"{8949DE}Мини-Ресторан 'Цезарь'\r\n",strlen(String));
				    strins(String,"{8949DE}Ресторан 'Обжора'\r\n",strlen(String));
				    strins(String,"{684ADD}Кафе 'У Моря'\r\n",strlen(String));
				    ShowPlayerDialog(playerid,7128,DIALOG_STYLE_LIST,"{ff0000}Интересные места Развлекательного Центра™",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 5:
			    {
				    new String[500];
				    strins(String,"{684ADD}RC Battlefield\r\n",strlen(String));
				    strins(String,"{8949DE}8-Track\r\n",strlen(String));
				    strins(String,"{A348DF}Bloodbowl\r\n",strlen(String));
				    strins(String,"{B647E0}Dirt track\r\n",strlen(String));
				    strins(String,"{DD46E1}Kickstart\r\n",strlen(String));
				    strins(String,"{DD46E1}Vice stadium\r\n",strlen(String));
				    strins(String,"{DD46E1}LS Atruim\r\n",strlen(String));
				    strins(String,"{E245B7}Bike School\r\n",strlen(String));
				    strins(String,"{E34494}Millie room\r\n",strlen(String));
				    strins(String,"{E44374}Barbara room\r\n",strlen(String));
				    strins(String,"{E64252}Michelle room\r\n",strlen(String));
				    strins(String,"{E64A42}Helena room\r\n",strlen(String));
				    strins(String,"{E44374}Woozie's office\r\n",strlen(String));
				    strins(String,"{E34494}Meat factory\r\n",strlen(String));
				    strins(String,"{E245B7}Sherman dam\r\n",strlen(String));
				    ShowPlayerDialog(playerid,7129,DIALOG_STYLE_LIST,"{ff0000}Интерьеры Развлекательного Центра™",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 6:
			    {
				    new String[500];
				    strins(String,"{E245B7}Форт Карсон\r\n",strlen(String));
				    strins(String,"{E34494}Лас Барранкас\r\n",strlen(String));
				    strins(String,"{E44374}Ел Квебрадос\r\n",strlen(String));
				    strins(String,"{E64A42}Лас Панасандс\r\n",strlen(String));
				    strins(String,"{E64252}Сосна Ангела\r\n",strlen(String));
				    strins(String,"{E44374}Диллимур\r\n",strlen(String));
				    strins(String,"{E34494}Чирника\r\n",strlen(String));
				    strins(String,"{E245B7}Монтгомери\r\n",strlen(String));
				    strins(String,"{DD46E1}Ручен Палотино\r\n",strlen(String));
				    ShowPlayerDialog(playerid,7130,DIALOG_STYLE_LIST,"{ff0000}Мини-города Развлекательного Центра™",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 7:
			    {
				    new String[500];
				    strins(String,"{E245B7}База команды ELISIYM\r\n",strlen(String));
				    strins(String,"{E34494}База свободна\r\n",strlen(String));
				    strins(String,"{E44374}База клана [Sunny]\r\n",strlen(String));
				    ShowPlayerDialog(playerid,7131,DIALOG_STYLE_LIST,"{ff0000}Базы кланов/team Развлекательного Центра™",String,"»]Выбор[«","»]Отмена[«");
			    }
			    case 8:OnPlayerCommandText(playerid,"/gotoplace");//Свой телепорт
			    case 9:
			    {
			        if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, red, "{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
				    new String[500];
				    strins(String,"{EFF600}Los Santos Пляж\r\n",strlen(String));
				    strins(String,"{EFF600}Groove Street\r\n",strlen(String));
				    strins(String,"{EFF600}Los Santos Centr\r\n",strlen(String));
				    strins(String,"{EFF600}VINEWOOD\r\n",strlen(String));
				    strins(String,"{EFF600}Бедный район\r\n",strlen(String));
					strins(String,"{EFF600}Озеро в лесу\r\n",strlen(String));
				    strins(String,"{EFF600}Заброшка\r\n",strlen(String));
					strins(String,"{EFF600}Военная база\r\n",strlen(String));
				    strins(String,"{EFF600}San Fierro\r\n",strlen(String));
					strins(String,"{EFF600}Las Venturas\r\n",strlen(String));
				    strins(String,"{EFF600}Небоскреб Los Santos\r\n",strlen(String));
				    ShowPlayerDialog(playerid,7132,DIALOG_STYLE_LIST,"{ff0000}ViP Teles Развлекательного Центра™",String,"»]Выбор[«","»]Отмена[«");
			    }
			}
		}
	    return 1;
	}

    if(dialogid == 3312)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			        new String[4000];
				    strins(String," {BEFD00} /lockcar,/unlock - закрыть/открыть двери своего транспорта *\n",strlen(String));
				    strins(String," {BEFD00} /disarm [id]- разоружить игрока\n",strlen(String));
				    strins(String," {BEFD00} /lcar - заспавнить тачку (спавнится определённая модель) и сесть в неё\n",strlen(String));
				    strins(String," {BEFD00} /lbike - заспавнить NRG и сесть в него\n",strlen(String));
				    strins(String," {BEFD00} /ltc[1-12] - заспавнить тачку (Sultan , Elegy и т.д)\n",strlen(String));
				    strins(String," {BEFD00} /ltune - тюнинг машины\n",strlen(String));
				    strins(String," {BEFD00} /jetpack - взять джетпак *\n",strlen(String));
				    strins(String," {BEFD00} /flip - флиповать транпорт\n",strlen(String));
				    strins(String," {BEFD00} /fix - фиксировать транспорт\n",strlen(String));
				    strins(String," {BEFD00} /repair - починить транспорт\n",strlen(String));
				    strins(String," {BEFD00} /carcolour - изменить цвет авто\n",strlen(String));
				    strins(String," {BEFD00} /ltune - тюнинг\n",strlen(String));
				    strins(String," {BEFD00} /setmytime - установить себе время\n",strlen(String));
				    strins(String," {BEFD00} /lhy - тюнинговать машину\n",strlen(String));
				    strins(String," {BEFD00} /lnos - установить азот\n",strlen(String));
				    strins(String," {BEFD00} /ping - посмотреть игрока пинг\n",strlen(String));
			        strins(String," {BEFD00} /reports - посмотреть все жалобы\n",strlen(String));
				    strins(String," {BEFD00} /richlist - список богачей\n",strlen(String));
				    strins(String," {BEFD00} /miniguns - посмотреть нет ли у  игрокав миниганы\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 1 уровня",String,"Ok","Закрыть");
			    }
			    case 1:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /slap [id][причина] - пнуть игрока (игрока поднимает на метр-два вверх и снимает с него примерно 20хп )\n",strlen(String));
				    strins(String," {BEFD00} /burn [id](причина не пишется) - поджечь игрока\n",strlen(String));
				    strins(String," {BEFD00} /warn [id][причина] - предупредить игрока (после 3 предупреждений одному игроку, его кикает)\n",strlen(String));
				    strins(String," {BEFD00} /mute [id][время] [причина] - заткнуть игрокая\n",strlen(String));
				    strins(String," {BEFD00} /unmute  [id]- разоткнуть игрока\n",strlen(String));
				    strins(String," {BEFD00} /getinfo [id]- даёт информаци об игроке (Жизни,броня,фраги,деньги на руках,ид скина,ip адрес и т.д)\n",strlen(String));
				    strins(String," {BEFD00} /clearchat - очистить чат *\n",strlen(String));
				    strins(String," {BEFD00} /asay говорить от администрации (например если написать /asay test, то напишется: ''Админ nickname: test'')\n",strlen(String));
				    strins(String," {BEFD00} /giveweapon - дать оружие\n",strlen(String));
			        strins(String," {BEFD00} /jetpack - получить JetPack\n",strlen(String));
				    strins(String," {BEFD00} /goto [id]- телепорт к игроку *\n",strlen(String));
			   	    strins(String," {BEFD00} /jailed - посмотреть кто посажен \n",strlen(String));
			   	    strins(String," {BEFD00} /frozen - посмотреть кто заморожен\n",strlen(String));
			   	    strins(String," {BEFD00} /screen - отправить сообщение на экран\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 2 уровня ",String,"Ok","Закрыть");
			    }
			    case 2:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-2 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /setskin [id][id скина] - дать определённый скин игроку *\n",strlen(String));
				    strins(String," {BEFD00} /setcolour [id][id цвета] - сменить игроку цвет ника *\n",strlen(String));
				    strins(String," {BEFD00} /setwanted [id][уровень] - дать игроку уровень розыска (звёздочки на HUD) **\n",strlen(String));
				    strins(String," {BEFD00} /spawn [id]- вернуть игрока на респавн\n",strlen(String));
				    strins(String," {BEFD00} /kick [id][причина] - кикнуть игрока\n",strlen(String));
				    strins(String," {BEFD00} /explode [id][причина] - взорвать игрока\n",strlen(String));
				    strins(String," {BEFD00} /eject [id]- вытащить игрока из машины\n",strlen(String));
				    strins(String," {BEFD00} /jail [id][время] [причина],/unjail id - посадить игрока,выпустить из тюрьмы\n",strlen(String));
				    strins(String," {BEFD00} /freeze [id][причина],/unfreeze [id]- заморозить игрока,разморозить\n",strlen(String));
				    strins(String," {BEFD00} /admin,/adminoff - включить/выключить табличку админ у себя\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 3 уровня ",String,"Ok","Закрыть");
			    }
			    case 3:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-3 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /gethere [id],/get [id]- телепортировать игрока к себе *\n",strlen(String));
				    strins(String," {BEFD00} /teleplayer [id первого игрока] [id второго игрока] - телепортировать игрока к другому игроку *\n",strlen(String));
				    strins(String," {BEFD00} /car [id или название] - заспавнить определённую тачку *\n",strlen(String));
				    strins(String," {BEFD00} /carhealth  [id][hp]- изменить количество жизней тачки у игрока *\n",strlen(String));
				    strins(String," {BEFD00} /caps - вкл/выкл капс в чате **\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 4 уровня ",String,"Ok","Закрыть");
			    }
			    case 4:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-4 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /sethealth  [id][hp]- изменить игроку кол-во жизней\n",strlen(String));
				    strins(String," {BEFD00} /setarmour  [id][hp]- изменить игроку кол-во брони\n",strlen(String));
				    strins(String," {BEFD00} /setweather [id][id погоды] - изменить игроку погоду *\n",strlen(String));
				    strins(String," {BEFD00} /settime [id][время] - изменить игроку время **\n",strlen(String));
				    strins(String," {BEFD00} /healall - вылечить всех игроков\n",strlen(String));
				    strins(String," {BEFD00} /armourall - дать всем игрокам броню\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 5 уровня ",String,"Ok","Закрыть");
			    }
			    case 5:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-5 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /setallweather - изменить всем погоду (кроме вас) **\n",strlen(String));
				    strins(String," {BEFD00} /setallwanted - изменить всем уровень розыска (кроме вас) **\n",strlen(String));
				    strins(String," {BEFD00} /setalltime - изменить всем время (кроме вас) **\n",strlen(String));
				    strins(String," {BEFD00} /setallwanted - установить всем уровень розіска\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 6 уровня ",String,"Ok","Закрыть");
			    }
			    case 6:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-6 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /ban [id][причина] - забанить игрока\n",strlen(String));
				    strins(String," {BEFD00} /сс - очистить чат (больше кол-во строков будет очищено)\n",strlen(String));
				    strins(String," {BEFD00} /invis - невидимый\n",strlen(String));
				    strins(String," {BEFD00} /uninvis - стать видемым\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"	{FF0000}Строго требуется указывать причины наказаний,при чем нормальные,а не например ''xxx забанен админом yyy (причина: ковыряется в ноcу),\n",strlen(String));
				    strins(String,"	{FF0000}Приличное время наказания (максимум 10 минут).\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 7 уровня ",String,"Ok","Закрыть");
			    }
			    case 7:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-7 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /scars - зареспавнить незанятый транспорт;\n",strlen(String));
				    strins(String," {BEFD00} /lammo - оружие\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"	{FF0000}Строго требуется указывать причины наказаний,при чем нормальные,а не например ''xxx забанен админом yyy (причина: ковыряется в ноcу),\n",strlen(String));
				    strins(String,"	{FF0000}Приличное время наказания (максимум 10 минут).\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 8 уровня ",String,"Ok","Закрыть");
			    }
			    case 8:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-8 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /ip [id]- узнать ip адрес игрока;\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"	{FF0000}Строго требуется указывать причины наказаний,при чем нормальные,а не например ''xxx забанен админом yyy (причина: ковыряется в ноcу),\n",strlen(String));
				    strins(String,"	{FF0000}Приличное время наказания (максимум 10 минут).\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 9 уровня ",String,"Ok","Закрыть");
			    }
			    case 9:
			    {
			        new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-9 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /setworld - установить вертуальный мир\n",strlen(String));
				    strins(String," {BEFD00} /ubound - удалить мировые границы\n",strlen(String));
				    strins(String," {BEFD00} /countdown - Отчет\n",strlen(String));
				    strins(String," {BEFD00} /akill - убить игрока\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"	{FF0000}Строго требуется указывать причины наказаний,при чем нормальные,а не например ''xxx забанен админом yyy (причина: ковыряется в ноcу),\n",strlen(String));
				    strins(String,"	{FF0000}Приличное время наказания (максимум 10 минут).\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 10 уровня ",String,"Ok","Закрыть");
			    }
			    case 10:
			    {
					new String[4000];
			        strins(String,"{FFFFFF}Учитывая команды 1-10 уровня!\n",strlen(String));
			   	    strins(String,"\n",strlen(String));
				    strins(String," {BEFD00} /dialog - окошко счастья\n",strlen(String));
				    strins(String," {BEFD00} /undialog - убрать окошко счастья\n",strlen(String));
				    strins(String," {BEFD00} /forbidname - занести Никнейм в ЧС\n",strlen(String));
				    strins(String," {BEFD00} /forbidword - занести Слово в ЧС\n",strlen(String));
				    strins(String," {BEFD00} /spawnall - вернуть всех игроков на спавн\n",strlen(String));
				    strins(String," {BEFD00} /muteall - заткнуть всех игроков\n",strlen(String));
				    strins(String," {BEFD00} /unmuteall - разоткнуть всех игроков\n",strlen(String));
				    strins(String," {BEFD00} /getall - телепортировать всех к себе\n",strlen(String));
				    strins(String," {BEFD00} /freezeall - заморозить всех\n",strlen(String));
				    strins(String," {BEFD00} /unfreezeall - разморозить всех\n",strlen(String));
				    strins(String," {BEFD00} /slapall - пнуть всех\n",strlen(String));
				    strins(String," {BEFD00} /explodeall - взорвать всех\n",strlen(String));
				    strins(String," {BEFD00} /disarmall - разоружить всех\n",strlen(String));
				    strins(String," {BEFD00} /ejectall - выкинуть всех из машины\n",strlen(String));
				    strins(String," {BEFD00} /giveallweapon - выдать всех оружие\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    strins(String,"	{FF0000}Запрещено балование командами,раздача оружий/запрещённых оружий,использование админки против других админов.\n",strlen(String));
				    strins(String,"	{FF0000}Строго требуется указывать причины наказаний,при чем нормальные,а не например ''xxx забанен админом yyy (причина: ковыряется в ноcу),\n",strlen(String));
				    strins(String,"	{FF0000}Приличное время наказания (максимум 10 минут).\n",strlen(String));
				    strins(String,"\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Команды 11 уровня ",String,"Ok","Закрыть");
			    }
			}
		}
	    return 1;
	}

///========================================[Упрощеные выводы в диалогах от Цени + оптимизация]======================================================
   	if(dialogid == 8130 && response)//Новогоднии объекты
	switch (listitem)
	{
		case 0: SetPlayerAttachedObject(playerid, 2, 19065, 2, 0.121128, 0.023578, 0.001139, 222.540847, 90.773872, 211.130859, 1.098305, 1.122310, 1.106640)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 1: SetPlayerAttachedObject(playerid, 0, 19076, 1, -1.2619, 0.0669, -0.0720, 1.89, 86.79, 0.00, 0.27, 0.37, 0.38)
	            ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	    case 2: SetPlayerAttachedObject(playerid, 0, 19058, 1, -0.1990, 0.0360, -0.0120, 90.40, 89.29, -1.70, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	   	case 3: SetPlayerAttachedObject(playerid, 0, 19057, 1, -0.1990, 0.0360, -0.0120, 90.40, 89.29, -1.70, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 4: SetPlayerAttachedObject(playerid, 0, 19056, 1, -0.1990, 0.0360, -0.0120, 90.40, 89.29, -1.70, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	    case 5: SetPlayerAttachedObject(playerid, 0, 19055, 1, -0.1990, 0.0360, -0.0120, 90.40, 89.29, -1.70, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	   	case 6: SetPlayerAttachedObject(playerid, 0, 19054, 1, -0.1990, 0.0360, -0.0120, 90.40, 89.29, -1.70, 1.00, 1.00, 1.00)
	            ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 7: SetPlayerAttachedObject(playerid, 0, 19063, 1, -0.0249, 0.0320, -0.0100, 2.99, 85.59, 17.99, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	    case 8: SetPlayerAttachedObject(playerid, 0, 19062, 1, -0.0249, 0.0320, -0.0100, 2.99, 85.59, 17.99, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	   	case 9: SetPlayerAttachedObject(playerid, 0, 19061, 1, -0.0249, 0.0320, -0.0100, 2.99, 85.59, 17.99, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 10: SetPlayerAttachedObject(playerid, 0, 19060, 1, -0.0249, 0.0320, -0.0100, 2.99, 85.59, 17.99, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	    case 11: SetPlayerAttachedObject(playerid, 0, 19059, 1, -0.0249, 0.0320, -0.0100, 2.99, 85.59, 17.99, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}

   	if(dialogid == 8133 && response)//Оружие в теле
	switch (listitem)
	{
		case 0: SetPlayerAttachedObject(playerid, 5, 335, 2, -0.0839, -0.0270, -0.2490, 0.00, -19.89, -2.60, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 1: SetPlayerAttachedObject(playerid, 6, 339, 1, 0.0009, 0.3919, 0.0110, 98.29, -10.00, 164.10, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 2: SetPlayerAttachedObject(playerid, 6, 337, 1, 0.0299, -0.6340, 0.1119, -104.79, 0.00, -74.19, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	   	case 3: SetPlayerAttachedObject(playerid, 4, 335, 9, -0.1660, 0.1129, 0.0819, 0.00, 97.29, 40.19, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
   	}

   	if(dialogid == 8131 && response)//Наушники
	switch (listitem)
	{
		case 0: SetPlayerAttachedObject(playerid, 7, 19424, 2, 0.0590, 0.0250, -0.0020, 83.30, 0.00, -90.09, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 1: SetPlayerAttachedObject(playerid, 7, 19423, 2, 0.0590, 0.0250, -0.0020, 83.30, 0.00, -90.09, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 2: SetPlayerAttachedObject(playerid, 7, 19422, 2, 0.0590, 0.0250, -0.0020, 83.30, 0.00, -90.09, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	   	case 3: SetPlayerAttachedObject(playerid, 7, 19421, 2, 0.0590, 0.0250, -0.0020, 83.30, 0.00, -90.09, 1.00, 1.00, 1.00)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
   	}

   	if(dialogid == 8125 && response)// Доска для серфинга
	switch (listitem)
	{
		case 0: SetPlayerAttachedObject(playerid, 0, 2404, 1, 0.0089, -0.1350, -0.0129, 1.00, 125.49, 0.89, 0.86, 0.78, 0.71)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 1: SetPlayerAttachedObject(playerid, 0, 2405, 1, 0.0089, -0.1350, -0.0129, 1.00, 125.49, 0.89, 0.86, 0.78, 0.71)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 2: SetPlayerAttachedObject(playerid, 0, 2406, 1, 0.0089, -0.1350, -0.0129, 1.00, 125.49, 0.89, 0.86, 0.78, 0.71)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
   	}

   	if(dialogid == 8126 && response)//Гитара на спине
	switch (listitem)
	{
		case 0: SetPlayerAttachedObject(playerid, 0, 19317, 1, 0.2330, -0.0989, -0.0299, -2.49, 88.09, 2.09, 0.73, 1.89, 0.71)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 1: SetPlayerAttachedObject(playerid, 0, 19318, 1, 0.2330, -0.0989, -0.0299, -2.49, 88.09, 2.09, 0.73, 1.89, 0.71)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		case 2: SetPlayerAttachedObject(playerid, 0, 19319, 1, 0.2330, -0.0989, -0.0299, -2.49, 88.09, 2.09, 0.73, 1.89, 0.71)
		        ,PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
   	}

    if(dialogid == 8124)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
					SetPlayerAttachedObject(playerid, 0, 356, 1, 0.1859, -0.1259, 0.1460, 0.00, -179.60, 0.00, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 1, 349, 1, 0.2130, -0.0819, -0.1779, -178.70, -172.50, 3.20, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 2, 348, 8, 0.0770, -0.0200, 0.1089, -111.59, -2.79, -7.00, 1.00, 1.00, 1.00);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			    }
			    case 1:
			    {
					SetPlayerAttachedObject(playerid, 0, 350, 1, 0.4619, -0.1039, 0.2479, 0.00, 170.69, -1.29, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 1, 350, 1, 0.4219, -0.0509, -0.2510, 160.39, 173.30, 13.89, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 2, 353, 1, -0.3570, -0.1279, 0.1679, 0.00, 92.59, 0.00, 1.00, 1.00, 1.00);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				}
			    case 2:
			    {
					SetPlayerAttachedObject(playerid, 0, 351, 1, 0.4390, -0.1190, 0.2549, 0.00, -175.39, 0.00, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 1, 358, 1, 0.1959, -0.0819, -0.1710, -175.60, -179.60, 7.09, 1.00, 1.00, 1.00);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			    }
			    case 3:
			    {
			        if(GetPlayerScore(playerid) < 750) return SendClientMessage(playerid, -1, "* {FF0000}Слот оружия #4 доступны токо с 8 Level'a!!");
					SetPlayerAttachedObject(playerid, 0, 362, 1, 0.7060, -0.1700, -0.0089, 0.00, -155.00, 0.00, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 1, 360, 1, 0.1169, -0.1280, -0.2690, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			    }
			    case 4:
			    {
					SetPlayerAttachedObject(playerid, 0, 339, 1, 0.4389, -0.1450, -0.0250, 0.00, -116.19, 0.00, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 1, 339, 1, 0.4410, -0.1380, -0.0049, -156.09, -107.09, -26.19, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 2, 344, 1, -0.0239, -0.0870, -0.1019, 174.69, 106.59, -4.99, 1.00, 1.00, 1.00);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			    }
			    case 5:
			    {
					SetPlayerAttachedObject(playerid, 0, 357, 1, 0.2669, -0.1560, 0.1279, 0.00, 157.20, -1.40, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 1, 347, 8, 0.0299, 0.0230, 0.1239, -119.40, 4.59, -3.59, 1.00, 1.00, 1.00);
					SetPlayerAttachedObject(playerid, 2, 349, 1, 0.3009, -0.1119, -0.1349, -164.39, 174.20, -0.09, 1.00, 1.00, 1.00);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			    }
			}
		}
	    return 1;
	}
   	
    if(dialogid == 3311)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			        new String[4000];
				    strins(String,"{0000FF}1. Администратору запрещается:\n",strlen(String));
				    strins(String," {80FF80}1) Спавнить военную технику\n",strlen(String));
				    strins(String," {80FF80}2) Спавнить оружия, юзать /giveweapon и /lammo\n",strlen(String));
				    strins(String," {80FF80}3) Пользоваться миниганом\n",strlen(String));
				    strins(String," {80FF80}4) Пользоваться командой /lmenu без крайней необходимости, кроме как изменить погоду если\n",strlen(String));
				    strins(String," {80FF80}5) Использовать /goto или /get без крайней необходимости\n",strlen(String));
				    strins(String," {80FF80}6) Также запрещено менять скин и цвет другому игроку (себе можно)\n",strlen(String));
				    strins(String," {80FF80}7) Запрещается банить за ob того игрока которые обошёл бан через 12 часов, если раньше то бан, если позже то либо он разбанен либо он обошёл бан,\n",strlen(String));
				    strins(String," {80FF80}но наказание - 1 день просидел! Исключение: игроки в чёрном списке, их банить всегда как увидете!\n",strlen(String));
				    strins(String," {80FF80}8) Запрещается кикать/банить/пинать/взрывать/поджигать/оскорблять/давать warn/сажать в тюрьму другого администратора.\n",strlen(String));
				    strins(String," {80FF80}9) Запрещается выключать чтение админ команд, коннект / дисконнект сообщения, а так же чтение приватов / пм / личных сообщений игроков.\n",strlen(String));
				    strins(String,"{FF0000}2. Администратор обязан:\n",strlen(String));
				    strins(String," {80FF80}1) Кикать/банить игроков за различные читы, баги, моды, cleo скрипты, оскорбления и маты\n",strlen(String));
				    strins(String," {80FF80}2) Кикать администратору положено если игрок использовал sh один раз или мельком читерил мелкими читами, не опасными для игроков!\n",strlen(String));
				    strins(String," {80FF80}3) Банить положено тогда когда игрок использовал любой опасный чит, к примеру gm, fly, wh, частое sh, mh, ah, hh, обход наказаний не обязательно бана!\n",strlen(String));
				    strins(String," {80FF80}4) Пинать, взрывать, поджигать игрока разрешено в мелких проступках игрока, к примеру игрок сматернулся один раз, вы пишите: /slap id mat\n",strlen(String));
				    strins(String," {80FF80}5) Запрещено давать оружия игрокам, запрещено их тп на другого игрока без крайней необходимости,\n",strlen(String));
				    strins(String," {80FF80}также админу разрешено использовать единственный пожалуй ряд команд: /lcar, /lbike, /lplane, /lheli /car и т.д\n",strlen(String));
				    strins(String," {80FF80}6) Убивать командой /akill также можно игрока если он не слушается\n",strlen(String));
				    strins(String," {80FF80}7) Если игрок матерится сильно в чат, то можно заткнуть его командой /mute id [время] [причина] и /unmute id чтобы разоткнуть (без [])\n",strlen(String));
				    strins(String," {80FF80}8) Если игрок нарушил правила сервера и задавил кого-то или убил с транспорта, то на это есть две причины: Drive-by - игрок убил с транспорта,\n",strlen(String));
				    strins(String," {80FF80}с мотоцикла; Car-by - игрок задавил игрока. За эти нарушения правил Вы можете посадить игрока на 2 минуты: /jail [id] [кол.минут] [причина]\n",strlen(String));
				    strins(String," {80FF80}также чтобы выпустить /unjail (Убийство с вертолёта хантера не считается, это разрешено, также лопостями винта вертолёта тоже разрешено)\n",strlen(String));
				    strins(String," {80FF80}9) Администратор обязан отвечать на репорты (жалобы на читера)! Проверять читера слежкой за ним, а если GM то:\n",strlen(String));
				    strins(String," {80FF80}- 1. Тп к нему и убить его из Micro UZI.\n",strlen(String));
				    strins(String," {80FF80}- 2. Тп к нему, заморозить /freeze id [proverka] - причина проверка, без [], и пострелять в него! Если жизни ОТНИМУТСЯ то ОН ЧИТЕР,\n",strlen(String));
				    strins(String," {80FF80}если жизни НЕ ОТНИМУТСЯ то он НЕЧИТЕР, я ничего не перепутал, всё так и есть, при заморозке всё наоборот! Освободить игрока после проверки -\n",strlen(String));
				    strins(String," {80FF80}/unfreeze id\n",strlen(String));
				    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Администратору запрещается/обязан",String,"Ok","Закрыть");
			    }
			    case 1:
			    {
			    	new String[4000];
				    strins(String," {80FF80}Airbrk - полёт на машине\n",strlen(String));
				    strins(String," {80FF80}Fly - полёт игроком\n",strlen(String));
				    strins(String," {80FF80}Repair car - игрок починил тачку читом\n",strlen(String));
				    strins(String," {80FF80}Carhack - игрок притянул к себе много тачек или на спавнил их читом\n",strlen(String));
				    strins(String," {80FF80}Car-by - игрок задавил игрока наехав на него\n",strlen(String));
				    strins(String," {80FF80}Drive-by - игрок убил из автомата игрока с мотоцикла или с машины\n",strlen(String));
				    strins(String," {80FF80}Teleport to car - игрок переместился быстро на место водителя ближайшей машины, тем самым скинув водителя\n",strlen(String));
				    strins(String," {80FF80}CLEO Scripts - игрок использует различные читы которых нет не в одной чит-программе и их трудно описать\n",strlen(String));
				    strins(String," {80FF80}Ezda po stenam, ezda vniz golovoi, ezda pod vodoi, ezda po vode - езда по стенам игроком, езда вниз головой, езда под водой, езда по воде\n",strlen(String));
				    strins(String," {80FF80}gm - год мод игрока\n",strlen(String));
				    strins(String," {80FF80}healthhack - игрок пополнил жизни читом\n",strlen(String));
				    strins(String," {80FF80}armourhack - игрок пополнил броню читом\n",strlen(String));
				    strins(String," {80FF80}moneyhack - игрок пополнил деньги читом\n",strlen(String));
				    strins(String," {80FF80}weaponhack - если у игрока есть подозрительные оружия (миниган или скорострельная базука и то что вы как пологаете\n",strlen(String));
				    strins(String," {80FF80}все 100% игрок создал себе оружия спомощью чита) (так как базуки разрешены на сервере и их может найти любой игрок)\n",strlen(String));
				    strins(String," {80FF80}spam, adv - спам, реклама\n",strlen(String));
				    strins(String," {80FF80}mat - если игрок матерится в чате то писать слово мат английскими буквами обязательно в причине.\n",strlen(String));
				    strins(String," {80FF80}osk - если игрок оскорбляет другого игрока или админа то писать на всех одну причину.\n",strlen(String));
				    strins(String," {80FF80}flame - флейм – это процесс, который иногда возникает при общении в интернете ''словесная война''. Это неожиданно возникшее бурное обсуждение,\n",strlen(String));
				    strins(String," {80FF80}в процессе которого участники обычно забывают о первоначальной теме, переходят на личности и не могут остановиться.\n",strlen(String));
				    strins(String," {80FF80}speedhack - игрок двигается на большой скорости резко и на старой развалине возможно\n",strlen(String));
				    strins(String," {80FF80}colourcar - игрок покрасил машину читом\n",strlen(String));
				    strins(String," {80FF80}ob - обход наказания\n",strlen(String));
				    strins(String," {80FF80}flip - игрок перевернул тачку читом\n",strlen(String));
				    strins(String," {80FF80}brake dance - игрок вертит машину во все стороны функцией собейта - brake dance to car\n",strlen(String));
				    strins(String," {80FF80}Sandbox - когда с одного ip адреса играет 2 игрока\n",strlen(String));
				    strins(String," {80FF80}багоюзер [вид бага] - желательно кикать, но когда игрок в наглую и часто юзает баги, его можно забанить,\n",strlen(String));
				    strins(String," {80FF80}обязательно указать вид бага (+ с, скольжение, невидимость; ИСКЛЮЧЕНИЕ - скролл, который ОФИЦИАЛЬНО РАЗРЕШЕН НА НАШЕМ СЕРВЕРЕ).\n",strlen(String));
				    strins(String," {80FF80}некорректный ник - желательно кикать, если не помогает 3 и более киков, можно банить, ники,\n",strlen(String));
				    strins(String," {80FF80}которые не несут смысловой нагрузки, например: 111, ololo, XD и тд, матные и оскорбляющие ники банить сразу.\n",strlen(String));
				    strins(String," {80FF80}proverka - причина используется для проверки игрока на GM в основном, взрывом, заморозкой и другими способами!\n",strlen(String));
				    strins(String," {80FF80}team kill - командное убийство/дружественный огонь/убийство игрока из своей команды. Желательно кикать.\n",strlen(String));
				    strins(String," {80FF80}spawn kill - убийство игрока на спавне/респавне, например /gora /jump /akvapark. Желательно кикать.\n",strlen(String));
				    strins(String," {80FF80}срыв мероприятия - дается только в том случае, когда игрок мешает администрации или другому игроку провести мероприятие.\n",strlen(String));
				    strins(String," {80FF80}За нарушение данного правила игрока можно кикнуть или посадить в тюрьму на время не более 10 минут. !\n",strlen(String));
				    strins(String," {80FF80}sell account - бан дается только в том случае, когда игрок пишет в общий чат объявление о покупке/продаже аккаунта.\n",strlen(String));
				    strins(String," {80FF80}Fake kill - функция собейта, когда игрок с собейтом умирает от рук другого, хотя он этого не делал.\n",strlen(String));
					ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFF00}Второстепенные правила ",String,"Ok","Закрыть");
			    }
			}
		}
	    return 1;
	}

	if(dialogid == 119)
	{
	    if(response)
 	   {
	        switch(listitem)
			{
			    case 0: AddVehicleComponent(GetPlayerVehicleID(playerid),1025);
			    case 1: AddVehicleComponent(GetPlayerVehicleID(playerid),1073);
			    case 2: AddVehicleComponent(GetPlayerVehicleID(playerid),1074);
			    case 3: AddVehicleComponent(GetPlayerVehicleID(playerid),1075);
			    case 4: AddVehicleComponent(GetPlayerVehicleID(playerid),1076);
			    case 5: AddVehicleComponent(GetPlayerVehicleID(playerid),1077);
			    case 6: AddVehicleComponent(GetPlayerVehicleID(playerid),1078);
			    case 7: AddVehicleComponent(GetPlayerVehicleID(playerid),1079);
			    case 8: AddVehicleComponent(GetPlayerVehicleID(playerid),1080);
			    case 9: AddVehicleComponent(GetPlayerVehicleID(playerid),1081);
			    case 10: AddVehicleComponent(GetPlayerVehicleID(playerid),1082);
			    case 11: AddVehicleComponent(GetPlayerVehicleID(playerid),1083);
			    case 12: AddVehicleComponent(GetPlayerVehicleID(playerid),1084);
			    case 13: AddVehicleComponent(GetPlayerVehicleID(playerid),1085);
			    case 14: AddVehicleComponent(GetPlayerVehicleID(playerid),1096);
			    case 15: AddVehicleComponent(GetPlayerVehicleID(playerid),1097);
			    case 16: AddVehicleComponent(GetPlayerVehicleID(playerid),1098);
			}
			SendClientMessage(playerid, 0xFF9900FF,"{FF0000}* {8b00ff}Вы установили новые диски на свой автомобиль.");
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~b~Updated", 1000, 3);
		}
	}
	
	if(dialogid == 587)
    {
        if(response)
        {
            if(listitem == 0)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
                neon[playerid][0] = CreateObject(18647,0,0,0,0,0,0,100.0);
                neon[playerid][1] = CreateObject(18647,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
            else if(listitem == 1)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
                neon[playerid][0] = CreateObject(18648,0,0,0,0,0,0,100.0);
                neon[playerid][1] = CreateObject(18648,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
            else if(listitem == 2)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
                neon[playerid][0] = CreateObject(18649,0,0,0,0,0,0,100.0);
                neon[playerid][1] = CreateObject(18649,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
            else if(listitem==3)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
                neon[playerid][0] = CreateObject(18650,0,0,0,0,0,0,100.0);
                neon[playerid][1] = CreateObject(18650,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
            else if(listitem==4)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
                neon[playerid][0] = CreateObject(18651,0,0,0,0,0,0,100.0);
                neon[playerid][1] = CreateObject(18651,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
            else if(listitem==5)
            {
                DestroyObject(neon[playerid][0]);
                DestroyObject(neon[playerid][1]);
                neon[playerid][0] = CreateObject(18652,0,0,0,0,0,0,100.0);
                neon[playerid][1] = CreateObject(18652,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
                AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
            }
        }
    }

    if(dialogid == 1)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: ShowPlayerDialog(playerid, 1+1, DIALOG_STYLE_LIST,"{FFBF00}Машины","{FFBF00}Инфернус\n{FFEA00}Супер GT\n{E6FF00}Банши\n{B3FF00}Турисмо\n{44FF00}ZR-350\n{00FF51}Монстер\n{00FFC8}Пуля\n{00C8FF}Феникс\n{4400FF}Султан\n{6F00FF}Джип\n{9500FF}Уранус\n{6F00FF}Комет\n{4400FF}Елегия\n{00C8FF}Меса\n{00FFC8}Виндсор","»]Выбрать[«", "»]Выход[«");
			    case 1: ShowPlayerDialog(playerid, 1+2, DIALOG_STYLE_LIST,"{FFEA00}Мотоциклы","{FFBF00}BF-400\n{FFEA00}Велик\n{E6FF00}BMX\n{B3FF00}Байк\n{44FF00}FCR-900\n{00FF51}Мотоцикл\n{00FFC8}Горный-Велик\n{00C8FF}NRG-500\n{4400FF}PCJ-600\n{6F00FF}Пица-Байк\n{9500FF}Скутер\n{C300FF}Санчез","»]Выбрать[«", "»]Выход[«");
			    case 2: ShowPlayerDialog(playerid, 1+3, DIALOG_STYLE_LIST,"{E6FF00}Самолёты","{FFBF00}Андромада\n{FFEA00}АТ-400\n{E6FF00}Бигл\n{B3FF00}Кукурзник1\n{44FF00}Додо\n{00FFC8}Невада\n{00C8FF}Рустлер\n{4400FF}Шамаль\n{6F00FF}Скиммера\n{9500FF}Кукурузник2","»]Выбрать[«", "»]Выход[«");
			    case 3: ShowPlayerDialog(playerid, 1+4, DIALOG_STYLE_LIST,"{B3FF00}Вертолёты","{FFBF00}Каргобоб\n{E6FF00}Левитан\n{B3FF00}Маверик\n{44FF00}Новый-Маверик\n{00FF51}Полицейский-Маверик\n{00FFC8}Вертолёт","»]Выбрать[«", "»]Выход[«");
			    case 4: ShowPlayerDialog(playerid, 1+5, DIALOG_STYLE_LIST,"{B3FF00}Лодки","{FFBF00}Squallo\n{FFEA00}Speeder\n{E6FF00}Reefer\n{B3FF00}Tropic\n{44FF00}Dinghy\n{00FF51}Coastquard\n{00FFC8}Marquis\n{00C8FF}Jetmax\n{4400FF}Launch","»]Выбрать[«", "»]Выход[«");
			    case 5: ShowPlayerDialog(playerid, 1+6, DIALOG_STYLE_LIST,"{B3FF00}Тракторы","{FFBF00}Dozer\n{FFEA00}Tractor\n{E6FF00}Combine Harvester\n{B3FF00}Mower","»]Выбрать[«", "»]Выход[«");
			    case 6: ShowPlayerDialog(playerid, 1+7, DIALOG_STYLE_LIST,"{B3FF00}RC Игрушки","{FFBF00}RC Bandit\n{FFBF00}RC Baron\n{FFEA00}RC Raider\n{E6FF00}RC Goblin\n{B3FF00}RC Tiger\n{44FF00}RC Cam","»]Выбрать[«", "»]Выход[«");
			    case 7: ShowPlayerDialog(playerid, 1+8, DIALOG_STYLE_LIST,"{B3FF00}Военая техника","{FFBF00}Гидра\n{FFBF00}Хантер\n{FFEA00}Воробей\n{E6FF00}Танк","»]Выбрать[«", "»]Выход[«");
		    }
		}
	    else
	    {
		    new String[2048];
		    strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
		    strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
		    strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
		    strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
		    strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
		    strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
		    strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
		    strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
		    strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
		    ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
	}

    if(dialogid == 1338)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{DFDF02}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}Данаги\n{44FF00}Фермеры\n{00FF51}Подруги\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
			    case 1: ShowPlayerDialog(playerid, 1339, DIALOG_STYLE_INPUT, "{DFDF02}Смена скина", "{B3FF00}Введите ID скина:", "Выбрать", "");
		    }
		}
	    else
	    {
		    new String[2048];
		    strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
		    strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
		    strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
		    strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
		    strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
		    strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
		    strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
		    strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
		    strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
		    ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
	}
	if(dialogid == 1339)
	{
		if(response)
		{
			if(strval(inputtext) >= 0 && strval(inputtext) <= 299)
			{
	  			SetPlayerSkin(playerid,strval(inputtext));
	  			PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
			}
		}
		else ShowPlayerDialog(playerid, 1339, DIALOG_STYLE_INPUT, "{DFDF02}Смена скина", "{B3FF00}Введите ID скина , от 0 до 299:", "Выбрать", "");
	}
//===========================[  Новый вывод с dialog skin  + оптимизацыя] ===================================
    if(dialogid == SKINMENU)
	{
 	if(response)
	{
	switch(listitem)
	{
	case 0: ShowPlayerDialog(playerid, SKINMENU+20, DIALOG_STYLE_LIST,"{00FF00}Балласы","{FFBF00}Баллас 1\n{FFEA00}Баллас 2\n{E6FF00}Баллас 3","»]Выбрать[«", "»]Выход[«");
	case 1: ShowPlayerDialog(playerid, SKINMENU+2, DIALOG_STYLE_LIST,"{00FF00}Пляжные","{FFBF00}Пляжник 1\n{FFEA00}Пляжник 2\n{E6FF00}Пляжник 3\n{B3FF00}Пляжник 4\n{44FF00}Пляжник 5\n{00FF51}Пляжник 6\n{00FFC8}Пляжник 7\n{00C8FF}Пляжник 8\n{4400FF}Пляжник 9\n{6F00FF}Пляжник 10\n{9500FF}Пляжник 11","»]Выбрать[«", "»]Назад[«");
	case 2: ShowPlayerDialog(playerid, SKINMENU+3, DIALOG_STYLE_LIST,"{00FF00}Байкеры","{FFBF00}Байкер 1\n{FFEA00}Байкер 2\n{E6FF00}Байкер 3\n{B3FF00}Байкер 4","»]Выбрать[«", "»]Выход[«");
	case 3: ShowPlayerDialog(playerid, SKINMENU+4, DIALOG_STYLE_LIST,"{00FF00}ДаНаги","{FFBF00}ДаНаг 1\n{FFEA00}ДаНаг 2\n{E6FF00}ДаНаг 3","»]Выбрать[«", "»]Выход[«");
	case 4: ShowPlayerDialog(playerid, SKINMENU+5, DIALOG_STYLE_LIST,"{00FF00}Фермеры","{FFBF00}Фермер 1\n{FFEA00}Фермер 2\n{E6FF00}Фермер 3\n{B3FF00}Фермер 4\n{44FF00}Фермер 5\n{00FF51}Фермер 6\n{00FFC8}Фермер 7\n{00C8FF}Фермер 8\n{4400FF}Фермер 9\n{6F00FF}Фермер 10\n{9500FF}Фермер 11","»]Выбрать[«", "»]Назад[«");
	case 5: ShowPlayerDialog(playerid, SKINMENU+6, DIALOG_STYLE_LIST,"{00FF00}Девчонки","{FFBF00}Дэнис Робертсон\n{FFEA00}Барбара Штернварт\n{E6FF00}Елена Ванкшэйн\n{B3FF00}Мишель Уильямс\n{44FF00}Кати Жан\n{00FF51}Милли Перкинс","»]Выбрать[«", "»]Выход[«");
	case 6: ShowPlayerDialog(playerid, SKINMENU+7, DIALOG_STYLE_LIST,"{00FF00}Грув","{FFBF00}Си-джей\n{FFEA00}Фам 1\n{E6FF00}Фам 2\n{B3FF00}Фам 3","»]Выбрать[«", "»]Выход[«");
	case 7: ShowPlayerDialog(playerid, SKINMENU+8, DIALOG_STYLE_LIST,"{00FF00}Мафия","{FFBF00}Русская мафия 1\n{FFEA00}Русская мафия 2\n{E6FF00}Русская мафия 3\n{B3FF00}Мафия 1\n{44FF00}Мафия 2\n{00FF51}Мафия 3\n{00FFC8}Мафия 4","»]Выбрать[«", "»]Выход[«");
	case 8: ShowPlayerDialog(playerid, SKINMENU+9, DIALOG_STYLE_LIST,"{00FF00}Братаны","{FFBF00}Тенпени\n{FFEA00}Пуласки\n{E6FF00}Хернадез\n{B3FF00}Двейни\n{44FF00}Большой Смок\n{00FF51}Свиит\n{00FFC8}Райдер\n{00C8FF}Бос Мафии","»]Выбрать[«", "»]Выход[«");
	case 9: ShowPlayerDialog(playerid, SKINMENU+10, DIALOG_STYLE_LIST,"{00FF00}Пешеходы","{FFBF00}Пешеход 1\n{FFEA00}Пешеход 2\n{E6FF00}Пешеход 3\n{B3FF00}Пешеход 4\n{44FF00}Пешеход 5\n{00FF51}Пешеход 6\n{00FFC8}Пешеход 7\n{00C8FF}Пешеход 8\n{4400FF}Пешеход 9\n{6F00FF}Пешеход 10\n{9500FF}Пешеход 11\n{C300FF}Пешеход 12\n{FF00C4}Пешеход 13\n{FF0066}Пешеход 14\n{FF0000}Пешеход 15","»]Выбрать[«", "»]Назад[«");
	case 10: ShowPlayerDialog(playerid, SKINMENU+11, DIALOG_STYLE_LIST,"{00FF00}Разные","{FFBF00}Бомж 1\n{FFEA00}Бомж 2\n{E6FF00}Бомж 3\n{B3FF00}Бомж 4\n{44FF00}Бомж 5\n{00FF51}Наркоторговец\n{00FFC8}Элвис Пресли 1\n{00C8FF}Элвис Пресли 2\n{4400FF}Элвис Пресли 3\n{6F00FF}Гонщик\n{9500FF}Лётчик\n{C300FF}Камердинер\n{FF00C4}Афро американец\n{FF0066}Машинист","»]Выбрать[«", "»]Назад[«");
	case 11: ShowPlayerDialog(playerid, SKINMENU+12, DIALOG_STYLE_LIST,"{00FF00}Клубные","{FFBF00}Рабочий казино\n{FFEA00}Конторский служащий\n{E6FF00}Директор\n{B3FF00}Cекретарь 1\n{44FF00}Секретарь 2\n{00FF51}Секретарь 3\n{00FFC8}Человек кофе\n{00C8FF}Cluckin' Bell\nСвященник\nГостин. обслуживание\nМагазиник1\n{C300FF}Магазиник2\nПродавец\nБизнесмен\nБизнесмен 2\nПиццевоз\nПродавец\nБезопасность 1\nБезопасность 2\nСтроитель 1\nСтроитель 2\nСтроитель 3\nКлоун\nПрофессор","»]Выбрать[«", "»]Назад[«");
	case 12: ShowPlayerDialog(playerid, SKINMENU+13, DIALOG_STYLE_LIST,"{00FF00}Сервисные","{FFBF00}Федеральный агент 1\n{FFEA00}Федеральный агент 2\n{E6FF00}Федеральный агент 3\n{B3FF00}Федеральный агент 4\n{44FF00}Cкорая помощь 1\n{00FF51}Cкорая помощь 2\n{00FFC8}Cкорая помощь 3\n{00C8FF}Пожарник 1\n{4400FF}Пожарник 2\n{6F00FF}Пожарник 3\n{9500FF}LSPD\n{C300FF}SFPD\n{FF00C4}LVPD\n{FF0066}BCPD 1\n{FF003C}BCPD 2\n{FF0000}SA Bike Cop\n{FF003C}SWAT\n\n{FF0066}FBI\n{FF00C4}SA Army","»]Выбрать[«", "»]Назад[«");
	case 13: ShowPlayerDialog(playerid, SKINMENU+14, DIALOG_STYLE_LIST,"{00FF00}Рифы","{FFBF00}Рифа 1\n{FFEA00}Рифа 2\n{E6FF00}Рифа 3","»]Выбрать[«", "»]Назад[«");
	case 14: ShowPlayerDialog(playerid, SKINMENU+15, DIALOG_STYLE_LIST,"{00FF00}Спортсмены","{FFBF00}Гольфер 1\n{FFEA00}Гольфер 2\n{E6FF00}Альпинист\n{B3FF00}Горный Велосипедист 1\n{44FF00}Горный Велосипедист 2\n{00FF51}Боксёр 1\n{00FFC8}Боксёр 2\n{00C8FF}Роликобежец\n{4400FF}Бегун\n{6F00FF}Скилерер","»]Выбрать[«", "»]Назад[«");
	case 15: ShowPlayerDialog(playerid, SKINMENU+16, DIALOG_STYLE_LIST,"{00FF00}Триада","{FFBF00}Триада 1\n{FFEA00}Триада 2\n{E6FF00}Триада 3","»]Выбрать[«", "»]Назад[«");
	case 16: ShowPlayerDialog(playerid, SKINMENU+17, DIALOG_STYLE_LIST,"{00FF00}Азтеки","{FFBF00}Азтек 1\n{FFEA00}Азтек 2\n{E6FF00}Азтек 3","»]Выбрать[«", "»]Назад[«");
	case 17: ShowPlayerDialog(playerid, SKINMENU+18, DIALOG_STYLE_LIST,"{00FF00}Вагосы","{FFBF00}Вагос 1\n{FFEA00}Вагос 2\n{E6FF00}Вагос3","»]Выбрать[«", "»]Назад[«");
	case 18: ShowPlayerDialog(playerid, SKINMENU+19, DIALOG_STYLE_LIST,"{00FF00}Шлюхи","{FFBF00}Шлюхa 1\n{FFEA00}Шлюхa 2\n{E6FF00}Шлюхa 3\n{B3FF00}Шлюхa 4\n{44FF00}Шлюхa 5","»]Выбрать[«", "»]Назад[«");
	}
	}
 	return 1;
	}
//=============================BALLAS===================================//
    if(dialogid == SKINMENU+20)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 102);
			    case 1: SetPlayerSkin(playerid, 103);
			    case 2: SetPlayerSkin(playerid, 104);
		    }
		}
		else
		{
	    	ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+2)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 138);
			    case 1: SetPlayerSkin(playerid, 139);
			    case 2: SetPlayerSkin(playerid, 140);
			    case 3: SetPlayerSkin(playerid, 145);
			    case 4: SetPlayerSkin(playerid, 146);
			    case 5: SetPlayerSkin(playerid, 154);
			    case 6: SetPlayerSkin(playerid, 251);
			    case 7: SetPlayerSkin(playerid, 92);
			    case 8: SetPlayerSkin(playerid, 97);
			    case 9: SetPlayerSkin(playerid, 45);
			    case 10: SetPlayerSkin(playerid, 18);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}
    
    if(dialogid == SKINMENU+3)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 100);
			    case 1: SetPlayerSkin(playerid, 247);
			    case 2: SetPlayerSkin(playerid, 248);
			    case 3: SetPlayerSkin(playerid, 254);
		    }
		}else
		{
	    	ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+4)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 121);
			    case 1: SetPlayerSkin(playerid, 122);
			    case 2: SetPlayerSkin(playerid, 123);
		    }
		}else
		{
	    	ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+5)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 128);
			    case 1: SetPlayerSkin(playerid, 129);
			    case 2: SetPlayerSkin(playerid, 130);
			    case 3: SetPlayerSkin(playerid, 131);
			    case 4: SetPlayerSkin(playerid, 132);
			    case 5: SetPlayerSkin(playerid, 133);
			    case 6: SetPlayerSkin(playerid, 196);
			    case 7: SetPlayerSkin(playerid, 197);
			    case 8: SetPlayerSkin(playerid, 198);
			    case 9: SetPlayerSkin(playerid, 199);
			    case 10: SetPlayerSkin(playerid, 31);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+6)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 195);
			    case 1: SetPlayerSkin(playerid, 190);
			    case 2: SetPlayerSkin(playerid, 191);
			    case 3: SetPlayerSkin(playerid, 192);
			    case 4: SetPlayerSkin(playerid, 193);
			    case 5: SetPlayerSkin(playerid, 194);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+7)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
		    case 0: SetPlayerSkin(playerid, 0);
		    case 1: SetPlayerSkin(playerid, 105);
		    case 2: SetPlayerSkin(playerid, 106);
		    case 3: SetPlayerSkin(playerid, 107);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+8)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 111);
			    case 1: SetPlayerSkin(playerid, 112);
			    case 2: SetPlayerSkin(playerid, 113);
			    case 3: SetPlayerSkin(playerid, 124);
			    case 4: SetPlayerSkin(playerid, 125);
			    case 5: SetPlayerSkin(playerid, 126);
			    case 6: SetPlayerSkin(playerid, 127);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+9)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 265);
			    case 1: SetPlayerSkin(playerid, 266);
			    case 2: SetPlayerSkin(playerid, 267);
			    case 3: SetPlayerSkin(playerid, 268);
			    case 4: SetPlayerSkin(playerid, 269);
			    case 5: SetPlayerSkin(playerid, 270);
			    case 6: SetPlayerSkin(playerid, 271);
			    case 7: SetPlayerSkin(playerid, 272);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+10)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 10);
			    case 1: SetPlayerSkin(playerid, 101);
			    case 2: SetPlayerSkin(playerid, 12);
			    case 3: SetPlayerSkin(playerid, 13);
			    case 4: SetPlayerSkin(playerid, 14);
			    case 5: SetPlayerSkin(playerid, 143);
			    case 6: SetPlayerSkin(playerid, 144);
			    case 7: SetPlayerSkin(playerid, 17);
			    case 8: SetPlayerSkin(playerid, 170);
			    case 9: SetPlayerSkin(playerid, 180);
			    case 10: SetPlayerSkin(playerid, 184);
			    case 11: SetPlayerSkin(playerid, 75);
			    case 12: SetPlayerSkin(playerid, 216);
			    case 13: SetPlayerSkin(playerid, 22);
			    case 14: SetPlayerSkin(playerid, 226);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+11)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 134);
			    case 1: SetPlayerSkin(playerid, 135);
			    case 2: SetPlayerSkin(playerid, 137);
			    case 3: SetPlayerSkin(playerid, 212);
			    case 4: SetPlayerSkin(playerid, 212);
			    case 5: SetPlayerSkin(playerid, 29);
			    case 6: SetPlayerSkin(playerid, 82);
			    case 7: SetPlayerSkin(playerid, 83);
			    case 8: SetPlayerSkin(playerid, 84);
			    case 9: SetPlayerSkin(playerid, 255);
			    case 10: SetPlayerSkin(playerid, 61);
			    case 11: SetPlayerSkin(playerid, 253);
			    case 12: SetPlayerSkin(playerid, 241);
			    case 13: SetPlayerSkin(playerid, 50);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+12)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 11);
			    case 1: SetPlayerSkin(playerid, 141);
			    case 2: SetPlayerSkin(playerid, 147);
			    case 3: SetPlayerSkin(playerid, 148);
			    case 4: SetPlayerSkin(playerid, 150);
			    case 5: SetPlayerSkin(playerid, 219);
			    case 6: SetPlayerSkin(playerid, 153);
			    case 7: SetPlayerSkin(playerid, 167);
			    case 8: SetPlayerSkin(playerid, 68);
			    case 9: SetPlayerSkin(playerid, 171);
			    case 10: SetPlayerSkin(playerid, 176);
			    case 11: SetPlayerSkin(playerid, 177);
			    case 12: SetPlayerSkin(playerid, 179);
			    case 13: SetPlayerSkin(playerid, 187);
			    case 14: SetPlayerSkin(playerid, 204);
			    case 15: SetPlayerSkin(playerid, 155);
			    case 16: SetPlayerSkin(playerid, 205);
			    case 17: SetPlayerSkin(playerid, 211);
			    case 18: SetPlayerSkin(playerid, 217);
			    case 19: SetPlayerSkin(playerid, 260);
			    case 20: SetPlayerSkin(playerid, 27);
			    case 21: SetPlayerSkin(playerid, 264);
			    case 22: SetPlayerSkin(playerid, 70);
			    case 23: SetPlayerSkin(playerid, 70);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+13)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 163);
			    case 1: SetPlayerSkin(playerid, 164);
			    case 2: SetPlayerSkin(playerid, 165);
			    case 3: SetPlayerSkin(playerid, 166);
			    case 4: SetPlayerSkin(playerid, 274);
			    case 5: SetPlayerSkin(playerid, 275);
			    case 6: SetPlayerSkin(playerid, 276);
			    case 7: SetPlayerSkin(playerid, 277);
			    case 8: SetPlayerSkin(playerid, 278);
			    case 9: SetPlayerSkin(playerid, 279);
			    case 10: SetPlayerSkin(playerid, 280);
			    case 11: SetPlayerSkin(playerid, 281);
			    case 12: SetPlayerSkin(playerid, 282);
			    case 13: SetPlayerSkin(playerid, 283);
			    case 14: SetPlayerSkin(playerid, 288);
			    case 15: SetPlayerSkin(playerid, 284);
			    case 16: SetPlayerSkin(playerid, 285);
			    case 17: SetPlayerSkin(playerid, 286);
			    case 18: SetPlayerSkin(playerid, 287);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+14)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 173);
			    case 1: SetPlayerSkin(playerid, 174);
			    case 2: SetPlayerSkin(playerid, 175);
			}
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+15)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 258);
			    case 1: SetPlayerSkin(playerid, 259);
			    case 2: SetPlayerSkin(playerid, 26);
			    case 3: SetPlayerSkin(playerid, 51);
			    case 4: SetPlayerSkin(playerid, 52);
			    case 5: SetPlayerSkin(playerid, 80);
			    case 6: SetPlayerSkin(playerid, 81);
			    case 7: SetPlayerSkin(playerid, 23);
			    case 8: SetPlayerSkin(playerid, 96);
			    case 9: SetPlayerSkin(playerid, 99);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+16)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 117);
			    case 1: SetPlayerSkin(playerid, 118);
			    case 2: SetPlayerSkin(playerid, 120);
	    	}
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+17)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 114);
			    case 1: SetPlayerSkin(playerid, 115);
			    case 2: SetPlayerSkin(playerid, 116);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}

    if(dialogid == SKINMENU+19)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerSkin(playerid, 152);
			    case 1: SetPlayerSkin(playerid, 207);
			    case 2: SetPlayerSkin(playerid, 245);
			    case 3: SetPlayerSkin(playerid, 246);
			    case 4: SetPlayerSkin(playerid, 178);
		    }
		}else
		{
			ShowPlayerDialog(playerid, SKINMENU, DIALOG_STYLE_LIST, "{00FF00}Выбор скина", "{FFBF00}Балласы\n{FFEA00}Пляжные\n{E6FF00}Байкеры\n{B3FF00}ДаНаги\n{44FF00}Фермеры\n{00FF51}Девчонки\n{00FFC8}Гроуверы\n{00C8FF}Мафиози\n{4400FF}Братаны\n{6F00FF}Пешеходы\n{9500FF}Разные\n{C300FF}Клубные\n{FF00C4}Сервисные\n{FF0066}Рифа\n{FF003C}Спортсмены\n{FF0000}Триады\n{FF003C}Азтек\n{FF0066}Вагосы\n{FF00C4}Шлюхи","»]Выбрать[«", "»]Выход[«");
	    }
	}
//номер авто--------------------
	if(dialogid == 4721)
	{
		if(response)
		{
            new Float:x,Float:y,Float:z,Float:ang;
            SetVehicleNumberPlate(GetPlayerVehicleID(playerid), inputtext);
			GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
			GetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
			PutPlayerInVehicle(playerid,GetPlayerVehicleID(playerid),0);
			SetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
   		}else
		{
 			SendClientMessage(playerid,0xFFFFFFFF,"Ты отменил!");
 		}
		return 1;
	}

//==================================[Авто]=================================================/
    if(dialogid == 1+1)
	{
	if(response)
	{
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
        CarSpawner(playerid,411);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
	if(listitem == 1)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
	    CarSpawner(playerid,506);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
	if(listitem == 2)
	{
        if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
	    CarSpawner(playerid,429);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
	if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,451);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 4)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
	    CarSpawner(playerid,477);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 5)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,444);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 6)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,541);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 7)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,603);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 8)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,560);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 9)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
        CarSpawner(playerid,579);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 10)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
	    CarSpawner(playerid,558);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 11)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,480);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 12)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
	    CarSpawner(playerid,562);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 13)
	{
        if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,500);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}
    if(listitem == 14)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,555);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Авто");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $2000");
     }}}}
//================================[Самолёты]======================================================
    if(dialogid == 1+3){
	if(response){
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,592);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
	if(listitem == 1)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,577);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
	if(listitem == 2)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,511);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
	if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,512);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 4)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,593);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 5)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,553);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 6)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,476);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 7)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,519);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
		SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 8)
	{
    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,460);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 9)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,513);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Самолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}}}
 //====================================[Тракторы]=================================
    if(dialogid == 1+6){
	if(response){
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,486);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Покупка Трактора]: {00FF00}У вас уже есть Трактор");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Покупка Трактора]: {00FF00}У тебя нет $2000");
     }}
	if(listitem == 1)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,531);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Покупка Трактора]: {00FF00}У вас уже есть Трактор");
		}}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Покупка Трактора]: {00FF00}У тебя нет $2000");
     }}
	if(listitem == 2)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,532);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Покупка Трактора]: {00FF00}У вас уже есть Трактор");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Покупка Трактора]: {00FF00}У тебя нет $2000");
     }}
	if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 2000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,572);
        GivePlayerMoney(playerid, -2000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $2000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Покупка Трактора]: {00FF00}У вас уже есть Трактор");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Покупка Трактора]: {00FF00}У тебя нет $2000");
     }}}}

///============================================[RC игрушки]================================
    if(dialogid == 1+7){
	if(response){
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,441);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[RC Игрушка]: {00FF00}У вас уже есть RC Игрушка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[RC Игрушка]: {00FF00}У тебя нет $3000");
     }}
	if(listitem == 1)
	{
	   if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,464);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[RC Игрушка]: {00FF00}У вас уже есть RC Игрушка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[RC Игрушка]: {00FF00}У тебя нет $3000");
     }}
	if(listitem == 2)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,465);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[RC Игрушка]: {00FF00}У вас уже есть RC Игрушка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[RC Игрушка]: {00FF00}У тебя нет $3000");
     }}
	if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,501);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[RC Игрушка]: {00FF00}У вас уже есть RC Игрушка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[RC Игрушка]: {00FF00}У тебя нет $3000");
     }}
    if(listitem == 4)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,564);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[RC Игрушка]: {00FF00}У вас уже есть RC Игрушка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[RC Игрушка]: {00FF00}У тебя нет $3000");
     }}
    if(listitem == 5)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,594);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);}
        else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[RC Игрушка]: {00FF00}У вас уже есть RC Игрушка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[RC Игрушка]: {00FF00}У тебя нет $3000");
     }}}}
//====================================[Военая техника]===========================================
    if(dialogid == 1+8)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(GetPlayerMoney(playerid) < 10000)return SendClientMessage(playerid, -1, "{FF0000}[Военая техника]: {00FF00}У тебя нет $10000");
		        if(GetPlayerScore(playerid) < 150) return SendClientMessage(playerid,-1, "*** {FF0000}Чтобы купить Гидру вам нужно иметь 150 SCORE...");
				if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,-1,"{FF0000}[Военая техника]: {00FF00}У вас уже есть транспорт");
				CarSpawner(playerid,520);
		        GivePlayerMoney(playerid, -10000);
		        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $10000",2000,3);
			}
		   	if(listitem == 1)
			{
				if(GetPlayerMoney(playerid) < 10000)return SendClientMessage(playerid, -1, "{FF0000}[Военая техника]: {00FF00}У тебя нет $10000");
		        if(GetPlayerScore(playerid) < 250) return SendClientMessage(playerid,0xAA3333AA, "*** {FF0000}Чтобы купить Хантер вам нужно иметь 250 SCORE...");
				if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,-1,"{FF0000}[Военая техника]: {00FF00}У вас уже есть транспорт");
				CarSpawner(playerid,425);
		        GivePlayerMoney(playerid, -10000);
		        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $10000",2000,3);
    		}
		    if(listitem == 2)
			{
				if(GetPlayerMoney(playerid) < 10000)return SendClientMessage(playerid, -1, "{FF0000}[Военая техника]: {00FF00}У тебя нет $10000");
		        if(GetPlayerScore(playerid) < 100) return SendClientMessage(playerid,0xAA3333AA, "*** {FF0000}Чтобы купить Воробей вам нужно иметь 100 SCORE...");
				if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,-1,"{FF0000}[Военая техника]: {00FF00}У вас уже есть транспорт");
				CarSpawner(playerid,447);
		        GivePlayerMoney(playerid, -10000);
		        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $10000",2000,3);
			}
		    if(listitem == 3)
			{
				if(GetPlayerMoney(playerid) < 10000)return SendClientMessage(playerid, -1, "{FF0000}[Военая техника]: {00FF00}У тебя нет $10000");
		        if(GetPlayerScore(playerid) < 200) return SendClientMessage(playerid,0xAA3333AA, "*** {FF0000}Чтобы купить Танк вам нужно иметь 200 SCORE...");
				if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,-1,"{FF0000}[Военая техника]: {00FF00}У вас уже есть транспорт");
				CarSpawner(playerid,432);
		        GivePlayerMoney(playerid, -10000);
		        GameTextForPlayer(playerid, "~y~buy ~b~Tank ~r~-10000$",2000,3);
			}
		}
	}
//===================================[Лодки]==========================================
    if(dialogid == 1+5)
	{
	if(response)
	{
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,446);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
	if(listitem == 1)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,452);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
	if(listitem == 2)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,453);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
	if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,454);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
    if(listitem == 4)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,473);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
    if(listitem == 5)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,472);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
    if(listitem == 6)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
	    CarSpawner(playerid,484);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
    if(listitem == 7)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,493);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}
    if(listitem == 8)
	{
	    if (GetPlayerMoney(playerid) >= 1500){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,595);
        GivePlayerMoney(playerid, -1500);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1500",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "{FF0000}[Лодки]: {00FF00}У вас уже есть Лодка");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "{FF0000}[Лодки]: {00FF00}У тебя нет $1500");
     }}}}

    if(dialogid == 1+4)
	{
	if(response)
	{
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,548);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
	if(listitem == 1)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,417);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
	if(listitem == 2)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,487);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,488);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 4)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,497);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 5)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,563);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}
    if(listitem == 6)
	{
	    if (GetPlayerMoney(playerid) >= 3000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,447);
        GivePlayerMoney(playerid, -3000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $3000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Вертолёт");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $3000");
     }}}}

    if(dialogid == 1+2)
	{
	if(response)
	{
	if(listitem == 0)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,581);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
	if(listitem == 1)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,509);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
	if(listitem == 2)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,481);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
	if(listitem == 3)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,463);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
  	if(listitem == 4)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,521);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
   	if(listitem == 5)
	{
        if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,586);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
    if(listitem == 6)
	{
        if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,510);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
    if(listitem == 7)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,522);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
    if(listitem == 8)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,461);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
    if(listitem == 9)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,448);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
    if(listitem == 10)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,462);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}
    if(listitem == 11)
	{
	    if (GetPlayerMoney(playerid) >= 1000){
        if (!IsPlayerInAnyVehicle(playerid)) {
		CarSpawner(playerid,468);
        GivePlayerMoney(playerid, -1000);
        GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~y~BS ZOTPATNLN $1000",2000,3);
		}else{
        SendClientMessage(playerid, COLOR_BLUE, "У вас уже есть Мотоцикл");
        }}else{
        SendClientMessage(playerid, COLOR_GREEN, "У тебя нет $1000");
     }}}}

    if(dialogid == 1008)
	{
	    if(response)
	    {
	        if(!strlen(inputtext))
	        {
            new String[4000];
            strins(String,"{FFF000}Чтобы включить анимацию, введите её ид от 0-30!\n",strlen(String));
            strins(String,"\n",strlen(String));
            strins(String,"{FFFFFF}0.{B85FF3}Упасть на спину\t\t{FFFFFF}22.{B85FF3}Сцiкати\n",strlen(String));
            strins(String,"{FFFFFF}1.{B85FF3}Контузится\t\t\t{FFFFFF}23.{B85FF3}Укрыться\n",strlen(String));
            strins(String,"{FFFFFF}2.{B85FF3}Удар плечём 3\t\t{FFFFFF}24.{B85FF3}Сесть\n",strlen(String));
            strins(String,"{FFFFFF}3.{B85FF3}Поднять руки\t\t\t{FFFFFF}25.{B85FF3}Разговаривать\n",strlen(String));
            strins(String,"{FFFFFF}4.{B85FF3}Ударить по жопе\t\t{FFFFFF}26.{B85FF3}Семяться\n",strlen(String));
            strins(String,"{FFFFFF}5.{B85FF3}Пьяный в жопу\t\t{FFFFFF}27.{B85FF3}Танец №1\n",strlen(String));
            strins(String,"{FFFFFF}6.{B85FF3}Пьяный в жопу 2\t\t{FFFFFF}28.{B85FF3}Танец №2\n",strlen(String));
            strins(String,"{FFFFFF}7.{B85FF3}Смеяться\t\t\t{FFFFFF}26.{B85FF3}Танец №3\n",strlen(String));
            strins(String,"{FFFFFF}8.{B85FF3}RAP\t\t\t\t{FFFFFF}30.{B85FF3}Танец №4\n",strlen(String));
            strins(String,"{FFFFFF}9.{B85FF3}Сложить руки\n",strlen(String));
            strins(String,"{FFFFFF}10.{B85FF3}Fuck you\n",strlen(String));
            strins(String,"{FFFFFF}11.{B85FF3}Балончик краски\n",strlen(String));
            strins(String,"{FFFFFF}12.{B85FF3}Чисать машонку\n",strlen(String));
            strins(String,"{FFFFFF}13.{B85FF3}Стать боком\n",strlen(String));
            strins(String,"{FFFFFF}14.{B85FF3}Лечь 1\n",strlen(String));
            strins(String,"{FFFFFF}15.{B85FF3}Лечь 2\n",strlen(String));
            strins(String,"{FFFFFF}16.{B85FF3}Лечь 3\n",strlen(String));
            strins(String,"{FFFFFF}17.{B85FF3}Рыболов\n",strlen(String));
            strins(String,"{FFFFFF}18.{B85FF3}Давай-Давай-Давай\n",strlen(String));
            strins(String,"{FFFFFF}19.{B85FF3}ЭЙ СЛЫШЬ, ЧЁ?\n",strlen(String));
            strins(String,"{FFFFFF}20.{B85FF3}Флаг\n",strlen(String));
            strins(String,"{FFFFFF}21.{B85FF3}Приветствие\n",strlen(String));
            strins(String,"\n",strlen(String));
            strins(String,"{FF0000}P.S Некоторые анимации могут работать со 2 раза!!\n",strlen(String));
            ShowPlayerDialog(playerid,1008,DIALOG_STYLE_INPUT,"{DFDF02}»»» Anim System «««",String,"»[Выбрать]«","»[Назад]«");
            return 1;
	        }
	        new id = strval(inputtext);
			if(id == 0) { LoopingAnim(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0);}
			else if(id == 1) { LoopingAnim(playerid, "PED","FLOOR_hit_f", 4.0, 1, 0, 0, 0, 0);}
			else if(id == 2) { OnePlayAnim(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0);}
			else if(id == 3) { LoopingAnim(playerid, "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, 0);}
			else if(id == 4) { OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);}
			else if(id == 5) { LoopingAnim(playerid,"PAULNMAC", "pnm_loop_a", 3.0, 1, 0, 0, 0, 0);}
			else if(id == 6) { LoopingAnim(playerid,"PAULNMAC", "pnm_loop_b", 3.0, 1, 0, 0, 0, 0);}
			else if(id == 7) { OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);}
			else if(id == 8) { LoopingAnim(playerid,"RAPPING","RAP_C_Loop",4.0,1,0,0,0,0);}
			else if(id == 9) { LoopingAnim(playerid,"OTB", "wtchrace_loop", 4.0, 1, 0, 0, 0, 0);}
			else if(id == 10) { LoopingAnim(playerid,"RIOT", "RIOT_FUKU",4.1,0,1,1,1,0);}
			else if(id == 11) { OnePlayAnim(playerid,"SPRAYCAN","spraycan_full",4.0,0,0,0,0,0);}
			else if(id == 12) { LoopingAnim(playerid,"MISC","Scratchballs_01",3.0,1,0,0,0,0);}
			else if(id == 13) { LoopingAnim(playerid,"MISC","Plyrlean_loop",4.0,0,1,1,1,0);}
			else if(id == 14) { LoopingAnim(playerid,"CAR", "Fixn_Car_Loop", 4.0, 1, 0, 0, 0, 0);}
			else if(id == 15) { BackAnim(playerid,"SUNBATHE","parksit_m_in",3.0,0,1,1,1,0,1);}
			else if(id == 16) { LoopingAnim(playerid,"SUNBATHE","batherdown",3.0,0,1,1,1,0);}
			else if(id == 17) { ApplyAnimation(playerid,"SWORD","sword_block",4.1,0,1,1,1,1);}
			else if(id == 18) { LoopingAnim(playerid,"RIOT","RIOT_CHANT",4.0,1,1,1,1,0);}
			else if(id == 19) { LoopingAnim(playerid,"PED","run_fatold",4.0,1,1,1,1,1);}
			else if(id == 20) { OnePlayAnim(playerid,"CAR","flag_drop",3.0,0,0,0,0,0);}
			else if(id == 21) { LoopingAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);}
			else if(id == 22) { SetPlayerSpecialAction(playerid, 68);}
			else if(id == 23) { LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);}
			else if(id == 24) { LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);}
            else if(id == 25) { OnePlayAnim(playerid,"PED","IDLE_CHAT",4.0,0,0,0,0,0);}
			else if(id == 26) { OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);}
			else if(id == 27) { SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);}
			else if(id == 28) { SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);}
			else if(id == 29) { SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);}
			else if(id == 30) { SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);}
			else
			{
            new String[4000];
            strins(String,"{FFF000}Чтобы включить анимацию, введите её ид от 0-30!\n",strlen(String));
            strins(String,"\n",strlen(String));
            strins(String,"{FFFFFF}0.{B85FF3}Упасть на спину\t\t{FFFFFF}22.{B85FF3}Сцiкати\n",strlen(String));
            strins(String,"{FFFFFF}1.{B85FF3}Контузится\t\t\t{FFFFFF}23.{B85FF3}Укрыться\n",strlen(String));
            strins(String,"{FFFFFF}2.{B85FF3}Удар плечём 3\t\t{FFFFFF}24.{B85FF3}Сесть\n",strlen(String));
            strins(String,"{FFFFFF}3.{B85FF3}Поднять руки\t\t\t{FFFFFF}25.{B85FF3}Разговаривать\n",strlen(String));
            strins(String,"{FFFFFF}4.{B85FF3}Ударить по жопе\t\t{FFFFFF}26.{B85FF3}Семяться\n",strlen(String));
            strins(String,"{FFFFFF}5.{B85FF3}Пьяный в жопу\t\t{FFFFFF}27.{B85FF3}Танец №1\n",strlen(String));
            strins(String,"{FFFFFF}6.{B85FF3}Пьяный в жопу 2\t\t{FFFFFF}28.{B85FF3}Танец №2\n",strlen(String));
            strins(String,"{FFFFFF}7.{B85FF3}Смеяться\t\t\t{FFFFFF}26.{B85FF3}Танец №3\n",strlen(String));
            strins(String,"{FFFFFF}8.{B85FF3}RAP\t\t\t\t{FFFFFF}30.{B85FF3}Танец №4\n",strlen(String));
            strins(String,"{FFFFFF}9.{B85FF3}Сложить руки\n",strlen(String));
            strins(String,"{FFFFFF}10.{B85FF3}Fuck you\n",strlen(String));
            strins(String,"{FFFFFF}11.{B85FF3}Балончик краски\n",strlen(String));
            strins(String,"{FFFFFF}12.{B85FF3}Чисать машонку\n",strlen(String));
            strins(String,"{FFFFFF}13.{B85FF3}Стать боком\n",strlen(String));
            strins(String,"{FFFFFF}14.{B85FF3}Лечь 1\n",strlen(String));
            strins(String,"{FFFFFF}15.{B85FF3}Лечь 2\n",strlen(String));
            strins(String,"{FFFFFF}16.{B85FF3}Лечь 3\n",strlen(String));
            strins(String,"{FFFFFF}17.{B85FF3}Рыболов\n",strlen(String));
            strins(String,"{FFFFFF}18.{B85FF3}Давай-Давай-Давай\n",strlen(String));
            strins(String,"{FFFFFF}19.{B85FF3}ЭЙ СЛЫШЬ, ЧЁ?\n",strlen(String));
            strins(String,"{FFFFFF}20.{B85FF3}Флаг\n",strlen(String));
            strins(String,"{FFFFFF}21.{B85FF3}Приветствие\n",strlen(String));
            strins(String,"\n",strlen(String));
            strins(String,"{FF0000}P.S Некоторые анимации могут работать со 2 раза!!\n",strlen(String));
            ShowPlayerDialog(playerid,1008,DIALOG_STYLE_INPUT,"{DFDF02}»»» Anim System «««",String,"»[Выбрать]«","»[Назад]«");
           }
		}
	}


    if(dialogid == 888)// System 
	{
	    if(response)
	    {
	        if(!strlen(inputtext))
	        {
		    	new String[4000];
	        	strins(String,"{FFF000}Введите ид цвета от 0-34!\n",strlen(String));
	        	strins(String,"\n",strlen(String));
	        	strins(String,"{FFFFFF}0.{AA3333}[|||||||]\t\t{FFFFFF}18.{4B00B0}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}1.{AFAFAF}[|||||||]\t\t{FFFFFF}19.{FFFF82}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}2.{33AA33}[|||||||]\t\t{FFFFFF}20.{7CFC00}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}3.{FF9900}[|||||||]\t\t{FFFFFF}21.{32CD32}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}4.{0000BB}[|||||||]\t\t{FFFFFF}22.{191970}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}5.{33CCFF}[|||||||]\t\t{FFFFFF}23.{800000}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}6.{FFFF00}[|||||||]\t\t{FFFFFF}24.{808000}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}7.{10F441}[|||||||]\t\t{FFFFFF}25.{FF4500}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}8.{000080}[|||||||]\t\t{FFFFFF}26.{FFC0CB}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}9.{F0F8FF}[|||||||]\t\t{FFFFFF}27.{00FF7F}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}10.{DC143C}[|||||||]\t{FFFFFF}28.{FF6347}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}11.{6495ED}[|||||||]\t{FFFFFF}29.{9ACD32}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}12.{FFE4C4}[|||||||]\t{FFFFFF}30.{83BFBF}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}13.{7FFF00}[|||||||]\t{FFFFFF}31.{8B008B}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}14.{A52A2A}[|||||||]\t{FFFFFF}32.{DC143C}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}15.{FF7F50}[|||||||]\t{FFFFFF}33.{EFEFF7}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}16.{B8860B}[|||||||]\t{FFFFFF}34.{330066}[|||||||]\n",strlen(String));
	        	strins(String,"{FFFFFF}17.{ADFF2F}[|||||||]\n",strlen(String));
	        	ShowPlayerDialog(playerid,888,DIALOG_STYLE_INPUT,"{DFDF02}»»» Цвет «««",String,"»[Выбрать]«","»[Назад]«");
		        return 1;
	        }
	        new id = strval(inputtext);
			if(id == 0) { SetPlayerColor(playerid,COLOR_RED);SendClientMessage(playerid, COLOR_RED, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {AA3333}[|||||||] id 0"); }
			else if(id == 1) { SetPlayerColor(playerid,0xAFAFAFAA);SendClientMessage(playerid, 0xAFAFAFAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {AFAFAF}[|||||||] id 1"); }
			else if(id == 2) { SetPlayerColor(playerid,COLOR_GREEN);SendClientMessage(playerid, COLOR_GREEN, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {33AA33}[|||||||] id 2"); }
			else if(id == 3) { SetPlayerColor(playerid,0xFF9900AA);SendClientMessage(playerid, 0xFF9900AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FF9900}[|||||||] id 3"); }
			else if(id == 4) { SetPlayerColor(playerid,COLOR_BLUE);SendClientMessage(playerid, COLOR_BLUE, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {0000BB}[|||||||] id 4"); }
			else if(id == 5) { SetPlayerColor(playerid,0x33CCFFAA);SendClientMessage(playerid, 0x33CCFFAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {33CCFF}[|||||||] id 5"); }
			else if(id == 6) { SetPlayerColor(playerid,0xFFFF00AA);SendClientMessage(playerid, 0xFFFF00AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FFFF00}[|||||||] id 6"); }
			else if(id == 7) { SetPlayerColor(playerid,0x10F441AA);SendClientMessage(playerid, 0x10F441AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {10F441}[|||||||] id 7"); }
			else if(id == 8) { SetPlayerColor(playerid,0x000080AA);SendClientMessage(playerid, 0x000080AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {000080}[|||||||] id 8"); }
			else if(id == 9) { SetPlayerColor(playerid,0xF0F8FFAA);SendClientMessage(playerid, 0xF0F8FFAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {F0F8FF}[|||||||] id 9"); }
			else if(id == 10) { SetPlayerColor(playerid,0xDC143CAA);SendClientMessage(playerid, 0xDC143CAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {DC143C}[|||||||] id 10"); }
			else if(id == 11) { SetPlayerColor(playerid,0x6495EDAA);SendClientMessage(playerid, 0x6495EDAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {6495ED}[|||||||] id 11"); }
			else if(id == 12) { SetPlayerColor(playerid,0xFFE4C4AA);SendClientMessage(playerid, 0xFFE4C4AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FFE4C4}[|||||||] id 12"); }
			else if(id == 13) { SetPlayerColor(playerid,0x7FFF00AA);SendClientMessage(playerid, 0x7FFF00AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {7FFF00}[|||||||] id 13"); }
			else if(id == 14) { SetPlayerColor(playerid,0xA52A2AAA);SendClientMessage(playerid, 0xA52A2AAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {A52A2A}[|||||||] id 14"); }
			else if(id == 15) { SetPlayerColor(playerid,0xFF7F50AA);SendClientMessage(playerid, 0xFF7F50AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FF7F50}[|||||||] id 15"); }
			else if(id == 16) { SetPlayerColor(playerid,0xB8860BAA);SendClientMessage(playerid, 0xB8860BAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {B8860B}[|||||||] id 16"); }
			else if(id == 17) { SetPlayerColor(playerid,0xADFF2FAA);SendClientMessage(playerid, 0xADFF2FAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {ADFF2F}[|||||||] id 17"); }
			else if(id == 18) { SetPlayerColor(playerid,0x4B00B0AA);SendClientMessage(playerid, 0x4B00B0AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {4B00B0}[|||||||] id 18"); }
			else if(id == 19) { SetPlayerColor(playerid,0xFFFF82AA);SendClientMessage(playerid, 0xFFFF82AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FFFF82}[|||||||] id 19"); }
			else if(id == 20) { SetPlayerColor(playerid,0x7CFC00AA);SendClientMessage(playerid, 0x7CFC00AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {7CFC00}[|||||||] id 20"); }
			else if(id == 21) { SetPlayerColor(playerid,0x32CD32AA);SendClientMessage(playerid, 0x32CD32AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {32CD32}[|||||||] id 21"); }
			else if(id == 22) { SetPlayerColor(playerid,0x191970AA);SendClientMessage(playerid, 0x191970AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {191970}[|||||||] id 22"); }
			else if(id == 23) { SetPlayerColor(playerid,0x800000AA);SendClientMessage(playerid, 0x800000AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {800000}[|||||||] id 23"); }
			else if(id == 24) { SetPlayerColor(playerid,0x808000AA);SendClientMessage(playerid, 0x808000AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {808000}[|||||||] id 24"); }
			else if(id == 25) { SetPlayerColor(playerid,0xFF4500AA);SendClientMessage(playerid, 0xFF4500AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FF4500}[|||||||] id 25"); }
			else if(id == 26) { SetPlayerColor(playerid,0xFFC0CBAA);SendClientMessage(playerid, 0xFFC0CBAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FFC0CB}[|||||||] id 26"); }
			else if(id == 27) { SetPlayerColor(playerid,0x00FF7FAA);SendClientMessage(playerid, 0x00FF7FAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {00FF7F}[|||||||] id 27"); }
			else if(id == 28) { SetPlayerColor(playerid,0xFF6347AA);SendClientMessage(playerid, 0xFF6347AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {FF6347}[|||||||] id 28"); }
			else if(id == 29) { SetPlayerColor(playerid,0x9ACD32AA);SendClientMessage(playerid, 0x9ACD32AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {9ACD32}[|||||||] id 29"); }
			else if(id == 30) { SetPlayerColor(playerid,0x83BFBFAA);SendClientMessage(playerid, 0x83BFBFAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {83BFBF}[|||||||] id 30"); }
			else if(id == 31) { SetPlayerColor(playerid,0x8B008BAA);SendClientMessage(playerid, 0x8B008BAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {8B008B}[|||||||] id 31"); }
			else if(id == 32) { SetPlayerColor(playerid,0xDC143CAA);SendClientMessage(playerid, 0xDC143CAA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {DC143C}[|||||||] id 32"); }
			else if(id == 33) { SetPlayerColor(playerid,0xEFEFF7AA);SendClientMessage(playerid, 0xEFEFF7AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {EFEFF7}[|||||||] id 33"); }
			else if(id == 34) { SetPlayerColor(playerid,0x330066AA);SendClientMessage(playerid, 0x330066AA, "{FFE4C4}[S{FFFFFF}ys{8B008B}te{DC143C}m C{FF4500}ol{7CFC00}or{FF9900}s]: {FFFFFF}Вы поменяли себе цвет ника на {330066}[|||||||] id 34"); }
			else
			{
	 	    new String[4000];
      	    strins(String,"{FFF000}Введите ид цвета от 0-34!\n",strlen(String));
        	strins(String,"\n",strlen(String));
        	strins(String,"{FFFFFF}0.{AA3333}[|||||||]\t\t{FFFFFF}18.{4B00B0}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}1.{AFAFAF}[|||||||]\t\t{FFFFFF}19.{FFFF82}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}2.{33AA33}[|||||||]\t\t{FFFFFF}20.{7CFC00}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}3.{FF9900}[|||||||]\t\t{FFFFFF}21.{32CD32}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}4.{0000BB}[|||||||]\t\t{FFFFFF}22.{191970}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}5.{33CCFF}[|||||||]\t\t{FFFFFF}23.{800000}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}6.{FFFF00}[|||||||]\t\t{FFFFFF}24.{808000}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}7.{10F441}[|||||||]\t\t{FFFFFF}25.{FF4500}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}8.{000080}[|||||||]\t\t{FFFFFF}26.{FFC0CB}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}9.{F0F8FF}[|||||||]\t\t{FFFFFF}27.{00FF7F}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}10.{DC143C}[|||||||]\t{FFFFFF}28.{FF6347}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}11.{6495ED}[|||||||]\t{FFFFFF}29.{9ACD32}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}12.{FFE4C4}[|||||||]\t{FFFFFF}30.{83BFBF}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}13.{7FFF00}[|||||||]\t{FFFFFF}31.{8B008B}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}14.{A52A2A}[|||||||]\t{FFFFFF}32.{DC143C}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}15.{FF7F50}[|||||||]\t{FFFFFF}33.{EFEFF7}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}16.{B8860B}[|||||||]\t{FFFFFF}34.{330066}[|||||||]\n",strlen(String));
        	strins(String,"{FFFFFF}17.{ADFF2F}[|||||||]\n",strlen(String));
        	ShowPlayerDialog(playerid,888,DIALOG_STYLE_INPUT,"{DFDF02}»»» Цвет «««",String,"»[Выбрать]«","»[Назад]«");
           }
		}
	}

    if(dialogid == 1000)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0:
			    {
			        new String[1000];
			        strins(String,"{FFFFFF}1.{FE2E2E}Rock\r\n",strlen(String));
			        strins(String,"{FFFFFF}2.{FE9A2E}Pop\r\n",strlen(String));
			        strins(String,"{FFFFFF}3.{C8FE2E}House & Dance\r\n",strlen(String));
			        strins(String,"{FFFFFF}4.{D358F7}Alternative\r\n",strlen(String));
			        strins(String,"{FFFFFF}5.{81BEF7}Easy Listening\r\n",strlen(String));
			        ShowPlayerDialog(playerid,5323,DIALOG_STYLE_LIST,"{00ACFF}»»» {FF0000}Жанры{00ACFF} «««",String,"»[Включить]«","»[Назад]«");
			    }
			    case 1:
			    {
			        new String[1000];
			        strins(String,"{FFFFFF}1.{FF0000}Radio Record\r\n",strlen(String));
			        strins(String,"{FFFFFF}2.{FF2C00}Record Teodor\r\n",strlen(String));
			        strins(String,"{FFFFFF}3.{FF5000}Record Dancecore\r\n",strlen(String));
			        strins(String,"{FFFFFF}4.{FF8700}Русский Шансон\r\n",strlen(String));
			        strins(String,"{FFFFFF}5.{FFA700}Retro\r\n",strlen(String));
			        strins(String,"{FFFFFF}6.{FFDC00}Record DubStep\r\n",strlen(String));
			        strins(String,"{FFFFFF}7.{FFFB00}Record Дискотека 90-х\r\n",strlen(String));
			        strins(String,"{FFFFFF}8.{C4FF00}Record Club\r\n",strlen(String));
			        strins(String,"{FFFFFF}9.{C4FF00}Hip-Hop\r\n",strlen(String));
			        strins(String,"{FFFFFF}10.{7BFF00}Европа +\r\n",strlen(String));
			        strins(String,"{FFFFFF}11.{00FF00}Radio HardStyle\r\n",strlen(String));
			        strins(String,"{FFFFFF}12.{00FF00}Radio HardRock\r\n",strlen(String));
			        strins(String,"{00FF1E}Выключить радио\r\n",strlen(String));
			        ShowPlayerDialog(playerid,7893,DIALOG_STYLE_LIST,"{00ACFF}»»» {FF0000}Radio{00ACFF} «««",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 2:ShowPlayerDialog(playerid,83,2,"{DFDF02}»»» Работы «««","{C2FE0E}Работа Водолаза\n{B0FF0D}Работа Археолога\n{8CFF0D}Работа Курьера\n{14FE0E}Работа Грузчика\n{0DFF98}Работа Дальнобойщика\n{0DFF98}Работа Золотника","»[Выбрать]«","»[Назад]«");
			    case 3:ShowPlayerDialog(playerid,80,2,"{DFDF02}Выпивка","{31EEFD}Пиво\n{32FCCE}Текила\n{31FD9C}Спрайт\n{33FB5B}Сигарета\n{57F935}Отрезвитель","»[Выбрать]«","»[Отмена]«");
			    case 4:
			    {
					new String[4000];
			        strins(String,"{FFF000}Чтобы включить анимацию, введите её ид от 0-30!\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FFFFFF}0.{B85FF3}Упасть на спину\t\t{FFFFFF}22.{B85FF3}Сцiкати\n",strlen(String));
			        strins(String,"{FFFFFF}1.{B85FF3}Контузится\t\t\t{FFFFFF}23.{B85FF3}Укрыться\n",strlen(String));
			        strins(String,"{FFFFFF}2.{B85FF3}Удар плечём 3\t\t{FFFFFF}24.{B85FF3}Сесть\n",strlen(String));
			        strins(String,"{FFFFFF}3.{B85FF3}Поднять руки\t\t\t{FFFFFF}25.{B85FF3}Разговаривать\n",strlen(String));
			        strins(String,"{FFFFFF}4.{B85FF3}Ударить по жопе\t\t{FFFFFF}26.{B85FF3}Семяться\n",strlen(String));
			        strins(String,"{FFFFFF}5.{B85FF3}Пьяный в жопу\t\t{FFFFFF}27.{B85FF3}Танец №1\n",strlen(String));
			        strins(String,"{FFFFFF}6.{B85FF3}Пьяный в жопу 2\t\t{FFFFFF}28.{B85FF3}Танец №2\n",strlen(String));
			        strins(String,"{FFFFFF}7.{B85FF3}Смеяться\t\t\t{FFFFFF}26.{B85FF3}Танец №3\n",strlen(String));
			        strins(String,"{FFFFFF}8.{B85FF3}RAP\t\t\t\t{FFFFFF}30.{B85FF3}Танец №4\n",strlen(String));
			        strins(String,"{FFFFFF}9.{B85FF3}Сложить руки\n",strlen(String));
			        strins(String,"{FFFFFF}10.{B85FF3}Fuck you\n",strlen(String));
			        strins(String,"{FFFFFF}11.{B85FF3}Балончик краски\n",strlen(String));
			        strins(String,"{FFFFFF}12.{B85FF3}Чисать машонку\n",strlen(String));
			        strins(String,"{FFFFFF}13.{B85FF3}Стать боком\n",strlen(String));
			        strins(String,"{FFFFFF}14.{B85FF3}Лечь 1\n",strlen(String));
			        strins(String,"{FFFFFF}15.{B85FF3}Лечь 2\n",strlen(String));
			        strins(String,"{FFFFFF}16.{B85FF3}Лечь 3\n",strlen(String));
			        strins(String,"{FFFFFF}17.{B85FF3}Рыболов\n",strlen(String));
			        strins(String,"{FFFFFF}18.{B85FF3}Давай-Давай-Давай\n",strlen(String));
			        strins(String,"{FFFFFF}19.{B85FF3}ЭЙ СЛЫШЬ, ЧЁ?\n",strlen(String));
			        strins(String,"{FFFFFF}20.{B85FF3}Флаг\n",strlen(String));
			        strins(String,"{FFFFFF}21.{B85FF3}Приветствие\n",strlen(String));
			        strins(String,"\n",strlen(String));
			        strins(String,"{FF0000}P.S Некоторые анимации могут работать со 2 раза!!\n",strlen(String));
			        ShowPlayerDialog(playerid,1008,DIALOG_STYLE_INPUT,"{DFDF02}»»» Anim System «««",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 5:
			    {
  					if(GetPlayerScore(playerid) > 5000) return SendClientMessage(playerid, -1, "* {FF0000}У вас запрещен доступ сюда! Так как у вас модифицырованые стили боя!");
			    	ShowPlayerDialog(playerid, 7975, DIALOG_STYLE_LIST, "{DFDF02}Стили боя", "{FF740D}Обычный\n{FFAA0D}Боксёр\n{FEE60E}Каратист\n{DFFD0F}Гангстер\n{DFFD0F}Локтевой", "»[Выбрать]«","»[Отмена]«");
			    }
			    case 6:
			    {
			        new String[1000];
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Лестница\t\t\t| {C4FF00}Приз , побериги нервы!\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Норки\t\t\t| {C4FF00}Развличение\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Паркур\t\t\t| {C4FF00}Развличение\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Skydive\t\t\t| {C4FF00}Приз , мастерство полёта\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Skydive HARD\t\t| {C4FF00}Приз , мастерство полёта\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Counte Strike \t\t| {C4FF00}Убийства , Выживание\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Meat Game\t\t| {C4FF00}Убийства , Выживание , Мясорубка\r\n",strlen(String));
			        strins(String,"{2DF90F}Мини-Игра : {11EBF7}Mini Game\t\t\t| {C4FF00}Убийства , Выживание\r\n",strlen(String));
			        ShowPlayerDialog(playerid,7753,DIALOG_STYLE_LIST,"{31EEFD}Мини-Игры Развлекательного Центра™",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 7:
			    {
			        new String[4000];
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Deagle DM\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: 9mm DM\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Shotgun DM\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Deagle + Shot DM\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Silenced Pistol\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: M4\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: M5\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Sawnoff Shotgun\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Chainsaw\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: RPG\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Sniper\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Deagle + AK-47 + Rifle\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Deagle + M4 + Sawn + UZI\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Tec 9\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Micro SMG/Uzi\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Combat Shotgun\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Silenced Pistol + Rifle\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Country Rifle\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: AK-47\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Fire Extinguisher\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Flamethrower + Molotov Cocktail\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Silenced Pistol + M5\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: UZI + Molotov Cocktail\r\n",strlen(String));
			        strins(String,"{FAB11D}ДеадМатч, {A7FA0E}оружие: Combat Shotgun + 9mm\r\n",strlen(String));
			        ShowPlayerDialog(playerid,142,DIALOG_STYLE_LIST,"{0000ff}»»» DM зоны «««",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 8:
			    {
			        new String[4000];
			        strins(String,"{00FF00}Los Santos\t\t\t{FFFFFF}|    {00FF00}Лос Сантос\r\n",strlen(String));
			        strins(String,"{00FF1E}Las Venturas\t\t\t{FFFFFF}|    {00FF1E}Лас Вентурас\r\n",strlen(String));
			        strins(String,"{00FF3B}San Fierro\t\t\t{FFFFFF}|   {00FF3B}Сан Фиерро\r\n",strlen(String));
			        strins(String,"{00FF7C}Развлекательные Зоны\t{FFFFFF}|    {00FF7C}Stunt , Fun Zone\r\n",strlen(String));
			        strins(String,"{00FFAE}Интересные места сервера\t{FFFFFF}|    {00FFAE}Planes Zone\r\n",strlen(String));
			        strins(String,"{00FFD5}Интерьеры\t\t\t{FFFFFF}|    {00FFD5}Interior\r\n",strlen(String));
			        strins(String,"{00FFFF}Мини-города\t\t\t{FFFFFF}|    {00FFFF}Mini-City\r\n",strlen(String));
			        strins(String,"{00FFFF}Базы кланов/team\t\t{FFFFFF}|    {00FFFF}The base of the clan/team\r\n",strlen(String));
			        strins(String,"{00FFFF}Мой телепорт\t\t\t{FFFFFF}|    {00FFFF}My teleport\r\n",strlen(String));
			        strins(String,"{00FFFF}ViP Телепорты\t\t\t{FFFFFF}|    {00FFFF}ViP teleports\r\n",strlen(String));
			        ShowPlayerDialog(playerid,7123,DIALOG_STYLE_LIST,"{FFFF00}Телепорты Развлекательного Центра™",String,"»[Выбрать]«","»[Отмена]«");
			    }
			    case 9:
			    {
   					if(GetPlayerScore(playerid) < 20) return SendClientMessage(playerid, -1, "* {FF0000}Доступ к достижениям доступно с 20 SCORE!!");
			        new String[4000];
			        strins(String,"{2BF997}Deagle + M4 + ResetWeapons\t\t{FD9F9F}| {FB2828}Доступ с 20 SCORE        {FD9F9F}|  {2BF997}0$\r\n",strlen(String));
			        strins(String,"{2BF997}Sawnoff + Micro UZI + ResetWeapons\t{FD9F9F}| {FB2828}Доступ с 100 SCORE      {FD9F9F}|  {2BF997}10.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Летучий ранец\t\t\t\t{FD9F9F}| {FB2828}Доступ с 1250 SCORE    {FD9F9F}|  {2BF997}14.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Невидимка на радаре\t\t\t{FD9F9F}| {FB2828}Доступ с 350 SCORE      {FD9F9F}|  {2BF997}10.000$\r\n",strlen(String));
			        strins(String,"{2BF997}RPG с 500 зарядами\t\t\t{FD9F9F}| {FB2828}Доступ с 2000 SCORE    {FD9F9F}|  {2BF997}5.000$\r\n",strlen(String));
			        strins(String,"{2BF997}RPG с 5 зарядами\t\t\t{FD9F9F}| {FB2828}Доступ с 230 SCORE      {FD9F9F}|  {2BF997}20.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Hp & Armour по 100\t\t\t{FD9F9F}| {FB2828}Доступ с 400 SCORE      {FD9F9F}|  {2BF997}7.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Hp & Armour по 250\t\t\t{FD9F9F}| {FB2828}Доступ с {EFF600}Gold ViP {FB2828}Level{FD9F9F}|  {2BF997}20.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Hp & Armour по 500\t\t\t{FD9F9F}| {FB2828}Доступ с 9999 SCORE    {FD9F9F}|  {2BF997}15.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Оборудование снайпера\t\t{FD9F9F}| {FB2828}Доступ с 780 SCORE      {FD9F9F}|  {2BF997}9.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Оборудование НеУдЕрЖиМоГо\t{FD9F9F}| {FB2828}Доступ с 20000 SCORE  {FD9F9F}|  {2BF997}20.000$\r\n",strlen(String));
			        strins(String,"{2BF997}Доска под ногами\t\t\t{FD9F9F}| {FB2828}Доступ с {EFF600}ViP {FB2828}Level          {FD9F9F}|  {2BF997}0$\r\n",strlen(String));
			        strins(String,"{2BF997}Оборудование ViP\t\t\t{FD9F9F}| {FB2828}Доступ с {EFF600}ViP {FB2828}Level          {FD9F9F}|  {2BF997}10.000$\r\n",strlen(String));
			        strins(String,"{2BF994}*** Остальные мелкие достижения ***\r\n",strlen(String));
			        ShowPlayerDialog(playerid,8543,DIALOG_STYLE_LIST,"{FFFF00}Достижения™",String,"»[Выбрать]«","»[Отмена]«");
				}
			    case 10:
			    {
			        new String[4000];
			        strins(String,"{FF0000}1. Новогоднее\r\n",strlen(String));
			        strins(String,"{FF2C00}2. Попугай на плече\r\n",strlen(String));
			        strins(String,"{FF5000}3. Попугай\r\n",strlen(String));
			        strins(String,"{FF8700}4. Бегемот\r\n",strlen(String));
			        strins(String,"{FFA700}5. Кепка\r\n",strlen(String));
			        strins(String,"{FFDC00}6. Кейс в руке\r\n",strlen(String));
			        strins(String,"{FFFB00}7. Мешок денег\r\n",strlen(String));
			        strins(String,"{C4FF00}8. Акула\r\n",strlen(String));
			        strins(String,"{7BFF00}9. Дельфин\r\n",strlen(String));
			        strins(String,"{00FF00}10. Шапка курицы\r\n",strlen(String));
			        strins(String,"{00FF1E}11. Щит на спине\r\n",strlen(String));
			        strins(String,"{00FF3B}12. Щит в руке\r\n",strlen(String));
			        strins(String,"{00FF7C}13. Огневые руки\r\n",strlen(String));
			        strins(String,"{00FFAE}14. Красный дым\r\n",strlen(String));
			        strins(String,"{00FFD5}15. Водяной шар\r\n",strlen(String));
			        strins(String,"{00FFFF}16. Доски для серфинга\r\n",strlen(String));
			        strins(String,"{00CCFF}17. Гитары на спине\r\n",strlen(String));
			        strins(String,"{00ACFF}18. Гамбургер\r\n",strlen(String));
			        strins(String,"{0083FF}19. Бутылка\r\n",strlen(String));
			        strins(String,"{0054FF}20. Пожарная шапка\r\n",strlen(String));
			        strins(String,"{0000FF}21. Магнитофон\r\n",strlen(String));
			        strins(String,"{2C00FF}22. Рога\r\n",strlen(String));
			        strins(String,"{5F00FF}23. Факел в левой руке\r\n",strlen(String));
			        strins(String,"{9B00FF}24. Оружие на спине\r\n",strlen(String));
			        strins(String,"{CB00FF}25. Голова CJ\r\n",strlen(String));
			        strins(String,"{FF0000}26. Грабли в левой руке\r\n",strlen(String));
			        strins(String,"{FF2C00}27. Бронижелет\r\n",strlen(String));
			        strins(String,"{FF5000}28. Сигара\r\n",strlen(String));
			        strins(String,"{FF8700}29. Полицейская шапка\r\n",strlen(String));
			        strins(String,"{FFA700}30. Рюкзак\r\n",strlen(String));
			        strins(String,"{FFDC00}31. Олень на спине\r\n",strlen(String));
			        strins(String,"{FFFB00}32. ХотДог на спине\r\n",strlen(String));
			        strins(String,"{C4FF00}33. Наушники\r\n",strlen(String));
			        strins(String,"{C4FF00}34. Удочка в правой руке\r\n",strlen(String));
			        strins(String,"{C4FF00}35. Мигалка на голове\r\n",strlen(String));
			        strins(String,"{C4FF00}36. Оружие в теле\r\n",strlen(String));
			        strins(String,"{ffffff}***** Снять всё *****\r\n",strlen(String));
			        ShowPlayerDialog(playerid,949,DIALOG_STYLE_LIST,"{00ff00}»»» Объекты для развлечения «««",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 11:ShowPlayerDialog(playerid, 1338, DIALOG_STYLE_LIST, "{DFDF02}»»» Выбор скина «««", "{FF8700}Выбрать скин по катигориям\n{FFA700}Ввести самому ID скина",".»[Выбрать]«","»[Назад]«");
			    case 12:CallRemoteFunction("HomeTp", "i",playerid);
			    case 13:ShowPlayerDialog(playerid,2727, DIALOG_STYLE_LIST, "{DFDF02}»»» Стили походки «««","{D6EF6D}Обычная\n{B5F06C}Гражданская\n{97F26A}Гангстерская 1\n{68F473}Гангстерская 2\n{68F4A4}Старика\n{68F4CA}Старухи\n{6AF2EC}Женская 1\n{6BDDF1}Женская 2\n{6AC2F2}Шлюхи 1\n{6AA0F2}Шлюхи 2\n{697AF3}Шлюхи 3\n{7E6AF2}Пьяного\n{896AF2}Слепого", "»[Выбрать]«","»[Назад]«");
			    case 14:
			    {
			        new String[500];
			        strins(String,"{FF0000}Жара\r\n",strlen(String));
			        strins(String,"{FF2C00}Дождь\r\n",strlen(String));
			        strins(String,"{FF5000}Песчаная буря\r\n",strlen(String));
			        strins(String,"{FF8700}Очень ярко\r\n",strlen(String));
			        strins(String,"{FFA700}Туманный\r\n",strlen(String));
			        strins(String,"{FFDC00}Бурная погода\r\n",strlen(String));
			        strins(String,"{FFDC00}Голубое небо с облаками\r\n",strlen(String));
			        ShowPlayerDialog(playerid,7499,DIALOG_STYLE_LIST,"{DFDF02}»»» Сменить погоду «««",String,"»[Выбрать]«","»[Назад]«");
				}
			    case 15:
			    {
       				if(GetPlayerScore(playerid) < 50) return SendClientMessage(playerid, -1, "* {FF0000}Покупка оружия через 'Alt' доступна с 3 Level!!");
			        new String[4000];
			        strins(String,"{DC56F3}1. Golf Club\r\n",strlen(String));
			        strins(String,"{F356DC}2. Nightstick\r\n",strlen(String));
			        strins(String,"{F455C0}3. Knife\r\n",strlen(String));
			        strins(String,"{F4559D}4. Baseball Bat\r\n",strlen(String));
			        strins(String,"{F45569}5. Shovel\r\n",strlen(String));
			        strins(String,"{F45555}6. Pool Cue\r\n",strlen(String));
			        strins(String,"{F48555}7. Katana\r\n",strlen(String));
			        strins(String,"{F49D55}8. Chainsaw\r\n",strlen(String));
			        strins(String,"{F5C954}9. Double-ended Dildo\r\n",strlen(String));
			        strins(String,"{F5EA54}10. Dildo\r\n",strlen(String));
			        strins(String,"{D6F554}11. Vibrator \r\n",strlen(String));
			        strins(String,"{A9F554}12. Silver Vibrator\r\n",strlen(String));
			        strins(String,"{73F852}13. Flowers \r\n",strlen(String));
			        strins(String,"{52F85A}14. Cane \r\n",strlen(String));
			        strins(String,"{DC56F3}15. Grenade\r\n",strlen(String));
			        strins(String,"{F356DC}16. Tear Gas\r\n",strlen(String));
			        strins(String,"{F455C0}17. Molotov Cocktail\r\n",strlen(String));
			        strins(String,"{F4559D}18. 9m\r\n",strlen(String));
			        strins(String,"{F45569}19. Silenced 9mm\r\n",strlen(String));
			        strins(String,"{F45555}20. Desert Eagle\r\n",strlen(String));
			        strins(String,"{F48555}21. Shotgun\r\n",strlen(String));
			        strins(String,"{F49D55}22. Sawn-off Shotgun\r\n",strlen(String));
			        strins(String,"{F5C954}23. Combat Shotgun\r\n",strlen(String));
			        strins(String,"{F5EA54}24. Micro SMG\r\n",strlen(String));
			        strins(String,"{D6F554}25. MP5\r\n",strlen(String));
			        strins(String,"{A9F554}26. AK-47\r\n",strlen(String));
			        strins(String,"{73F852}27. M4\r\n",strlen(String));
			        strins(String,"{52F85A}28. Tec9\r\n",strlen(String));
			        strins(String,"{53F795}29. Country Rifle\r\n",strlen(String));
			        strins(String,"{52F8B6}30. Sniper Rifle\r\n",strlen(String));
			        strins(String,"{53F795}31. RPG\r\n",strlen(String));
			        strins(String,"{52F8C1}32. HS Rocket\r\n",strlen(String));
			        strins(String,"{51F9E8}33. Flamethrower\r\n",strlen(String));
			        strins(String,"{53F795}34. Satchel Charge\r\n",strlen(String));
			        strins(String,"{52F8C1}35. Detonator\r\n",strlen(String));
			        strins(String,"{51F9E8}36. Spraycan\r\n",strlen(String));
			        strins(String,"{51F0F9}37. Fire Extinguisher\r\n",strlen(String));
			        strins(String,"{50BAFA}38. Camera\r\n",strlen(String));
			        ShowPlayerDialog(playerid,3333,DIALOG_STYLE_LIST,"{ff0000}»»» Покупка оружия Развлекательного Центра™ «««",String,"»[Купить]«","»[Отмена]«");
			    }
			    case 16:
			    {
			       new String[1000];
			       strins(String,"{FFBF00}Машины\t\t(2000$)\r\n",strlen(String));
			       strins(String,"{FFBF00}Мотоциклы\t\t(1000$)\r\n",strlen(String));
			       strins(String,"{FFEA00}Самолёты\t\t(3000$)\r\n",strlen(String));
			       strins(String,"{FFEA00}Вертолёты\t\t(3000$)\r\n",strlen(String));
			       strins(String,"{E6FF00}Лодки\t\t\t(1500$)\r\n",strlen(String));
			       strins(String,"{E6FF00}Тракторы\t\t(2000$)\r\n",strlen(String));
			       strins(String,"{B3FF00}RC Игрушки\t\t(3000$)\r\n",strlen(String));
			       strins(String,"{B3FF00}Военая техника\t(10000$)\r\n",strlen(String));
			       ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,"{DFDF02}»»» Покупка транспорта «««",String,"»[Выбрать]«","»[Назад]«");
			    }
			    case 17:ShowPlayerDialog(playerid, 6254, DIALOG_STYLE_LIST, "{DFDF02}Настройки аккаунта", "{18FEED}¤ Сменить пароль ¤\n{18EDFE}¤ Сменить никнейм ¤\n{18B9FE}¤ Сменить цвет ника ¤\n{18B9FE}¤ Управление TextDraw'ами ¤\n{1874FE}¤ Фразы сервера ¤\n{1874FE}¤ Сохранения скина ¤\n{1874FE}¤ Сохранить свою позицию ¤\n{1874FE}¤ Информация обо мне ¤","»]Выбрать[«", "»]Назад[«");
			    case 18:ShowPlayerDialog(playerid, 6257, DIALOG_STYLE_LIST, "{DFDF02}Платные услуги сервера", "{B3FF00}Админка\n{E6FF00}Score | Фраги\n{FFEA00}Деньги\n{FFEA00}Базы кланов/team\n{FFBF00}Маппинг возле дома!","»]Выбрать[«", "»]Назад[«");
			}
		}
	    return true;
	}

    if(dialogid == 6254)
    {
    if(response == 1)
    {
    if(listitem == 0)
    {
        OnPlayerCommandText(playerid,"/changepass");
    }
    if(listitem == 1)
    {
        OnPlayerCommandText(playerid,"/changenick");
    }
    if(listitem == 2)
    {
       	new String[4000];
       	strins(String,"{FFF000}Введите ид цвета от 0-34!\n",strlen(String));
       	strins(String,"\n",strlen(String));
       	strins(String,"{FFFFFF}0.{AA3333}[|||||||]\t\t{FFFFFF}18.{4B00B0}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}1.{AFAFAF}[|||||||]\t\t{FFFFFF}19.{FFFF82}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}2.{33AA33}[|||||||]\t\t{FFFFFF}20.{7CFC00}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}3.{FF9900}[|||||||]\t\t{FFFFFF}21.{32CD32}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}4.{0000BB}[|||||||]\t\t{FFFFFF}22.{191970}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}5.{33CCFF}[|||||||]\t\t{FFFFFF}23.{800000}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}6.{FFFF00}[|||||||]\t\t{FFFFFF}24.{808000}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}7.{10F441}[|||||||]\t\t{FFFFFF}25.{FF4500}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}8.{000080}[|||||||]\t\t{FFFFFF}26.{FFC0CB}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}9.{F0F8FF}[|||||||]\t\t{FFFFFF}27.{00FF7F}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}10.{DC143C}[|||||||]\t{FFFFFF}28.{FF6347}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}11.{6495ED}[|||||||]\t{FFFFFF}29.{9ACD32}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}12.{FFE4C4}[|||||||]\t{FFFFFF}30.{83BFBF}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}13.{7FFF00}[|||||||]\t{FFFFFF}31.{8B008B}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}14.{A52A2A}[|||||||]\t{FFFFFF}32.{DC143C}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}15.{FF7F50}[|||||||]\t{FFFFFF}33.{EFEFF7}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}16.{B8860B}[|||||||]\t{FFFFFF}34.{330066}[|||||||]\n",strlen(String));
       	strins(String,"{FFFFFF}17.{ADFF2F}[|||||||]\n",strlen(String));
       	ShowPlayerDialog(playerid,888,DIALOG_STYLE_INPUT,"{DFDF02}»»» Цвет «««",String,"»[Выбрать]«","»[Назад]«");
    }
    if(listitem == 3)
    {
        OnPlayerCommandText(playerid,"/textdraw");//управление textdraw'ами!
    }
    if(listitem == 4)
    {
        new String[4000];
        strins(String,"{FFBF00}Фразы для Игроков\r\n",strlen(String));
        strins(String,"{FFEA00}Фразы для Админа\r\n",strlen(String));
        strins(String,"{E6FF00}Фразы для Создателя\r\n",strlen(String));
        ShowPlayerDialog(playerid,9332,DIALOG_STYLE_LIST,"{DFDF02}»»» Фразы «««",String,"»[Выбрать]«","»[Назад]«");
    }
    if(listitem == 5)
    {
        OnPlayerCommandText(playerid,"/skininfo");//Сохранения скинов!
    }
    if(listitem == 6)
    {
    	if(GetPlayerScore(playerid) < 500) return SendClientMessage(playerid, -1, "* {FF0000}Сохранение позиции доступно только с 4 Level'a!!");
        OnPlayerCommandText(playerid,"/smeposska");//Сохранения позиций!
    }
    if(listitem == 7)
    {
	    new player1, NamePlayer[24] , string[128],str1[128],str2[128],str3[128],str4[128],str5[128],str6[128],str7[128],str8[128],str9[128],str10[128],str11[128],str12[128],str13[128],str14[128],str15[128],str16[4000];
	    player1 = playerid;
	    GetPlayerName(player1, NamePlayer, sizeof(NamePlayer));
	 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID)
		{
		    new Float:player1health, Float:player1armour, playerip[128], tmp2[256], file[256],P1Jailed[15], P1Frozen[15], RegDate[256];
		    GetPlayerHealth(player1,player1health);
		    GetPlayerArmour(player1,player1armour);
		    GetPlayerIp(player1, playerip, sizeof(playerip));
		    format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(NamePlayer));
		    if(PlayerInfo[player1][Jailed] == 1) P1Jailed = "{FF0000}Да"; else P1Jailed = "{00FF00}Нет";
		    if(PlayerInfo[player1][Frozen] == 1) P1Frozen = "{FF0000}Да"; else P1Frozen = "{00FF00}Нет";
		    if(dUserINT(PlayerName2(player1)).("LastOn")==0) tmp2 = "Never"; else tmp2 = dini_Get(file,"LastOn");
		    if(strlen(dini_Get(file,"RegisteredDate")) < 3) RegDate = "n/a"; else RegDate = dini_Get(file,"RegisteredDate");

		    format(string, sizeof(string)," {FFFF00}Ник: %s  {0000FF}ID: %d", NamePlayer,player1);

		    format(str1, sizeof(str1),"{FFFF00}Админ Уровень:\t\t{0000FF}%d",PlayerInfo[player1][Level]);

		    format(str2, sizeof(str2),"{FFFF00}ViP Уровень:\t\t\t{0000FF}%d", PlayerInfo[player1][pVip]);

		    format(str3, sizeof(str3),"{FFFF00}Дата Регистрации:\t\t{0000FF}%s", RegDate);

		    format(str4, sizeof(str4),"{FFFF00}Наличные Деньги:\t\t{0000FF}%d$", GetPlayerMoney(player1));

		    format(str5, sizeof(str5),"{FFFF00}Деньги в Банке:\t\t{0000FF}%d$", udb_UserInt(PlayerName2(player1),"bank"));

		    format(str6, sizeof(str6),"{FFFF00}Здоровье:\t\t\t{0000FF}%d",floatround(player1health));

		    format(str7, sizeof(str7),"{FFFF00}Броня:\t\t\t\t{0000FF}%d",floatround(player1armour));

		    format(str8, sizeof(str8),"{FFFF00}Убил/SCORE:\t\t\t{0000FF}%d", PlayerInfo[player1][Kills]);

		    format(str9, sizeof(str9),"{FFFF00}Смертей:\t\t\t{0000FF}%d",PlayerInfo[player1][Deaths]);

		    format(str10, sizeof(str10),"{FFFF00}Посажен:\t\t\t%s",P1Jailed);

			format(str11, sizeof(str11),"{FFFF00}Заморожен:\t\t\t%s",P1Frozen);

		    format(str12, sizeof(str12),"{FFFF00}Колличество поцелуев:\t{0000FF}%d",udb_UserInt(PlayerName2(player1),"kiss"));

		    format(str13, sizeof(str13),"{FFFF00}Учавствовал в Дуэлях:\t{0000FF}%d",udb_UserInt(PlayerName2(player1),"allduel"));

		    format(str14, sizeof(str14),"{FFFF00}В браке с:\t\t\t{0000FF}%s",newlywed[playerid]);

		    format(str15, sizeof(str15),"{FFFF00}Ранг:\t\t\t\t{0000FF}%s",PlayerInfo[playerid][RanG]);

		    format(str16, sizeof(str16),"\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",str1, str2,str3,str4,str5,str6,str7,str8,str9,str10,str11,str12,str13,str14,str15);
		    ShowPlayerDialog(playerid,73456,DIALOG_STYLE_LIST,string,str16,"Ok","Выход");//DIALOG_STYLE_MSGBOX
	    }
    }
    }else
    	{
	    new String[2048];
	    strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
	    strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
	    strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
	    strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
	    strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
	    strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
	    strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
	    strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
	    strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
	    strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
	    strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
	    strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
	    strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
	    strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
	    strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
	    strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
	    strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
	    strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
	    strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
	    ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
    }

    if(dialogid == 7131)
    {
	    if(response == 1)
	    {
		    if(listitem == 0)
		    {
		        new playername[256];
		        GetPlayerName(playerid, playername, sizeof(playername));
		        if(strfind(playername, "John_Vibers") == 0 || strfind(playername, "John_Marston") == 0 || strfind(playername, "TimyrSem") == 0 || strfind(playername, "VladSem") == 0){
		        SetPlayerPos(playerid,1734.2528,-2061.0417,17.6422);
		        new string[256];
		        GetPlayerName(playerid,playername,sizeof(playername));
		        format(string,sizeof(string),"{AC17F4}..:: {FF0000}%s(ID: %d) {AC17F4}телепортировался(лась) на базу {FF0000}ELISIYM {AC17F4}::..",playername,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        SetPlayerInterior(playerid,0);
		        SetPlayerVirtualWorld(playerid,0);
		        SetTogglePlayerPos(playerid);
		        }else
		        SendClientMessage(playerid, 0xAC17F4FF, "*** {FF0000}Ты не состаиш в ELISIYM!");
		    }
		    if(listitem == 1)
		    {
		        SetPlayerPos(playerid,-2900.9333,469.3362,4.9141);
		        new playername[30];
		        new string[256];
		        GetPlayerName(playerid,playername,sizeof(playername));
		        format(string,sizeof(string),"{AC17F4}..:: {FF0000}%s(ID: %d) {AC17F4}телепортировался(лась) на базу {FF0000}База свободна {AC17F4}::..",playername,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        SetPlayerInterior(playerid,0);
		        SetPlayerVirtualWorld(playerid,0);
		        SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 2)
		    {
		        new playername[256];
		        GetPlayerName(playerid, playername, sizeof(playername));
		        if(strfind(playername, "[Sunny]") == 0 || strfind(playername, "John_Vibers") == 0){
		        SetPlayerPos(playerid,-2.7004,1514.8202,12.7500);
		        new string[256];
		        GetPlayerName(playerid,playername,sizeof(playername));
		        format(string,sizeof(string),"{AC17F4}..:: {FF0000}%s(ID: %d) {AC17F4}телепортировался(лась) на базу {FF0000}[Sunny] {AC17F4}::..",playername,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        SetPlayerInterior(playerid,0);
		        SetPlayerVirtualWorld(playerid,0);
		        SetTogglePlayerPos(playerid);
		        }else
		        SendClientMessage(playerid, 0xAC17F4FF, "*** {FF0000}Ты не состаиш в [Sunny]!");
			}
		}
	}

//=================================================================
    if(dialogid == 83)
	{
	    if(response == 1)
		{
		    switch(listitem)
			{
			    case 0: OnPlayerCommandText(playerid,"/водолаз");
			    case 1: OnPlayerCommandText(playerid,"/археолог");
			    case 2: OnPlayerCommandText(playerid,"/job");
			    case 3: OnPlayerCommandText(playerid,"/gruz");
			    case 4: OnPlayerCommandText(playerid,"/дальнобойщик");
			    case 5: OnPlayerCommandText(playerid,"/золотник");
		    }
		}else // Возврощение в меню
	    {
		    new String[2048];
		    strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
		    strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
		    strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
		    strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
		    strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
		    strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
		    strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
		    strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
		    strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
		    ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
	}
///===================================================[Объекты на сервере]===========================================
	if(dialogid == 949)
	{
		if(response)
		{
			if(listitem == 0) // Шляпа Санты
			{
				new String[500];
				strins(String,"{00FFFF}Шляпа санты\r\n",strlen(String));
				strins(String,"{00CCFF}Ёлка\r\n",strlen(String));
				strins(String,"{00ACFF}Подарок #1\r\n",strlen(String));
				strins(String,"{0083FF}Подарок #2\r\n",strlen(String));
				strins(String,"{0054FF}Подарок #3\r\n",strlen(String));
				strins(String,"{0000FF}Подарок #4\r\n",strlen(String));
				strins(String,"{2C00FF}Подарок #5\r\n",strlen(String));
				strins(String,"{5F00FF}Шарик #1\r\n",strlen(String));
				strins(String,"{9B00FF}Шарик #2\r\n",strlen(String));
				strins(String,"{CB00FF}Шарик #3\r\n",strlen(String));
				strins(String,"{FF0000}Шарик #4\r\n",strlen(String));
				strins(String,"{FF2C00}Шарик #5\r\n",strlen(String));
				ShowPlayerDialog(playerid,8130,DIALOG_STYLE_LIST,"{00ff00}Новогодние объекты",String,"Выбрать","Отмена");
			}
			if(listitem == 1) // Попугай на плече
			{
				SetPlayerAttachedObject( playerid, 0, 19078, 1, 0.329150, -0.072101, 0.156082, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // TheParrot1
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 2) // Попугай
			{
				SetPlayerAttachedObject( playerid, 0, 19078, 1, -1.097527, -0.348305, -0.008029, 0.000000, 0.000000, 0.000000, 8.073966, 8.073966, 8.073966 ); // TheParrot1 - parrot man
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 3) // Бегемот
			{
				SetPlayerAttachedObject( playerid, 0, 1371, 1, 0.037538, 0.000000, -0.020199, 350.928314, 89.107200, 180.974227, 1.000000, 1.000000, 1.000000 ); // CJ_HIPPO_BIN - /hippo
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 4) // Кепка
			{
				SetPlayerAttachedObject( playerid, 0, 18939, 2, 0.147825, 0.010626, -0.004892, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // CapBack1 - Sapca RuTeN
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 5) // Кейс в руке
			{
				SetPlayerAttachedObject( playerid, 0, 1210, 6, 0.259532, -0.043030, -0.009978, 85.185333, 271.380615, 253.650283, 1.000000, 1.000000, 1.000000 ); // briefcase - briefcase
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 6) // Мешок денег
			{
				SetPlayerAttachedObject( playerid, 0, 1550, 15, 0.016491, 0.205742, -0.208498, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // CJ_MONEY_BAG - money
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 7) // Акула
			{
				SetPlayerAttachedObject( playerid, 0, 1608, 1, 0.201047, -1.839761, -0.010739, 0.000000, 90.005447, 0.000000, 1.000000, 1.000000, 1.000000 ); // shark - shark
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 8) // Дельфин
			{
				SetPlayerAttachedObject( playerid, 0, 1607, 1, 0.000000, 0.000000, 0.000000, 0.000000, 86.543479, 0.000000, 1.000000, 1.000000, 1.000000 ); // dolphin - /dolphin
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 9) // Шапка курицы
			{
				SetPlayerAttachedObject( playerid, 0, 19137, 2, 0.110959, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // CluckinBellHat1 - 7
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 10) // Щит на руке
			{
				SetPlayerAttachedObject(playerid, 1 , 18637, 1, 0, -0.1, 0.18, 90, 0, 272, 1, 1, 1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 11) // Щит на спине
			{
				SetPlayerAttachedObject(playerid, 1, 18637, 4, 0.3, 0, 0, 0, 170, 270, 1, 1, 1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 12) // огневые руки
			{
		 		if(GetPlayerScore(playerid) < 100) return SendClientMessage(playerid, -1, "* {FF0000}Огневые руки доступны токо с 3 Level'a!!");
				SetPlayerAttachedObject( playerid, 3, 18693, 6, 0.033288, 0.000000, -1.647527, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); ////правая рука
				SetPlayerAttachedObject( playerid, 4, 18693, 5, 0.036614, 1.886157, 0.782101, 145.929061, 0.000000, 0.000000, 0.469734, 200.000000, 1.000000 ); //левая рука
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 13)
			{
				SetPlayerAttachedObject( playerid, 0, 18728, 2, 0.134301, 1.475258, -0.192459, 82.870338, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 14)//Воляной шар
			{
				SetPlayerAttachedObject( playerid, 0, 18844, 1, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -0.027590, -0.027590, -0.027590 );
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 15)// Доска для серфинга #1
			{
				ShowPlayerDialog(playerid,8125,DIALOG_STYLE_LIST, "{A5F5A0}Доски для серфинга","{10F50A}Доска #1\n{07F855}Доска #2\n{0AF597}Доска #3","..:|Выбор|:..","..:|Выход|::..");
			}
			if(listitem == 16)//Гитара на спине
			{
				ShowPlayerDialog(playerid,8126,DIALOG_STYLE_LIST, "{A5F5A0}Гитары","{10F50A}Гитара #1\n{07F855}Гитара #2\n{0AF597}Гитара #3","..:|Выбор|:..","..:|Выход|::..");
			}
			if(listitem == 17)//Гамбургер
			{
				SetPlayerAttachedObject(playerid, 1, 2703, 1, -0.0059, 0.2230, -0.0260, 0.00, -3.49, 164.40, 8.34, 6.68, 7.42);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 18)//бутылка
			{
				SetPlayerAttachedObject(playerid, 0, 1486, 1, 0.1590, 0.0180, 0.0040, -90.49, 91.09, 12.80, 9.14, 10.51, 6.60);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 19) //Пожарная шапка
			{
				SetPlayerAttachedObject(playerid, 2, 19330, 2, 0.1730, -0.0180, 0.0029, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 20)//магнитола
			{
				SetPlayerAttachedObject(playerid, 0, 2226, 5, 0.3089, 0.0089, 0.0380, -20.29, -99.49, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 21)//рога
			{
				SetPlayerAttachedObject(playerid, 6, 19314, 2, 0.1360, 0.0680, 0.0019, -0.29, 0.00, -46.79, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 22)//факел в левой руке
			{
				SetPlayerAttachedObject(playerid, 0, 3461, 5, -0.4580, -0.2119, -0.4439, 153.10, -46.59, 80.80, 0.45, 0.89, 0.73);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 23)//факел в левой руке
			{
				ShowPlayerDialog(playerid,8124,DIALOG_STYLE_LIST, "{A5F5A0}Оружие на спине","{10F50A}Слот #1\n{07F855}Слот #2\n{0AF597}Слот #3\n{09F7DF}Слот #4\n{0AF597}Слот #5\n{09F7DF}Слот #6","..:|Выбор|:..","..:|Выход|::..");
			}
			if(listitem == 24)//голова CJ
			{
				SetPlayerAttachedObject(playerid, 3, 18963, 2, 0.0989, 0.0140, -0.0069, 85.49, 87.10, 6.89, 1.37, 1.38, 1.12);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 25)//Грабли в левой руке
			{
				SetPlayerAttachedObject(playerid, 2, 18890, 5, 0.0519, -0.0409, 0.1460, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 26)//Бронижелет
			{
				SetPlayerAttachedObject(playerid, 3, 19515, 1, 0.0579, 0.0399, 0.0080, 0.00, 0.00, 0.00, 1.12, 1.15, 1.19);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 27)//сигара
			{
				SetPlayerAttachedObject(playerid, 5, 1485, 2, 0.0399, 0.0400, -0.0629, 33.40, 0.00, 97.10, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 28)//полицейская шапка
			{
				SetPlayerAttachedObject(playerid, 6, 19521, 2, 0.1850, 0.0000, 0.0059, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 29)//Рюкзак
			{
				SetPlayerAttachedObject(playerid, 0, 3026, 1, -0.1599, -0.0329, -0.0110, 0.00, 0.00, 0.00, 1.04, 1.15, 1.25);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 30)//Олень
			{
				SetPlayerAttachedObject(playerid, 5, 19315, 1, -0.0049, -0.1489, -0.1580, 0.00, 47.59, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 31)//ХотДог
			{
				SetPlayerAttachedObject(playerid, 0, 19346, 1, 0.0189, -0.1480, -0.0159, -94.00, -176.50, 104.50, 3.31, 3.61, 3.22);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 32)//Наушники
			{
				new String[500];
				strins(String,"{00FFFF}#1\r\n",strlen(String));
				strins(String,"{00CCFF}#2\r\n",strlen(String));
				strins(String,"{00ACFF}#3\r\n",strlen(String));
				strins(String,"{0083FF}#4\r\n",strlen(String));
				ShowPlayerDialog(playerid,8131,DIALOG_STYLE_LIST,"{00ff00}Наушники",String,"Выбрать","Отмена");
			}
			if(listitem == 33)//Удочка в правой руке
			{
				SetPlayerAttachedObject(playerid, 4, 18632, 6, 0.0630, 0.0120, 0.0350, 12.99, -172.29, 153.09, 1.35, 1.16, 1.35);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 34)//Мигалка на голове
			{
				SetPlayerAttachedObject(playerid, 2, 18646, 2, 0.2260, 0.0140, 0.0189, -1.69, 82.20, -6.79, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 35)//Наушники
			{
				new String[500];
				strins(String,"{00FFFF}Нож в шеи\r\n",strlen(String));
				strins(String,"{00CCFF}Катана в животе\r\n",strlen(String));
				strins(String,"{00ACFF}Лопата в спине\r\n",strlen(String));
				strins(String,"{0083FF}Нож в левой ноге\r\n",strlen(String));
				ShowPlayerDialog(playerid,8133,DIALOG_STYLE_LIST,"{00ff00}Оружие в теле",String,"Выбрать","Отмена");
			}

			if(listitem == 36) // Снятие предметов
			{
				new zz=0;
				while(zz!=MAX_PLAYER_ATTACHED_OBJECTS)
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, zz))
					{
						RemovePlayerAttachedObject(playerid, zz);
					}
					zz++;
			    }
		    }
	    }
    	return 1;
	}

    if(dialogid == 7499)
	{
	    if(response)
		{
		    switch(listitem)
			{
			    case 0: SetPlayerWeather(playerid, 11)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Жара'!");
			    case 1: SetPlayerWeather(playerid, 16)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Дождь'!");
			    case 2: SetPlayerWeather(playerid, 19)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Песчаная буря'!");
			    case 3: SetPlayerWeather(playerid, 39)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Очень ярко'!");
			    case 4: SetPlayerWeather(playerid, 09)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Туманный'!");
			    case 5: SetPlayerWeather(playerid, 08)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Бурная погода'!");
			    case 6: SetPlayerWeather(playerid, 10)
					    ,SendClientMessage(playerid, 0xFF0000FF, "{A41ED7}* {37F737}Вы сменили себе погоду на {09CE09}'Голубое небо с облаками'!");
		    }
		}else
	    {
		    new String[2048];
		    strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
		    strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
		    strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
		    strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
		    strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
		    strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
		    strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
		    strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
		    strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
		    strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
		    strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
		    strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
		    strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
		    strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
		    ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
	}

   	if(dialogid == 1009 && response)
	switch (listitem)
	{
		case 0: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
		case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
		case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
		case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
   	}

    if(dialogid == 9333)
    {
	    if(response == 1)
	    {
		    if(listitem == 0)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» {7E27E9}%s {1EF2C2}приветствует всех игроков!!! «««", PlayerName);
		        SendClientMessageToAll(0x1EF2C2AA, str);
		    }
		    if(listitem == 1)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» {7E27E9}%s {1EF2C2}прощается со всеми!!! «««", PlayerName);
		        SendClientMessageToAll(0x1EF2C2AA, str);
		    }
		    if(listitem == 2)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» Парень {7E27E9}%s {1EF2C2}ищет себе вторую половинку!!! «««", PlayerName);
		        SendClientMessageToAll(0x1EF2C2AA, str);
		    }
		    if(listitem == 3)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» Девушка {7E27E9}%s {1EF2C2}ищет себе вторую половинку!!! «««", PlayerName);
		        SendClientMessageToAll(0x1EF2C2AA, str);
		    }
		    if(listitem == 4)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» {7E27E9}%s {1EF2C2}ищет себе друзей!!! «««", PlayerName);
		        SendClientMessageToAll(0x1EF2C2AA, str);
		    }
		    if(listitem == 5)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» Бомж {7E27E9}%s {1EF2C2}просит Вас дать ему хотя бы 100$!!! «««", PlayerName);
		        SendClientMessageToAll(0x1EF2C2AA, str);
		    }
	    }
    }

    if(dialogid == 9334)
    {
	    if(response == 1)
	    {
		    if(listitem == 0)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» Админ {FF0000}%s {FF8080}приветствует всех игроков!!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
		    if(listitem == 1)
		    {
		        new PlayerName[30], str[128];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 128, "»»» Админ {FF0000}%s {FF8080}прощается со всеми!!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
		    if(listitem == 2)
		    {
		        new PlayerName[30], str[256];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 256, "»»» Админ {FF0000}%s {FF8080}напоминает вам, если вы увидели читера, отпишитесь в репорт -> /report!!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
		    if(listitem == 3)
		    {
		        new PlayerName[30], str[256];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 256, "»»» Админ {FF0000}%s {FF8080}напоминает вам, что оскарбление на нашем сервере строго запрещено и наказуемо!!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
		    if(listitem == 4)
		    {
		        new PlayerName[30], str[256];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 256, "»»» Админ {FF0000}%s {FF8080}напоминает вам, что-бы вы соблюдали правила сервера -> /rules!!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
	    }
    }

    if(dialogid == 9335)
    {
	    if(response == 1)
	    {
		    if(listitem == 0)
		    {
		        new PlayerName[30], str[256];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 256, "»»» Создатель {FF0000}%s {FF8080}предупреждает, что сейчас будет Рестарт сервера! Просьба выйти на 1 минуту для сох. акк!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
		    if(listitem == 1)
		    {
		        new PlayerName[30], str[256];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 256, "»»» Создатель {FF0000}%s {FF8080}напоминает Вам, что идет набор в пиар-команду! {FF0000}Телеграм:t.me/e_centersamp{FF8080}!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
		    if(listitem == 2)
		    {
		        new PlayerName[30], str[256];
		        GetPlayerName(playerid, PlayerName, 30);
		        format(str, 256, "»»» Создатель {FF0000}%s {FF8080}напоминает Вам, что Вы можете предложить идею для мода! {FF0000}Телеграм:t.me/e_centersamp{FF8080}!! «««", PlayerName);
		        SendClientMessageToAll(0xFF8080AA, str);
		    }
	    }
    }

    if(dialogid == 9332)
    {
	    if(response)
	    {
		    if(listitem == 0)
		    {
		        new String[4000];
		        strins(String,"{26FB61}Приветствовать всех игроков\r\n",strlen(String));
		        strins(String,"{30FC25}Попрощаться со всеми игроками\r\n",strlen(String));
		        strins(String,"{60FD24}Искать пару(М)\r\n",strlen(String));
		        strins(String,"{60FD24}Искать пару(Ж)\r\n",strlen(String));
		        strins(String,"{9BFC25}Искать друзей\r\n",strlen(String));
		        strins(String,"{CCFC25}Попросить денег\r\n",strlen(String));//FBF526
		        ShowPlayerDialog(playerid,9333,DIALOG_STYLE_LIST,"{FFFF00}Фразы игрока!",String,"»]Выбор[«","»]Отмена[«");
		    }
		    if(listitem == 1)
		    {
		        if(PlayerInfo[playerid][Level] < 6) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор {FF0000}Развлекательного Центра™{0AD383}!");
		        new String[500];
		        strins(String,"{26FB61}Приветствовать всех игроков\r\n",strlen(String));
		        strins(String,"{30FC25}Попрощаться со всеми игроками\r\n",strlen(String));
		        strins(String,"{60FD24}Напомнить всем про /report\r\n",strlen(String));
		        strins(String,"{60FD24}Напомнить про маты\r\n",strlen(String));
		        strins(String,"{60FD24}Напомнить про Rules\r\n",strlen(String));
		        ShowPlayerDialog(playerid,9334,DIALOG_STYLE_LIST,"{FFFF00}Фразы Админа!",String,"»]Выбор[«","»]Отмена[«");
		    }
		    if(listitem == 2)
		    {
		        if(PlayerInfo[playerid][Level] < 12) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
		        new String[500];
		        strins(String,"{26FB61}Предупридить про рестарт\r\n",strlen(String));
		        strins(String,"{30FC25}Поиск пиарщиков\r\n",strlen(String));
		        strins(String,"{60FD24}Поиск идей для мода\r\n",strlen(String));
		        ShowPlayerDialog(playerid,9335,DIALOG_STYLE_LIST,"{FFFF00}Фразы Создателя!",String,"»]Выбор[«","»]Отмена[«");
		    }
	    }
	    else
	    {
	        ShowPlayerDialog(playerid, 6254, DIALOG_STYLE_LIST, "{DFDF02}Настройки аккаунта", "{18FEED}¤ Сменить пароль ¤\n{18EDFE}¤ Сменить никнейм ¤\n{18B9FE}¤ Сменить цвет ника ¤\n{18B9FE}¤ Управление TextDraw'ами ¤\n{1874FE}¤ Фразы сервера ¤\n{1874FE}¤ Сохранения скина ¤\n{1874FE}¤ Информация обо мне ¤","»]Выбрать[«", "»]Назад[«");
	    }
    }

    if(dialogid == 7753)
    {
	    if(response)
	    {
		    if(listitem == 0)
		    {
		         SetPlayerPos(playerid, 2953.9846,1196.1062,38.9021);
		         new playername[30];
		         new string[128];
		         GetPlayerName(playerid,playername,sizeof(playername));
		         format(string,sizeof(string),"{EFF422}Игрок {F88B1F}%s(%d) {EFF422}начал играть в 'Мини-Игры' > {F88B1F}'Лестница'",playername,playerid);
		         SendClientMessageToAll(0xB85FF3AA, string);
		       	 SendClientMessage(playerid, -1, "* {AA25FA}[Мини-Игры] {20FFFF}Добро пожаловать в Мини-Игру 'Лестница'! Подымись на верх и получи приз!:D");
		         SetPlayerInterior(playerid,0);
		         SetPlayerVirtualWorld(playerid,2);
		         SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 1)
		    {
		         SetPlayerPos(playerid, -330.3955,161.6867,29.5360);
		         new playername[30];
		         new string[128];
		         GetPlayerName(playerid,playername,sizeof(playername));
		         format(string,sizeof(string),"{EFF422}Игрок {F88B1F}%s(%d) {EFF422}начал играть в 'Мини-Игры' > {F88B1F}'Норки'",playername,playerid);
		         SendClientMessageToAll(0xB85FF3AA, string);
		       	 SendClientMessage(playerid, -1, "* {AA25FA}[Мини-Игры] {20FFFF}Добро пожаловать в Мини-Игру 'Норки'! Пробей себе норку своей мечты :D!");
		         SetPlayerInterior(playerid,0);
		         SetPlayerVirtualWorld(playerid,0);
		         SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 2)
		    {
		        new playername[30];
		        new string[128];
		        GetPlayerName(playerid,playername,sizeof(playername));
		        format(string,sizeof(string),"{EFF422}Игрок {F88B1F}%s(%d) {EFF422}начал играть в 'Мини-Игры'' > {F88B1F}'Паркур'",playername,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        SendClientMessage(playerid, -1, "* {AA25FA}[Мини-Игры] {20FFFF}Добро пожаловать в Мини-Игру 'Паркур'! Собериай флажки и получи приз :D!");
		        SetPlayerInterior(playerid,0);
		        SetPlayerVirtualWorld(playerid,0);
		        SetTogglePlayerPos(playerid);
		        CallRemoteFunction("Parkour", "i",playerid);
		    }
		    if(listitem == 3)
		    {
		        SetPlayerPos(playerid, -3788.4465,1579.0140,1665.6820);
		        new playername[30];
		        new string[128];
		        GetPlayerName(playerid,playername,sizeof(playername));
		        format(string,sizeof(string),"{EFF422}Игрок {F88B1F}%s(%d) {EFF422}начал играть в 'Мини-Игры' > {F88B1F}'Skydive'",playername,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        SendClientMessage(playerid, -1, "* {AA25FA}[Мини-Игры] {20FFFF}Добро пожаловать в Мини-Игру 'Skydive'! Прыгай вниз , и забери в конце приз!:D");
		        SetPlayerInterior(playerid,0);
		        SetPlayerVirtualWorld(playerid,2);
		        GivePlayerWeapon(playerid,46,1);
		        SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 4)
		    {
		        SetPlayerPos(playerid, 3443.69995117,540.90002441,2014.00000000);
		        new playername[30];
		        new string[128];
		        GetPlayerName(playerid,playername,sizeof(playername));
		        format(string,sizeof(string),"{EFF422}Игрок {F88B1F}%s(%d) {EFF422}начал играть в 'Мини-Игры' > {F88B1F}'Skydive HARD'",playername,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        SendClientMessage(playerid, -1, "* {AA25FA}[Мини-Игры] {20FFFF}Добро пожаловать в Мини-Игру 'Skydive HARD'! Прыгай вниз , и забери в конце приз!:D");
		        SetPlayerInterior(playerid,0);
		        SetPlayerVirtualWorld(playerid,2);
		        GivePlayerWeapon(playerid,46,1);
		        SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 5)
		    {
		        OnPlayerCommandText(playerid,"/cs");
		    }
		    if(listitem == 6)
		    {
		        OnPlayerCommandText(playerid,"/mg");
		    }
		    if(listitem == 7)
		    {
		        OnPlayerCommandText(playerid,"/ming");
		    }
	    }
	    else
	    {
	        new String[2048];
	        strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
	        strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
	        strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
	        strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
	        strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
	        strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
	        strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
	        strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
	        strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
	        strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
	        strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
	        strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
	        strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
	        strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
	        strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
	        strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
	        strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
	        strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
	        strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
	        ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
    }
     
    if(dialogid == 8543)
    {
	    if(response)
	    {
		    if(listitem == 0)
		    {
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Deagle + M4 + ResetWeapons", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        ResetPlayerWeapons(playerid);
		        GivePlayerWeapon(playerid,24,99999);
		        GivePlayerWeapon(playerid,31,99999);
		    }
		    if(listitem == 1)
		    {
		    	if(GetPlayerScore(playerid) < 100) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Sawnoff + Micro UZI + ResetWeapons доступно с 100 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Sawnoff + Micro UZI + ResetWeapons стоит 10000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Sawnoff + Micro UZI + ResetWeapons", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        ResetPlayerWeapons(playerid);
		        GivePlayerWeapon(playerid,28,99999);
		        GivePlayerWeapon(playerid,26,99999);
		        GivePlayerMoney(playerid, -10000);
		    }
		    if(listitem == 2)
		    {
		   		if(GetPlayerScore(playerid) < 1250) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Летучий ранец доступно с 1250 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 14000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Летучий ранец стоит 14000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Летучий ранец", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        SetPlayerSpecialAction(playerid, 2);
		        GivePlayerMoney(playerid, -14000);
		        SetPlayerColor(playerid,0x808080AA);
		        new String[1024];
		        strins(String,"                     {FF0000}ВНИМАНИЕ!!\n",strlen(String));
		        strins(String,"{FF0000}Чтобы вас не приняли за читера,мы вам поменяли цвет на {808080}[|||||]{FF0000}!\n",strlen(String));
		        strins(String,"{FF0000}Все Админы про этот цвет придупреждены!!\n",strlen(String));
		        strins(String,"{FF0000}Пожалуйста не меняйте цвет вашего ника, если вы поменяете пинайте на себя!\n",strlen(String));
		        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Летучий ранец",String,"»]Ок[«","");
		    }
		    if(listitem == 3)
		    {
		  		if(GetPlayerScore(playerid) < 350) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Невидимка на радаре доступно с 350 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Невидимка на радаре стоит 10000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Радарную невидимку", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        OnPlayerCommandText(playerid,"/nivedblms");
		    }
		    if(listitem == 4)
		    {
		  		if(GetPlayerScore(playerid) < 2000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение RPG с 500 зарядами доступно с 2000 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 5000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение RPG с 500 зарядами стоит 5000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял RPG с 500 зарядами", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        GivePlayerWeapon(playerid,35,500);
		        GivePlayerMoney(playerid, -5000);
		        SetPlayerColor(playerid,0x808080AA);
		        new String[1024];
		        strins(String,"                     {FF0000}ВНИМАНИЕ!!\n",strlen(String));
		        strins(String,"{FF0000}Чтобы вас не приняли за читера,мы вам поменяли цвет на {808080}[|||||]{FF0000}!\n",strlen(String));
		        strins(String,"{FF0000}Все Админы про этот цвет придупреждены!!\n",strlen(String));
		        strins(String,"{FF0000}Пожалуйста не меняйте цвет вашего ника, если вы поменяете пинайте на себя!\n",strlen(String));
		        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}RPG с 500 зарядами",String,"»]Ок[«","");
		    }
		    if(listitem == 5)
		    {
		  		if(GetPlayerScore(playerid) < 230) return SendClientMessage(playerid, -1, "* {FF0000}Достижение RPG с 5 зарядами доступно с 230 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 20000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение RPG с 5 зарядами стоит 20000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял RPG с 5 зарядами", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        GivePlayerWeapon(playerid,35,5);
		        GivePlayerMoney(playerid, -20000);
		        SetPlayerColor(playerid,0x808080AA);
		    }
		    if(listitem == 6)
		    {
		  		if(GetPlayerScore(playerid) < 400) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Hp & Armour по 100 доступно с 400 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 7000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Hp & Armour по 100 стоит 7000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Hp & Armour по 100", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        SetPlayerHealthAC(playerid,100);
		        SetPlayerArmorAC(playerid,100);
		        GivePlayerMoney(playerid, -7000);
			}
		    if(listitem == 7)
		    {
		        if(PlayerInfo[playerid][pVip] < 2) return SendClientMessage(playerid, -1, "{EFF600}*** Ты не Gold ViP {FF0000}Развлекательного Центра™{EFF600}!");
		    	if(GetPlayerMoney(playerid) < 20000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Hp & Armour по 250 стоит 20000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{EFF600}[Достижение - Gold ViP]: Игрок {32F4FA}%s {EFF600}взял Hp & Armour по 250", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        SetPlayerHealthAC(playerid,250);
		        SetPlayerArmorAC(playerid,250);
		        GivePlayerMoney(playerid, -20000);
		    }
		    if(listitem == 8)
		    {
		  		if(GetPlayerScore(playerid) < 9999) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Hp & Armour по 500 доступно с 9999 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 15000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Hp & Armour по 500 стоит 15000 $!!");
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Hp & Armour по 500", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        SetPlayerHealthAC(playerid,500);
		        SetPlayerArmorAC(playerid,500);
		        GivePlayerMoney(playerid, -15000);
		    }
		    if(listitem == 9)
		    {
		  		if(GetPlayerScore(playerid) < 780) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Оборудование снайпера доступно с 780 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 9000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Оборудование снайпера стоит 9000 $!!");
		        SetPlayerAttachedObject(playerid, 6, 824, 1, -0.0770, 0.0500, 0.0199, 2.59, 90.19, 8.10, 0.10, 0.10, 0.27);
		        SetPlayerAttachedObject(playerid, 7, 824, 9, 0.0000, 0.0000, 0.0000, -84.09, 0.00, 0.00, 0.05, 0.04, 0.12);
		        SetPlayerAttachedObject(playerid, 8, 824, 10, 0.0000, 0.0000, 0.0000, 93.50, 0.00, 0.00, 0.05, 0.04, 0.10);
		        SetPlayerAttachedObject(playerid, 9, 358, 1, 0.0960, -0.2249, 0.0999, 26.59, 160.90, 0.00, 1.00, 1.00, 1.00);
		        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Оборудование снайпера", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        ResetPlayerWeapons(playerid);
		        GivePlayerWeapon(playerid,34,99999);
		        GivePlayerWeapon(playerid,23,99999);
		        GivePlayerMoney(playerid, -9000);
		    }
		    if(listitem == 10)
		    {
		  		if(GetPlayerScore(playerid) < 20000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Оборудование НеУдЕрЖиМоГо доступно с 20000 SCORE!!");
		    	if(GetPlayerMoney(playerid) < 20000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Оборудование НеУдЕрЖиМоГо стоит 20000 $!!");
		        SetPlayerAttachedObject(playerid, 6, 19515, 1, 0.0549, 0.0539, 0.0080, 0.00, 0.00, 0.00, 1.06, 1.15, 1.15);
		        SetPlayerAttachedObject(playerid, 7, 359, 1, 0.2060, -0.1610, -0.2380, 0.00, -4.90, 0.00, 1.00, 1.00, 1.00);
		        SetPlayerAttachedObject(playerid, 8, 356, 1, -0.0849, -0.1399, 0.1610, -170.89, 2.60, 0.00, 1.00, 1.00, 1.00);
		        SetPlayerAttachedObject(playerid, 9, 19472, 2, 0.0070, 0.1439, 0.0040, 96.79, 74.19, 0.00, 1.00, 1.00, 1.00);
		        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        new name[MAX_PLAYER_NAME+1];
		        new string[256];
		        GetPlayerName(playerid, name, sizeof(name));
		        format(string, sizeof(string), "{88F03C}[Достижение]: Игрок {32F4FA}%s {88F03C}взял Оборудование НеУдЕрЖиМоГо", name);
		        SendClientMessageToAll(0xFF6600AA, string);
		        ResetPlayerWeapons(playerid);
		        GivePlayerWeapon(playerid,31,99999);
		        GivePlayerWeapon(playerid,24,99999);
		        GivePlayerWeapon(playerid,35,99999);
		        GivePlayerWeapon(playerid,28,99999);
		        GivePlayerWeapon(playerid,26,99999);
		        GivePlayerMoney(playerid, -20000);
		        SetPlayerHealthAC(playerid,150);
		        SetPlayerArmorAC(playerid,200);
		        SetPlayerColor(playerid,0x808080AA);
		        new String[1024];
		        strins(String,"                     {0000FF}Вам выдано:\n",strlen(String));
		    	strins(String,"{FFFFFF}1.{FF0000}Обрезы - 99999 патрон\n",strlen(String));
		        strins(String,"{FFFFFF}2.{FF0000}Узи - 99999 патрон\n",strlen(String));
		        strins(String,"{FFFFFF}3.{FF0000}М4 - 99999 патрон\n",strlen(String));
		        strins(String,"{FFFFFF}4.{FF0000}Дигл - 99999 патрон\n",strlen(String));
		        strins(String,"{FFFFFF}5.{FF0000}RPG - 99999 патрон\n",strlen(String));
		        strins(String,"{FFFFFF}6.{FF0000}Броня - 200#\n",strlen(String));
		        strins(String,"{FFFFFF}7.{FF0000}Жизни - 150#\n",strlen(String));
		        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Оборудование НеУдЕрЖиМоГо",String,"»]Ок[«","");
		    }
		    if(listitem == 11)
		    {
		        OnPlayerCommandText(playerid,"/vdoska");
		    }
		    if(listitem == 12)
		    {
		        if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, red, "{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
		    	if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, -1, "* {FF0000}Достижение Оборудование ViP стоит 10000 $!!");
		        new namevip[30];
		        new string[128];
		        GetPlayerName(playerid,namevip,sizeof(namevip));
		        format(string,sizeof(string),"{EFF600}[Достижение - ViP]: Игрок {32F4FA}%s {EFF600}взял Оборудование ViP",namevip,playerid);
		        SendClientMessageToAll(0xB85FF3AA, string);
		        GivePlayerWeapon(playerid,31,99999);
		        GivePlayerWeapon(playerid,24,99999);
		        GivePlayerWeapon(playerid,28,99999);
		        GivePlayerWeapon(playerid,26,99999);
		        GivePlayerWeapon(playerid,4,1);
		        GivePlayerWeapon(playerid,15,1);
		        GivePlayerWeapon(playerid,18,99999);
		        GivePlayerWeapon(playerid,34,99999);
		        GivePlayerWeapon(playerid,42,99999);
		        GivePlayerMoney(playerid, -10000);
		        SetPlayerHealthAC(playerid,100);
		        SetPlayerArmorAC(playerid,100);
		    }
		    if(listitem == 13)
		    {
		        new String[1024];
		        strins(String,"{32F4FA}Стиль Боксёра - {FF0000}100 SCORE | 4 Level\n",strlen(String));
		        strins(String,"{32F4FA}Стиль Каратиста - {FF0000}1000 SCORE | 9 Level\n",strlen(String));
		        strins(String,"{32F4FA}Стиль Гангстера - {FF0000}2600 SCORE | 12 Level\n",strlen(String));
		        strins(String,"{32F4FA}Стиль StreetBlow - {FF0000}5000 SCORE | 14 Level\n",strlen(String));
		        strins(String,"{32F4FA}Стиль MiXCeni - {FF0000}11000 SCORE | 18 Level\n",strlen(String));
		        strins(String,"{32F4FA}Гидра - {FF0000}150 SCORE | В 4 Level'е!\n",strlen(String));
		        strins(String,"{32F4FA}Хантер - {FF0000}250 SCORE | В 5 Level'е!\n",strlen(String));
		        strins(String,"{32F4FA}Воробей - {FF0000}100 SCORE | 4 Level\n",strlen(String));
		        strins(String,"{32F4FA}Танк - {FF0000}200 SCORE | 5 Level\n",strlen(String));
		        strins(String,"{32F4FA}Покупка оружие через 'Alt' - {FF0000}50 SCORE | 3 Level\n",strlen(String));
		        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Мелкие Достижение",String,"»]Ok]«","»]Выход]«");
		    }
	    }
		else // Возврощение в меню
	    {
	        new String[2048];
	        strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
	        strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
	        strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
	        strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
	        strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
	        strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
	        strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
	        strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
	        strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
	        strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
	        strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
	        strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
	        strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
	        strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
	        strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
	        strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
	        strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
	        strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
	        strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
	        ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
    }

    if(dialogid == 7975)
    {
	    if(response)
	    {
		    if(listitem == 0)
		    {
		        GameTextForPlayer(playerid, "~g~~h~O6S4HSи CTNLJ", 3000, 4);
		        SetPlayerFightingStyle(playerid, 4);
		        PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		    }
		    if(listitem == 1)
		    {
      			if(GetPlayerScore(playerid) < 100) return SendClientMessage(playerid, -1, "* {FF0000}Стиль 'Боксёра' доступен с 4 Level!!");
		        GameTextForPlayer(playerid, "~y~BOKCEPCKNи CTNLJ", 3000, 4);
		        SetPlayerFightingStyle(playerid, 5);
		        PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		    }
		    if(listitem == 2)
		    {
      			if(GetPlayerScore(playerid) < 1000) return SendClientMessage(playerid, -1, "* {FF0000}Стиль 'Каратиста' доступен с 9 Level!!");
		        GameTextForPlayer(playerid, "~b~~h~CTNLJ KAPATNCTA", 3000, 4);
		        SetPlayerFightingStyle(playerid, 6);
		        PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		    }
		    if(listitem == 3)
		    {
      			if(GetPlayerScore(playerid) < 2600) return SendClientMessage(playerid, -1, "* {FF0000}Стиль 'Гангстера' доступен с 12 Level!!");
		        GameTextForPlayer(playerid, "~r~CTNLJ FAHFCTEPA", 3000, 4);
		        SetPlayerFightingStyle(playerid, 7);
		        PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		    }
		    if(listitem == 4)
		    {
		        GameTextForPlayer(playerid, "~w~lokteboи CTNLJ", 3000, 4);
		        SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
		        PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		    }
	    }
	    else // Возврощение в меню
	    {
	        new String[2048];
	        strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
	        strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
	        strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
	        strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
	        strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
	        strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
	        strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
	        strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
	        strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
	        strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
	        strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
	        strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
	        strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
	        strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
	        strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
	        strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
	        strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
	        strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
	        strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
	        ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
    }

    if(dialogid == 80){
    if(response == 1){
    new Float:health;
    GetPlayerHealth(playerid,health);
    switch(listitem) {
    case 0:  SetPlayerSpecialAction(playerid,22)
            ,GivePlayerMoney(playerid,-2)
            ,GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~b~~h~~h~~h~BS 3AZLATNLN $1",2000,3)
            ,PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0)
            ,SendClientMessage(playerid,COLOR_GREEN,"{4440F4}*** {49EF45}Пейте на здоровье ;)");
    case 1: SetPlayerSpecialAction(playerid,20)
            ,GivePlayerMoney(playerid,-4)
            ,GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~b~~h~~h~~h~BS 3AZLATNLN $1",2000,3)
            ,PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0)
            ,SendClientMessage(playerid,COLOR_GREEN,"{4440F4}*** {49EF45}Пейте на здоровье ;)");
    case 2:  SetPlayerSpecialAction(playerid,23)
            ,GivePlayerMoney(playerid,-1)
            ,GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~b~~h~~h~~h~BS 3AZLATNLN $1",2000,3)
            ,PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0)
            ,SendClientMessage(playerid,COLOR_GREEN,"{4440F4}*** {49EF45}Пейте на здоровье ;)");
    case 3: SetPlayerSpecialAction(playerid,21)
            ,GivePlayerMoney(playerid,-1)
            ,GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~b~~h~~h~~h~BS 3AZLATNLN $1",2000,3)
            ,PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0)
            ,SendClientMessage(playerid,COLOR_GREEN,"{4440F4}*** {49EF45}Менздрав предуприждает! Куренье это ЯД ;)");
    case 4:  SetPlayerDrunkLevel (playerid, 0)
            ,SendClientMessage(playerid,COLOR_GREEN,"{4440F4}*** {49EF45}Вы отрезвели !!!");

    }
    }
    return 1;
    }

    if(dialogid == 142)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerPos(playerid,1673.6046,-1340.9886,158.4766);
				SetPlayerFacingAngle(playerid,91.2318);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Deagle DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,24,500);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		   	    SetPlayerInterior(playerid,0);
		   	    SetPlayerVirtualWorld(playerid,3);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 1)
			{
				SetPlayerPos(playerid,1282.6284,-1199.2778,94.2266);
				SetPlayerFacingAngle(playerid,91.2318);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'9mm DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,22,500);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,4);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 2)
			{
				SetPlayerPos(playerid,1666.9998,-1253.1271,233.3750);
				SetPlayerFacingAngle(playerid,175.5191);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Shotgun DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,25,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,5);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 3)
			{
				SetPlayerPos(playerid,1080.7910,-1171.9169,64.5000);
				SetPlayerFacingAngle(playerid,267.3033);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Deagle+Shot DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,25,500);
				GivePlayerWeapon(playerid,24,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,6);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 4)
			{
				SetPlayerPos(playerid,1282.6284,-1199.2778,94.2266);
				SetPlayerFacingAngle(playerid,114.4186);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Silenced Pistol DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,23,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,7);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 5)
			{
				SetPlayerPos(playerid,1774.5293,-1121.1003,84.4766);
				SetPlayerFacingAngle(playerid,114.4186);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'M4 DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,31,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,8);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 6)
			{
				SetPlayerPos(playerid,-1848.9814,1062.0646,145.1297);
				SetPlayerFacingAngle(playerid,274.5101);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'M5 DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,29,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,9);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 7)
			{
				SetPlayerPos(playerid,1449.8163,-1063.7456,213.3828);
				SetPlayerFacingAngle(playerid,186.8460);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Sawnoff Shotgun DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,26,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,10);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 8)
			{
				SetPlayerPos(playerid,295.4582,-1610.4799,114.4219);
				SetPlayerFacingAngle(playerid,86.8917);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Chainsaw DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,9,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,11);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 9)
			{
		    	new rand = random(sizeof(RpgTele));
		    	SetPlayerPos(playerid, RpgTele[rand][0], RpgTele[rand][1], RpgTele[rand][2]);
				SetPlayerFacingAngle(playerid,86.8917);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'RPG DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,35,5);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,12);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 10)
			{
		    	new rand = random(sizeof(AnaRandomTele));
		    	SetPlayerPos(playerid, AnaRandomTele[rand][0], AnaRandomTele[rand][1], AnaRandomTele[rand][2]);
				SetPlayerFacingAngle(playerid,86.8917);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Sniper DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				SetPlayerWeather(playerid, 09);
		   	 	SetPlayerTime(playerid, 1,0);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,34,5000);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,13);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 11)
			{
		    	SetPlayerPos(playerid,1774.5293,-1121.1003,84.4766);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Deagle + Ak-47 + Rifle DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,33,500);
				GivePlayerWeapon(playerid,30,500);
				GivePlayerWeapon(playerid,24,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,14);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 12)
			{
		    	new rand = random(sizeof(MRandomTele));
		    	SetPlayerPos(playerid, MRandomTele[rand][0], MRandomTele[rand][1], MRandomTele[rand][2]);
				SetPlayerFacingAngle(playerid,86.8917);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Deagle + M4 + Sawn + UZI DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,24,500);
				GivePlayerWeapon(playerid,26,500);
				GivePlayerWeapon(playerid,28,500);
				GivePlayerWeapon(playerid,31,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,15);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 13)
			{
		    	SetPlayerPos(playerid,1518.6472,-1468.9209,63.8594);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Tec 9 DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,32,700);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,16);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 14)
			{
		   		SetPlayerPos(playerid,1518.6472,-1468.9209,63.8594);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Micro SMG/Uzi DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,28,700);
		   	 	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,17);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 15)
			{
		    	SetPlayerPos(playerid,1518.6472,-1468.9209,63.8594);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Combat Shotgun DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,27,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,18);
		    	SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 16)
			{
		    	SetPlayerPos(playerid,3758.48,-1013.72,26.44);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Silenced Pistol + Rifle DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,33,500);
		    	GivePlayerWeapon(playerid,23,500);
		   	    SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,19);
		    	SetTogglePlayerPos(playerid);
		    }
			if(listitem == 17)
			{
		    	SetPlayerPos(playerid,2059.4319,2398.9604,150.4766);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Country Rifle DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
				GivePlayerWeapon(playerid,33,200);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,20);
		    	SetTogglePlayerPos(playerid);
			}
			if(listitem == 18)
			{
		    	SetPlayerPos(playerid,2388.1917,2084.7466,58.7220);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'AK-47 DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,30,500);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,21);
		    	SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 19)
			{
		    	SetPlayerPos(playerid,2401.2039,1573.7902,64.4430);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Fire Extinguisher DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,42,5000);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,22);
		    	SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 20)
			{
		    	SetPlayerPos(playerid,2190.7288,1038.0234,79.5547);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Flamethrower + Molotov Cocktail DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		   	    GivePlayerWeapon(playerid,18,10);
		    	GivePlayerWeapon(playerid,37,200);
			 	SetPlayerInterior(playerid,0);
			 	SetPlayerVirtualWorld(playerid,23);
		   	    SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 21)
			{
		    	SetPlayerPos(playerid,2059.4319,2398.9604,150.4766);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Silenced Pistol + M5 DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,23,100);
		   	 	GivePlayerWeapon(playerid,29,100);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,24);
		    	SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 22)
			{
		   	 	SetPlayerPos(playerid,2190.7288,1038.0234,79.5547);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Uzi + Molotov Cocktail DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,18,10);
		    	GivePlayerWeapon(playerid,28,200);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,25);
		    	SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 23)
			{
		    	SetPlayerPos(playerid,3758.48,-1013.72,26.44);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[128];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок {FF0000}%s {FF6600}телепортировался на {FF0000}'Combat Shotgun + 9mm DM'", name);
				SendClientMessageToAll(0xFF6600AA, string);
				ResetPlayerWeapons(playerid);
				SetPlayerHealthAC(playerid,100);
				SetPlayerArmorAC(playerid,100);
		    	GivePlayerWeapon(playerid,27,300);
		    	GivePlayerWeapon(playerid,22,300);
		    	SetPlayerInterior(playerid,0);
		    	SetPlayerVirtualWorld(playerid,26);
		    	SetTogglePlayerPos(playerid);
		    }
		    if(listitem == 24)
		    {
		    	OnPlayerCommandText(playerid,"/cs");//CS DM
		    }
	    }
	    else // Возврощение в меню
	    {
	    	new String[2048];
	    	strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
	    	strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
	    	strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
	    	strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
	    	strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
	    	strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
	    	strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
	    	strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
	    	strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
	    	strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
	    	strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
	    	strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
	    	strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
	    	strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
	   	 	strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
	    	strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
	   	 	strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
	    	strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
	    	strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
	    	ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	    }
    }

	if(dialogid == 270)
	{
	    if(response == 1)
	    {
		    if(listitem == 0)
		    {
			    new string[256];
			    new namanama[MAX_PLAYER_NAME];
				GetPlayerName(ReceiverID[playerid],namanama,sizeof(namanama));
			    pm2player_id[playerid]=ReceiverID[playerid];
				pm1playerid[playerid]=playerid;
				format(string,sizeof(string),"PM Сообщение игроку %s",namanama);
				ShowPlayerDialog(playerid, PM_DLG_ID,DIALOG_STYLE_INPUT, "Ввод ЛС", string, "ОК", "Отмена");
		    }
		    if(listitem == 1)
		    {
			    new str[100],name[24];
			    GetPlayerName(ReceiverID[playerid], name, sizeof(name));
			    format(str,sizeof(str),"Введите сумму перевода игроку %s",name);
			    ShowPlayerDialog(playerid,800,DIALOG_STYLE_INPUT,"Система перевода денег",str,"Ok","Выход");
		    }
		    if(listitem == 2)
		    {
		        new str[100],name[24];
		        GetPlayerName(ReceiverID[playerid], name, sizeof(name));
		        format(str,sizeof(str),"Введите жалобу на игрока %s",name);
		        ShowPlayerDialog(playerid,594,DIALOG_STYLE_INPUT,"Система жалоб",str,"Ok","Выход");
		    }
		    if(listitem == 3)
		    {
			    new idp = ReceiverID[playerid];
		        new player1, NamePlayer[24] , string[128],str1[128],str2[128],str3[128],str4[128],str5[128],str6[128],str7[128],str10[128],str11[128],str12[128],str13[128],str14[1300];
			    player1 = ReceiverID[playerid];
		        GetPlayerName(player1, NamePlayer, sizeof(NamePlayer));
			 	if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				    new Float:player1health, Float:player1armour, playerip[128], tmp2[256], file[256],P1Jailed[15], P1Frozen[15], RegDate[256];
					GetPlayerHealth(player1,player1health);
					GetPlayerArmour(player1,player1armour);
			    	GetPlayerIp(player1, playerip, sizeof(playerip));
					format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(NamePlayer));
					if(PlayerInfo[player1][Jailed] == 1) P1Jailed = "{FF0000}Да"; else P1Jailed = "{00FF00}Нет";
					if(PlayerInfo[player1][Frozen] == 1) P1Frozen = "{FF0000}Да"; else P1Frozen = "{00FF00}Нет";
					if(dUserINT(PlayerName2(player1)).("LastOn")==0) tmp2 = "Never"; else tmp2 = dini_Get(file,"LastOn");
					if(strlen(dini_Get(file,"RegisteredDate")) < 3) RegDate = "n/a"; else RegDate = dini_Get(file,"RegisteredDate");

			  		format(string, sizeof(string)," {FFFF00}Ник: %s  {0000FF}ID: %d", NamePlayer,player1);

					format(str1, sizeof(str1),"   {FFFF00}Админ Уровень:{0000FF} %d",PlayerInfo[player1][Level]);

					format(str2, sizeof(str2),"   {FFFF00}Дата Регистрации:{0000FF} %s", RegDate);

					format(str3, sizeof(str3),"   {FFFF00}Наличные Деньги:{0000FF} %d$", GetPlayerMoney(player1));

					format(str4, sizeof(str4),"   {FFFF00}Деньги в Банке:{0000FF} %d$", udb_UserInt(PlayerName2(player1),"bank"));

		            format(str5, sizeof(str5),"   {FFFF00}Здоровье:{0000FF} %d  {FFFF00}Броня:{0000FF} %d",floatround(player1health),floatround(player1armour));

		            format(str6, sizeof(str6),"   {FFFF00}Убил:{0000FF} %d {FFFF00}Смертей:{0000FF} %d", PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths]);

		            format(str7, sizeof(str7),"   {FFFF00}Посажен: %s  {FFFF00}Заморожен: %s",P1Jailed, P1Frozen );

					format(str10, sizeof(str10),"   {FFFF00}Количество поцелуев:{0000FF} %d",udb_UserInt(PlayerName2(player1),"kiss"));

				    format(str11, sizeof(str11),"   {FFFF00}Участвовал в Дуэлях: {0000FF}%d",udb_UserInt(PlayerName2(player1),"allduel"));

					format(str12, sizeof(str12),"   {FFFF00}В браке с: {0000FF}%s",newlywed[idp]);

		            format(str13, sizeof(str13),"   {FFFF00}Ранг: {0000FF}%s",PlayerInfo[player1][RanG]);

		            format(str14, sizeof(str14),"          {FFFF00}АККАУНТ\n%s\n%s\n\n          {FFFF00}ДЕНЬГИ\n%s\n%s\n\n          {FFFF00}СОСТОЯНИЕ\n%s\n%s\n%s\n%s\n%s\n\n          {FFFF00}Личная Жизнь:\n%s\n\n          {FFFF00}Ранг:\n%s\n\n",str1, str2,str3,str4,str5,str6,str7,str10,str11,str12,str13);
					ShowPlayerDialog(playerid,73456,DIALOG_STYLE_MSGBOX,string,str14,"Ok","Выход");
				}
			}
		    if(listitem == 4)
		    {
      			if(zonezapret[playerid] != 1000) return SendClientMessage(playerid, -1, "* {FF0000}В этой зоне запрещено вызвать на Дуэль {ffffff}| {FF0000}Что бы выйти введите /exit!");
		    	if(PlayerInfo[playerid][Jailed] == 1) return SendClientMessage(playerid,-1,"* {FF0000}Вы не можете вызывать игрока на Дуэль когда вы тюрьме!");
			    DuelOffer[playerid] = ReceiverID[playerid];
				if(IsPlayerConnected(DuelOffer[playerid]))
				{
					 if(DuelStatus == 0)
			         {
				         ShowPlayerDialog(playerid,5001,1,"{F8FF88}Введите цену","{EEDD00}Введите цену дуэли","Далее","Отмена");
				   	 }
					 else
			         {
				         SendClientMessage(playerid,-1,"{CC00DD}[Дуэль]{FF0000}Подождите пока не закончится дуэль");
			         }
				}
			}
		    if(listitem == 5)
		    {
	    		if(PlayerInfo[playerid][Jailed] == 1) return SendClientMessage(playerid,-1,"* {FF0000}Вы не можете следить за игроком когда вы тюрьме!");
				new specplayerid = ReceiverID[playerid];
				if(IsPlayerConnected(specplayerid) && specplayerid != INVALID_PLAYER_ID)
				{
					if(specplayerid == playerid) return SendClientMessage(playerid, red, " ОШИБКА: Вы не можете следить за собой");
					if(GetPlayerState(specplayerid) == PLAYER_STATE_SPECTATING && PlayerInfo[specplayerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "Слежка: Игрок ща за кем-то следит");
					if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, red, "Слежка: Игрок не заспанен");
					if( (PlayerInfo[specplayerid][Level] != ServerInfo[MaxAdminLevel]) || (PlayerInfo[specplayerid][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] == ServerInfo[MaxAdminLevel]) )
					{
						StartSpectate(playerid, specplayerid);
						GetPlayerFacingAngle(playerid,Pos[playerid][3]);
						return SendClientMessage(playerid,0xFF8000AA,"[Р-Ц™]: Дальше - {FFFFFF}'Shift'! {FF8000}Выйти - {FFFFFF}'Пробел'");
					} else return SendClientMessage(playerid,0xFF8000AA," [ОШИБКА]: Вы не можете следить за админом, выше вас уровнем");
				} else return SendClientMessage(playerid,0xFF8000AA," [ОШИБКА]:  Нет такого игрока");
			}
		}
	}

    if(dialogid == 800)
    {
	    new bbb = strval(inputtext);
	    new ddd = ReceiverID[playerid];
	    {
		    if(response == 1)
		    {
			    if (bbb > 0)
			    {
				    new money1 = GetPlayerMoney(playerid);
				    if (money1 > bbb)
				    {
					    if (bbb < 1000000001)
					    {
						    new name2[25];
						    new name1[25];
						    if(IsPlayerConnected(ddd) && ddd != INVALID_PLAYER_ID)
						    GivePlayerMoney(ddd, bbb);
						    GivePlayerMoney(playerid, -bbb);
						    new str[256];
						    new stra[256];
						    GetPlayerName(ddd, name2, sizeof(name2));
						    GetPlayerName(playerid, name1, sizeof(name1));
						    format(str,sizeof(str),"Вы перевели $%d на лицевой счёт %s(%d)",bbb,name2, ddd);
						    SendClientMessage(playerid,0x009F9FFF, str);
						    format(stra,sizeof(stra),"Вы получили $%d от %s(%d)",bbb,name1,playerid);
						    SendClientMessage(ddd,0x009F9FFF, stra);
					    }
				    	else SendClientMessage(playerid,0xFF0000AA, "Вы не можете совершить такой башьшой перевод! (максимум $1000000000)");
				    }
			    	else SendClientMessage(playerid,0xFF0000AA, "У вас недостаточно денег для такого большого перевода...");
			    }
		    	else SendClientMessage(playerid,0xFF0000AA, "Вы неможете перевести 0$...");
		    }
	    }
    }

    if(dialogid == 594)
    {
    if(response == 1)
    {
        //new textJ = inputtext;
        new reported = ReceiverID[playerid];
        if(IsPlayerConnected(reported) && reported != INVALID_PLAYER_ID)
		{
	        //if(textJ > 7) {
	        if(strlen(inputtext) < 8) return ShowPlayerDialog(playerid,1975,DIALOG_STYLE_MSGBOX,"Ошибка","Ваша жалоба слишком короткая...","Повторить","Выход");
	        if(PlayerInfo[reported][Level] == ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете пожаловаться на админа");
	        //if(playerid == reported) return SendClientMessage(playerid,red," ОШИБКА: Вы не можете пожаловаться на себя");
	        new reportedname[MAX_PLAYER_NAME], reporter[MAX_PLAYER_NAME], str[128], hour,minute,second; gettime(hour,minute,second);
	        GetPlayerName(reported, reportedname, sizeof(reportedname));	GetPlayerName(playerid, reporter, sizeof(reporter));
	        format(str, sizeof(str), " ||НОВАЯ ЖАЛОБА||  %s(%d) жалуется на %s(%d) Причина: %s |@%d:%d:%d|", reporter,playerid, reportedname, reported, inputtext, hour,minute,second);
	        MessageToAdmins(COLOR_WHITE,str);
	        SaveToFile("ReportLog",str);
	        SendClientMessage(playerid,0xFF0000AA, "[Р-Ц™]: {FFFF80}Ваша жалоба отправлена всем админам, которые сейчас в игре.");
	        //}else return ShowPlayerDialog(DuelPlayer2,59875,DIALOG_STYLE_MSGBOX,"Ошибка","Ваша жалоба слишком короткая...","Повтор","Выход);
	        }else return SendClientMessage(playerid, red, " Игрок уже вышел, вы не успели ;)");
		}
	}

    if(dialogid == 1975)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,594,DIALOG_STYLE_INPUT,"Система жалоб","Введите текст жалобы...","Ok","Выход");
	    }
    }

    if(dialogid==PM_DLG_ID)
    {
    if(response==1)
    {
        if(!strlen(inputtext)) return SendClientMessage(playerid,COLOR_RED, " Вы не написали сообщение");
        if(strlen(inputtext) > 100) return SendClientMessage(playerid,COLOR_RED, " Слишком длинное сообщение");
        new pm[512];
        new playername[30];
        new namepm1[MAX_PLAYER_NAME];
        new namepm2[MAX_PLAYER_NAME];
        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(pm2player_id[playerid],X,Y,Z);
        GetPlayerName(pm1playerid[playerid], namepm1, sizeof(namepm1));
        GetPlayerName(pm2player_id[playerid], namepm2, sizeof(namepm2));
        GetPlayerName(playerid,playername,sizeof(playername));
        format(pm, sizeof(pm), "{D5FF02}* Вам пришло ЛС от %s(%d): {E7DF57}%s", namepm1, pm1playerid[playerid], inputtext);
        SendClientMessage(pm2player_id[playerid], 0xFFFF00AA, pm);
        format(pm, sizeof(pm), "{D5FF02}* Вы отправили ЛС игроку {E7DF57}%s(%d): %s", namepm2, pm2player_id[playerid], inputtext);
        SendClientMessage(playerid, 0xFFFF00AA, pm);
        format(pm, sizeof(pm), "{EEE8AA} %s(%d) пишет ЛС %s(%d): %s ", namepm1, pm1playerid[playerid], namepm2, pm2player_id[playerid], inputtext);
        MessageToAdmins(yellow,pm);
        PlayerPlaySound(pm2player_id[playerid],1149,X,Y,Z);
        }
        else
        {
        	SendClientMessage(playerid,COLOR_RED, " Вы отказались писать сообщение");
    	}
	}

    if(dialogid == 26165)
    {
	    if(response==1)
	    {
	        ShowPlayerDialog(playerid, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья сука", "{FF3300}Это окошечко счастья пидар\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}За твое ебаное повидение уёбак тупой мудло ебаное пидрило", "ИДИ", "НАХУЙ");
	        return ShowPlayerDialog(playerid, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья сука", "{FF3300}Это окошечко счастья пидар\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}За твое ебаное повидение уёбак тупой мудло ебаное пидрило", "ИДИ", "НАХУЙ");
	        }
	        else
	    if(response==0)
	    {
	        ShowPlayerDialog(playerid, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья сука", "{FF3300}Это окошечко счастья пидар\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}За твое ебаное повидение уёбак тупой мудло ебаное пидрило", "ИДИ", "НАХУЙ");
	        return ShowPlayerDialog(playerid, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья сука", "{FF3300}Это окошечко счастья пидар\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}За твое ебаное повидение или за читы уёбак тупой мудло ебаное пидрило", "ИДИ", "НАХУЙ");
	    }
    }

    if(dialogid == DIALOG_LOGIN)
    {
	    if(!udb_Exists(PlayerName2(playerid)) && IsPlayerConnected(playerid)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{00FFD5}Регистрация на Entertaining Center'e!", "{42aaff}Для регистрации введите свой пароль в окошко\n{42aaff}Пароль не должен быть простым\n{42aaff}И должен состоять от 4 до 25 символов", "Войти", "Выйти");
	    if(PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}Вы уже успешно вошли ");
	    if(response==1)
	    {
	        if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{00FFD5}Пожалуйста, залогиньтесь!", "{42aaff}Ваш ник зарегистрирован на этом сервере!\n{42aaff}Для продолжения введите свой пароль в окошко:", "Ок", "Выйти");
	        if(strlen(inputtext) > 20) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{00FFD5}Пожалуйста, залогиньтесь!", "{42aaff}Ваш ник зарегистрирован на этом сервере!\n{42aaff}Для продолжения введите свой пароль в окошко:", "Ок", "Выйти");
	        if (strlen(inputtext) == 0)
	        {
		        SendClientMessage(playerid,red,"{11F244}*** {F4C522}Нельзя оставить поле пустым! *");
		        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{00FFD5}Пожалуйста, залогиньтесь!", "{42aaff}Ваш ник зарегистрирован на этом сервере!\n{42aaff}Для продолжения введите свой пароль в окошко:", "Ок", "Выйти");
	        }
	        if(udb_CheckLogin(PlayerName2(playerid),inputtext))
	        {
		        new file[256], tmp3[100], string[128], name[130];
		        GetPlayerIp(playerid,tmp3,100);
		        GetPlayerName(playerid,name,130);
		        format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(playerid)));
		        dini_Set(file,"ip",tmp3);
		        printf("%s has logged in [password: %s]",name,inputtext);
		        LoginPlayer(playerid);
		        if(PlayerInfo[playerid][Level] > 0)
		        {
		        format(string,sizeof(string),"{11F244}*** {F4C522}Вы успешно залогинились. {FF0000}(Админ уровень %d)",PlayerInfo[playerid][Level]);
		        SendClientMessage(playerid,green,string);
	        	}
	        	else
	        	{
        		SendClientMessage(playerid,green,"{11F244}*** {F4C522}Вы успешно залогинились. Приятной игры :) ");
	        	}
        		}
        		else
        		{
		        PlayerInfo[playerid][FailLogin]++;
		        new strng[245];
		        format(strng, sizeof(strng), "{FF0000}Неверный пароль! Попытка: %d из %d",PlayerInfo[playerid][FailLogin],MAX_FAIL_LOGINS);
		        SendClientMessage(playerid,yellow,strng);
		        printf("LOGIN: %s has failed to login, Wrong password (%s) Attempt (%d)", PlayerName2(playerid), inputtext, PlayerInfo[playerid][FailLogin] );
		        if(PlayerInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
		        {
		        new string[128];
		        format(string, sizeof(string), "{00F200}*** {FF0000}%s Был Кикнут системой (Причина: Забыл пароль/Пытался взломать пароль)", PlayerName2(playerid) );
		        SendClientMessageToAll(COLOR_RED, string);
		        print(string);
		        Kick(playerid);
		        }
		        else
		        {
		        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{00FFD5}Пожалуйста, залогиньтесь!", "Ваш ник зарегистрирован на этом сервере!\nДля продолжения введите свой пароль в окошко:", "Ок", "Выйти");
		        }
		        }
	        }
	        else
	        if(response==0)
	        {
	        new string[128];
	        format(string, sizeof(string), "{00F200}*** {FF0000}%s Был Кикнут системой (Причина: Отказ от логина)", PlayerName2(playerid) );
	        SendClientMessageToAll(COLOR_RED, string);
	        print(string);
	        Kick(playerid);
	    }
	}

    if(dialogid == DIALOG_REGISTER)
    {
        if(PlayerInfo[playerid][LoggedIn] == 1 || udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}Вы уже зарегистрированы и залогинены *");
        if(response==1)
        {
	        if(strlen(inputtext) == 0) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}Нельзя оставить поле пустым! *");
	        if(strlen(inputtext) < 4)return SendClientMessage(playerid,red,"{11F244}*** {F4C522}Слишком короткий пароль") && ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{00FFD5}Регистрация на Entertaining Center'e!", "{FF0000}ERROR!\n{42aaff}У вас произошла не правельное действие (Смотри в чате!)\n{42aaff}Придумай себе пароль и введите его в поле", "Войти", "Выход");
	        if(strlen(inputtext) > 20) return SendClientMessage(playerid,red,"{11F244}*** {F4C522}Слишком длинный пароль") && ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{00FFD5}Регистрация на Entertaining Center'e!", "{FF0000}ERROR!\n{42aaff}У вас произошла не правельное действие (Смотри в чате!)\n{42aaff}Придумай себе пароль и введите его в поле", "Войти", "Выход");
	        if(udb_Create(PlayerName2(playerid),inputtext))
	        {
		        new file[256],name[MAX_PLAYER_NAME], tmp3[100];
		        new strdate[20], year,month,day;	getdate(year, month, day);
		        GetPlayerName(playerid,name,sizeof(name)); format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(name));
		        GetPlayerIp(playerid,tmp3,100);	dini_Set(file,"ip",tmp3);
		        dini_Set(file,"password",inputtext);
		        //dini_Set(file,"nickname",name);
		        dUserSetINT(PlayerName2(playerid)).("registered",1);
		        format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
		        dini_Set(file,"RegisteredDate",strdate);
		        dUserSetINT(PlayerName2(playerid)).("loggedin",1);
		        dUserSetINT(PlayerName2(playerid)).("banned",0);
		        dUserSetINT(PlayerName2(playerid)).("level",0);
		        dUserSetINT(PlayerName2(playerid)).("LastOn",0);
		        dUserSetINT(PlayerName2(playerid)).("money",0);
		        dUserSetINT(PlayerName2(playerid)).("kills",0);
		        dUserSetINT(PlayerName2(playerid)).("deaths",0);
		        dUserSetINT(PlayerName2(playerid)).("jailed",0);
		        dUserSetINT(PlayerName2(playerid)).("fgoed",0);
		        dUserSetINT(PlayerName2(playerid)).("frozen",0);
		        dUserSetINT(PlayerName2(playerid)).("muted",0);
		        dUserSetINT(PlayerName2(playerid)).("dialoged",0);
		        dUserSetINT(PlayerName2(playerid)).("cameraed",0);
		        dUserSetINT(PlayerName2(playerid)).("blinded",0);
		        dUserSetINT(PlayerName2(playerid)).("vippp",0);
		        PlayerInfo[playerid][LoggedIn] = 1;
		        PlayerInfo[playerid][Registered] = 1;
		        SendClientMessage(playerid, green, "{11F244}*** {F4C522}Вы зарегистрированы, вы автоматически залогинились");
		        SendClientMessage(playerid, green, "{11F244}*** {F4C522}Для более точной информации нажмите 'Y' или введите /help!");
		        PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	        }
        }
        else
        if(response==0)
        {
	        Kick(playerid);
	        SendClientMessage(playerid,COLOR_RED,"{11F244}*** {FF0000}Вы отказались от регистрации");
    	}
	}

    if(dialogid == 4763)
    {
	    if(response == 1)
	    {
		    if(listitem == 0)
		    {
		        new namebank[MAX_PLAYER_NAME];
		        GetPlayerName(playerid, namebank, sizeof(namebank));
		        if(udb_UserInt(namebank,"bank") > -10000 )
		        {
		          ShowPlayerDialog(playerid,4764,DIALOG_STYLE_MSGBOX,"{00fff3}Хорошо подумайте перед выбором!","                                                     {ffcc00}Помните и не забывайте никогда !!!\n{7fff00}Если ваш баланс будет отрицательный, то каждый час будет отчисляться 2% от вашей задолжности","..::|Далее|::..","..::|Выход|::..");
		        }
		        else ShowPlayerDialog(playerid,4774,DIALOG_STYLE_MSGBOX,"{ff000b}Ошибка","{ff0500}В данный момент вы не можете снимать деньги\n    {}у вас итак уже большая задолжность","..::|Ok|::..",".:|Выход|:.");
		    }
		    if(listitem == 1)
		    {
		        ShowPlayerDialog(playerid,4765,DIALOG_STYLE_MSGBOX,"{00fff3}Хорошо подумайте перед выбором!","                                                 {ffcc00}Помните и не забывайте никогда !!!\n{7fff00}Если ваш баланс положительный, то каждый час вам будет начисляться 1% от вашего счёта","..::|Далее|::..","..::|Выход|::..");
		    }
		    if(listitem == 2)
		    {
		        new namebank[MAX_PLAYER_NAME];
		        new BankStr[256];
		        GetPlayerName(playerid, namebank, sizeof(namebank));
		        format(BankStr, sizeof(BankStr), "{bfff00}На данный момент у вас на счёте $%d",udb_UserInt(namebank,"bank"));
		        ShowPlayerDialog(playerid,4778,DIALOG_STYLE_MSGBOX,"{bfff00}Ваш счёт в банке",BankStr,"Ok","Выход");
      		}
	    }
	}

    if(dialogid == 4765)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4766,DIALOG_STYLE_INPUT,"{ff0500}Система пополнения счёта в банке","{f3ff00}Введите сумму денег...","..::|Пополнить|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == 4764)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4769,DIALOG_STYLE_INPUT,"{ff0500}Система снятия денег с счёта","{f3ff00}Введите сумму денег...","..::|Снять|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == 4766)
    {
	    if(response == 1)
	    {
		    if(strval(inputtext) > 99)
		    {
		        if(strval(inputtext) < 1000000001)
		        {
			        if(GetPlayerMoney(playerid) + 1 > strval(inputtext))
		            {
		               new namebank[MAX_PLAYER_NAME];
		               new BankStr[256];
		               GetPlayerName(playerid, namebank, sizeof(namebank));
		               if(udb_UserIsset(namebank,"bank")) udb_UserSetInt(namebank,"bank", udb_UserInt(namebank,"bank") + strval(inputtext)); else udb_UserSetInt(namebank,"bank", strval(inputtext));
		               format(BankStr, sizeof(BankStr), "{f3ff00}Мы вас поздравляем!\n  {00ff00}Вы пополнили свой счёт на $%d\n       {ff0c00}Ваш счёт: $%d",strval(inputtext),udb_UserInt(namebank,"bank"));
		               ShowPlayerDialog(playerid,4768,DIALOG_STYLE_MSGBOX,"Поздравление!",BankStr,"Ok","Выход");
		               GivePlayerMoney(playerid, -strval(inputtext));
		            }
		            else ShowPlayerDialog(playerid,4775,DIALOG_STYLE_MSGBOX,"{ff0c00}Ошибка","{d4ff00}У вас нет так много денег\n    {99ff99}введите сумму не более того что у вас есть","..::|Повтор|::..","..::|Выход|::..");
		        }
				else ShowPlayerDialog(playerid,4772,DIALOG_STYLE_MSGBOX,"{ff0c00}Ошибка","{d4ff00}Вы не можете положить сразу так много\n    {99ff99}максимальная сумма взноса 1000000000$ за раз","..::||Повторить||::..","..::|Выход|::..");
			}
			else ShowPlayerDialog(playerid,4767,DIALOG_STYLE_MSGBOX,"{ff0c00}Ошибка","{d4ff00}Вы не можете положить так мало\n    {99ff99}минимальная сумма взноса 100$","Повторить","Выход");
		}
	}


    if(dialogid == 4769)
    {
	    if(response == 1)
	    {
		    if(strval(inputtext) > 99)
		    {
		        if(strval(inputtext) < 1000000001)
		        {
		              new namebank[MAX_PLAYER_NAME];
		              new BankStr[256];
		              GetPlayerName(playerid, namebank, sizeof(namebank));

		              if ( ( udb_UserInt(namebank,"bank") - strval(inputtext) ) < - 50000) return ShowPlayerDialog(playerid,4773,DIALOG_STYLE_MSGBOX,"{d4ff00}Ошибка","{f9ff00}Вы не можете снять так много","..::|Повторить|::..","..::|Выход|::..");

		              if(udb_UserIsset(namebank,"bank")) udb_UserSetInt(namebank,"bank", udb_UserInt(namebank,"bank") - strval(inputtext)); else udb_UserSetInt(namebank,"bank", -strval(inputtext));
		              format(BankStr, sizeof(BankStr), "{f3ff00}Мы вас поздравляем!\n {00ff00}Вы сняли со своего счёта $%d\n       {ff0c00}Ваш счёт: $%d",strval(inputtext),udb_UserInt(namebank,"bank"));
		              ShowPlayerDialog(playerid,4771,DIALOG_STYLE_MSGBOX,"Поздравление!",BankStr,"Ok","Выход");
		              GivePlayerMoney(playerid, strval(inputtext));
		        }
				else ShowPlayerDialog(playerid,4773,DIALOG_STYLE_MSGBOX,"{ff0c00}Ошибка","{d4ff00}Вы не можете снять сразу так много\n    {99ff99}максимальная сумма снятия 1000000000$ за раз","..::|Повторить|::..","..::|Выход|::..");
			}
	     	else ShowPlayerDialog(playerid,4770,DIALOG_STYLE_MSGBOX,"{ff0c00}Ошибка","{d4ff00}Вы не можете снять так мало\n    {99ff99}минимальная сумма снятия 100$","..::|Повторить|::..","..::|Выход|::..");
		}
	}
    if(dialogid == 4767)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4766,DIALOG_STYLE_INPUT,"{ff0000}Система пополнения счёта в банке","{adff2f}Введите сумму денег...","..::|Пополнить|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == 4770)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4769,DIALOG_STYLE_INPUT,"{ff0000}Система снятия денег с счёта","{adff2f}Введите сумму денег...","..::|Снять|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == 4772)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4766,DIALOG_STYLE_INPUT,"{ff0000}Система пополнения счёта в банке","{adff2f}Введите сумму денег...","..::|Пополнить|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == 4773)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4769,DIALOG_STYLE_INPUT,"{ff0000}Система снятия денег с счёта","{adff2f}Введите сумму денег...","..::|Снять|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == 4775)
    {
	    if(response == 1)
	    {
	        ShowPlayerDialog(playerid,4766,DIALOG_STYLE_INPUT,"{ff0000}Система пополнения счёта в банке","{adff2f}Введите сумму денег...","..::|Пополнить|::..","..::|Выход|::..");
	    }
	}

    if(dialogid == DIALOG_CHANGEPASS)
    {
	    if(response==1)
	    {
			if(PlayerInfo[playerid][LoggedIn] == 1)
			{
			    if(!strlen(inputtext)) return SendClientMessage(playerid, red, "* ПРАВКА: /changepass *");
			    if(strlen(inputtext) < 4) return SendClientMessage(playerid,red,"** Слишком короткий пароль");
			    if(strlen(inputtext) > 20) return SendClientMessage(playerid,red,"** Слишком длинный пароль");
			    new string[128];
			    dUserSetINT(PlayerName2(playerid)).("password_hash",udb_hash(inputtext));
			    dUserSet(PlayerName2(playerid)).("Password",inputtext);
			    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
			    format(string, sizeof(string),"* Вы успешно сменили пароль на [ %s ] *",inputtext);
			    return SendClientMessage(playerid,yellow,string);
			}
			else return SendClientMessage(playerid,red, "** Вы должны зарегистрироваться, чтобы использовать эту команду");
		}
		else if(response==0) return SendClientMessage(playerid,red,"* Вы отказались от смены пароля! *");
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
    ////rangs////new
    new Score = GetPlayerScore(playerid);
    if(Score < 0) format(PlayerInfo[playerid][RanG],50,"»] Новичок [«");
    if(Score >= 0 && Score < 10) format(PlayerInfo[playerid][RanG],50,"»] Новичок [«"); //1
    if(Score >= 10 && Score < 50) format(PlayerInfo[playerid][RanG],50,"»] Рядовой [«"); //2
    if(Score >= 50 && Score < 100) format(PlayerInfo[playerid][RanG],50,"»] Ефрейтор [«"); //3
    if(Score >= 100 && Score < 200) format(PlayerInfo[playerid][RanG],50,"»] Младший сержант [«"); //4
    if(Score >= 200 && Score < 350) format(PlayerInfo[playerid][RanG],50,"»] Сержант [«"); //5
    if(Score >= 350 && Score < 500) format(PlayerInfo[playerid][RanG],50,"»] Старший сержант [«"); //6
    if(Score >= 500 && Score < 750) format(PlayerInfo[playerid][RanG],50,"»] Старшина [«"); //7
    if(Score >= 750 && Score < 1000) format(PlayerInfo[playerid][RanG],50,"»] Прапорщик [«"); //8
    if(Score >= 1000 && Score < 1350) format(PlayerInfo[playerid][RanG],50,"»] Старший прапорщик [«"); //9
    if(Score >= 1350 && Score < 1800) format(PlayerInfo[playerid][RanG],50,"»] Младший лейтенант [«");
    if(Score >= 1800 && Score < 2600) format(PlayerInfo[playerid][RanG],50,"»] Лейтенант [«");
    if(Score >= 2600 && Score < 3500) format(PlayerInfo[playerid][RanG],50,"»] Старший лейтенант [«");
    if(Score >= 3500 && Score < 5000) format(PlayerInfo[playerid][RanG],50,"»] Капитан [«");
    if(Score >= 5000 && Score < 6000) format(PlayerInfo[playerid][RanG],50,"»] Майор [«");
    if(Score >= 6000 && Score < 8000) format(PlayerInfo[playerid][RanG],50,"»] Подполковник [«");
    if(Score >= 8000 && Score < 9500) format(PlayerInfo[playerid][RanG],50,"»] Полковник [«");
    if(Score >= 9500 && Score < 11000) format(PlayerInfo[playerid][RanG],50,"»] Генерал-майор [«");
    if(Score >= 11000 && Score < 15000) format(PlayerInfo[playerid][RanG],50,"»] Генерал-лейтенант [«");
    if(Score >= 15000 && Score < 20000) format(PlayerInfo[playerid][RanG],50,"»] Генерал-полковник [«");
    if(Score >= 20000) format(PlayerInfo[playerid][RanG],50,"»] Генерал Р-Ц [«");
	if(RangStatus[playerid] == 0) Attach3DTextLabelToPlayer(Rang3D[playerid],playerid,0.0,0.0,0.47);
	Update3DTextLabelText(Rang3D[playerid],0x00f9fcFF,PlayerInfo[playerid][RanG]);
	RangStatus[playerid] = 1;
    //Анти лоад зашита
    if(!IsPlayerInRangeOfPoint(playerid,20000.0,0.0,0.0,0.0))
	{
	    ShowPlayerDialog(playerid,-1,0," "," "," "," ");
		ShowPlayerDialog(playerid,5719,DIALOG_STYLE_MSGBOX,"{ff0000}Спасения!!!","{7df9ff}Читеры попытался закинуть вас в загрузку, но мы вас спасли!!!","Ок","Ок");
		SetPlayerPos(playerid,Coords[0],Coords[1],Coords[2]);
		BugTicks[playerid]++;
		if(BugTicks[playerid] > 500) return SetPlayerHealth(playerid,0.0);
	}
	else BugTicks[playerid] = 0;

    SetPlayerScore(playerid,PlayerInfo[playerid][Kills]);

    if(dUserINT(PlayerName2(playerid)).("cameraed") == 1 || PlayerInfo[playerid][Cameraed] == 1)
    {
	    Camera(playerid);
	    return Camera(playerid);
    }
    if(dUserINT(PlayerName2(playerid)).("fgoed") == 1 || PlayerInfo[playerid][Fgoed] == 1 && IsPlayerInAnyVehicle(playerid))
    {
	    RemovePlayerFromVehicle(playerid);
	    return RemovePlayerFromVehicle(playerid);
    }
    if(dUserINT(PlayerName2(playerid)).("dialoged") == 1 || PlayerInfo[playerid][Dialoged] == 1)
    {
	    ShowPlayerDialog(playerid, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья сука", "{FF3300}Это окошечко счастья пидар\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}За твое ебаное повидение или ЧИТЫ уёбак тупой мудило ебаное пидрило", "ИДИ", "НАХУЙ");
	    return ShowPlayerDialog(playerid, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья сука", "{FF3300}Это окошечко счастья пидар\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}За твое ебаное повидение или ЧИТЫ уёбак тупой мудило ебаное пидрило", "ИДИ", "НАХУЙ");
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(Ceniantifloodcmd[playerid] == 1) return  SendClientMessage(playerid, 0xFF0000AA, "[Anti-Flood Cmds]: {FF8888}Не флуди командами, баклан. Жди {FF0000}3 {FF8888}секунды после введения команды!");
    Ceniantifloodcmd[playerid] = 1; 
    SetTimerEx("ANTIFLUD", 3000,0,"d",playerid);
    
	if(PlayerInfo[playerid][LoggedIn] == 0) return SendClientMessage(playerid,red,"  {ff0000}[Ошибка] {ff3300}Вы {ff6600}должны {ff9900}быть {ffcc00} залогинены чтоб пользоваться командами....");

	if(zonezapret[playerid] != 1000)
	{
	    if(PlayerInfo[playerid][Level] >= 0)
		{
		    if (strcmp("/exit", cmdtext, true, 10) == 0)
			{
				SetPlayerVirtualWorld(playerid,0);
				SetPlayerInterior(playerid,0);
			    ResetPlayerWeapons(playerid);
			    GivePlayerWeapon(playerid,31,500);
			    GivePlayerWeapon(playerid,24,200);
			    SetPlayerArmorAC(playerid,100.0);
			    SetPlayerHealthAC(playerid,100.0);
			    zonezapret[playerid] = 1000;
			    SetPlayerPos(playerid,351.1953,-1793.9633,4.9237);
				return true;
			}
	    	SendClientMessage(playerid,red,"{FFFFFF}* {FF0000}В этой зоне запрещено использывать команды! {FFFFFF}| {FF0000}Что бы выйти введите /exit!");
	    	return true;
		}
	}

	if(strcmp(cmdtext, "/exit", true) == 0)
	{
	    if(zonezapret[playerid] != 1000)
		{
		    SetPlayerPos(playerid,351.1953,-1793.9633,4.9237);
			SetPlayerVirtualWorld(playerid,0);
		    zonezapret[playerid] = 1000;
		    return true;
			}
			else{
			SendClientMessage(playerid,0xFFFFFFAA,"* {FF0000}Ты не в Counte Strike, Meat Game, Mini Game!");
		}
		return true;
	}

	fixchars(cmdtext);
	if(PlayerInfo[playerid][Jailed] == 1) return SendClientMessage(playerid,-1,"* {FF0000}Вы не можете пользоваться командами в тюрьме!");
	new cmd[256], string[128], tmp[256], idx;
	cmd = strtok(cmdtext, idx);
	#if defined USE_AREGISTER
  	dcmd(aregister,9,cmdtext); dcmd(alogin,6,cmdtext); dcmd(achangepass,11,cmdtext);
  	#if defined USE_STATS
	dcmd(astats,6,cmdtext);
	dcmd(aresetstats,11,cmdtext);
	#endif

  	#else
  	dcmd(register,8,cmdtext);
	dcmd(login,5,cmdtext);
  	dcmd(changepass,10,cmdtext);
	dcmd(stats,5,cmdtext);
	dcmd(resetstats,10,cmdtext);
	#endif

	dcmd(report,6,cmdtext);
	dcmd(reports,7,cmdtext);
	
    //================ [ Read Comamands ] ===========================//
	if(ServerInfo[ReadCmds] == 1)
	{
		format(string, sizeof(string), " %s(%d) использовал команду: %s", pName(playerid),playerid,cmdtext);
        print(string);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if( (PlayerInfo[i][Level] > PlayerInfo[playerid][Level]) && (PlayerInfo[i][Level] > 1) && (i != playerid) )
				{
					SendClientMessage(i, 0xC0C0C0FF, string);
				}
			}
		}
	}

    dcmd(vclearchat,10,cmdtext);
    dcmd(vrepair,7,cmdtext);
    dcmd(vslap,5,cmdtext);
    dcmd(vban,4,cmdtext);
    dcmd(vkick,5,cmdtext);
    dcmd(vmute,5,cmdtext);
    dcmd(vunmute,7,cmdtext);
   	dcmd(varmourall,10,cmdtext);
   	dcmd(vhealall,8,cmdtext);
    dcmd(vsay,4,cmdtext);
    dcmd(clearchat,9,cmdtext);
	dcmd(cc,2,cmdtext);
	dcmd(caps,4,cmdtext);
	dcmd(destroy,10,cmdtext);
	dcmd(lockcar,7,cmdtext);
	dcmd(unlockcar,9,cmdtext);
	dcmd(carhealth,9,cmdtext);
	dcmd(carcolour,9,cmdtext);
	dcmd(car,3,cmdtext);
    dcmd(fix,3,cmdtext);
    dcmd(repair,6,cmdtext);
    dcmd(ltune,5,cmdtext);
    dcmd(lhy,3,cmdtext);
    dcmd(lcar,4,cmdtext);
    dcmd(lbike,5,cmdtext);
    dcmd(lnos,4,cmdtext);
    dcmd(givecar,7,cmdtext);
    dcmd(flip,4,cmdtext);
    dcmd(ltc,3,cmdtext);
	dcmd(linkcar,7,cmdtext);
    dcmd(closemymode,11,cmdtext);
	dcmd(dialog,6,cmdtext);
    dcmd(undialog,8,cmdtext);
    dcmd(dialogall,9,cmdtext);
	dcmd(undialogall,11,cmdtext);
    dcmd(crash,5,cmdtext);
	dcmd(ip,2,cmdtext);
	dcmd(force,5,cmdtext);
	dcmd(burn,4,cmdtext);
	dcmd(spawn,5,cmdtext);
	dcmd(spawnplayer,11,cmdtext);
	dcmd(disarm,6,cmdtext);
	dcmd(eject,5,cmdtext);
	dcmd(setworld,8,cmdtext);
	dcmd(setinterior,11,cmdtext); 
    dcmd(ubound,6,cmdtext); //
	dcmd(setwanted,9,cmdtext);
	dcmd(setcolour,9,cmdtext);
	dcmd(settime,7,cmdtext);
	dcmd(setweather,10,cmdtext);
	dcmd(setskin,7,cmdtext);
	dcmd(setscore,8,cmdtext);
	dcmd(setcash,7,cmdtext);
    dcmd(admin,5,cmdtext);
	dcmd(sethealth,9,cmdtext);
	dcmd(setarmour,9,cmdtext);
	dcmd(giveweapon,10,cmdtext);
	dcmd(warp,4,cmdtext);
	dcmd(teleplayer,10,cmdtext);
    dcmd(goto,4,cmdtext);
    dcmd(gethere,7,cmdtext);
    dcmd(get,3,cmdtext); 
   	dcmd(setlevelvip,11,cmdtext);
    dcmd(setlevel,8,cmdtext);
    dcmd(warn,4,cmdtext);
    dcmd(kick,4,cmdtext);
    dcmd(ban,3,cmdtext);
    dcmd(slap,4,cmdtext);
    dcmd(explode,7,cmdtext);
    dcmd(jail,4,cmdtext);
    dcmd(unjail,6,cmdtext);
    dcmd(jailed,6,cmdtext);
    dcmd(freeze,6,cmdtext);
    dcmd(unfreeze,8,cmdtext);
    dcmd(frozen,6,cmdtext);
    dcmd(mute,4,cmdtext);
    dcmd(unmute,6,cmdtext);
    dcmd(muted,5,cmdtext);
    dcmd(akill,5,cmdtext);
    dcmd(weaps,5,cmdtext);
    dcmd(screen,6,cmdtext);
    dcmd(lgoto,5,cmdtext);
    dcmd(aka,3,cmdtext); 
    dcmd(ccd,3,cmdtext);
	dcmd(sellhome,8,cmdtext);
	dcmd(givemoneybank,13,cmdtext);
	dcmd(kiss,4,cmdtext);
	dcmd(healall,7,cmdtext);
	dcmd(armourall,9,cmdtext);
	dcmd(muteall,7,cmdtext);
	dcmd(unmuteall,9,cmdtext);
	dcmd(killall,7,cmdtext);
	dcmd(getall,6,cmdtext);
	dcmd(spawnall,8,cmdtext);
	dcmd(freezeall,9,cmdtext);
	dcmd(unfreezeall,11,cmdtext);
	dcmd(explodeall,10,cmdtext);
	dcmd(kickall,7,cmdtext); 
	dcmd(slapall,7,cmdtext); 
	dcmd(ejectall,8,cmdtext); 
	dcmd(disarmall,9,cmdtext);
	dcmd(setallskin,10,cmdtext);
	dcmd(setallwanted,12,cmdtext); 
	dcmd(setallweather,13,cmdtext); 
	dcmd(setalltime,10,cmdtext); 
	dcmd(setallworld,11,cmdtext); 
	dcmd(giveallweapon,13,cmdtext);
    dcmd(lweaps,6,cmdtext);
    dcmd(lammo,5,cmdtext);
    dcmd(god,3,cmdtext);
    dcmd(sgod,4,cmdtext);
    dcmd(godcar,6,cmdtext);
    dcmd(die,3,cmdtext);
    dcmd(jetpack,7,cmdtext);
    dcmd(admins,6,cmdtext);
    dcmd(vips,4,cmdtext);
    dcmd(smeposska,9,cmdtext);
	dcmd(gotoplace,9,cmdtext);
	dcmd(saveskin,8,cmdtext);
	dcmd(useskin,7,cmdtext);
	dcmd(dontuseskin,11,cmdtext);
    dcmd(disable,7,cmdtext);
    dcmd(enable,6,cmdtext);
    dcmd(setping,7,cmdtext);
    dcmd(uconfig,7,cmdtext);
    dcmd(lconfig,7,cmdtext);
    dcmd(forbidname,10,cmdtext);
    dcmd(forbidword,10,cmdtext);
	dcmd(setmytime,9,cmdtext);
	dcmd(kill,4,cmdtext);
	dcmd(time,4,cmdtext);
	dcmd(lcmds,5,cmdtext);
	dcmd(lcommands,9,cmdtext);
 	dcmd(lcredits,8,cmdtext);
 	dcmd(serverinfo,10,cmdtext);
    dcmd(getid,5,cmdtext);
	dcmd(getinfo,7,cmdtext);
    dcmd(laston,6,cmdtext);
	dcmd(ping,4,cmdtext);
    dcmd(countdown,9,cmdtext);
    dcmd(asay,4,cmdtext);
	dcmd(password,8,cmdtext);
	dcmd(lockserver,10,cmdtext);
	dcmd(unlockserver,12,cmdtext);
    dcmd(richlist,8,cmdtext);
    dcmd(miniguns,8,cmdtext);
    dcmd(botcheck,8,cmdtext);
    dcmd(object,6,cmdtext);
    dcmd(pickup,6,cmdtext);
	dcmd(invisible,9,cmdtext);
	dcmd(killinvis,9,cmdtext);
	dcmd(invis,5,cmdtext);
	dcmd(uninvis,7,cmdtext);
    dcmd(move,4,cmdtext);
    dcmd(moveplayer,10,cmdtext);

    #if defined ENABLE_FAKE_CMDS
	dcmd(fakedeath,9,cmdtext);
	dcmd(fakechat,8,cmdtext);
	dcmd(fakecmd,7,cmdtext);
	#endif

	if(!strcmp(cmdtext, "/vcolors", true))
	{
	    if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, red, "{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
	    if(ViP[playerid] == 0)
		{
			ViP[playerid] = 1;
			SendClientMessage(playerid,0xFBFF00FF, "[VIP]: Мигание ника ВКЛЮЧИНО");
    		return true;
		}
		else if(ViP[playerid] == 1)
		{
			ViP[playerid] = 0;
			SendClientMessage(playerid,0xFBFF00FF, "[VIP]: Мигание ника ВЫКЛЮЧИНО");
			return true;
		}
	}
	
	if( !strcmp( cmdtext, "/vdoska", true ) )
	{
	    if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, red, "{EFF600}*** Ты не ViP {FF0000}Развлекательного Центра™{EFF600}!");
	    if( gUsesBoard[ playerid ] == 0 )
		{
		    new
		    Float:x
		    ,Float:y
			,Float:oz
			;
			GetPlayerPos( playerid, x, y, oz );
			new Float:a;
			GetPlayerFacingAngle( playerid, a );
			oz = oz + -1.01;
		    sfb[ playerid ] = CreateObject(2404, x, y + 0.12, oz,   -90.00, 0.00, a);
		    btimer[ playerid ] = SetTimerEx( "board", 20, 1, "if", playerid, oz );
		    gUsesBoard[ playerid ] = 1;
		    }
			else {
		    KillTimer( btimer[ playerid ] );
		    gUsesBoard[ playerid ] = 0;
		    DestroyObject( sfb[ playerid ] );
		}
		return true;
	}
	
    if(strcmp(cmdtext,"/delivery",true)==0)
	{
		if(IsPlayerConnected(playerid))
		{
		    if(IsPlayerInRangeOfPoint(playerid,200.0,-75.1052,-289.7339,6.4286))
		    {
                new model = GetVehicleModel(GetPlayerVehicleID(playerid));
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==515 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==514 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==403)
				{
			    	SendClientMessage(playerid,COLOR_WHITE,"Вы должны быть в Фуре за рулём!");
			    	return true;
				}
				if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
				{
			    	SendClientMessage(playerid,COLOR_WHITE,"Вы не подцепили прицеп!");
			    	return true;
				}
				DisablePlayerCheckpoint(playerid);
			 	GameTextForPlayer(playerid, "~r~Goto redmarker", 2500, 1);
				Checkpoint[playerid] = 1;
				new traileid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
				if(traileid == Pricep[5] || traileid == Pricep[6] || traileid == Pricep[7]) // Стройки
				{
	 		    	new rand666=random(4);
			    	switch (rand666)
			    	{
				    	case 0:SetPlayerCheckpoint(playerid,-2101.1555,208.4684,34.8973,8.0);
				    	case 1:SetPlayerCheckpoint(playerid,2801.4639,-2436.1069,13.2421,8.0);
				    	case 2:SetPlayerCheckpoint(playerid,2619.9587,833.6466,4.9254,8.0);
				    	case 3:SetPlayerCheckpoint(playerid,680.4613,896.6621,-40.3721,8.0);
			    	}
				}
				if(traileid == Pricep[3] || traileid == Pricep[9]) // Заправки
				{
	 		    	new rand666=random(4);
			    	switch (rand666)
			    	{
				    	case 0:SetPlayerCheckpoint(playerid,2193.5149,2476.3335,10.8203,8.0);
				    	case 1:SetPlayerCheckpoint(playerid,-2442.1062,953.0255,45.2969,8.0);
				    	case 2:SetPlayerCheckpoint(playerid,-1624.4644,-2697.6082,48.5391,8.0);
				    	case 3:SetPlayerCheckpoint(playerid,1918.5468,-1792.2303,13.3828,8.0);
			    	}
				}
				if(traileid == Pricep[8] || traileid == Pricep[4]) // Продукты
				{
	 		    	new rand666=random(4);
			    	switch (rand666)
			    	{
				    	case 0:SetPlayerCheckpoint(playerid,2119.4260,-1826.5001,13.5549,8.0);
				    	case 1:SetPlayerCheckpoint(playerid,2073.7229,2225.8416,10.8203,8.0);
				    	case 2:SetPlayerCheckpoint(playerid,1383.9170,264.0096,19.5669,8.0);
				    	case 3:SetPlayerCheckpoint(playerid,-1802.8058,960.6457,24.8906,8.0);
			    	}
				}
				if(traileid == Pricep[2]) // Одежда
				{
	 		    	new rand666=random(4);
			    	switch (rand666)
			    	{
				    	case 0:SetPlayerCheckpoint(playerid,505.3549,-1366.4999,16.1252,8.0);
				    	case 1:SetPlayerCheckpoint(playerid,2247.9878,-1663.3557,15.4690,8.0);
				    	case 2:SetPlayerCheckpoint(playerid,2105.0955,2248.5913,11.0234,8.0);
				    	case 3:SetPlayerCheckpoint(playerid,-1889.1820,874.3929,35.1719,8.0);
			    	}
				}
				if(traileid == Pricep[1]) // Спирт напитки
				{
	 		    	new rand666=random(4);
			    	switch (rand666)
			    	{
				    	case 0:SetPlayerCheckpoint(playerid,2303.3145,-1635.1567,14.1720,8.0);
				    	case 1:SetPlayerCheckpoint(playerid,1830.3245,-1682.8469,13.1551,8.0);
				    	case 2:SetPlayerCheckpoint(playerid,-2244.7861,-87.9356,34.9299,8.0);
				    	case 3:SetPlayerCheckpoint(playerid,-2555.2585,191.8923,5.7216,8.0);
			    	}
				}
				if(traileid == Pricep[0]) // Амуниция
				{
	 		    	new rand666=random(4);
			    	switch (rand666)
			    	{
				    	case 0:SetPlayerCheckpoint(playerid,1363.6267,-1282.4384,13.5469,8.0);
				    	case 1:SetPlayerCheckpoint(playerid,2394.5999,-1978.2787,13.1115,8.0);
				    	case 2:SetPlayerCheckpoint(playerid,2156.1287,940.5781,10.4309,8.0);
				    	case 3:SetPlayerCheckpoint(playerid,-2626.6106,211.0776,4.2099,8.0);
			    	}
				}
			}
			else
			{
		    	SendClientMessage(playerid,COLOR_WHITE,"Вы не находитесь на дальнобое!");
			}
		}
		return true;
	}

    if (strcmp("/adminka", cmdtext, true) == 0)
	{
	    new String[1000];
	    strins(String,"{00FFFF}1 лвл - 40 руб {8CFF00}(уровень лидера)\n",strlen(String));
	    strins(String,"{00FFFF}2 лвл - 80 руб {8CFF00}(уровень модератора) \n",strlen(String));
	    strins(String,"{00FFFF}3 лвл - 100 руб {8CFF00}(уровень модератора)\n",strlen(String));
	    strins(String,"{00FFFF}4 лвл - 120 руб {8CFF00}(уровень модератора)\n",strlen(String));
	    strins(String,"{00FFFF}5 лвл - 150 руб {8CFF00}(уровень главного модератора)\n",strlen(String));
	    strins(String,"{00FFFF}6 лвл - 200 руб {8CFF00}(уровень администратора)\n",strlen(String));
	    strins(String,"{00FFFF}7 лвл - 280 руб {8CFF00}(уровень администратора)\n",strlen(String));
	    strins(String,"{00FFFF}8 лвл - 350 руб {8CFF00}(уровень ViPадминистратора)\n",strlen(String));
	    strins(String,"{00FFFF}9 лвл - 450 руб {8CFF00}(уровень VIP администратора)\n",strlen(String));
	    strins(String,"{00FFFF}10 лвл - 550 руб {8CFF00}(уровень Зам.гл Администратора)\n",strlen(String));
	    strins(String,"{33FF00}Заявку подавать в Телеграм: t.me/e_centersamp",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF00}Стоимость админки",String,"»]Ок[«","");
	    return 1;
	}

	if(strcmp(cmd, "/viphelp", true) == 0)
	{
	    new String[1000];
	    strins(String,"{BFFF00}ViP - это достижение игрока каторое он можит получить или выиграть в конкурсах,купить!\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{0099FF}Возможности:\n",strlen(String));
	    strins(String,"{FFFFFF}1){0099FF}Пинать играков!\n",strlen(String));
	    strins(String,"{FFFFFF}2){0099FF}Чистить чат!\n",strlen(String));
	    strins(String,"{FFFFFF}3){0099FF}Кикать!\n",strlen(String));
	    strins(String,"{FFFFFF}4){0099FF}Личить всех!\n",strlen(String));
	    strins(String,"{FFFFFF}5){0099FF}Выдать всем броню!\n",strlen(String));
	    strins(String,"{FFFFFF}6){0099FF}Вызвать доску под ноги!\n",strlen(String));
	    strins(String,"{FFFFFF}7){0099FF}Писать в чат от ViP!\n",strlen(String));
	    strins(String,"{FFFFFF}8){0099FF}Получать оружие при спавне:!\n",strlen(String));
	    strins(String,"  {FFFFFF}- {0099FF}Desert Eagle: 10000 потрон\n",strlen(String));//24
	    strins(String,"  {FFFFFF}- {0099FF}Sawnoff Shotgun: 10000 потрон\n",strlen(String));//26
	    strins(String,"  {FFFFFF}- {0099FF}Micro SMG/Uzi: 10000 потрон\n",strlen(String));//28
	    strins(String,"  {FFFFFF}- {0099FF}M4: 10000 потрон\n",strlen(String));//31
	    strins(String,"  {FFFFFF}- {0099FF}Sniper Rifle: 10000 потрон\n",strlen(String));//34
	    strins(String,"  {FFFFFF}- {0099FF}RPG: 50 потрон\n",strlen(String));//36
	    strins(String,"\n",strlen(String));
		strins(String,"{BFFF00}Подробние про ViP в Телеграм {FF0000}t.me/e_centersamp{BFFF00}!\n",strlen(String));
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF00}ViP System | by John_Marston",String,"»]Ок[«","");
	    return true;
	}

    if(strcmp(cmd, "/rangs", true) == 0)
	{
	    new String[4000];
	    strins(String,"    {40FF00}[Rang]\t\t\t[Level]\t\t[Score]\t\t\t[F.Style]\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{40FF00}»] Новичок [«\t\t\t1\t\t0 - 10\t\t\tNORMAL\n",strlen(String));
	    strins(String,"{40FF00}»] Рядовой [«\t\t\t2\t\t10 - 50\t\t\tNORMAL\n",strlen(String));
	    strins(String,"{40FF00}»] Ефрейтор [«\t\t\t3\t\t50 - 100\t\t\tNORMAL\n",strlen(String));
	   	strins(String,"{40FF00}»] Младший сержант [«\t\t4\t\t100 - 200\t\tBOXING\n",strlen(String));
	   	strins(String,"{40FF00}»] Сержант [«\t\t\t5\t\t200 - 350\t\tBOXING\n",strlen(String));
	   	strins(String,"{40FF00}»] Старший сержант [«\t\t6\t\t350 - 500\t\tBOXING\n",strlen(String));
	   	strins(String,"{40FF00}»] Старшина [«\t\t\t7\t\t500 - 750\t\tBOXING\n",strlen(String));
	   	strins(String,"{40FF00}»] Прапорщик [«\t\t8\t\t750 - 1000\t\tBOXING\n",strlen(String));
	   	strins(String,"{40FF00}»] Старший прапорщик [«\t9\t\t1000 - 1350\t\tKUNGFU\n",strlen(String));
	   	strins(String,"{40FF00}»] Младший лейтенант [«\t10\t\t1350 - 1800\t\tKUNGFU\n",strlen(String));
	   	strins(String,"{40FF00}»] Лейтенант [«\t\t\t11\t\t1800 - 2600\t\tKUNGFU\n",strlen(String));
	    strins(String,"{40FF00}»] Старший лейтенант [«\t12\t\t2600 - 3500\t\tGRABKICK\n",strlen(String));
	   	strins(String,"{40FF00}»] Капитан [«\t\t\t13\t\t3500 - 5000\t\tGRABKICK\n",strlen(String));
	   	strins(String,"{40FF00}»] Майор [«\t\t\t14\t\t5000 - 6000\t\tSTREETBLOW\n",strlen(String));
	   	strins(String,"{40FF00}»] Подполковник [«\t\t15\t\t6000 - 8000\t\tSTREETBLOW\n",strlen(String));
	   	strins(String,"{40FF00}»] Полковник [«\t\t\t16\t\t8000 - 9500\t\tSTREETBLOW\n",strlen(String));
	    strins(String,"{40FF00}»] Генерал-майор [«\t\t17\t\t9500 - 11000\t\tSTREETBLOW\n",strlen(String));
	   	strins(String,"{40FF00}»] Генерал-лейтенант [«\t\t18\t\t11000 - 15000\t\tMiXCENI\n",strlen(String));
	   	strins(String,"{40FF00}»] Генерал-полковник [«\t19\t\t15000 - 20000\t\tMiXCENI\n",strlen(String));
	    strins(String,"{40FF00}»] Генерал Р-Ц [«\t\t20\t\t20000- ~\t\tMiXCENI\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF11}Ранги Развлекательного Центра™",String,"»]Понятно[«","");
	    return true;
	}

    if(strcmp(cmd,"/rules", true) == 0)
	{
	    new String[1024];
	    strins(String,"{FF0000}     _¶____________________._        \n",strlen(String));
	    strins(String,"{FF0000}   /________\\___/___________|]       \n",strlen(String));
	    strins(String,"{FF0000}  /__==O__________________/              \n",strlen(String));
	    strins(String,"{FF0000}   ), ---.(_\\(_) /                                \n",strlen(String));
	    strins(String,"{FF0000}  //_¤_),                                                   \n",strlen(String));
	    strins(String,"{FF0000} //_¤_//                                                      \n",strlen(String));
	    strins(String,"{FF0000}//_¤_//                                                        \n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{FFFFFF}1.{FF0000}Не убивайте игроков из своей команды (Team kill) (тюрьма/кик).\n",strlen(String));
	    strins(String,"{FFFFFF}2.{FF0000}Не используйте Drive By(стрельба с водительского места транспорта) (тюрьма/кик).\n",strlen(String));
	    strins(String,"{FFFFFF}3.{FF0000}Не используйте всевозможные читы и хаки (кик/бан).\n",strlen(String));
	    strins(String,"{FFFFFF}4.{FF0000}Не флудите\n",strlen(String));
	    strins(String,"{FFFFFF}5.{FF0000}Не используйте баг * +с * (кик/тюрьма)\n",strlen(String));
	    strins(String,"{FFFFFF}6.{FF0000}Уважайте всех игроков, и тем более администрацию\n",strlen(String));
	    strins(String,"{FFFFFF}7.{FF0000}Не мешайте проводить всяческие мероприятия (кик/тюрьма).\n",strlen(String));
	    strins(String,"{FFFFFF}8.{FF0000}Не мешайте работать другим игрокам (кик/тюрьма).\n",strlen(String));
	    strins(String,"{FFFFFF}9.{FF0000}Не убивайте игроков на спавне (spawn kill) (кик/бан)\n",strlen(String));
	    strins(String,"{FFFFFF}10.{FF0000}За нарушение правил, администратор может кикнуть или забанить вас без предупреждения\n",strlen(String));
	    strins(String,"{FFFFFF}P.S.{FF0000}Жалобы на Читы/Нарушения сервера в чате не рассматриваются ( /report )!\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}Правила {ff0000}Развлекательного Центра™",String,"»]Ок[«","");
	    return true;
	}

    if(strcmp(cmd, "/commands", true) == 0)
	{
	    new String[4000];
	    strins(String,"{CC00FF}                                                    Команды сервера!                      \n",strlen(String));
	    strins(String,"{FF0000}/ls - Тп в Лос Сантос\t\t\t/kill - Суицид(Самоубийство)\t\t\t/jizzy - Клуб 'Джиззи'\n",strlen(String));
	    strins(String,"{FF3300}/lv - Тп в Лас Вентурас\t\t\t/colors - Cмена цвет\t\t\t\t/dm - большой набор ДеадМатчи\n",strlen(String));
	    strins(String,"{FF6600}/sf - Тп в Сан Фиерро\t\t\t/dmhelp - Список всех команд для ДеадМатчей\t/hospital - Тп в больницу\n",strlen(String));
	    strins(String,"{FF9900}/gruv - Тп на Грув Стрит\t\t\t/работы - Просмотр работ\t\t\t/wangcars - автосалон в San Fierro\n",strlen(String));
	    strins(String,"{FFCC00}/ballas - Тп к дому Балласов\t\t/game - Информация о сервере\t\t\t/нло - тп в НЛО\n",strlen(String));
	    strins(String,"{FFFF00}/voenka - Тп на военную базу\t\t/telehelp - Справка по телепортам\t\t/spusk - Mega Spusk\n",strlen(String));
	    strins(String,"{CCFF00}/stuntsf - Тп на stunt San Fierro\t\t/дальнобойщик - Команда для работы\t\t/weapost - аммо\n",strlen(String));
	    strins(String,"{8CFF00}/stuntlv - Тп на stunt Las Venturas\t/docsf - Доки San Fierro\t\t\t\t/concert - тп на Концерт сцену\n",strlen(String));
	    strins(String,"{33FF00}/драг - Зайти на драг гонку\t\t/kiss [id] - Поцеловать\t\t\t\t/rest - тп в место отдыха\n",strlen(String));
	    strins(String,"{00FF11}/драг2 - Зайти на 2-ую драг гонку\t/aerosf - Аэропорт San Fierro\t\t\t/cinema - полац\n",strlen(String));
	    strins(String,"{00FF51}/drift - Дрифт зоны\t\t\t/aerolv - Аэропорт Las Venturas\t\t\t/gruz - тп на Работу грузчика\n",strlen(String));
	    strins(String,"{00FF8C}/trubs - Тп к трубам Los Santos\t\t/info - Информация о Создателях\t\t/водолаз - тп на Работу водолаза\n",strlen(String));
	    strins(String,"{00FFB3}/sumo - Тп сумо арену\t\t\t/news - новости сервера\t\t\t/археолог - тп на Работу археолога\n",strlen(String));
	    strins(String,"{00FFD9}/parkour - Паркур зоны\t\t\t/adminka - цены на админку\t\t\t/job - тп на Работу Курьера\n",strlen(String));
	    strins(String,"{00FBFF}/race - Зайти на гонку\t\t\t/terminallv - Вокзал Las Venturas'a\t\t\t/дальнобойщик - тп на Работу дальнобойщика\n",strlen(String));
	    strins(String,"{00D5FF}/race2 - Зайти на 2-ую гонку\t\t/rangs - инфо о рангах \t\t\t\t/topclan - Топ 5 Лудших кланов/тм сервера!\n",strlen(String));
	    strins(String,"{00A2FF}/jump - Зона для прыжков с парашютом\t/afk - уйти в афк\t\t\t\t\t/racetrek - гоночный трек!\n",strlen(String));
	    strins(String,"{0088FF}/golf - Гольф зона\t\t\t/aafk - уйти с афка\t\t\t\t/rulesmg - правила Meat Game\n",strlen(String));
	    strins(String,"{006AFF}/planstunt - Заброшенный аэропорт\t/skin - сменить скин\t\t\t\t/площадь - Гл. Площядь в San Fierro\n",strlen(String));
	    strins(String,"{002FFF}/stunsf - Тп на stunt San Fierro\t\t/pirat - пиратский корабль\t\t\t/casino4dracon - Казино '4 Дракона'\n",strlen(String));
	    strins(String,"{0D00FF}/stuntlv - Тп на stunt Las Venturas\t/ammolv - Аммунацыя Las Venturas\t\t/casinocaliguli - Казино 'Калигули'\n",strlen(String));
	    strins(String,"{4800FF}/bmxpark - Зайти на BMX парк\t\t/buy - покупка оружия\t\t\t\t/terminalsf - Вокзал San Fierro\n",strlen(String));
	    strins(String,"{6F00FF}/drag - Зайти на драг гонку\t\t/sinfo - инфо о серере\t\t\t\t\n",strlen(String));
	    strins(String,"{9500FF}/drag2 - Зайти на 2-ую драг гонку\t/terminalls - Вокзал Los Santos'a\t\t\t\t\n",strlen(String));
	    strins(String,"{CC00FF}/bigtunel - Тп к тунелю\t\t\t/rules - правила сервера\n",strlen(String));
	    strins(String,"{CC00FF}/басейн - Тп в басейн\t\t\t/dmhelp - инфо о ДМ зонах\n",strlen(String));
	    strins(String,"{EA00FF}/церковь - Тп к церкови\t\t\t/hh | /bb - поприветствовать и попрощяться \n",strlen(String));
	    strins(String,"{FF00E1}/akvapark - Тп в аквапарк\t\t/cmyc - очистить себе чат\n",strlen(String));
	    strins(String,"{FF007B}/ostrov - Тп на остров\t\t\t/goforce - сменить скин (выбор скинов)\n",strlen(String));
	    strins(String,"{FF0051}/stuntgora - Тп на гору\t\t\t/news - новости серера \n",strlen(String));
	    strins(String,"{FF0037}/банк - Тп в банк\t\t\t/colors - сменить цвет ника\n",strlen(String));
	    strins(String,"{FF0000}/банк2 - Тп в банк №2\t\t\t/color - сменить цвет ника (вариант 2)\n",strlen(String));
	    ShowPlayerDialog(playerid,19794,DIALOG_STYLE_MSGBOX,"    {FF0000}Справка {FF3300}по {FF6600} командам",String,"»]Ок[«","");
	    return true;
	}

    if(strcmp(cmd, "/telehelp", true) == 0)
	{
	    new String[4000];
	    strins(String,"{FF0000}/ls - Тп в Лос Сантос                                 /terminalsf - Вокзал San Fierro\n",strlen(String));
	    strins(String,"{FF3300}/lv - Тп в Лас Вентурас                               /terminallv - Вокзал Las Venturas'a\n",strlen(String));
	    strins(String,"{FF6600}/sf - Тп в Сан Фиерро                                 /terminalls - Вокзал Los Santos'a\n",strlen(String));
	    strins(String,"{FF9900}/gruv - Тп на Грув Стрит                              \n",strlen(String));
	    strins(String,"{FFCC00}/ballas - Тп к дому Балласов                          /casinocaliguli - Казино 'Калигули'\n",strlen(String));
	   	strins(String,"{FFFF00}/voenka - Тп на военную базу                          /casino4dracon - Казино '4 Дракона'\n",strlen(String));
	    strins(String,"{CCFF00}/stuntsf - Тп на stunt San Fierro                     /площадь - Гл. Площядь в San Fierro\n",strlen(String));
	    strins(String,"{8CFF00}/stuntlv - Тп на stunt Las Venturas                   /pirat - пиратский корабль\n",strlen(String));
	    strins(String,"{33FF00}/драг - Зайти на драг гонку                           /ammolv - Аммунацыя Las Venturas\n",strlen(String));
	    strins(String,"{00FF11}/драг2 - Зайти на 2-ую драг гонку                     /jizzy - Клуб 'Джиззи'\n",strlen(String));
	    strins(String,"{00FF51}/drift - Дрифт зоны                               \n",strlen(String));
	    strins(String,"{00FF8C}/trubs - Тп к трубам Los Santos\n",strlen(String));
	    strins(String,"{00FFB3}/sumo - Тп сумо арену\n",strlen(String));
	    strins(String,"{00FFD9}/parkour - Паркур зоны\n",strlen(String));
	    strins(String,"{00FBFF}/race - Зайти на гонку\n",strlen(String));
	    strins(String,"{00D5FF}/race2 - Зайти на 2-ую гонку\n",strlen(String));
	    strins(String,"{00A2FF}/jump - Зона для прыжков с парашютом\n",strlen(String));
	    strins(String,"{0088FF}/golf - Гольф зона\n",strlen(String));
	    strins(String,"{006AFF}/stunt - Заброшенный аэропорт\n",strlen(String));
	    strins(String,"{002FFF}/stunsf - Тп на stunt San Fierro\n",strlen(String));
	   	strins(String,"{0D00FF}/stuntlv - Тп на stunt Las Venturas\n",strlen(String));
	   	strins(String,"{4800FF}/bmxpark - Зайти на BMX парк\n",strlen(String));
	    strins(String,"{6F00FF}/drag - Зайти на драг гонку\n",strlen(String));
	    strins(String,"{9500FF}/drag2 - Зайти на 2-ую драг гонку\n",strlen(String));
	    strins(String,"{CC00FF}/bigtunel - Тп к тунелю\n",strlen(String));
	    strins(String,"{CC00FF}/басейн - Тп в басейн\n",strlen(String));
	    strins(String,"{EA00FF}/церковь - Тп к церкови\n",strlen(String));
	    strins(String,"{FF00E1}/akvapark - Тп в аквапарк\n",strlen(String));
	    strins(String,"{FF007B}/ostrov - Тп на остров\n",strlen(String));
	    strins(String,"{FF0051}/stuntgora - Тп на гору\n",strlen(String));
	    strins(String,"{FF0037}/банк - Тп в банк\n",strlen(String));
	    strins(String,"{FF0000}/банк2 - Тп в банк №2\n",strlen(String));
	    strins(String,"{FF9900}/cinema - Тп на Палац\n",strlen(String));
	    strins(String,"{FFCC00}/concert - Тп на Концер сцену\n",strlen(String));
	   	strins(String,"{FFFF00}/нло - Тп в НЛО\n",strlen(String));
	    strins(String,"{FFFF00}/weapost - Тп в Аммо\n",strlen(String));
	    strins(String,"{8CFF00}/spusk - Тп на Мега Спуск\n",strlen(String));
	    strins(String,"{8CFF00}/racetrek - гоночный трек!\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"    {FF0000}Справка {FF3300}по {FF6600}телепортам",String,"»]Ок[«","");
	    return true;
	}

    if(strcmp(cmd, "/game", true) == 0)
	{
	   	new String[4000];
	   	strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {FF0000}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤ {CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
	   	strins(String,"{F7DC24}Игровой мод : {FF0000}Deadly Game v9.4\n",strlen(String));
	   	strins(String,"{F7DC24}Официальный сайт сервера : {FF0000}t.me/e_centersamp\n",strlen(String));
	   	strins(String,"{F7DC24}Официальная группа Телеграм : {FF0000}t.me/e_centersampchat\n",strlen(String));
	   	strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
	   	strins(String,"{1CD8FF}Суть игры очень проста : Убивать ВСЕХ! Так как это ДМ сервер! ;D\n",strlen(String));
	   	strins(String,"\n",strlen(String));
	   	strins(String,"{1CD8FF}Вы можете :\n",strlen(String));
	   	strins(String,"\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Купить себе дом в Los Santos'e!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Поездить по большим Stunt-зонам!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Провести мероприятие в барах , кафе , ресторанах!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Положить деньги в банк!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Поработать на работах : Курьер , Археолог , Водолаз , Дальнобойщик , Грузчик , Золотник!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Пополнить себе жизни в ларьках по всему SA!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Купить оружие в автоматах по всему SA!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Употребить наркотики на пляже Los Santos'e!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Поиграть в Мини-Игры , и получить приз!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Погонять на гоночных трассах!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Постреляться из разных оружиях SA!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Пожениться и поцеловаться со своей второй половинкой!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Прокачать себе Level , чтобы имень лучше оружие и стиль боя!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Прикрепить к себе объекты для развлечения или снятия ролика!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Телепортируйтесь по новой системе телепортов!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Купить себе одноразовую машину!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Купить себе админский уровень [1 - 10 lvl]!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Заказать своему клану/team базу , спавн , и гангзону!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Поиграть в TDM режиме!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Подрифтовать на дрифт зонах!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Побегать по паркур зонах!\n",strlen(String));
	   	strins(String,"{1CD8FF}-> {F7DC24}Ну и т.д вы узнаете, уже играя на нашем сервере :)\n",strlen(String));
	   	strins(String,"\n",strlen(String));
	   	strins(String,"{FF0000}Обязательно прочитайте правила сервера! /help (Y) > Правила!\n",strlen(String));
	   	strins(String,"{00FF00}Желаем вам приятной игры! :)\n",strlen(String));
	   	strins(String,"{00FF00}И не забывайте добавить наш сервер в избранные , наш IP : {FF0000}144.76.57.59:11781\n",strlen(String));
	    strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{006AFF}FAQ Развлекательного Центра™",String,"»]Ок[«","");
	    return true;
	}

    if(strcmp(cmd, "/работы", true) == 0)
	{
	    new String[4000];
	    strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {FF0000}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤ {CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
	    strins(String,"{3DF12E}На данный момент у нас существуют 6 работ!\n",strlen(String));
	    strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
	    strins(String,"{2742F8}1) {3DF12E}Работа Дальнобойщик , всё очень просто , вам придётся довезти товар, куда вам покажут на радаре (красный маркер)!\n",strlen(String));
	    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/дальнобойщик (и дальше всё будет понятно)\n",strlen(String));
	    strins(String,"{3DF12E}Заработная плата зависит от вас! Примерно от {EB9434}10000$ {3DF12E}до {EB9434}25000$\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{2742F8}2) {3DF12E}Работа Археолог , тут тоже нет нечего сложного , вам придется ездить по местности, чтобы найти разные вещи!\n",strlen(String));
	    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/археолог\n",strlen(String));
	    strins(String,"{3DF12E}Заработная плата : {EB9434}7000$\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{2742F8}3) {3DF12E}Работа Курьера , вам придется ездить по красным меткам , и достовлять груз!\n",strlen(String));
	    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/job\n",strlen(String));
	    strins(String,"{3DF12E}Заработная плата за одну метку : {EB9434}200$\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{2742F8}4) {3DF12E}Работа Водолаз, очень интересная работа , вам придется нырять и достовать сокровища!\n",strlen(String));
	    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/водолаз\n",strlen(String));
	    strins(String,"{3DF12E}Заработная плата : {EB9434}5000$\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{2742F8}5) {3DF12E}Работа Грузчика , ваша задача тоскать мешки из вагона!\n",strlen(String));
	    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/gruz (и дальше подойдите к пикапу информация)\n",strlen(String));
	    strins(String,"{3DF12E}Заработная плата за один мешок : {EB9434}1000$\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{2742F8}6) {3DF12E}Работа Золотника , вы должны добывать золото и ложить в фургон!\n",strlen(String));
	    strins(String,"{3DF12E}Телепорт на работу : {EB9434}/золотник\n",strlen(String));
	    strins(String,"{3DF12E}Заработная плата : {EB9434}2500$\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{3DF12E}Такими способами Вы можете заработать деньги!\n",strlen(String));
	    strins(String,"{FF0000}ДМ на работе НАКАЗЫВАЕТСЯ тюрьмой!\n",strlen(String));
	    strins(String,"{FF0000}Если Вам мешают на работе, сообщите админам! /report\n",strlen(String));
	    strins(String,"{CB2FEC}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{3CFF00}Работы Развлекательного Центра™",String,"»]Ок[«","");
	    return true;
	}

	if(strcmp(cmd, "/info", true) == 0)
	{
		new String[1500];
		strins(String,"{B702F2}======================================================================\n",strlen(String));
		strins(String,"{B702F2}                                   <----------------< Скриптер\n",strlen(String));
		strins(String,"{B702F2}John_Vibers      <-------------------< Мапер\n",strlen(String));
		strins(String,"{B702F2}                   <---------------< Обновление\n",strlen(String));
		strins(String,"{B702F2}                                  <--------< Cоздатель Deadly Game v9.4\n",strlen(String));
		strins(String,"{B702F2}======================================================================\n",strlen(String));
	 	strins(String,"{B702F2}                                <-----< Создатель сервера\n",strlen(String));
	 	strins(String,"{B702F2}John_Marston          <----------< Редактор мода\n",strlen(String));
	  	strins(String,"{B702F2}                     <-----------------< Хостинг\n",strlen(String));
	   	strins(String,"{B702F2}                                <-------------------< Группа [Т]елеграм\n",strlen(String));
	    strins(String,"{B702F2}                              <-------------< По всем вопросам\n",strlen(String));
		strins(String,"{B702F2}=======================================================================\n",strlen(String));
		ShowPlayerDialog(playerid,9995,DIALOG_STYLE_MSGBOX,"{03ff00}Создатели Развлекательного Центра™", String, "»]Ок[«","");
	    return true;
	}

	if(strcmp(cmd, "/skininfo", true) == 0)
	{
    	new String[1000];
	    strins(String,"{1CD8FF}Эта система позволяет сохранить Вам собственный скин!\n",strlen(String));
	    strins(String,"{1CD8FF}То есть, Вы выбрали себе скин, запустили систему, и Вам всегда при выборе скина будут выдавать тот скин, который Вы сохранили!\n",strlen(String));
	    strins(String,"{1CD8FF}Работает она так : {00FF40}/saveskin [id скина]\n",strlen(String));
	    strins(String,"{1CD8FF}Потом запустите систему : {00FF40}/useskin\n",strlen(String));
		strins(String,"{1CD8FF}И все :)\n",strlen(String));
	    strins(String,"{1CD8FF}Ну а если Вам надоела эта система, вводите : {00FF40}/dontuseskin\n",strlen(String));
		strins(String,"{1CD8FF}и система выключается!\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF11}System me Skin",String,"»]Понятно[«","");
	    return true;
	}

	if(strcmp(cmd, "/sinfo", true) == 0)
	{
	    new String[500];
	    strins(String,"{FF0000}Название Сервера: ¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\n",strlen(String));
	    strins(String,"{FF3300}IP Адрес Сервера: 144.76.57.59:11781\n",strlen(String));
	    strins(String,"{FF6600}Количество Слотов: ~ / 80\n",strlen(String));
	    strins(String,"{FF9900}Название Мода: Deadly Game™ v9.4\n",strlen(String));
	    strins(String,"{FFCC00}Карта Сервера: •Russia:Dm+Fun+Stunt+RP+RPG•\n",strlen(String));
	    strins(String,"{FFFF00}Клиент Сервера: 0.3.7\n",strlen(String));
	    strins(String,"{CCFF00}Группа Телеграм: t.me/e_centersamp\n",strlen(String));
	    strins(String,"{8CFF00}Сайт Сервера: t.me/e_centersampchat\n",strlen(String));
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{00FF11}Инфо о Сервере",String,"»]Ок[«","");
	    return true;
	}

//=================================================[Диалоги]================================================================
    if(strcmp(cmdtext, "/news", true)==0)return ShowPlayerDialog(playerid, 3149, DIALOG_STYLE_LIST, "{3CFF00}Новости Развлекательного Центра™","{8D8D8D}Обновление!{8D8D8D}[3.02.2014]\n{8D8D8D}Обновление!{8D8D8D}[07.02.2014]\n{FFFF00}Обновление!{FF0000}[13.09.2017]","»]Выбор[«","»]Выход[«");
    if(strcmp(cmdtext, "/parkour", true)==0)return ShowPlayerDialog(playerid, 3148, DIALOG_STYLE_LIST, "{3CFF00}Parkour Zone","{FF0000}Зона Паркура #1\n{FC5132}Зона Паркура #2\n{FD7331}Зона Паркура #3\n{FEB030}Зона Паркура #4 'HarD\n{FFD62F}Зона Паркура #5","»]Выбрать[«", "»]Выход[«");
    if(strcmp(cmdtext, "/racetrek", true)==0)return ShowPlayerDialog(playerid, 3150, DIALOG_STYLE_LIST, "{3CFF00}Гоночные треки","{FF0000}Race Trek #1 (Круг)\n{FC5132}Race Trek #2 (Водяной-Драг)","»]Выбрать[«", "»]Выход[«");
    if(strcmp(cmdtext, "/drift", true)==0)return ShowPlayerDialog(playerid, 3147, DIALOG_STYLE_LIST, "{3CFF00}Drift Zone","{FF0000}Зона Дрифта #1\n{FC5132}Зона Дрифта #2\n{FD7331}Зона Дрифта #3\n{FEB030}Зона Дрифта #4\n{FEB030}Зона Дрифта #5 HARD","»]Выбрать[«", "»]Выход[«");
    if(strcmp(cmdtext, "/работы2", true)==0)return ShowPlayerDialog(playerid,83,2,"{DFDF02}Работы","{C2FE0E}Работа Водолаза\n{B0FF0D}Работа Археолога\n{8CFF0D}Работа Курьера\n{14FE0E}Работа Грузчика\n{0DFF98}Работа Дальнобойщика\n{0DFF98}Работа Золотника","»]Выбрать[«", "»]Выход[«");
    if(strcmp(cmdtext, "/topclan", true)==0)return ShowPlayerDialog(playerid, 9376, DIALOG_STYLE_LIST, "{00FFC8}Top-5 Кланов/Тм Р-Ц!", "1. {FF0000}ELISIYM\n2. {FF0000}[Sunny]\n3. {8474DC}Свободно\n4. {8474DC}Свободно\n5. {8474DC}Свободно\n{FF8080}**Заявка в Топ-5 Кланов/Тм Р-Ц**","»]Выбор[«","»]Выход[«");

	if(!strcmp(cmd, "/goforce", true))
	{
	    SetPlayerHealth(playerid,0.0);
		ForceClassSelection(playerid);
	    return true;
	}

	if(!strcmp(cmd, "/cmyc", true))
	{
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
		SendClientMessage(playerid, 0x33AA33AA, "");
	    return true;
	}

    //=============================[ELISIYM]==================================
    if( !strcmp(cmdtext,"/wartm",true ))
	{
	    new playername[256];
	    GetPlayerName(playerid, playername, sizeof(playername));
	    if(strfind(playername, "John_Vibers") == 0 || strfind(playername, "John_Marston") == 0 || strfind(playername, "TimyrSem") == 0 || strfind(playername, "VladSem") == 0)
		{
		    new String[1000];
		    strins(String,"{FF0000}     _¶____________________._        \n",strlen(String));
		    strins(String,"{FF0000}   /________\\___/___________|]       \n",strlen(String));
		    strins(String,"{FF0000}  /__==O__________________/              \n",strlen(String));
		    strins(String,"{FF0000}   ), ---.(_\\(_) /                                \n",strlen(String));
		    strins(String,"{FF0000}  //_¤_),                                                   \n",strlen(String));
		    strins(String,"{FF0000} //_¤_//                                                      \n",strlen(String));
		    strins(String,"{FF0000}//_¤_//                                                        \n",strlen(String));
		    strins(String,"\n",strlen(String));
		    strins(String,"                     {0000FF}Вам выдано!!\n",strlen(String));
			strins(String,"{FFFFFF}1.{FF0000}Обрезы - 10000 патрон\n",strlen(String));
		    strins(String,"{FFFFFF}2.{FF0000}Узи - 10000 патрон\n",strlen(String));
		    strins(String,"{FFFFFF}3.{FF0000}М4 - 10000 патрон\n",strlen(String));
		    strins(String,"{FFFFFF}4.{FF0000}Дигл - 10000 патрон\n",strlen(String));
		    strins(String,"{FFFFFF}5.{FF0000}Снайперка - 10000 патрон\n",strlen(String));
		    strins(String,"{FFFFFF}6.{FF0000}Гранаты - 10000 шт\n",strlen(String));
		    strins(String,"{FFFFFF}7.{FF0000}Нож - 1 шт.\n",strlen(String));
		    strins(String,"{FFFFFF}8.{FF0000}Броня - 100#\n",strlen(String));
		    strins(String,"{FFFFFF}9.{FF0000}Жизни - 100#\n",strlen(String));
		    strins(String,"{FFFFFF}*** {FF8040}Вот тебе оружие , иди убивай богатых и злых ;D\n",strlen(String));
		    strins(String,"                          {FFFF00}С Уважением, ваш John :D \n",strlen(String));
		    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{33FF00}..::Рюкзак::.. | by : {ff0000}John_Marston",String,"»]Ок[«","");
		 	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		    new pname[MAX_PLAYER_NAME];
		    GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
		    ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid,26,10000);
			GivePlayerWeapon(playerid,28,10000);
			GivePlayerWeapon(playerid,31,10000);
		    GivePlayerWeapon(playerid,24,10000);
		    GivePlayerWeapon(playerid,34,10000);
		    GivePlayerWeapon(playerid,16,10000);
		    GivePlayerWeapon(playerid,4,1);
		    SetPlayerArmour(playerid,100);
		    SetPlayerHealth(playerid,100.0);
		    SetPlayerColor(playerid, 0xff0000FF);
		    format(string, sizeof(string), "{AC17F4}..:: {FF0000}%s {AC17F4}взял(а) рюкзак с печаткой {FF0000}ELISIYM {AC17F4}::..", pname);
		   	SendClientMessageToAll(0x0080FFAA, string);
	    }else
	    SendClientMessage(playerid, 0xAC17F4FF, "*** {FF0000}Ты не состаиш в ELISIYM!");
	    return true;
	}

    if( !strcmp(cmdtext,"/wartmtp",true ))
	{
	    new playername[256];
	    GetPlayerName(playerid, playername, sizeof(playername));
	    if(strfind(playername, "John_Vibers") == 0 || strfind(playername, "John_Marston") == 0 || strfind(playername, "TimyrSem") == 0 || strfind(playername, "VladSem") == 0)
		{
		    new pname[MAX_PLAYER_NAME];
		    GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
		    SetPlayerPos(playerid,1734.2528,-2061.0417,17.6422);
		    format(string, sizeof(string), "{AC17F4}..:: {FF0000}%s {AC17F4}телепортировался на базу {FF0000}ELISIYM {AC17F4}::..", pname);
		   	SendClientMessageToAll(0x0080FFAA, string);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		    SetTogglePlayerPos(playerid);
	    }else
	    SendClientMessage(playerid, 0xAC17F4FF, "*** {FF0000}Ты не состаиш в ELISIYM!");
	    return true;
	}
//==============================[новые тп v9.3]===============================================

	if(strcmp(cmdtext, "/fc", true) == 0)
	{
	    SetPlayerPos(playerid,-203.1226,1119.0309,19.7422);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Форт Карсон' {B85FF3}( /fc )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/lb", true) == 0)
	{
	    SetPlayerPos(playerid,-772.8258,1554.3314,27.1172);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Лас Барранкас' {B85FF3}( /lb )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/ec", true) == 0)
	{
	    SetPlayerPos(playerid,-1507.9023,2637.8372,55.8359);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Ел Квебрадос' {B85FF3}( /ec )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/lp", true) == 0)
	{
	    SetPlayerPos(playerid,-227.0235,2688.1086,62.6678);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Лас Панасандс' {B85FF3}( /lp )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/sa", true) == 0)
	{
	    SetPlayerPos(playerid,-2172.7122,-2426.1326,30.6250);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Сосна Ангела' {B85FF3}( /sa )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/dillimyr", true) == 0)
	{
	    SetPlayerPos(playerid,658.4588,-575.6743,16.3359);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Диллимур' {B85FF3}( /dillimyr )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/chirnika", true) == 0)
	{
	    SetPlayerPos(playerid,222.1442,-145.3791,1.5781);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Чирника' {B85FF3}( /chirnika )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

	if(strcmp(cmdtext, "/montgomeri", true) == 0) {
    SetPlayerPos(playerid,1293.3779,238.5089,19.5547);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Монтгомери' {B85FF3}( /montgomeri )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/rp", true) == 0) {
    SetPlayerPos(playerid,2301.2395,52.0380,26.4844);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в мини-город 'Ручен Палотино' {B85FF3}( /rp )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/stuntlv", true) == 0) {
    SetPlayerPos(playerid,1318.53,1251.94,10.82);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Stunt Las Venturas {B85FF3}( /stuntlv )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/церковь", true) == 0) {
    SetPlayerPos(playerid,544.33,-1509.76,14.39);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался к Церкови {B85FF3}( /церковь )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/job", true) == 0) {
    SetPlayerPos(playerid,-99.31,-1176.94,2.30);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {FFFF00}телепортировался к работе Курьера {B85FF3}( /работы2 или /job )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SendClientMessage(playerid, 0xFF0000FF, "* {AA25FA}[Работа] {20FFFF}Добро пожаловать на работе Курьера , чтобы начать работу садитесь в машину!");
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/дальнобойщик", true) == 0) {
    SetPlayerPos(playerid,2.2692,-264.9087,5.4297);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {FFFF00}телепортировался к работе Дальнобойщик {B85FF3}( /работы2 или /дальнобойщик )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/золотник", true) == 0) {
    SetPlayerPos(playerid,-1998.2095,-1585.0023,86.4245);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {FFFF00}телепортировался к работе Золотника {B85FF3}( /работы2 или /золотник )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/akvapark", true) == 0) {
    SetPlayerPos(playerid,291.11,-1886.83,1.83);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Akvapark {B85FF3}( /akvapark )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/lc", true) == 0) {
    SetPlayerPos(playerid,-794.84,489.98,1377.60);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Либерти Сити {B85FF3}( /lc )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,1);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/банк", true) == 0) {
    SetPlayerPos(playerid,1275.61,-1314.74,13.32);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Банк {B85FF3}( /банк )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/банк2", true) == 0) {
    SetPlayerPos(playerid,1475.40,-1757.57,17.53);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Банк #2 {B85FF3}( /банк2 )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/ostrov", true) == 0) {
    SetPlayerPos(playerid,796.14,-2835.19,5.82);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Остров {B85FF3}( /ostrov )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/gorodok", true) == 0) {
    SetPlayerPos(playerid,-130.99,-1633.11,3.38);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в Городок {B85FF3}( /gorodok )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

 	if(strcmp(cmdtext, "/водолаз", true) == 0) {
    SetPlayerPos(playerid,707.2558,-1478.4854,5.468);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {FFFF00}телепортировался на работу Водолаз {B85FF3}( /работы2 или /водолаз )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/археолог", true) == 0) {
    SetPlayerPos(playerid,876.0891,-31.7464,63.1953);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {FFFF00}телепортировался на работу Археолог {B85FF3}( /работы2 или /археолог )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/forest", true) == 0) {
    SetPlayerPos(playerid,-1737.8334,-3112.1792,1.0437);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в Старый Лес {B85FF3}( /forest )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/drag2", true) == 0) {
    SetPlayerPos(playerid,-2679.1379,1238.6624,55.6876);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на Drag #2 {B85FF3}( /drag2 )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/bmxpark", true) == 0) {
    SetPlayerPos(playerid,1920.1694,-1402.0734,13.5703);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортрировался в ВМХ Парк {B85FF3}( /bmxpark )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/jump", true) == 0) {
    SetPlayerPos(playerid,1543.629150,-1358.963378,329.464660);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Зону прыжков {B85FF3}( /jump )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/ls", true) == 0) {
    SetPlayerPos(playerid,309.7184,-1771.8354,4.5721);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в город Los Santos {B85FF3}( /ls )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/stuntsf", true) == 0) {
    SetPlayerPos(playerid,-1362.9072,-267.6884,14.1484);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Stunt San Fierro {B85FF3}( /stuntsf )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/gruv", true) == 0) {
    SetPlayerPos(playerid,2482.1042,-1692.1602,13.5152);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Gruv Street {B85FF3}( /gruv )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

	if(strcmp(cmdtext, "/ballas", true) == 0) {
    SetPlayerPos(playerid,2172.4453,-1677.5505,15.0859);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в дом BallaS {B85FF3}( /ballas )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/lv", true) == 0) {
    SetPlayerPos(playerid,1675.4208,1447.2802,10.7875);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в город Las Venturas {B85FF3}( /lv )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/voenka", true) == 0) {
    SetPlayerPos(playerid,285.3131,2007.0435,17.6406);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Военную базу {B85FF3}( /voenka )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/sf", true) == 0) {
    SetPlayerPos(playerid,-2030.3229,161.2125,28.8359);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в город San Fierro {B85FF3}( /sf )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/FBI", true) == 0) {
    SetPlayerPos(playerid,933.2227,-1262.8456,959.3936);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в в 'FBI Department' {B85FF3}( /FBI )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/spusk", true) == 0) {
    SetPlayerPos(playerid,651.6271,1430.6841,1026.0570);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Spusk {B85FF3}( /spusk )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/weapost", true) == 0) {
    SetPlayerPos(playerid,1156.3682,-1640.7036,13.9531);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Weaponstore {B85FF3}( /weapost )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/stuntgora", true) == 0) {
    SetPlayerPos(playerid,-2345.0815,-1615.2330,485.3003);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Stunt Chilliand {B85FF3}( /stuntgora )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/race2", true) == 0) {
    SetPlayerPos(playerid,-2409.1953,-2190.6052,34.0391);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Горную гонку {B85FF3}( /race2 )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/bigtunel", true) == 0) {
    SetPlayerPos(playerid,2217.2629, 1466.551, 3870.7451);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на БигТунель {B85FF3}( /bigtunel )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/нло", true) == 0) {
    SetPlayerPos(playerid,13.1051,61.1155,3.1172);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался к НЛО {B85FF3}( /нло )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/Hospital", true) == 0) {
    SetPlayerPos(playerid,1976.0076,-1823.4600,13.7067);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Hospital' {B85FF3}( /Hospital )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/cinema", true) == 0) {
    SetPlayerPos(playerid,1581.7775,-1950.1964,35.5432);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Cinema-Еheatre' {B85FF3}( /cinema )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/басейн", true) == 0) {
    SetPlayerPos(playerid,-1469.3625,-549.0286,1.3588);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался покупаться в Басейне {B85FF3}( /басейн )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/spiritbaz", true) == 0) {
    SetPlayerPos(playerid,1025.5266,-365.6132,73.6838);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Базу Спирита {B85FF3}( /spiritbaz )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/rest", true) == 0) {
    SetPlayerPos(playerid,2486.1060,1531.7153,10.6126);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Местечко Отдыха {B85FF3}( /rest )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/concert", true) == 0) {
    SetPlayerPos(playerid,1723.5092,-652.9614,494.5934);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на 'Concert Hall' {B85FF3}( /concert )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/gruz", true) == 0) {
    SetPlayerPos(playerid,2184.39,-2260.46,13.41);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {FFFF00}телепортировался на работу Грузчика {B85FF3}( /работы2 или /gruz )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/kafemore", true) == 0) {
    SetPlayerPos(playerid,356.6372,-1909.5275,4.5871);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Кафе 'У Моря' {B85FF3}( /kafemore )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/hroom", true) == 0) {
    SetPlayerPos(playerid,291.282989,310.031982,999.148437);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Helena room {B85FF3}( /hroom )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,3);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/woffice", true) == 0) {
    SetPlayerPos(playerid,-2159.122802,641.517517,1052.381713);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Woozie's office {B85FF3}( /woffice )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,1);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/meatfactory", true) == 0) {
    SetPlayerPos(playerid,963.418762,2108.292480,1011.030273);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Meat factory {B85FF3}( /meatfactory )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,1);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/shermandam", true) == 0) {
    SetPlayerPos(playerid,-959.564392,1848.576782,9.000000);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Sherman dam {B85FF3}( /shermandam )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,17);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/8track", true) == 0) {
    SetPlayerPos(playerid,-1398.065307,-217.028900,1051.115844);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на 8-Track {B85FF3}( /8track )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,7);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/bloodbowl", true) == 0) {
    SetPlayerPos(playerid,-1398.103515,937.631164,1036.479125);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Bloodbowl {B85FF3}( /bloodbowl )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,15);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/dtrack", true) == 0) {
    SetPlayerPos(playerid,-1444.645507,-664.526000,1053.572998);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Dirt track {B85FF3}( /dtrack )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,4);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/kickstart", true) == 0) {
    SetPlayerPos(playerid,-1465.268676,1557.868286,1052.531250);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Kickstart {B85FF3}( /kickstart )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,14);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/vstadium", true) == 0) {
    SetPlayerPos(playerid,-1401.829956,107.051300,1032.273437);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Vice stadium {B85FF3}( /vstadium )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,1);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/lsatruim", true) == 0) {
    SetPlayerPos(playerid,1710.433715,-1669.379272,20.225049);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на LS Atruim {B85FF3}( /lsatruim )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,18);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/bschool", true) == 0) {
    SetPlayerPos(playerid,1494.325195,1304.942871,1093.289062);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Bike School {B85FF3}( /bschool )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,3);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/mroom", true) == 0) {
    SetPlayerPos(playerid,346.870025,309.259033,999.155700);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Millie room {B85FF3}( /mroom )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,6);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/broom", true) == 0) {
    SetPlayerPos(playerid,322.197998,302.497985,999.148437);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Barbara room {B85FF3}( /broom )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,5);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/miroom", true) == 0) {
    SetPlayerPos(playerid,302.180999,300.722991,999.148437);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Michelle room {B85FF3}( /miroom )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,4);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/bfh", true) == 0) {
    SetPlayerPos(playerid,1038.531372,0.111030,1001.284484);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Blastin fools hallway {B85FF3}( /bfh )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,3);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/restorancezar", true) == 0) {
    SetPlayerPos(playerid,1008.7291,-1355.2432,14.9562);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Мини-Ресторан 'Цезарь' {B85FF3}( /restorancezar )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/restoranob", true) == 0) {
    SetPlayerPos(playerid,1002.8301,-1306.1179,13.5423);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Ресторан 'Обжора' {B85FF3}( /restoranob )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/trubssf", true) == 0) {
    SetPlayerPos(playerid,-2060.7690,-126.8908,35.3246);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Трубы San Fierro {B85FF3}( /trubssf )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/race", true) == 0) {
    SetPlayerPos(playerid,2106.1147,843.3138,7.5825);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}зашёл на Гонку в Las Venturas {B85FF3}( /race )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/terminalsf", true) == 0) {
    SetPlayerPos(playerid,-1951.7241,136.5687,26.2813);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Вокзал San Fierro {B85FF3}( /terminalsf )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/jizzy", true) == 0) {
    SetPlayerPos(playerid,-2621.1584,1400.2754,7.1016);
    new playername[30];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Клуб 'Джиззи' {B85FF3}( /jizzy )",playername,playerid);
    SendClientMessageToAll(0xB85FF3AA, string);
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
    SetTogglePlayerPos(playerid);
    return true;}

    if(strcmp(cmdtext, "/docsf", true) == 0)
	{
	    SetPlayerPos(playerid,-1651.0532,36.0664,3.5547);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Доки San Fierro {B85FF3}( /docsf )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/aerosf", true) == 0)
	{
	    SetPlayerPos(playerid,-1550.3787,-433.9974,6.0364);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Аэропорт San Fierro {B85FF3}( /aerosf )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/wangcars", true) == 0)
	{
	    SetPlayerPos(playerid,-1952.4572,285.7984,36.6111);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Автосалон 'Wang Cars' {B85FF3}( /wangcars )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/ottosautos", true) == 0)
	{
	    SetPlayerPos(playerid,-1668.4133,1206.9596,13.6719);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Автосалон 'Otto's Autos' {B85FF3}( /ottosautos )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/площадь", true) == 0)
	{
	    SetPlayerPos(playerid,-2706.0654,375.8479,4.9686);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Площадь San Fierro {B85FF3}( /площадь )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/tuningsf", true) == 0)
	{
	    SetPlayerPos(playerid,-2707.3535,218.5471,4.1797);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Tuning Cars San Fierro {B85FF3}( /tuningsf )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/golf", true) == 0)
	{
	    SetPlayerPos(playerid,-2679.5449,-276.1423,7.1730);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Гольф Парк San Fierro {B85FF3}( /golf )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/casino4dracon", true) == 0)
	{
	    SetPlayerPos(playerid,2028.6458,1029.7288,10.8203);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Казино '4 Дракона' {B85FF3}( /casino4dracon )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/casinocaliguli", true) == 0)
	{
	    SetPlayerPos(playerid,2181.3157,1667.0054,11.0632);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Казино 'Калигули' {B85FF3}( /casinocaliguli )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/pirat", true) == 0)
	{
	    SetPlayerPos(playerid,2000.4231,1520.7107,17.0625);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Пиратский Корабль {B85FF3}( /pirat )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/ammolv", true) == 0)
	{
	    SetPlayerPos(playerid,2156.1172,935.1474,10.8203);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Аммунацыю Las Venturas {B85FF3}( /ammolv )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/aerolv", true) == 0)
	{
	    SetPlayerPos(playerid,1718.9296,1603.6212,13.1179);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в Аэропорт Las Venturas {B85FF3}( /aerolv )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/terminallv", true) == 0)
	{
	    SetPlayerPos(playerid,2859.1646,1266.2284,11.3906);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Вокзал Las Venturas {B85FF3}( /terminallv )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/пляж", true) == 0)
	{
	    SetPlayerPos(playerid,262.3611,-1871.9818,2.4681);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Пляж {B85FF3}( /пляж )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/skyscraper", true) == 0)
	{
	    SetPlayerPos(playerid,1543.629150,-1358.963378,329.464660);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Небоскрёб {B85FF3}( /skyscraper )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/aerols", true) == 0)
	{
	    SetPlayerPos(playerid,1967.6398,-2181.2295,13.5469);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в Аэропорт Los Santos {B85FF3}( /aerols )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/terminalls", true) == 0)
	{
	    SetPlayerPos(playerid,1733.6125,-1950.4171,14.1172);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Вокзал Los Santos {B85FF3}( /terminalls )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/rublevka", true) == 0)
	{
	    SetPlayerPos(playerid,-320.49,1813.44,42.36);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в Рублевку {B85FF3}( /rublevka )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/turma", true) == 0)
	{
	    SetPlayerPos(playerid,2499.0771,-1512.5469,24.0000);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в Тюрьму {B85FF3}( /turma )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/pb", true) == 0)
	{
	    SetPlayerPos(playerid,1254.6926,-1416.1410,13.6445);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся в Приват-Банк {B85FF3}( /pb )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/ghouse", true) == 0)
	{
	    SetPlayerPos(playerid,2375.0012,-1638.7683,13.5529);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Grove Street GangHouse' {B85FF3}( /ghouse )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/vhouse", true) == 0)
	{
	    SetPlayerPos(playerid,2006.5708,-1045.4594,24.6565);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Vagos GangHouse' {B85FF3}( /vhouse )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/ahouse", true) == 0)
	{
	    SetPlayerPos(playerid,2537.8110,-1471.3811,24.0389);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Aztec GangHouse' {B85FF3}( /ahouse )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/bhouse", true) == 0)
	{
	    SetPlayerPos(playerid,2272.9075,-1405.0496,24.4656);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Ballas GangHouse' {B85FF3}( /bhouse )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/restoranmore", true) == 0)
	{
	    SetPlayerPos(playerid,1018.8289,-1872.2533,14.7465);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Ресторан у моря' {B85FF3}( /restoranmore )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/klubsf", true) == 0)
	{
	    SetPlayerPos(playerid,-2235.0952,104.0220,35.3422);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'Ночной Клуб' {B85FF3}( /klubsf )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/cityhall", true) == 0)
	{
	    SetPlayerPos(playerid,2759.2302,-2420.6379,816.0160);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в 'City Hall' {B85FF3}( /cityhall )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/bigisland", true) == 0)
	{
	    SetPlayerPos(playerid,3378.1328,-1867.6792,1.8008);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на большой Остров {B85FF3}( /bigisland )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/spripbar", true) == 0)
	{
	    SetPlayerPos(playerid,2620.6697,-1729.8931,674.9755);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался в StriptiZzZ BaR {B85FF3}( /spripbar )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/aerostunt", true) == 0)
	{
	    SetPlayerPos(playerid,1999.7462,-2191.2947,13.6503);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на АероСтант {B85FF3}( /aerostunt )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/motostunt", true) == 0)
	{
	    SetPlayerPos(playerid,2001.645507,29.789215,31.295146);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на МотоСтант {B85FF3}( /motostunt )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/box", true) == 0)
	{
	    SetPlayerPos(playerid,3165.430175,-2134.053466,8.843608);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Бокс Арену {B85FF3}( /box )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/trubs", true) == 0)
	{
	    SetPlayerPos(playerid,1552.1981,-1361.5740,329.4674);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Трубы с небоскрёба {B85FF3}( /trubs )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/platrubs", true) == 0)
	{
	    SetPlayerPos(playerid,2899.4214,-2051.5171,3.5480);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортнулся на Трубы на пляже {B85FF3}( /platrubs )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/sumo", true) == 0)
	{
	    SetPlayerPos(playerid,-429.922394, 2506.329834, 131.333527);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Sumo арену {B85FF3}( /sumo )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
    	return true;
	}

    if(strcmp(cmdtext, "/drag", true) == 0)
	{
	    SetPlayerPos(playerid,-1683.99,-193.55,14.15);
	    new playername[30];
	    GetPlayerName(playerid,playername,sizeof(playername));
	    format(string,sizeof(string),"%s(ID: %d) {11F411}телепортировался на Drag {B85FF3}( /drag )",playername,playerid);
	    SendClientMessageToAll(0xB85FF3AA, string);
	    SetPlayerInterior(playerid,0);
	    SetPlayerVirtualWorld(playerid,0);
	    SetTogglePlayerPos(playerid);
	    return true;
	}

    if(strcmp(cmdtext, "/colors", true) == 0 || strcmp(cmdtext, "/colours", true) == 0)
	{
	    new String[4000];
	    strins(String,"{FFF000}Введите ид цвета от 0-34!\n",strlen(String));
	    strins(String,"\n",strlen(String));
	    strins(String,"{FFFFFF}0.{AA3333}[|||||||]\t\t{FFFFFF}18.{4B00B0}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}1.{AFAFAF}[|||||||]\t\t{FFFFFF}19.{FFFF82}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}2.{33AA33}[|||||||]\t\t{FFFFFF}20.{7CFC00}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}3.{FF9900}[|||||||]\t\t{FFFFFF}21.{32CD32}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}4.{0000BB}[|||||||]\t\t{FFFFFF}22.{191970}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}5.{33CCFF}[|||||||]\t\t{FFFFFF}23.{800000}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}6.{FFFF00}[|||||||]\t\t{FFFFFF}24.{808000}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}7.{10F441}[|||||||]\t\t{FFFFFF}25.{FF4500}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}8.{000080}[|||||||]\t\t{FFFFFF}26.{FFC0CB}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}9.{F0F8FF}[|||||||]\t\t{FFFFFF}27.{00FF7F}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}10.{DC143C}[|||||||]\t{FFFFFF}28.{FF6347}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}11.{6495ED}[|||||||]\t{FFFFFF}29.{9ACD32}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}12.{FFE4C4}[|||||||]\t{FFFFFF}30.{83BFBF}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}13.{7FFF00}[|||||||]\t{FFFFFF}31.{8B008B}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}14.{A52A2A}[|||||||]\t{FFFFFF}32.{DC143C}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}15.{FF7F50}[|||||||]\t{FFFFFF}33.{EFEFF7}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}16.{B8860B}[|||||||]\t{FFFFFF}34.{330066}[|||||||]\n",strlen(String));
	    strins(String,"{FFFFFF}17.{ADFF2F}[|||||||]\n",strlen(String));
	    ShowPlayerDialog(playerid,888,DIALOG_STYLE_INPUT,"{DFDF02}»»» Цвет «««",String,"»[Выбрать]«","»[Назад]«");
	    return true;
	}

	if(strcmp("/unbanname", cmdtext, true, 10) == 0)
	{
	    if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid))
		{
		    tmp = strtok(cmdtext,idx);
		    if (!strlen(tmp)) return SendClientMessage(playerid, red, "ПРАВКА: /unbanname [ник] (разбанить ник)");
		    new PFp[256]; format(PFp,sizeof(PFp),"/ladmin/users/%s.sav",udb_encode(tmp)); //format(PFp,sizeof(PFp),"/ladmin/users/%s.sav", strval(tmp));
		    if (!dini_Exists(PFp)) return SendClientMessage(playerid, red,"Неверное имя!");
		    dini_IntSet(PFp,"banned", 0);
		    format(string,sizeof(string), "{00FF00}Ник %s разблокирован.",tmp);
		    SendClientMessage(playerid, red, string);
	    }
		else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	    return true;
	}

    if( !strcmp(cmdtext,"/ming",true ))
	{
	    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	    new rand = random(sizeof(MINI));
	    SetPlayerPos(playerid,MINI[rand][0],MINI[rand][1],MINI[rand][2]);
	    ResetPlayerWeapons(playerid);
	    SetTogglePlayerPos(playerid);
	    SetPlayerVirtualWorld(playerid,3);
	    SetPlayerInterior(playerid,1);
	    GivePlayerWeapon(playerid,38,300);
	    SetPlayerHealthAC(playerid,100.0);
	    SetPlayerArmour(playerid,100);
		zonezapret[playerid] = 2;
	    new pname[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "%s телепортировался на Mini Game {FF6666}(/ming)", pname);
	   	SendClientMessageToAll(0x36B4F8AA, string);
		return true;
	}

    if( !strcmp(cmdtext,"/cs",true ))
	{
	    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	    new rand = random(sizeof(CSS));
	    SetPlayerPos(playerid,CSS[rand][0],CSS[rand][1],CSS[rand][2]);
	    ResetPlayerWeapons(playerid);
	    SetTogglePlayerPos(playerid);
	    SetPlayerVirtualWorld(playerid,2);
	    SetPlayerInterior(playerid, 0);
	    GivePlayerWeapon(playerid,24,50);
	    GivePlayerWeapon(playerid,31,400);
	    GivePlayerWeapon(playerid,34,10);
	    GivePlayerWeapon(playerid,4,1);
	    GivePlayerWeapon(playerid,16,2);
	    SetPlayerHealthAC(playerid,20.0);
	    SetPlayerArmour(playerid, 20);
		zonezapret[playerid] = 0;
	    new pname[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "%s телепортировался на Conter Strike {FF6666}(/cs)", pname);
	   	SendClientMessageToAll(0x36B4F8AA, string);
		return true;
	}

    if( !strcmp(cmdtext,"/mg",true ))
	{
	    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	    new rand = random(sizeof(CSS));
	    SetPlayerPos(playerid,MG[rand][0],MG[rand][1],MG[rand][2]);
	    ResetPlayerWeapons(playerid);
	    SetTogglePlayerPos(playerid);
	    SetPlayerVirtualWorld(playerid,1);
	    SetPlayerInterior(playerid, 18);
	    GivePlayerWeapon(playerid,4,1);
	    SetPlayerHealthAC(playerid,20.0);
	    SetPlayerArmour(playerid, 0);
	   	zonezapret[playerid] = 1;
	    new pname[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "%s телепортировался на Meat Game {FF6666}(/mg)", pname);
	   	SendClientMessageToAll(0x36B4F8AA, string);
		return true;
	}

    if (strcmp("/duel", cmdtext, true, 10) == 0)
	{
		if (IsPlayerConnected(playerid))
		{
		    if(DuelStatus == 0)
			{
		    	ShowPlayerDialog(playerid,5000,1,"{F8FF88}Введите ID","{3344CC}Введите ID игрока с которым вы хотите провести дуэль","Далее","Отмена");
		    }
			else{
   				SendClientMessage(playerid,-1,"{CC00DD}[Дуэль]{FF0000}Подождите пока не закончится дуэль");
		    }
		}
		return true;
	}

    new cmdd[256], idxx;
    cmdd = strtok(cmdtext, idxx);

	if(!strcmp(cmdd,"/family",true))
    {
        new tmpp[256];
        new stringg[256];
        new idp;
        tmpp = strtok(cmdtext, idxx);
        if(!strlen(tmpp))
        {
            SendClientMessage(playerid, 0xFFFFFFFF, " Используйте: /family [id]");
            return 1;
        }
        if(IsNumericc(tmpp))
        {
            idp = strval(tmpp);
        }
        else
        {
            SendClientMessage(playerid, 0xFFFFFFFF, " Введите id игрока!");
            return 1;
        }
        if (!IsPlayerConnected(idp))
        {
            SendClientMessage(playerid, 0xFFFFFFFF, " Этот игрок не подключен!");
            return 1;
        }
        if (!strcmp(newlywed[idp], "0", true, 1))
        {
            SendClientMessage(playerid, 0xFFFFFFFF, " У этого игрока не заключен брак!");
			return 1;
	    }
	    if(Sex[idp] == 1)
	    {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(idp, name, sizeof name);
		    format(stringg,sizeof(stringg)," %s замужем за %s ",name, newlywed[idp]);
            SendClientMessage (playerid, 0xB4B5B7FF, stringg);
            return 1;
        }
        else if(Sex[idp] == 2)
	    {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(idp, name, sizeof name);
		    format(stringg,sizeof(stringg)," %s женат на %s ",name, newlywed[idp]);
            SendClientMessage (playerid, 0xB4B5B7FF, stringg);
            return 1;
        }
        return 1;
    }
	
	if (strcmp("/мигалкасукаыав", cmdtext, true, 10) == 0)
    {
        if(lustra[GetPlayerVehicleID(playerid)]!=-1)
		{
			DestroyObject(lustra[GetPlayerVehicleID(playerid)]);
			lustra[GetPlayerVehicleID(playerid)]=-1;
		}
		lustra[GetPlayerVehicleID(playerid)] = CreateObject(19419,0,0,0,0,0,0,0.0);
		switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
		{
			case 401:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), -0.004999, 0.000000, 0.799999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 402:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), -0.004999, -0.519999, 0.769999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 404:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), -0.004999, -0.224999, 0.934999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 405:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), -0.004999, -0.224999, 0.759999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 410:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.010000, -0.224999, 0.899999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 409:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.419999, 0.824999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 411:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.089999, 0.719999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 412:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.089999, 0.714999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 413:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.704999, 1.134999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 415:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.259999, 0.609999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 418:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.389999, 1.039999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 419:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.324999, 0.694999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 421:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.174999, 0.729999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 422:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.044999, 0.799999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 424:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.044999, 0.864999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 426:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.264999, 0.849999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 428:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.754999, 1.369998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 431:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, 5.230072, 2.115000, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 434:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, -0.060000, 0.729999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 436:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, -0.259999, 0.844999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 437:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, 4.630058, 2.044999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 442:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, 0.009999, 0.889999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 444:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, 0.234999, 1.689998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 445:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.020000, -0.254999, 0.844999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 451:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), -0.044999, -0.534999, 0.589999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 455:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), -0.044999, 1.189998, 1.664998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 458:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.000000, 0.724999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 459:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.544999, 1.114999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 466:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.204999, 0.849999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 467:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.004999, 0.829999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 470:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.004999, 1.089999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 474:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.229999, 0.794999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 475:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.229999, 0.704999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 477:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.404999, 0.734999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 478:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.125000, 0.909999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 479:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.269999, 0.984999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 480:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -1.024999, 0.684999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 482:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 1.074999, 0.904999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 483:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 1.499998, 1.019999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 489:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.114999, 1.084999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 490:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.474999, 1.089999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 491:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.404999, 0.679999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 492:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.279999, 0.859999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 494:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.374999, 0.739999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 495:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.050000, 0.999999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 496:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.444999, 0.809999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 498:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 1.749998, 2.014998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 502:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.469999, 0.779999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 503:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.469999, 0.764999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 504:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.065000, 0.854999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 505:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.065000, 1.084999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 506:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.444999, 0.574999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 507:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.339999, 0.779999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 516:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.089999, 0.864999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 517:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.344999, 0.839999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 518:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.119999, 0.689999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 525:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.454999, 1.444998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 528:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.050000, 1.074999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 527:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.054999, 0.874999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 526:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.234999, 0.644999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 529:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.234999, 0.899999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 534:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.029999, 0.604999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 535:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.095000, 0.804999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 540:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.259999, 0.699999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 541:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.259999, 0.619999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 542:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.259999, 0.829999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 543:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.110000, 0.874999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 544:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 2.510010, 1.459998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 545:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.384999, 0.744999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 546:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.384999, 0.834999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 547:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.384999, 0.889999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 549:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.035000, 0.719999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 550:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.089999, 0.724999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 551:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.344999, 0.904999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 552:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.609999, 1.314998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 554:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.025000, 1.004999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 556:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.489999, 1.679998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 557:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.010000, 1.639998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 558:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.354999, 0.824999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 559:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.354999, 0.704999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 562:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.354999, 0.749999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 561:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.129999, 0.829999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 560:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.074999, 0.824999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 565:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.414999, 0.674999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 566:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.169999, 0.844999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 576:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.169999, 0.884999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 579:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.369999, 0.939999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 580:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.059999, 1.034999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 585:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.259999, 0.974999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 587:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.599999, 0.734999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 589:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.194999, 1.049999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 601:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 1.209999, 1.499998, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 604:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.159999, 0.864999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 603:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.429999, 0.644999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 602:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, -0.429999, 0.679999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			case 605:AttachObjectToVehicle(lustra[GetPlayerVehicleID(playerid)], GetPlayerVehicleID(playerid), 0.000000, 0.015000, 0.884999, 0.000000, 0.000000, 0.000000); //Object Model: 19419 |
			default: SendClientMessage(playerid,0xFA7516FF,"{FF0000}*** {8b00ff}На эту машину нельзя установить мигалку!");
		}
		return true;
	}

	if (strcmp(cmdtext, "/duelspec", true)==0)
    {
	    if(PlayerInfo[playerid][Level] >= 1)
	    SetPlayerPos(playerid, 2570.6, 2819.5, 19.30 );
	    else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	    return true;
	}

    if(strcmp(cmd, "/nivedblms", true) == 0)
	{
        PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
        if(GetPlayerMoney(playerid) < 10000) {SendClientMessage(playerid, COLOR_RED, "{0AD383}*** {FF0000}У тебя не хватает денег на покупку невидимки нужно 10000$.");return 1;}
        SetPlayerColor(playerid,GetPlayerColor(playerid) & 0xFFFFFF00);
        GivePlayerMoney(playerid,-10000);
        SendClientMessage(playerid, COLOR_WHITE, "{8CFF00}*** {00FFFF}Теперь ты невидимка тебя никто не видит на радаре");
        SendClientMessage(playerid, COLOR_WHITE, "{8CFF00}*** {00FFFF}Эффект неожиданости за тобой пользуйся им!");
		return true;
	}

	if(strcmp(cmd, "/scars", true) == 0)
	{
		if(IsPlayerConnected(playerid))
		{
			if(PlayerInfo[playerid][Level] < 8) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор 8 уровня {FF0000}Развлекательного Центра™{0AD383}!");
			for(new c=0; c<MAX_VEHICLES; c++)
			{
				if(!IsVehicleOccupied(c)) SetVehicleToRespawn(c);
			}
   			new admname[64];
   			GetPlayerName(playerid,admname,sizeof(admname));
		    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}зареспавнил незанятый транспорт!",admname);
		    SendClientMessageToAll(red,string);
  		}
		return true;
	}

	if(strcmp(cmd, "/lrest", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    if(PlayerInfo[playerid][Level] < 3) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор 3 уровня {FF0000}Развлекательного Центра™{0AD383}!");
		    new admname[64];
		    GetPlayerName(playerid,admname,sizeof(admname));
		    format(string,sizeof(string),"{00F200}*** {8b00ff}Админ {FF0000}%s {8b00ff}решил отдохнуть от всех вас!",admname);
		    SendClientMessageToAll(red,string);
		    SetPlayerPos(playerid,-1385.8981,2110.1897,42.0688);
	    }
		return true;
	}

    if(strcmp(cmd, "/skexit", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
	    	if(PlayerInfo[playerid][Level] < 12) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	    	SetPlayerPos(playerid,-3792.4221,1518.6224,0.4550);
	    }
		return true;
	}

    if(strcmp(cmd, "/skexithard", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    if(PlayerInfo[playerid][Level] < 12) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
		    SetPlayerPos(playerid,3565.9099,619.4527,-0.1432);
	    }
		return true;
	}

    if(strcmp(cmd, "/adminhouse", true) == 0)
	{
	    if(IsPlayerConnected(playerid))
		{
		    if(PlayerInfo[playerid][Level] < 6) return SendClientMessage(playerid, red, "{0AD383}*** Ты не Администратор {FF0000}Развлекательного Центра™{0AD383}!");
		    SetPlayerPos(playerid,2550.9275,-1292.7086,1060.9844);
		    SetPlayerInterior(playerid,2);
	    }
		return true;
	}

    if(strcmp(cmd, "/changenick", true) == 0)
	{
		if(PlayerInfo[playerid][Level] > 0)
		{
  			SendClientMessage(playerid,0x2EEB41AA,"*** Админам нельзя менять ник! Если хотите поменять, обращайтесь в Телеграм {308CE9}t.me/e_centersamp{2EEB41}!");
		}
 		if(PlayerInfo[playerid][Level] < 1 )
		{
 			new String[1024];
    		strins(String,"{F8FF88}Введите в окошко свой новый ник...\n",strlen(String));
    		strins(String,"{F8FF88}В нике должно быть {308CE9}3 - 20 {F8FF88}символов!\n",strlen(String));
    		strins(String,"{F8FF88}Не в коем случае не используйте {308CE9}РУССКИЕ БУКВЫ{F8FF88}! Только {308CE9}Английские{F8FF88}!\n",strlen(String));
    		strins(String,"{F8FF88}Не использовать такие знаки : {308CE9}! @ # $ % & * (пробел){F8FF88}!\n",strlen(String));
			strins(String,"{F8FF88}Можно использовать : {308CE9}( ) _ [ ] . ={F8FF88}!\n",strlen(String));
    		strins(String,"{F8FF88}После смена Никнейма, не забудьте поменять сам ник в Name (в самом клиенте)!\n",strlen(String));
			strins(String,"{F8FF88}И если хотите, нажмите 'Отмена' и посмотрите свою статистику и сделайте скрин F8! \n",strlen(String));
    		strins(String,"{F8FF88}Нужен скрин с инфо , если вы не правильно создадите свой новый ник!\n",strlen(String));
			strins(String,"{F8FF88}** Если вы не соблюдали все эти правила, ваш аккаунт может изчезнуть!\n",strlen(String));
			strins(String,"{FFFFFF}                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",strlen(String));
    		strins(String,"{FF0000}Скрины кидать в Телеграм: {308CE9}t.me/e_centersamp\n",strlen(String));
			strins(String,"{FF0000}Администрация не несет ответственность за Ваши аккаунты!\n",strlen(String));
    		strins(String,"{FF0000}Если Вы неправильно создадите никнейм!\n",strlen(String));
			ShowPlayerDialog(playerid,5006,DIALOG_STYLE_INPUT,"{F8FF88}Смена Никнейма",String,"Сменить","Отмена");
		}
		return true;
	}

    if(strcmp(cmd, "/acmd", true) == 0)
	{
	    if(PlayerInfo[playerid][Level] < 1 )
		{
		    SendClientMessage(playerid,0x0AD383AA,"*** Ты не Администратор сервера {FF0000}Развлекательного Центра™{0AD383}!");
		    SendClientMessage(playerid,0x0AD383AA,"*** Для информацыии о продаже прав администрации введите {FF0000}/adminka{0AD383}!");
		}
		if(PlayerInfo[playerid][Level] > 0)
		{
		    ShowPlayerDialog(playerid, 3312, DIALOG_STYLE_LIST, "{FFFF00}Команды Админа","{FF8000}1 Уровень\n{FF8000}2 Уровень\n{FF8000}3 Уровень\n{FF8000}4 Уровень\n{FF8000}5 Уровень\n{FF8000}6 Уровень\n{FF8000}7 Уровень\n{FF8000}8 Уровень\n{FF8000}9 Уровень\n{FF8000}10 Уровень\n{FF8000}11 Уровень","..::|Читать|::..","..::|Выход|::..");
	    }
		return true;
	}
    
    if(strcmp(cmd, "/arules", true) == 0)
	{
	    if(PlayerInfo[playerid][Level] < 1 )
		{
		    SendClientMessage(playerid,0x0AD383AA,"*** Ты не Администратор сервера {FF0000}Развлекательного Центра™{0AD383}!");
		    SendClientMessage(playerid,0x0AD383AA,"*** Для информацыии о продаже прав администрации введите {FF0000}/adminka{0AD383}!");
		}
		if(PlayerInfo[playerid][Level] > 0)
		{
		    ShowPlayerDialog(playerid, 3311, DIALOG_STYLE_LIST, "{FFFF00}Правила для Администрации","{FFFF00}Администратору запрещается и Администратор обязан\n{FFFF00}Второстепенные правила","..::|Читать|::..","..::|Выход|::..");
	    }
		return true;
	}
    
	if(strcmp(cmd, "/teles", true) == 0 || strcmp(cmd, "/еудуы", true) == 0)
	{
	    new Tpdialog[700];
	    format(Tpdialog,sizeof(Tpdialog), "%s%s%s%s%s%s%s%s%s%s%s",
	    telesnew[0],
	    telesnew[1],
	    telesnew[2],
	    telesnew[3],
	    telesnew[4],
	    telesnew[5],
	    telesnew[6],
	    telesnew[7],
	    telesnew[8],
	    telesnew[9],
	    telesnew[10]);
	    ShowPlayerDialog(playerid, 7123, DIALOG_STYLE_LIST, "{FFFF00}Телепорты Развлекательного Центра™", Tpdialog, "Выбрать","Отмена");
	    return true;
	}
    
    if(strcmp(cmd, "/textdraw", true) == 0 || strcmp(cmd, "/еучевкфц", true) == 0)
	{
	    new Tpdialog[700];
	    format(Tpdialog,sizeof(Tpdialog), "%s%s%s%s%s%s%s%s%s%s%s",
	    textdraw[0],
	    textdraw[1],
	    textdraw[2],
	    textdraw[3],
	    textdraw[4],
	    textdraw[5],
	    textdraw[6],
	    textdraw[7],
	    textdraw[8],
	    textdraw[9],
	    textdraw[10]);
	    ShowPlayerDialog(playerid, 9388, DIALOG_STYLE_LIST, "{00FFC8}Упровление TextDraw'aми!", Tpdialog, "Ок", "Выйти");
	    return true;
	}
    
	if(strcmp(cmd, "/help", true) == 0 || strcmp(cmd, "/помощь", true) == 0)
	{
	    new Tpdialog[700];
	    format(Tpdialog,sizeof(Tpdialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	    helpy[0],
	    helpy[1],
	    helpy[2],
	    helpy[3],
	    helpy[4],
	    helpy[5],
	    helpy[6],
	    helpy[7],
	    helpy[8],
	    helpy[9],
	    helpy[10],
	    helpy[11],
	    helpy[12],
	    helpy[13]);
	    ShowPlayerDialog(playerid, 9375, DIALOG_STYLE_LIST, "{00FFC8}Первая помощь!", Tpdialog, "Ок", "Отмена");
	    return true;
	}
    
	if (strcmp("/skin", cmdtext, true) == 0 || strcmp("/Скин", cmdtext, true) == 0)
	{
        ShowPlayerDialog(playerid, 1338, DIALOG_STYLE_LIST, "{DFDF02}Выбор скина", "{FF8700}Выбрать скин по катигориям\n{FFA700}Ввести самому ID скина","»]Выбрать[«", "»]Выход[«");
	}
///========================= [ Car Commands ]====================================
	if(strcmp(cmdtext, "/ltunedcar2", true)==0 || strcmp(cmdtext, "/ltc2", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); CMDMessageToAdmins(playerid,"LTunedCar");	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,1);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = LVehicleIDt;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar3", true)==0 || strcmp(cmdtext, "/ltc3", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); CMDMessageToAdmins(playerid,"LTunedCar");	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,2);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = LVehicleIDt;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar4", true)==0 || strcmp(cmdtext, "/ltc4", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(559,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
    	AddVehicleComponent(carid,1065);    AddVehicleComponent(carid,1067);    AddVehicleComponent(carid,1162); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);	ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar5", true)==0 || strcmp(cmdtext, "/ltc5", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(565,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
	    AddVehicleComponent(carid,1046); AddVehicleComponent(carid,1049); AddVehicleComponent(carid,1053); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar6", true)==0 || strcmp(cmdtext, "/ltc6", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
    	AddVehicleComponent(carid,1088); AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1139); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
 	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar7", true)==0 || strcmp(cmdtext, "/ltc7", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(561,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
    	AddVehicleComponent(carid,1055); AddVehicleComponent(carid,1058); AddVehicleComponent(carid,1064); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar8", true)==0 || strcmp(cmdtext, "/ltc8", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
	    AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar9", true)==0 || strcmp(cmdtext, "/ltc9", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(567,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
	    AddVehicleComponent(carid,1102); AddVehicleComponent(carid,1129); AddVehicleComponent(carid,1133); AddVehicleComponent(carid,1186); AddVehicleComponent(carid,1188); ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1085); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1086);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar10", true)==0 || strcmp(cmdtext, "/ltc10", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
   		AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1166); AddVehicleComponent(carid,1165); AddVehicleComponent(carid,1090);
	    AddVehicleComponent(carid,1094); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1163);//SPOILER
	    AddVehicleComponent(carid,1091); ChangeVehiclePaintjob(carid,2);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar11", true)==0 || strcmp(cmdtext, "/ltc11", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(557,X,Y,Z,Angle,1,1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1081);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar12", true)==0 || strcmp(cmdtext, "/ltc12", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		} else  {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(535,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
		ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1109); AddVehicleComponent(carid,1115); AddVehicleComponent(carid,1117); AddVehicleComponent(carid,1073); AddVehicleComponent(carid,1010);
	    AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1114); AddVehicleComponent(carid,1081); AddVehicleComponent(carid,1119); AddVehicleComponent(carid,1121);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmdtext, "/ltunedcar13", true)==0 || strcmp(cmdtext, "/ltc13", true)==0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid,red," ОШИБКА: У вас есть транспорт");
		else {
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
  		AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		PlayerInfo[playerid][pCar] = carid;
		}
	} else SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	return 1;	}

	if(strcmp(cmd, "/lp", true) == 0)	{
	if(PlayerInfo[playerid][Level] >= 1) {
		if (GetPlayerState(playerid) == 2)
		{
		new VehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(VehicleID);
        switch(LModel) { case 448,461,462,463,468,471,509,510,521,522,523,581,586, 449: return SendClientMessage(playerid,red," ОШИБКА: Вы не можете тюнить этот транспорт"); }
		new str[128], Float:pos[3];	format(str, sizeof(str), "%s", cmdtext[2]);
		SetVehicleNumberPlate(VehicleID, str);
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);	SetPlayerPos(playerid, pos[0]+1, pos[1], pos[2]);
		SetVehicleToRespawn(VehicleID); SetVehiclePos(VehicleID, pos[0], pos[1], pos[2]);
		SetTimerEx("TuneLCar",4000,0,"d",VehicleID);    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		SendClientMessage(playerid, COLOR_GREEN, " Ваша машина была изьята на прокачку");   CMDMessageToAdmins(playerid,"LP");
		} else {
		SendClientMessage(playerid,red," ОШИБКА: Вы не в машине");	}
	} else	{
  	SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 1 уровня {FF0000}Развлекательного Центра™{0AD383}!");   }
	return 1;	}

 	if(strcmp(cmd, "/spam", true) == 0)	{
		if(PlayerInfo[playerid][Level] >= 12) {
		    tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) {
				SendClientMessage(playerid, red, " ПРАВКА: /spam [№ цвета] [текст] (спамить)");
				SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
				return 1;
			}
			new Colour = strval(tmp);
			if(Colour > 9 ) return SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
			tmp = strtok(cmdtext, idx);

			format(string,sizeof(string)," %s",cmdtext[8]);

	        if(Colour == 0) 	 for(new i; i < 50; i++) SendClientMessageToAll(0x2C2727FF,string);
	        else if(Colour == 1) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_WHITE,string);
	        else if(Colour == 2) for(new i; i < 50; i++) SendClientMessageToAll(red,string);
	        else if(Colour == 3) for(new i; i < 50; i++) SendClientMessageToAll(0xFF9900FF,string);
	        else if(Colour == 4) for(new i; i < 50; i++) SendClientMessageToAll(yellow,string);
	        else if(Colour == 5) for(new i; i < 50; i++) SendClientMessageToAll(0x33AA33FF,string);
	        else if(Colour == 6) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_BLUE,string);
	        else if(Colour == 7) for(new i; i < 50; i++) SendClientMessageToAll(0x330066AA,string);
	        else if(Colour == 8) for(new i; i < 50; i++) SendClientMessageToAll(0xA52A2AAA,string);
	        else if(Colour == 9) for(new i; i < 50; i++) SendClientMessageToAll(0xFFC0CBAA,string);
			return 1;
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

 	if(strcmp(cmd, "/write", true) == 0) {
	if(PlayerInfo[playerid][Level] >= 10) {
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, red, " ПРАВКА: /write [№ цвета] [текст] (писать в чат объявления)");
			return SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
	 	}
		new Colour;
		Colour = strval(tmp);
		if(Colour > 9 )	{
			SendClientMessage(playerid, red, " ПРАВКА: /write [Colour] [Text] (писать в чат объявления)");
			return SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
		}
		tmp = strtok(cmdtext, idx);

        CMDMessageToAdmins(playerid,"WRITE");

        if(Colour == 0) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(0x2C2727FF,string); return 1;	}
        else if(Colour == 1) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_WHITE,string); return 1;	}
        else if(Colour == 2) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(red,string); return 1;	}
        else if(Colour == 3) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(0xFF9900FF,string); return 1;	}
        else if(Colour == 4) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(yellow,string); return 1;	}
        else if(Colour == 5) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(0x33AA33FF,string); return 1;	}
        else if(Colour == 6) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_BLUE,string); return 1;	}
        else if(Colour == 7) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(0x330066AA,string); return 1;	}
        else if(Colour == 8) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(0xA52A2AAA,string); return 1;	}
        else if(Colour == 9) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(0xFFC0CBAA,string); return 1;	}
        return 1;
	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Администратор 10 уровня {FF0000}Развлекательного Центра™{0AD383}!");
	}
//Remote Console

	if(strcmp(cmd, "/loadfs", true) == 0) {
	    if(PlayerInfo[playerid][Level] >= 12) {
    		new str[128]; format(str,sizeof(string),"loadfs %s",cmdtext[1]); SendRconCommand(str);
		    return SendClientMessage(playerid,COLOR_WHITE," Скрипт загружен, если вы ввели верное название файла");
	   	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/unloadfs", true) == 0)	 {
	    if(PlayerInfo[playerid][Level] >= 12) {
    		new str[128]; format(str,sizeof(string),"unloadfs %s",cmdtext[1]); SendRconCommand(str);
		    return SendClientMessage(playerid,COLOR_WHITE," Скрипт выгружен, если вы ввели верное название файла");
	   	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/reloadfs", true) == 0)	 {
	    if(PlayerInfo[playerid][Level] >= 12) {
    		new str[128]; format(str,sizeof(string),"reloadfs %s",cmdtext[1]); SendRconCommand(str);
		    return SendClientMessage(playerid,COLOR_WHITE," Скрипт перезагружен, если вы ввели верное название файла");
	   	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/changemode", true) == 0)	 {
	    if(PlayerInfo[playerid][Level] >= 12) {
    		new str[128]; format(str,sizeof(string),"changemode %s",cmdtext[1]); SendRconCommand(str);
		    return SendClientMessage(playerid,COLOR_WHITE," Сейчас будет сменен мод, если вы верно ввели название файла");
	   	} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/gmx", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 12) {
			OnFilterScriptExit(); SetTimer("RestartGM",5000,0);
			return SendClientMessage(playerid,COLOR_WHITE," Сейчас будет рестарт");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/loadladmin", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 12) {
			SendRconCommand("loadfs ladmin5");
			return SendClientMessage(playerid,COLOR_WHITE," Админка загружена");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/unloadladmin", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 12) {
			SendRconCommand("unloadfs ladmin5");
			return SendClientMessage(playerid,COLOR_WHITE," Админка выгружена");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmd, "/reloadladmin", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 12 || IsPlayerAdmin(playerid) ) {
			SendRconCommand("reloadfs ladmin5");
			SendClientMessage(playerid,COLOR_WHITE," Админка перезагружена");
			return CMDMessageToAdmins(playerid,"RELOADLADMIN");
		} else return SendClientMessage(playerid,red,"{0AD383}*** Ты не Создатель {FF0000}Развлекательного Центра™{0AD383}!");
	}

	if(strcmp(cmdtext, "/dm", true, 10) == 0){
    SendClientMessage(playerid,COLOR_WHITE,"{FFFFFF}** {FF0000}Извените временые работы!!! Используйте Alt > ДеадМатчи!");
    return 1;}
	return 0;
}

#if defined ENABLE_SPEC

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	new x = 0;
	while(x!=MAX_PLAYERS) {
	    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
			PlayerInfo[x][SpecID] == playerid && PlayerInfo[x][SpecType] == ADMIN_SPEC_TYPE_PLAYER )
   		{
   		    SetPlayerInterior(x,newinteriorid);
		}
		x++;
	}
}


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & 131072) //"N" - Админ панель
    {
		if(PlayerInfo[playerid][Level] < 1 )
		{
		}
		if(PlayerInfo[playerid][Level] > 0)
		{
		    new String[1000];
		    strins(String,"{00FF40}Включить {FFFFFF}| {FF0000}Выключить\r\n",strlen(String));
		    strins(String,"{00FF00}Вылечить всех игроков\r\n",strlen(String));
		    strins(String,"{00FF00}Дать всем игрокам броню\r\n",strlen(String));
		    strins(String,"{7BFF00}Почистить чат\r\n",strlen(String));
		    strins(String,"{7BFF00}Сменить погоду {FFFFFF}>\r\n",strlen(String));
		    strins(String,"{C4FF00}Выдать игрокам оружие {FFFFFF}>\r\n",strlen(String));
		    strins(String,"{C4FF00}Телепорты {FFFFFF}>\r\n",strlen(String));
		    strins(String,"{C4FF00}Накормить всех наркотиками\r\n",strlen(String));
		    strins(String,"{C4FF00}Взять Мото\r\n",strlen(String));
			strins(String,"{FFDC00}Взять Infernus\r\n",strlen(String));
		    strins(String,"{FFA700}Отдохнуть от всех\r\n",strlen(String));
		    strins(String,"{FF5000}Заспавнить машины\r\n",strlen(String));
		    strins(String,"{FF5000}Jetpack\r\n",strlen(String));
		    strins(String,"{FF2C00}Посмотреть все жалобы\r\n",strlen(String));
		    strins(String,"{FF2C00}GodMod\r\n",strlen(String));
		    ShowPlayerDialog(playerid,5188,DIALOG_STYLE_LIST,"{FF0000}Админ-панель!",String,"»[Выбрать]«","»[Назад]«");
	    }
    }
	if(newkeys & 65536) //"Y" - Инфо сервера
    {
	    new Tpdialog[700];//ok
	    format(Tpdialog,sizeof(Tpdialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	    helpy[0],
	    helpy[1],
	    helpy[2],
	    helpy[3],
	    helpy[4],
	    helpy[5],
	    helpy[6],
	    helpy[7],
	    helpy[8],
	    helpy[9],
	    helpy[10],
	    helpy[11],
	    helpy[12],
	    helpy[13]);
	    ShowPlayerDialog(playerid, 9375, DIALOG_STYLE_LIST, "{00FFC8}Первая помощь!", Tpdialog, "Ок", "Отмена");
    }
    
    ///Анти лоад
    if((newkeys == PLAYER_STATE_DRIVER && oldkeys == PLAYER_STATE_PASSENGER) || (newkeys == PLAYER_STATE_PASSENGER && oldkeys == PLAYER_STATE_DRIVER))
	{
	    GetPlayerName(playerid,Name,24);
	    format(StringBYVIRuS,256,"{FF0000}[ИнФо] %s был кикнут системой Р-Ц за подозрение в Cleo Loading!",Name);
	    SendClientMessageToAll(0xFF0000AA,StringBYVIRuS);
		Kick(playerid);
	    return 1;
	}

    //азот на мото
    if (PRESSED(KEY_FIRE))
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehid) == 522)
		{
			new Float:Velocity[3];
			GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
			if(Velocity[0] <1.3  && Velocity[1] < 1.3 && Velocity[0] > -1.3 && Velocity[1] > -1.3)
			{
				SetVehicleVelocity(vehid, Velocity[0]*2, Velocity[1]*2, 0.0);
				if(countpos[playerid] == 0)
				{
					Flame[playerid][0] = CreateObject(18693, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
					Flame[playerid][1] = CreateObject(18693, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
					AttachObjectToVehicle(Flame[playerid][0], vehid, 0.194999, 0.439999, 0.044999, 86.429962, 0.000000, 0.000000);
					AttachObjectToVehicle(Flame[playerid][1], vehid, -0.204999, 0.439999, 0.044999, 86.429962, 0.000000, 0.000000);
					countpos[playerid] = 1;
				}
			}
		}
	}
	
	if(newkeys & 512 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new String[2000];
	 	strins(String,"{00FF00}¤ Включить фары ¤\r\n",strlen(String));
	 	strins(String,"{FF0000}¤ Выключить фары ¤\r\n",strlen(String));
	 	strins(String,"{00FF00}¤ Открыть капот ¤\r\n",strlen(String));
	 	strins(String,"{FF0000}¤ Закрыть капот ¤\r\n",strlen(String));
	 	strins(String,"{00FF00}¤ Открыть багажник ¤\r\n",strlen(String));
		strins(String,"{FF0000}¤ Закрыть багажник ¤\r\n",strlen(String));
	 	strins(String,"{00FF00}¤ Включить неон ¤\r\n",strlen(String));
	 	strins(String,"{FF0000}¤ Выключить неон ¤\r\n",strlen(String));
	 	strins(String,"{00FF00}¤ Открыть двери ¤\r\n",strlen(String));
	 	strins(String,"{FF0000}¤ Закрыть двери ¤\r\n",strlen(String));
	 	strins(String,"{FFFFFF}~~~~~~~~~~~~~~~~~~~~~~~~~\r\n",strlen(String));
	 	strins(String,"{1CF9E8}¤ Починить ¤\r\n",strlen(String));
	 	strins(String,"{1CF9E8}¤ Починить {EFF600}[V] {1CF9E8}¤\r\n",strlen(String));
	 	strins(String,"{18D5FC}¤ Флипнуть ¤\r\n",strlen(String));
	 	strins(String,"{18D5FC}¤ Смена номера ¤\r\n",strlen(String));
	 	strins(String,"{1AACFB}¤ Смена дисков ¤\r\n",strlen(String));
	 	strins(String,"{1AACFB}¤ Сменить цвет авто ¤\r\n",strlen(String));
	 	strins(String,"{1C8AF9}¤ Мигалка на авто ¤\r\n",strlen(String));
	 	strins(String,"{1C8AF9}¤ Убрать мигалку ¤\r\n",strlen(String));
	 	strins(String,"{1D33F8}¤ Заспавнить ¤\r\n",strlen(String));
	 	strins(String,"{1D33F8}¤ GodCar ¤\r\n",strlen(String));
	 	ShowPlayerDialog(playerid,586,DIALOG_STYLE_LIST,"{00f9ff}Авто-Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
	}

    if(IsPlayerInAnyVehicle(playerid))
    {
	    new nos = GetPlayerVehicleID(playerid);
	    if(Nitro(nos) && (oldkeys & 1 || oldkeys & 4))
	    {
		    RemoveVehicleComponent(nos, 1010);
		    AddVehicleComponent(nos, 1010);
	    }
    }

    if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID)
    {
	    if(newkeys == KEY_JUMP) AdvanceSpectate(playerid);
	    else if(newkeys == KEY_SPRINT) StopSpectate(playerid);
    }
	
    if(udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
    {
		new lstring[256];
		format(lstring,256,"\n{42aaff}Добро пожаловать на {00ff00}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\n\n{42aaff}Официальная группа сервера {00ff00}t.me/e_centersamp\n\n{42aaff}Аккаунт {ff0000}'%s' {42aaff}зарегистрирован!\n\n{42aaff}Введите пароль от Вашего аккаунта:\n\n",pName(playerid));
		ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_INPUT,"{00FFD5}Пожалуйста, залогиньтесь",lstring,"Ок","");
    }

    if(newkeys == KEY_WALK)// Alt Menu
    {
    	if(PlayerInfo[playerid][Jailed] == 1) return SendClientMessage(playerid,-1,"* {FF0000}Вы не можете пользоваться Alt меню в тюрьме!");
        if(zonezapret[playerid] != 1000) return SendClientMessage(playerid, -1, "* {FF0000}В этой зоне запрещено использывать 'Alt' {ffffff}| {FF0000}Что бы выйти введите /exit!");
        new String[2048];
        strins(String,"{9B23FE}¤ Mp3 ¤\r\n",strlen(String));
        strins(String,"{7125FC}¤ Радио ¤\r\n",strlen(String));
        strins(String,"{7125FC}¤ Работы ¤\r\n",strlen(String));
        strins(String,"{2626FB}¤ Выпивка ¤\r\n",strlen(String));
        strins(String,"{2460FD}¤ Анимации ¤\r\n",strlen(String));
        strins(String,"{26ABFB}¤ Стили боя ¤\r\n",strlen(String));
        strins(String,"{26ABFB}¤ Мини-Игры ¤\r\n",strlen(String));
        strins(String,"{25FCEC}¤ ДеадМатчи ¤\r\n",strlen(String));
        strins(String,"{26FBA0}¤ Телепорты ¤\r\n",strlen(String));
        strins(String,"{26FBA0}¤ Достижения ¤\r\n",strlen(String));
        strins(String,"{26FB61}¤ FUN Объекты ¤\r\n",strlen(String));
        strins(String,"{30FC25}¤ Сменить скин ¤\r\n",strlen(String));
        strins(String,"{60FD24}¤ Собственность ¤\r\n",strlen(String));
        strins(String,"{9BFC25}¤ Стили походки ¤\r\n",strlen(String));
        strins(String,"{9BFC25}¤ Сменить погоду ¤\r\n",strlen(String));
        strins(String,"{CCFC25}¤ Покупка оружия ¤\r\n",strlen(String));
        strins(String,"{FBF526}¤ Покупка транспорта ¤\r\n",strlen(String));
        strins(String,"{FBC026}¤ Настройки аккаунта ¤\r\n",strlen(String));
        strins(String,"{FBC026}¤ Платные услуги сервера ¤\r\n",strlen(String));
        ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFF00}Меню Развлекательного Центра",String,"»]Выбор[«","»]Отмена[«");
    }
    if(gPlayerUsingLoopingAnim[playerid] == 1)
    {
        if(IsKeyJustDown(KEY_SPRINT,newkeys,oldkeys)) StopLoopingAnim(playerid);
        if(IsKeyJustDown(KEY_JUMP,newkeys,oldkeys)) StopLoopingAnim(playerid);
        if(IsKeyJustDown(KEY_FIRE,newkeys,oldkeys)) StopLoopingAnim(playerid);
    }
    return 1;
}

Nitro(vehicleid)
{
	new nos = GetVehicleModel(vehicleid);
	switch(nos)
	{
		case 444:
		return 0;
		case 581:
		return 0;
		case 586:
		return 0;
		case 481:
		return 0;
		case 509:
		return 0;
		case 446:
		return 0;
		case 556:
		return 0;
		case 443:
		return 0;
		case 452:
		return 0;
		case 453:
		return 0;
		case 454:
		return 0;
		case 472:
		return 0;
		case 473:
		return 0;
		case 484:
		return 0;
		case 493:
		return 0;
		case 595:
		return 0;
		case 462:
		return 0;
		case 463:
		return 0;
		case 468:
		return 0;
		case 521:
		return 0;
		case 522:
		return 0;
		case 417:
		return 0;
		case 425:
		return 0;
		case 447:
		return 0;
		case 487:
		return 0;
		case 488:
		return 0;
		case 497:
		return 0;
		case 501:
		return 0;
		case 548:
		return 0;
		case 563:
		return 0;
		case 406:
		return 0;
		case 520:
		return 0;
		case 539:
		return 0;
		case 553:
		return 0;
		case 557:
		return 0;
		case 573:
		return 0;
		case 460:
		return 0;
		case 593:
		return 0;
		case 464:
		return 0;
		case 476:
		return 0;
		case 511:
		return 0;
		case 512:
		return 0;
		case 577:
		return 0;
		case 592:
		return 0;
		case 471:
		return 0;
		case 448:
		return 0;
		case 461:
		return 0;
		case 523:
		return 0;
		case 510:
		return 0;
		case 430:
		return 0;
		case 465:
		return 0;
		case 469:
		return 0;
		case 513:
		return 0;
		case 519:
		return 0;
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid) {

    if(Nitro(vehicleid))
	{
      AddVehicleComponent(vehicleid, 1010);
	}

	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid)
		{
	     	TogglePlayerSpectating(x, 1);
	     	PlayerSpectateVehicle(x, vehicleid);
	     	PlayerInfo[x][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
		}
	}

	if(PlayerInfo[playerid][Fgoed] == 1)
	{
	    new Float:x5, Float:y5, Float:z5;
		SendClientMessage(playerid, COLOR_RED, "Вам запрещено ездить на транспорте");
		GetPlayerPos(playerid, x5, y5, z5);
		SetPlayerPos(playerid, x5, y5, z5);
		return 0;
	}

	if(udb_Exists(PlayerName2(playerid)) && PlayerInfo[playerid][LoggedIn] == 0)
    {
		new lstring[256];
		format(lstring,256,"\n{42aaff}Добро пожаловать на {00ff00}¤ [0.3.7] • Развлекательный • Центр • [FUN] ¤\n\n{42aaff}Официальная группа сервера {00ff00}t.me/e_centersamp\n\n{42aaff}Аккаунт {ff0000}'%s' {42aaff}зарегистрирован!\n\n{42aaff}Введите пароль от Вашего аккаунта:\n\n",pName(playerid));
		ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_INPUT,"{00FFD5}Пожалуйста, залогиньтесь",lstring,"Ок","");
 	}
    
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
    //АнтиКраш
    if(newstate == PLAYER_STATE_DRIVER)
    {
    new model = GetPlayerVehicleSeat(playerid);
    if(model != 128)
    {
    if(!model)
    {
        model = GetVehicleModel(GetPlayerVehicleID(playerid));
        if(!(400 <= model <= 611) || MaxPassengers[model - 400 >>> 3] >>> ((model - 400 & 7) << 2) & 0xF == 15) return Kick(playerid);
    }
    else return Kick(playerid);
    }
    }
    else if(newstate == PLAYER_STATE_PASSENGER)
    {
    new model = GetVehicleModel(GetPlayerVehicleID(playerid));
    if(400 <= model <= 611)
    {
    model -= 400;
    new seat = GetPlayerVehicleSeat(playerid);
    if(seat != 128)
    {
        model = (MaxPassengers[model >>> 3] >>> ((model & 7) << 2)) & 0xF;
        if(!model || model == 15) return Kick(playerid);
        else if(!(0 < seat <= model)) return Kick(playerid);
    }
    else return Kick(playerid);
    }
    }
    //АнтиКраш
   //шлем на голову
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if(IsABike(GetPlayerVehicleID(playerid)))
        {
            switch(GetPlayerSkin(playerid))
            {
                #define SPAO{%0,%1,%2,%3,%4,%5} SetPlayerAttachedObject(playerid, SLOT, 18645, 2, (%0), (%1), (%2), (%3), (%4), (%5));
                case 0, 65, 74, 149, 208, 273:  SPAO{0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000}
                case 1..6, 8, 14, 16, 22, 27, 29, 33, 41..49, 82..84, 86, 87, 119, 289: SPAO{0.070000, 0.000000, 0.000000, 88.000000, 77.000000, 0.000000}
                case 7, 10: SPAO{0.090000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
                case 9: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
                case 11..13: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
                case 15: SPAO{0.059999, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
                case 17..21: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 23..26, 28, 30..32, 34..39, 57, 58, 98, 99, 104..118, 120..131: SPAO{0.079999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 40: SPAO{0.050000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 50, 100..103, 148, 150..189, 222: SPAO{0.070000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 51..54: SPAO{0.100000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 55, 56, 63, 64, 66..73, 75, 76, 78..81, 133..143, 147, 190..207, 209..219, 221, 247..272, 274..288, 290..293: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 59..62: SPAO{0.079999, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 77: SPAO{0.059999, 0.019999, 0.000000, 87.000000, 82.000000, 0.000000}
                case 85, 88, 89: SPAO{0.070000, 0.039999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 90..97: SPAO{0.050000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 132: SPAO{0.000000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 144..146: SPAO{0.090000, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
                case 220: SPAO{0.029999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 223, 246: SPAO{0.070000, 0.050000, 0.000000, 88.000000, 82.000000, 0.000000}
                case 224..245: SPAO{0.070000, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 294: SPAO{0.070000, 0.019999, 0.000000, 91.000000, 84.000000, 0.000000}
                case 295: SPAO{0.050000, 0.019998, 0.000000, 86.000000, 82.000000, 0.000000}
                case 296..298: SPAO{0.064999, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 299: SPAO{0.064998, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
            }
        }
    }
    else
    {
        RemovePlayerAttachedObject(playerid, SLOT);
    }
	switch(newstate) {
	            case PLAYER_STATE_ONFOOT: {
			    switch(oldstate) {
				case PLAYER_STATE_DRIVER: OnPlayerExitVehicle(playerid,255);
				case PLAYER_STATE_PASSENGER: OnPlayerExitVehicle(playerid,255);
			}
		}
	}
    if(newstate == PLAYER_STATE_DRIVER)
	{
	    SendClientMessage(playerid,0x04FBFBAA,"{8b00ff}Нажмите клавишу {ff0000}\"2\" {8b00ff}для управления автомобилем {ff0000}|| {8b00ff}Нажмите клавишу{ff0000}\"R\" {8b00ff}для включения Радио");
	    GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,objective);
	    SetVehicleParamsEx(GetPlayerVehicleID(playerid),1,1,0,0,0,0,0);
	}

//дальнобойщики новые==========
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new model = GetVehicleModel(GetPlayerVehicleID(playerid));
	    if(model==515 || model==514 || model==403)
		{
	    	SendClientMessage(playerid,0x04FBFBAA,"[ИнФо]: Для того чтобы начать работать, подцепите прицеп и введите {F1FE01}/delivery");
		}
	    if(model==456)
		{
	    	SendClientMessage(playerid,0x04FBFBAA,"[ИнФо]: Для того чтобы начать работать, введите {F1FE01}/курьер");
		}
	    if(model==522)
		{
	    	SendClientMessage(playerid,0x04FBFBAA,"[ИнФо]: Это не простой мотоцикл , в нём присутствует NITRO при нажатии {F1FE01}ЛКМ");
	    }
	}
 	return 1;
}

#endif

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(PlayerInfo[playerid][Invis] == 1) EraseVehicle(vehicleid);
	if(PlayerInfo[playerid][DoorsLocked] == 1) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),playerid,false,false);

#if defined ENABLE_SPEC
	for(new x=0; x<MAX_PLAYERS; x++) {
    	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid && PlayerInfo[x][SpecType] == ADMIN_SPEC_TYPE_VEHICLE) {
        	TogglePlayerSpectating(x, 1);
	        PlayerSpectatePlayer(x, playerid);
    	    PlayerInfo[x][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
		}
	}
#endif

	return 1;
}


#if defined ENABLE_SPEC

stock StartSpectate(playerid, specplayerid)
{
	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid)
		{
     		AdvanceSpectate(x);
		}
	}
	if(IsPlayerInAnyVehicle(specplayerid))
	{
		SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
		PlayerInfo[playerid][SpecID] = specplayerid;
		PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else {
		SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, specplayerid);
		PlayerInfo[playerid][SpecID] = specplayerid;
		PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	new string[100], Float:hp, Float:ar;
	GetPlayerName(specplayerid,string,sizeof(string));
	GetPlayerHealth(specplayerid, hp);	GetPlayerArmour(specplayerid, ar);
	format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~w~%s - id:%d~n~< HAGMNTE - ZPSFATJ >~n~GN3HN:%0.1f 6POHR:%0.1f CYMMA:%d", string,specplayerid,hp,ar,GetPlayerMoney(specplayerid) );
	GameTextForPlayer(playerid,string,25000,3);
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	PlayerInfo[playerid][SpecID] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer(playerid,"~n~~n~~n~~w~CLEGKA 3AKOH4EHA",1000,3);
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID) {
	    for(new x=PlayerInfo[playerid][SpecID]+1; x<=MAX_PLAYERS; x++) {
	    	if(x == MAX_PLAYERS) { x = 0; }
	        if(IsPlayerConnected(x) && x != playerid) {
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] != INVALID_PLAYER_ID ||
					(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else {
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID) {
	    for(new x=PlayerInfo[playerid][SpecID]-1; x>=0; x--) {
	    	if(x == 0) { x = MAX_PLAYERS; }
	        if(IsPlayerConnected(x) && x != playerid) {
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] != INVALID_PLAYER_ID ||
					(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else {
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

forward PosAfterSpec(playerid);
public PosAfterSpec(playerid) {
	SetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
	SetPlayerFacingAngle(playerid,Pos[playerid][3]);
}
#endif


EraseVehicle(vehicleid)
{
    for(new players=0;players<=MAX_PLAYERS;players++)
    {
        new Float:X,Float:Y,Float:Z;
        if (IsPlayerInVehicle(players,vehicleid))
        {
            GetPlayerPos(players,X,Y,Z);
            SetPlayerPos(players,X,Y,Z+2);
            SetVehicleToRespawn(vehicleid);
        }
        SetVehicleParamsForPlayer(vehicleid,players,0,1);
    }
    SetTimerEx("VehRes",3000,0,"d",vehicleid);
    return 1;
}



forward CarSpawner(playerid,model);
public CarSpawner(playerid,model)
{
	if(IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid, red, " У вас есть автомобиль!");
 	else
	{
    	new Float:x, Float:y, Float:z, Float:angle;
	 	GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, angle);
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
	    new vehicleid=CreateVehicle(model, x, y, z, angle, -1, -1, -1);
		PutPlayerInVehicle(playerid, vehicleid, 0);
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
		ChangeVehicleColor(vehicleid,211,137);
        PlayerInfo[playerid][pCar] = vehicleid;
	}
	return 1;
}

forward CarDeleter(vehicleid);
public CarDeleter(vehicleid)
{
    for(new i=0;i<MAX_PLAYERS;i++)
	{
        new Float:X,Float:Y,Float:Z;
    	if(IsPlayerInVehicle(i, vehicleid))
		{
    	    RemovePlayerFromVehicle(i);
    	    GetPlayerPos(i,X,Y,Z);
        	SetPlayerPos(i,X,Y+3,Z);
	    }
	    SetVehicleParamsForPlayer(vehicleid,i,0,1);
	}
    SetTimerEx("VehRes",1500,0,"i",vehicleid);
}

forward VehRes(vehicleid);
public VehRes(vehicleid)
{
    DestroyVehicle(vehicleid);
}

public OnVehicleSpawn(vehicleid)
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
        if(vehicleid==PlayerInfo[i][pCar])
		{
		    CarDeleter(vehicleid);
	        PlayerInfo[i][pCar]=-1;
        }
	}
	return 1;
}

forward TuneLCar(VehicleID);
public TuneLCar(VehicleID)
{
	ChangeVehicleColor(VehicleID,0,7);
	AddVehicleComponent(VehicleID, 1010);  AddVehicleComponent(VehicleID, 1087);
}



public OnRconCommand(cmd[])
{
	if( strlen(cmd) > 50 || strlen(cmd) == 1 ) return print("Не верно введеная комманда");

	if(!strcmp(cmd, "ladmin", true))
	{
		print("Rcon Commands");
		print("info, aka, pm, asay, ann, uconfig, chat, kickall, banall, cc, ccd");
		return true;
	}

	if(!strcmp(cmd, "info", true))
	{
	    new TotalVehicles = CreateVehicle(411, 0, 0, 0, 0, 0, 0, 1000);    DestroyVehicle(TotalVehicles);
		new numo = CreateObject(1245,0,0,1000,0,0,0);	DestroyObject(numo);
		new nump = CreatePickup(371,2,0,0,1000);	DestroyPickup(nump);
		new gz = GangZoneCreate(3,3,5,5);	GangZoneDestroy(gz);

		new model[250], nummodel;
		for(new i=1;i<TotalVehicles;i++) model[GetVehicleModel(i)-400]++;
		for(new i=0;i<250;i++) { if(model[i]!=0) {	nummodel++;	}	}

		new string[256];
		print(" ===========================================================================");
		printf("                           INFO O CEPBEPE:");
		format(string,sizeof(string),"[ Players Connected: %d || Maximum Players: %d ] [Ratio %0.2f ]",ConnectedPlayers(),GetMaxPlayers(),Float:ConnectedPlayers() / Float:GetMaxPlayers() );
		printf(string);
		format(string,sizeof(string),"[ Vehicles: %d || Models %d || Players In Vehicle: %d ]",TotalVehicles-1,nummodel, InVehCount() );
		printf(string);
		format(string,sizeof(string),"[ InCar %d  ||  OnBike %d ]",InCarCount(),OnBikeCount() );
		printf(string);
		format(string,sizeof(string),"[ Objects: %d || Pickups %d  || Gangzones %d]",numo-1, nump, gz);
		printf(string);
		format(string,sizeof(string),"[ Players In Jail %d || Players Frozen %d || Muted %d ]",JailedPlayers(),FrozenPlayers(), MutedPlayers() );
	    printf(string);
	    format(string,sizeof(string),"[ Admins online %d  RCON admins online %d ]",AdminCount(), RconAdminCount() );
	    printf(string);
		print(" ===========================================================================");
		return true;
	}

	if(!strcmp(cmd, "pm", .length = 2))
	{
	    new arg_1 = argpos(cmd), arg_2 = argpos(cmd, arg_1),targetid = strval(cmd[arg_1]), message[128];

    	if ( !cmd[arg_1] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > MAX_PLAYERS || targetid < 0 || !cmd[arg_2])
	        print(" PRAVKA: \"pm <playerid> <message>\"");

	    else if ( !IsPlayerConnected(targetid) ) print("HET TAKOGO IGROKA!");
    	else
	    {
	        format(message, sizeof(message), "[RCON из консоли]Админ ЛС: %s", cmd[arg_2]);
	        SendClientMessage(targetid, COLOR_WHITE, message);
   	        printf("Rcon PM '%s' sent", cmd[arg_1] );
    	}
	    return true;
	}

	if(!strcmp(cmd, "asay", .length = 4))
	{
	    new arg_1 = argpos(cmd), message[128];

    	if ( !cmd[arg_1] || cmd[arg_1] < '0') print(" PRAVKA: \"asay  <message>\" (MessageToAdmins)");
	    else
	    {
	        format(message, sizeof(message), "[RCON из консоли]Сообщение для админов: %s", cmd[arg_1]);
	        MessageToAdmins(COLOR_WHITE, message);
	        printf("Admin Message '%s' sent", cmd[arg_1] );
    	}
	    return true;
	}

	if(!strcmp(cmd, "ann", .length = 3))
	{
	    new arg_1 = argpos(cmd), message[128];
    	if ( !cmd[arg_1] || cmd[arg_1] < '0') print(" PRAVKA: \"ann  <message>\" (GameTextForAll)");
	    else
	    {
	        format(message, sizeof(message), "[RCON из консоли]: %s", cmd[arg_1]);
	        GameTextForAll(message,3000,3);
	        printf("GameText Message '%s' sent", cmd[arg_1] );
    	}
	    return true;
	}

	if(!strcmp(cmd, "msg", .length = 3))
	{
	    new arg_1 = argpos(cmd), message[128];
    	if ( !cmd[arg_1] || cmd[arg_1] < '0') print(" PRAVKA: \"msg  <message>\" (SendClientMessageToAll)");
	    else
	    {
	        format(message, sizeof(message), "[RCON из консоли]: %s", cmd[arg_1]);
	        SendClientMessageToAll(COLOR_WHITE, message);
	        printf("MessageToAll '%s' sent", cmd[arg_1] );
    	}
	    return true;
	}
	
	if(!strcmp(cmd, "kickall", .length = 7))
	{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) && !IsPlayerAdmin(i) && PlayerInfo[i][Level] < 1)
	{
	SendClientMessage(i,green,"RCON Админ из консоли кикнул всех игроков");
	Kick(i);
	}
	}
	return true;
	}
	
	if(!strcmp(cmd, "banall", .length = 6))
	{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) && !IsPlayerAdmin(i) && PlayerInfo[i][Level] < 1)
	{
	SendClientMessage(i,green,"RCON Админ из консоли забанил всех игроков");
	BanEx(i,"RCON Console - All Banned");
	}
	}
	return true;
	}
	
	if(!strcmp(cmd, "cc", .length = 2))
	{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i))
	{
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green," ");
	SendClientMessage(i,green,"RCON Админ из консоли очистил чат");
	}
	}
	return true;
	}
	
	if(!strcmp(cmd, "ccd", .length = 3))
	{
	SendDeathMessage(5000,5000,5000);
	SendDeathMessage(5000,5000,5000);
	SendDeathMessage(5000,5000,5000);
	SendDeathMessage(5000,5000,5000);
	SendDeathMessage(5000,5000,5000);
	SendClientMessageToAll(green,"RCON Админ из консоли очистил кил чат");
	return true;
	}

	if(!strcmp(cmd, "uconfig", true))
	{
		UpdateConfig();
		print("Configuration Successfully Updated");
		return true;
	}

	if(!strcmp(cmd, "aka", .length = 3))
	{
	    new arg_1 = argpos(cmd), targetid = strval(cmd[arg_1]);

    	if ( !cmd[arg_1] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > MAX_PLAYERS || targetid < 0)
	        print(" PRAVKA: aka <playerid>");
	    else if ( !IsPlayerConnected(targetid) ) print("HET TAKOGO IGROKA!");
    	else
	    {
			new tmp3[50], playername[MAX_PLAYER_NAME];
	  		GetPlayerIp(targetid,tmp3,50);
			GetPlayerName(targetid, playername, sizeof(playername));
			printf("AKA: [%s id:%d] [%s] %s", playername, targetid, tmp3, dini_Get("ladmin/config/aka.txt",tmp3) );
    	}
	    return true;
	}

	if(!strcmp(cmd, "chat", .length = 4)) {
	for(new i = 1; i < MAX_CHAT_LINES; i++) print(Chat[i]);
    return true;
	}

	return 0;
}



public OnPlayerExitedMenu(playerid) {
    new Menu:Current = GetPlayerMenu(playerid);
    HideMenuForPlayer(Current,playerid);
    return TogglePlayerControllable(playerid,true);
}
//==================== [ Jail & Freeze ]========================================

forward Jail1(player1);
public Jail1(player1)
{
	TogglePlayerControllable(player1,false);
	new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+10,y,z+10);SetPlayerCameraLookAt(player1,x,y,z);
	SetTimerEx("Jail2",1000,0,"d",player1);
}

forward Jail2(player1);
public Jail2(player1)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+7,y,z+5); SetPlayerCameraLookAt(player1,x,y,z);
	if(GetPlayerState(player1) == PLAYER_STATE_ONFOOT) SetPlayerSpecialAction(player1,SPECIAL_ACTION_HANDSUP);
	GameTextForPlayer(player1,"~r~ZOCAGEH ADMNHOM",3000,3);
	SetTimerEx("Jail3",1000,0,"d",player1);
}

forward Jail3(player1);
public Jail3(player1)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+3,y,z); SetPlayerCameraLookAt(player1,x,y,z);
}

forward JailPlayer(player1);
public JailPlayer(player1)
{
	TogglePlayerControllable(player1,true);
	SetPlayerPos(player1,197.6661,173.8179,1003.0234);
	SetPlayerInterior(player1,3);
	SetCameraBehindPlayer(player1);
	JailTimer[player1] = SetTimerEx("JailRelease",PlayerInfo[player1][JailTime],0,"d",player1);
	PlayerInfo[player1][Jailed] = 1;
	TogglePlayerControllable(player1,false);
}

forward JailRelease(player1);
public JailRelease(player1)
{
	KillTimer( JailTimer[player1] );
	PlayerInfo[player1][JailTime] = 0;
	PlayerInfo[player1][Jailed] = 0;
	SetPlayerInterior(player1,0);
	SetPlayerPos(player1, 0.0, 0.0, 0.0);
	SpawnPlayer(player1);
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	GameTextForPlayer(player1,"~g~BSZYWEH ~n~N3 TUPJMS",3000,3);
	TogglePlayerControllable(player1,true);
    dUserSetINT(PlayerName2(player1)).("jailed",0);
}
forward UnFreezeMe(player1);
public UnFreezeMe(player1)
{
	KillTimer( FreezeTimer[player1] );
	TogglePlayerControllable(player1,true);   PlayerInfo[player1][Frozen] = 0;
	dUserSetINT(PlayerName2(player1)).("frozen",0); PlayerInfo[player1][FreezeTime] = 0;
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);	GameTextForPlayer(player1,"~g~PA3MOPOGEH",3000,3);
}

forward RepairCar(playerid);
public RepairCar(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid),Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]+0.5);
	SetVehicleZAngle(GetPlayerVehicleID(playerid), Pos[playerid][3]);
	SetCameraBehindPlayer(playerid);
}

//============================ [ Timers ]=======================================
forward PingKick();
public PingKick()
{
	if(ServerInfo[MaxPing] != 0)
	{
	    PingPos++; if(PingPos > PING_MAX_EXCEEDS) PingPos = 0;

		for(new i=0; i<MAX_PLAYERS; i++)
		{
			PlayerInfo[i][pPing][PingPos] = GetPlayerPing(i);

		    if(GetPlayerPing(i) > ServerInfo[MaxPing])
			{
				if(PlayerInfo[i][PingCount] == 0) PlayerInfo[i][PingTime] = TimeStamp();

	   			PlayerInfo[i][PingCount]++;
				if(TimeStamp() - PlayerInfo[i][PingTime] > PING_TIMELIMIT)
				{
	    			PlayerInfo[i][PingTime] = TimeStamp();
					PlayerInfo[i][PingCount] = 1;
				}
				else if(PlayerInfo[i][PingCount] >= PING_MAX_EXCEEDS)
				{
				    new Sum, Average, x, string[128];
					while (x < PING_MAX_EXCEEDS) {
						Sum += PlayerInfo[i][pPing][x];
						x++;
					}
					Average = (Sum / PING_MAX_EXCEEDS);
					format(string,sizeof(string),"{FF0000} %s кикнут с сервера. (Причина: Высокий пинг (%d) | Среднее число (%d) | Максимальное число (%d) )", PlayerName2(i), GetPlayerPing(i), Average, ServerInfo[MaxPing] );
  		    		SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string);
					Kick(i);
				}
			}
			else if(GetPlayerPing(i) < 1 && ServerInfo[AntiBot] == 1)
		    {
				PlayerInfo[i][BotPing]++;
				if(PlayerInfo[i][BotPing] >= 3) BotCheck(i);
		    }
		    else
			{
				PlayerInfo[i][BotPing] = 0;
			}
		}
	}
	
/////antichit/////
#if defined ANTI_MINIGUN
new weapp, ammoo;
for(new i = 0; i < MAX_PLAYERS; i++)
{
if(IsPlayerConnected(i))
{
GetPlayerWeaponData(i, 7, weapp, ammoo);
if(ammoo >= 301 && weapp == 38) {
new string[256];
format(string, sizeof(string), "{FF0404}[Р-Ц]: {FF8888}Игрок {FF0404}%s {FF8888}был кикнут системой Р-Ц {FF0404}[Причина : Minigun Hack]", PlayerName2(i) );
SendClientMessageToAll(COLOR_RED, string);
print(string);
//Kick(i);
}
}
}
#endif
/////antichit/////
	#if defined ANTI_MINIGUN
	new weap, ammo;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerWeaponData(i, 7, weap, ammo);
			if(ammo >= 301 && weap == 38) {
				new string[128];
				format(string,sizeof(string)," Игрок %s был замечен с миниганом (%d патронов)", PlayerName2(i), ammo);
				MessageToAdmins(COLOR_RED,string);
			}
		}
	}
	#endif
}

forward GodUpdate();
public GodUpdate()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerInfo[i][God] == 1)
		{
			SetPlayerHealthAC(i,100000);
		}
		if(IsPlayerConnected(i) && PlayerInfo[i][GodCar] == 1 && IsPlayerInAnyVehicle(i))
		{
			SetVehicleHealth(GetPlayerVehicleID(i),10000);
		}
	}
}

forward HideNameTag();
public HideNameTag()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		for (new x = 0; x < MAX_PLAYERS; x++)
		{
	    	if(PlayerInfo[i][Level] < 1 && PlayerInfo[x][Invis] == 1)
			{
		   		ShowPlayerNameTagForPlayer(i,x,0);
		   		SetPlayerMarkerForPlayer(i,x, ( GetPlayerColor(x) & 0xFFFFFF00) );
			}
			else
			{
				ShowPlayerNameTagForPlayer(i,x,1);
				SetPlayerMarkerForPlayer(i,x,GetPlayerColor(x));
			}
	    }
	}
  	return 1;
}

//==========================[ Server Info  ]====================================
forward ConnectedPlayers();
public ConnectedPlayers()
{
	new Connected;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) Connected++;
	return Connected;
}

forward JailedPlayers();
public JailedPlayers()
{
	new JailedCount;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Jailed] == 1) JailedCount++;
	return JailedCount;
}

forward FrozenPlayers();
public FrozenPlayers()
{
	new FrozenCount; for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Frozen] == 1) FrozenCount++;
	return FrozenCount;
}

forward MutedPlayers();
public MutedPlayers()
{
	new Count; for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Muted] == 1) Count++;
	return Count;
}

forward InVehCount();
public InVehCount()
{
	new InVeh; for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) InVeh++;
	return InVeh;
}

forward OnBikeCount();
public OnBikeCount()
{
	new BikeCount;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
		new LModel = GetVehicleModel(GetPlayerVehicleID(i));
		switch(LModel)
		{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586:  BikeCount++;
		}
	}
	return BikeCount;
}

forward InCarCount();
public InCarCount()
{
	new PInCarCount;
	for(new i = 0; i < MAX_PLAYERS; i++) {
		if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
			new LModel = GetVehicleModel(GetPlayerVehicleID(i));
			switch(LModel)
			{
				case 448,461,462,463,468,471,509,510,521,522,523,581,586: {}
				default: PInCarCount++;
			}
		}
	}
	return PInCarCount;
}

forward AdminCount();
public AdminCount()
{
	new LAdminCount;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][Level] >= 1)	LAdminCount++;
	return LAdminCount;
}

forward RconAdminCount();
public RconAdminCount()
{
	new rAdminCount;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && IsPlayerAdmin(i)) rAdminCount++;
	return rAdminCount;
}

//==========================[ Remote Console ]==================================
forward RestartGM();
public RestartGM()
{
	SendRconCommand("gmx");
}

forward UnloadFS();
public UnloadFS()
{
	SendRconCommand("unloadfs ladmin4");
}

forward PrintWarning(const string[]);
public PrintWarning(const string[])
{
    new str[128];
    print("\n\n>		WARNING:\n");
    format(str, sizeof(str), " The  %s  folder is missing from scriptfiles", string);
    print(str);
    print("\n Please Create This Folder And Reload the Filterscript\n\n");
}

//============================[ Bot Check ]=====================================
forward BotCheck(playerid);
public BotCheck(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(GetPlayerPing(playerid) < 1)
		{
			new string[128], ip[20];  GetPlayerIp(playerid,ip,sizeof(ip));
			format(string,sizeof(string)," БОТ: %s id:%d ip: %s пинг: %d",PlayerName2(playerid),playerid,ip,GetPlayerPing(playerid));
			SaveToFile("BotKickLog",string);
		    SaveToFile("KickLog",string);
			printf("[ADMIN] Possible bot has been detected (Kicked %s ID:%d)", PlayerName2(playerid), playerid);
			Kick(playerid);
		}
	}
}

forward PutAtPos(playerid);
public PutAtPos(playerid)
{
	if (dUserINT(PlayerName2(playerid)).("x")!=0) {
     	SetPlayerPos(playerid, float(dUserINT(PlayerName2(playerid)).("x")), float(dUserINT(PlayerName2(playerid)).("y")), float(dUserINT(PlayerName2(playerid)).("z")) );
 		SetPlayerInterior(playerid,	(dUserINT(PlayerName2(playerid)).("interior"))	);
	}
}

forward PutAtDisconectPos(playerid);
public PutAtDisconectPos(playerid)
{
	if (dUserINT(PlayerName2(playerid)).("x1")!=0) {
    	SetPlayerPos(playerid, float(dUserINT(PlayerName2(playerid)).("x1")), float(dUserINT(PlayerName2(playerid)).("y1")), float(dUserINT(PlayerName2(playerid)).("z1")) );
		SetPlayerInterior(playerid,	(dUserINT(PlayerName2(playerid)).("interior1"))	);
	}
}

MaxAmmo(playerid)
{
	new slot, weap, ammo;
	for (slot = 0; slot < 14; slot++)
	{
    	GetPlayerWeaponData(playerid, slot, weap, ammo);
		if(IsValidWeapon(weap))
		{
		   	GivePlayerWeapon(playerid, weap, 99999);
		}
	}
	return 1;
}

stock PlayerName2(playerid) {
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, sizeof(name));
  return name;
}

stock pName(playerid)
{
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, sizeof(name));
  return name;
}

stock TimeStamp()
{
	new time = GetTickCount() / 1000;
	return time;
}

stock PlayerSoundForAll(SoundID)
{
	for(new i = 0; i < MAX_PLAYERS; i++) PlayerPlaySound(i, SoundID, 0.0, 0.0, 0.0);
}

stock IsValidWeapon(weaponid)
{
    if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
    return 0;
}

stock IsValidSkin(SkinID)
{
	if((SkinID == 0)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299)) return true;
	else return false;
}

stock IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
			return i + 400;
	}
	return -1;
}

stock GetWeaponIDFromName(WeaponName[])
{
	if(strfind("molotov",WeaponName,true)!=-1) return 18;
	for(new i = 0; i <= 46; i++)
	{
		switch(i)
		{
			case 0,19,20,21,44,45: continue;
			default:
			{
				new name[32]; GetWeaponName(i,name,32);
				if(strfind(name,WeaponName,true) != -1) return i;
			}
		}
	}
	return -1;
}

stock DisableWord(const badword[], text[])
{
   	for(new i=0; i<256; i++)
   	{
		if (strfind(text[i], badword, true) == 0)
		{
			for(new a=0; a<256; a++)
			{
				if (a >= i && a < i+strlen(badword)) text[a]='*';
			}
		}
	}
}

argpos(const string[], idx = 0, sep = ' ')// (by yom)
{
    for(new i = idx, j = strlen(string); i < j; i++)
        if (string[i] == sep && string[i+1] != sep)
            return i+1;

    return -1;
}

forward MessageToAdmins(color,const string[]);
public MessageToAdmins(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][Level] >= 1) SendClientMessage(i, color, string);
	}
	return 1;
}

stock CMDMessageToAdmins(playerid,command[])
{
	if(ServerInfo[AdminCmdMsg] == 0) return 1;
	new string[128]; GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string)," [Админ] %s Использовал команду %s",string,command);
	return MessageToAdmins(blue,string);
}

SavePlayer(playerid)
{
   	dUserSetINT(PlayerName2(playerid)).("kills",PlayerInfo[playerid][Kills]);
   	dUserSetINT(PlayerName2(playerid)).("deaths",PlayerInfo[playerid][Deaths]);
    dUserSetINT(PlayerName2(playerid)).("money",PlayerInfo[playerid][Moneys]);

    new Float:x,Float:y,Float:z, interior;
   	GetPlayerPos(playerid,x,y,z);	interior = GetPlayerInterior(playerid);
    dUserSetINT(PlayerName2(playerid)).("x1",floatround(x));
	dUserSetINT(PlayerName2(playerid)).("y1",floatround(y));
	dUserSetINT(PlayerName2(playerid)).("z1",floatround(z));
    dUserSetINT(PlayerName2(playerid)).("interior1",interior);

	new weap1, ammo1, weap2, ammo2, weap3, ammo3, weap4, ammo4, weap5, ammo5, weap6, ammo6;
	GetPlayerWeaponData(playerid,2,weap1,ammo1);// hand gun
	GetPlayerWeaponData(playerid,3,weap2,ammo2);//shotgun
	GetPlayerWeaponData(playerid,4,weap3,ammo3);// SMG
	GetPlayerWeaponData(playerid,5,weap4,ammo4);// AK47 / M4
	GetPlayerWeaponData(playerid,6,weap5,ammo5);// rifle
	GetPlayerWeaponData(playerid,7,weap6,ammo6);// rocket launcher
   	dUserSetINT(PlayerName2(playerid)).("weap1",weap1); dUserSetINT(PlayerName2(playerid)).("weap1ammo",ammo1);
  	dUserSetINT(PlayerName2(playerid)).("weap2",weap2);	dUserSetINT(PlayerName2(playerid)).("weap2ammo",ammo2);
  	dUserSetINT(PlayerName2(playerid)).("weap3",weap3);	dUserSetINT(PlayerName2(playerid)).("weap3ammo",ammo3);
	dUserSetINT(PlayerName2(playerid)).("weap4",weap4); dUserSetINT(PlayerName2(playerid)).("weap4ammo",ammo4);
  	dUserSetINT(PlayerName2(playerid)).("weap5",weap5);	dUserSetINT(PlayerName2(playerid)).("weap5ammo",ammo5);
	dUserSetINT(PlayerName2(playerid)).("weap6",weap6); dUserSetINT(PlayerName2(playerid)).("weap6ammo",ammo6);

	new	Float:health;	GetPlayerHealth(playerid, Float:health);
	new	Float:armour;	GetPlayerArmour(playerid, Float:armour);
	new year,month,day;	getdate(year, month, day);
	new strdate[20];	format(strdate, sizeof(strdate), "%d.%d.%d",day,month,year);
	new file[256]; 		format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(playerid)) );

	dUserSetINT(PlayerName2(playerid)).("health",floatround(health));
    dUserSetINT(PlayerName2(playerid)).("armour",floatround(armour));
	dini_Set(file,"LastOn",strdate);
	dUserSetINT(PlayerName2(playerid)).("loggedin",0);
	dUserSetINT(PlayerName2(playerid)).("vippp",PlayerInfo[playerid][pVip]);
	dUserSetINT(PlayerName2(playerid)).("TimesOnServer",(dUserINT(PlayerName2(playerid)).("TimesOnServer"))+1);
}

#if defined DISPLAY_CONFIG
stock ConfigInConsole()
{
	print(" ________Ladmin5 Configuration ___________\n");
	print(" __________ Chat & Messages ______");
	if(ServerInfo[AntiSwear] == 0) print("  Anti Swear:              Disabled "); else print("  Anti Swear:             Enabled ");
	if(ServerInfo[AntiSpam] == 0)  print("  Anti Spam:               Disabled "); else print("  Anti Spam:              Enabled ");
	if(ServerInfo[ReadCmds] == 0)  print("  Read Cmds:               Disabled "); else print("  Read Cmds:              Enabled ");
	if(ServerInfo[ReadPMs] == 0)   print("  Read PMs:                Disabled "); else print("  Read PMs:               Enabled ");
	if(ServerInfo[ConnectMessages] == 0) print("  Connect Messages:        Disabled "); else print("  Connect Messages:       Enabled ");
  	if(ServerInfo[AdminCmdMsg] == 0) print("  Admin Cmd Messages:     Disabled ");  else print("  Admin Cmd Messages:     Enabled ");
	if(ServerInfo[ReadPMs] == 0)   print("  Anti capital letters:    Disabled \n"); else print("  Anti capital letters:   Enabled \n");
	print(" __________ Skins ________________");
	if(ServerInfo[AdminOnlySkins] == 0) print("  AdminOnlySkins:         Disabled "); else print("  AdminOnlySkins:         Enabled ");
	printf("  Admin Skin 1 is:         %d", ServerInfo[AdminSkin] );
	printf("  Admin Skin 2 is:         %d\n", ServerInfo[AdminSkin2] );
	print(" ________ Server Protection ______");
	if(ServerInfo[AntiBot] == 0) print("  Anti Bot:                Disabled "); else print("  Anti Bot:                Enabled ");
	if(ServerInfo[NameKick] == 0) print("  Bad Name Kick:           Disabled\n"); else print("  Bad Name Kick:           Enabled\n");
	print(" __________ Ping Control _________");
	if(ServerInfo[MaxPing] == 0) print("  Ping Control:            Disabled"); else print("  Ping Control:            Enabled");
	printf("  Max Ping:                %d\n", ServerInfo[MaxPing] );
	print(" __________ Players ______________");
	if(ServerInfo[GiveWeap] == 0) print("  Save/Give Weaps:         Disabled"); else print("  Save/Give Weaps:         Enabled");
	if(ServerInfo[GiveMoney] == 0) print("  Save/Give Money:         Disabled\n"); else print("  Save/Give Money:         Enabled\n");
	print(" __________ Other ________________");
	printf("  Max Admin Level:         %d", ServerInfo[MaxAdminLevel] );
	if(ServerInfo[Locked] == 0) print("  Server Locked:           No"); else print("  Server Locked:           Yes");
	if(ServerInfo[AutoLogin] == 0) print("  Auto Login:             Disabled\n"); else print("  Auto Login:              Enabled\n");
}
#endif

//=====================[ Configuration ] =======================================
stock UpdateConfig()
{
	new file[256], File:file2, string[100]; format(file,sizeof(file),"ladmin/config/Config.ini");
	ForbiddenWordCount = 0;
	BadNameCount = 0;
	BadPartNameCount = 0;

	if(!dini_Exists("ladmin/config/aka.txt")) dini_Create("ladmin/config/aka.txt");

	if(!dini_Exists(file))
	{
		dini_Create(file);
		print("\n >Configuration File Successfully Created");
	}

	if(!dini_Isset(file,"MaxPing")) dini_IntSet(file,"MaxPing",1200);
	if(!dini_Isset(file,"ReadPms")) dini_IntSet(file,"ReadPMs",1);
	if(!dini_Isset(file,"ReadCmds")) dini_IntSet(file,"ReadCmds",1);
	if(!dini_Isset(file,"MaxAdminLevel")) dini_IntSet(file,"MaxAdminLevel",5);
	if(!dini_Isset(file,"AdminOnlySkins")) dini_IntSet(file,"AdminOnlySkins",0);
	if(!dini_Isset(file,"AdminSkin")) dini_IntSet(file,"AdminSkin",217);
	if(!dini_Isset(file,"AdminSkin2")) dini_IntSet(file,"AdminSkin2",214);
	if(!dini_Isset(file,"AntiBot")) dini_IntSet(file,"AntiBot",1);
	if(!dini_Isset(file,"AntiSpam")) dini_IntSet(file,"AntiSpam",1);
	if(!dini_Isset(file,"AntiSwear")) dini_IntSet(file,"AntiSwear",1);
	if(!dini_Isset(file,"NameKick")) dini_IntSet(file,"NameKick",1);
 	if(!dini_Isset(file,"PartNameKick")) dini_IntSet(file,"PartNameKick",1);
	if(!dini_Isset(file,"NoCaps")) dini_IntSet(file,"NoCaps",0);
	if(!dini_Isset(file,"Locked")) dini_IntSet(file,"Locked",0);
	if(!dini_Isset(file,"SaveWeap")) dini_IntSet(file,"SaveWeap",1);
	if(!dini_Isset(file,"SaveMoney")) dini_IntSet(file,"SaveMoney",1);
	if(!dini_Isset(file,"ConnectMessages")) dini_IntSet(file,"ConnectMessages",1);
	if(!dini_Isset(file,"AdminCmdMessages")) dini_IntSet(file,"AdminCmdMessages",1);
	if(!dini_Isset(file,"AutoLogin")) dini_IntSet(file,"AutoLogin",1);
	if(!dini_Isset(file,"MaxMuteWarnings")) dini_IntSet(file,"MaxMuteWarnings",4);
	if(!dini_Isset(file,"MustLogin")) dini_IntSet(file,"MustLogin",0);

	if(dini_Exists(file))
	{
		ServerInfo[MaxPing] = dini_Int(file,"MaxPing");
		ServerInfo[ReadPMs] = dini_Int(file,"ReadPMs");
		ServerInfo[ReadCmds] = dini_Int(file,"ReadCmds");
		ServerInfo[MaxAdminLevel] = dini_Int(file,"MaxAdminLevel");
		ServerInfo[AdminOnlySkins] = dini_Int(file,"AdminOnlySkins");
		ServerInfo[AdminSkin] = dini_Int(file,"AdminSkin");
		ServerInfo[AdminSkin2] = dini_Int(file,"AdminSkin2");
		ServerInfo[AntiBot] = dini_Int(file,"AntiBot");
		ServerInfo[AntiSpam] = dini_Int(file,"AntiSpam");
		ServerInfo[AntiSwear] = dini_Int(file,"AntiSwear");
		ServerInfo[NameKick] = dini_Int(file,"NameKick");
		ServerInfo[PartNameKick] = dini_Int(file,"PartNameKick");
		ServerInfo[NoCaps] = dini_Int(file,"NoCaps");
		ServerInfo[Locked] = dini_Int(file,"Locked");
		ServerInfo[GiveWeap] = dini_Int(file,"SaveWeap");
		ServerInfo[GiveMoney] = dini_Int(file,"SaveMoney");
		ServerInfo[ConnectMessages] = dini_Int(file,"ConnectMessages");
		ServerInfo[AdminCmdMsg] = dini_Int(file,"AdminCmdMessages");
		ServerInfo[AutoLogin] = dini_Int(file,"AutoLogin");
		ServerInfo[MaxMuteWarnings] = dini_Int(file,"MaxMuteWarnings");
		ServerInfo[MustLogin] = dini_Int(file,"MustLogin");
		print("\n -Configuration Settings Loaded");
	}

	//forbidden names
	if((file2 = fopen("ladmin/config/ForbiddenNames.cfg",io_read)))
	{
		while(fread(file2,string))
		{
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            BadNames[BadNameCount] = string;
            BadNameCount++;
		}
		fclose(file2);	printf(" -%d Forbidden Names Loaded", BadNameCount);
	}

	//forbidden part of names
	if((file2 = fopen("ladmin/config/ForbiddenPartNames.cfg",io_read)))
	{
		while(fread(file2,string))
		{
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            BadPartNames[BadPartNameCount] = string;
            BadPartNameCount++;
		}
		fclose(file2);	printf(" -%d Forbidden Tags Loaded", BadPartNameCount);
	}

	//forbidden words
	if((file2 = fopen("ladmin/config/ForbiddenWords.cfg",io_read)))
	{
		while(fread(file2,string))
		{
		    for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
            ForbiddenWords[ForbiddenWordCount] = string;
            ForbiddenWordCount++;
		}
		fclose(file2);	printf(" -%d Forbidden Words Loaded", ForbiddenWordCount);
	}
}
//=====================[ SAVING DATA ] =========================================

forward SaveToFile(filename[],text[]);
public SaveToFile(filename[],text[])
{
	#if defined SAVE_LOGS
	new File:LAdminfile, filepath[256], string[256], year,month,day, hour,minute,second;
	getdate(year,month,day); gettime(hour,minute,second);

	format(filepath,sizeof(filepath),"ladmin/logs/%s.txt",filename);
	LAdminfile = fopen(filepath,io_append);
	format(string,sizeof(string),"[%d.%d.%d %d:%d:%d] %s\r\n",day,month,year,hour,minute,second,text);
	fwrite(LAdminfile,string);
	fclose(LAdminfile);
	#endif

	return 1;
}

//============================[ EOF ]===========================================
forward DialogReset(player1);
public DialogReset(player1)
{
KillTimer( DialogTimer[player1] );
dUserSetINT(PlayerName2(player1)).("dialoged",0);
PlayerInfo[player1][DialogTime] = 0;
PlayerInfo[player1][Dialoged] = 0;
SendClientMessage(player1,green,"Срок вашего наказания истек.(Окошечко счастья)");
ShowPlayerDialog(player1, -1, DIALOG_STYLE_MSGBOX, "Праздник!!!! ^_^", "Ты освободился от окошечка! Нажми на любую кнопку для продолжения", "Круто!!!!", "Ура!!");
}

forward UnMute(player1);
public UnMute(player1)
{
KillTimer( MutedTimer[player1] );
PlayerInfo[player1][Muted] = 0;
PlayerInfo[player1][MuteWarnings] = 0;
PlayerInfo[player1][MutedTime] = 0;
dUserSetINT(PlayerName2(player1)).("mute",0);
SendClientMessage(player1,green,"Срок вашего наказания истек.(Затычка)");
}

forward Camera(player1);
public Camera(player1)
{
new Float:x, Float:y, Float:z;
GetPlayerPos(player1,x,y,z);
SetPlayerCameraPos(player1,x,y,z);
SetPlayerCameraLookAt(player1,x,y,z+5);
PlayerInfo[player1][Cameraed] = 1;
dUserSetINT(PlayerName2(player1)).("cameraed",1);
return SetPlayerCameraPos(player1,x,y,z);
}

forward BlindSet(player1);
public BlindSet(player1)
{
PlayerInfo[player1][Blinded] = 1;
dUserSetINT(PlayerName2(player1)).("blinded",1);
TextDrawShowForPlayer(player1, white);
TextDrawShowForPlayer(player1, white123);
TextDrawShowForPlayer(player1, white123321);
}

forward UnBlind(player1);
public UnBlind(player1)
{
KillTimer( BlindTimer[player1] );
PlayerInfo[player1][Blinded] = 0;
PlayerInfo[player1][BlindTime] = 0;
dUserSetINT(PlayerName2(player1)).("blinded",0);
TextDrawHideForPlayer(player1, white);
TextDrawHideForPlayer(player1, white123);
TextDrawHideForPlayer(player1, white123321);
SendClientMessage(player1,green,"Срок вашего наказания истек.(Ослепление)");
}

forward UnCamera(player1);
public UnCamera(player1)
{
dUserSetINT(PlayerName2(player1)).("cameraed",0);
KillTimer( CameraTimer[player1] );
SetCameraBehindPlayer(player1);
PlayerInfo[player1][Cameraed] = 0;
PlayerInfo[player1][CameraTime] = 0;
SendClientMessage(player1,green,"Срок вашего наказания истек.(Камера в жопе)");
}

forward DialogSet(player1);
public DialogSet(player1)
{
dUserSetINT(PlayerName2(player1)).("dialoged",1);
PlayerInfo[player1][Dialoged] = 1;
ShowPlayerDialog(player1, 26165, DIALOG_STYLE_MSGBOX, "{FF0000}Окошко счастья", "{FF3300}Это окошечко счастья\n {FF6600}Тебе подарил его добрый админ\n  {FF9900}Нажми на 'Ок' 123456789 раз и оно закроется", "Ок", "Ок");
}

forward Fgo(player1);
public Fgo(player1)
{
dUserSetINT(PlayerName2(player1)).("fgoed",1);
PlayerInfo[player1][Fgoed] = 1;
}

forward UnFgo(player1);
public UnFgo(player1)
{
dUserSetINT(PlayerName2(player1)).("fgoed",0);
PlayerInfo[player1][Fgoed] = 0;
PlayerInfo[player1][FgoTime] = 0;
KillTimer( FgoTimer[player1] );
SendClientMessage(player1,green,"Срок вашего наказания истек.(Запрет ездить на тачке)");
}

forward KiSsStaTus(playerid);
public KiSsStaTus(playerid)
{
kissstatus[playerid] = 0;
}

stock GetDistanceBetweenPlayers(playerid, playerid2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
    return floatround(tmpdis);
}

new Males[204][1] = {
{0},{1},{2},{7},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{32},{33},{34},{35},{36},{37},{43},{44},{45},{46},{47},{48},
{49},{50},{51},{52},{56},{58},{59},{60},{61},{62},{66},{67},{68},{70},{71},{72},{73},{78},{79},{80},{81},{82},{83},{84},{94},{95},{96},{97},{98},{99},{100},
{101},{102},{103},{104},{105},{106},{107},{108},{109},{110},{111},{112},{113},{114},{115},{116},{117},{118},{120},{121},{123},{124},{125},{126},
{127},{128},{132},{133},{134},{135},{136},{137},{142},{143},{144},{146},{147},{153},{154},{155},{156},{158},{159},{160},{161},{162},{163},{164},
{165},{166},{167},{168},{170},{171},{173},{174},{175},{176},{177},{179},{180},{181},{182},{183},{184},{185},{186},{187},{188},{189},{200},{202},
{203},{204},{206},{209},{210},{217},{220},{222},{221},{223},{227},{228},{229},{230},{234},{235},{256},{239},{240},{241},{242},{247},{248},{249},
{250},{252},{253},{254},{255},{258},{259},{260},{261},{262},{264},{265},{267},{268},{269},{270},{271},{272},{273},{274},{275},{276},{277},
{278},{279},{280},{281},{282},{283},{284},{285},{286},{287},{288},{289},{290},{291},{292},{293},{294},{295},{296},{297},{299}
};

new Females[82][1] = {
{9},{10},{11},{12},{13},{31},{38},{39},{40},{41},{53},{54},{55},{57},{63},{64},{69},{75},{76},{77},{85},{87},{88},{89},{90},{91},{92},{93},{129},{130},{131},
{138},{139},{140},{141},{145},{148},{150},{151},{152},{157},{169},{172},{178},{190},{191},{192},{193},{194},{195},{196},{197},{198},{199},{201},
{205},{207},{211},{212},{213},{214},{215},{216},{218},{219},{224},{225},{226},{231},{232},{233},{237},{238},{244},{243},{245},{246},{251},{256},
{257},{263},{298}
};

stock IsPlayerFemale(playerid)
{
   new skin = GetPlayerSkin(playerid);
   for(new i = 0; i < 82; i++)
   {
     if(skin == Females[i][0])
     {
       return 1;
     }
   }
   return 0;
}

stock IsPlayerMale(playerid)
{
   new skin = GetPlayerSkin(playerid);
   for(new i = 0; i < 204; i++)
   {
     if(skin == Males[i][0])
     {
       return 1;
     }
   }
   return 0;
}

forward SetPosPlayer(playerid);
public SetPosPlayer(playerid)
{
TogglePlayerControllable(playerid,true);
return 1;
}

stock SetTogglePlayerPos(playerid)
{
if(GetPlayerState(playerid) == 1)
SetCameraBehindPlayer(playerid);
TogglePlayerControllable(playerid,false), SetTimerEx("SetPosPlayer", 1200,0,"d",playerid);
return 1;
}

/*forward Weather();
public Weather()
{
WorldWeather = RandomWeather[random(sizeof(RandomWeather))][0];
SetWeather(WorldWeather);
}
*/
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    if(PlayerInfo[playerid][LoggedIn] == 0) return SendClientMessage(playerid,red,"  {ff0000}[Ошибка] {ff3300}Вы {ff6600}должны {ff9900}быть {ffcc00} залогинены чтобы пользоваться ТАБ....");

    if (playerid != clickedplayerid && PlayerInfo[playerid][Level] == 0)
    {
        new name2[25];
        new strd[256];
        ReceiverID[playerid] = (clickedplayerid);
        GetPlayerName(ReceiverID[playerid], name2, sizeof(name2));
        format(strd,sizeof(strd),"Меню функций над игроком %s(%d) ",name2,ReceiverID[playerid]);
        ShowPlayerDialog(playerid, 270, DIALOG_STYLE_LIST, strd, "{FFBF00}¤ Отправить личное сообщение ¤\n{FFEA00}¤ Перевести на его счёт деньги ¤\n{E6FF00}¤ Пожаловаться на игрока ¤\n{B3FF00}¤ Вся информация о игроке ¤\n{44FF00}¤ Вызвать на Дуэль ¤\n{00FF51}¤ Cледить за игроком ¤","»]Выбрать[«", "»]Выход[«");
    }
	    
    if (playerid == clickedplayerid)
    {
        if(zonezapret[playerid] != 1000) return SendClientMessage(playerid, -1, "* {FF0000}В этой зоне запрещено использывать 'Tab' {ffffff}| {FF0000}Что бы выйти введите /exit!");
        ShowPlayerDialog(playerid, 6254, DIALOG_STYLE_LIST, "{DFDF02}Настройки аккаунта", "{18FEED}¤ Сменить пароль ¤\n{18EDFE}¤ Сменить никнейм ¤\n{18B9FE}¤ Сменить цвет ника ¤\n{18B9FE}¤ Управление TextDraw'ами ¤\n{1874FE}¤ Фразы сервера ¤\n{1874FE}¤ Сохранения скина ¤\n{1874FE}¤ Сохранить свою позицию¤\n{1874FE}¤ Информация обо мне ¤","»]Выбрать[«", "»]Назад[«");
    }
		
    if(PlayerInfo[playerid][Level] >= 1 && playerid != clickedplayerid)
    {
        new name2[25];
        new strd[256];
        ReceiverID[playerid] = (clickedplayerid);
        GetPlayerName(ReceiverID[playerid], name2, sizeof(name2));
        format(strd,sizeof(strd),"Меню функций над игроком %s(%d) ",name2,ReceiverID[playerid]);
        ShowPlayerDialog(playerid, 270, DIALOG_STYLE_LIST, strd, "{FFBF00}¤ Отправить личное сообщение ¤\n{FFEA00}¤ Перевести на его счёт деньги ¤\n{E6FF00}¤ Пожаловаться на игрока ¤\n{B3FF00}¤ Вся информация о игроке ¤\n{44FF00}¤ Вызвать на Дуэль ¤\n{00FF51}¤ Cледить за игроком ¤","»]Выбрать[«", "»]Выход[«");
	    }
    return 1;
}
public CheckHealth()
    {
    for(new i = 0; i < GetMaxPlayers(); i++) // Цикл, проверяем всех игроков онлайн
    {
        if(IsPlayerConnected(i))
        {
            new Float: Health; // Переменная
            GetPlayerHealth(i, Health); // Узнаем, сколько у игрока жизней
            if(PlayerHealth[i] < Health) // Если жизни у игрока больше, чем нужно (чит)
            {
            SetPlayerHealth(i, PlayerHealth[i]); // Возвращаем ему его настоящую жизни
		    }
            else
            {
            PlayerHealth[i] = Health;
            }
            }
    }
    return 1;
}

stock SetPlayerHealthAC(playerid, Float: Health)
{
    if(IsPlayerConnected(playerid))
    {
        PlayerHealth[playerid] = Health; // Принимаем массив
        SetPlayerHealth(playerid, Health); // Устанавливаем игроку жизни
    }
    return 1;
}
//==================================[Античит на броню]==========================
public CheckArmour()
{
    for(new i = 0; i < GetMaxPlayers(); i++) //
    {
        if(IsPlayerConnected(i))
        {
            new Float: Armour; //
            GetPlayerArmour(i, Armour); //
            if(PlayerArmor[i] < Armour) //
            {
            SetPlayerArmour(i, PlayerArmor[i]); //
		    }
            else
            {
            PlayerArmor[i] = Armour;
            }
            }
    }
    return 1;
}

stock SetPlayerArmorAC(playerid, Float: Armor)
{
if(IsPlayerConnected(playerid))
{
PlayerArmor[playerid] = Armor; //
SetPlayerArmour(playerid, Armor); //
}
return 1;
}

forward GivePlayerMoneyByKRYPTODEN(playerid,money);
public GivePlayerMoneyByKRYPTODEN(playerid,money)
{
  CallRemoteFunction("GivePlayerMoneyByKRYPTODENS", "id",playerid , money);
  PlayerInfo[playerid][Moneys] = PlayerInfo[playerid][Moneys] + money;
  return 1;
}

forward GetPlayerMoneyByKRYPTODEN(playerid);
public GetPlayerMoneyByKRYPTODEN(playerid)
{
  return PlayerInfo[playerid][Moneys];
}

forward MoneyByKRYPTODEN();
public MoneyByKRYPTODEN()
{
  for(new i=0;i<MAX_PLAYERS;i++)
  {
  ResetPlayerMoney(i);
  CallRemoteFunction("GivePlayerMoneyByKRYPTODENS", "id",i , PlayerInfo[i][Moneys]);
  }
  return 1;
}
///////////////////////////////////////////adminlabel//////////////////////////
public ColorUpdate(playerid)
{
    if(PlayerInfo[playerid][Level] >= 3)//samdelal
    {
	countt[playerid] = SetTimerEx("ColorUpdate",200,0,"i",playerid);
    Update3DTextLabelText(Label[playerid], Colors[numberr[playerid]], "..::Admin::..");
    SetPlayerColor(playerid,Colors[numberr[playerid]]);
    numberr[playerid]++;
    }
    if(numberr[playerid] == 25)
    {
        numberr[playerid] = 1;
    }

    if(Hentum[playerid] == 0)
    {
        KillTimer(countt[playerid]);
        Update3DTextLabelText(Label[playerid], Colors[numberr[playerid]], "");
    }
	return 1;
}

////////////////////////////adminlabel///////////////////////////
///////////////////////////church/////////////////////////////////
public TogglePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
    return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == info)
    {
        ShowPlayerDialog(playerid,189,DIALOG_STYLE_MSGBOX,"              {FFFF00}             |Услуги Церкви!!!|                     ","{FFFF00}В нашей Церкви вы можете Обвенчаться и Развестись\nНо до развода мы думаем не дойдет, ведь это большой Грех!\nЕсли вы обвенчались,то вы будете счастливы всю вашу жизнь!!!\nА если разведётесь,то будете жить в Горе до конца своих дней...","Ок","Выход");
        SetPlayerPos(playerid,369.4603,2320.0725,1890.6047);
    }
    if(pickupid == divorce)
    {
        if (!strcmp(newlywed[playerid], "0", true, 1))
        {
            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{00bdff}                       |Развод|","{ff00ff}У вас не заключен брак! ", ".:Ok:.",".:Выход:.");
            SetPlayerPos(playerid,369.6763,2328.3811,1890.6047);
        }
        else
        {
            new fn[256];
            format(fn,256,"wedding/%s.ini",newlywed[playerid]);
            for (new i = 0; i < 100; i++)
            {
                if (!strcmp(PlayerNamerr(i), newlywed[playerid], false, strlen(newlywed[playerid])))
                {
                    SetPlayerPos(playerid,369.6763,2328.3811,1890.6047);
                    ShowPlayerDialog(i, 1, DIALOG_STYLE_MSGBOX, "{00bdff}                       |Развод|","{ff00ff}вы развелись! ", ".:Ok:.",".:Выход:.");
                    dini_IntSet(fn,"newlywed",0);
                    newlywed[i] = dini_Get(fn,"newlywed");
                }
            }
            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{00bdff}                       |Развод|","{ff00ff}вы развелись! ", ".:Ok:.",".:Выход:.");
            format(fn,256,"wedding/%s.ini",PlayerNamerr(playerid));
            dini_IntSet(fn,"newlywed",0);
            newlywed[playerid] = dini_Get(fn,"newlywed");
        }
    }
    if(pickupid == church)
    {
        if(Sex[playerid] == 1)
        {
            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония!!!","{ff00ff}Это место для мужчины! ", ".:Ok:.",".:Выход:.");
            return 1;
        }
        if (!strcmp(newlywed[playerid], "0", true, 1))
        {
            ShowPlayerDialog(playerid,555,DIALOG_STYLE_INPUT,"{00bdff}Сводебная церемония!!!","{00bdff}Введите ид невесты:","Ок","Отмена");
            SetPlayerPos(playerid,372.1742,2323.3713,1889.5669);
        }
        else
        {
            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "           {FFFF00}Свадебная церемония","{ff00ff}Для начала нужно развестись! ", ".:Ok:.",".:Выход:.");
        }
    }
    if(pickupid == church_f)
    {
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("TogglePlayer",1000,0,"i",playerid);
        SetPlayerFacingAngle(playerid,89.71);
        SetPlayerPos(playerid,385.33,2324.41,1889.86);
        SetCameraBehindPlayer(playerid);
    }
    if(pickupid == church_b)
    {
        SetPlayerFacingAngle(playerid,90.0);
       	SetPlayerPos(playerid,554.1701,-1507.2631,14.5554);
        SetCameraBehindPlayer(playerid);
    }
    if(pickupid == BxodtauHa)
    {
        SetPlayerInterior(playerid,6);
        SetPlayerPos(playerid,316.524993,-167.706985,999.593750);
    }
    if(pickupid == tauHapriz)
    {
        new String[2048];
        strins(String,"{F4559D}Мы забираем твое оружие! НО мы даем тебе целый набор оружия Киллера!\n",strlen(String));
        strins(String,"\n",strlen(String));
        strins(String,"{FF0000}Обрезы - {FFF000}10000 ammo!\n",strlen(String));
        strins(String,"{FF0000}М4 - {FFF000}10000 ammo\n",strlen(String));
        strins(String,"{FF0000}Дигл - {FFF000}10000 ammo\n",strlen(String));
        strins(String,"{FF0000}Снайперка - {FFF000}10000 ammo\n",strlen(String));
        strins(String,"{FF0000}М5 - {FFF000}10000 ammo\n",strlen(String));
        strins(String,"\n",strlen(String));
        strins(String,"{F4559D}Удачной тебе охоты ;D\n",strlen(String));
        strins(String,"{F4559D}Никому не говори про этот тайник сервера! Иначе он будет перенесен в другое место!\n",strlen(String));
        ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{03ff00}Набор киллера Развлекательного Центра™", String, "»]Ехуу[«","");
        ResetPlayerWeapons(playerid);
        GivePlayerWeapon(playerid,26,10000);
        GivePlayerWeapon(playerid,31,10000);
        GivePlayerWeapon(playerid,24,10000);
        GivePlayerWeapon(playerid,34,10000);
        GivePlayerWeapon(playerid,29,10000);
    }
    if(pickupid == BblxodtauHa)
    {
        SetPlayerInterior(playerid,0);
        SetPlayerPos(playerid,1413.2535,-1700.2159,13.5395);
    }
    return 1;
}
public LoadObjects()//Церковь походу..
{
    CreateObject(9931, 369.681640625, 2339.9267578125, 1904.9915771484, 0, 0, 0);
    CreateObject(9931, 369.7060546875, 2308.431640625, 1904.9920654297, 0, 0, 0);
    CreateObject(6959, 380.3193359375, 2327.4951171875, 1888.5981445313, 0, 0, 0);
    CreateObject(6959, 378.1806640625, 2333.775390625, 1897.5466308594, 296.47705078125, 0, 0);
    CreateObject(6959, 378.0703125, 2314.8393554688, 1897.5084228516, 63.740020751953, 0, 0);
    CreateObject(6959, 363.0498046875, 2326.4736328125, 1902.5007324219, 0, 270.18676757813, 0);
    CreateObject(9931, 409.28952026367, 2325.361328125, 1903.9514160156, 0, 0, 182.88500976563);
    CreateObject(6959, 349.35693359375, 2328.1083984375, 1889.6359863281, 0, 0, 0);
    CreateObject(14394, 370.83624267578, 2320.2700195313, 1888.7946777344, 0, 0, 179.43994140625);
    CreateObject(14394, 370.92697143555, 2328.2631835938, 1888.7946777344, 0, 0, 179.43969726563);
    CreateObject(3657, 373.32641601563, 2328.6003417969, 1889.0850830078, 0, 0, 269.96997070313);
    CreateObject(3657, 375.27359008789, 2328.5871582031, 1889.0850830078, 0, 0, 269.96704101563);
    CreateObject(3657, 377.10638427734, 2328.55078125, 1889.0850830078, 0, 0, 269.96704101563);
    CreateObject(3657, 379.10192871094, 2328.5529785156, 1889.0850830078, 0, 0, 269.96704101563);
    CreateObject(3657, 381.24136352539, 2328.552734375, 1889.0850830078, 0, 0, 269.96704101563);
    CreateObject(3657, 383.30206298828, 2328.5458984375, 1889.0850830078, 0, 0, 269.96704101563);
    CreateObject(3657, 373.34204101563, 2320.0771484375, 1889.0850830078, 0, 0, 269.96154785156);
    CreateObject(3657, 375.22265625, 2320.0434570313, 1889.0850830078, 0, 0, 269.96154785156);
    CreateObject(3657, 377.12313842773, 2320.0419921875, 1889.0850830078, 0, 0, 269.96154785156);
    CreateObject(3657, 379.14074707031, 2320.0615234375, 1889.0850830078, 0, 0, 269.96154785156);
    CreateObject(3657, 381.31060791016, 2320.05859375, 1889.0850830078, 0, 0, 269.96154785156);
    CreateObject(3657, 383.32202148438, 2320.029296875, 1889.0850830078, 0, 0, 269.96154785156);
    CreateObject(8131, 359.04635620117, 2324.1560058594, 1890.9467773438, 334.75, 0, 270.44000244141);
    CreateObject(14705, 367.74389648438, 2322.6496582031, 1890.7045898438, 0, 0, 0);
    CreateObject(2208, 367.70974731445, 2325.3110351563, 1889.6047363281, 0, 0, 269.95498657227);
    CreateObject(2868, 367.74664306641, 2325.3173828125, 1890.4699707031, 0, 0, 0);
    CreateObject(2894, 367.60568237305, 2324.0219726563, 1890.4699707031, 0, 0, 269.39514160156);
    CreateObject(2869, 368.66561889648, 2331.6791992188, 1889.6047363281, 0, 0, 320.9599609375);
    CreateObject(2869, 365.07345581055, 2331.7023925781, 1889.6047363281, 0, 0, 322.20654296875);
    CreateObject(2869, 365.21087646484, 2316.7504882813, 1889.6047363281, 0, 0, 320.95458984375);
    CreateObject(2869, 368.77743530273, 2316.8020019531, 1889.6047363281, 0, 0, 320.95458984375);
    //CreateObject(2896, 367.05938720703, 2318.2067871094, 1890.2440185547, 0, 0, 0);
    CreateObject(1664, 367.76473999023, 2323.0808105469, 1890.63671875, 0, 0, 0);
    CreateObject(1667, 367.53042602539, 2323.2294921875, 1890.55859375, 0, 0, 0);
    CreateObject(2869, 375.79760742188, 2316.7111816406, 1888.5668945313, 0, 0, 320.95458984375);
    CreateObject(2869, 382.89117431641, 2316.5712890625, 1888.5668945313, 0, 0, 320.95458984375);
    CreateObject(2869, 375.69821166992, 2331.720703125, 1888.5668945313, 0, 0, 320.95458984375);
    CreateObject(2869, 382.8698425293, 2331.7434082031, 1888.5668945313, 0, 0, 320.95458984375);
    CreateObject(6959, 375.40222167969, 2326.0595703125, 1915.3721923828, 0, 0, 0);
    CreateObject(6959, 387.21533203125, 2323.322265625, 1924.6811523438, 0, 269.68676757813, 2.75);
    CreateObject(3462, 364.39996337891, 2328.1259765625, 1890.3927001953, 0, 0, 179.65002441406);
    CreateObject(3462, 364.37484741211, 2320.1662597656, 1890.3676757813, 0, 0, 180.3984375);
//конец========================================================================
    return 1;
}
/////church
///armed//
stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 33..45:
		    return weaponid+324;

		case 46:
		    return 371;
	}
	return 0;
}
////dropweapon///
public DropPlayerWeapons(playerid)
{
    new playerweapons[13][2];
    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid, x, y, z);

	for(new i=0;i<13;i++){
    	GetPlayerWeaponData(playerid, i, playerweapons[i][0], playerweapons[i][1]);
    	new model=GetWeaponModel(playerweapons[i][0]);
		new times=floatround(playerweapons[i][1]/10.0001);
		new string[256];
        format(string, sizeof(string), "%d", times);
        times=strval(string);
    	new Float:X=x+(random(3)-random(3));
    	new Float:Y=y+(random(3)-random(3));
    	if(playerweapons[i][1]!=0)
		{
		    if(times>DropLimit) times=DropLimit;
	    	for(new a=0;a<times;a++)
			{
			    if(model!=-1)
				{
					new pickupid=CreatePickup(model, 3, X, Y, z);
					SetTimerEx("DeletePickup", 10000, false, "d", pickupid);
				}
			}
		}
	}
	return 1;
}
public DeletePickup(pickupid)
{
	DestroyPickup(pickupid);
	return 1;
}

stock IsApplyAnimation(playerid, animation[])
{
    new bool:IsApply;
    if(GetPlayerAnimationIndex(playerid))
    {
        new animlib[32], animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
        if(!strcmp(animname, animation, true)) IsApply=true;
        else IsApply=false;
    }
    return IsApply;
}

//шлем на голову
stock IsABike(vehicleid)
{
    new result;
    new model = GetVehicleModel(vehicleid);
    switch(model)
    {
        case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: result = model;
        default: result = 0;
    }
    return result;
}

//азот на мото
public Counter()
{
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) && countpos[i] != 0)
		{
			countpos[i]++;
			if(countpos[i] == 4)
			{
				countpos[i] = 0;
				DestroyObject(Flame[i][0]);
				DestroyObject(Flame[i][1]);
			}
		}
	}
	return 1;
}
forward countdown();
public countdown()
{
	if(CountDown==6) GameTextForAll("~p~CTAPT...",1000,6);

	CountDown--;
	if(CountDown==0)
	{
		GameTextForAll("~g~GO~ r~!",1000,6);
		CountDown = -1;
		for(new i = 0; i < MAX_PLAYERS; i++) {
			TogglePlayerControllable(i,true);
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
		}
		return 0;
	}
	else
	{
		new text[7]; format(text,sizeof(text),"~w~%d",CountDown);
		for(new i = 0; i < MAX_PLAYERS; i++) {
			PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
			TogglePlayerControllable(i,false);
		}
	 	GameTextForAll(text,1000,6);
	}
	SetTimer("countdown",1000,0);
	return 0;
}
//duel==========================================================================
forward DuelTimer(playerid,playerid2);
public DuelTimer(playerid,playerid2)
{
    TogglePlayerControllable(playerid,1);
    SendClientMessage(playerid,-1,"{CC00DD}[Дуэль]{993344}Дуэль началась!");
    GivePlayerWeapon(playerid,24,DuelAmmo);
    TogglePlayerControllable(playerid2,1);
    SendClientMessage(playerid2,-1,"{CC00DD}[Дуэль]{993344}Дуэль началась!");
    GivePlayerWeapon(playerid2,24,DuelAmmo);

}
//полезная вешь=================================================================
forward PrintWarningstole(const string[]);
public PrintWarningstole(const string[])
{
    new str[128];
    print("\n\n>  WARNING:\n");
    format(str, sizeof(str), "My Protection Folder is missing from scriptfiles", string);
    print(str);
    print("\n > WARNING: Folder Missing From Scriptfiles\n\n");
    SendRconCommand("exit");
}
// > WARNING: Folder Missing From Scriptfiles
//новое дальнобойщики===========================================================
public OnPlayerEnterCheckpoint(playerid)
{
	if(Checkpoint[playerid] == 1)
	{
		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		{
		    SendClientMessage(playerid, COLOR_WHITE,"С чем ты приехал?! где прицеп?!  иди ищи прицеп!");
		    DisablePlayerCheckpoint(playerid);
		    return true;
		}
		DisablePlayerCheckpoint(playerid);
		TogglePlayerControllable(playerid,0);
		SendClientMessage(playerid, COLOR_WHITE,"Подождите какое-то време пока разгрузят фуру!");
		SetTimerEx("RazgruzFurui",25000,false,"i",playerid);
	}
	else if(Checkpoint[playerid] == 2)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
			if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    SendClientMessage(playerid, COLOR_WHITE,"С чем ты приехал?! где прицеп?!  иди ищи прицеп!");
			    DisablePlayerCheckpoint(playerid);
			    return true;
			}
			new zarplata = 10000 + random(10000);
			new string[64];
			format(string, sizeof(string), "Вы доставили груз и получили $%d", zarplata);
			SendClientMessage(playerid, 0xFF9900AA,string);
			GivePlayerMoney(playerid, zarplata);
			Checkpoint[playerid] = 0;
		    DisablePlayerCheckpoint(playerid);
		    SetVehicleToRespawn(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
		}
	}
	return true;
}

public RazgruzFurui(playerid)
{
	TogglePlayerControllable(playerid,1);
	SendClientMessage(playerid, COLOR_WHITE,"Разгрузка фуры завершена...");
    SendClientMessage(playerid, COLOR_WHITE,"Верните прицеп обратно где взяли, там же вам выдадут зарплату за рейс");
 	Checkpoint[playerid] = 2;
	SetPlayerCheckpoint(playerid,-0.8136,-249.4456,5.0401,8.0);
	return true;
}

forward lol(playerid);
public lol(playerid)
{
	SavePlayer(playerid);
	return 1;
}

//--защита от DeAMX-------------------------------------------------------------
forward DeAMXI (playerid);
AntiDeAMX()
{
new a[][] =
{
"Unarmed (Fist)",
"Brass K"
};
#pragma unused a
}
public DeAMXI(playerid)
{
AntiDeAMX();
return 1;
}

public OnRconLoginAttempt(ip[], password[], success)//Защита на RCON!
{
    if(!success){
        printf("Попытка взлома Rcon пароля игроком под IP: %s .Вводимый пароль: %s",ip, password);
        new Nick[MAX_PLAYER_NAME];
        new pip[16];
        for(new i=0; i<MAX_PLAYERS; i++){
        GetPlayerIp(i, pip, sizeof(pip));
        if(!strcmp(ip, pip, true)){
        GetPlayerName(i, Nick, sizeof(Nick));
        if(!strcmp(Nick, "John_Vibers", false)){
        SendClientMessage(i, 0xAA3333AA, "Вспонимай пороль!");
		return true;}
		if(!strcmp(Nick, "John_Marston", false)){
		SendClientMessage(i, 0xAA3333AA, "Вспонимай пороль!");
		return true;}
		SendClientMessage(i, 0xFFFFFFFF, "Неправильный пароль.Кик!"); 
        Kick(i);
	    return true;}
        }}else{
        new pip[16];
        new Nick[MAX_PLAYER_NAME];
        for(new i=0; i<MAX_PLAYERS; i++){
        GetPlayerIp(i, pip, sizeof(pip));
        if(!strcmp(ip, pip, true)){
        GetPlayerName(i, Nick, sizeof(Nick));
        if(!strcmp(Nick, "John_Vibers", false)){
        SendClientMessage(i, 0xAA3333AA, "* Вы успешно вошли как RCON Админ!");
       	return true;}
        if(!strcmp(Nick, "John_Marston", false)){
		SendClientMessage(i, 0xAA3333AA, "* Вы успешно вошли как RCON Админ!");
		return true;}
        SendClientMessage(i, 0xAA3333AA, "Вы не RCON администратор! Ок? уебан!");
		Kick(i);
        }}}
    return 0;}
	
forward IsVehicleOccupied(vehicleid);
public IsVehicleOccupied(vehicleid)
{
    for(new i=0;i<MAX_PLAYERS;i++)
    {
        if(IsPlayerInVehicle(i,vehicleid)) return 1;
    }
    return 0;
}
forward ANTIFLUD(playerid);
public ANTIFLUD(playerid)
{
Ceniantifloodcmd[playerid] = 0;
}
//============================================================================//
forward board( playerid, Float:oz );
//============================================================================//
public board( playerid, Float:oz ) {
	new
		Float:x
		,Float:y
		,Float:z2
		,Float:a
	;
	GetPlayerPos( playerid, x, y, z2 );
	#pragma unused z2
	SetObjectPos( sfb[ playerid ], x, y + 0.12, oz );
	GetPlayerFacingAngle( playerid, a );
	SetObjectRot( sfb[ playerid ], -90.00, 0.00, a );
	return 1;
}
public MSeconds()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(ViP[i]==1)
		{
			ViPColor = ViPColor+1;
        	if(ViPColor==15)
			{
				ViPColor=0;
			}
        	SetPlayerColor(i,ViPColors[ViPColor]);
		}
	}
	return 1;
}
