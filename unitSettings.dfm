object frmSettings: TfrmSettings
  Left = 201
  Top = 110
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Settings'
  ClientHeight = 578
  ClientWidth = 713
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCantChange: TLabel
    Left = 48
    Top = 552
    Width = 607
    Height = 24
    Caption = 
      'Once the game has started you can NOT change the settings anymor' +
      'e!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
    Visible = False
  end
  object pcSettings: TPageControl
    Left = 0
    Top = 0
    Width = 713
    Height = 545
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Standard'
      object Label18: TLabel
        Left = 16
        Top = 41
        Width = 72
        Height = 13
        Caption = 'Field image file:'
      end
      object Label11: TLabel
        Left = 8
        Top = 424
        Width = 207
        Height = 13
        Caption = 'Use LRB edition rules for the following skills:'
      end
      object txtFieldImageFile: TEdit
        Left = 94
        Top = 39
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'field.jpg'
      end
      object rgRandomAlgorithm: TRadioGroup
        Left = 16
        Top = 136
        Width = 609
        Height = 97
        Caption = 'Random Algorithm'
        ItemIndex = 2
        Items.Strings = (
          'Standard Delphi'
          'Random algorithm supplied by Brian Hixon'
          'Random algorithm based on article by Robert Edwards')
        TabOrder = 1
      end
      object GroupBox2: TGroupBox
        Left = 16
        Top = 248
        Width = 297
        Height = 73
        Caption = 'Base colors'
        TabOrder = 2
        object Label22: TLabel
          Left = 8
          Top = 16
          Width = 28
          Height = 13
          Caption = 'Home'
        end
        object Label23: TLabel
          Left = 8
          Top = 40
          Width = 26
          Height = 13
          Caption = 'Away'
        end
        object lblHomeColor: TLabel
          Left = 48
          Top = 16
          Width = 49
          Height = 17
          AutoSize = False
          Color = clRed
          ParentColor = False
          Transparent = True
        end
        object lblAwayColor: TLabel
          Left = 48
          Top = 40
          Width = 49
          Height = 17
          AutoSize = False
          Color = clBlue
          ParentColor = False
          Transparent = True
        end
        object Button1: TButton
          Left = 184
          Top = 16
          Width = 97
          Height = 41
          Caption = 'Reset colors'
          TabOrder = 0
          OnClick = Button1Click
        end
        object butHomeColorChange: TButton
          Left = 104
          Top = 16
          Width = 73
          Height = 17
          Caption = 'Change'
          TabOrder = 1
          OnClick = butHomeColorChangeClick
        end
        object butAwayColorChange: TButton
          Left = 104
          Top = 40
          Width = 73
          Height = 17
          Caption = 'Change'
          TabOrder = 2
          OnClick = butAwayColorChangeClick
        end
      end
      object butSelectFile: TButton
        Left = 237
        Top = 37
        Width = 76
        Height = 25
        Caption = 'Select file'
        TabOrder = 3
        OnClick = butSelectFileClick
      end
      object cbPassingRangesColored: TCheckBox
        Left = 16
        Top = 16
        Width = 233
        Height = 17
        Caption = 'Colored Passing bands for color blindness'
        TabOrder = 4
      end
      object cbBlackIce: TCheckBox
        Left = 44
        Top = 90
        Width = 281
        Height = 17
        Caption = 'Movement #s shown in Black for White/Ice field Jpgs'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object cbWeatherPitch: TCheckBox
        Left = 44
        Top = 66
        Width = 281
        Height = 17
        Caption = 'Show Weather Pitches'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object cbDC: TCheckBox
        Left = 16
        Top = 480
        Width = 153
        Height = 17
        Caption = 'Diving Catch (Vault rules)'
        TabOrder = 7
      end
      object cbDeStun: TCheckBox
        Left = 16
        Top = 344
        Width = 425
        Height = 17
        Caption = 
          'Players automatically go from Stunned to Prone at the end of the' +
          ' turn after their injury'
        Checked = True
        State = cbChecked
        TabOrder = 8
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Tables'
      ImageIndex = 1
      object Label12: TLabel
        Left = 8
        Top = 16
        Width = 166
        Height = 13
        Caption = 'Select which tables are to be used:'
      end
      object Label14: TLabel
        Left = 8
        Top = 80
        Width = 107
        Height = 13
        Caption = 'Match Winnings Table'
      end
      object Label15: TLabel
        Left = 8
        Top = 112
        Width = 68
        Height = 13
        Caption = 'Kick Off Table'
      end
      object Label16: TLabel
        Left = 8
        Top = 144
        Width = 71
        Height = 13
        Caption = 'Weather Table'
      end
      object Label17: TLabel
        Left = 8
        Top = 192
        Width = 46
        Height = 13
        Caption = 'Cards file:'
      end
      object lblLustrian: TLabel
        Left = 123
        Top = 280
        Width = 3
        Height = 13
      end
      object txtMWTable: TEdit
        Left = 128
        Top = 80
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object txtKOTable: TEdit
        Left = 128
        Top = 112
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object txtWeatherTable: TEdit
        Left = 128
        Top = 144
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object txtCardsIniFile: TEdit
        Left = 128
        Top = 184
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'bbcards_MBBL_LRB6'
      end
      object cbLRB4KO: TCheckBox
        Left = 280
        Top = 112
        Width = 313
        Height = 17
        Caption = 'Use LRB 4.0 kick-off changes'
        TabOrder = 4
      end
    end
  end
  object butAccept: TButton
    Left = 176
    Top = 552
    Width = 289
    Height = 25
    Caption = 'Accept these settings'
    TabOrder = 1
    OnClick = butAcceptClick
  end
  object cdColorDialog: TColorDialog
    Left = 664
    Top = 24
  end
  object dlgPic: TOpenDialog
    Filter = 'JPeg|*.jpg|Bitmap|*.bmp|Gif|*.gif'
    Left = 680
    Top = 512
  end
end
