      subroutine stfset(s,nel,model,beta,nels)
c     implicit double precision (a-h,o-z)                                    dp
       use mod_parameters
      common/bk00/
     1k01,k02,k03,k04,k05,k06,k07,k08,k09,k10,k11,k12,
     2k13,k14,k15,k16,k17,k18,k19,k20,k21,k22,k23,k24,
     3k25,k26,k27,k28,k29,k30,k31,k32,k33,k34,k35,k36,
     4k37,k38,k39,k40,k41,k42,k43,k44,k45,k46,k47,k48,
     5k49,k50,k51,k52,k53,k54,k55,k56,k57,k58,k59,k60,
     6k61,k62,k63,k64,k65,k66,k67,k68,k69,k70,k71,k72,
     7k73,k74,k75,k76,k77,k78,k79,k80,k81,k82,k83,k84,
     8k85,k86,k87,k88,k89,k90,k91,k92,k93,k94,k95,k96
      common/bk02/ioofc,iphase,imass,lpar(9)
      common/bk16/maxint,hgc
      common/vect1/r(nelemg,10)
      common/vect7/
     1 diavg(nelemg),dfavg(nelemg),volnd(nelemg),volcd(nelemg),
     > vlinc(nelemg),volgp(nelemg),
     2 dimod(nelemg),sig11(nelemg),sig22(nelemg),sig33(nelemg),
     > sig12(nelemg)
      common/main_block/ a(1)
      dimension s(*)


!        write(7777,*) '-- stfset.f'

      do 10 i=1,36
   10 s(i)=0.

      do 20 i=1,8
   20 r(nels,i)=0.0
      s(1) =0.0001
      s(3) =0.0001
      s(6) =0.0001
      s(10)=0.0001
      s(15)=0.0001
      s(21)=0.0001
      s(28)=0.0001
      s(36)=0.0001
c
c     zero stress
c
      ln=maxint*lpar(9)
      ii=k14+ln*(nel-1)
      j=4
      if (model.eq.3) j=8
      if (model.eq.5) j=8
      if (model.eq.6) j=8
      if (model.eq.21)j=8
      do 40 ipt=1,maxint
      if (model.eq.4) nn=ii+8+(ipt-1)*(lpar(9)-2)
      if (model.ne.4) nn=ii+lpar(9)*(ipt-1)
      do 30 i=1,j
   30 a(nn+i-1)=0.
      if (model.eq.4) a(nn+5)=0.
      if (model.eq.5) beta=1./dfavg(nels)
      if (model.eq.21)beta=1./dfavg(nels)
   40 continue
      return
      end
