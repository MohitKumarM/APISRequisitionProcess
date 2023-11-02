pageextension 50109 LocationExtension extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("Production Unit"; Rec."Production Unit")
            {
                ApplicationArea = all;
            }
            field("Reject Unit"; Rec."Reject Unit")
            {
                ApplicationArea = all;
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