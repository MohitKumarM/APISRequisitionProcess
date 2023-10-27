page 50135 "Paper Quality"
{
    ApplicationArea = All;
    Caption = 'Paper Quality';
    PageType = List;
    SourceTable = "Substrate-Paper Quality Master";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Substrate Type field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Substrate Description field.';
                }
            }
        }
    }
}
