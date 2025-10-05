Unit
          printableBin;

          {$mode ObjFPC}{$H+}

Interface

Uses
          Classes
          ,
          SysUtils
          ,
          stringEvents
          ;

Type
          EPtblBinFormat                    = Class( Exception) End;



Function  // converts contents of a stream to #990 format - stream must be at necessary starting pos
          binStmToHsh990Str( aStm: tStream): String;

Function  // converts contents of a file to #990 format and returns it in aOutHRStr - aStdErr allows notifying
          fileContentToHsh990( aFilePath: String; Out aOutHRStr: String; aStdErr: tStrNotifyProc= Nil): boolEan;

Function  // converts a string in #990 format to LRS-Syntax (only value)
          hsh990StrToLrsStr( aResStr: String): String;

Function  // converts one line in LRS-Syntax to #990 format (only value)
          lrsStrToHsh990Str( aLRSLine: String): String;

Function  // writes a string in #990 format to a stream - stream must be created and writable and at necessary starting pos - aStdErr allows notifying
          hsh990StrToBinStm( aStm: tStream; aResStr: String; aStdErr: tStrNotifyProc= Nil): boolEan;

Function  // writes a string in #990 format to a file - aStdErr allows notifying
          hsh990StrSaveToBinFile( aFilePath: String; aHRStr: String; aStdErr: tStrNotifyProc= Nil): boolEan;

Function  // original author: Mattias Gaertner original project lrstolfm - converts LRA to binary in "one" step
          makeMemStreamFromResStr( aResStr: String): tMemoryStream;

Var
          int_MaxLneLen                     : intEger        = 80;
          int_MaxLnsInArrMbr                : intEger        = 64;


Implementation

Uses
          stringHelper
          ,
          numberHelper
          //,
          //nOp
          ;

Procedure // on cr or if a np byte comes next
          extLineWthChrsStr( Var aVarCharStr: String; Var aVarLneStr: String);
Begin
          If ( ''= aVarCharStr)
             Then
             Exit;

          aVarLneStr+= aVarCharStr;
          aVarCharStr:= '';
End;

Procedure
          endResLneAndStartNew1( Var aVarLneStr: String; Var aVarLneIdx: intEger; Var aVarResult: String);
Begin
          If ( ''< aVarResult)
             Then
             aVarResult+= LineEnding;

          If ( int_MaxLnsInArrMbr> aVarLneIdx)
             Then
             Begin
                  If ( ''< aVarResult)
                     Then
                     aVarResult+= '  +'      // nth line in fst array element
                  Else
                     aVarResult+= '  ';      // fst line in fst array element

                  Inc( aVarLneIdx, 1);
             End
          Else
             Begin
                    aVarResult+= '  ,';      // fst line in nxt array element
                  aVarLneIdx:= 0;
          End;

          aVarResult+= aVarLneStr;
          aVarLneStr:= '';

End;


Procedure
          checkExtLineWthChrsStr( Var aVarCharStr: String; Var aVarLneStr: String; Var aVarLneIdx: intEger; Var aVarResult: String; aDoForceLE: boolEan; aDoForceAppend: boolEan= False);
Var
          vInLineLen                        : intEger;
          vStSCpd                           : String;
Begin
          If ( ''= aVarCharStr) And ( Not aDoForceLE)
             Then
             Exit;

          vStSCpd:= #39+ aVarCharStr.rePlace( #39, #39#39)+ #39;

          If aDoForceAppend
             Then
             extLineWthChrsStr( vStSCpd, aVarLneStr);

          vInLineLen:= length( aVarLneStr)+ length( vStSCpd);

          If ( int_MaxLneLen<= vInLineLen)
             Or aDoForceLE
             Then
             Begin
                  If Not aDoForceAppend
                     Then
                     extLineWthChrsStr( vStSCpd, aVarLneStr);

                  endResLneAndStartNew1( aVarLneStr, aVarLneIdx, aVarResult);
          End;

          If ( ''= vStSCpd)
             Then
             aVarCharStr:= '';
End;

Procedure
          checkExtLineWthByteStr( aByteStr: String; Var aVarLneStr: String; Var aVarLneIdx: intEger; Var aVarResult: String; aDoForceLE: boolEan= False);
