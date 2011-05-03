#include <R.h>
#include <Rdefines.h>

/*============================================================================
  global R variables 
============================================================================*/
SEXP YOUT, YOUT2, ISTATE, RWORK, IROOT;    /* returned to R */
SEXP Time, Y, YPRIME , Rin;

/*============================================================================
  global C variables 
============================================================================*/
int    it, n_eq; 
int    *iwork;   
double *rwork;
 double *xytmp, *xdytmp, tin, tout;

long int mu;
long int ml;
long int nrowpd;

/* output in DLL globals */
int nout, ntot, isOut, lrpar, lipar, *ipar;
double *out;

/* forcings  */
long int nforc;  /* the number of forcings */
double *tvec;
double *fvec;
int    *ivec;
int    fmethod;
int    finit;

int    *findex;
double *intpol;
int    *maxindex;

double *forcings;

/* events - not yet used */
double tEvent;
int iEvent, nEvent, typeevent, rootevent;

double *timeevent, *valueevent;
int *svarevent, *methodevent;

/*============================================================================
 type definitions for C functions
============================================================================*/
typedef void C_deriv_func_type(int*, double*, double*, double*, double*, int*);
C_deriv_func_type* DLL_deriv_func;

typedef void C_res_func_type(double*, double*, double*, double*, double*,
                             int*, double*, int*);
C_res_func_type* DLL_res_func;


/* this is in compiled code */
typedef void init_func_type (void (*)(int*, double*));
C_deriv_func_type *deriv_func;

double             *tt, *ytmp;
int                isDll;

/*============================================================================
  solver R- global functions 
============================================================================*/
/* DAE globals */
extern SEXP R_res_func;
extern SEXP R_daejac_func;
extern SEXP R_deriv_func;
extern SEXP R_jac_func;
extern SEXP R_mas_func;
extern SEXP R_envir;
extern SEXP R_event_func;

extern SEXP de_gparms;
SEXP getListElement(SEXP list, const char* str);

/*============================================================================ 
  C- utilities, functions 
============================================================================*/
void init_N_Protect(void);
void incr_N_Protect(void);
void unprotect_all(void);
void my_unprotect(int);
void returnearly (int);
void terminate(int, int, int, int, int);

/* declarations for initialisations */
void initParms(SEXP Initfunc, SEXP Parms);
void Initdeparms(int*, double*);
void Initdeforc(int*, double*);
void initOutR(int isDll, int neq, SEXP nOut, SEXP Rpar, SEXP Ipar);
void initOutC(int isDll, int neq, SEXP nOut, SEXP Rpar, SEXP Ipar);
void initOut(int isDll, int neq, SEXP nOut, SEXP Rpar, SEXP Ipar);

/* not yet used in mebdfi... */
void initglobals(int);
void initdaeglobals(int);

/* the forcings and event functions - latter not yet implemented */
void updatedeforc(double*);
int initForcings(SEXP list);
int initEvents(SEXP list, SEXP);
void updateevent(double*, double*, int*);



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                         DECLARATIONS for time lags
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/*==========================================
  R-functions
==========================================*/
int noff;

SEXP getPastValue   (SEXP T, SEXP nr);
SEXP getPastGradient(SEXP T, SEXP nr);

/*==========================================
  C- utilities, functions
==========================================*/
/* Hermitian interpolation */
double Hermite (double t0, double t1, double y0, double y1, double dy0,
                double dy1, double t);

double dHermite(double t0, double t1, double y0, double y1, double dy0,
                double dy1, double t);

int initLags(SEXP elag, int solver, int nroot);

/* history vectors  */
void inithist(int max, int maxlags, int solver, int nroot);

void updatehistini(double t, double *y, double *dY, double *rwork, int *iwork);
void updatehist(double t, double *y, double *dy, double *rwork, int *iwork);

int nexthist(int i);
double interpolate(int i, int k, double t0, double t1, double t,
  double *Yh, int nq);


/*==========================================
  Global variables for history arrays
==========================================*/
/* time delays */
int interpolMethod;  /* for time-delays : 1 = hermite; 2=dense */

int indexhist, indexlag, endreached, starthist;
double *histvar, *histdvar, *histtime, *histhh, *histsave;
int    *histord;
int    histsize, offset;
int    initialisehist, lyh, lhh, lo;