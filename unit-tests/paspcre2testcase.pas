unit paspcre2testcase;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, libpaspcre2, utils.api.cstring
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type

  { TPcre2TestCase }

  TPcre2TestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test;
  end;

implementation

{$IFNDEF FPC}
procedure TPcre2TestCase.AssertTrue(AMessage: string; ACondition: Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TPcre2TestCase.Test;
var
  re : pcre2_code_8;
  rc : Integer;
  pattern, subject : PCRE2_SPTR8;
  error_buffer : string[255];
  subject_length : Int64;
  error_number : Integer;
  error_offset : PCRE2_SIZE;
  ovector : PPCRE2_SIZE;
  match_data : ppcre2_match_data_8;
  substring : string; 
begin
  pattern := PCRE2_SPTR8(API.CString.Create('(?:\D|^)(5[1-5][0-9]{2}(?:\ |\-|)[0-9]{4}'+
    '(?:\ |\-|)[0-9]{4}(?:\ |\-|)[0-9]{4})(?:\D|$)').ToPAnsiChar);
  subject := PCRE2_SPTR8(API.CString.Create('5111 2222 3333 4444').ToPAnsiChar);
  subject_length := API.CString.Create('5111 2222 3333 4444').Length;
  
  re := pcre2_compile_8(pattern, PCRE2_ZERO_TERMINATED, 0, @error_number, @error_offset, nil);
  if re = nil then
  begin
    pcre2_get_error_message_8(error_number, PPCRE2_UCHAR8(@error_buffer[0]), 256);
    Fail(Format('PCRE2 compilation failed at offset %d: %s', [error_offset, error_buffer]));
  end;
  
  match_data := pcre2_match_data_create_from_pattern_8(re, nil);
  rc := pcre2_match_8(re, subject, subject_length, 0, 0, match_data, nil);
  if rc < 0 then
  begin
    case rc of
    PCRE2_ERROR_NOMATCH :
      begin
        pcre2_match_data_free_8(match_data);
        pcre2_code_free_8(re);
        Fail('No match');
      end;
    end;
  end;
  {
  ovector := pcre2_get_ovector_pointer_8(match_data);

  if ovector^ > (ovector + 1)^ then
    Fail('Error');

  substring := Copy(PChar(subject), ovector^, (ovector + 1)^ - ovector^);

  pcre2_match_data_free_8(match_data);
  pcre2_code_free_8(re);
  }
end;


{
procedure TPcre2TestCase.Test;
var
  subject : PCRE2_SPTR8;
  subject_len : PCRE2_SIZE;
  pattern : PCRE2_SPTR8;
  error_code : Integer;
  error_offset : PCRE2_SIZE;
  re : ppcre2_code_8;
  group_count, options_exec : Cardinal;
  match_data : ppcre2_match_data_8;
begin
  subject := PCRE2_SPTR8(API.CString.Create('this is it').ToPAnsiChar);
  pattern := PCRE2_SPTR8(API.CString.Create(PChar('([a-z])')).ToPAnsiChar);
  re := pcre2_compile_8(pattern, PCRE2_ZERO_TERMINATED, PCRE2_ANCHORED or
    PCRE2_UTF, @error_code, @error_offset, nil);

  AssertTrue('Result code is empty', re <> nil);
  if (re <> nil) then
  begin
    pcre2_pattern_info_8(re, PCRE2_INFO_BACKREFMAX, @group_count);
    match_data := pcre2_match_data_create_from_pattern_8(re, nil);
    options_exec := PCRE2_NOTEMPTY;
    subject_len := API.CString.Create('this is it').Length;
    error_code := pcre2_match_8(re, subject, subject_len, 0, options_exec,
      match_data, nil);
    
    AssertTrue('Match error', error_code >= 0);

    pcre2_match_data_free_8(match_data);
  end;
  pcre2_code_free_8(re);
end;
}

initialization
  RegisterTest(TPcre2TestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

