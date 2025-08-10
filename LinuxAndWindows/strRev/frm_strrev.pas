          { copyright (c) StoFlow [Pseudonym] 2025 }
Unit
          frm_StrRev;

          {$CODEPAGE UTF8}
          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}

Interface

Uses
          Classes,
          SysUtils,
          Forms,
          Controls,
          Graphics,
          Dialogs,
          StdCtrls,
          ExtCtrls,
          Spin,
          ComCtrls,
          JSONPropStorage,
          fontcomboImpl;

Type

          { tHTypeHelperInteger }

          tHTypeHelperInteger               = Type Helper( tIntegerHelper) For Integer
             Function                       toString( aFormat: String; aPfx: String= ''): String;
             Function                       toXString( aFormat: String; aPfx: String= ''): String;
             Function                       toStdXString( aPfx: String): String;

          End;

          { tHTypeHelperExtended }

          tHTypeHelperExtended              = Type Helper For Extended
             Function                       toString( aFormat: String; aPfx: String= ''): String;

          End;

          { tfrm_StrRev_ }

          tfrm_StrRev_                      = Class( tForm)

          Private
             Type

             tSbPanels                      = ( sbp_TextLen, sbp_Row, sbp_Col, sbp_SelLen, sbp_Float);

          Protected

             {$hints off}
             Procedure                      _nOp( Const aAOC: Array Of Const);
             {$hints on}

             {$ifdef Windows}
             Procedure                      setTextWOLBAdj( aNewTxt: String);
             {$EndIf}
             Procedure                      setContent( aNewTxt: String);

          Public

             Procedure                      displayTextInfo();

          Published

             btn_reVerse                    : tButton;
             btn_Exit                       : tButton;
             mem_Str2Rev                    : tMemo;
             pn_Top                         : tPanel;
             sped_TextSize                  : tSpinEdit;
             sb_Status                      : tStatusBar;
             lbl_Fonts                      : tLabel;
             FontCombo1                     : tFontCombo;
             jpsStorage                     : tJSONPropStorage;
             chb_Fixed                      : tCheckBox;
             chb_Varbl                      : tCheckBox;
             chb_Mono                       : tCheckBox;
             lbl_Size                       : tLabel;
             tim_Load                       : tTimer;

             Procedure                      jpsStorageSaveProperties( aSender: tObject);

             Procedure                      mem_Str2RevChange( aSender: tObject);
             Procedure                      mem_Str2RevKeyUp ( aSender: tObject; Var aKey: Word; aShSte: tShiftState);
             Procedure                      mem_Str2RevClick ( aSender: tObject);

             Procedure                      btn_ExitClick( aSender: tObject);
             Procedure                      btn_reVerseClick( aSender: tObject);

             Procedure                      jpsStorageRestoreProperties( aSender: tObject);
             Procedure                      formShow( aSender: tObject);
             Procedure                      formClose( aSender: tObject; Var aCloseAction: tCloseAction);
             Procedure                      sped_TextSizeChange( aSender: tObject);

             Procedure                      FontCombo1Change( aSender: tObject);
             Procedure                      FontCombo1Click ( aSender: tObject);
             Procedure                      FontCombo1Enter ( aSender: tObject);

             Procedure                      changePitchAndReloadFonts( aPitch: tPropFontPitch; aSwitchOn: boolEan);
             Procedure                      chb_FixedChange( aSender: tObject);
             Procedure                      chb_VarblChange( aSender: tObject);
             Procedure                      chb_MonoChange ( aSender: tObject);

             Procedure                      tim_LoadTimer( aSender: tObject);

          End;

Var
          frm_StrRev_                       : tfrm_StrRev_;

Implementation

          {$R *.lfm}

Uses
          strUtils
          ,
          lclIntf
          {$ifdef Windows}
          ,
          lMessages
          ,
          winDOwS
          ,
          LazUTF8
          ,
          LCLMessageGlue
          {$EndIf}
          ;


          { tHTypeHelperInteger }
Function
          tHTypeHelperInteger.toString( aFormat: String; aPfx: String= ''): String;
