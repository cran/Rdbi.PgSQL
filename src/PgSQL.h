/* -*- C -*-
 * $RCSfile: PgSQL.h,v $
 * $Date: 2001/07/31 16:23:10 $
 * $Revision: 1.1.1.1 $
 * Copyright (C) 2001 Timothy H. Keitt
 */

static SEXP
mkInteger(int val) {
  SEXP out;
  PROTECT(out = allocVector(INTSXP, 1));
  INTEGER(out)[0] = val;
  UNPROTECT(1);
  return(out);
}

static SEXP
mkLogical(int val) {
  SEXP out;
  PROTECT(out = allocVector(LGLSXP, 1));
  LOGICAL(out)[0] = val;
  UNPROTECT(1);
  return(out);
}

static SEXP
mkString_safe(char *string) {
  if (string == NULL) string = "";
  return(mkString(string));
}

static SEXP
fetchPgString(PGresult *result, unsigned row, unsigned col) {

  char *value;

  if (PQgetisnull(result, row, col)) return(NA_STRING);

  value = PQgetvalue(result, row, col);

  return(mkChar(value));

}

static int
fetchPgInteger(PGresult *result, unsigned row, unsigned col) {

  int out, warn = 0;
  char *value;

  if (PQgetisnull(result, row, col)) return(NA_INTEGER);

  value = PQgetvalue(result, row, col);
  
  out = IntegerFromString(mkChar(value), &warn);

  CoercionWarning(warn);

  return(out);

}

static double
fetchPgDouble(PGresult *result, unsigned row, unsigned col) {

  double out;
  int warn = 0;
  char *value;

  if (PQgetisnull(result, row, col)) return(NA_INTEGER);

  value = PQgetvalue(result, row, col);

  out = RealFromString(mkChar(value), &warn);

  CoercionWarning(warn);

  return(out);

}

static int
fetchPgLogical(PGresult *result, unsigned row, unsigned col) {

  if (PQgetisnull(result, row, col)) return(NA_LOGICAL);

  if (PQgetvalue(result, row, col) == "t") return(1);

  return(0);
}

