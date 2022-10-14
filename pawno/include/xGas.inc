/*
*
*    Gasoline Inc by Pixels^
*    Inc is not for sale
*
*/
#if defined _gas_included
  #endinput
#endif

#define MAX_VEHICLE 255
#define VTYPE_CAR 1
#define VTYPE_HEAVY 2
#define VTYPE_BIKE 3
#define VTYPE_AIR 4
#define VTYPE_SEA 5

new VehicleModels[260];
new Gas[MAX_VEHICLE];
new E[MAX_VEHICLE];
new Tick[MAX_VEHICLE];
new MaxV;

stock xGas_SetGas(vehicleid,amount) {
	return Gas[vehicleid] = amount;
}
native xGas_SetGas(vehicleid,amount);

stock xGas_GetGas(vehicleid) {
	return Gas[vehicleid];
}
native xGas_GetGas(vehicleid);

stock xGas_SetAllGas(amount) {
	for(new v=0; v<MAX_VEHICLE; v++) {
		Gas[v] = amount;
	}
	return 1;
}
native xGas_SetAllGas(amount);

stock xGas_ShowGas(vehicleid) {
	new string[76];
	return format(string,sizeof(string),"%d",Gas[vehicleid]);
}
native xGas_ShowGas(vehicleid);

stock xGas_Deplete(vehicleid) {
	return Gas[vehicleid]--;
}
native xGas_Deplete(vehicleid);

stock xGas_Add(vehicleid) {
	return Gas[vehicleid]++;
}
native xGas_Fuel(vehicleid);

stock xGas_EngineOil(vehicleid,bool:PlusORMinus,amount) { // engine oil usage, 100 = god, 0  = bad
	if(PlusORMinus == true) return E[vehicleid]+=amount;
	if(PlusORMinus == false) return E[vehicleid]+=amount;
	return false
}
native xGas_EngineOil(vehicleid,bool:PlusORMinus,amount);

stock xGas_SetAllEngineOil(amount) {
	for(new v=0; v<MAX_VEHICLE; v++) return E[v] = amount;
	return false;
}
native xGas_SetAllEngineOil(amount);

stock xGas_GetEngineOil(vehicleid) {
	return E[vehicleid];
}
native xGas_GetEngineOil(vehicleid);

stock GetMaxVehicles() {
	return MaxV;
}
native GetMaxVehicles();

stock AddFueledVehicle(modelid,Float:x,Float:y,Float:z,Float:angle,color1,color2) {
	MaxV++;
	new vid = AddStaticVehicle(modelid, x,y, z, angle, color1, color2);
	VehicleModels[vid] = modelid;
	return vid;
}
native AddFueledVehicle(modelid,Float:x,Float:y,Float:z,Float:angle,color1,color2);

stock AddVehicleTick(vehicleid,amount) {
	return Tick[vehicleid]+=amount;
}
native AddVehicleTick(vehicleid,amount);

stock SubVehicleTick(vehicleid,amount) {
	return Tick[vehicleid]-=amount;
}
native SubVehicleTick(vehicleid,amount);

stock GetVehicleTick(vehicleid) {
	return Tick[vehicleid];
}
native GetVehicleTick(vehicleid);

stock SetVehicleTick(vehicleid,amount) {
	return Tick[vehicleid] = amount;
}
native SetVehicleTick(vehicleid,amount);

