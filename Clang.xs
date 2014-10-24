#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <clang-c/Index.h>

enum CXChildVisitResult visitor(CXCursor cursor, CXCursor parent, CXClientData data) {
	SV *child;
	AV *children = data;

	CXCursor *ref = malloc(sizeof(CXCursor));
	*ref = cursor;

	child = sv_setref_pv(newSV(0), "Clang::Cursor", (void *) ref);

	av_push(children, child);

	return CXChildVisit_Continue;
}

MODULE = Clang				PACKAGE = Clang

INCLUDE: xs/Index.xs
INCLUDE: xs/TUnit.xs
INCLUDE: xs/Cursor.xs
INCLUDE: xs/CursorKind.xs
INCLUDE: xs/Type.xs
INCLUDE: xs/TypeKind.xs
