#include <a_samp>
#include <streamer>

#define MAX_SPIKESTRIPS 500
forward OnPlayerUpdate_B(playerid);
enum sInfo
{
	sCreated,
    Float:sX,
    Float:sY,
    Float:sZ,
    sObject,
};
new SpikeInfo[MAX_SPIKESTRIPS][sInfo];

public OnPlayerUpdate_B(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        for(new i = 0; i < sizeof(SpikeInfo); i++)
  	    {
  	        if(IsPlayerInRangeOfPoint(playerid, 3.0, SpikeInfo[i][sX], SpikeInfo[i][sY], SpikeInfo[i][sZ]))
            {
  	            if(SpikeInfo[i][sCreated] == 1)
  	            {
  	                new panels, doors, lights, tires;
  	                new carid = GetPlayerVehicleID(playerid);
		            GetVehicleDamageStatus(carid, panels, doors, lights, tires);
		            tires = encode_tires(1, 1, 1, 1);
		            UpdateVehicleDamageStatus(carid, panels, doors, lights, tires);
  	                return 0;
  	            }
  	        }
  	    }
  	}

	return 1;
}

stock CreateStrip(playerid,Float:x,Float:y,Float:z,Float:Angle)
{
	if(SpikeInfo[playerid][sCreated] == 0)
	{
		SpikeInfo[playerid][sCreated]=1;
		SpikeInfo[playerid][sX]=x;
		SpikeInfo[playerid][sY]=y;
		SpikeInfo[playerid][sZ]=z-0.7;
		SpikeInfo[playerid][sObject] = CreateDynamicObject(2899, x, y, z-0.9, 0, 0, Angle-90);
		return 1;
	}
	return 0;
}

stock DeleteAllStrip()
{
    for(new i = 0; i < sizeof(SpikeInfo); i++)
  	{
  	    if(SpikeInfo[i][sCreated] == 1)
  	    {
  	      SpikeInfo[i][sCreated]=0;
            SpikeInfo[i][sX]=0.0;
            SpikeInfo[i][sY]=0.0;
            SpikeInfo[i][sZ]=0.0;
            DestroyDynamicObject(SpikeInfo[i][sObject]);
  	    }
	}
    return 0;
}

stock DeleteClosestStrip(playerid)
{
	if(SpikeInfo[playerid][sCreated] == 1)
      {
     		SpikeInfo[playerid][sCreated]=0;
            SpikeInfo[playerid][sX]=0.0;
            SpikeInfo[playerid][sY]=0.0;
            SpikeInfo[playerid][sZ]=0.0;
            DestroyDynamicObject(SpikeInfo[playerid][sObject]);
            return 1;
	}
    return 0;
}

encode_tires(tires1, tires2, tires3, tires4) {

	return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);

}