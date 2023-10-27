pageextension 50105 PurchasePayableSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Return Order Nos.")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = All;
            }
            field("Carton No. Series"; Rec."Carton No. Series")
            {
                ApplicationArea = All;
            }
            field("Pouch No. Series"; Rec."Pouch No. Series")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}