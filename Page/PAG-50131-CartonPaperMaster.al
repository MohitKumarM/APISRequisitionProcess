page 50131 "Carton Paper Master"
{
    ApplicationArea = All;
    Caption = 'Carton Paper Master';
    PageType = List;
    SourceTable = "Substrate-Paper Quality Master";
    SourceTableView = where(Type = filter(Carton));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Carton Quality Paper"; Rec.Code)
                {

                }
                field("Carton Quality Paper Description"; Rec."Description")
                {

                }
            }
        }
    }
}
