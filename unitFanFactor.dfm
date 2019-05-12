object frmFanFactor: TfrmFanFactor
  Left = 158
  Top = 76
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Fan Factor'
  ClientHeight = 600
  ClientWidth = 249
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 104
    Width = 233
    Height = 65
    Caption = 'Touchdown modifier'
    TabOrder = 0
    object cbTDMod: TCheckBox
      Left = 8
      Top = 16
      Width = 161
      Height = 17
      Caption = '+1 (Scored 2+ touchdowns)'
      TabOrder = 0
    end
    object cbEach2TD: TCheckBox
      Left = 40
      Top = 40
      Width = 185
      Height = 17
      Caption = '+1 for every 2 touchdowns scored'
      Enabled = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 176
    Width = 233
    Height = 65
    Caption = 'Casulaties modifier'
    TabOrder = 1
    object cbCasMod: TCheckBox
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Caption = '+1 (Inflicted 2+ casualties)'
      TabOrder = 0
    end
    object cbEach2Cas: TCheckBox
      Left = 40
      Top = 40
      Width = 177
      Height = 17
      Caption = '+1 for every 2 casualties scored'
      Enabled = False
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 344
    Width = 233
    Height = 65
    Caption = 'Fan Factor modifier'
    TabOrder = 2
    object cbMinFFEach10: TCheckBox
      Left = 8
      Top = 16
      Width = 185
      Height = 17
      Caption = '-1 for each 10 points of Fan Factor'
      TabOrder = 0
    end
    object cbTeamFFMod: TCheckBox
      Left = 8
      Top = 40
      Width = 185
      Height = 17
      Caption = '+1 modifer for Special Teams'
      TabOrder = 1
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 89
    Caption = 'Result modifier'
    TabOrder = 3
    object rbWonMatch: TRadioButton
      Left = 8
      Top = 16
      Width = 121
      Height = 17
      Caption = '+1 (Won the Match)'
      TabOrder = 0
    end
    object rbTiedMatch: TRadioButton
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = '0 (Tied Match)'
      TabOrder = 1
    end
    object rbLostMatch: TRadioButton
      Left = 8
      Top = 64
      Width = 121
      Height = 17
      Caption = '-1 (Lost the Match)'
      TabOrder = 2
    end
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 248
    Width = 233
    Height = 89
    Caption = 'Match modifier'
    TabOrder = 4
    object rbFFRegularSeason: TRadioButton
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = '0 (Regular Season)'
      TabOrder = 0
    end
    object rbFFSemiFinal: TRadioButton
      Left = 8
      Top = 40
      Width = 113
      Height = 17
      Caption = '+1 (Semi-final)'
      TabOrder = 1
    end
    object rbFFFinal: TRadioButton
      Left = 8
      Top = 64
      Width = 113
      Height = 17
      Caption = '+2 (Final)'
      TabOrder = 2
    end
  end
  object GroupBox6: TGroupBox
    Left = 8
    Top = 472
    Width = 233
    Height = 57
    Caption = 'Before modification setting'
    TabOrder = 5
    object Label1: TLabel
      Left = 25
      Top = 36
      Width = 129
      Height = 13
      Caption = 'and always up on a roll of 6'
    end
    object cbFFPreMod: TCheckBox
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Caption = 'Always down on a roll of 1'
      TabOrder = 0
    end
  end
  object GroupBox7: TGroupBox
    Left = 8
    Top = 424
    Width = 233
    Height = 41
    Caption = 'Card modifier'
    TabOrder = 6
    object cbBigMatch: TCheckBox
      Left = 8
      Top = 16
      Width = 121
      Height = 17
      Caption = '+3 (The Big Match)'
      TabOrder = 0
    end
  end
  object butFFUse: TButton
    Left = 8
    Top = 536
    Width = 113
    Height = 33
    Caption = 'Use these modifiers'
    TabOrder = 7
    OnClick = butFFUseClick
  end
  object butFFCancel: TButton
    Left = 128
    Top = 536
    Width = 113
    Height = 33
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = butFFCancelClick
  end
end