stock GetVehicleType(vid) {
	new type;
// ================== CARS =======
	switch(VehicleModels[vid]) {
	case
	416,   //ambulan  -  car
	445,   //admiral  -  car
	602,   //alpha  -  car
	485,   //baggage  -  car
	568,   //bandito  -  car
	429,   //banshee  -  car
	499,   //benson  -  car
	424,   //bfinject,   //car
	536,   //blade  -  car
	496,   //blistac  -  car
	504,   //bloodra  -  car
	422,   //bobcat  -  car
	609,   //boxburg  -  car
	498,   //boxville,   //car
	401,   //bravura  -  car
	575,   //broadway,   //car
	518,   //buccanee,   //car
	402,   //buffalo  -  car
	541,   //bullet  -  car
	482,   //burrito  -  car
	431,   //bus  -  car
	438,   //cabbie  -  car
	457,   //caddy  -  car
	527,   //cadrona  -  car
	483,   //camper  -  car
	524,   //cement  -  car
	415,   //cheetah  -  car
	542,   //clover  -  car
	589,   //club  -  car
	480,   //comet  -  car
	596,   //copcarla,   //car
	599,   //copcarru,   //car
	597,   //copcarsf,   //car
	598,   //copcarvg,   //car
	578,   //dft30  -  car
	486,   //dozer  -  car
	507,   //elegant  -  car
	562,   //elegy  -  car
	585,   //emperor  -  car
	427,   //enforcer,   //car
	419,   //esperant,   //car
	587,   //euros  -  car
	490,   //fbiranch,   //car
	528,   //fbitruck,   //car
	533,   //feltzer  -  car
	544,   //firela  -  car
	407,   //firetruk,   //car
	565,   //flash  -  car
	455,   //flatbed  -  car
	530,   //forklift,   //car
	526,   //fortune  -  car
	466,   //glendale,   //car
	604,   //glenshit,   //car
	492,   //greenwoo,   //car
	474,   //hermes  -  car
	434,   //hotknife,   //car
	502,   //hotrina  -  car
	503,   //hotrinb  -  car
	494,   //hotring  -  car
	579,   //huntley  -  car
	545,   //hustler  -  car
	411,   //infernus,   //car
	546,   //intruder,   //car
	559,   //jester  -  car
	508,   //journey  -  car
	571,   //kart  -  car
	400,   //landstal,   //car
	403,   //linerun  -  car
	517,   //majestic,   //car
	410,   //manana  -  car
	551,   //merit  -  car
	500,   //mesa  -  car
	418,   //moonbeam,   //car
	572,   //mower  -  car
	423,   //mrwhoop  -  car
	516,   //nebula  -  car
	582,   //newsvan  -  car
	467,   //oceanic  -  car
	404,   //peren  -  car
	514,   //petro  -  car
	603,   //phoenix  -  car
	600,   //picador  -  car
	413,   //pony  -  car
	426,   //premier  -  car
	436,   //previon  -  car
	547,   //primo  -  car
	489,   //rancher  -  car
	441,   //rcbandit,   //car
	594,   //rccam  -  car
	564,   //rctiger  -  car
	515,   //rdtrain  -  car
	479,   //regina  -  car
	534,   //remingtn,   //car
	505,   //rnchlure,   //car
	442,   //romero  -  car
	440,   //rumpo  -  car
	475,   //sabre  -  car
	543,   //sadler  -  car
	605,   //sadlshit,   //car
	495,   //sandking,   //car
	567,   //savanna  -  car
	428,   //securica,   //car
	405,   //sentinel,   //car
	535,   //slamvan  -  car
	458,   //solair  -  car
	580,   //stafford,   //car
	439,   //stallion,   //car
	561,   //stratum  -  car
	409,   //stretch  -  car
	560,   //sultan  -  car
	550,   //sunrise  -  car
	506,   //supergt  -  car
	601,   //swatvan  -  car
	574,   //sweeper  -  car
	566,   //tahoma  -  car
	549,   //tampa  -  car
	420,   //taxi  -  car
	459,   //topfun  -  car
	576,   //tornado  -  car
	583,   //tug  -  car
	451,   //turismo  -  car
	558,   //uranus  -  car
	552,   //utility  -  car
	540,   //vincent  -  car
	491,   //virgo  -  car
	412,   //voodoo  -  car
	478,   //walton  -  car
	421,   //washing  -  car
	529,   //willard  -  car
	555,   //windsor  -  car
	456,   //yankee  -  car
	554,   //yosemite,   //car
	477   //zr3	50  -  car
	: type = VTYPE_CAR;

// ================== BIKES =======
	case
	581,   //bf400  -  bike
	523,   //copbike  -  bike
	462,   //faggio  -  bike
	521,   //fcr900  -  bike
	463,   //freeway  -  bike
	522,   //nrg500  -  bike
	461,   //pcj600  -  bike
	448,   //pizzaboy,   //bike
	468,   //sanchez  -  bike
	586,   //wayfarer,   //bike
	509,   //bike  -  bmx
	481,   //bmx  -  bmx
	510,   //mtbike  -  bmx
	471   //quad  -  quad
	: type = VTYPE_BIKE;

// ================== SEA =======
	case
	472,   //coastg  -  boat
	473,   //dinghy  -  boat
	493,   //jetmax  -  boat
	595,   //launch  -  boat
	484,   //marquis  -  boat
	430,   //predator,   //boat
	453,   //reefer  -  boat
	452,   //speeder  -  boat
	446,   //squalo  -  boat
	454   //tropic  -  boat
	: type = VTYPE_SEA;

// ================== AIR =======
	case
	548,   //cargobob,   //heli
	425,   //hunter  -  heli
	417,   //leviathn,   //heli
	487,   //maverick,   //heli
	497,   //polmav  -  heli
	563,   //raindanc,   //heli
	501,   //rcgoblin,   //heli
	465,   //rcraider,   //heli
	447,   //seaspar  -  heli
	469,   //sparrow  -  heli
	488,   //vcnmav  -  heli
	592,   //androm  -  plane
	577,   //at	400  -  plane
	511,   //beagle  -  plane
	512,   //cropdust,   //plane
	593,   //dodo  -  plane
	520,   //hydra  -  plane
	553,   //nevada  -  plane
	464,   //rcbaron  -  plane
	476,   //rustler  -  plane
	519,   //shamal  -  plane
	460,   //skimmer  -  plane
	513,   //stunt  -  plane
	539   //vortex  -  plane
	: type = VTYPE_AIR;

// ================== HEAVY =======
	case
	588,   //hotdog  -  car
	437,   //coach  -  car
	532,   //combine  -  car
	433,   //barracks,   //car
	414,   //mule  -  car
	443,   //packer  -  car
	470,   //patriot  -  car
	432,   //rhino  -  car
	525,   //towtruck,   //car
	531,   //tractor  -  car
	408,   //trash  -  car
	406,   //dumper  -  mtruck
	573,   //duneride,   //mtruck
	444,   //monster  -  mtruck
	556,   //monstera,   //mtruck
	557,   //monsterb,   //mtruck
	435,   //artict1  -  trailer
	450,   //artict2  -  trailer
	591,   //artict3  -  trailer
	606,   //bagboxa  -  trailer
	607,   //bagboxb  -  trailer
	610,   //farmtr1  -  trailer
	584,   //petrotr  -  trailer
	608,   //tugstair,   //trailer
	611,   //utiltr1  -  trailer
	590,   //freibox  -  train
	569,   //freiflat,   //train
	537,   //freight  -  train
	538,   //streak  -  train
	570,   //streakc  -  train
	449   //tram  -  train
	: type = VTYPE_HEAVY;
	}
	return type;
}