//------------------------------------------------------------------------------//
/*
 * Info:
 	* encryption and decryption functions
 	* created by Omer ('N1trO'),
 	* (c) Copyright 2009.
 	
 * Encryptions Types:
    * en_ascci 	- 	Uprise The Charters ASCII Number By The Key.	[weak]
	* en_byte   -   Uprise The Charters Binary Number By The Key.   [normal]
	* en_mix    -   Both Enctription Types Mixed Together.          [hard]
	
 * Usage:
    * Encrypt(Text_To_Encrypt[] ,Encryption_Key(number) ,Encryptmode: Encrypt_Type);
	* Decrypt(Text To Encrypt[] ,Encryption_Key(number) ,Encryptmode: Encrypt_Type);
	* Decrypt Function Should Have The Same Key As The Encryption

*/
//------------------------------------------------------------------------------//

#if defined _enc_included
  #endinput
#endif
#define _enc_included
#pragma library enc

enum Encryptmode
{
	en_ascci,
	en_byte,
	en_conc,
	en_mix
};

stock Encrypt(const string[],key,Encryptmode: mode = en_ascci)
{
    new EN[256];
 	if(mode == en_ascci)for(new i; i<256; i++) EN[i] = string[i],EN[i] += key;
	if(mode == en_byte) for(new i; i<256; i++) EN[i] = string[i],EN[i] += (i << key);
	if(mode == en_mix)  for(new i; i<256; i++) EN[i] = string[i],EN[i] += ((i << key) + i);
	if(mode == en_conc){
        new x = key1 + 10,
		y = _:floatabs(Float:(key - 10));
		for(new i,j; i<strlen(string); i++,j+=2){
		string[i] += x - (y & key1) + y;
	    string[i] += j;
	}
	return EN;
}
stock Decrypt(const string[],key,Encryptmode: mode = en_ascci)
{
    new EN[256];
 	if(mode == en_ascci)for(new i; i<256; i++) EN[i] = string[i],EN[i] -= key;
	if(mode == en_byte) for(new i; i<256; i++) EN[i] = string[i],EN[i] -= (i << key);
	if(mode == en_mix)  for(new i; i<256; i++) EN[i] = string[i],EN[i] -= ((i << key) + i);
	if(mode == en_conc){
        new x = key1 + 10,
		y = _:floatabs(Float:(key - 10));
		for(new i,j; i<strlen(string); i++,j+=2){
		string[i] -= x - (y & key1) + y;
	    string[i] -= j;
	}
	return EN;
}
