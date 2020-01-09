(******************************************************************************)
(*                                libPasPCRE2                                 *)
(*  object pascal wrapper around Perl-compatible Regular Expressions library  *)
(*                                   (PCRE2)                                  *)
(*                            https://www.pcre.org/                           *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpaspcre2                 ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit libpaspcre2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{$IFDEF FPC}
  {$PACKRECORDS C}
{$ENDIF}

const
  { The following option bits can be passed to pcre2_compile(), pcre2_match(),
  or pcre2_dfa_match(). PCRE2_NO_UTF_CHECK affects only the function to which it
  is passed. Put these bits at the most significant end of the options word so
  others can be added next to them }
  PCRE2_ANCHORED =                                                    $80000000;
  PCRE2_NO_UTF_CHECK =                                                $40000000;
  PCRE2_ENDANCHORED =                                                 $20000000;

  { The following option bits can be passed only to pcre2_compile(). However,
    they may affect compilation, JIT compilation, and/or interpretive execution.
    The following tags indicate which:

    C   alters what is compiled by pcre2_compile()
    J   alters what is compiled by pcre2_jit_compile()
    M   is inspected during pcre2_match() execution
    D   is inspected during pcre2_dfa_match() execution }
  PCRE2_ALLOW_EMPTY_CLASS =                               { C       } $00000001;
  PCRE2_ALT_BSUX =                                        { C       } $00000002;
  PCRE2_AUTO_CALLOUT =                                    { C       } $00000004;
  PCRE2_CASELESS =                                        { C       } $00000008;
  PCRE2_DOLLAR_ENDONLY =                                  {   J M D } $00000010;
  PCRE2_DOTALL =                                          { C       } $00000020;
  PCRE2_DUPNAMES =                                        { C       } $00000040;
  PCRE2_EXTENDED =                                        { C       } $00000080;
  PCRE2_FIRSTLINE =                                       {   J M D } $00000100;
  PCRE2_MATCH_UNSET_BACKREF =                             { C J M   } $00000200;
  PCRE2_MULTILINE =                                       { C       } $00000400;
  PCRE2_NEVER_UCP =                                       { C       } $00000800;
  PCRE2_NEVER_UTF =                                       { C       } $00001000;
  PCRE2_NO_AUTO_CAPTURE =                                 { C       } $00002000;
  PCRE2_NO_AUTO_POSSESS =                                 { C       } $00004000;
  PCRE2_NO_DOTSTAR_ANCHOR =                               { C       } $00008000;
  PCRE2_NO_START_OPTIMIZE =                               {   J M D } $00010000;
  PCRE2_UCP =                                             { C J M D } $00020000;
  PCRE2_UNGREEDY =                                        { C       } $00040000;
  PCRE2_UTF =                                             { C J M D } $00080000;
  PCRE2_NEVER_BACKSLASH_C =                               { C       } $00100000;
  PCRE2_ALT_CIRCUMFLEX =                                  {   J M D } $00200000;
  PCRE2_ALT_VERBNAMES =                                   { C       } $00400000;
  PCRE2_USE_OFFSET_LIMIT =                                {   J M D } $00800000;
  PCRE2_EXTENDED_MORE =                                   { C       } $01000000;
  PCRE2_LITERAL =                                         { C       } $02000000;

  { An additional compile options word is available in the compile context. }
  PCRE2_EXTRA_ALLOW_SURROGATE_ESCAPES =                               $00000001;
  PCRE2_EXTRA_BAD_ESCAPE_IS_LITERAL =                                 $00000002;
  PCRE2_EXTRA_MATCH_WORD =                                            $00000004;
  PCRE2_EXTRA_MATCH_LINE =                                            $00000008;

  { These are for pcre2_jit_compile(). }
  PCRE2_JIT_COMPLETE =                                                $00000001;
  PCRE2_JIT_PARTIAL_SOFT =                                            $00000002;
  PCRE2_JIT_PARTIAL_HARD =                                            $00000004;

  { These are for pcre2_match(), pcre2_dfa_match(), and pcre2_jit_match(). Note
    that PCRE2_ANCHORED and PCRE2_NO_UTF_CHECK can also be passed to these
    functions (though pcre2_jit_match() ignores the latter since it bypasses all
    sanity checks). }
  PCRE2_NOTBOL =                                                      $00000001;
  PCRE2_NOTEOL =                                                      $00000002;
  PCRE2_NOTEMPTY =           { ) These two must be kept  }            $00000004;
  PCRE2_NOTEMPTY_ATSTART =   { ) adjacent to each other. }            $00000008;
  PCRE2_PARTIAL_SOFT =                                                $00000010;
  PCRE2_PARTIAL_HARD =                                                $00000020;

  { These are additional options for pcre2_dfa_match(). }
  PCRE2_DFA_RESTART =                                                 $00000040;
  PCRE2_DFA_SHORTEST =                                                $00000080;

  { These are additional options for pcre2_substitute(), which passes any others
    through to pcre2_match(). }
  PCRE2_SUBSTITUTE_GLOBAL =                                           $00000100;
  PCRE2_SUBSTITUTE_EXTENDED =                                         $00000200;
  PCRE2_SUBSTITUTE_UNSET_EMPTY =                                      $00000400;
  PCRE2_SUBSTITUTE_UNKNOWN_UNSET =                                    $00000800;
  PCRE2_SUBSTITUTE_OVERFLOW_LENGTH =                                  $00001000;

  { A further option for pcre2_match(), not allowed for pcre2_dfa_match(),
    ignored for pcre2_jit_match(). }
  PCRE2_NO_JIT =                                                      $00002000;

  { Options for pcre2_pattern_convert(). }
  PCRE2_CONVERT_UTF =                                                 $00000001;
  PCRE2_CONVERT_NO_UTF_CHECK =                                        $00000002;
  PCRE2_CONVERT_POSIX_BASIC =                                         $00000004;
  PCRE2_CONVERT_POSIX_EXTENDED =                                      $00000008;
  PCRE2_CONVERT_GLOB =                                                $00000010;
  PCRE2_CONVERT_GLOB_NO_WILD_SEPARATOR =                              $00000030;
  PCRE2_CONVERT_GLOB_NO_STARSTAR =                                    $00000050;

  { Newline and \R settings, for use in compile contexts. The newline values
    must be kept in step with values set in config.h and both sets must all be
    greater than zero. }
  PCRE2_NEWLINE_CR =                                                  1;
  PCRE2_NEWLINE_LF =                                                  2;
  PCRE2_NEWLINE_CRLF =                                                3;
  PCRE2_NEWLINE_ANY =                                                 4;
  PCRE2_NEWLINE_ANYCRLF =                                             5;
  PCRE2_NEWLINE_NUL =                                                 6;

  PCRE2_BSR_UNICODE =                                                 1;
  PCRE2_BSR_ANYCRLF =                                                 2;

  { Error codes for pcre2_compile(). Some of these are also used by
    pcre2_pattern_convert(). }
  PCRE2_ERROR_END_BACKSLASH =                                         101;
  PCRE2_ERROR_END_BACKSLASH_C =                                       102;
  PCRE2_ERROR_UNKNOWN_ESCAPE =                                        103;
  PCRE2_ERROR_QUANTIFIER_OUT_OF_ORDER =                               104;
  PCRE2_ERROR_QUANTIFIER_TOO_BIG =                                    105;
  PCRE2_ERROR_MISSING_SQUARE_BRACKET =                                106;
  PCRE2_ERROR_ESCAPE_INVALID_IN_CLASS =                               107;
  PCRE2_ERROR_CLASS_RANGE_ORDER =                                     108;
  PCRE2_ERROR_QUANTIFIER_INVALID =                                    109;
  PCRE2_ERROR_INTERNAL_UNEXPECTED_REPEAT =                            110;
  PCRE2_ERROR_INVALID_AFTER_PARENS_QUERY =                            111;
  PCRE2_ERROR_POSIX_CLASS_NOT_IN_CLASS =                              112;
  PCRE2_ERROR_POSIX_NO_SUPPORT_COLLATING =                            113;
  PCRE2_ERROR_MISSING_CLOSING_PARENTHESIS =                           114;
  PCRE2_ERROR_BAD_SUBPATTERN_REFERENCE =                              115;
  PCRE2_ERROR_NULL_PATTERN =                                          116;
  PCRE2_ERROR_BAD_OPTIONS =                                           117;
  PCRE2_ERROR_MISSING_COMMENT_CLOSING =                               118;
  PCRE2_ERROR_PARENTHESES_NEST_TOO_DEEP =                             119;
  PCRE2_ERROR_PATTERN_TOO_LARGE =                                     120;
  PCRE2_ERROR_HEAP_FAILED =                                           121;
  PCRE2_ERROR_UNMATCHED_CLOSING_PARENTHESIS =                         122;
  PCRE2_ERROR_INTERNAL_CODE_OVERFLOW =                                123;
  PCRE2_ERROR_MISSING_CONDITION_CLOSING =                             124;
  PCRE2_ERROR_LOOKBEHIND_NOT_FIXED_LENGTH =                           125;
  PCRE2_ERROR_ZERO_RELATIVE_REFERENCE =                               126;
  PCRE2_ERROR_TOO_MANY_CONDITION_BRANCHES =                           127;
  PCRE2_ERROR_CONDITION_ASSERTION_EXPECTED =                          128;
  PCRE2_ERROR_BAD_RELATIVE_REFERENCE =                                129;
  PCRE2_ERROR_UNKNOWN_POSIX_CLASS =                                   130;
  PCRE2_ERROR_INTERNAL_STUDY_ERROR =                                  131;
  PCRE2_ERROR_UNICODE_NOT_SUPPORTED =                                 132;
  PCRE2_ERROR_PARENTHESES_STACK_CHECK =                               133;
  PCRE2_ERROR_CODE_POINT_TOO_BIG =                                    134;
  PCRE2_ERROR_LOOKBEHIND_TOO_COMPLICATED =                            135;
  PCRE2_ERROR_LOOKBEHIND_INVALID_BACKSLASH_C =                        136;
  PCRE2_ERROR_UNSUPPORTED_ESCAPE_SEQUENCE =                           137;
  PCRE2_ERROR_CALLOUT_NUMBER_TOO_BIG =                                138;
  PCRE2_ERROR_MISSING_CALLOUT_CLOSING =                               139;
  PCRE2_ERROR_ESCAPE_INVALID_IN_VERB =                                140;
  PCRE2_ERROR_UNRECOGNIZED_AFTER_QUERY_P =                            141;
  PCRE2_ERROR_MISSING_NAME_TERMINATOR =                               142;
  PCRE2_ERROR_DUPLICATE_SUBPATTERN_NAME =                             143;
  PCRE2_ERROR_INVALID_SUBPATTERN_NAME =                               144;
  PCRE2_ERROR_UNICODE_PROPERTIES_UNAVAILABLE =                        145;
  PCRE2_ERROR_MALFORMED_UNICODE_PROPERTY =                            146;
  PCRE2_ERROR_UNKNOWN_UNICODE_PROPERTY =                              147;
  PCRE2_ERROR_SUBPATTERN_NAME_TOO_LONG =                              148;
  PCRE2_ERROR_TOO_MANY_NAMED_SUBPATTERNS =                            149;
  PCRE2_ERROR_CLASS_INVALID_RANGE =                                   150;
  PCRE2_ERROR_OCTAL_BYTE_TOO_BIG =                                    151;
  PCRE2_ERROR_INTERNAL_OVERRAN_WORKSPACE =                            152;
  PCRE2_ERROR_INTERNAL_MISSING_SUBPATTERN =                           153;
  PCRE2_ERROR_DEFINE_TOO_MANY_BRANCHES =                              154;
  PCRE2_ERROR_BACKSLASH_O_MISSING_BRACE =                             155;
  PCRE2_ERROR_INTERNAL_UNKNOWN_NEWLINE =                              156;
  PCRE2_ERROR_BACKSLASH_G_SYNTAX =                                    157;
  PCRE2_ERROR_PARENS_QUERY_R_MISSING_CLOSING =                        158;
  PCRE2_ERROR_VERB_ARGUMENT_NOT_ALLOWED =                             159;
  PCRE2_ERROR_VERB_UNKNOWN =                                          160;
  PCRE2_ERROR_SUBPATTERN_NUMBER_TOO_BIG =                             161;
  PCRE2_ERROR_SUBPATTERN_NAME_EXPECTED =                              162;
  PCRE2_ERROR_INTERNAL_PARSED_OVERFLOW =                              163;
  PCRE2_ERROR_INVALID_OCTAL =                                         164;
  PCRE2_ERROR_SUBPATTERN_NAMES_MISMATCH =                             165;
  PCRE2_ERROR_MARK_MISSING_ARGUMENT =                                 166;
  PCRE2_ERROR_INVALID_HEXADECIMAL =                                   167;
  PCRE2_ERROR_BACKSLASH_C_SYNTAX =                                    168;
  PCRE2_ERROR_BACKSLASH_K_SYNTAX =                                    169;
  PCRE2_ERROR_INTERNAL_BAD_CODE_LOOKBEHINDS =                         170;
  PCRE2_ERROR_BACKSLASH_N_IN_CLASS =                                  171;
  PCRE2_ERROR_CALLOUT_STRING_TOO_LONG =                               172;
  PCRE2_ERROR_UNICODE_DISALLOWED_CODE_POINT =                         173;
  PCRE2_ERROR_UTF_IS_DISABLED =                                       174;
  PCRE2_ERROR_UCP_IS_DISABLED =                                       175;
  PCRE2_ERROR_VERB_NAME_TOO_LONG =                                    176;
  PCRE2_ERROR_BACKSLASH_U_CODE_POINT_TOO_BIG =                        177;
  PCRE2_ERROR_MISSING_OCTAL_OR_HEX_DIGITS =                           178;
  PCRE2_ERROR_VERSION_CONDITION_SYNTAX =                              179;
  PCRE2_ERROR_INTERNAL_BAD_CODE_AUTO_POSSESS =                        180;
  PCRE2_ERROR_CALLOUT_NO_STRING_DELIMITER =                           181;
  PCRE2_ERROR_CALLOUT_BAD_STRING_DELIMITER =                          182;
  PCRE2_ERROR_BACKSLASH_C_CALLER_DISABLED =                           183;
  PCRE2_ERROR_QUERY_BARJX_NEST_TOO_DEEP =                             184;
  PCRE2_ERROR_BACKSLASH_C_LIBRARY_DISABLED =                          185;
  PCRE2_ERROR_PATTERN_TOO_COMPLICATED =                               186;
  PCRE2_ERROR_LOOKBEHIND_TOO_LONG =                                   187;
  PCRE2_ERROR_PATTERN_STRING_TOO_LONG =                               188;
  PCRE2_ERROR_INTERNAL_BAD_CODE =                                     189;
  PCRE2_ERROR_INTERNAL_BAD_CODE_IN_SKIP =                             190;
  PCRE2_ERROR_NO_SURROGATES_IN_UTF16 =                                191;
  PCRE2_ERROR_BAD_LITERAL_OPTIONS =                                   192;

  { "Expected" matching error codes: no match and partial match. }
  PCRE2_ERROR_NOMATCH =                                               -1;
  PCRE2_ERROR_PARTIAL =                                               -2;

  { Error codes for UTF-8 validity checks }
  PCRE2_ERROR_UTF8_ERR1 =                                             -3;
  PCRE2_ERROR_UTF8_ERR2 =                                             -4;
  PCRE2_ERROR_UTF8_ERR3 =                                             -5;
  PCRE2_ERROR_UTF8_ERR4 =                                             -6;
  PCRE2_ERROR_UTF8_ERR5 =                                             -7;
  PCRE2_ERROR_UTF8_ERR6 =                                             -8;
  PCRE2_ERROR_UTF8_ERR7 =                                             -9;
  PCRE2_ERROR_UTF8_ERR8 =                                             -10;
  PCRE2_ERROR_UTF8_ERR9 =                                             -11;
  PCRE2_ERROR_UTF8_ERR10 =                                            -12;
  PCRE2_ERROR_UTF8_ERR11 =                                            -13;
  PCRE2_ERROR_UTF8_ERR12 =                                            -14;
  PCRE2_ERROR_UTF8_ERR13 =                                            -15;
  PCRE2_ERROR_UTF8_ERR14 =                                            -16;
  PCRE2_ERROR_UTF8_ERR15 =                                            -17;
  PCRE2_ERROR_UTF8_ERR16 =                                            -18;
  PCRE2_ERROR_UTF8_ERR17 =                                            -19;
  PCRE2_ERROR_UTF8_ERR18 =                                            -20;
  PCRE2_ERROR_UTF8_ERR19 =                                            -21;
  PCRE2_ERROR_UTF8_ERR20 =                                            -22;
  PCRE2_ERROR_UTF8_ERR21 =                                            -23;

  { Error codes for UTF-16 validity checks }
  PCRE2_ERROR_UTF16_ERR1 =                                            -24;
  PCRE2_ERROR_UTF16_ERR2 =                                            -25;
  PCRE2_ERROR_UTF16_ERR3 =                                            -26;

  { Error codes for UTF-32 validity checks }
  PCRE2_ERROR_UTF32_ERR1 =                                            -27;
  PCRE2_ERROR_UTF32_ERR2 =                                            -28;

  { Miscellaneous error codes for pcre2[_dfa]_match(), substring extraction
    functions, context functions, and serializing functions. They are in
    numerical order. Originally they were in alphabetical order too, but now
    that PCRE2 is released, the numbers must not be changed. }
  PCRE2_ERROR_BADDATA =                                               -29;
  PCRE2_ERROR_MIXEDTABLES =  { Name was changed }                     -30;
  PCRE2_ERROR_BADMAGIC =                                              -31;
  PCRE2_ERROR_BADMODE =                                               -32;
  PCRE2_ERROR_BADOFFSET =                                             -33;
  PCRE2_ERROR_BADOPTION =                                             -34;
  PCRE2_ERROR_BADREPLACEMENT =                                        -35;
  PCRE2_ERROR_BADUTFOFFSET =                                          -36;
  PCRE2_ERROR_CALLOUT =      { Never used by PCRE2 itself }           -37;
  PCRE2_ERROR_DFA_BADRESTART =                                        -38;
  PCRE2_ERROR_DFA_RECURSE =                                           -39;
  PCRE2_ERROR_DFA_UCOND =                                             -40;
  PCRE2_ERROR_DFA_UFUNC =                                             -41;
  PCRE2_ERROR_DFA_UITEM =                                             -42;
  PCRE2_ERROR_DFA_WSSIZE =                                            -43;
  PCRE2_ERROR_INTERNAL =                                              -44;
  PCRE2_ERROR_JIT_BADOPTION =                                         -45;
  PCRE2_ERROR_JIT_STACKLIMIT =                                        -46;
  PCRE2_ERROR_MATCHLIMIT =                                            -47;
  PCRE2_ERROR_NOMEMORY =                                              -48;
  PCRE2_ERROR_NOSUBSTRING =                                           -49;
  PCRE2_ERROR_NOUNIQUESUBSTRING =                                     -50;
  PCRE2_ERROR_NULL =                                                  -51;
  PCRE2_ERROR_RECURSELOOP =                                           -52;
  PCRE2_ERROR_DEPTHLIMIT =                                            -53;
  PCRE2_ERROR_RECURSIONLIMIT = { Obsolete synonym }                   -53;
  PCRE2_ERROR_UNAVAILABLE =                                           -54;
  PCRE2_ERROR_UNSET =                                                 -55;
  PCRE2_ERROR_BADOFFSETLIMIT =                                        -56;
  PCRE2_ERROR_BADREPESCAPE =                                          -57;
  PCRE2_ERROR_REPMISSINGBRACE =                                       -58;
  PCRE2_ERROR_BADSUBSTITUTION =                                       -59;
  PCRE2_ERROR_BADSUBSPATTERN =                                        -60;
  PCRE2_ERROR_TOOMANYREPLACE =                                        -61;
  PCRE2_ERROR_BADSERIALIZEDDATA =                                     -62;
  PCRE2_ERROR_HEAPLIMIT =                                             -63;
  PCRE2_ERROR_CONVERT_SYNTAX =                                        -64;

  { Request types for pcre2_pattern_info() }
  PCRE2_INFO_ALLOPTIONS =                                             0;
  PCRE2_INFO_ARGOPTIONS =                                             1;
  PCRE2_INFO_BACKREFMAX =                                             2;
  PCRE2_INFO_BSR =                                                    3;
  PCRE2_INFO_CAPTURECOUNT =                                           4;
  PCRE2_INFO_FIRSTCODEUNIT =                                          5;
  PCRE2_INFO_FIRSTCODETYPE =                                          6;
  PCRE2_INFO_FIRSTBITMAP =                                            7;
  PCRE2_INFO_HASCRORLF =                                              8;
  PCRE2_INFO_JCHANGED =                                               9;
  PCRE2_INFO_JITSIZE =                                                10;
  PCRE2_INFO_LASTCODEUNIT =                                           11;
  PCRE2_INFO_LASTCODETYPE =                                           12;
  PCRE2_INFO_MATCHEMPTY =                                             13;
  PCRE2_INFO_MATCHLIMIT =                                             14;
  PCRE2_INFO_MAXLOOKBEHIND =                                          15;
  PCRE2_INFO_MINLENGTH =                                              16;
  PCRE2_INFO_NAMECOUNT =                                              17;
  PCRE2_INFO_NAMEENTRYSIZE =                                          18;
  PCRE2_INFO_NAMETABLE =                                              19;
  PCRE2_INFO_NEWLINE =                                                20;
  PCRE2_INFO_DEPTHLIMIT =                                             21;
  PCRE2_INFO_RECURSIONLIMIT = { Obsolete synonym }                    21;
  PCRE2_INFO_SIZE =                                                   22;
  PCRE2_INFO_HASBACKSLASHC =                                          23;
  PCRE2_INFO_FRAMESIZE =                                              24;
  PCRE2_INFO_HEAPLIMIT =                                              25;
  PCRE2_INFO_EXTRAOPTIONS =                                           26;

  { Request types for pcre2_config(). }
  PCRE2_CONFIG_BSR =                                                  0;
  PCRE2_CONFIG_JIT =                                                  1;
  PCRE2_CONFIG_JITTARGET =                                            2;
  PCRE2_CONFIG_LINKSIZE =                                             3;
  PCRE2_CONFIG_MATCHLIMIT =                                           4;
  PCRE2_CONFIG_NEWLINE =                                              5;
  PCRE2_CONFIG_PARENSLIMIT =                                          6;
  PCRE2_CONFIG_DEPTHLIMIT =                                           7;
  PCRE2_CONFIG_RECURSIONLIMIT = { Obsolete synonym }                  7;
  PCRE2_CONFIG_STACKRECURSE =   { Obsolete }                          8;
  PCRE2_CONFIG_UNICODE =                                              9;
  PCRE2_CONFIG_UNICODE_VERSION =                                      10;
  PCRE2_CONFIG_VERSION =                                              11;
  PCRE2_CONFIG_HEAPLIMIT =                                            12;
  PCRE2_CONFIG_NEVER_BACKSLASH_C =                                    13;
  PCRE2_CONFIG_COMPILED_WIDTHS =                                      14;

  PCRE2_SIZE_MAX = High(QWord);
  PCRE2_ZERO_TERMINATED = not QWord(0);
  PCRE2_UNSET = not QWord(0);

  { Flags for the callout_flags field. These are cleared after a callout. }
  PCRE2_CALLOUT_STARTMATCH = { Set for each bumpalong }               $00000001;
  PCRE2_CALLOUT_BACKTRACK =  { Set after a backtrack }                $00000002;




