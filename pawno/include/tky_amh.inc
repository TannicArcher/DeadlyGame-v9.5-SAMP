//TKY Anti Money Hack! (GodFather Compile) by chenza

new ScriptMoney[MAX_PLAYERS];

forward TKY_GiveMoney(plyid, amounttogive);
forward TKY_ResetMoney(plyid);
forward TKY_GetMoney(plyid);

public TKY_GiveMoney(plyid, amounttogive)
{
	GivePlayerMoney(plyid, amounttogive);
	ScriptMoney[plyid] = (ScriptMoney[plyid] + amounttogive);
	return 1;
}

public TKY_ResetMoney(plyid)
{
	ResetPlayerMoney(plyid);
	ScriptMoney[plyid] = 5;
	return 1;
}

public TKY_GetMoney(plyid)
{
	ScriptMoney[plyid];
	return 1;
}