Begin
          Result:= aPfx+ format( aFormat, [ Self]);
End;

Function
          tHTypeHelperInteger.toXString( aFormat: String; aPfx: String= ''): String;
Begin
          Result:= aPfx+ format( aFormat, [ exTended( Self)]);
End;

Function
          tHTypeHelperInteger.toStdXString( aPfx: String): String;
Begin
          Result:= toXString( '%1.0n', aPfx);
End;


          { tHTypeHelperExtended }
Function
          tHTypeHelperExtended.toString( aFormat: String; aPfx: String= ''): String;
Begin
          Result:= aPfx+ format( aFormat, [ Self]);
End;



          { tfrm_StrRev_ }

          {$hints off}

Procedure
          tfrm_StrRev_.tim_LoadTimer( aSender: tObject);
Begin
          tim_Load.Enabled:= False;
          Try
             {$ifdef Windows}
             jpsStorage.JSONFileName:= GetEnvironmentVariableUTF8( 'APPDATA')+ '\strRev.json';
             {$Else}
             jpsStorage.JSONFileName:= getEnvironmentVariable( 'HOME')+ '/strRev.json';
             {$EndIf}

             jpsStorage.restore();
             displayTextInfo();

             FontCombo1Enter( aSender);
             mem_Str2Rev.setFocus();

          Except End;
End;

Procedure
          tfrm_StrRev_._nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}

Procedure
          tfrm_StrRev_.changePitchAndReloadFonts( aPitch: tPropFontPitch; aSwitchOn: boolEan);
Begin
          If aSwitchOn
             Then
             FontCombo1.Pitches:= FontCombo1.Pitches+ [ aPitch]
          Else
             FontCombo1.Pitches:= FontCombo1.Pitches- [ aPitch];

          Try
             If ( Self.IsControlVisible And Self.Enabled)
                And
                ( []= FontCombo1.ControlState)
                Then
                FontCombo1.setFocus();
          Except End;
End;


Procedure
          tfrm_StrRev_.chb_FixedChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          changePitchAndReloadFonts( fp_FIXED_PITCH, chb_Fixed.Checked);
End;

Procedure
          tfrm_StrRev_.chb_VarblChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          changePitchAndReloadFonts( fp_Variable_PITCH, chb_Varbl.Checked);
End;

Procedure
          tfrm_StrRev_.chb_MonoChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          changePitchAndReloadFonts( fp_MONO_FONT, chb_Mono.Checked);
End;


          {$ifdef Windows}
Procedure // copied from tWin32MemoStrings.setTextStr() and removed call to AdjustLineBreaks()
          tfrm_StrRev_.setTextWOLBAdj( aNewTxt: String);
Var
          Msg                               : tLMessage;
Begin
          Windows.setWindowTextW( mem_Str2Rev.Handle, pWideChar( utf8ToUTF16( aNewTxt)));
          Msg     := Default(TLMessage);
          Msg.Msg := CM_TEXTCHANGED;
          deliverMessage(Owner, Msg);
End;
          {$EndIf}

Procedure
          tfrm_StrRev_.setContent( aNewTxt: String);
Begin
          {$IfDef Windows}
          setTextWOLBAdj( aNewTxt);
          {$Else}
          mem_Str2Rev.Text:= aNewTxt;
          {$EndIf}
End;

Procedure
          tfrm_StrRev_.jpsStorageSaveProperties( aSender: tObject);
Begin
          _nOp( [ aSender]);
          jpsStorage.doWriteString( 'Content', mem_Str2Rev.Name+ '.Text', mem_Str2Rev.Text);
End;

Procedure
          tfrm_StrRev_.jpsStorageRestoreProperties( aSender: tObject);
Var
          vStTxt                            : String;
Begin
          _nOp( [ aSender]);
          vStTxt:= jpsStorage.doReadString( 'Content', mem_Str2Rev.Name+ '.Text', mem_Str2Rev.Text);
          setContent( vStTxt);
End;

