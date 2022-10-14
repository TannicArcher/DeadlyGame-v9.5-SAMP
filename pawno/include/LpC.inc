
/*
                                     Copyrightœ ® LuxurioN™
________________________________________________________________________________________________
  _                                                          _               _ _       _
 | |                                                        |_|             |   \     | |
 | |                       _       _               _ _ _     _    _ _ _ _   | |\ \    | |
 | |           | |   | |  | |     | |  | |   | |  |  _  \   | |  |  _ _  |  | | \ \   | |
 | |           | |   | |   | |   | |   | |   | |  | |_| /   | |  | |   | |  | |  \ \  | |
 | |           | |   | |    | | | |    | |   | |  |  _ \    | |  | |   | |  | |   \ \ | |
 | |_ _ _ _ _  | |_ _| |   | |   | |   | |_ _| |  | | \ \   | |  | |_ _| |  | |    \ \| |
 |_ _ _ _ _ _| |_ _ _ _|  |_|     |_|  |_ _ _ _|  |_|  \_|  |_|  |_ _ _ _|  |_|     \_ _|

________________________________________________________________________________________________
						  	 .:: Do not remove the Credits ::.


                            _________________________________
                           |                                 |
                           |      [INC]LuX LpC v1.1          |
                           |_________________________________|



------------------------------------------------------------------------------------------------------
 native AddCarPerName(id,const name[],vehtype,Float:X,Float:Y,Float:Z,Float:Rotation,color1,color2);
------------------------------------------------------------------------------------------------------
*/

#include <a_samp>

/*
 _______________________________________________________________________________________
|                                                                                       |
| -> AddCarPerName Configuration <-                                                     |
|                                                                                       |
| LpC_Msg: Warning message for when the player enters the private car of another player |
| LpC_MsgC: Color of 'LpC_Msg' Message                                                  |
|_______________________________________________________________________________________|
*/

#define LpC_Msg    "Private Vehicle! Only %s use this Vehicle!"
#define Lpc_MsgC    0xAA3333AA

//______________________________________________________________________________


new LpCount=0;
new Message;

#define MAX_LPC 700

/*
 ______________________________________________________________________________
|                                                                              |
| -> AddCarPerName <-                                                          |
|______________________________________________________________________________|

*/
enum VehicleName {
	Float:aX,
	Float:aY,
	Float:aZ,
	Float:aRotation,
	aColor1,
	aColor2,
	aModel,
	aCName[128],
	aName[24]
}
new VpName[MAX_LPC][VehicleName];

/*
 ______________________________________________________________________________
|                                                                              |
| -> AddCarPerName <-                                                          |
|                                                                              |
| Functions: Defines a private vehicle. Only the player                        |
|  of the specific name can use                                                |
|______________________________________________________________________________|

*/
stock AddCarPerName(id,const name[],vehtype,Float:X,Float:Y,Float:Z,Float:Rotation,color1,color2)
    {
	VpName[id][aX]         = X;
	VpName[id][aY]         = Y;
	VpName[id][aZ]         = Z;
	VpName[id][aModel]     = vehtype;
	VpName[id][aRotation]  = Rotation;
	VpName[id][aColor1]    = color1;
	VpName[id][aColor2]    = color2;
	
	format(VpName[id][aName],24,"%s",name);
	format(VpName[id][aCName],128,"%s",name);
	
    VpName[id][aCName] = CreateVehicle(VpName[id][aModel],VpName[id][aX],VpName[id][aY],VpName[id][aZ],VpName[id][aRotation],VpName[id][aColor1],VpName[id][aColor2]);
	return LpCount += 1;
}
stock LpC_OnGameModeInit()
{
SetTimer("VerifyCar",1000,1);
Message = 1;
}
/*
 ______________________________________________________________________________
|                                                                              |
| -> AddCarPerName <-                                                          |
|                                                                              |
| Verification Timer                                                           |
|______________________________________________________________________________|

*/

forward VerifyCar(playerid, newstate, oldstate,type);
public VerifyCar(playerid, newstate, oldstate,type)
{
   for(new lpc;lpc<MAX_LPC;lpc++){
   new lpName[24];
   new string[256];
   GetPlayerName(playerid, lpName, sizeof(lpName));
   if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
   {
   if(GetPlayerVehicleID(playerid) == VpName[lpc][aCName])
   {
   if(strcmp(lpName,VpName[lpc][aName],true)){
   new Float:PX;
   new Float:PY;
   new Float:PZ;
   new Float:A;
   GetPlayerPos(playerid, PX, PY, PZ);
   GetPlayerFacingAngle(playerid, A);
   SetPlayerPos(playerid, PX, PY+4, PZ);
   SetPlayerFacingAngle(playerid, A);
   if(Message == 1)
   {
   format(string, sizeof(string),LpC_Msg, VpName[lpc][aName]);
   SendClientMessage(playerid, Lpc_MsgC, string);
   Message = 0;
   SetTimer("DesblockMsg",5000,0);
   }
   }
   }
   }
   }
   return 1;
}
forward DesblockMsg(playerid);
public DesblockMsg(playerid)
{
if(Message == 0)
{
Message = 1;
}
return 1;
}
