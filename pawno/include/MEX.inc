/*  

!!!!!!!!!!!!            !!!!!!!!!!!!!    !!!!!!!!                 !!!!!!!!         !!!!!!!!!!!!!!!!!                        !!!!!!!!!                  !!!!!!!!                !!!!!!!
!!!!!!!!!!!!!!         !!!!!!!!!!!!!!      !!!!!!!!!           !!!!!!!!!       !!!!!!!!!!!!!!!!!!!!!!!!!!                 !!!!!!!!!!!!                !!!!!!!!!!!!            !!!!!!!!
!!!!!!! !!!!!!!       !!!!!!!!!!!!!!!          !!!!!!!       !!!!!!!          !!!!!!!              !!!!!!                !!!!!!! !!!!!!!              !!!!!!!!!!!!!!!          !!!!!!!
!!!!!!!   !!!!!!     !!!!!!!  !!!!!!!             !!!!!!!!!!!!!!!               !!!!!!!!!!!!!!!!                       !!!!!!!     !!!!!!!             !!!!!!!   !!!!!!!       !!!!!!!
!!!!!!!   !!!!!!!   !!!!!!    !!!!!!!               !!!!!!!!!!                        !!!!!!!!!!!!!!!!!!!            !!!!!!!         !!!!!!!           !!!!!!      !!!!!!!!    !!!!!!!
!!!!!!!     !!!!!!!!!!!!!!    !!!!!!!                 !!!!!!!                !                      !!!!!!!!       !!!!!!!!!!!!!!!!!!!!!!!!!!!         !!!!!!!        !!!!!!!!!!!!!!!!
!!!!!!!     !!!!!!!!!!!!      !!!!!!!                 !!!!!!!                !!!!!!!!!              !!!!!!!      !!!!!!!!    !!!!!      !!!!!!!        !!!!!!!!         !!!!!!!!!!!!!!
!!!!!!!       !!!!!!!!!       !!!!!!!                 !!!!!!!                   !!!!!!!!!!!!!!!!!!!!!!!!!       !!!!!!!                   !!!!!!!!     !!!!!!!!            !!!!!!!!!!!


*/

//Создано 20.05.2009 by MYSAN

#if defined _MEX_included
	#endinput
#endif
#define _MEX_included
#pragma library MEX
new Float: xmysan,Float: ymysan,Float: zmysan;
#define mysan 500.0  //мошчность взрыва !
#define mys 55  //растояние появления взрыва от тачки
#define mys1 10  //растояние появления взрыва от тачки
#define mys2 15  //растояние появления взрыва от тачки
#define mys3 20 //растояние появления взрыва от тачки
#define mys4 25  //растояние появления взрыва от тачки
#define mys5 30  //растояние появления взрыва от тачки
#define mys6 18  //растояние появления взрыва от тачки
#define mys7 21  //растояние появления взрыва от тачки
#define mys8 40  //растояние появления взрыва от тачки
#define mys9 4  //растояние появления взрыва от тачки
#define mys10 1  //растояние появления взрыва от тачки
#define mys11 8  //растояние появления взрыва от тачки
#define mys12 7  //растояние появления взрыва от тачки
#define mys13 60  //растояние появления взрыва от тачки
#define mys14 70  //растояние появления взрыва от тачки
#define mys15 33  //растояние появления взрыва от тачки
#define my1 5  //высота взрыва от тачки
#define my2 10  //высота взрыва от тачки
#define my3 15  //высота взрыва от тачки
#define my4 20  //высота взрыва от тачки
#define my5 25  //высота взрыва от тачки
#define my6 33  //высота взрыва от тачки
#define my7 35  //высота взрыва от тачки
#define my8 40  //высота взрыва от тачки
#define my9 45  //высота взрыва от тачки
#define my10 50  //высота взрыва от тачки
#define my11 55  //высота взрыва от тачки
#define my12 90  //высота взрыва от тачки
#define my13 70  //высота взрыва от тачки
#define my14 75  //высота взрыва от тачки
#define my15 100  //высота взрыва от тачки

public OnVehicleDeath(vehicleid, killerid)
{
GetVehiclePos(vehicleid, Float:xmysan, Float:ymysan, Float:zmysan);
CreateExplosion(xmysan, ymysan, zmysan+1, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+4, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+2, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+5, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+3, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+6, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+8, 4, mysan);
CreateExplosion(xmysan, ymysan, zmysan+7, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+10, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+11, 6, mysan);
CreateExplosion(xmysan, ymysan, zmysan+12, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+13, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+14, 3, mysan);
CreateExplosion(xmysan, ymysan, zmysan+15, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+16, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+17, 7, mysan);
CreateExplosion(xmysan, ymysan, zmysan+18, 8, mysan);
CreateExplosion(xmysan, ymysan, zmysan+19, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+20, 9, mysan);
CreateExplosion(xmysan, ymysan, zmysan+21, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+22, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+23, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+24, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+25, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+26, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+27, 5, mysan);
CreateExplosion(xmysan, ymysan, zmysan+28, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+29, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+30, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my1, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my2, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my3, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my4, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my5, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my6, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my7, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my8, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my9, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my10, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my11, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my12, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my13, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my14, 10, mysan);
CreateExplosion(xmysan, ymysan, zmysan+my15, 10, mysan);
CreateExplosion(xmysan+mys, ymysan+mys, zmysan+mys, 10, mysan);
CreateExplosion(xmysan+mys1, ymysan+mys1, zmysan+mys1, 10, mysan);
CreateExplosion(xmysan+mys2, ymysan+mys2, zmysan+mys2, 10, mysan);
CreateExplosion(xmysan+mys3, ymysan+mys3, zmysan+mys3, 10, mysan);
CreateExplosion(xmysan+mys4, ymysan+mys4, zmysan+mys4, 10, mysan);
CreateExplosion(xmysan+mys5, ymysan+mys5, zmysan+mys5, 10, mysan);
CreateExplosion(xmysan+mys6, ymysan+mys6, zmysan+mys6, 10, mysan);
CreateExplosion(xmysan+mys7, ymysan+mys7, zmysan+mys7, 10, mysan);
CreateExplosion(xmysan+mys8, ymysan+mys8, zmysan+mys8, 10, mysan);
CreateExplosion(xmysan+mys9, ymysan+mys9, zmysan+mys9, 10, mysan);
CreateExplosion(xmysan+mys10, ymysan+mys10, zmysan+mys10, 10, mysan);
CreateExplosion(xmysan+mys14, ymysan+mys13, zmysan+mys11, 10, mysan);
CreateExplosion(xmysan+mys10, ymysan+mys12, zmysan+mys11, 10, mysan);
CreateExplosion(xmysan+mys15, ymysan+mys11, zmysan+mys12, 10, mysan);
CreateExplosion(xmysan+mys13, ymysan+mys14, zmysan+mys15, 10, mysan);
return 1;
}

