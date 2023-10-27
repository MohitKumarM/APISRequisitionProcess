pageextension 50106 UserSetup extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field("Department Code"; Rec."Department Code")
            {
                ApplicationArea = all;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = all;
            }
            field("Indent Approval Limit"; Rec."Indent Approval Limit")
            {
                ApplicationArea = all;
            }
            field("Quote Comp. Approval Limit"; Rec."Quote Comp. Approval Limit")
            {
                ApplicationArea = all;
            }
            field("Quote Comp. Approver ID"; Rec."Quote Comp. Approver ID")
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