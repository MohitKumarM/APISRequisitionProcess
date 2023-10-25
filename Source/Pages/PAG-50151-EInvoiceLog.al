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
                field("IRN Generated"; Rec."IRN Status")
                {
                    Editable = false;
                }
                field("Irn Cancel Date Time"; Rec."Irn Cancel Date Time")
                {
                    ApplicationArea = all;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = all;
                }
                field("E-Way Bill No"; Rec."E-Way Bill No")
                {
                    ApplicationArea = all;
                }
                field("E-Way Bill Date Time"; Rec."E-Way Bill Date Time")
                {
                    ApplicationArea = all;
                }
                field("E-Way Bill Status"; Rec."E-Way Bill Status")
                {
                    ApplicationArea = all;
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
            action("Generate IRN Sent Request")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    Instrm: InStream;
                    FileName: Text;
                begin
                    Rec.CALCFIELDS("G_IRN Sent Request");
                    MESSAGE(Rec.GenerateIRNSentResponseReadAsText('', TEXTENCODING::UTF8));
                    Rec."G_IRN Sent Request".CreateInStream(Instrm);
                    FileName := Rec."No." + '.txt';
                    DownloadFromStream(Instrm, 'Export', '', 'All Files (*.*)|*.*', FileName);
                end;
            }
            action("Generate IRN Output Request")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("G_IRN Output Response");
                    MESSAGE(Rec.GenerateIRNOutPutResponseReadAsText('', TEXTENCODING::UTF8));
                end;
            }
            action("Cancel IRN Sent Request")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("C_IRN Sent Request");
                    MESSAGE(Rec.GenerateIRNOutPutResponseReadAsText('', TEXTENCODING::UTF8));
                end;
            }
            action("Cancel IRN OutPut Request")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("C_IRN Output Response");
                    MESSAGE(Rec.GenerateIRNOutPutResponseReadAsText('', TEXTENCODING::UTF8));
                end;
            }

            action("Generate E-Way bill Sent Request")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("G_E-Way bill Sent Request");
                    MESSAGE(Rec.GenerateIRNOutPutResponseReadAsText('', TEXTENCODING::UTF8));
                end;
            }
            action("Generate E-Way bill Output Request")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.CALCFIELDS("G_E-Way bill Output Response");
                    MESSAGE(Rec.GenerateIRNOutPutResponseReadAsText('', TEXTENCODING::UTF8));
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