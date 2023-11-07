page 50121 "Carton Costing List"
{
    ApplicationArea = All, Basic, Suite;
    ;
    Caption = 'Carton Costing Master';
    CardPageId = "Carton Costing";
    DataCaptionFields = "Product No.", "Main Item Name", "Vendor Name";
    Editable = false;
    PageType = List;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Carton));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product No."; Rec."Product No.")
                {
                    ToolTip = 'Specifies the value of the Product No. field.';
                }
                field("Item Name"; Rec."Main Item Name")
                {
                    ToolTip = 'Specifies the value of the Main Item Name field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }

                field("Total Cost"; Rec."Total Cost") { }
            }
        }
    }
    var

    trigger OnOpenPage()
    begin
        Rec.CalculateCartonCostingHeader();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalculateCartonCostingHeader();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalculateCartonCostingHeader();
    end;



}