type
  { Types for code units in patterns and subject strings. }
  PCRE2_UCHAR8 = type Byte;
  PCRE2_UCHAR16 = type Word;
  PCRE2_UCHAR32 = type Cardinal;

  PCRE2_SPTR8 = type ^PCRE2_UCHAR8;
  PCRE2_SPTR16 = type ^PCRE2_UCHAR16;
  PCRE2_SPTR32 = type ^PCRE2_UCHAR32;

  { The PCRE2_SIZE type is used for all string lengths and offsets in PCRE2,
    including pattern offsets for errors and subject offsets after a match. We
    define special values to indicate zero-terminated strings and unset offsets
    in the offset vector (ovector). }
  PPCRE2_SIZE = ^PCRE2_SIZE;
  PCRE2_SIZE = type QWord;

  { Generic types for opaque structures and JIT callback functions. }
  ppcre2_real_general_context = ^pcre2_real_general_context;
  pcre2_real_general_context = record
  end;

  ppcre2_general_context = ^pcre2_general_context;
  pcre2_general_context = pcre2_real_general_context;

  ppcre2_real_compile_context = ^pcre2_real_compile_context;
  pcre2_real_compile_context = record
  end;

  ppcre2_compile_context = ^pcre2_compile_context;
  pcre2_compile_context = pcre2_real_compile_context;

  ppcre2_real_match_context = ^pcre2_real_match_context;
  pcre2_real_match_context = record
  end;

  ppcre2_match_context = ^pcre2_match_context;
  pcre2_match_context = pcre2_real_match_context;

  ppcre2_real_convert_context = ^pcre2_real_convert_context;
  pcre2_real_convert_context = record
  end;

  ppcre2_convert_context = ^pcre2_convert_context;
  pcre2_convert_context = pcre2_real_convert_context;

  ppcre2_real_code = ^pcre2_real_code;
  pcre2_real_code = record
  end;

  ppcre2_code = ^pcre2_code;
  pcre2_code = pcre2_real_code;

  ppcre2_real_match_data = ^pcre2_real_match_data;
  pcre2_real_match_data = record
  end;

  ppcre2_match_data = ^pcre2_match_data;
  pcre2_match_data = pcre2_real_match_data;

  ppcre2_real_jit_stack = ^pcre2_real_jit_stack;
  pcre2_real_jit_stack = record
  end;

  ppcre2_jit_stack = ^pcre2_jit_stack;
  pcre2_jit_stack = pcre2_real_jit_stack;

  pcre2_jit_callback = function (ptr : Pointer) : ppcre2_jit_stack of object;

  { The structure for passing out data via the pcre_callout_function. We use a
    structure so that new fields can be added on the end in future versions,
    without changing the API of the function, thereby allowing old clients to
    work without modification. Define the generic version in a macro; the
    width-specific versions are generated from this macro below. }
  ppcre2_callout_block = ^pcre2_callout_block;
  pcre2_callout_block = record
    version : Cardinal;                 { Identifies version of block }
    { ------------------------ Version 0 ------------------------------- }
    callout_number : Cardinal;          { Number compiled into pattern }
    capture_top : Cardinal;             { Max current capture }
    capture_last : Cardinal;            { Most recently closed capture }
    offset_vector : PPCRE2_SIZE;        { The offset vector }
{?} mark : PCRE2_SPTR;                  { Pointer to current mark or NULL }
{?} subject : PCRE2_SPTR;               { The subject being matched }
    subject_length : PCRE2_SIZE;        { The length of the subject }
    start_match : PCRE2_SIZE;           { Offset to start of this match attempt}
    current_position : PCRE2_SIZE;      { Where we currently are in the subject}
    pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
    next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
    { ------------------- Added for Version 1 -------------------------- }
    callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
    callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                          pattern }
{?} callout_string : PCRE2_SPTR;        { String compiled into pattern }
    { ------------------- Added for Version 2 -------------------------- }
    callout_flags : Cardinal;           { See above for list }
    { ------------------------------------------------------------------ }
  end;

  ppcre2_callout_enumerate_block = ^pcre2_callout_enumerate_block;
  pcre2_callout_enumerate_block = record
    version : Cardinal;                 { Identifies version of block }
    { ------------------------ Version 0 ------------------------------- }
    pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
    next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
    callout_number : Cardinal;          { Number compiled into pattern }
    callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
    callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                          pattern }
    callout_string : PCRE2_SPTR;        { String compiled into pattern }
    { ------------------------------------------------------------------ }
  end;

  private_malloc_callback = function (size : PCRE2_SIZE; ptr : Pointer) :
    Pointer of object;
  private_free_callback = procedure (ptr1 : Pointer; ptr2 : Pointer) of object;
  guard_function_callback = function (value : Cardinal; ptr : Pointer) : Integer
    of object;
  callout_function_callback = function (block : ppcre2_callout_block) : Integer
    of object;
  pcre2_callout_enumerate_callback = function (block :
    ppcre2_callout_enumerate_block; data : Pointer) : Integer of object;

