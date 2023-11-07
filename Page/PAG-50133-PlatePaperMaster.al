page 50133 "Plate Paper Master"
{
    ApplicationArea = All;
    Caption = 'Plate Paper Master';
    PageType = List;
    SourceTable = "Substrate-Paper Quality Master";
    SourceTableView = where(Type = filter(Plate));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Plate Quality Paper"; Rec.Code)
                {

                }
                field("Plate Quality Paper Description"; Rec."Description")
                {

                }
                field("Vendor Code"; Rec."Vendor Code")
                {

                }
                field("Vendor Name"; Rec."Vendor Name")
                {

                }
                field("Start Date"; Rec."Start Date")
                {

                }
                field("End Date"; Rec."End Date")
                {

                }
                field("Rate of Paper"; Rec."Rate of Paper")
                {

                }
            }
        }
    }
}
