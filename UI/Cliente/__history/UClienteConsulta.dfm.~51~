object FClienteConsulta: TFClienteConsulta
  Left = 0
  Top = 0
  Caption = 'Consulta de Clientes'
  ClientHeight = 476
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = onCreate
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 601
    Height = 81
    Caption = 'Filtrar Por:'
    TabOrder = 0
    object LFiltro: TLabel
      Left = 16
      Top = 24
      Width = 30
      Height = 15
      Caption = 'Filtro:'
    end
    object LCpf: TLabel
      Left = 168
      Top = 24
      Width = 24
      Height = 15
      Caption = 'CPF:'
    end
    object LNome: TLabel
      Left = 302
      Top = 24
      Width = 36
      Height = 15
      Caption = 'Nome:'
    end
    object CBFiltro: TComboBox
      Left = 52
      Top = 21
      Width = 109
      Height = 23
      TabOrder = 0
    end
    object MECpf: TMaskEdit
      Left = 198
      Top = 21
      Width = 91
      Height = 23
      EditMask = '999\.999\.999\-99;1;_'
      MaxLength = 14
      TabOrder = 1
      Text = '   .   .   -  '
    end
    object ENome: TEdit
      Left = 344
      Top = 21
      Width = 249
      Height = 23
      TabOrder = 2
    end
    object BPesquisar: TButton
      Left = 518
      Top = 50
      Width = 75
      Height = 25
      Caption = 'Pesquisar'
      TabOrder = 3
      OnClick = BPesquisarClick
    end
  end
  object SGClientes: TStringGrid
    Left = 8
    Top = 95
    Width = 601
    Height = 338
    TabOrder = 1
    OnDblClick = onDblClickEditar
  end
  object BImprimir: TButton
    Left = 534
    Top = 443
    Width = 75
    Height = 25
    Caption = 'Imprimir'
    TabOrder = 2
    OnClick = BImprimirClick
  end
end
