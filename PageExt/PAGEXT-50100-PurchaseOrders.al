pageextension 50100 INPurchaseOrder extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Release)
        {
            action("Indent List")
            {
                Promoted = true;
                ApplicationArea = All;
                RunObject = Page "Indent List";

            }
            action("Request to approve Indent list")
            {
                Promoted = true;
                ApplicationArea = All;
                RunObject = Page "Request To Approve Indent";

            }
            action("Posted Indent List")
            {
                Promoted = true;
                ApplicationArea = All;
                RunObject = Page "Posted Indent List";
            }



        }
    }

    var
        myInt: Integer;
}