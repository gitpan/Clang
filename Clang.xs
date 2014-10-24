#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <clang-c/Index.h>

enum CXChildVisitResult visitor(CXCursor cursor, CXCursor parent, CXClientData data) {
	SV *child;
	AV *children = data;

	CXCursor *ref = malloc(sizeof(CXCursor));
	*ref = cursor;

	child = sv_setref_pv(newSV(0), "Clang::Index::Cursor", (void *) ref);

	av_push(children, child);

	return CXChildVisit_Continue;
}

MODULE = Clang				PACKAGE = Clang::Index

CXIndex
new(class, exclude_decls)
	SV *class
	int exclude_decls

	CODE:
		RETVAL = clang_createIndex(exclude_decls, 0);

	OUTPUT:
		RETVAL

void
DESTROY(self)
	CXIndex self

	CODE:
		clang_disposeIndex(self);

CXTranslationUnit
parse(self, file, ...)
	CXIndex self
	SV *file

	CODE:
		STRLEN len;
		const char *path = SvPVbyte(file, len);
		CXTranslationUnit tu = clang_parseTranslationUnit(
			self, path, NULL, 0, NULL, 0, 0
		);

		RETVAL = tu;

	OUTPUT:
		RETVAL

MODULE = Clang				PACKAGE = Clang::Index::TUnit

CXCursor *
cursor(self)
	CXTranslationUnit self

	CODE:
		CXCursor *retval = malloc(sizeof(CXCursor));
		CXCursor cursor = clang_getTranslationUnitCursor(self);
		*retval = cursor;
		RETVAL = retval;

	OUTPUT:
		RETVAL

SV *
spelling(self)
	CXTranslationUnit self

	CODE:
		CXString spelling = clang_getTranslationUnitSpelling(self);
		RETVAL = newSVpv(clang_getCString(spelling), 0);

	OUTPUT:
		RETVAL

void
DESTROY(self)
	CXTranslationUnit self

	CODE:
		clang_disposeTranslationUnit(self);

MODULE = Clang				PACKAGE = Clang::Index::Cursor

enum CXCursorKind
kind(self)
	CXCursor *self

	CODE:
		RETVAL = clang_getCursorKind(*self);

	OUTPUT:
		RETVAL

SV *
spelling(self)
	CXCursor *self

	CODE:
		CXString spelling = clang_getCursorSpelling(*self);
		RETVAL = newSVpv(clang_getCString(spelling), 0);

	OUTPUT:
		RETVAL

SV *
displayname(self)
	CXCursor *self

	CODE:
		CXString dname = clang_getCursorDisplayName(*self);
		RETVAL = newSVpv(clang_getCString(dname), 0);

	OUTPUT:
		RETVAL

AV *
children(self)
	CXCursor *self

	CODE:
		AV *children = newAV();

		CXString spelling = clang_getCursorSpelling(*self);
		puts(clang_getCString(spelling));
		clang_visitChildren(*self, visitor, children);

		RETVAL = children;

	OUTPUT:
		RETVAL

void
location(self)
	CXCursor *self

	INIT:
		CXFile file;
		const char *filename;
		unsigned int line, column, offset;

	PPCODE:
		CXSourceLocation loc = clang_getCursorLocation(*self);

		clang_getSpellingLocation(loc, &file, &line, &column, NULL);

		filename = clang_getCString(clang_getFileName(file));

		if (filename != NULL)
			mXPUSHp(filename, strlen(filename));
		else
			mXPUSHp("", 0);

		mXPUSHi(line);
		mXPUSHi(column);

void
DESTROY(self)
	CXCursor *self

	CODE:
		free(self);

MODULE = Clang				PACKAGE = Clang::Index::CursorKind

SV *
spelling(self)
	enum CXCursorKind self

	CODE:
		CXString spelling = clang_getCursorKindSpelling(self);
		RETVAL = newSVpv(clang_getCString(spelling), 0);

	OUTPUT:
		RETVAL
