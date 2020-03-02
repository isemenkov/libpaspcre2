unit paspcre2testcase;

{$mode objfpc}{$H+}
{$DEFINE PCRE8}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, libpaspcre2;

type

  { TPcre2TestCase }

  TPcre2TestCase = class(TTestCase)
  published
    procedure Test;
    procedure TestPregMathPattern;
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

{ https://github.com/luvit/pcre2/blob/master/src/pcre2demo.c }
procedure TPcre2TestCase.TestPregMathPattern;
var
  re : ppcre2_code_8;
  pattern : PCRE2_SPTR8;
  subject : PCRE2_SPTR8;
  name_table : PCRE2_SPTR8;
  substring : string;

  crlf_is_newline : Integer;
  error_number : Integer;
  name_count : Integer;
  name_entry_size : Integer;
  rc : Integer;
  utf8 : Integer;

  option_bits : Cardinal;
  new_line : Cardinal;

  error_offset : PCRE2_SIZE;
  ovector : PPCRE2_SIZE;

  subject_length : QWord;
  match_data : ppcre2_match_data_8;

  error_buffer : string[255];
begin
  pattern := PCRE2_SPTR8(PChar('([a-z]+|\\w+)'));
  subject := PCRE2_SPTR8(PChar('this is it'));
  subject_length := Length(PChar(subject));

  re := pcre2_compile_8(pattern, PCRE2_ZERO_TERMINATED, 0, @error_number,
    @error_offset, nil);
  if re = nil then
  begin
    pcre2_get_error_message_8(error_number, PPCRE2_UCHAR8(@error_buffer[0]),
      Length(error_buffer));
    Fail(Format('PCRE2 compilation failed at offset %d: %s',
     [error_offset, error_buffer]));
  end;

  match_data := pcre2_match_data_create_from_pattern_8(re, nil);
  rc := pcre2_match_8(re, PCRE2_SPTR8(PChar(subject)), subject_length,
    0, 0, match_data, nil);
  if rc < 0 then
  begin
    case rc of
      PCRE2_ERROR_NOMATCH : Fail('No match');
    else
      Fail(Format('Matching error %d', [rc]));
    end;
    pcre2_match_data_free_8(match_data);
    pcre2_code_free_8(re);
  end;

  ovector := pcre2_get_ovector_pointer_8(match_data);
  if rc = 0 then
  begin
    Fail('Ovector was not big enough for all the captured substrings');
  end;

  substring := Copy(string(PChar(subject)), ovector^, (ovector + 1)^ -
    ovector^);
  //AssertTrue('First substring is not correct', substring = 'this');

  substring := Copy(string(PChar(subject)), (ovector + 2)^, (ovector + 3)^ -
    (ovector + 2)^);
  //AssertTrue('Second substring is not correct', substring = 'is');

  substring := Copy(string(PChar(subject)), (ovector + 4)^, (ovector + 5)^ -
    (ovector + 4)^);
  AssertTrue('Second substring is not correct', substring = 'it');
end;



initialization

  RegisterTest(TPcre2TestCase);
end.

