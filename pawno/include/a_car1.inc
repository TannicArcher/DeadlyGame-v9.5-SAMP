/*
 *	Vehicle Include's - by KevinSoftware
 *	Relase: 2-2-2008 18:45
 *	Mail: Kevinsoftware@live.nl
 *
 *	DONT SAY THIS IS YOUR WORK
 */

#if defined _a_car_included
  #endinput
#endif

#define MAX_VEHICLE_ID 212

new VehiclesName[MAX_VEHICLE_ID][256] ={
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Pereniel",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "Mr Whoopee",
   "BF Injection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer",
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RC Bandit",
   "Romero",
   "Packer",
   "Monster Truck",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer",
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "Berkley's RC Van",
   "Skimmer",
   "PCJ-600",
   "Faggio",
   "Freeway",
   "RC Baron",
   "RC Raider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR-350",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "News Chopper",
   "Rancher",
   "FBI Rancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "Blista Compact",
   "Police Maverick",
   "Boxville",
   "Benson",
   "Mesa",
   "RC Goblin",
   "Hotring Racer",
   "Hotring Racer",
   "Bloodring Banger",
   "Rancher",
   "Super GT",
   "Elegant",
   "Journey",
   "Bike",
   "Mountain Bike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker",
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR-900",
   "NRG-500",
   "HPV1000",
   "Cement Truck",
   "Tow Truck",
   "Fortune",
   "Cadrona",
   "FBI Truck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck",
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "Monster Truck",
   "Monster Truck",
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RC Tiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight",
   "Trailer",
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT-400",
   "DFT-30",
   "Huntley",
   "Stafford",
   "BF-400",
   "Newsvan",
   "Tug",
   "Trailer",
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer",
   "Trailer",
   "Andromada",
   "Dodo",
   "RC Cam",
   "Launch",
   "Police Car (LSPD)",
   "Police Car (SFPD)",
   "Police Car (LVPD)",
   "Police Ranger",
   "Picador",
   "S.W.A.T. Van",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Luggage Trailer",
   "Luggage Trailer",
   "Stair Trailer",
   "Boxville",
   "Farm Plow",
   "Utility Trailer"
};

stock GetVehicleName(modelid)
{
	new na_str[256];
	format(na_str,sizeof(na_str),"%s",VehiclesName[modelid]-400);
	return na_str;
}

stock SetVehicleName(modelid,carname[])
{
	VehiclesName[modelid]-400 = carname;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////
stock DiveVehicle(vehicleid,Float:height)
{
	new Float:pos[3];
	GetVehiclePos(vehicleid,pos[0],pos[1],pos[2]);
	SetVehiclePos(vehicleid,pos[0],pos[1],pos[2]+height);
}

stock ShowVehicleNameForPlayer(playerid,modelid,color)
{
	new str[256];
	if(color==1){ format(str,sizeof(str),"~r~~h~%s",GetVehicleName(modelid)); }
	if(color==2){ format(str,sizeof(str),"~g~~h~%s",GetVehicleName(modelid)); }
	if(color==3){ format(str,sizeof(str),"~b~~h~%s",GetVehicleName(modelid)); }
	if(color==4){ format(str,sizeof(str),"~w~~h~%s",GetVehicleName(modelid)); }
	if(color==5){ format(str,sizeof(str),"~y~~h~%s",GetVehicleName(modelid)); }
	if(color==6){ format(str,sizeof(str),"~p~~h~%s",GetVehicleName(modelid)); }
	if(color==7){ format(str,sizeof(str),"~r~%s",GetVehicleName(modelid)); }
	if(color==8){ format(str,sizeof(str),"~g~%s",GetVehicleName(modelid)); }
	if(color==9){ format(str,sizeof(str),"~b~%s",GetVehicleName(modelid)); }
	if(color==10){ format(str,sizeof(str),"~w~%s",GetVehicleName(modelid)); }
	if(color==11){ format(str,sizeof(str),"~y~%s",GetVehicleName(modelid)); }
	if(color==12){ format(str,sizeof(str),"~p~%s",GetVehicleName(modelid)); }
	if(color>12||color<1){ format(str,sizeof(str),"~w~%s",GetVehicleName(modelid)); }
	GameTextForPlayer(playerid,str,6000,1);
}

stock SetVehicleParameters(vehicleid,locked,objective,color1,color2,Float:health)
{
    for(new i=0; i<MAX_PLAYERS; i++){
        SetVehicleParamsForPlayer(vehicleid,i,objective,locked);
    }
    ChangeVehicleColor(vehicleid,color1,color2);
    SetVehicleHealth(vehicleid,health);
}

stock ExplodeVehicle(vehicleid)
{
	new Float:pos[3];
	GetVehiclePos(vehicleid,pos[0],pos[1],pos[2]);
	CreateExplosion(pos[0],pos[1],pos[2],11,100);
	SetVehicleHealth(vehicleid,0);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
stock FlipCar(vehicleid)
{
	new Float:Zas;
	GetVehicleZAngle(vehicleid,Zas);
	SetVehicleZAngle(vehicleid,Zas+0.0001);
}

stock HealCar(vehicleid)
{
	SetVehicleHealth(vehicleid,1000);
}

stock ClearCar(vehicleid)
{
	new Float:pos[3];
	new V_ID;
	for(new i=0; i<MAX_PLAYERS; i++){
	    V_ID = GetPlayerVehicleID(i);
	    if(V_ID==vehicleid){
	        GetPlayerPos(i,pos[0],pos[1],pos[2]);
	        SetPlayerPos(i,pos[0],pos[1],pos[2]);
	    }
	}
}