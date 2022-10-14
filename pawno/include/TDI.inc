/**********************************

Name: TextdrawImage
Description: Create ingame images using textdraws
Author: Ym[0]n

Software distributed under the following license: Creative Commons «Attribution» (Attribution 2.5 Generic (CC BY 2.5)).
This license allows you to distribute, process, correct and develop the product, even for commercial purposes, provided the author's works.

**********************************/

#if defined TDI_included
	#endinput
#endif
#define TDI_included

#include <a_samp>
#include <r_io>



#define allTextDraws 450//max textdraws in one moment

enum TDI_data {
Text:TextdrawIDs[allTextDraws],
bool:isCreated
}

new TDI[TDI_data];






stock CreateTextdrawImage(filename[], Float:X, Float:Y, Float:pixelSize = 2.0)
{
	if(TDI[isCreated])
	{
		print("TextdrawImage already created, delete before creating");
		return false;
	}
	
	new
		File:f 	= fopen(filename, io_read),
		
		bfType 				= readInt16(f),
		bfSize 				= readInt32(f),
		bfReserved1			= readInt16(f),
		bfReserved2 		= readInt16(f),
		bfOffBits 			= readInt32(f),
		
		biSize 				= readInt32(f),
		biWidth 			= readInt32(f),
		biHeight 			= readInt32(f),

		biPlanes 			= readInt16(f),
		biBitCount 			= readInt16(f),
		biCompression 		= readInt32(f),
		biSizeImage 		= readInt32(f),
		biXPelsPerMeter 	= readInt32(f),
		biYPelsPerMeter		= readInt32(f),
		biClrUsed 			= readInt32(f),
		biClrImportant 		= readInt32(f);
		
	/*
	printf(

	"bfType = 0x%x = %d, \n\
	bfSize = 0x%x = %d, \n\
	bfReserved1 = 0x%x = %d, \n\
	bfReserved2 = 0x%x = %d, \n\
	bfOffBits = 0x%x = %d, \n\
	biSize = 0x%x = %d, \n\
	biWidth = 0x%x = %d, \n\
	biHeight = 0x%x = %d, \n\
	biPlanes = 0x%x = %d, \n\
	biBitCount = 0x%x = %d, \n\
	biCompression = 0x%x = %d, \n\
	biSizeImage = 0x%x = %d, \n\
	biXPelsPerMeter = 0x%x = %d, \n\
	biYPelsPerMeter = 0x%x = %d, \n\
	biClrUsed = 0x%x = %d, \n\
	biClrImportant = 0x%x = %d",

	bfType, bfType,
	bfSize, bfSize,
	bfReserved1, bfReserved1,
	bfReserved2, bfReserved2,
	bfOffBits, bfOffBits,
	
	biSize, biSize,
	biWidth, biWidth,
	biHeight, biHeight,
	
	biPlanes, biPlanes,
	biBitCount, biBitCount,
	biCompression, biCompression,
	biSizeImage, biSizeImage,
	biXPelsPerMeter, biXPelsPerMeter,
	biYPelsPerMeter, biYPelsPerMeter,
	biClrUsed, biClrUsed,
	biClrImportant, biClrImportant

	);
	*/
	
	#pragma unused biClrImportant
	#pragma unused biYPelsPerMeter
	#pragma unused biXPelsPerMeter
	#pragma unused biSizeImage
	#pragma unused biSize
	#pragma unused bfOffBits
	#pragma unused bfSize

	if(bfType != 0x4D42)
	{
		print("Wrong BMP image format.");
		fclose(f);
		return false;
	}
	else if(bfReserved1 != 0 || bfReserved2 != 0)
	{
		print("Wrong BMP image format.");
		fclose(f);
		return false;
	}
	else if(biPlanes != 1)
	{
		print("Wrong BMP image format.");
		fclose(f);
		return false;
	}
	else if(biBitCount < 24)
	{
		print("Supported only 24 bit and 32 bit images.");
		fclose(f);
		return false;
	}
	else if(biCompression > 0)
	{
		print("Compression is not supported.");
		fclose(f);
		return false;
	}
	else if(biClrUsed != 0)
	{
		print("The palette is not supported.");
		fclose(f);
		return false;
	}
	else if(biWidth * biHeight > allTextDraws)
	{
		printf("biWidth * biHeight = %d, but maximum textdraws in one moment 450", biWidth * biHeight);
		fclose(f);
		return false;
	}
	
	new
		pixelX = 0,
		pixelY = biHeight,
		Float:offsetX = X - (pixelSize * (biWidth / 2)),
		Float:offsetY = Y - (pixelSize * (biHeight / 2));

	for(new i; i != (biWidth * biHeight); i++)
	{
		new
			B =		255,
			G =		255,
			R =		255,
			A =		255,
			RGBA =	0xFFFFFFFF;



		B = readByte(f);
		G = readByte(f);
		R = readByte(f);
		
	    if(biBitCount == 32)
		{
		    fseek(f, 1, seek_current);//skip 1 unused byte
			//A = readByte(f);
		}

		RGBA = (R << 24 | G << 16 | B << 8 | A);
	
		TDI[TextdrawIDs][i] = TextDrawCreate(offsetX + (pixelX * pixelSize), offsetY + (pixelY * pixelSize), ".");
		TextDrawBackgroundColor(TDI[TextdrawIDs][i], 255);
		TextDrawFont(TDI[TextdrawIDs][i], 3);
		TextDrawLetterSize(TDI[TextdrawIDs][i], 0.125 * pixelSize, 0.60 * pixelSize);
		TextDrawColor(TDI[TextdrawIDs][i], RGBA);
		TextDrawSetOutline(TDI[TextdrawIDs][i], 0);
		TextDrawSetProportional(TDI[TextdrawIDs][i], 1);
		TextDrawSetShadow(TDI[TextdrawIDs][i], 0);


		pixelX ++;
		if(pixelX >= biWidth)
		{
			if(biBitCount == 16)fseek(f,(2 * biWidth) % 4, seek_current);
			if(biBitCount == 24)fseek(f, biWidth % 4, seek_current);

			pixelX = 0;
			pixelY --;
		}
	}

	TDI[isCreated] = true;
	fclose(f);
	return 1;
}

stock ShowTextdrawImageForPlayer(playerid)
{
	for(new i; i != allTextDraws; i++)TextDrawShowForPlayer(playerid, TDI[TextdrawIDs][i]);
	return 1;
}

stock HideTextdrawImageForPlayer(playerid)
{
	for(new i; i != allTextDraws; i++)TextDrawHideForPlayer(playerid, TDI[TextdrawIDs][i]);
	return 1;
}

stock ShowTextdrawImageForAll()
{
	for(new i; i != allTextDraws; i++)TextDrawShowForAll(TDI[TextdrawIDs][i]);
	return 1;
}

stock HideTextdrawImageForAll()
{
	for(new i; i != allTextDraws; i++)TextDrawHideForAll(TDI[TextdrawIDs][i]);
	return 1;
}

stock DestroyTextdrawImage()
{
	for(new i; i != allTextDraws; i++)TextDrawDestroy(TDI[TextdrawIDs][i]);
	TDI[isCreated] = false;
	return 1;
}
