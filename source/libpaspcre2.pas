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

type


implementation

end.

