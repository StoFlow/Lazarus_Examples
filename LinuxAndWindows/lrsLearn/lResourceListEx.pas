Unit
          lResourceListEx;

          {$mode ObjFPC}{$H+}

Interface

Uses
          Classes
          ,
          SysUtils
          ,
          lResourceEx
          {$IFDEF LCL}
          ,
          JSONPropStorage
          {$ENDIF}
          ,
          stringEvents
          ;

Type

          {$M+}

          tLResourceCollItem                = Class( tCollectionItem)

          Protected

             Function                       ensureObject(): tLResourceEx;

             Function                       _name_get (): String;
             Procedure                      _name_set ( aName : String);

             Function                       _type_get (): String;
             Procedure                      _type_set ( aType : String);

             Function                       _value_get(): String;
             Procedure                      _value_set( aValue: String);


          Public

             Resource                       : tLResourceEx;
             Procedure                      assign( aSource: tPerSistent); OverRide;
             Constructor                    create( aCollection: tCollection); OverRide;

          Published


             Property                       ResName : String Read _name_get       Write _name_set;
             Property                       ResType : String Read _type_get       Write _type_set;
             Property                       ResValue: String Read _value_get      Write _value_set;

          End;


          tLResourceListEx                  = Class( tCollection)

          Private

             OwnerObj                       : tPersistent;
             InfoNotify                     : tStrNotifyProc;

          Protected

             Function                       getOwner(): tPersistent; Override;

             Function                       _itm_get( aIndex: intEger): tLResourceEx;

          Public

             Constructor                    create( aOwner: tPersistent; aInfoNotify: tStrNotifyProc);
             Constructor                    create( aSrcFNme: String; aOwner: tPersistent; aInfoNotify: tStrNotifyProc);

             Procedure                      append1( aLaRes: tLResourceEx);
             Procedure                      append2( Const aName: String; Const aType: String; Const aValue: String);
             Procedure                      assignReLi( aSource: tCollection; aDoClearBefore: boolEan= False);

             Procedure                      collectLRSSink( aDtaOwner: tObject; aCollectSink: tStrNotifyProc);

             Function                       writeToJSONFile( aFileName: String): boolEan;
             Function                       writeToLRSFile ( aFileName: String): boolEan;

             {$IFDEF LCL}
             Procedure                      writeToPropStore( aStg: tJsonPropStorage);
             Procedure                      readFromPropStore( aStg: tJsonPropStorage);
             {$ENDIF}

             Function                       lrsLines2List( aLines: tStrings; aDoAppend: boolEan): intEger;

             Function                       readFromJSONFile( aFileName: String; aDontKeepOldEntries: boolEan= False): boolEan;
             Function                       readFromLRSFile ( aFileName: String; aDontKeepOldEntries: boolEan= False): boolEan;
             Function                       readFromFile    ( aFileName: String; aDontKeepOldEntries: boolEan= False): boolEan;


             Procedure                      reportScriptResults( aSink: tLaResNotifyProc);

             Procedure                      forEach2LRS( aAssembleSink: tStrReturnProcEvt; aCollectSink: tStrNotifyProc);

             Property                       Item[ aIndex: intEger]: tLResourceEx Read _itm_get; Default;


          End;

          {$M-}

Implementation

Uses
          //,
          fpjsonrtti
          ,
          fpJSon
          ,
          stringHelper
          ,
          strObj
          ;


          { tLResourceCollItem }

Function
          tLResourceCollItem.ensureObject(): tLResourceEx;
Begin
          If ( Nil= Resource)
             Then
             Resource:= tLResourceEx.create( '', '', '');

          Result:= Resource;
End;

Function
          tLResourceCollItem._name_get (): String;
Begin
          Result:= ensureObject().Name;
End;

Procedure
          tLResourceCollItem._name_set ( aName : String);
Begin
          ensureObject().Name:= aName;
End;


Function
          tLResourceCollItem._type_get (): String;
Begin
          Result:= ensureObject().ValueType;
End;

Procedure
          tLResourceCollItem._type_set ( aType : String);
Begin
          ensureObject().ValueType:= aType;
End;

Function
          tLResourceCollItem._value_get(): String;
Begin
          Result:= ensureObject().Value;
End;

