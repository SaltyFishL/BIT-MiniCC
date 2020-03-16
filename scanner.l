%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    int line = 0;
    int col = 0;
%}

key_word (auto)|(break)|(case)|(char)|(const)|(continue)|(default)|(do)|(double)|(else)|(enum)|(extern)|(float)|(for)|(goto)|(if)|(inline)|(int)|(long)|(register)|(restrict)|(return)|(short)|(signed)|(sizeof)|(static)|(struct)|(switch)|(typedef)|(union)|(unsigned)|(void)|(volatile)|(while)
non_digit [a-zA-Z\_]
digit [0-9]
identifier {non_digit}[{non_digit}{digit}]*

hexadecimal_prefix 0[xX]
nonzero_digit [1-9]
octal_digit [0-7]
hexadecimal_digit [0-9a-fA-F]
decimal_constant ({nonzero_digit}{digit}*)|({digit})
octal_constant 0{octal_digit}+
hexadecimal_constant {hexadecimal_prefix}{hexadecimal_digit}+

unsigned_suffix [uU]
long_suffix [lL]
long_long_suffix (ll)|(LL)
integer_suffix {unsigned_suffix}[{long_suffix}{long_long_suffix}]|[{long_long_suffix}{long_suffix}]({unsigned_suffix}?)
integer_constant ({decimal_constant}|{octal_constant}|{hexadecimal_constant}){integer_suffix}?

sign [+-]
floating_suffix [flFL]
digit_sequence {digit}+
hexadecimal_digit_sequence {hexadecimal_digit}+
hexadecimal_fractional_constant {hexadecimal_digit_sequence}\.{hexadecimal_digit_sequence}?
exponent_part [eE]{sign}?{digit_sequence}
binary_exponent_part [pP]{sign}?{digit_sequence}
fractional_constant {digit_sequence}\.{digit_sequence}?
hexadecimal_floating_constant {hexadecimal_prefix}[{hexadecimal_fractional_constant}{hexadecimal_digit_sequence}]{binary_exponent_part}?{floating_suffix}?
decimal_floating_constant [{fractional_constant}{digit_sequence}]{exponent_part}?{floating_suffix}?
floating_constant {decimal_floating_constant}|{hexadecimal_floating_constant}

simple_escape_sequence [\'\"\?\\\a\b\f\n\r\t\v]
octal_escape_sequence \\{octal_digit}{1,3}
hexadecimal_escape_sequence \\x{hexadecimal_digit}{1,2}
universal_character_name [\u2e80-\ufffd]
escape_sequence {simple_escape_sequence}|{octal_escape_sequence}|{hexadecimal_escape_sequence}|{universal_character_name}
c_char [A-Za-z0-9!"#%&\(\)\*\+,\-\.\/:;<=>\?\[\]\^_\{\|\}~]|{escape_sequence}
c_char_sequence [c_char]+
character_constant [LuU]?\'{c_char_sequence}\'

encodeing_prefix (u8)|[uUL]
s_char [A-Za-z0-9!'#%&\(\)\*\+,\-\.\/:;<=>\?\[\]\^_\{\|\}~]|{escape_sequence}
s_char_sequence {s_char}+
string_literal "{s_char_sequence}"

operatorOrDelimiter [\[\]\(\)\{\}\.&\*\+-~!\/%<>\^\|\?:;,=#]|(->)|(\+\+)|(--)|(<<)|(>>)|(&&)|(\|\|)|(\.\.\.)|([\*\/%\+-<>=!&\^\|]=)|(<<=)|(>>=)|(##)|(<:)|(:>)|(<%)|(%>)|((%:){1,2})
%%

%%