Procedure
          tfrm_StrRev_.formClose( aSender: tObject; Var aCloseAction: tCloseAction);
Begin
          _nOp( [ aSender]);
          If ( caFree<> aCloseAction)
             Then
             Exit;

          Try
             jpsStorage.save();
          Except End;
End;

Procedure
          tfrm_StrRev_.fontCombo1Click( aSender: tObject);
Begin
          _nOp( [ aSender]);
End;

Procedure
          tfrm_StrRev_.fontCombo1Change( aSender: tObject);
Begin
          _nOp( [ aSender]);
End;

Procedure
          tfrm_StrRev_.FontCombo1Enter( aSender: tObject);
Begin
          _nOp( [ aSender]);
          If ( -1= FontCombo1.ItemIndex)
             And
             ( 0< FontCombo1.Items.Count)
             Then
             FontCombo1.ItemIndex:= 0;

End;



Procedure
          tfrm_StrRev_.displayTextInfo();
Var
          vtPt1                             : tPoint;
          vInLen                            : Integer;
          vInRow                            : Integer;
          vInCol                            : Integer;
          vInSel                            : Integer;
Begin

          If ( csDestroyingHandle In ControlState)
             Or
             ( csDestroying       In ComponentState)
             Then
             Exit;

          If Not assigned( sb_Status)
             Then
             Exit;

          sb_Status.Panels[ intEger( tSbPanels.sbp_TextLen)].Text:= '';
          sb_Status.Panels[ intEger( tSbPanels.sbp_Row    )].Text:= '';
          sb_Status.Panels[ intEger( tSbPanels.sbp_Col    )].Text:= '';
          sb_Status.Panels[ intEger( tSbPanels.sbp_SelLen )].Text:= '';

          If Not assigned( mem_Str2Rev)
             Then
             Exit;

          vInLen:= mem_Str2Rev.Lines.Text.Length;

          vtPt1 := mem_Str2Rev.CaretPos;
          vInSel:= mem_Str2Rev.SelLength;
          vInRow:= vtPt1.Y+ 1;
          vInCol:= vtPt1.X+ 1;

          sb_Status.Panels[ intEger( tSbPanels.sbp_TextLen)].Text:= vInLen.toStdXString( 'Len : ');
          sb_Status.Panels[ intEger( tSbPanels.sbp_Row    )].Text:= vInRow.toStdXString( 'Row : ');
          sb_Status.Panels[ intEger( tSbPanels.sbp_Col    )].Text:= vInCol.toStdXString( 'Col : ');
          sb_Status.Panels[ intEger( tSbPanels.sbp_SelLen )].Text:= vInSel.toStdXString( 'Sen : ');

End;


Procedure
          tfrm_StrRev_.mem_Str2RevChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          displayTextInfo();
End;


Procedure
          tfrm_StrRev_.mem_Str2RevKeyUp( aSender: tObject; Var aKey: Word; aShSte: tShiftState);
Begin
          _nOp( [ aSender, aKey, intEger( aShSte)]);
          displayTextInfo();
End;


Procedure
          tfrm_StrRev_.mem_Str2RevClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          displayTextInfo();
End;


Procedure
          tfrm_StrRev_.btn_reVerseClick( aSender: tObject);
Var
          vStTxt                            : String;
Begin
          _nOp( [ aSender]);
          vStTxt:= reverseString( mem_Str2Rev.Lines.Text);
          setContent( vStTxt);
End;

Procedure
          tfrm_StrRev_.formShow( aSender: tObject);
Begin
          _nOp( [ aSender]);
          mem_Str2Rev.Lines.Text:= '';

          // load props
          Try
             tim_Load.Enabled:= True;

          Except End;
End;

Procedure
          tfrm_StrRev_.sped_TextSizeChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          If ( mem_Str2Rev.Font.Height<> sped_TextSize.Value)
             Then
             mem_Str2Rev.Font.Height:= sped_TextSize.Value;
End;

Procedure
          tfrm_StrRev_.btn_ExitClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          Self.Close();
End;

End.
