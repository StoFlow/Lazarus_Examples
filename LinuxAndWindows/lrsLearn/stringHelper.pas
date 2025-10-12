Unit
          stringHelper;

          {$mode ObjFPC}{$H+}
          {$ModeSwitch typehelpers}

          {$If ( FPC_VERSION> 2) And ( FPC_RELEASE> 2) And ( FPC_PATCH> 0)}
               {$Define FPC331aa}
          {$Else}
          {$EndIf}


Interface

Uses
          Classes
          ,
          SysUtils
          ,
          stringEvents
          ;

Type


          { tHTypeHelperString }

          tHTypeHelperString                = Type Helper( tStringHelper) For String

             Function                       toIntDef ( aDefaultVal: intEger= 0): intEger;
             Function                       tryToByte( Out aOutRes: Byte): boolEan;
             Function                       saveToFile( aFileName: String): boolEan;
             Function                       loadFromFile( aFileName: String): boolEan;
             Procedure                      sendToSink( aSink: tStrNotifyProc);
             Function                       existsAsFileFolder(): boolEan;
             Function                       existsAsFile(): boolEan;
             Function                       iif( aUseSelf: boolEan; aAltStr: String): String;

          End;

Implementation

Procedure
          condCallStrNotifySink( aSink: tStrNotifyProc; aMsg: String);
Begin
          If ( assigned( aSink))
             Then
             Try
                aSink( aMsg);
             Except End;
End;


          { tHTypeHelperString }

Function
          tHTypeHelperString.toIntDef( aDefaultVal: intEger= 0): intEger;
Begin
          Result:= strToIntDef( Self, aDefaultVal);
End;


Function
          tHTypeHelperString.tryToByte( Out aOutRes: Byte): boolEan;
Var
          //vBy1                              : Byte;
          vInTst                            : intEger;
Begin
          aOutRes:= 0;
          Result:= False;

          vInTst:= strToIntDef( Self, -1);
          If ( -1< vInTst)
             And
             ( 256> vInTst)
             Then
             Begin
                  aOutRes:= Byte( vInTst);
                  Result:= True;
          End;
End;


Function
          tHTypeHelperString.saveToFile( aFileName: String): boolEan;
Var
          vtMemStm                          : tMemoryStream;
          vtEnc                             : tEncoding;
          aobCont                           : tBytes;
          vI64Sze                           : int64;
          {$IfNDef FPC331aa}
          vI64One                           : int64;
          {$EndIf}

Begin
          Result:= False;

          Try
             vtMemStm:= tMemoryStream.create();
             vtEnc   := tEncoding.ANSI;
             aobCont := vtEnc.GetAnsiBytes( Self);
             vI64Sze := sysTem.length( aobCont);

             {$IfDef FPC331aa}
             vtMemStm.write( aobCont, vI64Sze);
             {$Else}
             For vI64One:= 0 To vI64Sze- 1
                 Do
                 vtMemStm.writeByte( aobCont[ vI64One]);
             {$EndIf}

             vtMemStm.saveToFile( aFileName);
             Result:= fileExists( aFileName);

          Finally
             Try
                freeAndNil( vtMemStm);
             Except End;
          End;
End;


Function
          tHTypeHelperString.loadFromFile( aFileName: String): boolEan;
Var
          vtMemStm                          : tMemoryStream;
          vtEnc                             : tEncoding;
          aobCont                           : tBytes;
          vI64Sze                           : int64;
          {$IfNDef FPC331aa}
          vI64One                           : int64;
          {$EndIf}
Begin
          Result:= fileExists( aFileName);
          If Not Result
             Then
             Exit;

          Try
             vtMemStm:= tMemoryStream.create();
             vtMemStm.loadFromFile( aFileName);

             vI64Sze:= vtMemStm.Size;
             aobCont:= [];
             setLength( aobCont, vI64Sze);
             vtMemStm.Position:= 0;

             {$IfDef FPC331aa}
             vtMemStm.Read( aobCont, vI64Sze);
             {$Else}
             For vI64One:= 0 To vI64Sze- 1
                 Do
                 aobCont[ vI64One]:= vtMemStm.readByte();
             {$EndIf}

             vtEnc:= tEncoding.ANSI;
             Self:= vtEnc.GetAnsiString( aobCont);

          Except
             Result:= False;
          End;
          Try
             freeAndNil( vtMemStm);
          Except End;
End;


Procedure
          tHTypeHelperString.sendToSink( aSink: tStrNotifyProc);
Begin
          condCallStrNotifySink( aSink, Self);
End;

Function
          tHTypeHelperString.existsAsFileFolder(): boolEan;
Begin
          Result:= False;
          If ( ''= Self)
             Then
             Exit;

          Try
             Result:= directoryExists( Self, False);
          Except End;

End;

Function
          tHTypeHelperString.existsAsFile(): boolEan;
Begin
          Result:= False;
          If ( ''= Self)
             Then
             Exit;

          Try
             Result:= fileExists( Self, False);
          Except End;

End;

Function
          tHTypeHelperString.iif( aUseSelf: boolEan; aAltStr: String): String;
Begin
          If aUseSelf
             Then
             Result:= Self
          Else
             Result:= aAltStr;
End;

End.

