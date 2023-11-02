pageextension 50108 CustomerCardExtension extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("Customer Type"; Rec."Customer Type")
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