Var
          vInLenTst               : intEger;
          vStAdd                  : String;
Begin
          vStAdd:= aByteStr;

          If ( ''= vStAdd) And ( Not aDoForceLE)
             Then
             Exit;

          vInLenTst:= length( aVarLneStr)+ length( vStAdd);

          If ( int_MaxLneLen> vInLenTst) And ( Not aDoForceLE)
             Then
             aVarLneStr+= vStAdd
          Else
             Begin
                  If ( ''< aVarResult)
                     Then
                     aVarResult+= LineEnding;

                  If ( int_MaxLnsInArrMbr> aVarLneIdx)
                     Then
                     Begin
                          If ( ''< aVarResult)
                             Then
                             aVarResult+= '  +'
                          Else
                             aVarResult+= '  ';

                          aVarResult+= aVarLneStr;
                          Inc( aVarLneIdx, 1);
                     End
                  Else
                     Begin
                          aVarResult+= ( '  ,'+ aVarLneStr);
                          aVarLneIdx:= 0;
                  End;
                  aVarLneStr:= vStAdd;
          End;
End;


Function  // converts a string in #990 format to LRS-Syntax (without lazarusresources.add etc.)
          hsh990StrToLrsStr( aResStr: String): String;
Var
          vBy1                              : Byte;
          vStLnPCe                          : String;
          vStChrStr                         : String;
          vStNxtBte                         : String;

          aosByte                           : tStringArray;
          vIn1                              : intEger;
          vIn2                              : intEger;

          vInLneIdx                         : intEger; //

Begin
          Result:= '';
          If ( ''= aResStr)
             Then
             Exit;

          aosByte:= aResStr.Split( '#');
          vIn2:= length( aosByte);

          vStChrStr:= '';
          Result:= '';
          vStLnPCe:= '';
          vInLneIdx:= 0;

          For vIn1:= 0 To vIn2- 1
              Do
              Begin
                   vStNxtBte:= aosByte[ vIn1];
                   If ( ''= vStNxtBte)
                      Then
                      conTinue;

                   If Not vStNxtBte.tryToByte( vBy1)
                      Then
                      Begin
                           raise EPtblBinFormat.create( 'Illegal byte encoding found "'+ vStNxtBte+ '"');
                           Exit;
                   End;

                   If (  31< vBy1)
                      And
                      ( 128> vBy1)
                      Then
                      Begin
                           vStChrStr+= Char( vBy1);

                           checkExtLineWthChrsStr( vStChrStr, vStLnPCe, vInLneIdx, Result, False);
                      End
                   Else
                      Begin
                           If ( ''< vStChrStr)
                              Then
                              Begin
                                   checkExtLineWthChrsStr( vStChrStr, vStLnPCe, vInLneIdx, Result, False, True);
                           End;
                           checkExtLineWthByteStr( '#'+ vStNxtBte, vStLnPCe, vInLneIdx, Result);
                   End;
          End;

          checkExtLineWthChrsStr( vStChrStr, vStLnPCe, vInLneIdx, Result, True);
          Result+= vStLnPCe;

End;

Function  // converts contents of a stream to #990 format - stream must be at necessary starting pos
          binStmToHsh990Str( aStm: tStream): String;
Var
          vBy1                              : Byte;
Begin
          Result:= '';
          If ( Nil= aStm)
             Or
             ( 1> aStm.Size)
             Then
             Exit;

          vBy1:= 0;
          While ( aStm.Position< aStm.Size)
                Do
                Begin
                     //aStm.Read( vBy1, 1);
                     vBy1:= aStm.readByte();
                     Result+= '#'+ vBy1.toString();
          End;
End;


Function  // converts contents of a file to #990 format and returns it in aOutHRStr, aStdErr allows notifying
          fileContentToHsh990( aFilePath: String; Out aOutHRStr: String; aStdErr: tStrNotifyProc= Nil): boolEan;
Var
          vtMemStmBin                       : tMemoryStream;
          vStRes                            : String;
