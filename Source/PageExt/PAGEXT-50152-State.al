pageextension 50152 EInvState extends States
{
    layout
    {
        addafter("State Code (GST Reg. No.)")
        {
            field("State Code for E-Invoicing"; Rec."State Code for E-Invoicing")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}