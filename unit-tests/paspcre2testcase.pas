unit paspcre2testcase;

{$mode objfpc}{$H+}
{$DEFINE PCRE8}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, libpaspcre2;

type

  TPcre2TestCase = class(TTestCase)
  published
    procedure Test;
  end;

implementation


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
  subject := PCRE2_SPTR8(PChar('this is it'));
  pattern := PCRE2_SPTR8(PChar('([a-z]|\\s)'));
  re := pcre2_compile_8(pattern, PCRE2_ZERO_TERMINATED, PCRE2_ANCHORED or
    PCRE2_UTF, @error_code, @error_offset, nil);

  AssertTrue('Result code is empty', re <> nil);
  if (re <> nil) then
  begin
    pcre2_pattern_info_8(re, PCRE2_INFO_BACKREFMAX, @group_count);
    match_data := pcre2_match_data_create_from_pattern_8(re, nil);
    options_exec := PCRE2_NOTEMPTY;
    subject_len := Length(PChar(subject));
    error_code := pcre2_match_8(re, subject, subject_len, 0, options_exec,
      match_data, nil);
    AssertTrue('Match error', error_code >= 0);

    pcre2_match_data_free_8(match_data);
  end;
  pcre2_code_free_8(re);
end;



initialization

  RegisterTest(TPcre2TestCase);
end.

