page 50146 "Item Forecast Master"
{
    ApplicationArea = All;
    Caption = 'Item Forecast Master';
    PageType = List;
    SourceTable = "Item Forecaste Master";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Location Description"; Rec."Location Description")
                {
                    ToolTip = 'Specifies the value of the Location Description field.';
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("Projected Quantity"; Rec."Projected Quantity")
                {
                    ToolTip = 'Specifies the value of the Projected Quantity field.';
                }
                field("Buffer Quantity"; Rec."Buffer Quantity")
                {
                    ToolTip = 'Specifies the value of the Buffer Quantity field.';
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ToolTip = 'Specifies the value of the Total Quantity field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}
