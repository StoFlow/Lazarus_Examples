// parts of the sourcecode were initially taken (and somewhat changed) from "lrstolfm" by Mattias Gaertner
// parts of the sourcecode were initially taken (and somewhat changed) from "graphics.pp"
// Author of the remaining parts is StoFlow (pseudonym)
// this is a pilot and learning program (to me) - feel free to use it for your own purposes if you wish (no warranty, no promises - as always)
Unit
          frm_lrsLearn;

          {$mode objfpc}{$H+}
          {$ModeSwitch typehelpers}
          {$Modeswitch advancedrecords}

Interface

Uses
          Classes
          ,
          SysUtils
          ,
          Forms
          ,
          Controls
          ,
          Graphics
          ,
          Dialogs
          ,
          StdCtrls
          ,
          lResources
          ,
          lResourceEx
          ,
          lResourceListEx
          ,
          ExtCtrls
          ,
          JSONPropStorage
          ,
          Buttons
          ,
          triState
          ;

Type

          { tfrm_lrsLearn_ }

          tfrm_lrsLearn_                    = Class( tForm)

             btn_appendStart                : tButton;
             btn_LoadLBX: TButton;
             btn_Start                      : tButton;
             btn_ResetProfile               : tButton;
             btn_Exit                       : tButton;

             btn_SaveLBX                    : tButton;
             btn_Export                     : tButton;
             btn_Replace                    : tButton;
             btn_Import                     : tButton;

             btn_New                        : tButton;
             btn_EditRes                    : tButton;
             btn_RemoveRes                  : tButton;
             btn_clearLBX                   : tButton;

             btn_AllWriteBack               : tButton;
             btn_SelAutoExpFldr             : tButton;
             btn_opnAutSvFldr               : tBitBtn;
             btn_EmptMsgs                   : tButton;
             btn_SelWriteBack               : tButton;
             btn_LoadLRS                    : tButton;
             btn_SaveLRS                    : tButton;
             fd_Source                      : tFindDialog;

             img_prev                       : tImage;
             jpsStorage                     : tJSONPropStorage;
             lbet_AutoExpFld                : tLabeledEdit;

             lbl_Msgs                       : tLabel;
             lbl_Src                        : tLabel;
             lbl_ResLst                     : tLabel;
             lbl_SimgPrev                   : tLabel;
             lbx_Ress                       : tListBox;

             mem_Source                     : tMemo;
             mem_CompMsgs                   : tMemo;

             od_SingleLBXRes                : tOpenDialog;
             od_loadLBX                     : tOpenDialog;
             pn_LeftClt                     : tPanel;
             pn_LeftBtm                     : tPanel;
             sd_ResFromLBX                  : tSaveDialog;
             sd_saveLBX                     : tSaveDialog;

             sfd_SelFldr                    : tSelectDirectoryDialog;

             sd_saveLRS                     : tSaveDialog;
             od_loadLRS                     : tOpenDialog;

             pn_Left                        : tPanel;
             spl_LeftBtm2Clt                : tSplitter;
             spl_l2c                        : tSplitter;
             pn_Client                      : tPanel;

             tim_Load                       : tTimer;
             tim_AEoC                       : tTimer;

             Procedure                      btn_ExitClick( aSender: tObject);
             Procedure                      btn_ResetProfileClick( aSender: tObject);

             Procedure                      lrScript2List( aSender: tObject; aDoAppend: boolEan);
             Procedure                      btn_appendStartClick( aSender: tObject);
             Procedure                      btn_StartClick( aSender: tObject);

             Procedure                      saveLBX2LrsFile( aFileName: String);
             Procedure                      saveLBX2JsnFile( aFileName: String);
             Procedure                      btn_SaveLBXClick( aSender: tObject);

             Procedure                      btn_LoadLBXClick( aSender: tObject);

             Procedure                      btn_ExportClick( aSender: tObject);
             Procedure                      btn_ReplaceClick( aSender: tObject);
             Procedure                      btn_ImportClick( aSender: tObject);
             Procedure                      btn_NewClick( aSender: tObject);
             Procedure                      btn_EditResClick( aSender: tObject);
             Procedure                      btn_RemoveResClick( aSender: tObject);
             Procedure                      btn_clearLBXClick( aSender: tObject);

             Procedure                      btn_EmptMsgsClick( aSender: tObject);

             Procedure                      btn_SelWriteBackClick( aSender: tObject);
             Procedure                      btn_AllWriteBackClick( aSender: tObject);

             Procedure                      btn_LoadLRSClick( aSender: tObject);
             Procedure                      btn_SaveLRSClick( aSender: tObject);
             Procedure                      fd_SourceFind( aSender: tObject);

             Procedure                      tim_AEoCTimer( aSender: tObject);
             Procedure                      lbet_AutoExpFldChange( aSender: tObject);
             Procedure                      btn_SelAutoExpFldrClick( aSender: tObject);
             procedure                      btn_opnAutSvFldrClick( aSender: tObject);

             Function                       checkEnaLBXDepBtns(): boolEan;

             Function                       checkGetLResource( aIdx: intEger; Out aOutLRRes: tLResourceEx): boolEan; Overload;
             Function                       checkGetLResource( Out aOutLRRes: tLResourceEx; Out aOutIdx: intEger): boolEan; Overload;
             Function                       checkGetLResource( Out aOutLRRes: tLResourceEx): boolEan; Overload;

             Function                       checkGetOrCreateLResource( Out aOutLRRes: tLResourceEx): boolEan;
             Function                       lbxResToMemStr( Out aOutMemSt: tMemoryStream; Out aOutLRRes: tLResourceEx): boolEan;
             Function                       checkSave2File( aMemStm: tMemoryStream; aFilePath: String): boolEan;
             Function                       checkAutoSave( aMemStm: tMemoryStream; aLazRes: tLResourceEx): boolEan;
             Procedure                      autoSaveHsh990File( aFileName: String; aContents: String);
             Procedure                      autoSaveBinFileFromHsh990( aFileName: String; aContents: String);

             Procedure                      lbx_RessClick( aSender: tObject);

             Function                       getProfileFile(): String;

             Procedure                      jpsStorageRestoreProperties( aSender: tObject);

             Procedure                      formShow( aSender: tObject);
             Procedure                      formCreate( aSender: tObject);

             Procedure                      jpsStorageSaveProperties( aSender: tObject);

             Procedure                      formClose( aSender: tObject; Var aCloseAction: tCloseAction);
             Procedure                      formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);

             Procedure                      mem_SourceChange( aSender: tObject);
             Procedure                      mem_SourceKeyUp( aSender: tObject; Var aKey: Word; aShift: tShiftState);

             Procedure                      tim_LoadTimer( aSender: tObject);

             Procedure                      img_prevClick( aSender: tObject);

          Private

             reli_List                      : tLResourceListEx;
             bln_Loading                    : boolEan;
             bln_ChangedScript              : boolEan;
             bln_ChangedObjLst              : boolEan;
             bln_ReSetting                  : boolEan;
             bln_AlreadySavedToPropStore    : boolEan;

          Protected

             Procedure                      reflectChangedInLabel( aLbl: tLabel; aBaseCap: String; aWasChngd: boolEan);
             Procedure                      set_changedScript( aIsChanged: boolEan);
             Procedure                      set_changedObjLst( aIsChanged: boolEan);

          Public

             Const

             cstr_MEM_LRS_SRC               : String= 'L&R-Script';
             cstr_LBX_LRS_LST               : String= 'Resour&ces';
             cstr_OFD_SNG_TTL               : String= '%verb% selected resource from file...';

             Function                       manageChanges( aAddAbort: boolEan; aCtx: String; Var aCtxState: boolEan; aCBProc: tNotifyEvent): tTriState;

             Procedure                      prepareReLiList( aOptDontFree: boolEan= False);
             Procedure                      prepare();
             Procedure                      condFocusResults( aOptSelLastOne: boolEan= False; aOptIdx: intEger= -1);

             Procedure                      add2ListBoxSink( aLaRe: tLResourceEx);
             Procedure                      addLbxItm( aLine: String; aObject: tObject);

             Procedure                      refreshListFromReLi( aOptIdx: intEger= -1);

             Function                       createRstrImgFromLazarusResource( aResTpe: String; aStream: tMemoryStream; aMinimumClass: tRasterImageClass): tRasterImage;

             Function                       indexOf( aStr: String; aTkn: String): intEger;
             Procedure                      memoFind( aCtrl: tMemo; aTkn: String; aNext: boolEan= False);

             Procedure                      writeEmptyProfileFile();
             Procedure                      deleteProfileFile();


          End;




