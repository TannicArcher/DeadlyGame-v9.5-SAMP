#if defined _xcolours_included
  #endinput
#endif

#define _xcolours_included
#pragma library xcolours

#if !defined _samp_included
  #include <a_samp>
#endif

public RandomColour() //By Boylett
{
	new string[256];
	format(string, sizeof(string), "%d%d%d%d%d%d%d%d", random(10), random(10), random(10), random(10), random(10), random(10), random(10), random(10));
	return strval(string);
}

stock ToggleBlipVisibilty(playerid, bool:visible) //By Simon
{
    new tmpcolor = GetPlayerColor(playerid);
	if(visible) tmpcolor &= 0xFFFFFF00;
	else tmpcolor |= 0x000000FF;
	return SetPlayerColor(playerid, tmpcolor);
}

public SetPlayerRandomColour(playerid) // By Boylett
{
	SetPlayerColor(playerid, RandomColour());
	ToggleBlipVisibilty(playerid, true);
	return true;
}

public SetPlayersHashedColour(playerid) //Modified from Dracoblue's udb_hash
{
	new Playernamecolour[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Playernamecolour, sizeof(Playernamecolour));
	new length=strlen(Playernamecolour);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + Playernamecolour[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return SetPlayerColor(playerid, (s2 << 16) + s1);
}

//Colours by Dealman1
#define COLOUR_GREY 0xAFAFAFAA
#define COLOUR_GREEN 0x33AA33AA
#define COLOUR_RED 0xAA3333AA
#define COLOUR_YELLOW 0xFFFF00AA
#define COLOUR_WHITE 0xFFFFFFAA
#define COLOUR_BLUE 0x0000BBAA
#define COLOUR_LIGHTBLUE 0x33CCFFAA
#define COLOUR_ORANGE 0xFF9900AA
#define COLOUR_RED 0xAA3333AA
#define COLOUR_LIME 0x10F441AA
#define COLOUR_MAGENTA 0xFF00FFFF
#define COLOUR_NAVY 0x000080AA
#define COLOUR_AQUA 0xF0F8FFAA
#define COLOUR_CRIMSON 0xDC143CAA
#define COLOUR_FLBLUE 0x6495EDAA
#define COLOUR_BISQUE 0xFFE4C4AA
#define COLOUR_BLACK 0x000000AA
#define COLOUR_CHARTREUSE 0x7FFF00AA
#define COLOUR_BROWN 0XA52A2AAA
#define COLOUR_CORAL 0xFF7F50AA
#define COLOUR_GOLD 0xB8860BAA
#define COLOUR_GREENYELLOW 0xADFF2FAA
#define COLOUR_INDIGO 0x4B00B0AA
#define COLOUR_IVORY 0xFFFF82AA
#define COLOUR_LAWNGREEN 0x7CFC00AA
#define COLOUR_SEAGREEN 0x20B2AAAA
#define COLOUR_LIMEGREEN 0x32CD32AA
#define COLOUR_MIDNIGHTBLUE 0X191970AA
#define COLOUR_MAROON 0x800000AA
#define COLOUR_OLIVE 0x808000AA
#define COLOUR_ORANGERED 0xFF4500AA
#define COLOUR_PINK 0xFFC0CBAA
#define COLOUR_SEAGREEN2 0x2E8B57AA //Had same name as another define
#define COLOUR_SPRINGGREEN 0x00FF7FAA
#define COLOUR_TOMATO 0xFF6347AA
#define COLOUR_YELLOWGREEN 0x9ACD32AA
#define COLOUR_MEDIUMAQUA 0x83BFBFAA
#define COLOUR_MEDIUMMAGENTA 0x8B008BAA