{$IFDEF WINDOWS}
  const PCRE2Lib = 'libpcre2.dll';
{$ENDIF}
{$IFDEF LINUX}
  const PCRE2Lib = 'libpcre2.so';
{$ENDIF}

{ List the generic forms of all other functions in macros, which will be
  expanded for each width below. Start with functions that give general
  information. }
function pcre2_config (what : Cardinal; where : Pointer) : Integer; cdecl;
  external PCRE2Lib;

{ Functions for manipulating contexts. }
function pcre2_general_context_copy (gcontext : ppcre2_general_context) :
  ppcre2_general_context; cdecl; external PCRE2Lib;
function pcre2_general_context_create (private_malloc : private_malloc_callback;
  private_free : private_free_callback; memory_data : Pointer) :
  ppcre2_general_context; cdecl; external PCRE2Lib;
procedure pcre2_general_context_free (gcontext : ppcre2_general_context); cdecl;
  external PCRE2Lib;
function pcre2_compile_context_copy (ccontext : ppcre2_compile_context) :
  ppcre2_compile_context; cdecl; external PCRE2Lib;
function pcre2_compile_context_create (gcontext : ppcre2_general_context) :
  ppcre2_compile_context; cdecl; external PCRE2Lib;
procedure pcre2_compile_context_free (ccontext : ppcre2_compile_context); cdecl;
  external PCRE2Lib;
