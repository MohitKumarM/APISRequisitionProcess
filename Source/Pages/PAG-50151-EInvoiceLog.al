page 50312 "E-Invoice Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    SourceTable = E_Invoice_Log;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Acknowledge No."; Rec."Acknowledge No.")
                {
                    Editable = false;
                }
                field("Acknowledge Date"; Rec."Acknowledge Date")
                {
                    Editable = false;
                }
                field("IRN Hash"; Rec."IRN Hash")
                {
                    Editable = false;

                }
                field("QR Code"; Rec."QR Code")
                {
                    Editable = false;
                }
                field("Current Date Time"; Rec."Current Date Time")
                {
                    Editable = false;
                }
                field("IRN Generated"; Rec."IRN Generated")
                {
                    Editable = false;
                }
                /* field("Sent Response"; SendResponse)
                {

                }
                field("Output Response"; OutputResPonse)
                {

                } */

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

            /* action("Ouput Payload")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                var
                    Instrm: InStream;
                    ReturnText: Text;
                begin
                    Rec.CalcFields("Output Response");
                    If rec."Output Response".HasValue() then begin
                        rec."Output Response".CreateInStream(Instrm);
                        Instrm.Read(ReturnText);
                        Message(ReturnText);
                    end;
                end;
            }
            action("Json Payload")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                var
                    Instrm: InStream;
                    ReturnText: Text;
                    Text001: Label 'Parijat C&F';
                    Test: Notification;
                begin
                    Rec.CalcFields("Sent Response");
                    If rec."Sent Response".HasValue() then begin
                        rec."Sent Response".CreateInStream(Instrm);
                        Instrm.Read(ReturnText);
                        Message(ReturnText);
                    end;
                end;
            } */
            action("Sent Request IRN")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("Sent Response");
                    MESSAGE(Rec.SentResponseReadAsText('', TEXTENCODING::UTF8));
                end;
            }
            action("OutPut Request IRN")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("Output Response");
                    MESSAGE(Rec.OutPutResponseReadAsText('', TEXTENCODING::UTF8));
                end;
            }
        }
    }


    var
        SendResponse: Text;
        OutputResPonse: Text;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        SendResponse := Rec.SendResponse();
        OutputResPonse := Rec.GetAPIResponse();

    end;

}