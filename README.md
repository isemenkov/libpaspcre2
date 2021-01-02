# libPasPCRE2
libPasPCRE2 is delphi and object pascal bindings for Perl-compatible Regular Expressions library (PCRE2). Library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.



### Table of contents

* [Requierements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Testing](#testing)
* [Bindings](#bindings)
  * [Usage example](#usage-example)



### Requirements

* [Embarcadero (R) Rad Studio](https://www.embarcadero.com)
* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/) (optional)



Library is tested for 

- Embarcadero (R) Delphi 10.3 on Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)
- FreePascal Compiler (3.2.0) and Lazarus IDE (2.0.10) on Ubuntu Linux 5.8.0-33-generic x86_64



### Installation

Get the sources and add the *source* directory to the project search path. For FPC add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpaspcre2`.

Add the unit you want to use to the `uses` clause.



### Testing

A testing framework consists of the following ingredients:
1. Test runner project located in `unit-tests` directory.
2. Test cases (DUnit for Delphi and FPCUnit for FPC based) for all containers classes. 



### Bindings

[libpaspcre2.pas](https://github.com/isemenkov/libpaspcre2/blob/master/source/libpaspcre2.pas) file contains the PCRE2 translated headers to use this library in pascal programs. You can find C API documentation at [www.pcre.org](https://www.pcre.org/current/doc/html/) website.

#### Usage example

```pascal
uses
  libpaspcre2, utils.api.cstring;
  
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
```