Procedure
          tLResourceCollItem._value_set( aValue: String);
Begin
          ensureObject().Value:= aValue;
End;

Procedure
          tLResourceCollItem.assign( aSource: tPerSistent);
Begin
          If Not ( aSource Is tLResourceCollItem)
             Or
             ( Nil= ( aSource As tLResourceCollItem).Resource)
             Then
             Inherited assign( aSource)
          Else
             Begin
                  If ( Nil= Resource)
                     Then
                     Resource:= tLResourceEx.create( ( aSource As tLResourceCollItem).Resource)
                  Else
                     Resource.assign( ( aSource As tLResourceCollItem).Resource);
          End;
End;

Constructor
          tLResourceCollItem.create( aCollection: tCollection);
Begin
          inHerited create( aCollection);
End;

          { tLResourceListEx }

Constructor
          tLResourceListEx.create( aOwner: tPersistent; aInfoNotify: tStrNotifyProc);
Begin
          inHerited create( tLResourceCollItem);
          OwnerObj  := aOwner;
          InfoNotify:= aInfoNotify;
End;

Constructor
          tLResourceListEx.create( aSrcFNme: String; aOwner: tPersistent; aInfoNotify: tStrNotifyProc);
Begin
          create( aOwner, aInfoNotify);

          readFromFile( aSrcFNme);

End;

Procedure
          tLResourceListEx.append1( aLaRes: tLResourceEx);
Var
          vtCollItm                         : tCollectionItem;
Begin
          vtCollItm:= add();
          tLResourceCollItem( vtCollItm).Resource:= aLaRes;
End;


Procedure
          tLResourceListEx.append2( Const aName: String; Const aType: String; Const aValue: String);
Begin
          append1( tLResourceEx.create( aName, aType, aValue));
End;

Function
          tLResourceListEx.getOwner(): tPersistent;
Begin
          Result:= OwnerObj;
End;

Function
          tLResourceListEx._itm_get( aIndex: intEger): tLResourceEx;
Begin
          Result:= tLResourceCollItem( Self.Items[ aIndex]).Resource;
End;

Function
          tLResourceListEx.writeToJSONFile( aFileName: String): boolEan;
Var
          vtJsStr                           : tJSONStreamer;
          vtJsObj                           : tJSONObject;
          vStJSON                           : String;

Begin
          Result:= False;
          Try
              vtJsStr:= tJSONStreamer.Create( Nil);
              vtJsObj:= vtJsStr.ObjectToJSON( Self);
              vStJSON:= vtJsObj.FormatJSON( [], 2);
              Result:= vStJSON.saveToFile( aFileName);
          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.writeToJSONFile() => '+ E.Message).sendToSink( InfoNotify);
          End;
End;

Procedure
          tLResourceListEx.assignReLi( aSource: tCollection; aDoClearBefore: boolEan= False);
Var
          vInOne                            : intEger;
Begin
          If ( Nil= aSource)
             Then
             Exit;

          beginUpdate();

          ( 'Assigning '+ aSource.Count.toString()+' list entries'+ '...'.iif( Not aDoClearBefore, ' with previous clear...')).sendToSink( InfoNotify);

          Try
             If aDoClearBefore
                Then
                clear();

             For vInOne:= 0 To aSource.Count-1
                 Do
                 Begin
                      add().assign( aSource.Items[ vInOne]);
                      ( 'Assigned '+ ( vInOne+ 1).toString()+ ' list entries so far...').sendToSink( InfoNotify);
             End;

          Finally
             EndUpdate;
          End;
End;

Function  // returns true only after successfully retrieved >0 entries
          tLResourceListEx.readFromJSONFile( aFileName: String; aDontKeepOldEntries: boolEan= False): boolEan;
Var
          vtJsDSt                           : tJSONDeStreamer;
          vStJSON                           : String;
          vtLaReLi                          : tLResourceListEx;
