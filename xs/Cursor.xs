MODULE = Clang				PACKAGE = Clang::Cursor

enum CXCursorKind
kind(self)
	CXCursor *self

	CODE:
		RETVAL = clang_getCursorKind(*self);

	OUTPUT:
		RETVAL

CXType *
type(self)
	CXCursor *self

	CODE:
		CXType *retval = malloc(sizeof(CXType));
		CXType type = clang_getCursorType(*self);
		*retval = type;
		RETVAL = retval;

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
