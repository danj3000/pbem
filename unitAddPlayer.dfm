object frmAddPlayer: TfrmAddPlayer
  Left = 548
  Top = 109
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bloodbowl Add Player'
  ClientHeight = 408
  ClientWidth = 293
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
    Top = 40
    Width = 53
    Height = 13
    Caption = 'Roster slot:'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 40
    Height = 13
    Caption = 'Number:'
  end
  object Label3: TLabel
    Left = 16
    Top = 88
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 40
    Height = 13
    Caption = 'Position:'
  end
  object Label5: TLabel
    Left = 16
    Top = 136
    Width = 19
    Height = 13
    Caption = 'MA:'
  end
  object Label6: TLabel
    Left = 16
    Top = 184
    Width = 18
    Height = 13
    Caption = 'AG:'
  end
  object Label7: TLabel
    Left = 16
    Top = 160
    Width = 17
    Height = 13
    Caption = 'ST:'
  end
  object Label8: TLabel
    Left = 16
    Top = 208
    Width = 17
    Height = 13
    Caption = 'AV:'
  end
  object Label9: TLabel
    Left = 16
    Top = 232
    Width = 27
    Height = 13
    Caption = 'Skills:'
  end
  object Label10: TLabel
    Left = 16
    Top = 312
    Width = 24
    Height = 13
    Caption = 'Cost:'
  end
  object lblTeamName: TLabel
    Left = 16
    Top = 8
    Width = 265
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Team'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 128
    Top = 312
    Width = 6
    Height = 13
    Caption = 'k'
  end
  object Label12: TLabel
    Left = 16
    Top = 288
    Width = 30
    Height = 13
    Caption = 'Value:'
  end
  object Label13: TLabel
    Left = 128
    Top = 288
    Width = 6
    Height = 13
    Caption = 'k'
  end
  object Label14: TLabel
    Left = 16
    Top = 336
    Width = 36
    Height = 13
    Caption = 'Picture:'
  end
  object cmdAddPlayer: TButton
    Left = 72
    Top = 368
    Width = 137
    Height = 33
    Caption = 'Add Player'
    TabOrder = 0
    OnClick = cmdAddPlayerClick
  end
  object cmbRosterSlot: TComboBox
    Left = 72
    Top = 40
    Width = 49
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object txtNumber: TEdit
    Left = 72
    Top = 64
    Width = 49
    Height = 21
    TabOrder = 2
    OnExit = txtNumberExit
  end
  object txtName: TEdit
    Left = 72
    Top = 88
    Width = 209
    Height = 21
    TabOrder = 3
  end
  object txtPosition: TEdit
    Left = 72
    Top = 112
    Width = 209
    Height = 21
    TabOrder = 4
  end
  object txtMA: TEdit
    Left = 72
    Top = 136
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '1'
    OnExit = txtStatExit2
  end
  object txtST: TEdit
    Left = 72
    Top = 160
    Width = 49
    Height = 21
    TabOrder = 6
    Text = '1'
    OnExit = txtStatExit
  end
  object txtAG: TEdit
    Left = 72
    Top = 184
    Width = 49
    Height = 21
    TabOrder = 7
    Text = '1'
    OnExit = txtStatExit
  end
  object txtAV: TEdit
    Left = 72
    Top = 208
    Width = 49
    Height = 21
    TabOrder = 8
    Text = '1'
    OnExit = txtStatExit
  end
  object txtCost: TEdit
    Left = 72
    Top = 304
    Width = 49
    Height = 21
    TabOrder = 9
    OnExit = txtCostExit
  end
  object memSkills: TMemo
    Left = 72
    Top = 232
    Width = 209
    Height = 41
    TabOrder = 10
  end
  object cbPeaked: TCheckBox
    Left = 224
    Top = 208
    Width = 97
    Height = 17
    Caption = 'Peaked'
    TabOrder = 11
  end
  object txtValue: TEdit
    Left = 72
    Top = 280
    Width = 49
    Height = 21
    TabOrder = 12
    OnExit = txtValueExit
  end
  object txtPicture: TEdit
    Left = 72
    Top = 328
    Width = 105
    Height = 21
    TabOrder = 13
  end
  object butSelectFile: TButton
    Left = 192
    Top = 328
    Width = 89
    Height = 25
    Caption = 'Select file'
    TabOrder = 14
    OnClick = butSelectFileClick
  end
  object dlgPic: TOpenDialog
    Filter = 'JPeg|*.jpg|Bitmap|*.bmp|Gif|*.gif'
    Left = 248
    Top = 368
  end
end
