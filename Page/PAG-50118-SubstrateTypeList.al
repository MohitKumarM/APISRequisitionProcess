page 50118 "Substrate Type List"
{
    ApplicationArea = All;
    Caption = 'Substrate Type Master';
    PageType = List;
    SourceTable = "Substrate-Paper Quality Master";
    SourceTableView = where(Type = filter(Substrate));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Substrate Type"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Substrate Type field.';
                }
                field("Substrate Description"; Rec."Description")
                {
                    ToolTip = 'Specifies the value of the Substrate Description field.';
                }
            }
        }
    }
}
