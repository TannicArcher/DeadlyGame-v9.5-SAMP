/********************************************
 * OnPlayerShootPlayer! V4.5                *
 * Credits: wups,                           *
 * Double-O-Seven for his HS functions      *
 ********************************************/
 
// include
#include <a_samp>
#tryinclude <foreach>
 
// defines
#if defined OPSP
        #endinput
#endif
#define OPSP
 
#if !defined foreach
        #define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
        #define __SSCANF_FOREACH__
#endif
#if defined FILTERSCRIPT
        #error "OnPlayerShootPlayer ERROR: You must include it in your game mode, not in your filterscript!"
#endif
#if !defined PRESSED
        #define PRESSED(%0) \
                (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#endif
#if !defined RELEASED
        #define RELEASED(%0) \
                (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#endif
// variables
static  Float:phealth[MAX_PLAYERS],
                bool:Shooting[MAX_PLAYERS],
                Released[MAX_PLAYERS],
                bool:RL_OPUP,
                bool:RL_OPSC,
                bool:RL_OPKSC,
                bool:RL_OPC;
// forwards
forward OnPlayerShootPlayer(shooter,target,Float:damage);
 
public OnPlayerUpdate(playerid)
{
        static  Float:HP,
                        Float:Armour;
        GetPlayerHealth(playerid,HP);
        GetPlayerArmour(playerid,Armour);
        if(HP+Armour < phealth[playerid])
        {
                static Float:VALUE[14];
                GetPlayerPos(playerid, VALUE[0], VALUE[1], VALUE[2]);
                GetPlayerCameraFrontVector(playerid, VALUE[7], VALUE[8], VALUE[9]);
                GetPlayerCameraPos(playerid, VALUE[10], VALUE[11], VALUE[12]);
                foreach(Player,i)
                {
                        if(i != playerid && IsPlayerInRangeOfPoint(i,200.0,VALUE[0],VALUE[1],VALUE[2]))
                        {
                            GetPlayerPos(i, VALUE[3], VALUE[4], VALUE[5]);
                                GetDistanceFromPointToLine(VALUE[6], VALUE[7], VALUE[8], VALUE[9], VALUE[10], VALUE[11], VALUE[12], VALUE[3], VALUE[4], VALUE[5]);
                                if(VALUE[6] < 2.5)
                                {
                                        if(Shooting[i] || (GetTickCount()-1000 < Released[i]))
                                        {
                                                CallLocalFunction("OnPlayerShootPlayer","iif",i,playerid,(phealth[playerid]-HP-Armour));
                                                break;
                                        }
                                }
                        }
                }
        }
        phealth[playerid]=HP+Armour;
        return (RL_OPUP)?CallLocalFunction("RL_OnPlayerUpdate","i",playerid):1;
}
 
stock crossp(Float:v1x, Float:v1y, Float:v1z, Float:v2x, Float:v2y, Float:v2z, &Float:output)
{
        new
                Float:c1 = (v1y * v2z) - (v1z * v2y),
                Float:c2 = (v1z * v2x) - (v1x * v2z),
                Float:c3 = (v1x * v2y) - (v1y * v2x);
        output = floatsqroot ((c1 * c1) + (c2 * c2) + (c3 * c3));
        return 0;
}
 
stock GetDistanceFromPointToLine(&Float:distance, Float:line_vector_x, Float:line_vector_y, Float:line_vector_z, Float:line_x, Float:line_y, Float:line_z, Float:point_x, Float:point_y, Float:point_z)
{
        //A line is defined by a point (which is on the line (line_x/y/z)) and a vector which defines the direction (line_vector_x/y/z).
        static Float:output;
        crossp(line_vector_x, line_vector_y, line_vector_z, point_x - line_x, point_y - line_y, point_z - line_z, output);//Cross product of 2 vectors.
        distance = output / floatsqroot ((line_vector_x * line_vector_x) + (line_vector_y * line_vector_y) + (line_vector_z * line_vector_z));
        return 0;
}
 
stock SetPlayerHealthEx(playerid, Float:health)
{
        new Float:armour; 
        GetPlayerArmour(playerid,armour);
        phealth[playerid]=health+armour;
        return SetPlayerHealth(playerid, health);
}
 
#define SetPlayerHealth SetPlayerHealthEx
 
#if defined _ALS_OnPlayerUpdate
        #undef OnPlayerUpdate
#else
        #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate RL_OnPlayerUpdate
forward RL_OnPlayerUpdate(playerid);
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
        if(PRESSED(KEY_FIRE)) Shooting[playerid]=true;
        else if(RELEASED(KEY_FIRE))
        {
                Shooting[playerid]=false;
                Released[playerid]=GetTickCount();
        }
        return (RL_OPKSC)?CallLocalFunction("RL_OnPlayerKeyStateChange","iii",playerid,newkeys,oldkeys):1;
}
#if defined _ALS_OnPlayerKeyStateChange
        #undef OnPlayerKeyStateChange
#else
        #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange RL_OnPlayerKeyStateChange
forward RL_OnPlayerKeyStateChange(playerid,newkeys,oldkeys);
 
public OnPlayerStateChange(playerid, newstate, oldstate)
{
        Shooting[playerid]=false;
        Released[playerid]=GetTickCount();
        return (RL_OPSC)?CallLocalFunction("RL_OnPlayerStateChange","iii",playerid,newstate,oldstate):1;
}
#if defined _ALS_OnPlayerStateChange
        #undef OnPlayerStateChange
#else
        #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange RL_OnPlayerStateChange
forward RL_OnPlayerStateChange(playerid,newstate, oldstate);
public OnPlayerConnect(playerid)
{
        Shooting[playerid]=false;
        Released[playerid]=0;
        return (RL_OPC)?CallLocalFunction("RL_OnPlayerConnect","i",playerid):1;
}
#if defined _ALS_OnPlayerConnect
        #undef OnPlayerConnect
#else
        #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect RL_OnPlayerConnect
forward RL_OnPlayerConnect(playerid);
public OnGameModeInit()
{
        RL_OPUP = (funcidx("RL_OnPlayerUpdate") != -1);
        RL_OPSC = (funcidx("RL_OnPlayerStateChange") != -1);
        RL_OPKSC = (funcidx("RL_OnPlayerKeyStateChange") != -1);
        RL_OPC = (funcidx("RL_OnPlayerConnect") != -1);
        return (funcidx("RL_OnGameModeInit") != -1)?CallLocalFunction("RL_OnGameModeInit",""):1;
}
#if defined _ALS_OnGameModeInit
        #undef OnGameModeInit
#else
        #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit RL_OnGameModeInit
forward RL_OnGameModeInit();