Const
          cstrColFulMinIco                  : String=   '  #0#0#1#0#1#0#4#4#16#0#1#0#4#0#136#0#0#0#22#0#0#0''(''#0#0#0#4#0#0#0#8#0#0#0#1#0#4'#$0D#$0A+
                                                        ' +#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#128#0#0#0#0#128#0#0'#$0D#$0A   +
                                                        ' +#128#128#0#0#0#0#128#0#128#0#128#0#0#128#128#0#192#192#192#0#128#128#128#0#255'#$0D#$0A   +
                                                        ' +#0#0#0#0#255#0#0#255#255#0#0#0#0#255#0#255#0#255#0#0#255#255#0#255#255#255#0#22'#$0D#$0A  +
                                                        ' +''S''#0#0#128''B''#0#0#158#219#0#0#15#202#0#0#0#0#0#0''@''#0#0#0#0#0#0#0#0#0#0#0';



Var
          frm_lrsLearn_                     : tfrm_lrsLearn_;

Implementation

          {$R frm_lrslearn.lfm}

Uses
          FPImage
          ,
          fpimgcmn
          ,
          //pngcomn
          //,
          lazUtf8
          ,
          typinfo
          ,
          proCess
          ,
          clipBRD
          //,
          //fpjsonrtti
          //,
          //fpJSon
          ,
          frm_ResProps
          ,
          stringHelper
          ,
          printableBin
          ,
          strObj
          ,
          nOp
          ,
          //sdl
          //,
          lclintf
          ,
          LCLType
          ;


          { tfrm_lrsLearn_ }

Procedure
          tfrm_lrsLearn_.prepareReLiList( aOptDontFree: boolEan= False);
Begin
          If ( Nil<> reli_List)
             And
             ( Not aOptDontFree)
             Then
             freeAndNil( reli_List);

          If ( Nil= reli_List)
             Then
             reli_List:= tLResourceListEx.create( Self, @mem_CompMsgs.append);
End;

Procedure
          tfrm_lrsLearn_.prepare();
Begin
          lbx_Ress.clear();
          prepareReLiList();
End;

Procedure
          tfrm_lrsLearn_.reflectChangedInLabel( aLbl: tLabel; aBaseCap: String; aWasChngd: boolEan);
Begin
          aLbl.Caption       := aBaseCap;
          If ( aWasChngd)
             Then
             aLbl.Caption    := '*'+ aBaseCap;

End;

Procedure
          tfrm_lrsLearn_.set_changedScript( aIsChanged: boolEan);
Begin
          If ( bln_ChangedScript<> aIsChanged)
             Then
             bln_ChangedScript:= aIsChanged;

          reflectChangedInLabel( lbl_Src, cstr_MEM_LRS_SRC, bln_ChangedScript);
