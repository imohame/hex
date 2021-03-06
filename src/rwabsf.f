      subroutine rwabsf (fit,lfn,us,bfs,fcs)                            vax750
c
c     ansi fortran equivalents to llnl familied file random i/o routines
c
c     steven j. sackett
c
c     lawrence livermore laboratory
c     livermore, california 94550
c
c     december 5, 1981
c
c-----------------------------------------------------------------------
c     this package consists of seven routines for handling word
c     addressable random i/o on familied files:
c
c               asgrfm  (not called directly)
c               nrfnam  (not called directly)
c               rdabsf  (fit,w,nw,da)
c               rdiska  (not called directly)
c                wdiska
c               riosta  (fit)
c               rwabsf  (fit,lfn,us,bfs,fcs)
c               wrabsf  (fit,w,nw,da)
c
c
c     if the disk address given in the argument list to rdabsf/wrabsf
c     is greater than or equal to the family (file) size, it is biased
c     to access the correct family member. here the family size is
c     defined to be the size at which family members are created.
c
c     the root name for a family, which is the name of the first family
c     member, is taken to be the name associated with the given unit
c     specifier (logical unit). names for succeeding family members are
c     generated by appending a two digit integer to the root name (or
c     to its first six characters). the disk address bias for a member,
c     which is also the first word address for the member, is equal to
c     this integer times the family (file) size. assuming, for example,
c     the root name "diska" and a family size of 1000000b words, a
c     family with five members would appear as follows:
c             --------------------------------------
c             member     name     first word address
c             --------------------------------------
c               1        diska         0
c               2        diska01       1000000b
c               3        diska02       2000000b
c               4        diska03       3000000b
c               5        diska04       4000000b
c             --------------------------------------
c     note that with this naming scheme errors can occur if an eight
c     character root name of the form axxxxxnn is used, where "a"
c     denotes an alphabetic character, "x" denotes any character, and
c     "n" denotes a numeric character.
c
c     if a family member exists, it is opened and used. if it does
c     not exist, a new file is created at the family (file) size.
c     note that this will result in an error exit if a write is
c     attempted on an existing file that is read-only.
c
c-----------------------------------------------------------------------
c
c.... open/close a file for word addressable random i/o
c
c     calling sequence: call rwabsf(fit,lfn,lus,bfs,fcs)
c
c     input arguments
c            fit      array to use for the file information table
c            lfn      the file name for an open call; the file
c                     disposition status ('keep' or 'delete') for
c                     a close call
c            us       the file unit specifier (logical unit no.)
c                     for an open call; zero (0) or omitted for a
c                     close call
c            bfs      the buffer size in words for an open call;
c                     zero (0) or omitted for a close call
c            fcs      file creation size (family size) for an open
c                     call; zero (0) or omitted for a close call
c
c     fit must be dimensioned as an array of at least bfs+7 words in
c     the user's program and must not be changed while the file is open
c     bfs must be a multiple of 512 (1000b). fcs must be a multiple of
c     bfs.
c
      implicit integer (a-z)                                            vax750
      common/double/iprec,ncpw,unit                                     vax750
      dimension fit(8)                                                  vax750
      character lfn*8                                                   vax750
c
      common/frfcm1/mxfrf,ifrf,buflen,fcsize,dskloc ,curlen,kop,ier     vax750
c            mxfrf     dimension of the familied random file name
c                      table (currently set to 16) - this is the
c                      maximum number of familied random files
c                      allowed to be open at the same time
c            ifrf      index in familied random file name table for
c                      the file accessed last
c
      character*8 frfn,frn,kfn                                          vax750
      common/frfcm2/frfn(2,16),frn,kfn                                  vax750
c            frfn      familied random file name table
c
      logical fxist                                                     vax750
c
c     fit(1) = us
c     fit(2) = index in random file root name table for this file
c     fit(3) = bfs
c     fit(4) = fcs
c     fit(5) = disk address of first word in the buffer
c     fit(6) = number of words of data currently in the buffer
c     fit(7) = disk address of last word in file + 1
c

      if ((lfn.eq.'keep').or.(lfn.eq.'delete')) go to 50                vax750
c.... initialize fit and put name in familied random file name table
      do 10 n=1,mxfrf                                                   vax750
      if (frfn(1,n).ne.'        ') go to 10                             vax750
      frfn(1,n)=lfn                                                     vax750
      fit(2)=n                                                          vax750
      go to 12                                                          vax750
   10 continue                                                          vax750
c      call abort (' rwabsf open error- too many random files ')         vax750
   12 continue                                                          vax750
      buflen=bfs-mod(bfs,512)                                           vax750
      inquire (file=lfn,recl=rcl)                                       vax750
      rcl=rcl/ncpw                                                      vax750
      if (buflen.lt.rcl) then                                           vax750
c      call abort (' rwabsf open error- buffer too small ')              vax750
      endif                                                             vax750
      if (rcl.ne.0) buflen=rcl                                          vax750
      fit(1)=us                                                         vax750
      fit(3)=buflen                                                     vax750
      fit(4)=fcs-mod(fcs,buflen)                                        vax750
      fit(5)=fit(4)                                                     vax750
      fit(6)=0                                                          vax750
      fit(7)=0                                                          vax750
      return                                                            vax750
c.... flush the buffer if data is present which is not on disk
   50 continue                                                          vax750
      if (fit(3).lt.0) then                                             vax750
      fit(3)=-fit(3)                                                    vax750
      call wdiska (fit(1),fit(8),fit(3),fit(5))                         vax750
      fit(7)=max(fit(7),fit(5)+fit(3))                                  vax750
      endif                                                             vax750
c.... close the file
      if (fit(7).eq.0) return                                           vax750
      close (fit(1),status='keep')                                      vax750
      ifrf=fit(2)                                                       vax750
      frn=frfn(1,ifrf)                                                  vax750
      frfn(1,ifrf)='        '                                           vax750
      frfn(2,ifrf)='        '                                           vax750
      if (lfn.ne.'delete') return                                       vax750
c.... destroy the family if requested
      n=0                                                               vax750
      kfn=frn                                                           vax750
   60 continue                                                          vax750
      inquire (file=kfn,exist=fxist)                                    vax750
      if (.not.fxist) return                                            vax750
      open (fit(1),file=kfn,access='direct',form='unformatted',         vax750
     1 recl=rcl,status='old')                                           vax750
      close (fit(1),status='delete')                                    vax750
      n=n+1                                                             vax750
      call nrfnam (frn,n,kfn)                                           vax750
      go to 60                                                          vax750
      end                                                               vax750
