program libpaspcre2_testproject;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, paspcre2testcase, paspcre2;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