End;

Procedure
          tfrm_lrsLearn_.set_changedObjLst( aIsChanged: boolEan);
Begin
          If ( bln_ChangedObjLst<> aIsChanged)
             Then
             bln_ChangedObjLst     := aIsChanged;

          reflectChangedInLabel( lbl_ResLst, cstr_LBX_LRS_LST, bln_ChangedObjLst);
End;

Procedure
          tfrm_lrsLearn_.addLbxItm( aLine: String; aObject: tObject);
Begin
          lbx_Ress.addItem( aLine, aObject);
          set_changedObjLst( True);
End;


Procedure
          tfrm_lrsLearn_.condFocusResults( aOptSelLastOne: boolEan= False; aOptIdx: intEger= -1);
Begin
          If ( 1> lbx_Ress.Count)
             Then
             exit;

          If Not ( lbx_Ress.Enabled)
             Then
             exit;

          lbx_Ress.setFocus();

          If Not ( aOptSelLastOne)
             Then
             If ( 0> aOptIdx)
                Or
                ( lbx_Ress.Count<= aOptIdx)
                Then
                lbx_Ress.ItemIndex:= 0
             Else
                lbx_Ress.ItemIndex:= aOptIdx
          Else
             lbx_Ress.ItemIndex:= ( lbx_Ress.Count- 1);

          lbx_RessClick( Nil);

End;


Procedure
          tfrm_lrsLearn_.lrScript2List( aSender: tObject; aDoAppend: boolEan);
Begin
          _nOp( [ aSender]);

          prepareReLiList( True);

          reli_List.lrsLines2List( mem_Source.Lines, aDoAppend);

          refreshListFromReLi();
End;


Procedure
          tfrm_lrsLearn_.btn_appendStartClick( aSender: tObject);
Begin
          mem_CompMsgs.append( 'Parsing script and appending to list...');
          lrScript2List( aSender, True);
End;

Procedure
          tfrm_lrsLearn_.btn_StartClick( aSender: tObject);
Begin
          If manageChanges( True, 'List', bln_ChangedObjLst, @btn_SaveLRSClick)= tsNone
             Then
             Exit;

          mem_CompMsgs.append( 'Parsing script and replacing list...');
          lrScript2List( aSender, False);
End;

Procedure
          tfrm_lrsLearn_.formCreate( aSender: tObject);
Begin
          _nOp( [ aSender]);
          bln_AlreadySavedToPropStore:= False;
          reli_List                  := Nil;
          bln_ReSetting              := False;
          bln_Loading                := True;
          jpsStorage.JSONFileName    := '';  // prevents a too early and sometimes double loading of the settings //getProfileFile();
End;

Procedure
          tfrm_lrsLearn_.formShow( aSender: tObject);
Begin
          _nOp( [ aSender]);
          mem_Source.Lines.Text  := '';
          jpsStorage.JSONFileName:= getProfileFile();

          // load props
          Try
             mem_CompMsgs.append( 'Loading....');
             tim_Load.Enabled:= True;

          Except End;
End;

Function
          tfrm_lrsLearn_.getProfileFile(): String;
Begin
          Result:= 'lrsLearn.json';
          Try
             {$ifdef Windows}
             Result:= GetEnvironmentVariableUTF8( 'APPDATA')+ '\lrsLearn.json';
             {$Else}
             Result:= getEnvironmentVariable( 'HOME')+ '/lrsLearn.json';
             {$EndIf}
          Except
          End;
End;

Procedure
          tfrm_lrsLearn_.tim_LoadTimer( aSender: tObject);
Begin
          bln_Loading:= True;
          _nOp( [ aSender]);

          tim_Load.Enabled:= False;
          Try
             mem_CompMsgs.clear();
             Application.processMessages();

             mem_CompMsgs.append( 'Loading from property store....');
             jpsStorage.restore();

             set_changedScript( False);
             set_changedObjLst( False);
          Finally
             bln_Loading:= False;
          End;
End;


          // copied from graphics.pp and changed
Function
          tfrm_lrsLearn_.createRstrImgFromLazarusResource( aResTpe: String; aStream: tMemoryStream; aMinimumClass: tRasterImageClass): tRasterImage;
Var
          GraphicClass                      : tGraphicClass;
Begin
          Result:= nil;

          If ( Nil= aStream)
             Then
             Exit;

          GraphicClass:= getGraphicClassForFileExtension( aResTpe);

          If ( Nil= GraphicClass)
             Then
             Exit;

          If Not GraphicClass.InheritsFrom( aMinimumClass)
             Then
             Exit;

          Result:= tRasterImage( GraphicClass.Create());

          Try
             Result.LoadFromStream( aStream);
          Except

             On E: Exception
                Do
                Begin
                     mem_CompMsgs.append( 'Result.LoadFromStream( aStream) => '+ E.Message);
                     Result.Free;
                     Result:= nil;
             End;

          End;
End;



Function
          tfrm_lrsLearn_.checkEnaLBXDepBtns(): boolEan;
Var
          vInIdx                            : intEger;
Begin

          vInIdx:= lbx_Ress.ItemIndex;
          Result:= ( -1< vInIdx);

          btn_Export.Enabled      := Result;
          btn_Replace.Enabled     := Result;
          btn_EditRes.Enabled     := Result;
          btn_SelWriteBack.Enabled:= Result;
          btn_AllWriteBack.Enabled:= Result;
          btn_RemoveRes.Enabled   := Result;
          btn_clearLBX.Enabled    := Result;
          btn_SaveLBX.Enabled     := Result;
End;

Function
          tfrm_lrsLearn_.checkGetLResource( aIdx: intEger; Out aOutLRRes: tLResourceEx): boolEan; Overload;
