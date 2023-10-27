page 50132 "Partition Paper Master"
{
    ApplicationArea = All;
    Caption = 'Partition Paper Master';
    PageType = List;
    SourceTable = "Substrate-Paper Quality Master";
    SourceTableView = where(Type = filter(Partition));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Partition Quality Paper"; Rec.Code)
                {

                }
                field("Partition Quality Paper Description"; Rec."Description")
                {

                }
            }
        }
    }
}
