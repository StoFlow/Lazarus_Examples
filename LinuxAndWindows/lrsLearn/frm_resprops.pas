Unit
          frm_ResProps;

          {$mode ObjFPC}{$H+}

Interface

Uses
          Classes,
          SysUtils,
          Forms,
          Controls,
          Graphics,
          Dialogs,
          ExtCtrls,
          Buttons;

Type

          tProperties                       = Record

             TypeProp                       : String;
             NameProp                       : String;

          End;

          { tfrm_ResProps_ }

          tfrm_ResProps_                    = Class( tForm)

             pn_Props                       : tPanel;
             pn_Btns                        : tPanel;
             lbed_ResType                   : tLabeledEdit;
             lbed_ResName                   : tLabeledEdit;
             bbt_ok                         : tBitBtn;
             bbt_Cancel                     : tBitBtn;

             Procedure                      formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
             Procedure                      formShow( aSender: tObject);
             Procedure                      lbed_ResTypeChange( aSender: tObject);
             Procedure                      lbed_ResNameChange( aSender: tObject);

             Procedure                      bbt_okClick( aSender: tObject);
             Procedure                      bbt_CancelClick( aSender: tObject);

          Private

          Protected

             Props                          : tProperties;

          Public

             Class Function                 exeCute( aMnFrm: tForm; Var aVarProps: tProperties): tModalResult;

          End;


Implementation

          {$hints off}
Procedure
          _nOp( Const aAOC: Array Of Const);
Begin
          //
End;
          {$hints on}


          {$R *.lfm}

          { tfrm_ResProps_ }

Procedure
          tfrm_ResProps_.formShow( aSender: tObject);
Begin
          _nOp( [ aSender]);

          lbed_ResType.Text:= Props.TypeProp;
          lbed_ResName.Text:= Props.NameProp;
End;

Procedure
          tfrm_ResProps_.formCloseQuery( aSender: tObject; Var aVarCanClose: Boolean);
Begin
          _nOp( [ aSender]);
          aVarCanClose:= ( mrCancel= ModalResult);
End;

Procedure
          tfrm_ResProps_.bbt_okClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          ModalResult:= mrOk;
          close();
End;

Procedure
          tfrm_ResProps_.bbt_CancelClick( aSender: tObject);
Begin
          _nOp( [ aSender]);
          ModalResult:= mrCancel;
          close();
End;


Procedure
          tfrm_ResProps_.lbed_ResTypeChange( aSender: tObject);
Begin
          _nOp( [ aSender]);

          Props.TypeProp:= lbed_ResType.Text;
End;

Procedure
          tfrm_ResProps_.lbed_ResNameChange( aSender: tObject);
Begin
          _nOp( [ aSender]);

          Props.NameProp:= lbed_ResName.Text;
End;


Class Function
          tfrm_ResProps_.exeCute( aMnFrm: tForm; Var aVarProps: tProperties): tModalResult;
Var
          vtFrmRP                           : tfrm_ResProps_;
Begin

          vtFrmRP:= tfrm_ResProps_.create( aMnFrm);
          vtFrmRP.Props:= aVarProps;

          If ( Nil<> aMnFrm)
             Then
             Begin
                  vtFrmRP.Left:= aMnFrm.Left+ ( ( aMnFrm.Width - vtFrmRP.Width ) Div 2);
                  vtFrmRP.Top := aMnFrm.Top + ( ( aMnFrm.Height- vtFrmRP.Height) Div 2);
          End;

          vtFrmRP.show();

          While ( vtFrmRP.ModalResult= mrNone)
                Do
                Begin
                     Application.processMessages();
                     Sleep( 2);
          End;

          Result:= vtFrmRP.ModalResult;
          If ( mrOk= Result)
             Then
             aVarProps:= vtFrmRP.Props;
          freeAndNil( vtFrmRP);

End;

End.