Var
          vtObj1                            : tObject;
Begin
          aOutLRRes:= Nil;
          Result   := False;

          If ( 0> aIdx)
             Or
             ( lbx_Ress.Count<= aIdx)
             Then
             Exit;

          vtObj1   := lbx_Ress.Items.Objects[ aIdx];

          If ( Nil= vtObj1)
             Or
             ( Not( vtObj1 Is tLResource))
             Then
             Exit;

          aOutLRRes:= vtObj1 As tLResourceEx;
          Result   := ( ''<> aOutLRRes.Name);
End;

Function
          tfrm_lrsLearn_.checkGetLResource( Out aOutLRRes: tLResourceEx; Out aOutIdx: intEger): boolEan; Overload;
Begin
          aOutLRRes:= Nil;
          aOutIdx  := -1;
          Result   := checkEnaLBXDepBtns();

          If Not Result
             Then
             Exit;

          aOutIdx  := lbx_Ress.ItemIndex;
          Result   := checkGetLResource( aOutIdx, aOutLRRes);

End;

Function
          tfrm_lrsLearn_.checkGetLResource( Out aOutLRRes: tLResourceEx): boolEan;  Overload;
Var
          vInIdx                            : intEger;
Begin
          Result:= checkGetLResource( aOutLRRes, vInIdx);
End;

Function
          tfrm_lrsLearn_.checkGetOrCreateLResource( Out aOutLRRes: tLResourceEx): boolEan;
Begin
          aOutLRRes:= Nil;
          Result:= checkGetLResource( aOutLRRes);

          If Result
             Then
             Exit;

          aOutLRRes:= tLResourceEx.create();

          aOutLRRes.ValueType:= 'ICO';
          aOutLRRes.Name     := 'COLORFUL_MINI_ICO';
          aOutLRRes.Value    := cstrColFulMinIco;

          Result:= assigned( aOutLRRes);
End;

Procedure
          tfrm_lrsLearn_.img_prevClick( aSender: tObject);
Begin
          _nOp( [ aSender]);

          If ( Nil<> img_prev)
             And
             ( Nil<> img_prev.Picture)
             Then
             Begin
                  Clipboard.open();
                  Clipboard.assign( img_prev.Picture);
                  Clipboard.close();
          End;
End;

Function
          tfrm_lrsLearn_.manageChanges( aAddAbort: boolEan; aCtx: String; Var aCtxState: boolEan; aCBProc: tNotifyEvent): tTriState;
Var
          vtMdRs                            : tModalResult;
          vtMbts                            : tMsgDlgButtons;
begin
          Result:= tsFalse;
          vtMdRs:= mrYes;
          If Not assigned( aCBProc)
             Then
             Exit;

          vtMbts:= [ mbYes, mbNo];

          If aAddAbort
             Then
             vtMbts+= [ mbAbort];

          While ( aCtxState) And ( mrNo<> vtMdRs)
                Do
                Begin
                     vtMdRs:= messageDlg( 'There are changes in the '+ aCtx+ '. Save It?', mtConfirmation, vtMbts, 0, mbYes);
                     If ( mrAbort= vtMdRs)
                        Then
                        Begin
                             Result:= tsNone;
                             Exit;
                     End;

                     If ( mrYes= vtMdRs)
                        Then
                        aCBProc( Nil);
          End;
          If ( mrYes= vtMdRs)
             Then
             Result:= tsTrue;
End;

Procedure
          tfrm_lrsLearn_.formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
Begin
          _nOp( [ aSender]);

          aVarCanClose:= True;

          If manageChanges( True, 'Script', bln_ChangedScript, @btn_SaveLRSClick)= tsNone
             Then
             aVarCanClose:= False
          Else
             If manageChanges( True, 'List'  , bln_ChangedObjLst, @btn_SaveLBXClick)= tsNone
                Then
                aVarCanClose:= False;

End;

Procedure
          tfrm_lrsLearn_.formClose( aSender: tObject; Var aCloseAction: tCloseAction);
Begin
          _nOp( [ aSender]);

          If ( caFree<> aCloseAction)
             Then
             Exit;

          Try
             If ( Not bln_ReSetting)
                Then
                Begin
                     mem_CompMsgs.append( 'Saving to property store...');
                     jpsStorage.save();
             End;
          Except End;
End;

Procedure
          tfrm_lrsLearn_.mem_SourceChange( aSender: tObject);
Begin
          _nOp( [ aSender]);

          If Not bln_Loading
             Then
             set_changedScript( True);
End;

Procedure
          tfrm_lrsLearn_.mem_SourceKeyUp( aSender: tObject; Var aKey: Word; aShift: tShiftState);
Begin
          _nOp( [ aSender]);

          If ( [ ssCtrl]= aShift)
             And
             ( ord( 'F')= aKey)
             Then
             fd_Source.exeCute()
          Else
             If ( []= aShift)
                And
                ( $72= aKey)  // F3
                Then
                memoFind( mem_Source, fd_Source.FindText.toLower(), True);

End;

Procedure
          tfrm_lrsLearn_.tim_AEoCTimer( aSender: tObject);
Begin
          tim_AEoC.Enabled:= False;
          _nOp( [ aSender]);
          btn_opnAutSvFldr.Enabled:= String( lbet_AutoExpFld.Text).existsAsFileFolder();
End;


Function
          tfrm_lrsLearn_.lbxResToMemStr( Out aOutMemSt: tMemoryStream; Out aOutLRRes: tLResourceEx): boolEan;
Var
          vtMemStm                          : tMemoryStream;
