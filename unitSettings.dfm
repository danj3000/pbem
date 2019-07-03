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
    ActivePage = TabSheet3
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Standard'
      object Label18: TLabel
        Left = 16
        Top = 96
        Width = 72
        Height = 13
        Caption = 'Field image file:'
      end
      object Label20: TLabel
        Left = 16
        Top = 344
        Width = 171
        Height = 13
        Caption = 'Select the league you are playing in:'
      end
      object txtFieldImageFile: TEdit
        Left = 96
        Top = 96
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
          
            'Random algorithm based on article by Robert Edwards (http://www.' +
            'pbembb.com/article.htm)')
        TabOrder = 1
      end
      object cmbLeague: TComboBox
        Left = 200
        Top = 344
        Width = 273
        Height = 21
        TabOrder = 2
        Text = 'cmbLeague'
        OnChange = cmbLeagueChange
      end
      object GroupBox2: TGroupBox
        Left = 16
        Top = 248
        Width = 297
        Height = 73
        Caption = 'Base colors'
        TabOrder = 3
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
          Transparent = False
        end
        object lblAwayColor: TLabel
          Left = 48
          Top = 40
          Width = 49
          Height = 17
          AutoSize = False
          Color = clBlue
          ParentColor = False
          Transparent = False
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
        Left = 232
        Top = 96
        Width = 89
        Height = 25
        Caption = 'Select file'
        TabOrder = 4
        OnClick = butSelectFileClick
      end
      object cbPassingRangesColored: TCheckBox
        Left = 16
        Top = 56
        Width = 233
        Height = 17
        Caption = 'Colored Passing bands for color blindness'
        TabOrder = 5
      end
      object cbBlackIce: TCheckBox
        Left = 288
        Top = 56
        Width = 281
        Height = 17
        Caption = 'Movement #s shown in Black for White/Ice field Jpgs'
        TabOrder = 6
      end
      object cbWeatherPitch: TCheckBox
        Left = 352
        Top = 104
        Width = 281
        Height = 17
        Caption = 'Show Weather Pitches'
        TabOrder = 7
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
      object Label13: TLabel
        Left = 8
        Top = 48
        Width = 76
        Height = 13
        Caption = 'Handicap Table'
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
      object Label24: TLabel
        Left = 8
        Top = 224
        Width = 65
        Height = 13
        Caption = 'Handicap file:'
      end
      object lblLustrian: TLabel
        Left = 123
        Top = 280
        Width = 3
        Height = 13
      end
      object txtHandicapTable: TEdit
        Left = 128
        Top = 48
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object txtMWTable: TEdit
        Left = 128
        Top = 80
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object txtKOTable: TEdit
        Left = 128
        Top = 112
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object txtWeatherTable: TEdit
        Left = 128
        Top = 144
        Width = 121
        Height = 21
        TabOrder = 3
      end
      object txtCardsIniFile: TEdit
        Left = 128
        Top = 184
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'bbcards_4E.ini'
      end
      object txtHandicapIniFile: TEdit
        Left = 128
        Top = 216
        Width = 121
        Height = 21
        TabOrder = 5
        Text = 'bbhandicap.ini'
      end
      object rgCardSystem: TRadioGroup
        Left = 8
        Top = 256
        Width = 377
        Height = 129
        Caption = 'Card System'
        ItemIndex = 4
        Items.Strings = (
          '1 = 1 card, 2-5 = 2 cards, 6 = 3 cards (3rd edition standard)'
          '1-5 = 0 cards, 6 = 1 card (BB Mag #2 proposed standard)'
          '1-5 = 1 card, 6 = 2 cards (modified BB Mag #2)'
          
            'Single Handicap Table, no cards except for players with certain ' +
            'skills'
          
            'Multiple Handicap Tables, no cards except for players with certa' +
            'in skills')
        TabOrder = 6
      end
      object cbLRB4KO: TCheckBox
        Left = 280
        Top = 112
        Width = 313
        Height = 17
        Caption = 'Use LRB 4.0 kick-off changes'
        TabOrder = 7
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'LRB edition'
      ImageIndex = 2
      object Label11: TLabel
        Left = 16
        Top = 8
        Width = 207
        Height = 13
        Caption = 'Use LRB edition rules for the following skills:'
      end
      object rbPO: TRadioGroup
        Left = 16
        Top = 176
        Width = 665
        Height = 65
        Caption = 'Piling On'
        ItemIndex = 2
        Items.Strings = (
          'Piling On is declared before the armour roll'
          'Piling On is declared after the armour roll'
          'Piling On is an armour re-roll')
        TabOrder = 0
      end
      object cbDC: TCheckBox
        Left = 256
        Top = 152
        Width = 153
        Height = 17
        Caption = 'Diving Catch (Vault rules)'
        TabOrder = 1
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Fouling rules'
      ImageIndex = 3
    end
    object TabSheet5: TTabSheet
      Caption = 'Player Advancement'
      ImageIndex = 4
      object rgSkillRollsAt: TRadioGroup
        Left = 8
        Top = 16
        Width = 217
        Height = 81
        Caption = 'Skill rolls at'
        ItemIndex = 1
        Items.Strings = (
          '3rd edition: 6,11,26,51,101,151,251'
          'BB2k1 edition: 6,16,31,51,76,126,176')
        TabOrder = 0
      end
      object cbNoForcedMAandAG: TCheckBox
        Left = 16
        Top = 248
        Width = 209
        Height = 17
        Caption = 'Allow a normal skill at a roll of 10 or 11'
        TabOrder = 1
      end
      object cbNoMVPs: TCheckBox
        Left = 16
        Top = 272
        Width = 361
        Height = 17
        Caption = 
          'Players with skill '#39'No MVPs'#39' and dead players can not get a MVP ' +
          'award.'
        TabOrder = 2
      end
      object cbMVPBench: TCheckBox
        Left = 16
        Top = 296
        Width = 385
        Height = 17
        Caption = 
          'Players not missing the match but not leaving the dugout can get' +
          ' the MVP'
        TabOrder = 3
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Post game'
      ImageIndex = 5
      object cbFFMinus1Per10: TCheckBox
        Left = 16
        Top = 120
        Width = 345
        Height = 17
        Caption = 
          '-1 modifier on the Fan Factor roll for each 10 points of Fan Fac' +
          'tor'
        TabOrder = 0
      end
      object cbFFTrueDice: TCheckBox
        Left = 16
        Top = 144
        Width = 369
        Height = 17
        Caption = 
          'Fan Factor always goes down on a roll of 1, always goes up on a ' +
          'roll of 6'
        TabOrder = 1
      end
      object rgWonMatchMod: TRadioGroup
        Left = 16
        Top = 16
        Width = 137
        Height = 65
        Caption = 'Won Match Modifier'
        ItemIndex = 0
        Items.Strings = (
          '+1'
          '+2')
        TabOrder = 2
      end
      object rgTiedMatchMod: TRadioGroup
        Left = 160
        Top = 16
        Width = 121
        Height = 65
        Caption = 'Tied Match Modifier'
        ItemIndex = 0
        Items.Strings = (
          '+0'
          '+1')
        TabOrder = 3
      end
      object cbNegativeWinnings: TCheckBox
        Left = 16
        Top = 184
        Width = 369
        Height = 17
        Caption = 'Use Negative Winnings rule for incurring team debt'
        TabOrder = 4
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'New Skills'
      ImageIndex = 7
      object Label19: TLabel
        Left = 24
        Top = 16
        Width = 266
        Height = 13
        Caption = 'Select the new skills and abilities you want for this match'
      end
      object Label21: TLabel
        Left = 24
        Top = 256
        Width = 261
        Height = 13
        Caption = 'Allow the following special rules for special teams/races'
      end
      object cbFragile: TCheckBox
        Left = 160
        Top = 184
        Width = 113
        Height = 17
        Caption = 'Fragile'
        TabOrder = 0
      end
      object cbElephantTrunk: TCheckBox
        Left = 160
        Top = 88
        Width = 113
        Height = 17
        Caption = 'Elephant Trunk'
        TabOrder = 1
      end
      object cbNullField: TCheckBox
        Left = 312
        Top = 208
        Width = 129
        Height = 17
        Caption = 'Tattoos or Null Field'
        TabOrder = 2
      end
      object cbGFIInjury: TCheckBox
        Left = 160
        Top = 208
        Width = 113
        Height = 17
        Caption = 'GFI Injury'
        TabOrder = 3
      end
      object cbPerfectSpiral: TCheckBox
        Left = 312
        Top = 112
        Width = 113
        Height = 17
        Caption = 'Perfect Spiral'
        TabOrder = 4
      end
      object cbHouseFlyHead: TCheckBox
        Left = 312
        Top = 40
        Width = 113
        Height = 17
        Caption = 'House Fly Head'
        TabOrder = 5
      end
      object cbCrystalSkin: TCheckBox
        Left = 24
        Top = 208
        Width = 113
        Height = 17
        Caption = 'Crystal Skin'
        TabOrder = 6
      end
      object cbWaaaghArmour: TCheckBox
        Left = 488
        Top = 160
        Width = 113
        Height = 17
        Caption = 'Waaagh Armour'
        TabOrder = 7
      end
      object cbBanishment: TCheckBox
        Left = 24
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Banishment'
        TabOrder = 8
      end
      object cbBrittle: TCheckBox
        Left = 24
        Top = 112
        Width = 113
        Height = 17
        Caption = 'Brittle'
        TabOrder = 9
      end
      object cbDaemonicAura: TCheckBox
        Left = 160
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Daemonic Aura'
        TabOrder = 10
      end
      object cbPulledPunches: TCheckBox
        Left = 312
        Top = 160
        Width = 113
        Height = 17
        Caption = 'Pulled Punches'
        TabOrder = 11
      end
      object cbBless: TCheckBox
        Left = 24
        Top = 88
        Width = 113
        Height = 17
        Caption = 'Bless'
        TabOrder = 12
      end
      object cbSingleEye: TCheckBox
        Left = 312
        Top = 184
        Width = 113
        Height = 17
        Caption = 'Single Eye'
        TabOrder = 13
      end
      object cbThirdEye: TCheckBox
        Left = 488
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Third Eye'
        TabOrder = 14
      end
      object cbBrightCrusaders: TCheckBox
        Left = 24
        Top = 280
        Width = 585
        Height = 17
        Caption = 
          'Bright Crusaders teams recover from failed Niggles on a second D' +
          '6 roll of 6 and get -1 to all Armour rolls they make'
        TabOrder = 15
      end
      object cbEvilGits: TCheckBox
        Left = 24
        Top = 304
        Width = 417
        Height = 17
        Caption = 
          'Evil Gits and Heroes of Law teams get +1 to their Postgame Fan F' +
          'actor roll'
        TabOrder = 16
      end
      object cbVampireNecrarch: TCheckBox
        Left = 24
        Top = 328
        Width = 417
        Height = 17
        Caption = 'Vampire-Necrarch teams get +1 to their Regeneration rolls'
        TabOrder = 17
      end
      object cbVampireLahmian: TCheckBox
        Left = 24
        Top = 352
        Width = 417
        Height = 17
        Caption = 
          'Vampire-Lahmian team vampires get +1 to their Hypnotic Gaze roll' +
          's'
        TabOrder = 18
      end
      object cbNurglesRotters: TCheckBox
        Left = 24
        Top = 376
        Width = 417
        Height = 17
        Caption = 'Nurgles Rotters teams rot at end of game'
        TabOrder = 19
      end
      object cbHobgoblin: TCheckBox
        Left = 24
        Top = 400
        Width = 417
        Height = 17
        Caption = 'Hobgoblin teams get +1 to Argue the Call rolls'
        TabOrder = 20
      end
      object cbWings: TCheckBox
        Left = 488
        Top = 208
        Width = 113
        Height = 17
        Caption = 'Wings'
        TabOrder = 21
      end
      object cbWarCry: TCheckBox
        Left = 488
        Top = 184
        Width = 113
        Height = 17
        Caption = 'War Cry'
        TabOrder = 22
      end
      object cbThrowStinkBomb: TCheckBox
        Left = 488
        Top = 136
        Width = 113
        Height = 17
        Caption = 'Throw Stink Bombs'
        TabOrder = 23
      end
      object cbThrowNet: TCheckBox
        Left = 488
        Top = 112
        Width = 113
        Height = 17
        Caption = 'Throw Nets'
        TabOrder = 24
      end
      object cbThrowFireball: TCheckBox
        Left = 488
        Top = 88
        Width = 153
        Height = 17
        Caption = 'Throw Fireball (On-Pitch)'
        TabOrder = 25
      end
      object cbThrowBigBomb: TCheckBox
        Left = 488
        Top = 64
        Width = 161
        Height = 17
        Caption = 'Throw Big Bomb (Grab Bag)'
        TabOrder = 26
      end
      object cbPitchPlayer: TCheckBox
        Left = 312
        Top = 136
        Width = 113
        Height = 17
        Caption = 'Pitch Player'
        TabOrder = 27
      end
      object cbMaceTail: TCheckBox
        Left = 312
        Top = 88
        Width = 113
        Height = 17
        Caption = 'Mace Tail'
        TabOrder = 28
      end
      object cbEthereal: TCheckBox
        Left = 160
        Top = 112
        Width = 113
        Height = 17
        Caption = 'Ethereal'
        TabOrder = 29
      end
      object cbChill: TCheckBox
        Left = 24
        Top = 184
        Width = 113
        Height = 17
        Caption = 'Chill'
        TabOrder = 30
      end
      object cbBulletThrow: TCheckBox
        Left = 24
        Top = 136
        Width = 113
        Height = 17
        Caption = 'Bullet Throw'
        TabOrder = 31
      end
      object cbBearHug: TCheckBox
        Left = 24
        Top = 64
        Width = 113
        Height = 17
        Caption = 'Bear Hug'
        TabOrder = 32
      end
      object cbFlyer: TCheckBox
        Left = 160
        Top = 160
        Width = 113
        Height = 17
        Caption = 'Flyer'
        TabOrder = 33
      end
      object cbLanding: TCheckBox
        Left = 312
        Top = 64
        Width = 113
        Height = 17
        Caption = 'Landing'
        TabOrder = 34
      end
      object cbDig: TCheckBox
        Left = 160
        Top = 64
        Width = 113
        Height = 17
        Caption = 'Dig'
        TabOrder = 35
      end
      object cbButterfingers: TCheckBox
        Left = 24
        Top = 160
        Width = 113
        Height = 17
        Caption = 'Butterfingers'
        TabOrder = 36
      end
      object cbHChefNew: TCheckBox
        Left = 24
        Top = 424
        Width = 465
        Height = 17
        Caption = 
          'Use Experimental Halfling Chef as Head Coach and Dwarven Runesmi' +
          'th from BB Mag #7'
        TabOrder = 37
      end
      object cbGoblinWeapons: TCheckBox
        Left = 24
        Top = 448
        Width = 297
        Height = 17
        Caption = 'Goblin teams get a free weapon at start of matches'
        TabOrder = 38
      end
      object cbFirethrower: TCheckBox
        Left = 160
        Top = 136
        Width = 145
        Height = 17
        Caption = 'Chaos Dwarf Firethrower'
        TabOrder = 39
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Armour/Injury'
      ImageIndex = 8
      object cbWeakStunty: TCheckBox
        Left = 8
        Top = 64
        Width = 409
        Height = 17
        Caption = 
          'All Stunty players suffer a +1 modifier on injury rolls, and +1 ' +
          'band width on passes.'
        TabOrder = 0
      end
      object cbNiggleOnFour: TCheckBox
        Left = 8
        Top = 96
        Width = 241
        Height = 17
        Caption = 'A Serious Injury roll of 41-46 is a Niggling Injury'
        TabOrder = 1
      end
      object cbNiggleUp: TCheckBox
        Left = 8
        Top = 128
        Width = 241
        Height = 17
        Caption = 'Each Niggling Injury adds +1 to the Injury Roll'
        TabOrder = 2
      end
      object cbNiggleHalf: TCheckBox
        Left = 8
        Top = 160
        Width = 241
        Height = 17
        Caption = 
          'Niggling Injuries are rolled before each half starts instead of ' +
          'when the game starts'
        TabOrder = 3
      end
      object cbSeparateARIR: TCheckBox
        Left = 8
        Top = 32
        Width = 457
        Height = 17
        Caption = 
          'Armour roll and Injury rolls are considered 2 different rolls (s' +
          'o you can use a skill on each)'
        TabOrder = 4
      end
      object cbNoInjMods: TCheckBox
        Left = 8
        Top = 192
        Width = 241
        Height = 17
        Caption = 'No injury modifiers allowed'
        TabOrder = 5
      end
      object cbDeStun: TCheckBox
        Left = 8
        Top = 224
        Width = 425
        Height = 17
        Caption = 
          'Players automatically go from Stunned to Prone at the end of the' +
          ' turn after their injury'
        TabOrder = 6
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Other'
      ImageIndex = 6
      object Label4: TLabel
        Left = 8
        Top = 40
        Width = 139
        Height = 13
        Caption = 'Roll needed for Regeneration'
      end
      object Label5: TLabel
        Left = 176
        Top = 40
        Width = 6
        Height = 13
        Caption = '+'
      end
      object txtRegenRollNeeded: TEdit
        Left = 160
        Top = 40
        Width = 17
        Height = 21
        TabOrder = 0
        Text = '3'
      end
      object cbPBJumpUp: TCheckBox
        Left = 8
        Top = 72
        Width = 273
        Height = 17
        Caption = 'Jump Up can be used in combination with Pass Block'
        TabOrder = 1
      end
      object cbNoTZAssist: TCheckBox
        Left = 8
        Top = 120
        Width = 617
        Height = 17
        Caption = 
          'A standing player who does not have a Tackle Zone cannot stop co' +
          'unterassists but can still assist a block (White Dwarf #182)'
        TabOrder = 2
      end
      object cbUpApoth: TCheckBox
        Left = 8
        Top = 144
        Width = 289
        Height = 17
        Caption = 'Reroll KO'#39's for a level 3 Apothecary (Citadel Journal #18)'
        TabOrder = 3
      end
      object cbUseOtherSPP: TCheckBox
        Left = 8
        Top = 192
        Width = 249
        Height = 17
        Caption = 'Use '#39'Other'#39' SPP column in HTML-team roster'
        TabOrder = 4
      end
      object cbCheerAC: TCheckBox
        Left = 8
        Top = 216
        Width = 337
        Height = 17
        Caption = 'Cheerleader/Assistant Coach Pregame rolls for Special Play cards'
        TabOrder = 5
      end
      object cbBiasedReferee: TCheckBox
        Left = 8
        Top = 240
        Width = 337
        Height = 17
        Caption = 'Biased Referee Handicap Event adds +2 to Argue the Call rolls'
        TabOrder = 6
      end
      object cbThrowStunty: TCheckBox
        Left = 8
        Top = 96
        Width = 393
        Height = 17
        Caption = 
          'Thrown Players without Stunty/Titchy have an extra band range pe' +
          'nalty'
        TabOrder = 7
      end
      object cbKicking: TCheckBox
        Left = 8
        Top = 264
        Width = 185
        Height = 17
        Caption = 'Allow Experimental Kicking Rules'
        TabOrder = 8
      end
      object cbPassFumble: TCheckBox
        Left = 8
        Top = 168
        Width = 289
        Height = 17
        Caption = 'Pass fumble only on Natural 1s instead of Modified 1s'
        TabOrder = 9
      end
      object cbPGFI: TCheckBox
        Left = 8
        Top = 288
        Width = 337
        Height = 17
        Caption = 'Use Progressive GFI'
        TabOrder = 10
      end
      object rgPassFumble: TRadioGroup
        Left = 344
        Top = 304
        Width = 313
        Height = 81
        Caption = 'Passing Fumbles'
        ItemIndex = 0
        Items.Strings = (
          'Passing fumbles on all natural and modified 1s'
          'Passing fumbles on all natural 1s and only TZ modified 1s'
          'Passing fumbles only on natural 1s')
        TabOrder = 11
      end
      object cbLateInt: TCheckBox
        Left = 344
        Top = 424
        Width = 337
        Height = 17
        Caption = 'Roll for Interception after the Pass roll'
        TabOrder = 12
      end
      object cbFG1PT: TCheckBox
        Left = 192
        Top = 264
        Width = 233
        Height = 17
        Caption = 'Field Goals and Touchdowns are both 1 point'
        TabOrder = 13
      end
      object cbOPTakeRoot: TCheckBox
        Left = 8
        Top = 312
        Width = 225
        Height = 17
        Caption = 'Use On-Pitch Take Root'
        TabOrder = 14
      end
      object cbSquarePass: TCheckBox
        Left = 344
        Top = 400
        Width = 337
        Height = 17
        Caption = 'Passing/Interception based on squares not bases'
        TabOrder = 15
      end
      object cbBHAssist: TCheckBox
        Left = 8
        Top = 336
        Width = 241
        Height = 17
        Caption = 'Boneheads can assist with Really Stupid rolls'
        TabOrder = 16
      end
      object cbDiagMove: TCheckBox
        Left = 8
        Top = 360
        Width = 241
        Height = 17
        Caption = 'Throw-in Movement can be aimed diagonally'
        TabOrder = 17
      end
      object cbSWRef: TCheckBox
        Left = 8
        Top = 384
        Width = 313
        Height = 17
        Caption = 'Secret Weapons can be permantently taken by the Referee'
        TabOrder = 18
      end
      object cbNoFieldGoals: TCheckBox
        Left = 440
        Top = 264
        Width = 233
        Height = 17
        Caption = 'Kicking Skill without Field Goal scoring rules'
        TabOrder = 19
      end
      object cbOnPitchSpellcasters: TCheckBox
        Left = 8
        Top = 408
        Width = 313
        Height = 17
        Caption = 'On-Pitch Spellcasters instead of off pitch wizards'
        TabOrder = 20
      end
      object cbLOS: TCheckBox
        Left = 8
        Top = 432
        Width = 337
        Height = 17
        Caption = '3 players if available required on the LOS (Line of Scrimmage)'
        TabOrder = 21
      end
      object cbWideZone: TCheckBox
        Left = 8
        Top = 456
        Width = 337
        Height = 17
        Caption = 'No more than 2 players allowed in each Wide Zone'
        TabOrder = 22
      end
      object cbRuleof11: TCheckBox
        Left = 8
        Top = 480
        Width = 337
        Height = 17
        Caption = 'Must set up 11 players or as many as in Reserves'
        TabOrder = 23
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
