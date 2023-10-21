pageextension 50154 EInvPostedSalesCrMemo extends "Posted Sales Credit Memo"
{
    layout
    {
        modify("IRN Hash")
        {
            Enabled = false;
        }
        modify("Acknowledgement Date")
        {
            Enabled = false;
        }
        modify("Acknowledgement No.")
        {
            Enabled = false;
        }
        modify("QR Code")
        {
            Enabled = false;
        }
        addafter("Cancel Reason")
        {
            field("Cancel Remarks"; Rec."Cancel Remarks")
            {
                ApplicationArea = all;
            }
            field("Irn Cancel DateTime"; Rec."Irn Cancel DateTime")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("LR/RR No."; Rec."LR/RR No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("LR/RR Date"; Rec."LR/RR Date")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            group("E-Invoice")
            {
                action("Create IRN No.")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    begin
                        if Confirm('Do you want to create IRN No.?', false) then begin
                            if (Rec."GST Customer Type" <> Rec."GST Customer Type"::Unregistered) then begin
                                Clear(EInvoiceGeneration);
                                EInvoiceGeneration.GenerateIRN(Rec."No.", 2, true);
                            end else
                                Error('IRN is not needed for unregistered customer type')
                        end
                    end;
                }
                action("Check Payload")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    begin
                        if Confirm('Do you want to Check IRN Payload ?', false) then begin
                            if (Rec."GST Customer Type" <> Rec."GST Customer Type"::Unregistered) then begin
                                Clear(EInvoiceGeneration);
                                EInvoiceGeneration.GenerateIRN(Rec."No.", 2, false);
                            end else
                                Error('IRN is not needed for unregistered customer type')
                        end
                    end;
                }
                action("E-Invoice Log")
                {
                    ApplicationArea = All;
                    RunObject = page "E-Invoice Log";
                    RunPageLink = "Document Type" = filter('Credit Memo'),
                    "No." = field("No.");

                }
                action("Cancel Irn")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    begin
                        if Confirm('Do you want to Cancel Irn No.?', false) then begin
                            Rec.TestField("IRN Hash");
                            Rec.TestField("Irn Cancel DateTime", 0DT);
                            Clear(EInvoiceGeneration);
                            EInvoiceGeneration.CancelIRN(Rec."No.", 2);
                        end
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}