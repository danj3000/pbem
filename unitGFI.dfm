object frmGFI: TfrmGFI
  Left = 520
  Top = 119
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl GFI'
  ClientHeight = 382
  ClientWidth = 184
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
  object lblPlayer: TLabel
    Left = 8
    Top = 8
    Width = 169
    Height = 49
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblPlayer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblTriesToTxt: TLabel
    Left = 8
    Top = 56
    Width = 169
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'tries to Go For It'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblGFIFailed: TLabel
    Left = 0
    Top = 192
    Width = 185
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Go For It failed!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object lblRollNeeded: TLabel
    Left = 32
    Top = 136
    Width = 60
    Height = 13
    Caption = 'Roll needed:'
  end
  object butGFIRoll: TButton
    Left = 16
    Top = 160
    Width = 153
    Height = 25
    Caption = 'Make Go For It Roll'
    TabOrder = 0
    OnClick = butGFIRollClick
  end
  object butsurefeetSkill: TButton
    Left = 16
    Top = 216
    Width = 153
    Height = 25
    Caption = 'Use Sure Feet Skill'
    TabOrder = 1
    OnClick = butsurefeetSkillClick
  end
  object butTeamReroll: TButton
    Left = 16
    Top = 248
    Width = 153
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 2
    OnClick = butTeamRerollClick
  end
  object butKnockDown: TButton
    Left = 16
    Top = 312
    Width = 153
    Height = 25
    Caption = 'Knock Down Player'
    TabOrder = 3
    OnClick = butKnockDownClick
  end
  object txtGFIRollNeeded: TEdit
    Left = 104
    Top = 136
    Width = 25
    Height = 17
    AutoSize = False
    ReadOnly = True
    TabOrder = 4
    Text = '2+'
  end
  object cbBlizzard: TCheckBox
    Left = 8
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Blizzard'
    TabOrder = 5
    OnClick = cbBlizzardClick
  end
  object cbBigGuyAlly: TCheckBox
    Left = 8
    Top = 352
    Width = 97
    Height = 17
    Caption = 'Big Guy/Ally'
    TabOrder = 6
    Visible = False
  end
  object cbGFIInjury: TCheckBox
    Left = 80
    Top = 88
    Width = 97
    Height = 17
    Caption = 'GFI Auto Injury'
    TabOrder = 7
  end
  object cbSprint: TCheckBox
    Left = 40
    Top = 112
    Width = 97
    Height = 17
    Caption = 'Sprint for PGFI'
    TabOrder = 8
    Visible = False
    OnClick = cbBlizzardClick
  end
  object butPro: TButton
    Left = 16
    Top = 280
    Width = 153
    Height = 25
    Caption = 'Use Pro'
    Enabled = False
    TabOrder = 9
    OnClick = butProClick
  end
end
