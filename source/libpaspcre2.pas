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

{$IFNDEF PCRE8 AND PCRE16 AND PCRE32}
  {$DEFINE PCRE16}
{$ENDIF}

{$IFDEF WINDOWS}
  {$IFDEF PCRE8}
    const PCRE2Lib = 'libpcre2-8.dll';
  {$ENDIF}
  {$IFDEF PCRE16}
    const PCRE2Lib = 'libpcre2-16.dll';
  {$ENDIF}
  {$IFDEF PCRE32}
    const PCRE2Lib = 'libpcre2-32.dll';
  {$ENDIF}
{$ENDIF}
{$IFDEF LINUX}
  {$IFDEF PCRE8}
    const PCRE2Lib = 'libpcre2-8.so';
  {$ENDIF}
  {$IFDEF PCRE16}
    const PCRE2Lib = 'libpcre2-16.so';
  {$ENDIF}
  {$IFDEF PCRE32}
    const PCRE2Lib = 'libpcre2-32.so';
  {$ENDIF}
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
  {$IFDEF PCRE8}
    PPPPCRE2_UCHAR8 = ^PPPCRE2_UCHAR8;
    PPPCRE2_UCHAR8 = ^PPCRE2_UCHAR8;
    PPCRE2_UCHAR8 = ^PCRE2_UCHAR8;
    PCRE2_UCHAR8 = type Byte;
  {$ENDIF}
  {$IFDEF PCRE16}
    PPPPCRE2_UCHAR16 = ^PPPCRE2_UCHAR16;
    PPPCRE2_UCHAR16 = ^PPCRE2_UCHAR16;
    PPCRE2_UCHAR16 = ^PCRE2_UCHAR16;
    PCRE2_UCHAR16 = type Word;
  {$ENDIF}
  {$IFDEF PCRE32}
    PPPPCRE2_UCHAR32 = ^PPPCRE2_UCHAR32;
    PPPCRE2_UCHAR32 = ^PPCRE2_UCHAR32;
    PPCRE2_UCHAR32 = ^PCRE2_UCHAR32;
    PCRE2_UCHAR32 = type Cardinal;
  {$ENDIF}

  {$IFDEF PCRE8}
    PPCRE2_SPTR8 = ^PCRE2_SPTR8;
    PCRE2_SPTR8 = type ^PCRE2_UCHAR8;
  {$ENDIF}
  {$IFDEF PCRE16}
    PPCRE2_SPTR16 = ^PCRE2_SPTR16;
    PCRE2_SPTR16 = type ^PCRE2_UCHAR16;
  {$ENDIF}
  {$IFDEF PCRE32}
    PPCRE2_SPTR32 = ^PCRE2_SPTR32;
    PCRE2_SPTR32 = type ^PCRE2_UCHAR32;
  {$ENDIF}

  { The PCRE2_SIZE type is used for all string lengths and offsets in PCRE2,
    including pattern offsets for errors and subject offsets after a match. We
    define special values to indicate zero-terminated strings and unset offsets
    in the offset vector (ovector). }
  PPPCRE2_SIZE = ^PPCRE2_SIZE;
  PPCRE2_SIZE = ^PCRE2_SIZE;
  PCRE2_SIZE = type QWord;

  { Generic types for opaque structures and JIT callback functions. }
  {$IFDEF PCRE8}
    ppcre2_real_general_context_8 = ^pcre2_real_general_context_8;
    pcre2_real_general_context_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_general_context_16 = ^pcre2_real_general_context_16;
    pcre2_real_general_context_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_general_context_32 = ^pcre2_real_general_context_32;
    pcre2_real_general_context_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_general_context_8 = ^pcre2_general_context_8;
    pcre2_general_context_8 = pcre2_real_general_context_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_general_context_16 = ^pcre2_general_context_16;
    pcre2_general_context_16 = pcre2_real_general_context_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_general_context_32 = ^pcre2_general_context_32;
    pcre2_general_context_32 = pcre2_real_general_context_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_real_compile_context_8 = ^pcre2_real_compile_context_8;
    pcre2_real_compile_context_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_compile_context_16 = ^pcre2_real_compile_context_16;
    pcre2_real_compile_context_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_compile_context_32 = ^pcre2_real_compile_context_32;
    pcre2_real_compile_context_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_compile_context_8 = ^pcre2_compile_context_8;
    pcre2_compile_context_8 = pcre2_real_compile_context_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_compile_context_16 = ^pcre2_compile_context_16;
    pcre2_compile_context_16 = pcre2_real_compile_context_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_compile_context_32 = ^pcre2_compile_context_32;
    pcre2_compile_context_32 = pcre2_real_compile_context_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_real_match_context_8 = ^pcre2_real_match_context_8;
    pcre2_real_match_context_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_match_context_16 = ^pcre2_real_match_context_16;
    pcre2_real_match_context_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_match_context_32 = ^pcre2_real_match_context_32;
    pcre2_real_match_context_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_match_context_8 = ^pcre2_match_context_8;
    pcre2_match_context_8 = pcre2_real_match_context_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_match_context_16 = ^pcre2_match_context_16;
    pcre2_match_context_16 = pcre2_real_match_context_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_match_context_32 = ^pcre2_match_context_32;
    pcre2_match_context_32 = pcre2_real_match_context_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_real_convert_context_8 = ^pcre2_real_convert_context_8;
    pcre2_real_convert_context_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_convert_context_16 = ^pcre2_real_convert_context_16;
    pcre2_real_convert_context_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_convert_context_32 = ^pcre2_real_convert_context_32;
    pcre2_real_convert_context_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_convert_context_8 = ^pcre2_convert_context_8;
    pcre2_convert_context_8 = pcre2_real_convert_context_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_convert_context_16 = ^pcre2_convert_context_16;
    pcre2_convert_context_16 = pcre2_real_convert_context_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_convert_context_32 = ^pcre2_convert_context_32;
    pcre2_convert_context_32 = pcre2_real_convert_context_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_real_code_8 = ^pcre2_real_code_8;
    pcre2_real_code_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_code_16 = ^pcre2_real_code_16;
    pcre2_real_code_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_code_32 = ^pcre2_real_code_32;
    pcre2_real_code_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    pppcre2_code_8 = ^ppcre2_code_8;
    ppcre2_code_8 = ^pcre2_code_8;
    pcre2_code_8 = pcre2_real_code_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    pppcre2_code_16 = ^ppcre2_code_16;
    ppcre2_code_16 = ^pcre2_code_16;
    pcre2_code_16 = pcre2_real_code_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    pppcre2_code_32 = ^ppcre2_code_32;
    ppcre2_code_32 = ^pcre2_code_32;
    pcre2_code_32 = pcre2_real_code_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_real_match_data_8 = ^pcre2_real_match_data_8;
    pcre2_real_match_data_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_match_data_16 = ^pcre2_real_match_data_16;
    pcre2_real_match_data_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_match_data_32 = ^pcre2_real_match_data_32;
    pcre2_real_match_data_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_match_data_8 = ^pcre2_match_data_8;
    pcre2_match_data_8 = pcre2_real_match_data_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_match_data_16 = ^pcre2_match_data_16;
    pcre2_match_data_16 = pcre2_real_match_data_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_match_data_32 = ^pcre2_match_data_32;
    pcre2_match_data_32 = pcre2_real_match_data_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_real_jit_stack_8 = ^pcre2_real_jit_stack_8;
    pcre2_real_jit_stack_8 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_real_jit_stack_16 = ^pcre2_real_jit_stack_16;
    pcre2_real_jit_stack_16 = type Pointer;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_real_jit_stack_32 = ^pcre2_real_jit_stack_32;
    pcre2_real_jit_stack_32 = type Pointer;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_jit_stack_8 = ^pcre2_jit_stack_8;
    pcre2_jit_stack_8 = pcre2_real_jit_stack_8;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_jit_stack_16 = ^pcre2_jit_stack_16;
    pcre2_jit_stack_16 = pcre2_real_jit_stack_16;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_jit_stack_32 = ^pcre2_jit_stack_32;
    pcre2_jit_stack_32 = pcre2_real_jit_stack_32;
  {$ENDIF}

  {$IFDEF PCRE8}
    pcre2_jit_callback_8 = function (ptr : Pointer) : ppcre2_jit_stack_8
      of object;
  {$ENDIF}
  {$IFDEF PCRE16}
    pcre2_jit_callback_16 = function (ptr : Pointer) : ppcre2_jit_stack_16
      of object;
  {$ENDIF}
  {$IFDEF PCRE32}
    pcre2_jit_callback_32 = function (ptr : Pointer) : ppcre2_jit_stack_32
      of object;
  {$ENDIF}

  { The structure for passing out data via the pcre_callout_function. We use a
    structure so that new fields can be added on the end in future versions,
    without changing the API of the function, thereby allowing old clients to
    work without modification. Define the generic version in a macro; the
    width-specific versions are generated from this macro below. }
  {$IFDEF PCRE8}
    ppcre2_callout_block_8 = ^pcre2_callout_block_8;
    pcre2_callout_block_8 = record
      version : Cardinal;                 { Identifies version of block }
      { ------------------------ Version 0 ------------------------------- }
      callout_number : Cardinal;          { Number compiled into pattern }
      capture_top : Cardinal;             { Max current capture }
      capture_last : Cardinal;            { Most recently closed capture }
      offset_vector : PPCRE2_SIZE;        { The offset vector }
      mark : PCRE2_SPTR8;                 { Pointer to current mark or NULL }
      subject : PCRE2_SPTR8;              { The subject being matched }
      subject_length : PCRE2_SIZE;        { The length of the subject }
      start_match : PCRE2_SIZE;         { Offset to start of this match attempt}
      current_position : PCRE2_SIZE;    { Where we currently are in the subject}
      pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
      next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
      { ------------------- Added for Version 1 -------------------------- }
      callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
      callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                            pattern }
      callout_string : PCRE2_SPTR8;       { String compiled into pattern }
      { ------------------- Added for Version 2 -------------------------- }
      callout_flags : Cardinal;           { See above for list }
      { ------------------------------------------------------------------ }
    end;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_callout_block_16 = ^pcre2_callout_block_16;
    pcre2_callout_block_16 = record
      version : Cardinal;                 { Identifies version of block }
      { ------------------------ Version 0 ------------------------------- }
      callout_number : Cardinal;          { Number compiled into pattern }
      capture_top : Cardinal;             { Max current capture }
      capture_last : Cardinal;            { Most recently closed capture }
      offset_vector : PPCRE2_SIZE;        { The offset vector }
      mark : PCRE2_SPTR16;                { Pointer to current mark or NULL }
      subject : PCRE2_SPTR16;             { The subject being matched }
      subject_length : PCRE2_SIZE;        { The length of the subject }
      start_match : PCRE2_SIZE;         { Offset to start of this match attempt}
      current_position : PCRE2_SIZE;    { Where we currently are in the subject}
      pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
      next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
      { ------------------- Added for Version 1 -------------------------- }
      callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
      callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                            pattern }
      callout_string : PCRE2_SPTR16;      { String compiled into pattern }
      { ------------------- Added for Version 2 -------------------------- }
      callout_flags : Cardinal;           { See above for list }
      { ------------------------------------------------------------------ }
    end;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_callout_block_32 = ^pcre2_callout_block_32;
    pcre2_callout_block_32 = record
      version : Cardinal;                 { Identifies version of block }
      { ------------------------ Version 0 ------------------------------- }
      callout_number : Cardinal;          { Number compiled into pattern }
      capture_top : Cardinal;             { Max current capture }
      capture_last : Cardinal;            { Most recently closed capture }
      offset_vector : PPCRE2_SIZE;        { The offset vector }
      mark : PCRE2_SPTR32;                { Pointer to current mark or NULL }
      subject : PCRE2_SPTR32;             { The subject being matched }
      subject_length : PCRE2_SIZE;        { The length of the subject }
      start_match : PCRE2_SIZE;         { Offset to start of this match attempt}
      current_position : PCRE2_SIZE;    { Where we currently are in the subject}
      pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
      next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
      { ------------------- Added for Version 1 -------------------------- }
      callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
      callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                            pattern }
      callout_string : PCRE2_SPTR32;      { String compiled into pattern }
      { ------------------- Added for Version 2 -------------------------- }
      callout_flags : Cardinal;           { See above for list }
      { ------------------------------------------------------------------ }
    end;
  {$ENDIF}

  {$IFDEF PCRE8}
    ppcre2_callout_enumerate_block_8 = ^pcre2_callout_enumerate_block_8;
    pcre2_callout_enumerate_block_8 = record
      version : Cardinal;                 { Identifies version of block }
      { ------------------------ Version 0 ------------------------------- }
      pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
      next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
      callout_number : Cardinal;          { Number compiled into pattern }
      callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
      callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                            pattern }
      callout_string : PCRE2_SPTR8;       { String compiled into pattern }
      { ------------------------------------------------------------------ }
    end;
  {$ENDIF}
  {$IFDEF PCRE16}
    ppcre2_callout_enumerate_block_16 = ^pcre2_callout_enumerate_block_16;
    pcre2_callout_enumerate_block_16 = record
      version : Cardinal;                 { Identifies version of block }
      { ------------------------ Version 0 ------------------------------- }
      pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
      next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
      callout_number : Cardinal;          { Number compiled into pattern }
      callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
      callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                            pattern }
      callout_string : PCRE2_SPTR16;      { String compiled into pattern }
      { ------------------------------------------------------------------ }
    end;
  {$ENDIF}
  {$IFDEF PCRE32}
    ppcre2_callout_enumerate_block_32 = ^pcre2_callout_enumerate_block_32;
    pcre2_callout_enumerate_block_32 = record
      version : Cardinal;                 { Identifies version of block }
      { ------------------------ Version 0 ------------------------------- }
      pattern_position : PCRE2_SIZE;      { Offset to next item in the pattern }
      next_item_length : PCRE2_SIZE;      { Length of next item in the pattern }
      callout_number : Cardinal;          { Number compiled into pattern }
      callout_string_offset : PCRE2_SIZE; { Offset to string within pattern }
      callout_string_length : PCRE2_SIZE; { Length of string compiled into
                                            pattern }
      callout_string : PCRE2_SPTR32;      { String compiled into pattern }
      { ------------------------------------------------------------------ }
    end;
  {$ENDIF}

  private_malloc_callback = function (size : PCRE2_SIZE; ptr : Pointer) :
    Pointer of object;
  private_free_callback = procedure (ptr1 : Pointer; ptr2 : Pointer) of object;
  guard_function_callback = function (value : Cardinal; ptr : Pointer) : Integer
    of object;

  {$IFDEF PCRE8}
    callout_function_callback_8 = function (block : ppcre2_callout_block_8) :
      Integer of object;
    pcre2_callout_enumerate_callback_8 = function (block :
      ppcre2_callout_enumerate_block_8; data : Pointer) : Integer of object;
  {$ENDIF}
  {$IFDEF PCRE16}
    callout_function_callback_16 = function (block : ppcre2_callout_block_16) :
      Integer of object;
    pcre2_callout_enumerate_callback_16 = function (block :
      ppcre2_callout_enumerate_block_16; data : Pointer) : Integer of object;
  {$ENDIF}
  {$IFDEF PCRE32}
    callout_function_callback_32 = function (block : ppcre2_callout_block_32) :
      Integer of object;
    pcre2_callout_enumerate_callback_32 = function (block :
      ppcre2_callout_enumerate_block_32; data : Pointer) : Integer of object;
  {$ENDIF}

