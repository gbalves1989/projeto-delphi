unit UMessageUtils;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

procedure ShowMessageError(const Msg: string);
procedure ShowMessageInfo(const Msg: string);

implementation

procedure ShowMessageError(const Msg: string);
begin
  MessageDlg(Msg, mtError, [mbOK], 0);
end;

procedure ShowMessageInfo(const Msg: string);
begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

end.
