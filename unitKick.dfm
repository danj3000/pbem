object frmKick: TfrmKick
  Left = 401
  Top = 104
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Kick'
  ClientHeight = 478
  ClientWidth = 336
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
    Left = 128
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
    Width = 95
    Height = 20
    Alignment = taCenter
    Caption = 'kicks towards'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblKicker: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'KICKER'
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
  object lblKickFailed: TLabel
    Left = 48
    Top = 328
    Width = 84
    Height = 20
    Caption = 'Kick failed!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 16
    Top = 264
    Width = 60
    Height = 13
    Caption = 'Roll needed:'
  end
  object Label6: TLabel
    Left = 0
    Top = 96
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'AG:'
  end
  object Label3: TLabel
    Left = 200
    Top = 96
    Width = 94
    Height = 13
    Caption = '# Foul Appearance:'
  end
  object Label4: TLabel
    Left = 16
    Top = 232
    Width = 107
    Height = 13
    Caption = 'Distance to Field Goal:'
  end
  object Label8: TLabel
    Left = 56
    Top = 96
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'ST:'
  end
  object Label5: TLabel
    Left = 16
    Top = 384
    Width = 81
    Height = 13
    Caption = 'Distance Kicked:'
  end
  object gbKick: TGroupBox
    Left = 176
    Top = 120
    Width = 153
    Height = 161
    Caption = 'using'
    TabOrder = 0
    object cbStrongLeg: TCheckBox
      Left = 16
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Strong Leg'
      TabOrder = 0
      OnClick = KickSkillClick
    end
    object cbNervesOfSteel: TCheckBox
      Left = 16
      Top = 112
      Width = 97
      Height = 17
      Caption = 'Nerves of Steel'
      TabOrder = 1
      OnClick = KickSkillClick
    end
    object cbHFHead: TCheckBox
      Left = 16
      Top = 136
      Width = 129
      Height = 17
      Caption = 'House Fly Head'
      TabOrder = 2
      OnClick = KickSkillClick
    end
    object cbHookKick: TCheckBox
      Left = 16
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Hook Kick'
      TabOrder = 3
      OnClick = KickSkillClick
    end
    object cbPoochKick: TCheckBox
      Left = 16
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Pooch Kick'
      TabOrder = 4
      OnClick = PoochKickClick
    end
    object cbExtraLeg: TCheckBox
      Left = 16
      Top = 88
      Width = 97
      Height = 17
      Caption = 'Extra Leg'
      TabOrder = 5
      OnClick = KickSkillClick
    end
  end
  object txtKickTZ: TEdit
    Left = 160
    Top = 92
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object butKickRoll: TButton
    Left = 176
    Top = 288
    Width = 153
    Height = 25
    Caption = 'Make Kick Roll'
    TabOrder = 2
    OnClick = butKickRollClick
  end
  object butKickSkill: TButton
    Left = 176
    Top = 320
    Width = 153
    Height = 25
    Caption = 'Use Kick Skill'
    TabOrder = 3
    OnClick = butKickSkillClick
  end
  object butTeamReroll: TButton
    Left = 176
    Top = 352
    Width = 89
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 4
    OnClick = butKickReRollClick
  end
  object butFumbleInaccurate: TButton
    Left = 176
    Top = 448
    Width = 153
    Height = 25
    Caption = 'Fumble'
    TabOrder = 5
    OnClick = butFumbleInaccurateClick
  end
  object txtKickRollNeeded: TEdit
    Left = 96
    Top = 264
    Width = 25
    Height = 17
    AutoSize = False
    ReadOnly = True
    TabOrder = 6
    Text = '2+'
  end
  object txtThrowerAG: TEdit
    Left = 32
    Top = 92
    Width = 25
    Height = 21
    ReadOnly = True
    TabOrder = 7
  end
  object cbVerySunny: TCheckBox
    Left = 24
    Top = 128
    Width = 97
    Height = 17
    Caption = 'Very Sunny'
    TabOrder = 8
    OnClick = KickSkillClick
  end
  object txtKickFA: TEdit
    Left = 296
    Top = 92
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 9
  end
  object cbBigGuyAlly: TCheckBox
    Left = 16
    Top = 432
    Width = 129
    Height = 17
    Caption = 'BigGuy/Ally'
    TabOrder = 10
    Visible = False
  end
  object txtDistanceNeeded: TEdit
    Left = 128
    Top = 233
    Width = 33
    Height = 16
    AutoSize = False
    ReadOnly = True
    TabOrder = 11
    Text = '0'
  end
  object butProKick: TButton
    Left = 272
    Top = 352
    Width = 57
    Height = 25
    Caption = 'Use Pro'
    TabOrder = 12
    OnClick = butProKickRerollClick
  end
  object butDistance: TButton
    Left = 176
    Top = 384
    Width = 153
    Height = 25
    Caption = 'Distance Roll'
    TabOrder = 13
    OnClick = butDistanceRollClick
  end
  object cbWideZone: TCheckBox
    Left = 24
    Top = 192
    Width = 137
    Height = 17
    Caption = 'Wide Zone FG Attempt'
    TabOrder = 14
    OnClick = KickSkillClick
  end
  object butDistanceTeamReroll: TButton
    Left = 176
    Top = 416
    Width = 89
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 15
    OnClick = butDistanceRollReRollClick
  end
  object butDistancePro: TButton
    Left = 272
    Top = 416
    Width = 57
    Height = 25
    Caption = 'Use Pro'
    TabOrder = 16
    OnClick = butDistanceRollProClick
  end
  object txtThrowerST: TEdit
    Left = 88
    Top = 92
    Width = 25
    Height = 21
    ReadOnly = True
    TabOrder = 17
  end
  object cbFGAttempt: TCheckBox
    Left = 24
    Top = 168
    Width = 145
    Height = 17
    Caption = 'Attempting Field Goal'
    TabOrder = 18
    OnClick = FGAttemptClick
  end
  object txtDistanceKicked: TEdit
    Left = 104
    Top = 385
    Width = 33
    Height = 16
    AutoSize = False
    ReadOnly = True
    TabOrder = 19
    Text = '0'
  end
end
