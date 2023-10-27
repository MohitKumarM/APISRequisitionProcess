pageextension 50101 "usersetupext" extends "Approval User Setup"
{
    layout
    {
        addbefore("Purchase Amount Approval Limit")
        {
            field("Indent Approval Limit"; Rec."Indent Approval Limit")
            {
                ApplicationArea = all;

            }

        }
    }
}