Begin
          aOutMemSt:= Nil;
          aOutLRRes:= Nil;
          Result:= False;
          If Not checkGetLResource( aOutLRRes)
             Then
             Exit;

          vtMemStm:= Nil;
          Try
             vtMemStm:= makeMemStreamFromResStr( aOutLRRes.Value);
          Except
             On E: Exception
                Do
                Begin
                     mem_CompMsgs.append( 'lbxResToMemStr() => makeMemStreamFromResStr() => '+ E.Message);
                     Exit;
             End;
          End;
          vtMemStm.Position:= 0;

          Result:= ( 0< vtMemStm.Size);
          If Result
             Then
             aOutMemSt:= vtMemStm;

End;

Function
          tfrm_lrsLearn_.checkSave2File( aMemStm: tMemoryStream; aFilePath: String): boolEan;
Begin
          Result:= False;
          Try
             aMemStm.saveToFile( aFilePath);
             Result:= True;
          Except
             On E: Exception
                Do
                mem_CompMsgs.append( 'aMemStm.saveToFile() => '+ E.Message);
          End;
End;


Function
          tfrm_lrsLearn_.checkAutoSave( aMemStm: tMemoryStream; aLazRes: tLResourceEx): boolEan;
Var
          vStFNm                            : String;
          vStPth                            : String;
Begin
          Result:= False;
          If ( lbet_AutoExpFld.Text= '')
             Then
             Exit;

          vStFNm:= aLazRes.Name+ ' at '+ formatDateTime( 'yyyy-MM-dd_HH-mm-ss-zzz', now())+ '.'+ aLazRes.ValueType.toLower();
          vStPth:= concatPaths( [ lbet_AutoExpFld.Text, vStFNm]);

          Result:= checkSave2File( aMemStm, vStPth)
End;

Procedure
          tfrm_lrsLearn_.lbx_RessClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
          vtMemStm                          : tMemoryStream;
          vtCstBm                           : tRasterImage;
Begin
          _nOp( [ aSender]);
          img_prev.Picture.clear();

          If Not lbxResToMemStr( vtMemStm, vtLaRs)
             Then
             Exit;

          checkAutoSave( vtMemStm, vtLaRs);

          Try
             vtCstBm := Self.createRstrImgFromLazarusResource( vtLaRs.ValueType, vtMemStm, tRasterImage);
          Except
             On E: Exception
                Do
                Begin
                     mem_CompMsgs.append( 'lbx_RessClick() => createRstrImgFromLazarusResource() => '+ E.Message);
                     Exit;
             End;
          End;

          IF ( Nil<> vtCstBm)
             Then
             Try
                img_prev.Picture.Assign( vtCstBm);
                freeAndNil( vtCstBm);
             Except
                On E: Exception
                   Do
                   Begin
                        mem_CompMsgs.append( 'img_prev.Picture.Assign() => '+ E.Message);
                        Exit;
                End;
             End;

          freeAndNil( vtMemStm);
End;

Procedure
          tfrm_lrsLearn_.btn_ExitClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          close();
End;


Procedure
          tfrm_lrsLearn_.btn_clearLBXClick( aSender: tObject);
Var
          vtMdRs                            : tModalResult;
Begin
          _nOp( [ aSender]);

          If manageChanges( True, 'List'  , bln_ChangedObjLst, @btn_SaveLRSClick)= tsNone
             Then
             Exit;

          vtMdRs:= messageDlg( 'Should the list  be cleared?', mtConfirmation, [ mbYes, mbNo], 0, mbNo);
          If ( mrNo= vtMdRs)
             Then
             Exit;

          prepare();
          checkEnaLBXDepBtns();
          set_changedObjLst( False);
          img_prev.Picture.clear();
          mem_CompMsgs.append( 'List has been cleared');
End;



Procedure
          tfrm_lrsLearn_.writeEmptyProfileFile();
Begin
          '{}'.saveToFile( getProfileFile());
End;

Procedure
          tfrm_lrsLearn_.deleteProfileFile();
Var
          vStPFl                            : String;
Begin
          vStPFl:= getProfileFile();
          deleteFile( vStPFl);
End;


Procedure
          tfrm_lrsLearn_.btn_ResetProfileClick( aSender: tObject);
Var
          vStPth                            : String;
          vtPrcs                            : tProcess;
Begin
          _nOp( [ aSender]);

          bln_ReSetting:= True;

          deleteProfileFile();

          jpsStorage.JSONFileName:= '';

          vStPth:= ParamStr( 0);

          vtPrcs:= tProcess.create( Nil);
          vtPrcs.Executable:= vStPth;
          vtPrcs.exeCute();
          freeAndNil( vtPrcs);
          close();
End;

Procedure
          tfrm_lrsLearn_.lbet_AutoExpFldChange( aSender: tObject);
Begin
          _nOp( [ aSender]);
          tim_AEoC.Enabled:= False;
          tim_AEoC.Enabled:= True;
End;

Procedure
          tfrm_lrsLearn_.saveLBX2LrsFile( aFileName: String);
Begin
          prepareReLiList( True);
          If reli_List.writeToLRSFile( aFileName)
             Then
             set_changedObjLst( False)
          Else
             mem_CompMsgs.append( 'tfrm_lrsLearn_.saveLBX2LrsFile() => Errors while trying to save...');
End;

Procedure
          tfrm_lrsLearn_.saveLBX2JsnFile( aFileName: String);
Begin
          prepareReLiList( True);
          If reli_List.writeToJSONFile( aFileName)
             Then
             set_changedObjLst( False)
          Else
             mem_CompMsgs.append( 'tfrm_lrsLearn_.saveLBX2JsnFile() => Errors while trying to save...');

End;

Procedure
          tfrm_lrsLearn_.btn_SaveLBXClick( aSender: tObject);
Var
          vStFNme                           : String;
          vStExt                            : String;
