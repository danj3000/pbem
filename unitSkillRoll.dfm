object frmSkillRolls: TfrmSkillRolls
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Skill Rolls'
  ClientHeight = 292
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000000000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000000000000000000000000000000000F0
    0FFFFFFFFFFFFFFFFFFFFFF00F0000FFF000FFFFFFFFFFFFFFFF000FFF0000FF
    FFFF00FFFFFFFFFFFF00FFFFFF0000FFFFFFFF00FFFFFFFF00FFFFFFFF0000FF
    FFFFFFFF000FF000FFFFFFFFFF0000FFFFFFFFFFFFF00FFFFFFFFFFFFF0000FF
    FFFFFFFF00007000FFFFFFFFFF0000FFFFFFFF000700007000FFFFFFFF0000FF
    FFFF0077777888877700FFFFFF0000FFF0004787878111787878000FFF0000F0
    0FF177C8C881017C8C8C88100F00000FFFF177CCCC81118CCCCCC11FF0000000
    FFF1774C4C888874C4C4C1FF0000000000F177C4C4C4C4CC4C4C110000000000
    000177C8C8C8C8C8780110000000000000017770707070700740110000000000
    0001770000087870000401100000000000017707078111870700441100000000
    0011777777810178777774811000000000174878788111887878C81100000000
    011788C8C88888C8C8C8C1100000000011888CCCCCCCCCCCCCCCC10000000001
    1888C4C4C4C4C4C4C4CCC1000000000011778C4C4C4C4C4C4C4C110000000000
    011784444444444484411000000000000018777777C477777711000000000000
    00111111178C1111111000000000000000000000118110000000000000000000
    000000000111000000000000000000000000000000100000000000000000FFFF
    FFFF800000018000000180000001800000018000000180000001800000018001
    0001800BD00180000001800000018000800180000001C0000003F000000FFC00
    003FFE15583FFE3E1E1FFE280B0FFC008007FC00000FF800001FF000003FE000
    003FF000003FF800007FFC0000FFFC0001FFFFF07FFFFFF8FFFFFFFDFFFF}
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 132
    Height = 13
    Caption = 'Players eligible for a skill roll:'
  end
  object lblPlayerName: TLabel
    Left = 8
    Top = 128
    Width = 305
    Height = 41
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblPlayerName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object imDie1: TImage
    Left = 8
    Top = 184
    Width = 33
    Height = 33
    Stretch = True
  end
  object imDie2: TImage
    Left = 48
    Top = 184
    Width = 33
    Height = 33
    Stretch = True
  end
  object imDieA3: TImage
    Left = 8
    Top = 352
    Width = 33
    Height = 33
    Stretch = True
  end
  object imDieA4: TImage
    Left = 48
    Top = 352
    Width = 33
    Height = 33
    Stretch = True
  end
  object lblAgingEffect: TLabel
    Left = 104
    Top = 352
    Width = 96
    Height = 20
    Caption = 'Aging Effects'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbPlayers: TListBox
    Left = 8
    Top = 24
    Width = 305
    Height = 89
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbPlayersClick
  end
  object rbSkill: TRadioButton
    Left = 104
    Top = 192
    Width = 49
    Height = 17
    Caption = 'Skill:'
    TabOrder = 1
  end
  object rbMA: TRadioButton
    Left = 104
    Top = 216
    Width = 57
    Height = 17
    Caption = '+1 MA'
    TabOrder = 2
  end
  object rbAG: TRadioButton
    Left = 104
    Top = 240
    Width = 57
    Height = 17
    Caption = '+1 AG'
    TabOrder = 3
  end
  object rbST: TRadioButton
    Left = 104
    Top = 264
    Width = 57
    Height = 17
    Caption = '+1 ST'
    TabOrder = 4
  end
  object txtSkill: TEdit
    Left = 160
    Top = 192
    Width = 153
    Height = 21
    TabOrder = 5
  end
  object butAccept: TButton
    Left = 224
    Top = 256
    Width = 89
    Height = 25
    Caption = 'Accept'
    TabOrder = 6
    OnClick = butAcceptClick
  end
end
