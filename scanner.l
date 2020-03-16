%{
    #include <stdio.h>
    int line = 0;
    int col = 0;
    int count = 0;
    int with_quotes = 0;
    int flag = 1;
    void print_token(char* token_type);
%}

key_word (auto)|(break)|(case)|(char)|(const)|(continue)|(default)|(do)|(double)|(else)|(enum)|(extern)|(float)|(for)|(goto)|(if)|(inline)|(int)|(long)|(register)|(restrict)|(return)|(short)|(signed)|(sizeof)|(static)|(struct)|(switch)|(typedef)|(union)|(unsigned)|(void)|(volatile)|(while)
non_digit ([a-zA-Z\_])
digit ([0-9])
identifier ({non_digit}({non_digit}|{digit})*)

hexadecimal_prefix (0[xX])
nonzero_digit ([1-9])
octal_digit ([0-7])
hexadecimal_digit ([0-9a-fA-F])
decimal_constant ({nonzero_digit}{digit}*|{digit})
octal_constant (0{octal_digit}+)
hexadecimal_constant ({hexadecimal_prefix}{hexadecimal_digit}+)

unsigned_suffix ([uU])
long_suffix ([lL])
long_long_suffix ((ll)|(LL))
integer_suffix (({unsigned_suffix}({long_suffix}|{long_long_suffix}))|(({long_long_suffix}|{long_suffix}){unsigned_suffix}?))
integer_constant ({decimal_constant}|{octal_constant}|{hexadecimal_constant}){integer_suffix}?

sign ([+-])
floating_suffix ([flFL])
digit_sequence ({digit}+)
hexadecimal_digit_sequence ({hexadecimal_digit}+)
hexadecimal_fractional_constant ({hexadecimal_digit_sequence}\.{hexadecimal_digit_sequence}?)
exponent_part ([eE]{sign}?{digit_sequence})
binary_exponent_part ([pP]{sign}?{digit_sequence})
fractional_constant ({digit_sequence}\.{digit_sequence}?)
hexadecimal_floating_constant ({hexadecimal_prefix}({hexadecimal_fractional_constant}|{hexadecimal_digit_sequence}){binary_exponent_part}?{floating_suffix}?)
decimal_floating_constant (({fractional_constant}|{digit_sequence}){exponent_part}?{floating_suffix}?)
floating_constant ({decimal_floating_constant}|{hexadecimal_floating_constant})

simple_escape_sequence ((\\')|(\\")|(\\\?)|(\\\\)|(\\a)|(\\b)|(\\f)|(\\n)|(\\r)|(\\t)|(\\v))
octal_escape_sequence (\\{octal_digit}{1,3})
hexadecimal_escape_sequence (\\x{hexadecimal_digit}{1,2})
universal_character_name ([\u2e80-\ufffd])
escape_sequence ({simple_escape_sequence}|{octal_escape_sequence}|{hexadecimal_escape_sequence}|{universal_character_name})
c_char ([A-Za-z0-9!"#%&\(\)\*\+,\-\.\/:;<=>\?\[\]\^_\{\|\}~]|{escape_sequence})
c_char_sequence ([c_char]+)
character_constant ([LuU]?'{c_char_sequence}')

encodeing_prefix ((u8)|[uUL])
s_char ([A-Za-z0-9!'#%&\(\)\*\+,\-\.\/:;<=>\?\[\]\^_\{\|\}~]|{escape_sequence})
s_char_sequence ({s_char}+)
string_literal ({encodeing_prefix}?"{s_char_sequence}")

operator_or_delimiter ((->)|(\+\+)|(--)|(<<=)|(>>=)|(<<)|(>>)|(<=)|(>=)|(==)|(!=)|(&&)|(\|\|)|(\.\.\.)|(\*=)|(\/=)|(%=)|(\+=)|(-=)|(&=)|(\^=)|(\|=)|(##)|(<:)|(:>)|(<%)|(%>)|(%:%:)|(%:)|[\[\]\(\)\{\}\.&\*-\+~!/%<>\^\|\?:;=,#])

white_space ([ \t\r])

new_line (\n)

%%

{key_word} {
    with_quotes = 1;
    print_token(yytext);
}

{identifier} {
    with_quotes = 0;
    print_token("Identifier");
}

{integer_constant} {
    with_quotes = 0;
    if(flag == 0)
    {
       print_token("integer_constant");
    }
    else
    {
        print_token("Constant");
    }
}

{floating_constant} {
    with_quotes = 0;
    if(flag == 0)
    {
       print_token("floating_constant");
    }
    else
    {
        print_token("Constant");
    }
}

{character_constant} {
    with_quotes = 0;
    if(flag == 0)
    {
       print_token("character_constant");
    }
    else
    {
        print_token("Constant");
    }
}

{string_literal} {
    with_quotes = 0;
    print_token("StringLiteral");
}

{operator_or_delimiter} {
    with_quotes = 1;
    print_token(yytext);
}

{white_space} {
    col += yyleng;
}

{new_line} {
    col = 0;
    line++;
}

%%

void print_token(char* token_type)
{
    col += yyleng;
    if(with_quotes)
    {
        printf("[@%d,%d:%d=\'%s\',<\'%s\'>,%d:%d]\n", count, col-yyleng, col-1, yytext, token_type, line+1, col-yyleng);
    }
    else
    {
        printf("[@%d,%d:%d=\'%s\',<%s>,%d:%d]\n", count, col-yyleng, col-1, yytext, token_type, line+1, col-yyleng);
    }

    count++;
}

int yywrap()
{
    return 1;
}

int main()
{
    yyin=fopen("testFile.c", "r");
    yyout = freopen("testFile.tokens", "w", stdout);
    yylex();
    fclose(yyin);
    fclose(yyout);
}