table 50102 "Posted Indent Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "No. Series"; code[10])
        {

        }
        Field(3; "Posting Date"; Date)
        {

        }
        field(4; "Document Date"; Date)
        {

        }
        field(5; "Required Date"; date)
        {

        }
        field(6; "User ID"; code[50])
        {

        }
        field(7; Remarks; text[50])
        {

        }
        field(8; "Shortcut Dimension 1 Code"; code[10])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(False));
        }
        field(9; "Shortcut Dimension 2 Code"; code[10])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), blocked = const(false));
        }
        field(10; Status; Option)
        {
            OptionMembers = Open,"Sent for approval",Cancel,Approved,Closed;
        }
        field(11; "Gen. Journal Template Code"; Code[10])
        {
            Caption = 'Gen. Journal Template Code';
            DataClassification = ToBeClassified;
        }
        field(12; "Location Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(13; "Indent Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Budgeted,"Non-Budgeted";
        }
        field(14; "Indent Remarks"; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Shortcut Dimension 4 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), blocked = const(false));
            Caption = 'Department No.';
        }
    }

    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    var
        PostedIndentLine_Loc: Record "Posted Indent Line";
    begin
        PostedIndentLine_Loc.Reset();
        PostedIndentLine_Loc.SetRange("Indent No.", Rec."No.");
        IF PostedIndentLine_Loc.FindSet() then begin
            PostedIndentLine_Loc.ModifyAll(Status, Rec.Status);
        end;
    end;

}