stock SendFormattedClientMessage2(playerid, color, const msg[], define) //By Allan
{
	new wrap[256];
	format(wrap, sizeof(wrap), msg, define);
	SendClientMessage(playerid,color,wrap);
}
 
stock SendFormattedClientMessage(playerid, color, const msg[], define[]) //By Allan
{
	new wrap[256];
	format(wrap, sizeof(wrap), msg, define);
	SendClientMessage(playerid,color,wrap);
}
 
stock SendFormattedClientMessageToAll(color, const msg[], define[]) //By Allan
{
	new wrap[256];
	format(wrap, sizeof(wrap), msg, define);
	SendClientMessageToAll(color,wrap);
}
 
stock SendFormattedGameTextToPlayer(playerid, const msg[], time, style, define[]) //By Allan
{
	new wrap[256];
	format(wrap, sizeof(wrap), msg, define);
	GameTextForPlayer(playerid,wrap,time,style);
}
 
stock SendFormattedGameTextToAll(const msg[], time, style, define) //By Allan
{
	new wrap[256];
	format(wrap, sizeof(wrap), msg, define);
	GameTextForAll(wrap,time,style);
}
 
stock compare(const s1[],const s2[])
{
	new i;
	new bad;
	new tmp1[64];
	new tmp2[64];
 
	format(tmp1,sizeof(tmp1),"%s", s1);
	format(tmp2,sizeof(tmp2),"%s", s2);
 
	for(i=0; i<64; i++)
	{
	    if(tmp1[i] != tmp2[i])
		{
		    bad++;
		}
	}
 
	if(bad > 0)
	{
		return false;
	}
 
	return true;
}
 
stock IsPlayerInCircle(playerid,Float:x,Float:y,radius) //By Sacky
{
if(GetPlayerDistanceToPoint(playerid,x,y) < radius){
return 1;
}
return 0;
}
 
stock GetPlayerDistanceToPoint(playerid,Float:x,Float:y) //By Sacky
{
new Float:x1,Float:y1,Float:z1;
new Float:tmpdis;
GetPlayerPos(playerid,x1,y1,z1);
tmpdis = floatsqroot(floatpower(floatabs(floatsub(x,x1)),2)+floatpower(floatabs(floatsub(y,y1)),2));
return floatround(tmpdis);
}
 
stock IsPlayerInSphere(playerid,Float:x,Float:y,Float:z,radius) //By Sacky
{
if(GetPlayerDistanceToPointEx(playerid,x,y,z) < radius){
return 1;
}
return 0;
}
 
stock GetPlayerDistanceToPointEx(playerid,Float:x,Float:y,Float:z) //By Sacky
{
new Float:x1,Float:y1,Float:z1;
new Float:tmpdis;
GetPlayerPos(playerid,x1,y1,z1);
tmpdis = floatsqroot(floatpower(floatabs(floatsub(x,x1)),2)+floatpower(floatabs(floatsub(y,y1)),2)+floatpower(floatabs(floatsub(z,z1)),2));
return floatround(tmpdis);
}
 
stock id2file(const playerid)
{
	new file[128];
	new playerName[64];
 
    GetPlayerName(playerid,playerName,sizeof(playerName));
    format(file,sizeof(file),"players_%s.txt",playerName);
 
	return file;
}
 
stock isalnum(c)
{
    if ((c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A) || c == 0x20) return 1;
    return 0;
}
 
