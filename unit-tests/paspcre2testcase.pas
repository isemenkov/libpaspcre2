unit paspcre2testcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, libpaspcre2;

type

  TPcre2TestCase = class(TTestCase)
  published
    procedure TestHookUp;
  end;

implementation

procedure TPcre2TestCase.TestHookUp;
begin
  Fail('Напишите ваш тест');
end;



initialization

  RegisterTest(TPcre2TestCase);
end.

