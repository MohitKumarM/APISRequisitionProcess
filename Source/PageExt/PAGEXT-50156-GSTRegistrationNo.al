pageextension 50156 GSTRegsitrationNo extends "GST Registration Nos."
{
    layout
    {
        addafter(Description)
        {
            field("User Name"; Rec."User Name")
            {
                ApplicationArea = all;
            }
            field(Password; Rec.Password)
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