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
                field("Rate(Rs/Kg)"; Rec."Rate of Paper")
                {
                    Caption = 'Rate(Rs/Kg)';
                }
            }
        }
    }
}
