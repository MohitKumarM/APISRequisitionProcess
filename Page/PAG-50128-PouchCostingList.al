page 50128 "Pouch Costing List"
{
    ApplicationArea = All, Basic, Suite;
    ;
    Caption = 'Pouch Costing Master';
    CardPageId = "Pouch Costing";
    DataCaptionFields = "Product No.", "Main Item Name", "Vendor Name";
    Editable = false;
    PageType = List;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Pouch));
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

                field("Landed Price / Pouch"; Rec."Landed Price / Pouch")
                {

                }
                field("Landed Price / KG"; Rec."Landed Price / KG")
                {

                }

            }
        }
    }
}
