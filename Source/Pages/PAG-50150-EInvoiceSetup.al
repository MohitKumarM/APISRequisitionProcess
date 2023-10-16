page 50150 "E-Invoice Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "E-Invoice Set Up";

    layout
    {
        area(Content)
        {
            group("E-Invoice Setup")
            {

                field("Authentication URL"; Rec."Authentication URL")
                {
                    ToolTip = 'Specifies the value of the Authentication URL field.';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.';
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ToolTip = 'Specifies the value of the Client Secret field.';
                }
                field("E-Invoice URl"; Rec."E-Invoice URl")
                {
                    ToolTip = 'Specifies the value of the E-Invoice URl field.';
                }
                field("IP Address"; Rec."IP Address")
                {
                    ToolTip = 'Specifies the value of the IP Address field.';
                }
                field(Primary; Rec.Primary)
                {
                    ToolTip = 'Specifies the value of the Primary field.';
                }
                field("Round GL Account 1"; Rec."Round GL Account 1")
                {
                    ToolTip = 'Specifies the value of the Round GL Account 1 field.';
                }
                field("Round GL Account 2"; Rec."Round GL Account 2")
                {
                    ToolTip = 'Specifies the value of the Round GL Account 2 field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}