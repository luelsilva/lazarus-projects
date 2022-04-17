unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ExtCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Splitter1: TSplitter;
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }



end.
