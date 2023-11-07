page 50122 "Partition Costing List"
{
    ApplicationArea = All, Basic, Suite;
    Caption = 'Partition Costing Master';
    CardPageId = "Partition Costing";
    DataCaptionFields = "Product No.", "Main Item Name", "Vendor Name";
    PageType = List;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Partition));
    UsageCategory = Lists;
    Editable = false;

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

                field("No. of Pcs"; Rec."No. of Pcs")
                {

                }
                field("Total Cost"; Rec."Total Cost") { }
            }
        }
    }
}
