/* -*- C -*-
 * $RCSfile: PgSQL.c,v $
 * $Date: 2001/07/31 16:23:10 $
 * $Revision: 1.1.1.1 $
 * Copyright (C) 2001 Timothy H. Keitt
 */

#include <R.h>
#include <Rinternals.h>
#include <libpq-fe.h>
#include "PgSQL.h"

void
PgSQLcloseConnection(SEXP connPtr) {

  PGconn *conn = (PGconn *) R_ExternalPtrAddr(connPtr);
  if (PQstatus(conn) == CONNECTION_OK) PQfinish(conn);
  return;

}

SEXP
PgSQLconnect(SEXP connInfo) {

  PGconn *conn;
  SEXP connPtr;

  char *connInfoStr = CHAR(STRING_ELT(connInfo, 0));

  PROTECT(connInfo = coerceVector(connInfo, STRSXP));
  conn = PQconnectdb(connInfoStr);
  UNPROTECT(1);

  PROTECT(connPtr = R_MakeExternalPtr((void *) conn,
				      mkChar("PgSQL connection"),
				      R_NilValue));

  R_RegisterCFinalizer(connPtr, (R_CFinalizer_t)PgSQLcloseConnection);

  UNPROTECT(1);

  return(connPtr);

}

SEXP
PgSQLconnectionInfo(SEXP connPtr) {

  SEXP connInfo, listNames;
  PGconn *conn = (PGconn *) R_ExternalPtrAddr(connPtr);

  PROTECT(connInfo = allocVector(VECSXP, 12));
  PROTECT(listNames = allocVector(STRSXP, 12));

  SET_VECTOR_ELT(connInfo, 0, mkInteger(PQstatus(conn)));
  SET_VECTOR_ELT(listNames, 0, mkChar("status")); 

  SET_VECTOR_ELT(connInfo, 1, mkString_safe(PQerrorMessage(conn)));
  SET_VECTOR_ELT(listNames, 1, mkChar("last.message")); 

  SET_VECTOR_ELT(connInfo, 2, mkString_safe(PQdb(conn)));
  SET_VECTOR_ELT(listNames, 2, mkChar("database.name")); 

  SET_VECTOR_ELT(connInfo, 3, mkString_safe(PQhost(conn)));
  SET_VECTOR_ELT(listNames, 3, mkChar("host.name")); 

  SET_VECTOR_ELT(connInfo, 4, mkString_safe(PQoptions(conn)));
  SET_VECTOR_ELT(listNames, 4, mkChar("options")); 

  SET_VECTOR_ELT(connInfo, 5, mkString_safe(PQuser(conn)));
  SET_VECTOR_ELT(listNames, 5, mkChar("user.name")); 

  SET_VECTOR_ELT(connInfo, 6, mkString_safe(PQpass(conn)));
  SET_VECTOR_ELT(listNames, 6, mkChar("password")); 

  SET_VECTOR_ELT(connInfo, 7, mkString_safe(PQport(conn)));
  SET_VECTOR_ELT(listNames, 7, mkChar("port")); 

  SET_VECTOR_ELT(connInfo, 8, mkString_safe(PQtty(conn)));
  SET_VECTOR_ELT(listNames, 8, mkChar("tty")); 

  SET_VECTOR_ELT(connInfo, 9, mkInteger(PQsocket(conn)));
  SET_VECTOR_ELT(listNames, 9, mkChar("socket")); 

  SET_VECTOR_ELT(connInfo, 10, mkInteger(PQclientEncoding(conn)));
  SET_VECTOR_ELT(listNames, 10, mkChar("client.encoding")); 

  SET_VECTOR_ELT(connInfo, 11, mkInteger(PQbackendPID(conn)));
  SET_VECTOR_ELT(listNames, 11, mkChar("backend.pid")); 

  setAttrib(connInfo, R_NamesSymbol, listNames);

  UNPROTECT(2);
  return(connInfo);

}

void
PgSQLclearResult(SEXP resultPtr) {

  PQclear((PGresult *)R_ExternalPtrAddr(resultPtr));

}

SEXP
PgSQLsendQuery(SEXP connPtr, SEXP queryString) {

  PGresult *result;
  PGconn *conn = (PGconn *) R_ExternalPtrAddr(connPtr);
  SEXP resultPtr;

  if (PQstatus(conn) != CONNECTION_OK)
    error("No database connection");

  PROTECT(queryString = coerceVector(queryString, STRSXP));

  result = PQexec(conn, CHAR(STRING_ELT(queryString, 0)));

  if (result == NULL) error("Could not allocate result buffer");

  UNPROTECT(1);

  PROTECT(resultPtr = R_MakeExternalPtr((void *) result,
					mkChar("PgSQL result"),
					R_NilValue));

  R_RegisterCFinalizer(resultPtr, (R_CFinalizer_t)PgSQLclearResult);

  UNPROTECT(1);
  
  return(resultPtr);

}

