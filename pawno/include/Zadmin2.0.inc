/*=======================
 < Zuc's admin include >
============ Commands: ============
|1): IsAdminLevel(playerid,level) |
===================================
*/
#if defined _Zadmin_included
  #endinput
#endif
#define _Zadmin_included
#pragma library Zadmin
#pragma unused ret_memcpy

#include <a_samp>
#include <dudb>

forward IsAdminLevel(playerid, level);
public IsAdminLevel(playerid, level){
  new pname[24];
  new file[256],tmp,tmp2;
  GetPlayerName(playerid, pname, sizeof(pname));
  format(file, sizeof(file), "Zuc_Logs/Giocatori/%s.sav", pname);
  tmp = dini_Int(file,"adminlevel");
  tmp2 = dini_Int(file,"loggedin");
  if( (IsPlayerConnected(playerid)) && (tmp >= level) && tmp2==1)
	return true;
  else return false;}

//native IsAdminLevel(playerid, level);