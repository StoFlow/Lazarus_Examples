Program
          strRev;

          {$mode objfpc}{$H+}

Uses
          {$IFDEF UNIX}
          cthreads,
          {$ENDIF}
          {$IFDEF HASAMIGA}
          athreads,
          {$ENDIF}
          Interfaces, // this includes the LCL widgetset
          Forms,
          SysUtils,
          frm_StrRev
          { you can add units after this };

          {$R *.res}

Begin
          RequireDerivedFormResource:=True;
          Application.Scaled:=True;
          {$PUSH}{$WARN 5044 OFF}
          Application.MainFormOnTaskbar:=True;
          {$POP}
          Application.Initialize;
          Application.CreateForm(Tfrm_StrRev_, frm_StrRev_);
          Application.Run;
End.