Begin
          _nOp( [ aSender]);

          If Not( sd_saveLBX.exeCute())
             Then
             Exit;

          vStFNme:= sd_saveLBX.FileName;
          vStExt := extractFileExt( vStFNme);

          If ( '.lrs'= vStExt.toLower())
             Then
             saveLBX2LrsFile( vStFNme)
          Else
             If ( '.json'= vStExt.toLower())
                Then
                saveLBX2JsnFile( vStFNme)
             Else
                mem_CompMsgs.append( 'btn_SaveLBXClick() => don''t know, how to handle file extension "'+ vStExt+ '"!');

End;


Procedure
          tfrm_lrsLearn_.btn_LoadLBXClick( aSender: tObject);
Var
          vStFNme                           : String;
          vBoKeepList                       : boolEan;
Begin
          _nOp( [ aSender]);

          // press a shift key to preserve the current list
          vBoKeepList:= ( getKeyState( VK_Shift)< 0) Or ( getKeyState( VK_RShift)< 0);

          If ( Not vBoKeepList)
             Then
             If manageChanges( True, 'List', bln_ChangedObjLst, @btn_SaveLRSClick)= tsNone
                Then
                Exit;

          //  or replace resource list from file...
          od_loadLBX.Title:= 'Add'.iif( vBoKeepList, 'Replace')+ ' resource list from file...';
          If Not( od_loadLBX.exeCute())
             Then
             Exit;

          If vBoKeepList
             Then
             prepareReLiList( True)
          Else
             prepare();

          vStFNme:= od_loadLBX.FileName;

          If reli_List.readFromFile( vStFNme, Not vBoKeepList)
             Then
             Begin
                  refreshListFromReLi();
                  If ( Not vBoKeepList)
                     Then
                     set_changedObjLst( False);
          End;

End;


Procedure
          tfrm_lrsLearn_.btn_LoadLRSClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          If manageChanges( True, 'Script', bln_ChangedScript, @btn_SaveLRSClick)= tsNone
             Then
             Exit;

          If ( od_loadLRS.exeCute())
             Then
             Begin
                  mem_CompMsgs.append( 'Loading from "'+ od_loadLRS.FileName+ '"...');
                  mem_Source.Lines.beginUpdate();
                  Try
                     mem_Source.Lines.loadFromFile( od_loadLRS.FileName);
                  Finally
                     mem_Source.Lines.endUpdate();
                  End;
                  set_changedScript( False);
                  mem_CompMsgs.append( 'Loaded '+ format( '%.0n', [ doUble( mem_Source.Lines.Count)])+ ' lines from "'+ od_loadLRS.FileName+ '"');
          End;

End;

Procedure
          tfrm_lrsLearn_.btn_SaveLRSClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          //
          If ( sd_saveLRS.exeCute())
             Then
             Begin
                  mem_Source.Lines.saveToFile( sd_saveLRS.FileName);
                  set_changedScript( False);
          End;
End;


Procedure
          tfrm_lrsLearn_.btn_SelWriteBackClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
          vStLRSStr                         : String;
Begin
          _nOp( [ aSender]);

          If Not checkGetLResource( vtLaRs)
             Then
             Exit;

          vStLRSStr:= vtLaRs.toScriptPiece( True, False);
          mem_Source.Lines.insert( 0, vStLRSStr);
End;


Procedure
          tfrm_lrsLearn_.btn_AllWriteBackClick( aSender: tObject);
Var
          vtStrObj                          : tStrObj;
Begin
          _nOp( [ aSender]);

          If manageChanges( True, 'Script', bln_ChangedScript, @btn_SaveLRSClick)= tsNone
             Then
             Exit;

          prepareReLiList( True);

          Try
              vtStrObj:= tStrObj.create( '');
              reli_list.forEach2LRS( @reli_list.collectLRSSink, @vtStrObj.collect);
              mem_Source.Text:= vtStrObj.Value;
              freeAndNil( vtStrObj);
          Except
             On E: Exception
                Do
                mem_CompMsgs.append( 'btn_AllWriteBackClick() => '+ E.Message);
          End;
End;


Procedure
          tfrm_lrsLearn_.btn_EmptMsgsClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          mem_CompMsgs.Clear;
End;


Procedure
          tfrm_lrsLearn_.jpsStorageSaveProperties( aSender: tObject);
Begin
          If bln_AlreadySavedToPropStore  // sometimes it is called twice (no idea why)
             Then
             Exit;

          _nOp( [ aSender]);

          prepareReLiList( True);
          jpsStorage.doEraseSections( 'LBX');

          mem_CompMsgs.append( 'Saving list to property store...');
          reli_List.writeToPropStore( jpsStorage);
          bln_AlreadySavedToPropStore:= True;
End;

Procedure
          tfrm_lrsLearn_.add2ListBoxSink( aLaRe: tLResourceEx);
Begin
          If ( Nil= aLaRe)
             Then
             Exit;

          addLbxItm( aLaRe.ValueType+ ' : '+ aLaRe.Name, aLaRe);
End;


Procedure
          tfrm_lrsLearn_.jpsStorageRestoreProperties( aSender: tObject);
Begin
          _nOp( [ aSender]);

          prepareReLiList( True);
          mem_CompMsgs.append( 'Loading list from property store....');
          reli_List.readFromPropStore( jpsStorage);
          reli_List.reportScriptResults( @add2ListBoxSink);
          condFocusResults();

End;


Function
          tfrm_lrsLearn_.indexOf( aStr: String; aTkn: String): intEger;
Var
          vIn1                              : intEger;
          vIn2                              : intEger;
          vInTknLn                          : intEger;
          vStCur                            : String;
