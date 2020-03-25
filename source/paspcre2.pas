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

unit paspcre2;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, libpaspcre2, fgl;

type
  TErrors = (
    ERROR_NONE                                                        = 0,
  );

  PErrorStack = ^TErrorStack;

  { TErrorStack }

  TErrorStack = class
  private
    type
      TErrorsList = specialize TFPGList<TErrors>;
  private
    FErrors : TErrorsList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Push (Err : TErrors);{$IFNDEF DEBUG}inline;{$ENDIF}
    function Pop : TErrors;{$IFNDEF DEBUG}inline;{$ENDIF}
    function Count : Cardinal;{$IFNDEF DEBUG}inline;{$ENDIF}
    procedure Clear;{$IFNDEF DEBUG}inline;{$ENDIF}
  end;

  TRegex8 = class
  private
    re : pcre2_code_8;
    rc : Integer;
    pattern, subject : PCRE2_SPTR8;
    error_buffer : string[255];
    subject_length : QWord;
    FErrors : TErrorStack;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TRegex16 = class
  private
    re : pcre2_code_16;
    rc : Integer;
    pattern, subject : PCRE2_SPTR16;
    error_buffer : string[255];
    subject_length : QWord;
    FErrors : TErrorStack;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TRegex32 = class
  private
    re : pcre2_code_32;
    rc : Integer;
    pattern, subject : PCRE2_SPTR32;
    error_buffer : string[255];
    subject_length : QWord;
    FErrors : TErrorStack;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TErrorStack }

constructor TErrorStack.Create;
begin
  FErrors := TErrorsList.Create;
end;

destructor TErrorStack.Destroy;
begin
  FreeAndNil(FErrors);
  inherited Destroy;
end;

procedure TErrorStack.Push(Err: TErrors);
begin
  FErrors.Add(Err);
end;

function TErrorStack.Pop: TErrors;
begin
  if Count > 0 then
  begin
    Result := FErrors.First;
    FErrors.Delete(0);
  end;
end;

function TErrorStack.Count: Cardinal;
begin
  Result := FErrors.Count;
end;

procedure TErrorStack.Clear;
begin
  FErrors.Clear;
end;

end.

