object frmLanding: TfrmLanding
  Left = 587
  Top = 104
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Landing'
  ClientHeight = 430
  ClientWidth = 204
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblLandinger: TLabel
    Left = 8
    Top = 8
    Width = 193
    Height = 49
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblLandinger'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 169
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'tries to land'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 120
    Top = 188
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '#TZ:'
  end
  object Label6: TLabel
    Left = 8
    Top = 188
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'AG:'
  end
  object lblPassFailed: TLabel
    Left = 48
    Top = 312
    Width = 112
    Height = 20
    Caption = 'Landing failed!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 32
    Top = 256
    Width = 60
    Height = 13
    Caption = 'Roll needed:'
  end
  object txtLandingerTZ: TEdit
    Left = 152
    Top = 184
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object txtLandingerAG: TEdit
    Left = 40
    Top = 184
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object gbPass: TGroupBox
    Left = 8
    Top = 208
    Width = 193
    Height = 41
    Caption = 'using'
    TabOrder = 4
    object cbLanding: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Landing/Flyer'
      TabOrder = 0
    end
  end
  object rgAccPassBB: TRadioGroup
    Left = 8
    Top = 72
    Width = 185
    Height = 97
    Items.Strings = (
      'Accurate Pass'
      'Inaccurate Pass'
      'Pitch Player')
    TabOrder = 1
    OnClick = rgAccPassBBClick
  end
  object butLandingRoll: TButton
    Left = 24
    Top = 280
    Width = 153
    Height = 25
    Caption = 'Make Landing Roll'
    TabOrder = 0
    OnClick = butLandingRollClick
  end
  object butTeamReroll: TButton
    Left = 24
    Top = 336
    Width = 153
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 5
    OnClick = butTeamRerollClick
  end
  object butBounce: TButton
    Left = 24
    Top = 400
    Width = 153
    Height = 25
    Caption = 'Knock Player Over'
    TabOrder = 6
    OnClick = butBounceClick
  end
  object txtLandingRollNeeded: TEdit
    Left = 104
    Top = 256
    Width = 25
    Height = 17
    AutoSize = False
    ReadOnly = True
    TabOrder = 7
    Text = '2+'
  end
  object cbBigGuyAlly: TCheckBox
    Left = 144
    Top = 256
    Width = 41
    Height = 17
    Caption = 'BGA'
    TabOrder = 8
    Visible = False
  end
  object butProSkill: TButton
    Left = 24
    Top = 368
    Width = 153
    Height = 25
    Caption = 'Use Pro Skill'
    TabOrder = 9
    OnClick = butTeamRerollClick
  end
end
