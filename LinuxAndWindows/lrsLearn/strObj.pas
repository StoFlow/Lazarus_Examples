Unit
          strObj;

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

          { tStrObj }
          tStrObj                           = Class( tObject)

          Private

             _FwdCB                         : tForwardStringToCallBack;

          Public

             Value                          : String;

             Constructor                    create();
             Constructor                    create( aValue: String);
             Constructor                    create( aFwd2CB: tForwardStringToCallBack);
             Destructor                     deStroy(); Override;

             Procedure                      collect( Const aStr: String);

             Property                       ForwardToCallBack: tForwardStringToCallBack Read _FwdCB Write _FwdCB;
          End;



Implementation


          { tStrObj }

Destructor
          tStrObj.deStroy();
Begin
          Value:= '';
          inHerited;
End;

Constructor
          tStrObj.create();
Begin
          inHerited;
          Self.Value:= '';
          _FwdCB    := Nil;
End;

Constructor
          tStrObj.create( aValue: String);
Begin
          create();
          Self.Value:= aValue;
End;

Constructor
          tStrObj.create( aFwd2CB: tForwardStringToCallBack);
Begin
          create();
          _FwdCB:= aFwd2CB;
End;


Procedure
          tStrObj.collect( Const aStr: String);
Begin
          If assigned( ForwardToCallBack)
             Then
             ForwardToCallBack( aStr)
          Else
             Self.value+= aStr;
End;



End.
