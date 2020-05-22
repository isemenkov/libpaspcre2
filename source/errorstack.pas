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

unit errorstack;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, libpascurl;

type
  TErrors = (
    ERROR_NONE                                                        = 0,
  );

  { TErrorStack }
  { Store curl_easy_setopt function errors }

  PErrorStack = ^TErrorStack;
  TErrorStack = class
  private
    type
      TErrorsList = specialize TFPGList<TErrors>;
  private
    FList : TErrorsList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Push (ACode : CURLcode);
    function Pop : CURLcode;
    function Count : Cardinal;
  end;

implementation

{ TErrorStack }

constructor TErrorStack.Create;
begin
  FList := TErrorsList.Create;
end;

destructor TErrorStack.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TErrorStack.Push(ACode: TErrors);
begin
  FList.Add(ACode);
end;

function TErrorStack.Pop: TErrors;
begin
  if FList.Count > 0 then
  begin
    Result := FList.First;
    FList.Delete(1);
  end;
end;

function TErrorStack.Count: Cardinal;
begin
  Result := FList.Count;
end;

end.

