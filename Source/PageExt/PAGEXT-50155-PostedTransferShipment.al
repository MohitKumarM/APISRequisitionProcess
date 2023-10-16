pageextension 50155 EInvPostedTransferShipment extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group("E-Invoice Information")
            {
                field("IRN Hash"; Rec."IRN Hash")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Acknowledgement No."; Rec."Acknowledgement No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Acknowledgement Date"; Rec."Acknowledgement Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("QR Code"; Rec."QR Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter("Co&mments")
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
                RunPageLink = "Document Type" = filter('Invoice'),
                    "No." = field("No.");

            }
        }
    }

    var
        myInt: Integer;
}