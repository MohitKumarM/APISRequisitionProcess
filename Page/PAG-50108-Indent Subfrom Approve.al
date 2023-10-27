page 50108 "Indent Subform Approve"
{
    PageType = ListPart;
    SourceTable = "Pre Indent Line";
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Requisition No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }


                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Required Quantity field.';
                }
                field(Reamrk; Rec.Reamrk)
                {
                    ApplicationArea = all;
                }

                field(UOM; Rec.UOM)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the UOM field.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the UOM field.';

                }

            }
        }
    }
}