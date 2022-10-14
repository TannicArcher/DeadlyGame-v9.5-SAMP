stock strvalEx( const string[] )
{
	if( strlen( string ) >= 50 ) return 0;
	return strval(string);
}
new MissionPlayable = 0;
new noooc = 0;
new adds = 1;
new addtimer = 60000;
new Float:rx, Float:ry, Float:rz;
new carselect[15];
new objstore[128];
new cbjstore[128];
new motd[256];
new rccounter = 0;
new LSPDGate0Timer;
//new LVPDGate0;
//new LVPDGate0Timer;
//new LVPDGate1;
//new LVPDGate1Timer;
//new LVPDBarrier0;
//new LVPDBarrier0Timer;
new WarBaseGate0;
new WarBaseGate0Timer;
//=======================
new authorizeswat;
new authorizeundercover;
//======[NEW]============
new KillersGate;
new KillersGateTimer;
//new LCNGate;
//new LCNGateTimer;
new YakuzaGate;
new YakuzaGateTimer;
new SFPDGate1;
new SFPDGate1Timer;
new SFAutoBarrier;
new SFAutoBarrierTimer;
new LSPDGate0;