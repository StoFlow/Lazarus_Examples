Unit
          stringEvents;

          {$mode ObjFPC}{$H+}

Interface

Type
          tStrNotifyProc                    = Procedure( Const aValue: String) Of Object;
          tStrReturnProc                    = Procedure( aDtaOwner: tObject; Out aValue: String) Of Object;
          tStrReturnProcEvt                 = Procedure( aDtaOwner: tObject; aCollectSink: tStrNotifyProc) Of Object;

          tForwardStringToCallBack          = Procedure( Const aString: String); StdCall;



Implementation

End.