Begin
          Result  := -1;
          vInTknLn:= length( aTkn);
          vIn2:= aStr.Length;
          vIn1:= 0;
          While ( vIn1< vIn2)
                Do
                Begin
                     vStCur:= copy( aStr, vIn1, vInTknLn);
                     If ( vStCur= aTkn)
                        Then
                        Begin
                             Result:= vIn1;
                             exit;
                     End;
                     inc( vIn1, 1);
          End;
End;

Procedure
          tfrm_lrsLearn_.memoFind( aCtrl: tMemo; aTkn: String; aNext: boolEan= False);
Var
          vStTxt                            : String;
          vStTkn                            : String;
          vInTknLn                          : intEger;
          vInFndPos                         : intEger;
          vInSelSt                          : intEger;
Begin
          vStTkn:= aTkn;
          vStTxt:= aCtrl.Text;
          vStTxt:= vStTxt.toLower();
          If ( ''= vStTkn)
             Or
             ( ''= vStTxt)
             Then
             Begin
                  fd_Source.closeDialog();
                  Exit;
          End;

          vInTknLn  := length( vStTkn);
          vInSelSt  := mem_Source.SelStart;
          If ( aNext)
             Then
             vInSelSt+= 1;
          vStTxt    := vStTxt.subString( vInSelSt);

          vInFndPos := vStTxt.indexOf( vStTkn);

          If ( 0> vInFndPos)
             Then
             Begin
                  showMessage( 'Not found');
                  fd_Source.closeDialog();
                  Self.setFocus();
                  Self.bringToFront();
                  Exit;
          End;

          fd_Source.closeDialog();
          mem_Source.SelStart := vInSelSt+ vInFndPos;
          mem_Source.SelLength:= vInTknLn;

End;

Procedure
          tfrm_lrsLearn_.fd_SourceFind( aSender: tObject);
Begin
          _nOp( [ aSender]);
          memoFind( mem_Source, fd_Source.FindText.toLower());
End;

Procedure
          tfrm_lrsLearn_.btn_opnAutSvFldrClick( aSender: tObject);
Var
          vtPrcs                            : tProcess;
          vStPth                            : String;
Begin
          _nOp( [ aSender]);

          vStPth:= lbet_AutoExpFld.Text;
          If Not ( vStPth.existsAsFileFolder())
             Then
             Begin
                  btn_opnAutSvFldr.Enabled:= False;
                  Exit;
          End;

          vtPrcs:= tProcess.create( Nil);
          {$IFDEF WINDOWS}
          vtPrcs.Executable:= 'explorer.exe';
          {$ELSE}
          vtPrcs.Executable:= 'xdg-open';
          {$ENDIF}
          vtPrcs.Parameters.add( vStPth);
          vtPrcs.exeCute();
          freeAndNil( vtPrcs);

End;


Procedure
          tfrm_lrsLearn_.btn_SelAutoExpFldrClick( aSender: tObject);
Begin
          _nOp( [ aSender]);

          sfd_SelFldr.FileName:= lbet_AutoExpFld.Text;

          If ( Not sfd_SelFldr.exeCute())
             Then
             Exit;

          lbet_AutoExpFld.Text:= sfd_SelFldr.FileName;
End;


Procedure
          tfrm_lrsLearn_.btn_ExportClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
          vtMemStm                          : tMemoryStream;
Begin
          _nOp( [ aSender]);
          If Not lbxResToMemStr( vtMemStm, vtLaRs)
             Then
             Exit;

          If ( Not sd_ResFromLBX.execute())
             Then
             Exit;

          checkSave2File( vtMemStm, sd_ResFromLBX.FileName);

          freeAndNil( vtMemStm);
End;

Procedure
          tfrm_lrsLearn_.btn_ReplaceClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
          vStResWLB                         : String;
          vtRPrps                           : tProperties;
          vtMdRs                            : tModalResult;
Begin
          _nOp( [ aSender]);

          If Not checkGetLResource( vtLaRs)
             Then
             Exit;

          vtRPrps.TypeProp:= vtLaRs.ValueType;
          vtRPrps.NameProp:= vtLaRs.Name;

          vtMdRs:= tfrm_ResProps_.exeCute( Self, vtRPrps);
          If ( mrOk<> vtMdRs)
             Then
             Exit;

          If ( ''< vtRPrps.TypeProp)
             Then
             Begin
                  od_SingleLBXRes.DefaultExt:= '.'+ vtRPrps.TypeProp.toLower();
                  od_SingleLBXRes.FileName:= '*.'+ vtRPrps.TypeProp.toLower();
          End;

          od_SingleLBXRes.Title:= cstr_OFD_SNG_TTL.rePlace( '%verb%', 'Replace');
          If ( Not od_SingleLBXRes.exeCute())
             Then
             Exit;

          od_SingleLBXRes.DefaultExt:= '';
          If Not ( fileContentToHsh990( od_SingleLBXRes.FileName, vStResWLB))
             then
             Exit;

          vtLaRs.Value:= vStResWLB;
          lbx_RessClick( Nil);

End;

Procedure
          tfrm_lrsLearn_.autoSaveHsh990File( aFileName: String; aContents: String);
Var
          vStFNm                            : String;
          vStFXt                            : String;
          vStPth                            : String;
Begin

          If ( ''= lbet_AutoExpFld.Text)
             Or
             ( ''= aFileName)
             Then
             Exit;

          vStFNm:= extractFileName( aFileName);

          vStFXt:= extractFileExt( vStFNm);
          If ( vStFXt.startsWith( '.'))
             Then
             vStFXt:= vStFXt.subString( 1);

          vStFNm:= changeFileExt( vStFNm, '');
          vStFNm:= vStFNm+ '_'+ vStFXt+ ' at '+ formatDateTime( 'yyyy-MM-dd_HH-mm-ss-zzz', now())+ '.#990';
          vStPth:= concatPaths( [ lbet_AutoExpFld.Text, vStFNm]);

          aContents.saveToFile( vStPth);
