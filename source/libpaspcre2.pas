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

{$IFDEF WINDOWS}
  const PCRE2Lib = 'libpcre2.dll';
{$ENDIF}
{$IFDEF LINUX}
  const PCRE2Lib = 'libpcre2.so';
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

type


implementation

end.

