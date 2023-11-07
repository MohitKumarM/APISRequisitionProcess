page 50135 "Paper Master"
{

    Caption = 'Paper Master';
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