End;

Procedure
          tfrm_lrsLearn_.autoSaveBinFileFromHsh990( aFileName: String; aContents: String);
Var
          vStFNm                            : String;
          vStFXt                            : String;
          vStPth                            : String;
Begin

          If ( ''= lbet_AutoExpFld.Text)
             Or
             ( ''= aFileName)
             Then
             Exit;

          vStFNm:= extractFileName( aFileName);

          vStFXt:= extractFileExt( vStFNm);
          vStFNm:= changeFileExt( vStFNm, '');

          vStFNm:= vStFNm+ ' at '+ formatDateTime( 'yyyy-MM-dd_HH-mm-ss-zzz', now())+ vStFXt;
          vStPth:= concatPaths( [ lbet_AutoExpFld.Text, vStFNm]);

          hsh990StrSaveToBinFile( vStPth, aContents, @mem_CompMsgs.append);
End;


Procedure
          tfrm_lrsLearn_.btn_ImportClick( aSender: tObject);
Var
          vtMdRs                            : tModalResult;
          vStTpe                            : String;
          vStFPth                           : String;
          vtRPrps                           : tProperties;
          vStResWLB                         : String;
          vtLaRs                            : tLResourceEx;

Begin
          _nOp( [ aSender]);

          od_SingleLBXRes.Title:= cstr_OFD_SNG_TTL.rePlace( '%verb%', 'Import');
          If ( Not od_SingleLBXRes.exeCute())
             Then
             Exit;

          vStFPth  := od_SingleLBXRes.FileName;
          vStTpe   := extractFileExt( vStFPth);
          If ( ''= vStTpe)
             Then
             vStTpe:= 'TYP';
          If ( '.'= vStTpe.subString( 0, 1))
             Then
             vStTpe:= vStTpe.subString( 1);
          vStTpe   := vStTpe.toUpper();

          vtRPrps.TypeProp:= vStTpe;
          vtRPrps.NameProp:= changeFileExt( extractFileName( vStFPth), '');

          vtMdRs:= tfrm_ResProps_.exeCute( Self, vtRPrps);
          If ( mrOk<> vtMdRs)
             Then
             Exit;

          If Not ( fileContentToHsh990( vStFPth, vStResWLB))
             then
             Exit;

          // test <
          autoSaveHsh990File( vStFPth, vStResWLB);
          autoSaveBinFileFromHsh990( vStFPth, vStResWLB);
          // > test


          vtLaRs:= tLResourceEx.create( vtRPrps.NameProp, vtRPrps.TypeProp, vStResWLB);

          prepareReLiList( True);
          reli_List.append1( vtLaRs);

          addLbxItm( vtLaRs.ValueType+ ' : '+ vtLaRs.Name, vtLaRs);
          mem_CompMsgs.append( '1 resource imported');

          condFocusResults( True);
End;

Procedure
          tfrm_lrsLearn_.btn_NewClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
Begin
          _nOp( [ aSender]);

          If Not checkGetOrCreateLResource( vtLaRs)
             Then
             Exit;

          prepareReLiList( True);
          reli_List.append2( vtLaRs.Name, vtLaRs.ValueType, vtLaRs.Value);

          addLbxItm( vtLaRs.ValueType+ ' : '+ vtLaRs.Name, vtLaRs);
          mem_CompMsgs.append( ' 1 resource created');

          condFocusResults( True);

End;

Procedure
          tfrm_lrsLearn_.refreshListFromReLi( aOptIdx: intEger= -1);
Begin
          lbx_Ress.clear();
          reli_List.reportScriptResults( @add2ListBoxSink);
          condFocusResults( False, aOptIdx);
End;

Procedure
          tfrm_lrsLearn_.btn_EditResClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
          vtRPrps                           : tProperties;
          vtMdRs                            : tModalResult;
          vInIdx                            : intEger;
Begin
          _nOp( [ aSender]);

          If Not checkGetLResource( vtLaRs, vInIdx)
             Then
             Exit;

          vtRPrps.TypeProp:= vtLaRs.ValueType;
          vtRPrps.NameProp:= vtLaRs.Name;

          vtMdRs:= tfrm_ResProps_.exeCute( Self, vtRPrps);
          If ( mrOk<> vtMdRs)
             Then
             Exit;

          If ( ''< vtRPrps.TypeProp)
             And
             ( ''< vtRPrps.NameProp)
             Then
             Begin
                  vtLaRs.ValueType:= vtRPrps.TypeProp;
                  vtLaRs.Name     := vtRPrps.NameProp;
          End;

          refreshListFromReLi( vInIdx);
End;

Procedure
          tfrm_lrsLearn_.btn_RemoveResClick( aSender: tObject);
Var
          vtLaRs                            : tLResourceEx;
          vInIdx                            : intEger;
          vStCnfm                           : String;
          vStNme                            : String;
Begin
          _nOp( [ aSender]);

          If Not checkGetLResource( vtLaRs, vInIdx)
             Then
             Exit;

          vStNme := vtLaRs.Name.substring( 0, 32)+ '...';
          vStCnfm:= 'Remove "'       +
                    vtLaRs.ValueType +
                    ' : '            +
                    vStNme           +
                    '" @'            +
                    vInIdx.toString()+
                    ' from  list?';

          If ( mrOk <> messageDlg( 'Remove...?', vStCnfm, mtConfirmation, [ mbOk, mbCancel], 0, mbCancel))
             Then
             Exit;

          reli_List.delete( vInIdx);
          refreshListFromReLi( vInIdx- 1);

End;


End.

