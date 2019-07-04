object frmPass: TfrmPass
  Left = 464
  Top = 94
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Pass'
  ClientHeight = 494
  ClientWidth = 338
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
    Left = 88
    Top = 96
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '#TZ:'
  end
  object Label2: TLabel
    Left = 128
    Top = 32
    Width = 69
    Height = 20
    Alignment = taCenter
    Caption = 'passes to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblPasser: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'PASSER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblCatcher: TLabel
    Left = 8
    Top = 56
    Width = 321
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'CATCHER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblPassFailed: TLabel
    Left = 40
    Top = 400
    Width = 90
    Height = 20
    Caption = 'Pass failed!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 16
    Top = 328
    Width = 60
    Height = 13
    Caption = 'Roll needed:'
  end
  object Label6: TLabel
    Left = 8
    Top = 96
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'AG:'
  end
  object Label3: TLabel
    Left = 184
    Top = 96
    Width = 94
    Height = 13
    Caption = '# Foul Appearance:'
  end
  object txtBulletThrow: TLabel
    Left = 16
    Top = 296
    Width = 139
    Height = 20
    Caption = 'Bullet Throw Pass!'
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object gbPass: TGroupBox
    Left = 176
    Top = 120
    Width = 153
    Height = 241
    Caption = 'using'
    TabOrder = 0
    object cbAccurate: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Accurate'
      TabOrder = 0
      OnClick = PassSkillClick
    end
    object cbStrongArm: TCheckBox
      Left = 16
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Strong Arm'
      TabOrder = 1
      OnClick = PassSkillClick
    end
    object cbHailMaryPass: TCheckBox
      Left = 16
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Hail Mary Pass'
      TabOrder = 2
      OnClick = PassSkillClick
    end
    object cbNervesOfSteel: TCheckBox
      Left = 16
      Top = 96
      Width = 97
      Height = 17
      Caption = 'Nerves of Steel'
      TabOrder = 3
      OnClick = PassSkillClick
    end
    object cbTitchy: TCheckBox
      Left = 16
      Top = 120
      Width = 129
      Height = 17
      Caption = 'Halfling, Goblin'
      TabOrder = 4
      OnClick = cbTitchyClick
    end
  end
  object txtPassTZ: TEdit
    Left = 120
    Top = 92
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 120
    Width = 153
    Height = 145
    Caption = 'Range'
    Enabled = False
    TabOrder = 2
    object rbQuickPass: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Quick Pass'
      TabOrder = 0
    end
    object rbShortPass: TRadioButton
      Left = 16
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Short Pass'
      TabOrder = 1
    end
    object rbLongPass: TRadioButton
      Left = 16
      Top = 72
      Width = 113
      Height = 17
      Caption = 'Long Pass'
      TabOrder = 2
    end
    object rbLongBomb: TRadioButton
      Left = 16
      Top = 96
      Width = 113
      Height = 17
      Caption = 'Long Bomb'
      TabOrder = 3
    end
    object rbHailMaryPass: TRadioButton
      Left = 16
      Top = 120
      Width = 113
      Height = 17
      Caption = 'Hail Mary Pass'
      TabOrder = 4
    end
  end
  object butPassRoll: TButton
    Left = 176
    Top = 368
    Width = 153
    Height = 25
    Caption = 'Make Pass Roll'
    TabOrder = 3
    OnClick = butPassRollClick
  end
  object butPassSkill: TButton
    Left = 176
    Top = 400
    Width = 153
    Height = 25
    Caption = 'Use Pass Skill'
    TabOrder = 4
    OnClick = butPassSkillClick
  end
  object butTeamReroll: TButton
    Left = 176
    Top = 432
    Width = 89
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 5
    OnClick = butTeamRerollClick
  end
  object butFumbleInaccurate: TButton
    Left = 176
    Top = 464
    Width = 153
    Height = 25
    Caption = 'Fumble'
    TabOrder = 6
    OnClick = butFumbleInaccurateClick
  end
  object txtPassRollNeeded: TEdit
    Left = 88
    Top = 328
    Width = 25
    Height = 17
    AutoSize = False
    ReadOnly = True
    TabOrder = 7
    Text = '2+'
  end
  object txtThrowerAG: TEdit
    Left = 40
    Top = 92
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 8
  end
  object cbVerySunny: TCheckBox
    Left = 8
    Top = 272
    Width = 73
    Height = 17
    Caption = 'Very Sunny'
    TabOrder = 9
    OnClick = PassSkillClick
  end
  object txtPassFA: TEdit
    Left = 288
    Top = 92
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 10
  end
  object cbBigGuyAlly: TCheckBox
    Left = 8
    Top = 455
    Width = 129
    Height = 17
    Caption = 'BigGuy/Ally'
    TabOrder = 11
    Visible = False
  end
  object cbBlizzard: TCheckBox
    Left = 96
    Top = 272
    Width = 57
    Height = 17
    Caption = 'Blizzard'
    TabOrder = 12
    OnClick = PassSkillClick
  end
  object cbImpossible: TCheckBox
    Left = 8
    Top = 432
    Width = 129
    Height = 17
    Caption = 'Impossbile'
    TabOrder = 13
    Visible = False
  end
  object butPro: TButton
    Left = 272
    Top = 432
    Width = 57
    Height = 25
    Caption = 'Use Pro'
    Enabled = False
    TabOrder = 14
    OnClick = butProClick
  end
end
