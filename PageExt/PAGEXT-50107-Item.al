pageextension 50107 Item extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Full Description"; Rec."Full Description")
            {
                ApplicationArea = all;
            }
            field("PM Item Type"; Rec."PM Item Type")
            {
                ApplicationArea = all;
            }
            field(Length; Rec.Length)
            {
                ApplicationArea = all;

            }
            field(Width; Rec.Width)
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