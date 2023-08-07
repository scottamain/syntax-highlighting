/* This test file tests Kate's ANTLR highlighting 
   compilable bt ANTLR although not directly:
   grammar can be alone file for both parser and lexer
   or two files
   This file is merged TestParser.g4 and TestLexer.g4
   this lines also tests regions of multiline comment
*/
//file TestParser.g4
parser grammar TestParser;

options { tokenVocab = TestLexer; }

// The main entry point for parsing a grammar.

startRule
     :  (expression | STRING)+ EOF
     ;

expression
     :  expression PLUS mulExpr
     |  expression MINUS mulExpr
     |  mulExpr
     ;

mulExpr
    :  mulExpr MUL unaryExpr
    |  mulExpr DIV unaryExpr
    |  unaryExpr
    ;

unaryExpr
    : atom
    | LPAR expression RPAR
    ;

atom
    : IDENT
    | number
    ;

number
    : INT
    | FLOAT
    ;

//================================
//file TestLexer.g4

lexer grammar TestLexer;

/*'channels' and '{' must be in one line
 to correct highlighting, highlighter can't
 recognize regular expression "(options|tokens|channels)(?=([\s]*{))"
 where apart from \s whitrspaces are end of lines
 */
channels { OFF_CHANNEL , COMMENT }


PLUS
    : '+'
    ;

MINUS
    : '-'
    ;

MUL
    : '*'
    ;

DIV
    : '/'
    ;

LPAR
    : '('
    ;

RPAR
    : ')'
    ;

IDENT
    :   Nondigit
        (   Nondigit
        |   Digit
        )*
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
NonzeroDigit
    :   [1-9]
    ;

fragment
Nondigit
    :   [a-zA-Z_]
    ;

Sign
    :   '+' | '-'
    ;

INT
    :  Sign? (NonzeroDigit Digit* | '0')
    ;

fragment
DigitSequence
    :   Digit+
    ;

fragment
ExponentPart
    :   [eE] Sign? DigitSequence
    ;

fragment
FractionalConstant
    :   DigitSequence? '.' DigitSequence
    |   DigitSequence '.'
    ;

FLOAT
    :   (FractionalConstant ExponentPart? | DigitSequence ExponentPart)
    ;


fragment
EscapeSequence
    :   '\\' ['"?abfnrtvhe\\]
    ;

//between [] is charset , test escape \
fragment
SChar
    :   ~["\\\r\n]
    |   EscapeSequence
    ;

STRING
    :   '"' SChar* '"'
    ;
