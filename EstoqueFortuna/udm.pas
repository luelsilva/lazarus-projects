unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type

  { Tdm }

  Tdm = class(TDataModule)
    Conn: TZConnection;
    dsPecas: TDataSource;
    dsAnexos: TDataSource;
    dsModelos: TDataSource;
    tAnexosGuidFileName: TStringField;
    tAnexosGuidPai: TStringField;
    tAnexosIdReg: TLongintField;
    tModelos: TZTable;
    tModelosCod: TStringField;
    tModelosGuid: TStringField;
    tModelosIdModelo: TLongintField;
    tModelosIdReg: TLongintField;
    tModelosNome: TStringField;
    tModelosQtde: TSmallintField;
    tPecas: TZTable;
    tPecasCod: TStringField;
    tPecasGuid: TStringField;
    tPecasIdPeca: TLongintField;
    tPecasIdReg: TLongintField;
    tPecasNome: TStringField;
    tPecasQtde: TSmallintField;
    tAnexos: TZTable;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  Conn.Disconnect;
  Conn.Database := 'Provider=Microsoft.Jet.Oledb.4.0; Data Source=' +
    ExtractFilePath(ParamStr(0)) + 'EstoqueFortunaDB.mdb';
  Conn.Connect;
  tModelos.Open;
  tPecas.Open;
end;

end.
