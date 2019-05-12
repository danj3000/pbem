object MachID: TMachID
  Left = 494
  Top = 188
  Width = 224
  Height = 178
  BorderIcons = [biSystemMenu]
  Caption = 'GetIp Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 193
    Height = 33
    Caption = '&IP?'
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 16
    Top = 48
    Width = 185
    Height = 89
    Lines.Strings = (
      'To get the Ip push the Button on Top')
    TabOrder = 1
  end
end
