Program
          lrsCmp;

          {$mode objfpc}{$H+}

Uses
          {$IFDEF UNIX}
          cthreads,
          {$ENDIF}
          clAsses
          { you can add units after this }
          ,
          sysUtils
          ,
          lResourceListEx
          ,
          lResourceEx
          ,
          stringEvents
          ,
          strObj
          ,
          nOp
          ;

Var
          vStFNmeLeft                       : String;
          vStFNmeRght                       : String;
          vtSoPipe                          : tStrObj;

Function
          checkFile( aFNme: String; Out aOutFNme: String): boolEan;
Begin
          Result     := False;
          aOutFNme   := '';

          Try
             Result := fileExists( aFNMe);
          Except End;

          If ( Not Result)
             Then
             writeLn( 'Cannot reach/find/see file "'+ aFNme+ '"')
          Else
             aOutFNme:= aFNme;

End;
Function
          checkParms(): boolEan;
Begin
          Result:= False;

          If ( 2> paramCount())
             Then
             writeLn( 'Usage : prg.exe leftfile rightfile (both must exist)')
          Else
             Result:= (
                        checkFile( paramStr( 1), vStFNmeLeft)
                        And
                        checkFile( paramStr( 2), vStFNmeRght)
                      );
End;


Procedure
          outPut( Const aString: String); StdCall;
Begin
          writeLn( aString);
End;

Procedure
          prepPipe();
Begin
          vtSoPipe:= tStrObj.create( @outPut);
End;


Var
          vtReLiLeft                        : tlResourceListEx;
          vtReLiRght                        : tlResourceListEx;

Function
          cmpCounts(): boolEan;
Var
          vStCnts                           : String;
Begin
          vStCnts:= format( '%.0n vs. %.0n', [ doUble( vtReLiLeft.Count), doUble( vtReLiRght.Count)]);
          Result:= ( vtReLiLeft.Count= vtReLiRght.Count);
          If Not Result
             Then
             outPut( 'Count of left list differs from count of right one : '+ vStCnts)
          Else
             outPut( 'Count of left list equals to count of right one : '+ vStCnts);
End;

Function
          cmp1by1(): boolEan;
Var
          vInOne                            : intEger;
          vtRxLeft                          : tLResourceEx;
          vtRxRght                          : tLResourceEx;

Begin
          Result:= True;

          For vInOne:= 0 To vtReLiLeft.Count- 1
              Do
              Begin
                   vtRxLeft:= vtReLiLeft[ vInOne];
                   vtRxRght:= vtReLiRght[ vInOne];

                   If ( rcrEqual<> vtRxLeft.compare( vtRxRght, True, @vtSoPipe.collect))
                      Then
                      Begin
                           Result:= False;
                           Exit;
                   End;
          End;

End;


{$R *.res}

Begin
          If Not checkParms()
             Then
             Begin
                  ExitCode:= 87;
                  exit;
          End;

          prepPipe();

          vtReLiLeft:= tlResourceListEx.create( vStFNmeLeft, Nil, @vtSoPipe.collect);
          vtReLiRght:= tlResourceListEx.create( vStFNmeRght, Nil, @vtSoPipe.collect);

          If Not cmpCounts()
             Then
             Begin
                  ExitCode:= 24;
                  exit;
          End;

          If Not cmp1by1()
             Then
             Begin
                  ExitCode:= 13;
                  exit;
          End;

          ExitCode:= 0;
          _nOp( []);

End.
