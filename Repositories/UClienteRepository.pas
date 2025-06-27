unit UClienteRepository;

interface

uses
  Data.DB, FireDAC.Comp.Client, System.SysUtils,
  UClienteInterface, UClienteEntity, UFirebirdConnection,
  System.Generics.Collections, FireDAC.Stan.Param, FireDAC.Stan.Def,
  FireDac.DApt, FireDac.Stan.Async;

type
  TClienteRepository = class(TInterfacedObject, IClienteInterface)
  private
    FConnection: TFDConnection;
    FDataBaseConnection: TDataBaseConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAll: TList<TClienteEntity>;
    function GetByCpf(ACpf: string): TList<TClienteEntity>;
    function GetAllByNome(ANome: string): TList<TClienteEntity>;
    function GetById(AID: Integer): TClienteEntity;
    function GetCpfByCliente(ACpf: string): Integer;
    procedure Add(ACliente: TClienteEntity);
    procedure Update(ACliente: TClienteEntity);
    procedure Delete(AID: Integer);
  end;

implementation

{ TClienteRepository }

constructor TClienteRepository.Create;
begin
  FDataBaseConnection := TDataBaseConnection.Create;
  FConnection := FDataBaseConnection.GetConnection;
end;

destructor TClienteRepository.Destroy;
begin
  FreeAndNil(FDataBaseConnection);
  inherited;
end;

// Responsável por retornar uma lista de clientes
function TClienteRepository.GetAll: TList<TClienteEntity>;
var
  LQuery: TFDQuery;
  LCliente: TClienteEntity;
begin
  Result := TList<TClienteEntity>.Create;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT CODIGO, NOME, CPF FROM CLIENTES';
    LQuery.Open;
    while not LQuery.Eof do
    begin
      LCliente := TClienteEntity.Create;
      LCliente.ID := LQuery.FieldByName('CODIGO').AsInteger;
      LCliente.Nome := LQuery.FieldByName('NOME').AsString;
      LCliente.Cpf := LQuery.FieldByName('CPF').AsString;
      Result.Add(LCliente);
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

// Responsável por retornar um cliente por id
function TClienteRepository.GetById(AID: Integer): TClienteEntity;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT CODIGO, NOME, CPF, ENDERECO, CIDADE, ESTADO FROM CLIENTES WHERE CODIGO = :CODIGO';
    LQuery.ParamByName('CODIGO').AsInteger := AID;
    LQuery.Open;
    if not LQuery.Eof then
    begin
      Result := TClienteEntity.Create;
      Result.ID := LQuery.FieldByName('CODIGO').AsInteger;
      Result.Nome := LQuery.FieldByName('NOME').AsString;
      Result.Cpf := LQuery.FieldByName('CPF').AsString;
      Result.Endereco := LQuery.FieldByName('ENDERECO').AsString;
      Result.Cidade := LQuery.FieldByName('CIDADE').AsString;
      Result.Estado := LQuery.FieldByName('ESTADO').AsString;
    end;
  finally
    LQuery.Free;
  end;
end;

// Responsável por retornar um cliente por CPF
function TClienteRepository.GetByCpf(ACpf: string): TList<TClienteEntity>;
var
  LQuery: TFDQuery;
  LCliente: TClienteEntity;
begin
  Result := TList<TClienteEntity>.Create;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT CODIGO, NOME, CPF FROM CLIENTES WHERE CPF = :CPF';
    LQuery.ParamByName('CPF').AsString := ACpf;
    LQuery.Open;
    while not LQuery.Eof do
    begin
      LCliente := TClienteEntity.Create;
      LCliente.ID := LQuery.FieldByName('CODIGO').AsInteger;
      LCliente.Nome := LQuery.FieldByName('NOME').AsString;
      LCliente.Cpf := LQuery.FieldByName('CPF').AsString;
      Result.Add(LCliente);
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

// Responsável por retornar uma lista de clientes por nome
function TClienteRepository.GetAllByNome(ANome: string): TList<TClienteEntity>;
var
  LQuery: TFDQuery;
  LCliente: TClienteEntity;