stock ClassToModel(const classid)
{
	new model;
 
	switch(classid)
	{
		case 0: { model = 280; }
		case 1: { model = 281; }
		case 2: { model = 282; }
		case 3: { model = 283; }
		case 4: { model = 284; }
		case 5: { model = 285; }
		case 6: { model = 286; }
		case 7: { model = 287; }
 
		case 8: { model = 254; }
		case 9: { model = 255; }
		case 10: { model = 256; }
		case 11: { model = 257; }
		case 12: { model = 258; }
		case 13: { model = 259; }
		case 14: { model = 260; }
		case 15: { model = 261; }
		case 16: { model = 262; }
		case 17: { model = 263; }
		case 18: { model = 264; }
		case 19: { model = 274; }
		case 20: { model = 275; }
		case 21: { model = 276; }
 
		case 22: { model = 1; }
		case 23: { model = 2; }
		case 24: { model = 290; }
		case 25: { model = 291; }
		case 26: { model = 292; }
		case 27: { model = 293; }
		case 28: { model = 294; }
		case 29: { model = 295; }
		case 30: { model = 296; }
		case 31: { model = 297; }
		case 32: { model = 298; }
		case 33: { model = 299; }
 
		case 34: { model = 277; }
		case 35: { model = 278; }
		case 36: { model = 279; }
		case 37: { model = 288; }
		case 38: { model = 47; }
		case 39: { model = 48; }
		case 40: { model = 49; }
		case 41: { model = 50; }
		case 42: { model = 51; }
		case 43: { model = 52; }
		case 44: { model = 53; }
		case 45: { model = 54; }
		case 46: { model = 55; }
		case 47: { model = 56; }
		case 48: { model = 57; }
		case 49: { model = 58; }
		case 50: { model = 59; }
		case 51: { model = 60; }
		case 52: { model = 61; }
		case 53: { model = 62; }
		case 54: { model = 63; }
		case 55: { model = 64; }
		case 56: { model = 66; }
		case 57: { model = 67; }
		case 58: { model = 68; }
		case 59: { model = 69; }
		case 60: { model = 70; }
		case 61: { model = 71; }
		case 62: { model = 72; }
		case 63: { model = 73; }
		case 64: { model = 75; }
		case 65: { model = 76; }
		case 66: { model = 78; }
		case 67: { model = 79; }
		case 68: { model = 80; }
		case 69: { model = 81; }
		case 70: { model = 82; }
		case 71: { model = 83; }
		case 72: { model = 84; }
		case 73: { model = 85; }
		case 74: { model = 87; }
		case 75: { model = 88; }
		case 76: { model = 89; }
		case 77: { model = 91; }
		case 78: { model = 92; }
		case 79: { model = 93; }
		case 80: { model = 95; }
		case 81: { model = 96; }
		case 82: { model = 97; }
		case 83: { model = 98; }
		case 84: { model = 99; }
		case 85: { model = 100; }
		case 86: { model = 101; }
		case 87: { model = 102; }
		case 88: { model = 103; }
		case 89: { model = 104; }
		case 90: { model = 105; }
		case 91: { model = 106; }
		case 92: { model = 107; }
		case 93: { model = 108; }
		case 94: { model = 109; }
		case 95: { model = 110; }
		case 96: { model = 111; }
		case 97: { model = 112; }
		case 98: { model = 113; }
		case 99: { model = 114; }
		case 100: { model = 115; }
		case 101: { model = 116; }
		case 102: { model = 117; }
		case 103: { model = 118; }
		case 104: { model = 120; }
		case 105: { model = 121; }
		case 106: { model = 122; }
		case 107: { model = 123; }
		case 108: { model = 124; }
		case 109: { model = 125; }
		case 110: { model = 126; }
		case 111: { model = 127; }
		case 112: { model = 128; }
		case 113: { model = 129; }
		case 114: { model = 131; }
		case 115: { model = 133; }
		case 116: { model = 134; }
		case 117: { model = 135; }
		case 118: { model = 136; }
		case 119: { model = 137; }
		case 120: { model = 138; }
		case 121: { model = 139; }
		case 122: { model = 140; }
		case 123: { model = 141; }
		case 124: { model = 142; }
		case 125: { model = 143; }
		case 126: { model = 144; }
		case 127: { model = 145; }
		case 128: { model = 146; }
		case 129: { model = 147; }
		case 130: { model = 148; }
		case 131: { model = 150; }
		case 132: { model = 151; }
		case 133: { model = 152; }
		case 134: { model = 153; }
		case 135: { model = 154; }
		case 136: { model = 155; }
		case 137: { model = 156; }
		case 138: { model = 157; }
		case 139: { model = 158; }
		case 140: { model = 159; }
		case 141: { model = 160; }
		case 142: { model = 161; }
		case 143: { model = 162; }
		case 144: { model = 163; }
		case 145: { model = 164; }
		case 146: { model = 165; }
		case 147: { model = 166; }
		case 148: { model = 167; }
		case 149: { model = 168; }
		case 150: { model = 169; }
		case 151: { model = 170; }
		case 152: { model = 171; }
		case 153: { model = 172; }
		case 154: { model = 173; }
		case 155: { model = 174; }
		case 156: { model = 175; }
		case 157: { model = 176; }
		case 158: { model = 177; }
		case 159: { model = 178; }
		case 160: { model = 179; }
		case 161: { model = 180; }
		case 162: { model = 181; }
		case 163: { model = 182; }
		case 164: { model = 183; }
		case 165: { model = 184; }
		case 166: { model = 185; }
		case 167: { model = 186; }
		case 168: { model = 187; }
		case 169: { model = 188; }
		case 170: { model = 189; }
		case 171: { model = 190; }
		case 172: { model = 191; }
		case 173: { model = 192; }
		case 174: { model = 193; }
		case 175: { model = 194; }
		case 176: { model = 195; }
		case 177: { model = 196; }
		case 178: { model = 197; }
		case 179: { model = 198; }
		case 180: { model = 199; }
		case 181: { model = 200; }
		case 182: { model = 201; }
		case 183: { model = 202; }
		case 184: { model = 203; }
		case 185: { model = 204; }
		case 186: { model = 205; }
		case 187: { model = 206; }
		case 188: { model = 207; }
		case 189: { model = 209; }
		case 190: { model = 210; }
		case 191: { model = 211; }
		case 192: { model = 212; }
		case 193: { model = 213; }
		case 194: { model = 214; }
		case 195: { model = 215; }
		case 196: { model = 216; }
		case 197: { model = 217; }
		case 198: { model = 218; }
		case 199: { model = 219; }
		case 200: { model = 220; }
		case 201: { model = 221; }
		case 202: { model = 222; }
		case 203: { model = 223; }
		case 204: { model = 224; }
		case 205: { model = 225; }
		case 206: { model = 226; }
		case 207: { model = 227; }
		case 208: { model = 228; }
		case 209: { model = 229; }
		case 210: { model = 230; }
		case 211: { model = 231; }
		case 212: { model = 232; }
		case 213: { model = 233; }
		case 214: { model = 234; }
		case 215: { model = 235; }
		case 216: { model = 236; }
		case 217: { model = 237; }
		case 218: { model = 238; }
		case 219: { model = 239; }
		case 220: { model = 240; }
		case 221: { model = 241; }
		case 222: { model = 242; }
		case 223: { model = 243; }
		case 224: { model = 244; }
		case 225: { model = 245; }
		case 226: { model = 246; }
		case 227: { model = 247; }
		case 228: { model = 248; }
		case 229: { model = 249; }
		case 230: { model = 250; }
		case 231: { model = 251; }
		case 232: { model = 253; }
	}
 
	return model;
}
 
stock NumEnding(const num)
{
	new output[10];
 
	switch( num )
	{
		case 1: { format(output, sizeof(output), "%dst", num); }
		case 2: { format(output, sizeof(output), "%dnd", num); }
		case 3: { format(output, sizeof(output), "%drd", num); }
		default: { format(output, sizeof(output), "%dth", num); }
	}
 
	return output;
}
