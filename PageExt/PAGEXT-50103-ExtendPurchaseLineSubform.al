pageextension 50103 "IndentNo" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = all;

            }
            field("Indent Line No"; Rec."Indent Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
}