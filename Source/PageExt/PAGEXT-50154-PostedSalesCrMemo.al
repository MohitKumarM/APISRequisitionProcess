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
    }

    actions
    {
        addafter("F&unctions")
        {
            action("Create IRN No.")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    EInvoiceGeneration: Codeunit "E-Invoice Generation";
                begin
                    Clear(EInvoiceGeneration);
                    EInvoiceGeneration.GenerateIRN(Rec."No.", 1, true);
                end;
            }
            action("Check Payload")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    EInvoiceGeneration: Codeunit "E-Invoice Generation";
                begin
                    Clear(EInvoiceGeneration);
                    EInvoiceGeneration.GenerateIRN(Rec."No.", 1, false);
                end;
            }
            action("E-Invoice Log")
            {
                ApplicationArea = All;
                RunObject = page "E-Invoice Log";
                RunPageLink = "Document Type" = filter('Credit Memo'),
                    "No." = field("No.");

            }
        }
    }

    var
        myInt: Integer;
}