Begin
          Result:= False;
          aOutHRStr:= '';

          If ( ''= aFilePath)
             Then
             Exit;

          Try
             vtMemStmBin:= tMemoryStream.create();
             vtMemStmBin.loadFromFile( aFilePath);
             vtMemStmBin.Position:= 0;

             vStRes:= binStmToHsh990Str( vtMemStmBin);
             aOutHRStr:= vStRes;

             Result:= ( ''< aOutHRStr);
          Except
             On E: Exception
                Do
                ( 'getSimpleHashedResStrFromFile() => '+ E.Message).sendToSink( aStdErr);
          End;

          Try
             freeAndNil( vtMemStmBin);
          Except End;
End;


Function
          oll2shrsHandleNo39( aCurResult: String; aCurChar: Char; Var aVarBlnTxPrep: boolEan; Var aVarCnt39: intEger): String;
Var
          vInLop39                          : intEger;
Begin
          Result:= aCurResult;

          If ( Not aVarBlnTxPrep)
             And ( 0< aVarCnt39)
             And aVarCnt39.isEven()
             Then
             aVarCnt39-= 2;

          For vInLop39:= 0 To ( aVarCnt39 Div 2)- 1
              Do
              Result+= '#39';

          If Odd( aVarCnt39)
             Then
             Begin
                  aVarBlnTxPrep:= Not aVarBlnTxPrep;
          End;

          If aVarBlnTxPrep
             Then
             Result+= ( '#'+ ord( aCurChar).toString());

          aVarCnt39:= 0;

End;

Function
          oll2shrsHandleOrdPrep( aCurResult: String; Var aVarCurOrdPrep: String; Var aVarBlnOrdPrep: boolEan; aDisableOrdPrep: boolEan): String;
Begin
          Result:= aCurResult;

          If aVarBlnOrdPrep
             Then
             Begin
                  Result+= ( '#'+ aVarCurOrdPrep.subString( 0, 3));
                  aVarCurOrdPrep:= '';
                  If aDisableOrdPrep
                     Then
                     aVarBlnOrdPrep:= False;
          End;
End;

Function
          lrsStrToHsh990Str( aLRSLine: String): String;
Var
          vBoPlsStrt                        : boolEan;
          vBoClnStrt                        : boolEan;
          vChDLnPrep                        : Char;
          vBoTxtPrep                        : boolEan;
          vStOrdPrep                        : String;
          vBoOrdPrep                        : boolEan;

          vInCnt39                          : intEger;
          vStDLn                            : String;

