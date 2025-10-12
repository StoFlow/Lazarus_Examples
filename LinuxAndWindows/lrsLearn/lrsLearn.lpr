Program
          lrsLearn;

          {$mode objfpc}{$H+}

Uses
          {$IFDEF UNIX}
          cthreads,
          {$ENDIF}
          {$IFDEF HASAMIGA}
          athreads,
          {$ENDIF}
          Interfaces // this includes the LCL widgetset
          ,
          Forms
          ,
          frm_lrsLearn
          ;

          {$R *.res}

Begin
          RequireDerivedFormResource:=True;
          Application.Scaled:=True;
          {$PUSH}{$WARN 5044 OFF}
          Application.MainFormOnTaskbar:= True;
          {$POP}
          Application.Initialize;
          Application.CreateForm( tfrm_lrsLearn_, frm_lrsLearn_);
          Application.Run;
End.

