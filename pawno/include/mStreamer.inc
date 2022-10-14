#include <a_samp>
#define TIMER 1500 //обновление каждые полтура секунды (ВНИМАНИЕ: если меньше то сильно грузит процессор).
forward XmDP(p);forward XmCP(m,t,Float:x,Float:y,Float:z,vw);
forward mCPO(p,o,Float:x,Float:y,Float:z,Float:a,Float:b,Float:c); forward mDPO(pd,od); forward  RPMI(pid,iid); forward SPMI(pid, iid, Float:x, Float:y, Float:z, mt, co); forward Update(); forward IsMesto(playerid, Float:r, Float:x, Float:y, Float:z); forward mIsPlayerConnected(playerid); forward mDestroyVehicle(vehicleid); forward mGetPlayerPos(playerid, &Float:x, &Float:y, &Float:z); forward mCreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay);
native UpdateStrimer();
native mPluginCheck();
native IsEnterInMysanVehicle(vehicleid);
native AddMysanPickup(model, type, Float:X, Float:Y, Float:Z, virtualworld);
native DeleteMysanPickup(pickup);
native AddMysanVehicle(modelid,Float:x,Float:y,Float:z,Float:a,c1,c2);
native AddMysanIco(playerid, miconid, Float:s, Float:d, Float:v, markertype, color);
native AddMysanObject(playerid,m,Float:x,Float:y,Float:z,Float:a,Float:b,Float:c);
native DeleteMysanVehicle(vehicleid);
native DeleteMysanIco(playerid,icoid);
native DeleteMysanObject(playerid,objectid);
native SetSpawnDist(Float:dist);
native GetMysanVehCount();
native GetMysanIcoCount();
native GetMysanObjCount();
native GetMysanPickCount();
native GetMysanCash(playerid);
native GiveMysanCash(playerid, money);
native RemoveMysanCash(playerid);
native MysanOnline();
native abort();
native m_exit(params); //параметров не надо
native m_start(); //без параметров
native SetIact(params);
native SetOact(params);
native SetVact(params);
native SetPact(params);
public OnPlayerExitVehicle(playerid, vehicleid)return DeleteMysanVehicle(vehicleid);
public Update()return UpdateStrimer();
public mDestroyVehicle(vehicleid)return DestroyVehicle(vehicleid);
public mIsPlayerConnected(playerid)return IsPlayerConnected(playerid);
public XmCP(m,t,Float:x,Float:y,Float:z,vw)return CreatePickup(m,t,x,y,z,vw = 0);
public XmDP(p)return DestroyPickup(p);
public mCreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay)return CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay);
public mGetPlayerPos(playerid, &Float:x, &Float:y, &Float:z)return GetPlayerPos(playerid, x, y, z);
public IsMesto(playerid, Float:r, Float:x, Float:y, Float:z)return IsPlayerInRangeOfPoint(playerid, r, x, y, z);
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)return IsEnterInMysanVehicle(vehicleid);
public SPMI(pid, iid, Float:x, Float:y, Float:z, mt, co)return SetPlayerMapIcon(pid,iid,x,y,z,mt,co);
public mCPO(p,o,Float:x,Float:y,Float:z,Float:a,Float:b,Float:c)return CreatePlayerObject(p,o,x,y,z,a,b,c);
public RPMI(pid,iid)return RemovePlayerMapIcon(pid,iid);
public mDPO(pd,od)return DestroyPlayerObject(pd,od);
stock OGMI(){//добавить в мод в OnGameModeInit функцию OGMI();
SetTimer("Update",TIMER,1); //Обновление
mPluginCheck(); //Проверка на наличие инклуда
SetSpawnDist(200);  //Дистанция видимости транспорта (рекомендуется 100-200).
return 1;
}