begin
  Result := TList<TClienteEntity>.Create;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT CODIGO, NOME, CPF FROM CLIENTES WHERE NOME LIKE :NOME';
    LQuery.ParamByName('NOME').AsString := '%' + ANome + '%';
    LQuery.Open;
    while not LQuery.Eof do
    begin
      LCliente := TClienteEntity.Create;
      LCliente.ID := LQuery.FieldByName('CODIGO').AsInteger;
      LCliente.Nome := LQuery.FieldByName('NOME').AsString;
      LCliente.Cpf := LQuery.FieldByName('CPF').AsString;
      Result.Add(LCliente);
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

// Responsável por verificar se o cpf já está cadastrado
function TClienteRepository.GetCpfByCliente(ACpf: string): Integer;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);

  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT COUNT(*) FROM CLIENTES WHERE CPF = :CPF';
    LQuery.ParamByName('CPF').AsString := ACpf;
    LQuery.Open;

    if not LQuery.IsEmpty then
    begin
      Result := LQuery.Fields[0].AsInteger;
    end
    else
    begin
      Result := 0;
    end;
  finally
    LQuery.Free;
  end;
end;

// Responsável por cadastrar um novo cliente
procedure TClienteRepository.Add(ACliente: TClienteEntity);
var
  LQuery: TFDQuery;
begin
  LQuery := nil;
  FConnection.StartTransaction;

  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FConnection;

      LQuery.SQL.Text := 'INSERT INTO CLIENTES (NOME, CPF, ENDERECO, CIDADE, ESTADO) VALUES (:NOME, :CPF, :ENDERECO, :CIDADE, :ESTADO)';
      LQuery.ParamByName('NOME').AsString := ACliente.Nome;
      LQuery.ParamByName('CPF').AsString := ACliente.Cpf;
      LQuery.ParamByName('ENDERECO').AsString := ACliente.Endereco;
      LQuery.ParamByName('CIDADE').AsString := ACliente.Cidade;
      LQuery.ParamByName('ESTADO').AsString := ACliente.Estado;

      LQuery.ExecSQL;
      FConnection.Commit;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        raise Exception.Create('Erro ao tentar cadastrar cliente.');
      end;
    end;
  finally
    if Assigned(LQuery) then
      LQuery.Free;
  end;
end;

// Responsável por atualizar um cliente por id
procedure TClienteRepository.Update(ACliente: TClienteEntity);
var
  LQuery: TFDQuery;
begin
  FConnection.StartTransaction;
  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FConnection;

      LQuery.SQL.Text := 'UPDATE CLIENTES SET NOME = :NOME, ENDERECO = :ENDERECO, CIDADE = :CIDADE, ESTADO = :ESTADO WHERE CODIGO = :CODIGO';
      LQuery.ParamByName('NOME').AsString := ACliente.Nome;
      LQuery.ParamByName('ENDERECO').AsString := ACliente.Endereco;
      LQuery.ParamByName('CIDADE').AsString := ACliente.Cidade;
      LQuery.ParamByName('ESTADO').AsString := ACliente.Estado;
      LQuery.ParamByName('CODIGO').AsInteger := ACliente.ID;

      LQuery.ExecSQL;
      FConnection.Commit;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        raise Exception.Create('Erro ao tentar atualizar o cliente.');
      end;
    end;
  finally
    if Assigned(LQuery) then
      LQuery.Free;
  end;
end;

// Responsável por remover um cliente por id
procedure TClienteRepository.Delete(AID: Integer);
var
  LQuery: TFDQuery;
begin
  FConnection.StartTransaction;

  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FConnection;

      LQuery.SQL.Text := 'DELETE FROM CLIENTES WHERE CODIGO = :CODIGO';
      LQuery.ParamByName('CODIGO').AsInteger := AID;

      LQuery.ExecSQL;
      FConnection.Commit;
    except
      on E: Exception do
      begin
        FConnection.Rollback;
        raise Exception.Create('Erro ao tentar remover o cliente.');
      end;
    end;
  finally
    if Assigned(LQuery) then
      LQuery.Free;
  end;
end;

end.
