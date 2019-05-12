object frmPickUp: TfrmPickUp
  Left = 508
  Top = 110
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Pick Up'
  ClientHeight = 456
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
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 169
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'tries to pick up the ball'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 104
    Top = 84
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '#TZ:'
  end
  object Label6: TLabel
    Left = 8
    Top = 84
    Width = 25
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'AG:'
  end
  object lblPassFailed: TLabel
    Left = 40
    Top = 312
    Width = 109
    Height = 20
    Caption = 'Pick Up failed!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 40
    Top = 224
    Width = 60
    Height = 13
    Caption = 'Roll needed:'
  end
  object txtPlayerTZ: TEdit
    Left = 136
    Top = 80
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object txtPlayerAG: TEdit
    Left = 40
    Top = 80
    Width = 33
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object gbPickUp: TGroupBox
    Left = 8
    Top = 104
    Width = 169
    Height = 89
    Caption = 'using'
    TabOrder = 2
    object cbBigHand: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Big Hand'
      TabOrder = 0
      OnClick = BigHandClick
    end
    object cbETrunk: TCheckBox
      Left = 8
      Top = 32
      Width = 137
      Height = 17
      Caption = 'Elephant Trunk or Bless'
      TabOrder = 1
      OnClick = NewSkillClick
    end
    object cbHFHead: TCheckBox
      Left = 8
      Top = 64
      Width = 97
      Height = 17
      Caption = 'House Fly Head'
      TabOrder = 2
      OnClick = NewSkillClick
    end
    object cbButterfingers: TCheckBox
      Left = 8
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Butterfingers'
      TabOrder = 3
      OnClick = NewSkillClick
    end
  end
  object butPickUpRoll: TButton
    Left = 16
    Top = 280
    Width = 153
    Height = 25
    Caption = 'Make Pick Up Roll'
    TabOrder = 3
    OnClick = butPickUpRollClick
  end
  object butsureHandsSkill: TButton
    Left = 16
    Top = 336
    Width = 153
    Height = 25
    Caption = 'Use Sure Hands Skill'
    TabOrder = 4
    OnClick = butSureHandsSkillClick
  end
  object butTeamReroll: TButton
    Left = 16
    Top = 368
    Width = 89
    Height = 25
    Caption = 'Use Team Reroll'
    TabOrder = 5
    OnClick = butTeamRerollClick
  end
  object butBounce: TButton
    Left = 16
    Top = 400
    Width = 153
    Height = 25
    Caption = 'Bounce'
    TabOrder = 6
    OnClick = butBounceClick
  end
  object txtPickUpRollNeeded: TEdit
    Left = 120
    Top = 224
    Width = 25
    Height = 17
    AutoSize = False
    ReadOnly = True
    TabOrder = 7
    Text = '2+'
  end
  object cbPouringRain: TCheckBox
    Left = 8
    Top = 200
    Width = 97
    Height = 17
    Caption = 'Pouring Rain'
    TabOrder = 8
    OnClick = cbPouringRainClick
  end
  object cbBigGuyAlly: TCheckBox
    Left = 8
    Top = 432
    Width = 97
    Height = 17
    Caption = 'Big Guy/Ally'
    TabOrder = 9
    Visible = False
  end
  object cbNBH: TCheckBox
    Left = 104
    Top = 436
    Width = 97
    Height = 17
    Caption = 'NBH'
    TabOrder = 10
    Visible = False
  end
  object cbAutoScatter: TCheckBox
    Left = 96
    Top = 200
    Width = 97
    Height = 17
    Caption = 'Auto Scatter'
    TabOrder = 11
    OnClick = NewSkillClick
  end
  object butPro: TButton
    Left = 112
    Top = 368
    Width = 57
    Height = 25
    Caption = 'Use Pro'
    Enabled = False
    TabOrder = 12
    OnClick = butProClick
  end
  object butGFI: TButton
    Left = 16
    Top = 248
    Width = 153
    Height = 25
    Caption = 'Roll GFI First?'
    TabOrder = 13
    OnClick = butGFIRollClick
  end
end
