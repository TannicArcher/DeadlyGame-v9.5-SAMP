// Multiple Checkpoint System [ mic_checkpoint ]

/*
native CreateCheckpoint(Float:x,Float:y,Float:z,Float:size);
native DestroyCheckpoint(checkpointid);
native ShowCheckpoint(playerid,checkpointid);
native HideCheckpoint(playerid,checkpointid);
native ShowCheckpointForAll(checkpointid);
native HideCheckpointForAll(checkpointid);
*/

public CreateCheckpoint(Float:x,Float:y,Float:z,Float:size)
{
	cpid++;
	CheckpointX[cpid] = x;
	CheckpointY[cpid] = y;
	CheckpointZ[cpid] = z;
	CheckpointS[cpid] = size;
	return cpid;
}

public DestroyCheckpoint(checkpointid)
{
	CheckpointX[checkpointid] = 0.0;
	CheckpointY[checkpointid] = 0.0;
	CheckpointZ[checkpointid] = 0.0;
	CheckpointS[checkpointid] = 0.0;

}

public ShowCheckpoint(playerid,checkpointid)
{
	MapIconID++;
	IsCheckpointVisible[checkpointid][playerid] = 1;
	//SetPlayerMapIcon( playerid, MapIconID, CheckpointX[checkpointid], CheckpointY[checkpointid],CheckpointZ[checkpointid], 1, 0xAA3333AA );
}

public HideCheckpoint(playerid,checkpointid)
{
	IsCheckpointVisible[checkpointid][playerid] = 0;
}

public ShowCheckpointForAll(checkpointid)
{
 	new i;
	for(i=0;i<=MAX_PLAYERS;i++)
	{
	ShowCheckpoint(i,checkpointid);
	}
}

public HideCheckpointForAll(checkpointid)
{
 	new i;
	for(i=0;i<=MAX_PLAYERS;i++)
	{
	IsCheckpointVisible[i][checkpointid] = 0;
	}
}

Float:CheckpointToPlayerDistance(checkpointid,playerid)
{
	new Float:x1,Float:y1,Float:z1;
	new Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);
	x2 = CheckpointX[checkpointid];
	y2 = CheckpointY[checkpointid];
	z2 = CheckpointZ[checkpointid];
	//printf("checkpointid: %d playerid: %d dis: %d",checkpointid,playerid,floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2)));
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

public GetPlayerClosestCheckpoint(playerid)
{
	new i,j = -1,Float:Handle,Float:Closest = 999999.999;
	for(i=0;i<=cpid;i++)
	{
	if (IsCheckpointVisible[i][playerid] == 1){
	Handle = CheckpointToPlayerDistance(i,playerid);
	if(Handle <= Closest)
	{
	Closest = Handle;
	j = i;
	
	}
	}
	}
	return j;
}


public CheckpointHandler()
{
	new i;
	new checkpoint;
	for(i=0;i<=MAX_PLAYERS;i++)
	{
	//printf("i = %d",i);
	checkpoint = GetPlayerClosestCheckpoint(i);
	//printf("checkpoint = %d",checkpoint);
	if(CheckpointS[checkpoint] != 0)
	{
	SetPlayerCheckpoint(i,CheckpointX[checkpoint],CheckpointY[checkpoint],CheckpointZ[checkpoint],CheckpointS[checkpoint]);
	}
	}
}