{ List the generic forms of all other functions in macros, which will be
  expanded for each width below. Start with functions that give general
  information. }
function pcre2_config_8 (what : Cardinal; where : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_config_16 (what : Cardinal; where : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_config_32 (what : Cardinal; where : Pointer) : Integer; cdecl;
  external PCRE2Lib;

{ Functions for manipulating contexts. }
function pcre2_general_context_copy_8 (gcontext : ppcre2_general_context_8) :
  ppcre2_general_context_8; cdecl; external PCRE2Lib;
function pcre2_general_context_copy_16 (gcontext : ppcre2_general_context_16) :
  ppcre2_general_context_16; cdecl; external PCRE2Lib;
function pcre2_general_context_copy_32 (gcontext : ppcre2_general_context_32) :
  ppcre2_general_context_32; cdecl; external PCRE2Lib;
function pcre2_general_context_create_8 (private_malloc :
  private_malloc_callback; private_free : private_free_callback; memory_data :
  Pointer) : ppcre2_general_context_8; cdecl; external PCRE2Lib;
function pcre2_general_context_create_16 (private_malloc :
  private_malloc_callback; private_free : private_free_callback; memory_data :
  Pointer) : ppcre2_general_context_16; cdecl; external PCRE2Lib;
function pcre2_general_context_create_32 (private_malloc :
  private_malloc_callback; private_free : private_free_callback; memory_data :
  Pointer) : ppcre2_general_context_32; cdecl; external PCRE2Lib;
procedure pcre2_general_context_free_8 (gcontext : ppcre2_general_context_8);
  cdecl; external PCRE2Lib;
procedure pcre2_general_context_free_16 (gcontext : ppcre2_general_context_16);
  cdecl; external PCRE2Lib;
procedure pcre2_general_context_free_32 (gcontext : ppcre2_general_context_32);
  cdecl; external PCRE2Lib;
function pcre2_compile_context_copy_8 (ccontext : ppcre2_compile_context_8) :
  ppcre2_compile_context_8; cdecl; external PCRE2Lib;
function pcre2_compile_context_copy_16 (ccontext : ppcre2_compile_context_16) :
  ppcre2_compile_context_16; cdecl; external PCRE2Lib;
function pcre2_compile_context_copy_32 (ccontext : ppcre2_compile_context_32) :
  ppcre2_compile_context_32; cdecl; external PCRE2Lib;
function pcre2_compile_context_create_8 (gcontext : ppcre2_general_context_8) :
  ppcre2_compile_context_8; cdecl; external PCRE2Lib;
function pcre2_compile_context_create_16 (gcontext : ppcre2_general_context_16)
  : ppcre2_compile_context_16; cdecl; external PCRE2Lib;
function pcre2_compile_context_create_32 (gcontext : ppcre2_general_context_32)
  : ppcre2_compile_context_32; cdecl; external PCRE2Lib;
procedure pcre2_compile_context_free_8 (ccontext : ppcre2_compile_context_8);
  cdecl; external PCRE2Lib;
procedure pcre2_compile_context_free_16 (ccontext : ppcre2_compile_context_16);
  cdecl; external PCRE2Lib;
procedure pcre2_compile_context_free_32 (ccontext : ppcre2_compile_context_32);
  cdecl; external PCRE2Lib;
function pcre2_set_bsr_8 (ccontext : ppcre2_compile_context_8; value : Cardinal)
  : Integer; cdecl; external PCRE2Lib;
function pcre2_set_bsr_16 (ccontext : ppcre2_compile_context_16; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_bsr_32 (ccontext : ppcre2_compile_context_32; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_character_tables_8 (ccontext : ppcre2_compile_context_8;
  const tables : PByte) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_character_tables_16 (ccontext : ppcre2_compile_context_16;
  const tables : PByte) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_character_tables_32 (ccontext : ppcre2_compile_context_32;
  const tables : PByte) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_extra_options_8 (ccontext : ppcre2_compile_context_8;
  extra_options : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_extra_options_16 (ccontext :
  ppcre2_compile_context_16; extra_options : Cardinal) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_set_compile_extra_options_32 (ccontext :
  ppcre2_compile_context_32; extra_options : Cardinal) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_set_max_pattern_length_8 (ccontext : ppcre2_compile_context_8;
  value : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_max_pattern_length_16 (ccontext : ppcre2_compile_context_16;
  value : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_max_pattern_length_32 (ccontext : ppcre2_compile_context_32;
  value : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_newline_8 (ccontext : ppcre2_compile_context_8; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_newline_16 (ccontext : ppcre2_compile_context_16; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_newline_32 (ccontext : ppcre2_compile_context_32; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_parens_nest_limit_8 (ccontext : ppcre2_compile_context_8;
  value : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_parens_nest_limit_16 (ccontext : ppcre2_compile_context_16;
  value : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_parens_nest_limit_32 (ccontext : ppcre2_compile_context_32;
  value : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_recursion_guard_8 (ccontext :
  ppcre2_compile_context_8; guard_function : guard_function_callback;
  user_data : Pointer) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_recursion_guard_16 (ccontext :
  ppcre2_compile_context_16; guard_function : guard_function_callback;
  user_data : Pointer) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_compile_recursion_guard_32 (ccontext :
  ppcre2_compile_context_32; guard_function : guard_function_callback;
  user_data : Pointer) : Integer; cdecl; external PCRE2Lib;

function pcre2_match_context_copy_8 (mcontext : ppcre2_match_context_8) :
  ppcre2_match_context_8; cdecl; external PCRE2Lib;
function pcre2_match_context_copy_16 (mcontext : ppcre2_match_context_16) :
  ppcre2_match_context_16; cdecl; external PCRE2Lib;
function pcre2_match_context_copy_32 (mcontext : ppcre2_match_context_32) :
  ppcre2_match_context_32; cdecl; external PCRE2Lib;
function pcre2_match_context_create_8 (gcontext : ppcre2_general_context_8) :
  ppcre2_match_context_8; cdecl; external PCRE2Lib;
function pcre2_match_context_create_16 (gcontext : ppcre2_general_context_16) :
  ppcre2_match_context_16; cdecl; external PCRE2Lib;
function pcre2_match_context_create_32 (gcontext : ppcre2_general_context_32) :
  ppcre2_match_context_32; cdecl; external PCRE2Lib;
procedure pcre2_match_context_free_8 (mcontext : ppcre2_match_context_8); cdecl;
  external PCRE2Lib;
procedure pcre2_match_context_free_16 (mcontext : ppcre2_match_context_16);
  cdecl; external PCRE2Lib;
procedure pcre2_match_context_free_32 (mcontext : ppcre2_match_context_32);
  cdecl; external PCRE2Lib;
function pcre2_set_callout_8 (mcontext : ppcre2_match_context_8;
  callout_function : callout_function_callback_8; callout_data : Pointer) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_set_callout_16 (mcontext : ppcre2_match_context_16;
  callout_function : callout_function_callback_16; callout_data : Pointer) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_set_callout_32 (mcontext : ppcre2_match_context_32;
  callout_function : callout_function_callback_32; callout_data : Pointer) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_set_depth_limit_8 (mcontext : ppcre2_match_context_8; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_depth_limit_16 (mcontext : ppcre2_match_context_16; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_depth_limit_32 (mcontext : ppcre2_match_context_32; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_heap_limit_8 (mcontext : ppcre2_match_context_8; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_heap_limit_16 (mcontext : ppcre2_match_context_16; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_heap_limit_32 (mcontext : ppcre2_match_context_32; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_match_limit_8 (mcontext : ppcre2_match_context_8; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_match_limit_16 (mcontext : ppcre2_match_context_16; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_match_limit_32 (mcontext : ppcre2_match_context_32; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_offset_limit_8 (mcontext : ppcre2_match_context_8; value :
  PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_offset_limit_16 (mcontext : ppcre2_match_context_16; value :
  PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_offset_limit_32 (mcontext : ppcre2_match_context_32; value :
  PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_recursion_limit_8 (mcontext : ppcre2_match_context_8; value :
  Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_recursion_limit_16 (mcontext : ppcre2_match_context_16;
  value : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_recursion_limit_32 (mcontext : ppcre2_match_context_32;
  value : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_recursion_memory_management_8 (mcontext :
  ppcre2_match_context_8; private_malloc : private_malloc_callback;
  private_free : private_free_callback; memory_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_set_recursion_memory_management_16 (mcontext :
  ppcre2_match_context_16; private_malloc : private_malloc_callback;
  private_free : private_free_callback; memory_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_set_recursion_memory_management_32 (mcontext :
  ppcre2_match_context_32; private_malloc : private_malloc_callback;
  private_free : private_free_callback; memory_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;

function pcre2_convert_context_copy_8 (cvcontext : ppcre2_convert_context_8) :
  ppcre2_convert_context_8; cdecl; external PCRE2Lib;
function pcre2_convert_context_copy_16 (cvcontext : ppcre2_convert_context_16) :
  ppcre2_convert_context_16; cdecl; external PCRE2Lib;
function pcre2_convert_context_copy_32 (cvcontext : ppcre2_convert_context_32) :
  ppcre2_convert_context_32; cdecl; external PCRE2Lib;
function pcre2_convert_context_create_8 (gcontext : ppcre2_general_context_8) :
  ppcre2_convert_context_8; cdecl; external PCRE2Lib;
function pcre2_convert_context_create_16 (gcontext : ppcre2_general_context_16)
  : ppcre2_convert_context_16; cdecl; external PCRE2Lib;
function pcre2_convert_context_create_32 (gcontext : ppcre2_general_context_32)
  : ppcre2_convert_context_32; cdecl; external PCRE2Lib;
procedure pcre2_convert_context_free_8 (cvcontext : ppcre2_convert_context_8);
  cdecl; external PCRE2Lib;
procedure pcre2_convert_context_free_16 (cvcontext : ppcre2_convert_context_16);
  cdecl; external PCRE2Lib;
procedure pcre2_convert_context_free_32 (cvcontext : ppcre2_convert_context_32);
  cdecl; external PCRE2Lib;
function pcre2_set_glob_escape_8 (cvcontext : ppcre2_convert_context_8;
  escape_char : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_glob_escape_16 (cvcontext : ppcre2_convert_context_16;
  escape_char : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_glob_escape_32 (cvcontext : ppcre2_convert_context_32;
  escape_char : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_glob_separator_8 (cvcontext : ppcre2_convert_context_8;
  separator_char : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_glob_separator_16 (cvcontext : ppcre2_convert_context_16;
  separator_char : Cardinal) : Integer; cdecl; external PCRE2Lib;
function pcre2_set_glob_separator_32 (cvcontext : ppcre2_convert_context_32;
  separator_char : Cardinal) : Integer; cdecl; external PCRE2Lib;

{ Functions concerned with compiling a pattern to PCRE internal code. }
function pcre2_compile_8 (pattern : PCRE2_SPTR8; length : PCRE2_SIZE; options :
  Cardinal; errorcode : PInteger; erroroffset : PPCRE2_SIZE; ccontext :
  ppcre2_compile_context_8) : ppcre2_code_8; cdecl; external PCRE2Lib;
function pcre2_compile_16 (pattern : PCRE2_SPTR16; length : PCRE2_SIZE; options
  : Cardinal; errorcode : PInteger; erroroffset : PPCRE2_SIZE; ccontext :
  ppcre2_compile_context_16) : ppcre2_code_16; cdecl; external PCRE2Lib;
function pcre2_compile_32 (pattern : PCRE2_SPTR32; length : PCRE2_SIZE; options
  : Cardinal; errorcode : PInteger; erroroffset : PPCRE2_SIZE; ccontext :
  ppcre2_compile_context_32) : ppcre2_code_32; cdecl; external PCRE2Lib;
procedure pcre2_code_free_8 (code : ppcre2_code_8); cdecl; external PCRE2Lib;
procedure pcre2_code_free_16 (code : ppcre2_code_16); cdecl; external PCRE2Lib;
procedure pcre2_code_free_32 (code : ppcre2_code_32); cdecl; external PCRE2Lib;
function pcre2_code_copy_8 (const code : ppcre2_code_8) : ppcre2_code_8; cdecl;
  external PCRE2Lib;
function pcre2_code_copy_16 (const code : ppcre2_code_16) : ppcre2_code_16;
  cdecl; external PCRE2Lib;
function pcre2_code_copy_32 (const code : ppcre2_code_32) : ppcre2_code_32;
  cdecl; external PCRE2Lib;
function pcre2_code_copy_with_tables_8 (const code : ppcre2_code_8) :
  ppcre2_code_8; cdecl; external PCRE2Lib;
function pcre2_code_copy_with_tables_16 (const code : ppcre2_code_16) :
  ppcre2_code_16; cdecl; external PCRE2Lib;

{ Functions that give information about a compiled pattern. }
function pcre2_pattern_info_8 (const code : ppcre2_code_8; what : Cardinal;
  where : Pointer) : Integer; cdecl; external PCRE2Lib;
function pcre2_pattern_info_16 (const code : ppcre2_code_16; what : Cardinal;
  where : Pointer) : Integer; cdecl; external PCRE2Lib;
function pcre2_pattern_info_32 (const code : ppcre2_code_32; what : Cardinal;
  where : Pointer) : Integer; cdecl; external PCRE2Lib;
function pcre2_callout_enumerate_8 (const code : ppcre2_code_8; callback :
  pcre2_callout_enumerate_callback_8; callout_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_callout_enumerate_16 (const code : ppcre2_code_16; callback :
  pcre2_callout_enumerate_callback_16; callout_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_callout_enumerate_32 (const code : ppcre2_code_32; callback :
  pcre2_callout_enumerate_callback_32; callout_data : Pointer) : Integer; cdecl;
  external PCRE2Lib;

{ Functions for running a match and inspecting the result. }
function pcre2_match_data_create_8 (ovecsize : Cardinal; gcontext :
  ppcre2_general_context_8) : ppcre2_match_data_8; cdecl; external PCRE2Lib;
function pcre2_match_data_create_16 (ovecsize : Cardinal; gcontext :
  ppcre2_general_context_16) : ppcre2_match_data_16; cdecl; external PCRE2Lib;
function pcre2_match_data_create_32 (ovecsize : Cardinal; gcontext :
  ppcre2_general_context_32) : ppcre2_match_data_32; cdecl; external PCRE2Lib;
function pcre2_match_data_create_from_pattern_8 (const code : ppcre2_code_8;
  gcontext : ppcre2_general_context_8) : ppcre2_match_data_8; cdecl;
  external PCRE2Lib;
function pcre2_match_data_create_from_pattern_16 (const code : ppcre2_code_16;
  gcontext : ppcre2_general_context_16) : ppcre2_match_data_16; cdecl;
  external PCRE2Lib;
function pcre2_match_data_create_from_pattern_32 (const code : ppcre2_code_32;
  gcontext : ppcre2_general_context_32) : ppcre2_match_data_32; cdecl;
  external PCRE2Lib;
function pcre2_dfa_match_8 (const code : ppcre2_code_8; subject : PCRE2_SPTR8;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data_8; mcontext : ppcre2_match_context_8;
  workspace : PInteger; wscount : PCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_dfa_match_16 (const code : ppcre2_code_16; subject :
  PCRE2_SPTR16; length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options :
  Cardinal; match_data : ppcre2_match_data_16; mcontext :
  ppcre2_match_context_16; workspace : PInteger; wscount : PCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_dfa_match_32 (const code : ppcre2_code_32; subject :
  PCRE2_SPTR32; length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options :
  Cardinal; match_data : ppcre2_match_data_32; mcontext :
  ppcre2_match_context_32; workspace : PInteger; wscount : PCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_match_8 (const code : ppcre2_code_8; subject : PCRE2_SPTR8;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data_8; mcontext : ppcre2_match_context_8) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_match_16 (const code : ppcre2_code_16; subject : PCRE2_SPTR16;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data_16; mcontext : ppcre2_match_context_16) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_match_32 (const code : ppcre2_code_32; subject : PCRE2_SPTR32;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data_32; mcontext : ppcre2_match_context_32) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_get_match_data_size_8 (match_data : ppcre2_match_data_8) :
  PCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_match_data_size_16 (match_data : ppcre2_match_data_16) :
  PCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_match_data_size_32 (match_data : ppcre2_match_data_32) :
  PCRE2_SIZE; cdecl; external PCRE2Lib;
procedure pcre2_match_data_free_8 (match_data : ppcre2_match_data_8); cdecl;
  external PCRE2Lib;
procedure pcre2_match_data_free_16 (match_data : ppcre2_match_data_16); cdecl;
  external PCRE2Lib;
procedure pcre2_match_data_free_32 (match_data : ppcre2_match_data_32); cdecl;
  external PCRE2Lib;
function pcre2_get_mark_8 (match_data : ppcre2_match_data_8) : PCRE2_SPTR8;
  cdecl; external PCRE2Lib;
function pcre2_get_mark_16 (match_data : ppcre2_match_data_16) : PCRE2_SPTR16;
  cdecl; external PCRE2Lib;
function pcre2_get_mark_32 (match_data : ppcre2_match_data_32) : PCRE2_SPTR32;
  cdecl; external PCRE2Lib;
function pcre2_get_ovector_count_8 (match_data : ppcre2_match_data_8) :
  Cardinal; cdecl; external PCRE2Lib;
function pcre2_get_ovector_count_16 (match_data : ppcre2_match_data_16) :
  Cardinal; cdecl; external PCRE2Lib;
function pcre2_get_ovector_count_32 (match_data : ppcre2_match_data_32) :
  Cardinal; cdecl; external PCRE2Lib;
function pcre2_get_ovector_pointer_8 (match_data : ppcre2_match_data_8) :
  PPCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_ovector_pointer_16 (match_data : ppcre2_match_data_16) :
  PPCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_ovector_pointer_32 (match_data : ppcre2_match_data_32) :
  PPCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_startchar_8 (match_data : ppcre2_match_data_8) : PCRE2_SIZE;
  cdecl; external PCRE2Lib;
function pcre2_get_startchar_16 (match_data : ppcre2_match_data_16) :
  PCRE2_SIZE; cdecl; external PCRE2Lib;
function pcre2_get_startchar_32 (match_data : ppcre2_match_data_32) :
  PCRE2_SIZE; cdecl; external PCRE2Lib;

{ Convenience functions for handling matched substrings. }
function pcre2_substring_copy_byname_8 (match_data : ppcre2_match_data_8; name :
  PCRE2_SPTR8; buffer : PPCRE2_UCHAR8; bufflen : PPCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_substring_copy_byname_16 (match_data : ppcre2_match_data_16;
  name : PCRE2_SPTR16; buffer : PPCRE2_UCHAR16; bufflen : PPCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_substring_copy_byname_32 (match_data : ppcre2_match_data_32;
  name : PCRE2_SPTR32; buffer : PPCRE2_UCHAR32; bufflen : PPCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_substring_copy_bynumber_8 (match_data : ppcre2_match_data_8;
  number : Cardinal; buffer : PPCRE2_UCHAR8; bufflen : PPCRE2_SIZE) : Integer;
  cdecl; external PCRE2Lib;
function pcre2_substring_copy_bynumber_16 (match_data : ppcre2_match_data_16;
  number : Cardinal; buffer : PPCRE2_UCHAR16; bufflen : PPCRE2_SIZE) : Integer;
  cdecl; external PCRE2Lib;
function pcre2_substring_copy_bynumber_32 (match_data : ppcre2_match_data_32;
  number : Cardinal; buffer : PPCRE2_UCHAR32; bufflen : PPCRE2_SIZE) : Integer;
  cdecl; external PCRE2Lib;
procedure pcre2_substring_free_8 (buffer : PPCRE2_UCHAR8); cdecl;
  external PCRE2Lib;
procedure pcre2_substring_free_16 (buffer : PPCRE2_UCHAR16); cdecl;
  external PCRE2Lib;
procedure pcre2_substring_free_32 (buffer : PPCRE2_UCHAR32); cdecl;
  external PCRE2Lib;
function pcre2_substring_get_byname_8 (match_data : ppcre2_match_data_8; name :
  PCRE2_SPTR8; bufferptr : PPPCRE2_UCHAR8; bufflen : PPCRE2_SIZE) : Integer;
  cdecl; external PCRE2Lib;
function pcre2_substring_get_bynumber_8 (match_data : ppcre2_match_data_8;
  number : Cardinal; bufferptr : PPPCRE2_UCHAR8; bufflen : PPCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_substring_get_bynumber_16 (match_data : ppcre2_match_data_16;
  number : Cardinal; bufferptr : PPPCRE2_UCHAR16; bufflen : PPCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_substring_get_bynumber_32 (match_data : ppcre2_match_data_32;
  number : Cardinal; bufferptr : PPPCRE2_UCHAR32; bufflen : PPCRE2_SIZE) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_substring_length_byname_8 (match_data : ppcre2_match_data_8;
  name : PCRE2_SPTR8; length : PPCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_substring_length_byname_16 (match_data : ppcre2_match_data_16;
  name : PCRE2_SPTR16; length : PPCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_substring_length_byname_32 (match_data : ppcre2_match_data_32;
  name : PCRE2_SPTR32; length : PPCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_substring_length_bynumber_8 (match_data : ppcre2_match_data_8;
  number : Cardinal; length : PPCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_substring_length_bynumber_16 (match_data : ppcre2_match_data_16;
  number : Cardinal; length : PPCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_substring_length_bynumber_32 (match_data : ppcre2_match_data_32;
  number : Cardinal; length : PPCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_substring_nametable_scan_8 (const code : ppcre2_code_8; name :
  PCRE2_SPTR8; first : PPCRE2_SPTR8; last : PPCRE2_SPTR8) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_substring_number_from_name_8 (const code : ppcre2_code_8; name :
  PCRE2_SPTR8) : Integer; cdecl; external PCRE2Lib;
function pcre2_substring_number_from_name_16 (const code : ppcre2_code_16;
  name : PCRE2_SPTR16) : Integer; cdecl; external PCRE2Lib;
function pcre2_substring_number_from_name_32 (const code : ppcre2_code_32;
  name : PCRE2_SPTR32) : Integer; cdecl; external PCRE2Lib;
procedure pcre2_substring_list_free_8 (list : PPCRE2_SPTR8); cdecl;
  external PCRE2Lib;
procedure pcre2_substring_list_free_16 (list : PPCRE2_SPTR16); cdecl;
  external PCRE2Lib;
procedure pcre2_substring_list_free_32 (list : PPCRE2_SPTR32); cdecl;
  external PCRE2Lib;
function pcre2_substring_list_get_8 (match_data : ppcre2_match_data_8; listptr :
  PPPPCRE2_UCHAR8; lengthsptr : PPPCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;

{ Functions for serializing / deserializing compiled patterns. }
function pcre2_serialize_encode_8 (const codes : pppcre2_code_8;
  number_of_codes : Longint; serialized_bytes : PPByte; serialized_size :
  PPCRE2_SIZE; gcontext : ppcre2_general_context_8) : Longint; cdecl;
  external PCRE2Lib;
function pcre2_serialize_encode_16 (const codes : pppcre2_code_16;
  number_of_codes : Longint; serialized_bytes : PPByte; serialized_size :
  PPCRE2_SIZE; gcontext : ppcre2_general_context_16) : Longint; cdecl;
  external PCRE2Lib;
function pcre2_serialize_encode_32 (const codes : pppcre2_code_32;
  number_of_codes : Longint; serialized_bytes : PPByte; serialized_size :
  PPCRE2_SIZE; gcontext : ppcre2_general_context_32) : Longint; cdecl;
  external PCRE2Lib;
function pcre2_serialize_decode_8 (codes : pppcre2_code_8; number_of_codes :
  Longint; const bytes : PByte; gcontext : ppcre2_general_context_8) : Longint;
  cdecl; external PCRE2Lib;
function pcre2_serialize_decode_16 (codes : pppcre2_code_16; number_of_codes :
  Longint; const bytes : PByte; gcontext : ppcre2_general_context_16) : Longint;
  cdecl; external PCRE2Lib;
function pcre2_serialize_decode_32 (codes : pppcre2_code_32; number_of_codes :
  Longint; const bytes : PByte; gcontext : ppcre2_general_context_32) : Longint;
  cdecl; external PCRE2Lib;
function pcre2_serialize_get_number_of_codes_8 (const bytes : PByte) : Longint;
  cdecl; external PCRE2Lib;
function pcre2_serialize_get_number_of_codes_16 (const bytes : PByte) : Longint;
  cdecl; external PCRE2Lib;
function pcre2_serialize_get_number_of_codes_32 (const bytes : PByte) : Longint;
  cdecl; external PCRE2Lib;
procedure pcre2_serialize_free_8 (bytes : PByte); cdecl; external PCRE2Lib;
procedure pcre2_serialize_free_16 (bytes : PByte); cdecl; external PCRE2Lib;
procedure pcre2_serialize_free_32 (bytes : PByte); cdecl; external PCRE2Lib;

{ Convenience function for match + substitute. }
function pcre2_substitute_8 (const code : ppcre2_code_8; subject : PCRE2_SPTR8;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data_8; mcontext : ppcre2_match_context_8;
  replacement : PCRE2_SPTR8; rlength : PCRE2_SIZE; outputbuffer : PPCRE2_UCHAR8;
  outlengthptr : PPCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_substitute_16 (const code : ppcre2_code_16; subject :
  PCRE2_SPTR16; length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options :
  Cardinal; match_data : ppcre2_match_data_16; mcontext :
  ppcre2_match_context_16; replacement : PCRE2_SPTR16; rlength : PCRE2_SIZE;
  outputbuffer : PPCRE2_UCHAR16; outlengthptr : PPCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;
function pcre2_substitute_32 (const code : ppcre2_code_32; subject :
  PCRE2_SPTR32; length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options :
  Cardinal; match_data : ppcre2_match_data_32; mcontext :
  ppcre2_match_context_32; replacement : PCRE2_SPTR32; rlength : PCRE2_SIZE;
  outputbuffer : PPCRE2_UCHAR32; outlengthptr : PPCRE2_SIZE) : Integer; cdecl;
  external PCRE2Lib;

{ Functions for converting pattern source strings. }
function pcre2_pattern_convert_8 (pattern : PCRE2_SPTR8; length : PCRE2_SIZE;
  options : Cardinal; buffer : PPPCRE2_UCHAR8; blength : PPCRE2_SIZE;
  cvcontext : ppcre2_convert_context_8) : Integer; cdecl; external PCRE2Lib;
function pcre2_pattern_convert_16 (pattern : PCRE2_SPTR16; length : PCRE2_SIZE;
  options : Cardinal; buffer : PPPCRE2_UCHAR16; blength : PPCRE2_SIZE;
  cvcontext : ppcre2_convert_context_16) : Integer; cdecl; external PCRE2Lib;
function pcre2_pattern_convert_32 (pattern : PCRE2_SPTR32; length : PCRE2_SIZE;
  options : Cardinal; buffer : PPPCRE2_UCHAR32; blength : PPCRE2_SIZE;
  cvcontext : ppcre2_convert_context_32) : Integer; cdecl; external PCRE2Lib;
procedure pcre2_converted_pattern_free_8 (converted_pattern : PPCRE2_UCHAR8);
  cdecl; external PCRE2Lib;
procedure pcre2_converted_pattern_free_16 (converted_pattern : PPCRE2_UCHAR16);
  cdecl; external PCRE2Lib;
procedure pcre2_converted_pattern_free_32 (converted_pattern : PPCRE2_UCHAR32);
  cdecl; external PCRE2Lib;

{ Functions for JIT processing }
function pcre2_jit_compile_8 (code : ppcre2_code_8; options : Cardinal) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_jit_compile_16 (code : ppcre2_code_16; options : Cardinal) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_jit_compile_32 (code : ppcre2_code_32; options : Cardinal) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_jit_match_8 (const code : ppcre2_code_8; subject : PCRE2_SPTR8;
  length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options : Cardinal;
  match_data : ppcre2_match_data_8; mcontext : ppcre2_match_context_8) :
  Integer; cdecl; external PCRE2Lib;
function pcre2_jit_match_16 (const code : ppcre2_code_16; subject :
  PCRE2_SPTR16; length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options :
  Cardinal; match_data : ppcre2_match_data_16; mcontext :
  ppcre2_match_context_16) : Integer; cdecl; external PCRE2Lib;
function pcre2_jit_match_32 (const code : ppcre2_code_32; subject :
  PCRE2_SPTR32; length : PCRE2_SIZE; startoffset : PCRE2_SIZE; options :
  Cardinal; match_data : ppcre2_match_data_32; mcontext :
  ppcre2_match_context_32) : Integer; cdecl; external PCRE2Lib;
procedure pcre2_jit_free_unused_memory_8 (gcontext : ppcre2_general_context_8);
  cdecl; external PCRE2Lib;
procedure pcre2_jit_free_unused_memory_16 (gcontext :
  ppcre2_general_context_16); cdecl; external PCRE2Lib;
procedure pcre2_jit_free_unused_memory_32 (gcontext :
  ppcre2_general_context_32); cdecl; external PCRE2Lib;
function pcre2_jit_stack_create_8 (startsize : PCRE2_SIZE; maxsize : PCRE2_SIZE;
  gcontext : ppcre2_general_context_8) : ppcre2_jit_stack_8; cdecl;
  external PCRE2Lib;
function pcre2_jit_stack_create_16 (startsize : PCRE2_SIZE; maxsize :
  PCRE2_SIZE; gcontext : ppcre2_general_context_16) : ppcre2_jit_stack_16;
  cdecl; external PCRE2Lib;
function pcre2_jit_stack_create_32 (startsize : PCRE2_SIZE; maxsize :
  PCRE2_SIZE; gcontext : ppcre2_general_context_32) : ppcre2_jit_stack_32;
  cdecl; external PCRE2Lib;
procedure pcre2_jit_stack_assign_8 (mcontext : ppcre2_match_context_8;
  callback_function : pcre2_jit_callback_8; callback_data : Pointer); cdecl;
  external PCRE2Lib;
procedure pcre2_jit_stack_assign_16 (mcontext : ppcre2_match_context_16;
  callback_function : pcre2_jit_callback_16; callback_data : Pointer); cdecl;
  external PCRE2Lib;
procedure pcre2_jit_stack_assign_32 (mcontext : ppcre2_match_context_32;
  callback_function : pcre2_jit_callback_32; callback_data : Pointer); cdecl;
  external PCRE2Lib;
procedure pcre2_jit_stack_free_8 (jit_stack : ppcre2_jit_stack_8); cdecl;
  external PCRE2Lib;
procedure pcre2_jit_stack_free_16 (jit_stack : ppcre2_jit_stack_16); cdecl;
  external PCRE2Lib;
procedure pcre2_jit_stack_free_32 (jit_stack : ppcre2_jit_stack_32); cdecl;
  external PCRE2Lib;

{ Other miscellaneous functions. }
function pcre2_get_error_message_8 (errorcode : Integer; buffer : PPCRE2_UCHAR8;
  bufflen : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_get_error_message_16 (errorcode : Integer; buffer :
  PPCRE2_UCHAR16; bufflen : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_get_error_message_32 (errorcode : Integer; buffer :
  PPCRE2_UCHAR32; bufflen : PCRE2_SIZE) : Integer; cdecl; external PCRE2Lib;
function pcre2_maketables_8 (gcontext : ppcre2_general_context_8) : PByte;
  cdecl; external PCRE2Lib;
function pcre2_maketables_16 (gcontext : ppcre2_general_context_16) : PByte;
  cdecl; external PCRE2Lib;
function pcre2_maketables_32 (gcontext : ppcre2_general_context_32) : PByte;
  cdecl; external PCRE2Lib;
procedure pcre2_maketables_free_8 (gcontext : ppcre2_general_context_8;
  const tables : PByte); cdecl; external PCRE2Lib;
procedure pcre2_maketables_free_16 (gcontext : ppcre2_general_context_16;
  const tables : PByte); cdecl; external PCRE2Lib;
procedure pcre2_maketables_free_32 (gcontext : ppcre2_general_context_32;
  const tables : PByte); cdecl; external PCRE2Lib;

implementation

end.

