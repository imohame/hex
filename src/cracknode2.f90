      subroutine cracknode2(nedge, ele, ix)
!!!	  
!!!	  parameter (nume=40000)
!!!	  parameter (nume2=20000)
!!!	  common /overlapping/ intersec(4, nume), area_coeff(nume),update_flag
!!!	  common /crackline/ ncleave(3,nume), elecrack(4,nume),nodeflag(4,nume)
!!!
!!!      dimension ix(4,*)	 
!!!	  
!!!	  integer nedge, ele, elecrack, n1, n2,ix
!!!	  real intersec, yc, zc
!!!	  
!!!	  if(nedge<=3) then
!!!	      n1=ix(nedge+1,ele)
!!!		  n2=ix(nedge,ele)
!!!	  else if(nedge==4) then
!!!	      n1=ix(1,ele)
!!!		  n2=ix(nedge,ele)
!!!	  end if
!!!	  
!!!	  if(elecrack(1,ele)==nedge) then
!!!	      yc=1.0-intersec(1,ele)
!!!          zc=1.0-intersec(2,ele)
!!!	  else if(elecrack(3,ele)==nedge) then
!!!	      yc=1.0-intersec(3,ele)
!!!	      zc=1.0-intersec(4,ele)
!!!	  end if
!!!	  
!!!	  call postcoord(n1, n2, yc, zc)
	  
	  end
		    
	  
	  
	  
       
	  
	  