page 50145 "PM Planning Worksheet"
{
    ApplicationArea = All;
    Caption = 'PM Planning Worksheet';
    PageType = List;
    SourceTable = "PM Planning Item Wise";
    SourceTableView = where("Planning type" = filter(PM));
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field.';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Editable = false;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.';
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                    Editable = false;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ToolTip = 'Specifies the value of the Product Group Code field.';
                    Editable = false;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ToolTip = 'Specifies the value of the Inventory Posting Group field.';
                    Editable = false;
                }

                field("Direct Item Demand"; Rec."Actaul Demand")
                {

                    Caption = 'Direct Item Demand';
                    Editable = false;
                }
                field("Demand Quantity FG"; Rec."Demand Quantity FG")
                {
                    Editable = false;
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    Editable = false;
                }
                field("Quote Comp. Qty"; Rec."Quote Comp. Qty")
                {
                    Editable = false;
                }
                field("Inventory on Prod. Location"; Rec."Inventory on Prod. Location")
                {
                    ToolTip = 'Specifies the value of the Inventory on Prod. Location field.';
                    Editable = false;
                }


                field("Qty on Indent"; Rec."Qty on Indent")
                {
                    ToolTip = 'Specifies the value of the Qty on Indent field.';
                    Editable = false;
                    trigger OnAssistEdit()
                    begin
                        Rec.QtyOnIndentLookup();
                    end;
                }
                field("Total Demand"; Rec."Total Demand")
                {
                    ToolTip = 'Specifies the value of the Total Demand field.';
                    Editable = false;
                }
                field("Qty. for Indent"; Rec."Qty. for Indent")
                {
                    ToolTip = 'Specifies the value of the Qty. for Indent field.';
                }
                field(Select; Rec.Select)
                {
                    ToolTip = 'Specifies the value of the Select field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Planning Lines")
            {
                Caption = 'Update Planning Lines';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin
                    Rec.UpdatePlanningLines();
                    CurrPage.Update();
                end;
            }

            action("Create Indent")
            {
                Caption = 'Create Indent';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.CreateIndent();
                    CurrPage.Update();
                end;
            }
        }
    }

}
