/* deals with forcing functions that are passed via arguments in the call
to the integration routines */

#include "de.h"
#include "externalptr.h"

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   Forcing functions (compiled code)
   **FORCING FUNCTIONS**, or external variables need to be interpolated 
   at each time step. This is done in this part of C-code.

   "initForcings" creates forcing function vectors passed from an R-list 
   "initforcings" puts a pointer to the vector that contains the 
     forcing functions in the DLL. This is done by calling "Initdeforc"; 
   here the C-globals are initialised .  

   Each time-step, before entering the compiled code, the forcing function 
   variables are interpolated to the current time (function ("updateforc").
   
   
   
   **EVENTS** occur when the value of state variables change abruptly. 
   This cannot be easily handled in the integrators, where state 
   variables change via the derivatives only.
   
   Events are either specified in a data.frame, or via an event function, 
   specified in R-code or in compiled code. 
   For events, specified in R-code, function "C_event_func" provides 
   the C-interface.
   
   "initEvents" creates initialises the events, based on information passed 
   from an R-list.
   
   Each time-step, it is tested whether an event occurs ("updateevent")  

 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*=========================================================================== 
         -----     Check for presence of forcing functions     -----       
   function "initForcings" checks if forcing functions are present and if so,
   create the vectors that contain the times (Tvec), the forcing values (Fvec) 
   the start position of each forcing function variable (Ivec), and the 
   interpolation method (fmethod). 
  =========================================================================== */


int initForcings(SEXP flist) {

    SEXP Tvec, Fvec, Ivec, initforc;
    int i, j, isForcing = 0;
    init_func_type  *initforcings;
 
    initforc = getListElement(flist, "ModelForc");
    if (!isNull(initforc)) {
      Tvec = getListElement(flist, "tmat");
      Fvec = getListElement(flist, "fmat");
      Ivec = getListElement(flist, "imat");
      nforc = LENGTH(Ivec)-2; /* nforc, fvec, ivec = globals */

      i = LENGTH(Fvec);
      fvec = (double *) R_alloc((int) i, sizeof(double));
      for (j = 0; j < i; j++) fvec[j] = REAL(Fvec)[j];

      tvec = (double *) R_alloc((int) i, sizeof(double));
      for (j = 0; j < i; j++) tvec[j] = REAL(Tvec)[j];

      i = LENGTH (Ivec)-1; /* last element: the interpolation method...*/
      ivec = (int *) R_alloc(i, sizeof(int));
      for (j = 0; j < i; j++) ivec[j] = INTEGER(Ivec)[j];

      fmethod = INTEGER(Ivec)[i];
      initforcings = (init_func_type *) R_ExternalPtrAddrFn_(initforc);
      initforcings(Initdeforc);
      isForcing = 1;
    }
    return(isForcing);
}

/*=========================================================================== 
         -----     INITIALISATION  called from compiled code   -----
   1. Check the length of forcing functions in solver call and code in DLL
   2. Initialise the forcing function vectors
   3. set pointer to DLL; FORTRAN common block or C globals /
  =========================================================================== */

void Initdeforc(int *N, double *forc) {
  int i, ii;
  if ((*N) != nforc) {
    warning("Number of forcings passed to solver, %i; number in DLL, %i\n",nforc, *N);
  Rf_error("Confusion over the length of forc.");
  }

  /* for each forcing function: index to current position of data,
     current value, interpolation factor, 
     current forcing time, next forcing time,..
  */
  finit = 1;
  findex   = (int    *) R_alloc(nforc, sizeof(int));
  intpol   = (double *) R_alloc(nforc, sizeof(double));
  maxindex = (int    *) R_alloc(nforc, sizeof(int));

  /* Input is in three vectors:
     tvec, fvec: time and value;
     ivec : index to each forcing in tvec and fvec
  */
  for (i = 0; i<nforc; i++) {
    ii = ivec[i]-1;
    findex[i] = ii;
    maxindex[i] = ivec[i+1]-2;
    if (fmethod == 1) {
      intpol[i] = (fvec[ii+1]-fvec[ii])/(tvec[ii+1]-tvec[ii]);
    } else  intpol[i] = 0;
    forc[i] = fvec[ii];
  }
  forcings = forc;      /* set pointer to C globals or FORTRAN common block */
}

void updatedeforc(double *time) {
  int i, ii,  zerograd;

  /* check if initialised? */
  if (finit == 0)
    error ("error in forcing function: not initialised");

  for (i=0; i<nforc; i++) {
    ii = findex[i];
    zerograd=0;
    while (*time > tvec[ii+1]){
      if (ii+2 > maxindex[i]) {   /* this probably redundant...*/
        zerograd=1;
        break;
      }
      ii = ii+1;
    }
    while (*time < tvec[ii]){       /* test here for ii < 1 ?...*/
      ii = ii-1;
    }
    if (ii != findex[i]) {
      findex[i] = ii;
      if ((zerograd == 0) & (fmethod == 1)) {  /* fmethod 1=linear */
        intpol[i] = (fvec[ii+1]-fvec[ii])/(tvec[ii+1]-tvec[ii]); 
      } else {
        intpol[i] = 0;
      }
    }
    forcings[i]=fvec[ii]+intpol[i]*(*time-tvec[ii]);
  }
}

/* ============================================================================
  events: time, svar number, value, and method; in a list  
   ==========================================================================*/

typedef void event_func_type(int*, double*, double*);
event_func_type  *event_func;

static void C_event_func (int *n, double *t, double *y) {
  int i;
  SEXP R_fcall, Time, ans;
  for (i = 0; i < *n; i++) REAL(Y)[i] = y[i];

  PROTECT(Time = ScalarReal(*t));                  
  PROTECT(R_fcall = lang3(R_event_func,Time,Y));   
  PROTECT(ans = eval(R_fcall, R_envir));           

  for (i = 0; i < *n; i++) y[i] = REAL(ans)[i];

  UNPROTECT(3);
}

    
int initEvents(SEXP elist, SEXP eventfunc) {
    SEXP Time, SVar, Value, Method, Type, Root;
    int i, j, isEvent = 0;

    Time = getListElement(elist, "Time");
    Root = getListElement(elist, "Root");
    if (!isNull(Root)) 
      rootevent = INTEGER(Root)[0];
    else
      rootevent = 0;
    
    if (!isNull(Time)) {
     isEvent = 1;
     Type = getListElement(elist,"Type");
     typeevent = INTEGER(Type)[0];
       
     i = LENGTH(Time);
     timeevent = (double *) R_alloc((int) i+1, sizeof(double));
     for (j = 0; j < i; j++) timeevent[j] = REAL(Time)[j];
     timeevent[i+1] = 0;
      
     if (typeevent == 1) {  
       /* specified in a data.frame */
       SVar = getListElement(elist,"SVar");
       Value = getListElement(elist,"Value");
       Method = getListElement(elist,"Method");
       
       valueevent = (double *) R_alloc((int) i, sizeof(double));
       for (j = 0; j < i; j++) valueevent[j] = REAL(Value)[j];

       svarevent = (int *) R_alloc(i, sizeof(int));
       for (j = 0; j < i; j++) svarevent[j] = INTEGER(SVar)[j]-1;

       methodevent = (int *) R_alloc(i, sizeof(int));
       for (j = 0; j < i; j++) methodevent[j] = INTEGER(Method)[j];
     } else {   
        /* a function: either R (typeevent=2) or compiled code (3)... */
        if (typeevent == 3)  {
          event_func = (event_func_type *) R_ExternalPtrAddrFn_(eventfunc);
        } else {
          event_func = C_event_func;
          R_event_func = eventfunc; 
        }
      }
      tEvent = timeevent[0];
      iEvent = 0;
      nEvent = i;
    }
    return(isEvent);
}

void updateevent(double *t, double *y, int *istate) {
    int svar, method;
    double value;
    if (tEvent == *t) {
      if (typeevent == 1) {      /* specified in a data.frame */
        do {
          svar = svarevent[iEvent];
          method = methodevent[iEvent];
          value = valueevent[iEvent];
          if (method == 1) 
            y[svar] = value;
          else if (method == 2) 
            y[svar] = y[svar] + value;
          else if (method == 3) 
            y[svar] = y[svar] * value;
          tEvent = timeevent[++iEvent]; 
        } while ((tEvent == *t) && (iEvent <= nEvent));
      } else {                      /* a function (R or compiled code) */
        event_func(&n_eq,t,y); 
        tEvent = timeevent[++iEvent]; 
      }  
      *istate = 1;
    }
}













