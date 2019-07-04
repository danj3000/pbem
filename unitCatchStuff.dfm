object frmCatchStuff: TfrmCatchStuff
  Left = 587
  Top = 104
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Catch'
  ClientHeight = 544
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
  OnClick = CatchSkillClick
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCatcher: TLabel
    Left = 8
    Top = 8
    Width = 193
    Height = 49
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblCatcher'
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
    Caption = 'tries to catch the Bomb'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 120
    Top = 148
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '#TZ:'
  end
  object Label6: TLabel
    Left = 8
    Top = 148
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'AG:'
  end
  object lblPassFailed: TLabel
    Left = 48
    Top = 424
    Width = 97
    Height = 20
    Caption = 'Catch failed!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 48
    Top = 368
    Width = 60
    Height = 13
    Caption = 'Roll needed:'
  end
  object Label1: TLabel
    Left = 40
    Top = 176
    Width = 94
    Height = 13
    Caption = '# Foul Appearance:'
  end
  object txtCatcherTZ: TEdit
    Left = 152
    Top = 144
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object txtCatcherAG: TEdit
    Left = 40
    Top = 144
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object gbPass: TGroupBox
    Left = 8
    Top = 200
    Width = 193
    Height = 137
    Caption = 'using'
    TabOrder = 4
    object cbExtraArms: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Extra Arms'
      TabOrder = 0
      OnClick = CatchSkillClick
    end
    object cbNervesOfSteel: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Nerves of Steel'
      TabOrder = 1
      OnClick = CatchSkillClick
    end
  end
  object rgAccPassBB: TRadioGroup
    Left = 8
    Top = 72
    Width = 185
    Height = 65
    Items.Strings = (
      'Accurate Pass'
      'Bouncing Ball')
    TabOrder = 1
    OnClick = rgAccPassBBClick
  end
  object butCatchRoll: TButton
    Left = 24
    Top = 392
    Width = 153
    Height = 25
    Caption = 'Make Catch Roll'
    TabOrder = 0
    OnClick = butCatchRollClick
  end
  object butCatchSkill: TButton
    Left = 24
    Top = 448
    Width = 153
    Height = 25
    Caption = 'Use Catch Skill'
    TabOrder = 5
    OnClick = butCatchSkillClick
  end
  object butTeamReroll: TButton
    Left = 24
    Top = 480
    Width = 89
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 6
    OnClick = butTeamRerollClick
  end
  object butBounce: TButton
    Left = 24
    Top = 512
    Width = 153
    Height = 25
    Caption = 'Bounce'
    TabOrder = 7
    OnClick = butBounceClick
  end
  object txtCatchRollNeeded: TEdit
    Left = 128
    Top = 368
    Width = 25
    Height = 17
    AutoSize = False
    ReadOnly = True
    TabOrder = 8
    Text = '2+'
  end
  object cbPouringRain: TCheckBox
    Left = 16
    Top = 344
    Width = 97
    Height = 17
    Caption = 'Pouring Rain'
    TabOrder = 9
    OnClick = cbPouringRainClick
  end
  object txtCatcherFA: TEdit
    Left = 136
    Top = 172
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 10
  end
  object cbBigGuyAlly: TCheckBox
    Left = 104
    Top = 344
    Width = 41
    Height = 17
    Caption = 'BGA'
    TabOrder = 11
    Visible = False
  end
  object cbNBH: TCheckBox
    Left = 152
    Top = 344
    Width = 41
    Height = 17
    Caption = 'NBH'
    TabOrder = 12
    Visible = False
  end
  object cbSafeThrow: TCheckBox
    Left = 0
    Top = 368
    Width = 41
    Height = 17
    Caption = 'Safe Throw'
    TabOrder = 13
    Visible = False
  end
  object butPro: TButton
    Left = 120
    Top = 480
    Width = 57
    Height = 25
    Caption = 'Use Pro'
    Enabled = False
    TabOrder = 14
    OnClick = butProClick
  end
  object cbNoTZ: TCheckBox
    Left = 160
    Top = 368
    Width = 57
    Height = 17
    Caption = 'NoTZ'
    TabOrder = 15
    Visible = False
  end
end
