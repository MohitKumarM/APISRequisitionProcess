page 50134 "Pouch Paper Master"
{
    ApplicationArea = All;
    Caption = 'Pouch Paper Master';
    PageType = List;
    SourceTable = "Substrate-Paper Quality Master";
    SourceTableView = where(Type = filter(Pouch));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Pouch Quality Paper"; Rec.Code)
                {

                }
                field("Pouch Quality Paper Description"; Rec."Description")
                {

                }
            }
        }
    }
}
