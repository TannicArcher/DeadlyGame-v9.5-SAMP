/********************************************
********* Inc. ObjectText by Schwan***********
*********************************************/
#if defined object_text_loaded
#endinput
#endif

#define object_text_loaded

new id;

stock CreateObjText(TEXT[256],Float:x,Float:y,Float:z)
{
	id=0;
	while(strlen(TEXT[id]))
	{
		if(strcmp(TEXT[id],"a",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"b",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"c",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"d",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z-9,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"e",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"f",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"g",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"h",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z-6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"i",false,1) == 0)
		{
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 3,0,0,0);
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"j",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"k",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"l",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"m",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 3,0,0,0);
			
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			
			ObjectText(3374,x+12,y,z- 3,0,0,0);
			
			ObjectText(3374,x+16,y,z- 0,0,0,0);
			ObjectText(3374,x+16,y,z- 3,0,0,0);
			ObjectText(3374,x+16,y,z- 6,0,0,0);
			ObjectText(3374,x+16,y,z- 9,0,0,0);
			ObjectText(3374,x+16,y,z-12,0,0,0);
			x += 24;
		}
		if(strcmp(TEXT[id],"n",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 3,0,0,0);
			
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			
			ObjectText(3374,x+12,y,z- 9,0,0,0);
			
			ObjectText(3374,x+16,y,z- 0,0,0,0);
			ObjectText(3374,x+16,y,z- 3,0,0,0);
			ObjectText(3374,x+16,y,z- 6,0,0,0);
			ObjectText(3374,x+16,y,z- 9,0,0,0);
			ObjectText(3374,x+16,y,z-12,0,0,0);
			x += 24;
		}
		if(strcmp(TEXT[id],"o",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"p",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"q",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"r",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"s",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"t",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 3,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"u",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"v",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"w",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			
			ObjectText(3374,x+12,y,z- 9,0,0,0);
			
			ObjectText(3374,x+16,y,z- 0,0,0,0);
			ObjectText(3374,x+16,y,z- 3,0,0,0);
			ObjectText(3374,x+16,y,z- 6,0,0,0);
			ObjectText(3374,x+16,y,z- 9,0,0,0);
			ObjectText(3374,x+16,y,z-12,0,0,0);
			x += 24;
		}
		if(strcmp(TEXT[id],"x",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"y",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			
			ObjectText(3374,x+4,y,z- 3,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"z",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"1",false,1) == 0)
		{
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"2",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"3",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"4",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z- 9,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"5",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"6",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x+=16;
		}
		if(strcmp(TEXT[id],"7",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"8",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"9",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"0",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 0,0,0,0);
			ObjectText(3374,x,y,z- 3,0,0,0);
			ObjectText(3374,x,y,z- 6,0,0,0);
			ObjectText(3374,x,y,z- 9,0,0,0);
			ObjectText(3374,x,y,z-12,0,0,0);
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			
			ObjectText(3374,x+8,y,z- 0,0,0,0);
			ObjectText(3374,x+8,y,z- 3,0,0,0);
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			ObjectText(3374,x+8,y,z- 9,0,0,0);
			ObjectText(3374,x+8,y,z-12,0,0,0);
			x += 16;
		}

		if(strcmp(TEXT[id],"!",false,1) == 0)
		{
			
			ObjectText(3374,x+4,y,z- 0,0,0,0);
			ObjectText(3374,x+4,y,z- 3,0,0,0);
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			ObjectText(3374,x+4,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],".",false,1) == 0)
		{
			ObjectText(3374,x+4,y,z-12,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"-",false,1) == 0)
		{
			ObjectText(3374,x,y,z- 6,0,0,0);
			
			ObjectText(3374,x+4,y,z- 6,0,0,0);
			
			ObjectText(3374,x+8,y,z- 6,0,0,0);
			x += 16;
		}
		if(strcmp(TEXT[id],"_",false,1) == 0)
		{
			x += 12;
		}
		
		id++;
	}
	return 1;
}

ObjectText(miid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz)
{
 	return CreateObject(miid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz);
}