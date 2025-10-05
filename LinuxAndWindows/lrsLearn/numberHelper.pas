Unit
          numberHelper;

          {$mode ObjFPC}{$H+}
          {$ModeSwitch typehelpers}

Interface

Uses
          Classes
          ,
          SysUtils;

Type

          { tHTypeHelperInt }


          tHTypeHelperInt                   = Type Helper ( tIntegerHelper) For intEger

             Function                       isOdd(): boolEan;
             Function                       isEven(): boolEan;

          End;


Implementation

          { tHTypeHelperInt }

Function
          tHTypeHelperInt.isOdd(): boolEan;
Begin
          Result:= Odd( Self);
End;

Function
          tHTypeHelperInt.isEven(): boolEan;
Begin
          Result:= Not( isOdd);
End;


End.

