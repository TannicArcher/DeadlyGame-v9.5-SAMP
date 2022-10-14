stock TuneCar(carid)
{
	SetVehicleHealth(carid, 1000);
	new modelid;
	modelid = GetVehicleModel(carid);
	switch(modelid)
	{
		case 400:
		{
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1018);//POT
		    AddVehicleComponent(carid,1013);//PHARE ROND
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1086);//STEREO
	    }
    	case 401:
		{
		    AddVehicleComponent(carid,1086);//STEREO
		    AddVehicleComponent(carid,1139);//SPOILER
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1012);//CAPOT
		    AddVehicleComponent(carid,1013);//PHARE ROND
		    AddVehicleComponent(carid,1042);//CONDUITR
		    AddVehicleComponent(carid,1043);//CONDUITL
		    AddVehicleComponent(carid,1018);//POT
		    AddVehicleComponent(carid,1006);//TOIT
   		    AddVehicleComponent(carid,1007);//JUPE
   		    AddVehicleComponent(carid,1017);//JUPE
		}
		//DUMPER
		case 406:
		{
	        AddVehicleComponent(carid,1081);//JANTE
		}
		//FIRETRUCK
		case 407:
		{
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1010);//NOS
		}
		case 578,579,580,582,583,584,585,587,588,589,596,597,
		598,599,600,601,602,603,604,605,609,568,572,574,402,
		403,404,405,408,409,410,411,412,413,414,415,416,418,
		419,421,422,423,424,426,427,428,429,431,432,433,434,
		436,437,438,439,440,441,442,443,444,445,451,455,456,
		457,458,459,466,467,470,474,475,477,478,479,480,482,
		483,485,486,489,492,494,495,496,498,499,500,502,503,
		504,505,506,507,508,514,515,516,517,518,524,525,526,
		527,528,529,530,531,532,533,540,541,542,543,566,544,
		545,546,547,549,550,551,552,554,555:
		{
			AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1081);//JANTE
		}
		//TAXI
		case 420:
		{
			AddVehicleComponent(carid,1010);//NOS//nos
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1139);//SPOILER//SPOILER//spoiler
		}
		//REMINGTON
		case 534:
		{
		    //ChangeVehiclePaintjob(carid,2);
		    AddVehicleComponent(carid,1180);
		    AddVehicleComponent(carid,1185);
		    AddVehicleComponent(carid,1100);
		    AddVehicleComponent(carid,1010);//NOS//nos
		    AddVehicleComponent(carid,1127);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1101);//BAS DE CAISSE
		    AddVehicleComponent(carid,1122);//BAS DE CAISSE
		    AddVehicleComponent(carid,1087);//HYDROLIK
		}
		//SLAMVAN
		case 535:
		{
		    //ChangeVehiclePaintjob(carid,2);
			AddVehicleComponent(carid,1109);
			AddVehicleComponent(carid,1115);
			AddVehicleComponent(carid,1117);
			AddVehicleComponent(carid,1010);//NOS//nos
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1114);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1119);//BAS DE CAISSE
		    AddVehicleComponent(carid,1121);//BAS DE CAISSE
		}
		//BLADE
		case 536:
		{
		    AddVehicleComponent(carid,1010);//NOS//nos
		    AddVehicleComponent(carid,1183);
		    AddVehicleComponent(carid,1181);
		    AddVehicleComponent(carid,1107);//BAS DE CAISSE
		    AddVehicleComponent(carid,1104);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1108);//BAS DE CAISSE
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1081);//JANTE
		}
		//MONSTERA
		case 556,557:
		{
			AddVehicleComponent(carid,1010);//NOS
		}
		//URANUS
		case 558:
		{
		    AddVehicleComponent(carid,1092);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1166);
		    AddVehicleComponent(carid,1165);
		    AddVehicleComponent(carid,1090);//BAS DE CAISSE
		    AddVehicleComponent(carid,1094);//BAS DE CAISSE
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1163);//SPOILER
		    AddVehicleComponent(carid,1091);//ROOF
		    //ChangeVehiclePaintjob(carid,2);
		}
		//JESTER
		case 559:
		{
		    AddVehicleComponent(carid,1070);//BAS DE CAISSE
		    AddVehicleComponent(carid,1066);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1072);//BAS DE CAISSE
			AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1147);//SPOILER
		    AddVehicleComponent(carid,1068);//ROOF
		    AddVehicleComponent(carid,1173);
		    AddVehicleComponent(carid,1161);
		    //ChangeVehiclePaintjob(carid,1);
		}
		//SULTAN
		case 560:
		{
		    AddVehicleComponent(carid,1028);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1140);
		    AddVehicleComponent(carid,1170);
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1139);//SPOILER
		    AddVehicleComponent(carid,1033);//ROOF
		    AddVehicleComponent(carid,1031);//BAS DE CAISSE
		    AddVehicleComponent(carid,1030);//BAS DE CAISSE
		    //ChangeVehiclePaintjob(carid,1);
		}
		//STRATUM
		case 561:
		{
		   	AddVehicleComponent(carid,1056);//BAS DE CAISSE
		   	AddVehicleComponent(carid,1156);
		   	AddVehicleComponent(carid,1157);
		    AddVehicleComponent(carid,1062);//BAS DE CAISSE
		    AddVehicleComponent(carid,1059);//POT D'ECHAPPEMMENT
			AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1146);//SPOILER
		    AddVehicleComponent(carid,1061);//ROOF
		    //ChangeVehiclePaintjob(carid,2);
		}
		//ELEGY
		case 562:
		{
		    //ChangeVehiclePaintjob(carid,1);
		    AddVehicleComponent(carid,1037);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1035);//ROOF
		    AddVehicleComponent(carid,1039);//BAS DE CAISSE
		    AddVehicleComponent(carid,1041);//BAS DE CAISSE
		    AddVehicleComponent(carid,1086);//STEREO
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1147);//SPOILER
		    AddVehicleComponent(carid,1148);
		    AddVehicleComponent(carid,1172);
		}
		//FLASH
		case 565:
		{
		    //ChangeVehiclePaintjob(carid,2);
		    AddVehicleComponent(carid,1046);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1151);
		    AddVehicleComponent(carid,1152);
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1139);//SPOILER
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1053);//ROOF
		    AddVehicleComponent(carid,1047);//BAS DE CAISSE
		    AddVehicleComponent(carid,1051);//BAS DE CAISSE
		}
 		//SAVANNA
		case 567:
		{
		   	AddVehicleComponent(carid,1188);
		   	AddVehicleComponent(carid,1186);
		   	AddVehicleComponent(carid,1102);//BAS DE CAISSE
		   	AddVehicleComponent(carid,1133);//BAS DE CAISSE
		    AddVehicleComponent(carid,1018);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    //ChangeVehiclePaintjob(carid,2);
			AddVehicleComponent(carid,1081);//JANTE
   		}
   		case 575:
   		{
		    //ChangeVehiclePaintjob(carid,1);
		    AddVehicleComponent(carid,1175);
		    AddVehicleComponent(carid,1177);
		    AddVehicleComponent(carid,1043);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1042);//BAS DE CAISSE
		    AddVehicleComponent(carid,1099);//BAS DE CAISSE
		   AddVehicleComponent(carid,1087);//HYDROLIK
		}
		//TORNADO
   		case 576:
		{
		    //ChangeVehiclePaintjob(carid,2);
		    AddVehicleComponent(carid,1191);
		    AddVehicleComponent(carid,1193);
		    AddVehicleComponent(carid,1010);//NOS
		    AddVehicleComponent(carid,1018);//POT D'ECHAPPEMMENT
		    AddVehicleComponent(carid,1081);//JANTE
		    AddVehicleComponent(carid,1087);//HYDROLIK
		    AddVehicleComponent(carid,1134);//BAS DE CAISSE
		    AddVehicleComponent(carid,1137);//BAS DE CAISSE
		}
	}
}
stock NosCar(carid)
{
	SetVehicleHealth(carid, 1000);
	new modelid;
	modelid = GetVehicleModel(carid);
	switch(modelid)
	{
		case 407,578,579,580,582,583,584,585,587,588,589,596,
		597,400,401,420,534,535,536,556,557,558,559,560,561,
		598,599,600,601,602,603,604,605,609,568,572,574,402,
		403,404,405,408,409,410,411,412,413,414,415,416,418,
		419,421,422,423,424,426,427,428,429,431,432,433,434,
		436,437,438,439,440,441,442,443,444,445,451,455,456,
		457,458,459,466,467,470,474,475,477,478,479,480,482,
		483,485,486,489,492,494,495,496,498,499,500,502,503,
		504,505,506,507,508,514,515,516,517,518,524,525,526,
		527,528,529,530,531,532,533,540,541,542,543,566,544,
		545,546,547,549,550,551,552,554,555562,565,567,575,
		576:
		{
			AddVehicleComponent(carid,1010);//NOS
		}

	}
}