SEXP
PgSQLresultInfo(SEXP resultPtr) {

  SEXP resultInfo, listNames;
  PGresult *result = (PGresult *) R_ExternalPtrAddr(resultPtr);
  int status = PQresultStatus(result);

  PROTECT(resultInfo = allocVector(VECSXP, 8));
  PROTECT(listNames = allocVector(STRSXP, 8));

  SET_VECTOR_ELT(resultInfo, 0, mkInteger(status));
  SET_VECTOR_ELT(listNames, 0, mkChar("status")); 

  SET_VECTOR_ELT(resultInfo, 1, mkString_safe(PQresStatus(status)));
  SET_VECTOR_ELT(listNames, 1, mkChar("status.string")); 

  SET_VECTOR_ELT(resultInfo, 2, mkString_safe(PQresultErrorMessage(result)));
  SET_VECTOR_ELT(listNames, 2, mkChar("error.message")); 

  SET_VECTOR_ELT(resultInfo, 3, mkInteger(PQntuples(result)));
  SET_VECTOR_ELT(listNames, 3, mkChar("rows")); 

  SET_VECTOR_ELT(resultInfo, 4, mkInteger(PQnfields(result)));
  SET_VECTOR_ELT(listNames, 4, mkChar("columns")); 

  SET_VECTOR_ELT(resultInfo, 5, mkLogical(PQbinaryTuples(result)));
  SET_VECTOR_ELT(listNames, 5, mkChar("is.binary")); 

  SET_VECTOR_ELT(resultInfo, 6, mkString_safe(PQcmdStatus(result)));
  SET_VECTOR_ELT(listNames, 6, mkChar("command.response")); 

  SET_VECTOR_ELT(resultInfo, 7, mkString_safe(PQcmdTuples(result)));
  SET_VECTOR_ELT(listNames, 7, mkChar("command.tuples")); 

  setAttrib(resultInfo, R_NamesSymbol, listNames);

  UNPROTECT(2);
  return(resultInfo);

}

SEXP
PgSQLcolumnInfo(SEXP resultPtr) {
  
  unsigned row, rows;
  SEXP outFrame, rowNames, colNames;
  PGresult *result = (PGresult *) R_ExternalPtrAddr(resultPtr);

  if (PQresultStatus(result) != PGRES_TUPLES_OK)
    error("Query did not produce any tuples");

  rows = PQnfields(result);

  PROTECT(outFrame = allocVector(VECSXP, 3));
  PROTECT(rowNames = allocVector(STRSXP, rows));
  SET_VECTOR_ELT(outFrame, 0, allocVector(INTSXP, rows));
  SET_VECTOR_ELT(outFrame, 1, allocVector(INTSXP, rows));
  SET_VECTOR_ELT(outFrame, 2, allocVector(INTSXP, rows));
  
  for (row = 0; row < rows; row++) {

    SET_VECTOR_ELT(rowNames, row, mkChar(PQfname(result, row)));

    INTEGER(VECTOR_ELT(outFrame, 0))[row] = (int) PQftype(result, row);
    INTEGER(VECTOR_ELT(outFrame, 1))[row] = PQfsize(result, row);
    INTEGER(VECTOR_ELT(outFrame, 2))[row] = PQfmod(result, row);

  }

  setAttrib(outFrame, R_RowNamesSymbol, rowNames);

  PROTECT(colNames = allocVector(STRSXP, 3));
  SET_VECTOR_ELT(colNames, 0, mkChar("Type"));
  SET_VECTOR_ELT(colNames, 1, mkChar("Size"));
  SET_VECTOR_ELT(colNames, 2, mkChar("Modification"));

  namesgets(outFrame, colNames);

  classgets(outFrame, mkString("data.frame"));

  UNPROTECT(3);

  return(outFrame);

}

SEXP
PgSQLgetResult(SEXP resultPtr) {

  unsigned row, col, rows, cols, type;
  SEXP tupleFrame, rowNames, column, colNames;
  PGresult *result = (PGresult *) R_ExternalPtrAddr(resultPtr);

  if (PQresultStatus(result) != PGRES_TUPLES_OK)
    error("Query did not produce any tuples");

  if (PQbinaryTuples(result)) error("Binary tuples not supported");

  rows = PQntuples(result);
  cols = PQnfields(result);

  PROTECT(tupleFrame = allocVector(VECSXP, cols));
  PROTECT(colNames = allocVector(STRSXP, cols));

  for (col = 0; col < cols; ++col) {

    SET_VECTOR_ELT(colNames, col, mkChar(PQfname(result, col)));

    type = PQftype(result, col);

    switch (type) {

    case 16:			/* bool */

      PROTECT(column = allocVector(LGLSXP, rows));
    
      for (row = 0; row < rows; ++row)
	LOGICAL(column)[row] = fetchPgLogical(result, row, col);

      break;

    case 20:			/* int8 */
    case 21:			/* int2 */
    case 23:			/* int4 */
    case 26:			/* oid */

      PROTECT(column = allocVector(INTSXP, rows));
    
      for (row = 0; row < rows; ++row)
	INTEGER(column)[row] = fetchPgInteger(result, row, col);

      break;

    case 700:			/* float4 */
    case 701:			/* float8 */
    case 1700:			/* numeric */

      PROTECT(column = allocVector(REALSXP, rows));
    
      for (row = 0; row < rows; ++row)
	REAL(column)[row] = fetchPgDouble(result, row, col);

      break;

    default:			/* all other types */

      PROTECT(column = allocVector(STRSXP, rows));
    
      for (row = 0; row < rows; ++row)
	SET_VECTOR_ELT(column, row, fetchPgString(result, row, col));

      break;

    }
    
    SET_VECTOR_ELT(tupleFrame, col, column);
    
    UNPROTECT(1);
    
  }
  
  namesgets(tupleFrame, colNames);

  PROTECT(rowNames = allocVector(STRSXP, rows));
  
  for (row = 0; row < rows; ++row)
    SET_VECTOR_ELT(rowNames, row, StringFromInteger(row+1, NULL));
  
  setAttrib(tupleFrame, R_RowNamesSymbol, rowNames);
  
  classgets(tupleFrame, mkString_safe("data.frame"));

  UNPROTECT(3);

  return(tupleFrame);

}

void
PgSQLappendData(SEXP conn, SEXP name, SEXP data) { }


