Unit
          lResourceEx;

          {$mode ObjFPC}{$H+}

Interface

Uses
          Classes
          ,
          SysUtils
          {$IFDEF LCL}
          ,
          lResources
          {$ENDIF}
          ,
          stringEvents
          ;

Type
          {$M+}

          {$IFNDEF LCL}
          tLResource                        = Class
          Public
             Name                           : AnsiString;
             ValueType                      : AnsiString;
             Value                          : AnsiString;
          End;
          {$ENDIF}


          tResCompareResult                 = ( rcrCantCompareToNIL, rcrNamesDiffer, rcrTypesDiffer, rcrValuesDiffer, rcrValueLengthsDiffer, rcrEqual);

          tLResourceEx                      = Class( tLResource)

          Protected

             Function                       _vallen_get(): intEger;

          Public

             Constructor                    create( Const aName: String; Const aType: String; Const aValue: String);
             Constructor                    create( aLegacyRes: tLResource);
             Constructor                    create();

             Function                       packPieces( aOverrideVal: String= ''): String;
             Function                       toScriptPiece( aUseLRSStx: boolEan; aOnlyVal: boolEan): String;

             Class Function                 parseLRS( aLines: tStrings; Var aVarIdx: intEger; Out aOutLazRes: tLResourceEx): boolEan;

             Procedure                      assign( aSource: tLResource); Virtual;

                                            // Both values must be in same format (should be #990)
             Function                       compare( aCmp2: tLResourceEx; aDoCompValuesByteWise: boolEan= False; aOptSink: tStrNotifyProc= Nil): tResCompareResult;


          Published

             Property                       ResName   : String  Read Name         Write Name;
             Property                       ResType   : String  Read ValueType    Write ValueType;
             Property                       ResValue  : String  Read Value        Write Value;
             Property                       ResValLen : intEger Read _vallen_get;

          End;

          tLaResNotifyProc                  = Procedure( aLaRes: tLResourceEx) Of Object;

          ELResExConcoding                  = Class( exCeption)
          End;
          {$M-}

Const
          cstr_LAREADD_BEG                  = 'lazarusresources.add';
          cstr_LAREADD_PNT                  = '%valnme%';
          cstr_LAREADD_PTT                  = '%valtpe%';
          cstr_LAREADD_PRM                  = '('#39+ cstr_LAREADD_PNT+ #39','#39+ cstr_LAREADD_PTT+ #39',[';
          cstr_LAREADD_END                  = ']);';


Implementation

Uses
          printableBin
          ,
          Math
          ,
          stringHelper
          ,
          nOp
          ;

          { tLResourceEx }

Function
          tLResourceEx.packPieces( aOverrideVal: String= ''): String;
Var
          vStLRSHdr                         : String;
          vStLRSCnt                         : String;
          vStLRSFtr                         : String;
Begin
          vStLRSHdr:= cstr_LAREADD_BEG+ cstr_LAREADD_PRM;
          vStLRSHdr:= vStLRSHdr.rePlace( cstr_LAREADD_PNT, Self.Name);
          vStLRSHdr:= vStLRSHdr.rePlace( cstr_LAREADD_PTT, Self.ValueType);
          vStLRSCnt:= Self.Value;

          If ( ''< aOverrideVal)
             Then
             vStLRSCnt:= aOverrideVal;

          vStLRSFtr:= cstr_LAREADD_END;

          Result   := vStLRSHdr+ LineEnding+
                      vStLRSCnt+ LineEnding+
                      vStLRSFtr+ LineEnding;
End;


Function
          tLResourceEx.toScriptPiece( aUseLRSStx: boolEan; aOnlyVal: boolEan): String;
Begin
          Result   := Self.Value;

          If aUseLRSStx
             Then
             Result:= hsh990StrToLrsStr( Result);

          If aOnlyVal
             Then
             _nOp( []) //Result:= Result :)
          Else
             Result:= packPieces( Result);

End;

Function
          tLResourceEx._vallen_get(): intEger;
Begin
          Result:= length( Value);
End;


Constructor
          tLResourceEx.create( Const aName: String; Const aType: String; Const aValue: String);