Begin
          Result:= False;
          Try
              vStJSON:= '';
              If Not vStJSON.loadFromFile( aFileName)
                 Then
                 Exit;

              vtLaReLi:= tLResourceListEx.create( Nil, Nil);
              vtJsDSt:= tJSONDeStreamer.Create( Nil);
              vtJsDSt.jsonToObject( vStJSON, vtLaReLi);

              If ( 1> vtLaReLi.Count)
                 Then
                 Exit;

              Self.assignReLi( vtLaReLi, aDontKeepOldEntries);
              Result:= True;
          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.readFromJSONFile() => '+ E.Message).sendToSink( InfoNotify);
          End;
          Try
             freeAndNil( vtLaReLi);
             freeAndNil( vtJsDSt);
          Except End;
          Try
             ( 'Result of tLResourceListEx.readFromJSONFile( "'+ aFileName+ '") is '+ Result.toString( tUseBoolStrs.True)).sendToSink( InfoNotify);
          Except End;
End;


Function
          tLResourceListEx.lrsLines2List( aLines: tStrings; aDoAppend: boolEan): intEger;
Var
          vIn1                              : intEger;
          vIn2                              : intEger;
          vtLaRs                            : tLResourceEx;
Begin
          Result:= -1;
          If ( Nil= aLines)
             Or
             ( 1> aLines.Count)
             Then
             Exit;

          If Not aDoAppend
             Then
             clear();

          vtLaRs:= Nil;

          vIn2:= aLines.Count;
          vIn1:= 0;
          Result:= 0;
          While ( vIn1< vIn2)
                Do
                If tLResourceEx.parseLRS( aLines, vIn1, vtLaRs)
                   Then
                   Begin
                        append2( vtLaRs.Name, vtLaRs.ValueType, vtLaRs.Value);
                        'Appended resource to list'.sendToSink( InfoNotify);
                        freeAndNil( vtLaRs);
                        inc( Result, 1);
                   End
                Else
                  inc( vIn1, 1);

End;


Function  // returns true only after successfully retrieved >0 entries
          tLResourceListEx.readFromLRSFile( aFileName: String; aDontKeepOldEntries: boolEan= False): boolEan;
Var
          vtSlLRSLines                      : tStringList;
          vInLddCnt                         : intEger;
Begin
          Result:= False;
          Try
              vtSlLRSLines:= tStringList.create();
              vtSlLRSLines.loadFromFile( aFileName);
              vInLddCnt:= lrsLines2List( vtSlLRSLines, Not aDontKeepOldEntries);
              Result:= ( 0< vInLddCnt);
          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.readFromJSONFile() => '+ E.Message).sendToSink( InfoNotify);
          End;
          Try
             freeAndNil( vtSlLRSLines);
          Except End;
          Try
             ( 'Result of tLResourceListEx.readFromLRSFile( "'+ aFileName+ '") is '+ Result.toString( tUseBoolStrs.True)).sendToSink( InfoNotify);
          Except End;
End;

Function  // returns true only after successfully retrieved >0 entries
          tLResourceListEx.readFromFile( aFileName: String; aDontKeepOldEntries: boolEan= False): boolEan;
Var
          vStFNme                           : String;
          vStExt                            : String;

Begin
          Result:= False;

          vStFNme:= aFileName;
          vStExt := extractFileExt( vStFNme);

          If ( '.lrs'= vStExt.toLower())
             Then
             Result:= readFromLRSFile( vStFNme, aDontKeepOldEntries)
          Else
             If ( '.json'= vStExt.toLower())
                Then
                Result:= readFromJSONFile( vStFNme, aDontKeepOldEntries)
             Else
                 ( 'tLResourceListEx.readFromFile() => don''t know, how to handle file extension "'+ vStExt+ '"!').sendToSink( InfoNotify);

End;

Procedure
          tLResourceListEx.collectLRSSink( aDtaOwner: tObject; aCollectSink: tStrNotifyProc);
Var
          vtLaRe                            : tLResourceEx;
          vStLRS                            : String;
Begin
          If ( Nil= aDtaOwner)
             Or
             Not( aDtaOwner is tLResourceEx)
             Then
             Exit;

          If Not assigned( aCollectSink)
             Then
             Exit;

          vtLaRe:= aDtaOwner As tLResourceEx;

          vStLRS:= vtLaRe.toScriptPiece( True, False);
          aCollectSink( vStLRS);
End;

Function
          tLResourceListEx.writeToLRSFile( aFileName: String): boolEan;
Var
          vtStrObj                          : tStrObj;
