page 50113 "IndentLineList"
{
    ApplicationArea = All;
    Caption = 'Indent Line List';
    PageType = List;
    SourceTable = "Pre Indent Line";
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Indent No."; Rec."Indent No.")
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ToolTip = 'Specifies the value of the Required Quantity field.';
                }
                field(Reamrk; Rec.Reamrk)
                {
                    ToolTip = 'Specifies the value of the Reamrk field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action("Indent Document")
            {
                Caption = 'Show Indent Document';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = page "Indent Document";
                RunPageLink = "No." = field("Indent No.");


                trigger OnAction()
                begin


                end;
            }
        }
    }
}