function pcre2_set_bsr (ccontext : ppcre2_compile_context; value : Cardinal) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_set_character_tables (ccontext : ppcre2_compile_context; const
  tables : PByte) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_extra_options (ccontext : ppcre2_compile_context;
  extra_options : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_max_pattern_length (ccontext : ppcre2_compile_context;
  value : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_newline (ccontext : ppcre2_compile_context; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_parens_nest_limit (ccontext : ppcre2_compile_context; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_recursion_guard (ccontext : ppcre2_compile_context;
  guard_function : guard_function_callback; user_data : Pointer) : Integer;
  cdecl; external PCRE2Lib;

function pcre2_match_context_copy (mcontext : ppcre2_match_context) :
  ppcre2_match_context; cdecl; external PCRE2Lib;
function pcre2_match_context_create (gcontext : ppcre2_general_context) :
  ppcre2_match_context; cdecl; external PCRE2Lib;
procedure pcre2_match_context_free (mcontext : ppcre2_match_context); cdecl;
  external PCRE2Lib;
function pcre2_set_callout (mcontext : ppcre2_match_context; callout_function :
  callout_function_callback; callout_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_set_depth_limit (mcontext : ppcre2_match_context; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_heap_limit (mcontext : ppcre2_match_context; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_match_limit (mcontext : ppcre2_match_context; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_offset_limit (mcontext : ppcre2_match_context; value :
  PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_recursion_limit (mcontext : ppcre2_match_context; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_recursion_memory_management (mcontext : ppcre2_match_context;
  private_malloc : private_malloc_callback; private_free :
  private_free_callback; memory_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;

function pcre2_convert_context_copy (cvcontext : ppcre2_convert_context) :
  ppcre2_convert_context; cdecl; external PCRE2Lib;
function pcre2_convert_context_create (gcontext : ppcre2_general_context) :
  ppcre2_convert_context; cdecl; external PCRE2Lib;
procedure pcre2_convert_context_free (cvcontext : ppcre2_convert_context);
  cdecl; external PCRE2Lib;
function pcre2_set_glob_escape (cvcontext : ppcre2_convert_context;
  escape_char : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_glob_separator (cvcontext : ppcre2_convert_context;
  separator_char : Cardinal) : Integer; cdecl; external PCRE2Lib;

{ Functions concerned with compiling a pattern to PCRE internal code. }
function pcre2_compile (pattern : PCRE2_SPTR; length : PCRE2_SIZE; options :
  Cardinal; errorcode : PInteger; erroroffset : PPCRE2_SIZE; ccontext :
  ppcre2_compile_context) : ppcre2_code; cdecl; external PCRE2Lib;
procedure pcre2_code_free (code : ppcre2_code); cdecl; external PCRE2Lib;
function pcre2_code_copy (const code : ppcre2_code) : ppcre2_code; cdecl;
  external PCRE2Lib;
function pcre2_code_copy_with_tables (const code : ppcre2_code) : ppcre2_code;
  cdecl; external PCRE2Lib;

{ Functions that give information about a compiled pattern. }
function pcre2_pattern_info (const code : ppcre2_code; what : Cardinal; where :
  Pointer) : Integer; cdecl; external PCRE2Lib;
function pcre2_callout_enumerate (const code : ppcre2_code; callback :
  pcre2_callout_enumerate_callback; callout_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;

{ Functions for running a match and inspecting the result. }
function pcre2_match_data_create (ovecsize : Cardinal; gcontext :
  ppcre2_general_context) : ppcre2_match_data; cdecl; external PCRE2Lib;
function pcre2_match_data_create_from_pattern (const code : ppcre2_code;
  gcontext : ppcre2_general_context) : ppcre2_match_data; cdecl;
  external PCRE2Lib;
function pcre2_dfa_match (const code : ppcre2_code; subject : PCRE2_SPTR;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data; mcontext : ppcre2_match_context; workspace :
  PInteger; wscount : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_match (const code : ppcre2_code; subject : PCRE2_SPTR; length :
  PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal; match_data :
  ppcre2_match_data; mcontext : ppcre2_match_context) : Integer; cdecl;
  external PCRE2Lib;
procedure pcre2_match_data_free (match_data : ppcre2_match_data); cdecl;
  external PCRE2Lib;
function pcre2_get_mark (match_data : ppcre2_match_data) : PCRE2_SPTR; cdecl;
  external PCRE2Lib;
function pcre2_get_ovector_count (match_data : ppcre2_match_data) : Cardinal;
  cdecl; external PCRE2Lib;
function pcre2_get_ovector_pointer (match_data : ppcre2_match_data) :
  PPCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_startchar (match_data : ppcre2_match_data) : PCRE2_SIZE;
  cdecl; external PCRE2Lib;



implementation

end.