Begin
          Result:= False;
          Try
              vtStrObj:= tStrObj.create( '');
              forEach2LRS( @collectLRSSink, @vtStrObj.collect);
              Result:= vtStrObj.Value.saveToFile( aFileName);
              freeAndNil( vtStrObj);
          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.writeToJSONFile() => '+ E.Message).sendToSink( InfoNotify);
          End;
End;



          {$IFDEF LCL}
Procedure
          tLResourceListEx.writeToPropStore( aStg: tJsonPropStorage);
Var
          vIn1                              : intEger;
          vIn2                              : intEger;
          vtLaRe                            : tLResourceEx;
Begin
          If ( Nil= aStg)
             Then
             Exit;

          Try
             vIn2:= Self.Count;

             aStg.doWriteString( 'LBX', 'Count', vIn2.toString());
             For vIn1:= 0 To vIn2- 1
                 Do
                 Begin
                      vtLaRe:= Self.Item[ vIn1];
                      aStg.doWriteString( 'LBX', vIn1.toString()+ '_Name' , vtLaRe.Name);
                      aStg.doWriteString( 'LBX', vIn1.toString()+ '_Type' , vtLaRe.ValueType);
                      aStg.doWriteString( 'LBX', vIn1.toString()+ '_Value', vtLaRe.Value);
             End;

          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.writeToPropStore() => '+ E.Message).sendToSink( InfoNotify);
          End;
End;

Procedure
          tLResourceListEx.readFromPropStore( aStg: tJsonPropStorage);
Var
          vIn1                              : intEger;
          vIn2                              : intEger;
          vStCnt                            : String;
          vStNme                            : String;
          vStTpe                            : String;
          vStVal                            : String;

Begin
          If ( Nil= aStg)
             Then
             Exit;

          Try
             vStCnt:= aStg.doReadString( 'LBX', 'Count', '0');
             vIn2:= vStCnt.toIntDef();

             For vIn1:= 0 To vIn2- 1
                 Do
                 Begin
                      vStNme:= aStg.doReadString( 'LBX', vIn1.toString()+ '_Name' , '');
                      vStTpe:= aStg.doReadString( 'LBX', vIn1.toString()+ '_Type' , '');
                      vStVal:= aStg.doReadString( 'LBX', vIn1.toString()+ '_Value', '');

                      If ( ''< vStNme)
                         And
                         ( ''< vStTpe)
                         And
                         ( ''< vStVal)
                         Then
                         append2( vStNme, vStTpe, vStVal);

             End;
             ( Self.Count.toString()+ ' resources loaded from property store').sendToSink( InfoNotify);
          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.writeToPropStore() => '+ E.Message).sendToSink( InfoNotify);
          End;
End;
          {$ENDIF}

Procedure
          tLResourceListEx.reportScriptResults( aSink: tLaResNotifyProc);
Var
          vIn1                              : intEger;
Begin
          If ( Nil= aSink)
             Then
             Exit;

          Try
             ( Self.Count.toString()+ ' resources are in the list').sendToSink( InfoNotify);

             For vIn1:= 0 To Self.Count- 1
                 Do
                 aSink( Self.Item[ vIn1]);
                 //OwnerForm.addLbxItm( Self.Item[ vIn1].ValueType+ ' : '+ Self.Item[ vIn1].Name, Self.Item[ vIn1]);

          Except
             On E: Exception
                Do
                ( 'tLResourceListEx.reportScriptResults() => '+ E.Message).sendToSink( InfoNotify);
          End;

End;

Procedure
          tLResourceListEx.forEach2LRS( aAssembleSink: tStrReturnProcEvt; aCollectSink: tStrNotifyProc);
Var
          vIn1                              : intEger;
          vIn2                              : intEger;
          vtLaRs                            : tLResourceEx;

Begin
          vIn2:= Self.Count;
          For vIn1:= 0 To vIn2- 1
              Do
              Begin
                   vtLaRs:= Self.Item[ vIn1];
                   If ( Nil<> vtLaRs)
                      Then
                      //condCallCollector( aStdOut, vtLaRs)
                      aAssembleSink( vtLaRs, aCollectSink)
                   Else
                      ( 'tLResourceListEx.forEach2LRS()  => Resource item at index '+ vIn1.toString()+ ' is NIL').sendToSink( InfoNotify);
          End;

End;


End.