Begin
          Result:= '';

          vStDLn:= aLRSLine.trim();

          vBoPlsStrt:= ( vStDLn.startsWith( '+'));
          vBoClnStrt:= ( vStDLn.startsWith( ','));

          If ( vBoPlsStrt Or vBoClnStrt)
             Then
             vStDLn:= vStDLn.subString( 1);

          //If vStDLn.contains( '// comment in between')
          //   Then
          //   _nop( []);

          vStOrdPrep:= '';
          vBoTxtPrep:= False;
          vBoOrdPrep:= False;

          vInCnt39:= 0;
          for vChDLnPrep in vStDLn
              Do
              Begin

                   If ( #39= vChDLnPrep)
                      Then
                      Begin
                           Result:= oll2shrsHandleOrdPrep( Result, vStOrdPrep, vBoOrdPrep, True);
                           Inc( vInCnt39, 1);
                           conTinue;
                      End
                   Else
                      Begin
                           Result:= oll2shrsHandleNo39( Result, vChDLnPrep, vBoTxtPrep, vInCnt39);

                           If vBoTxtPrep
                              Then
                              conTinue;

                           If ( '#'= vChDLnPrep)
                              Then
                              Begin
                                   Result:= oll2shrsHandleOrdPrep( Result, vStOrdPrep, vBoOrdPrep, False);
                                   vBoOrdPrep:= True;
                                   conTinue;
                           End;

                           If vBoOrdPrep
                              Then
                              vStOrdPrep+= vChDLnPrep;

                   End;
          End;

          Result:= oll2shrsHandleOrdPrep( Result, vStOrdPrep, vBoOrdPrep, True);
          Result:= oll2shrsHandleNo39( Result, vChDLnPrep, vBoTxtPrep, vInCnt39);

End;

Function  // writes a string in #990 format to a stream - stream must be created and writable and at necessary starting pos
          hsh990StrToBinStm( aStm: tStream; aResStr: String; aStdErr: tStrNotifyProc= Nil): boolEan;
Var
          vBy1                              : Byte;
          vStNxtBte                         : String;

          aosByte                           : tStringArray;
          vIn1                              : intEger;
          vIn2                              : intEger;

          vStErr                            : String;

Begin
          Result:= False;
          If ( Nil= aStm)
             Then
             Exit;

          aosByte:= aResStr.Split( '#');
          vIn2:= length( aosByte);

          For vIn1:= 0 To vIn2- 1
              Do
              Begin
                   vStNxtBte:= aosByte[ vIn1];
                   If ( ''= vStNxtBte)
                      Then
                      conTinue;

                   If Not vStNxtBte.tryToByte( vBy1)
                      Then
                      Begin
                           vStErr:= ( 'Illegal byte encoding "'+ vStNxtBte+ '" found at position '+ vIn1.toString()+ '.');
                           vStErr.sendToSink( aStdErr);
                           Exit;
                   End;
                   aStm.WriteByte( vBy1);
          End;
          Result:= True;

End;

Function  // writes a string in #990 format to a file - aStdErr allows notifying
          hsh990StrSaveToBinFile( aFilePath: String; aHRStr: String; aStdErr: tStrNotifyProc= Nil): boolEan;
Var
          vtMemStmBin                       : tMemoryStream;
Begin
          Result:= False;
          If ( ''= aFilePath)
             Then
             Exit;

          Try
             vtMemStmBin:= tMemoryStream.create();
             vtMemStmBin.Position:= 0;

             Result:= hsh990StrToBinStm( vtMemStmBin, aHRStr, aStdErr);
             If Result
                Then
                Begin
                     vtMemStmBin.Position:= 0;
                     vtMemStmBin.saveToFile( aFilePath);
             End;

             Result:= fileExists( aFilePath);
          Except
             On E: Exception
                Do
                ( 'getSimpleHashedResStrFromFile() => '+ E.Message).sendToSink( aStdErr);
          End;
          Try
             freeAndNil( vtMemStmBin);
          Except End;

End;


Function  // original author: Mattias Gaertner original project lrstolfm - converts LRA to binary in "one" step
          makeMemStreamFromResStr( aResStr: String): tMemoryStream;
Var
          vInCur                            : intEger;
          vInLen                            : intEger;
          vChCur                            : Char;
          StartPos                          : longInt;
          CharID                            : intEger;
Begin
          Result:= tMemoryStream.create();
          vInCur:= 1;
          vInLen:= length( aResStr);
          While ( vInCur<= vInLen)
                Do
                Begin
                     vChCur:= aResStr[ vInCur];
                     Case vChCur Of
                          '''': Begin
                                     Inc( vInCur);
                                     While vInCur<= vInLen
                                           Do
                                           Begin
                                                If aResStr[ vInCur]<>''''
                                                   Then
                                                   Begin
                                                        StartPos:= vInCur;
                                                        While ( vInCur<= vInLen)
                                                              And
                                                              ( aResStr[ vInCur]<>'''')
                                                              Do
                                                              inc( vInCur);
                                                        Result.write( aResStr[ StartPos], vInCur- StartPos);
                                                   End
                                                Else
                                                   If ( vInCur< vInLen)
                                                      And
                                                      ( aResStr[ vInCur+1]='''')
                                                      Then
                                                      Begin
                                                           Result.write( aResStr[ vInCur],1);
                                                           inc( vInCur, 2);
                                                      End
                                                   Else
                                                      Begin
                                                           inc( vInCur);
                                                           break;
                                                   End;
                                     End;
                                End;

                          '#':  Begin
                                     inc( vInCur);
                                     CharID:= 0;
                                     While ( vInCur<= vInLen)
                                           And
                                           ( aResStr[ vInCur] In [ '0'.. '9'])
                                           Do
                                           Begin
                                                CharID:= CharID* 10+ ord( aResStr[ vInCur])- ord( '0');
                                                inc( vInCur);
                                     End;
                                     vChCur:= chr( CharID);
                                     Result.write( vChCur,1);
                                End;
                          Else
                                inc( vInCur);
                          End;
          End;
End;


End.

