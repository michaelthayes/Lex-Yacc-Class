a.out: lex.yy.c y.tab.c
	g++ lex.yy.c y.tab.c
lex.yy.c: ro.l
	flex ro.l
y.tab.c: ro.y
	bison -y -d ro.y
clean:
	rm -f lex.yy.c y.tab.c y.tab.h