Begin
          inHerited create();

          ResName := aName;
          ResType := aType;
          ResValue:= aValue;
End;

Constructor
          tLResourceEx.create( aLegacyRes: tLResource);
Begin
          create( aLegacyRes.Name, aLegacyRes.ValueType, aLegacyRes.Value);
End;

Constructor // for later prop setting
          tLResourceEx.create();
Begin
          create( '', '', '');
End;


Class Function // "good" candidate for rev/ref ;-)
          tLResourceEx.parseLRS( aLines: tStrings; Var aVarIdx: intEger; Out aOutLazRes: tLResourceEx): boolEan;
Var
          vStLne                            : String;
          vIn1                              : intEger;
          vIn2                              : intEger;
          vInNxtIdx                         : intEger;
          vInNmeI1                          : intEger;
          vInNmeI2                          : intEger;
          vStNme                            : String;
          vInTpeI1                          : intEger;
          vInTpeI2                          : intEger;
          vStTpe                            : String;
          vStDLnPrep                        : String;
          vStDta                            : String;
          vBoEndLne                         : boolEan;
Begin

          vStNme    := '';
          vStTpe    := '';
          vStDta    := '';

          aOutLazRes:= Nil;
          Result    := False;

          vIn2      := aLines.Count;

          For vIn1:= aVarIdx To vIn2- 1
              Do
              Begin
                   aVarIdx:= vIn1;

                   vStLne:= aLines[ vIn1].toLower();
                   If ( ''= vStLne.trim())
                      Then
                      Begin
                           Inc( aVarIdx, 1);
                           conTinue;
                   End;

                   vInNxtIdx:= vStLne.indexOf( cstr_LAREADD_BEG, 0);
                   If ( -1< vInNxtIdx)  // start line
                      Then
                      Begin
                           vStDta:= '';
                           vInNmeI1:= vInNxtIdx+ cstr_LAREADD_BEG.Length;
                           vStNme:= vStLne.subString( vInNmeI1);
                           vInNxtIdx:= vStNme.indexOf( '(', 0);
                           If ( -1< vInNxtIdx)
                              Then
                              Begin
                                   vInNmeI1+= ( vInNxtIdx+ 1);
                                   vStNme:= vStNme.subString( vInNxtIdx+ 1);
                                   vInNxtIdx:= vStNme.indexOf( '''', 0);
                                   If ( -1< vInNxtIdx)
                                      Then
                                      Begin
                                           vInNmeI1+= ( vInNxtIdx+ 1);
                                           vStNme:= vStNme.subString( vInNxtIdx+ 1);
                                           vInNxtIdx:= vStNme.indexOf( '''', 0);
                                           If ( -1< vInNxtIdx)
                                              Then
                                              Begin
                                                   vInNmeI2:= vInNmeI1+ vInNxtIdx;
                                                   vStNme:= aLines[ vIn1].subString( vInNmeI1, vInNmeI2- vInNmeI1);
                                                   vStTpe:= aLines[ vIn1].subString( vInNmeI2);
                                                   If ( ''< vStNme) And ( ''< vStTpe)
                                                      Then
                                                      Begin
                                                           vInNxtIdx:= vStTpe.indexOf( ',', 0);
                                                           If ( -1< vInNxtIdx)
                                                              Then
                                                              Begin
                                                                   vInTpeI1:= vInNxtIdx+ 1;
                                                                   vStTpe:= vStTpe.subString( vInNxtIdx+ 1);
                                                                   vInNxtIdx:= vStTpe.indexOf( '''', 0);
                                                                   If ( -1< vInNxtIdx)
                                                                      Then
                                                                      Begin
                                                                           vStTpe:= vStTpe.subString( vInNxtIdx+ 1);
                                                                           vInNxtIdx:= vStTpe.indexOf( '''', vInTpeI1);
                                                                           If ( -1< vInNxtIdx)
                                                                              Then
                                                                              Begin
                                                                                   vInTpeI2:= ( vInNxtIdx);
                                                                                   vStTpe:= vStTpe.subString( 0, vInTpeI2);
                                                                           End;
                                                                   End;
                                                           End;
                                                   End;
                                           End;
                                   End;
                           End;

                      End
                   Else
                      Begin
                           // because this is no compiler we have to decide it by line
                           // comment lines should go above start line and below end line ;-)
                           vBoEndLne:= ( vStLne.trim()= cstr_LAREADD_END);
                           If ( Not vBoEndLne)  // data line
                              And
                              ( ''<> vStNme)
                              And
                              ( ''<> vStTpe)
                              Then
                              Begin
                                   vStDLnPrep:= lrsStrToHsh990Str( aLines[ vIn1]);
                                   vStDta+= vStDLnPrep;
                              End
                           Else
                              Begin  // end line for one resource
                                   If ( ''<> vStNme) And ( ''<> vStTpe) And ( ''<> vStDta)
                                      Then
                                      Begin
                                           aOutLazRes          := tLResourceEx.create();
                                           aOutLazRes.Name     := vStNme;
                                           aOutLazRes.ValueType:= vStTpe;
                                           aOutLazRes.Value    := vStDta;
                                           Result:= True;
                                           inc( aVarIdx, 1);
                                           Exit;
                                   End;

                           End;
                   End;
          End;
End;

Procedure
          tLResourceEx.assign( aSource: tLResource);
Begin
          If ( Nil= aSource)
             Then
             Exit;

          ResName := aSource.Name;
          ResType := aSource.ValueType;
          ResValue:= aSource.Value;
End;

Function
          tLResourceEx.compare( aCmp2: tLResourceEx; aDoCompValuesByteWise: boolEan= False; aOptSink: tStrNotifyProc= Nil): tResCompareResult;
Var
          vIn1                              : intEger;
          vIn2                              : intEger;
          vStSlfVal                         : String;
          vStCm2Val                         : String;
          vInSlfValLen                      : intEger;
          vInCm2ValLen                      : intEger;
Begin
          Result:= rcrCantCompareToNIL;
          If ( Nil= aCmp2)
             Then
             Begin
                  ( 'Nil== aCmp2').sendToSink( aOptSink);
                  Exit;
          End;

          Result:= rcrNamesDiffer;
          If ( Self.ResName<> aCmp2.ResName)
             Then
             Begin
                  ( '"'+ Self.ResName+ '" != "'+ aCmp2.ResName+ '"').sendToSink( aOptSink);
                  Exit;
          End;

          Result:= rcrTypesDiffer;
          If ( Self.ResType<> aCmp2.ResType)
             Then
             Begin
                  ( '"'+ Self.ResType+ '" != "'+ aCmp2.ResType+ '"').sendToSink( aOptSink);
                  Exit;
          End;

          Result:= rcrValuesDiffer;
          If ( Not aDoCompValuesByteWise)
             Then
             Begin
                  If ( Self.ResValue<> aCmp2.ResValue)
                     Then
                     Begin
                          ( '"'+ Self.ResName+ '" != "'+ aCmp2.ResName+ '"').sendToSink( aOptSink);
                          Exit;
                     End
                  Else
                     Result:= rcrEqual;
             End
          Else
             Begin
                  vStSlfVal   := Self .ResValue;
                  vInSlfValLen:= vStSlfVal.Length;

                  vStCm2Val   := aCmp2.ResValue;
                  vInCm2ValLen:= vStCm2Val.Length;

                  vIn2:= Math.Min(
                                  vInSlfValLen,
                                  vInCm2ValLen
                         );
                  For vIn1:= 0 To vIn2- 1
                      Do
                      Begin
                           If ( Self.ResValue[ vIn1]<> aCmp2.ResValue[ vIn1])
                              Then
                              Begin
                                   ( 'Values are different at '+ vIn1.toString()+ '!').sendToSink( aOptSink);
                                   Exit;
                           End;
                  End;
                  If ( vInSlfValLen<> vInCm2ValLen)
                     Then
                     Begin
                          ( 'Value lengths are different ( '+ vInSlfValLen.toString()+ ' != '+ vInCm2ValLen.toString()+ ')').sendToSink( aOptSink);
                          Result:= rcrValueLengthsDiffer
                     End
                  Else
                     Begin
                          ( 'Values are equal.').sendToSink( aOptSink);
                          Result:= rcrEqual;
                  End;

          End;
End;

End.
