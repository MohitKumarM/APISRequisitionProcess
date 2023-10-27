tableextension 50100 "PurchaseLineExt" extends "Purchase Line"
{
    fields
    {
        field(79901; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(79902; "Indent Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(79903; "Shortcut Dimension 4 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), blocked = const(false));
        }
        field(50051; "Quote Comparison Entry No."; Integer)
        {
            DataClassification = CustomerContent;

        }

    }

    trigger
    OnDelete()
    begin
        PostedIndentLine.Reset();
        PostedIndentLine.SetRange("PO No", Rec."Document No.");
        PostedIndentLine.setrange("PO Line No", Rec."Line No.");
        if PostedIndentLine.FindSet() then
            repeat
                PostedIndentLine."Purchase Created" := false;
                PostedIndentLine."PO No" := '';
                PostedIndentLine."PO Line No" := 0;
                PostedIndentLine.Modify;
            until PostedIndentLine.Next = 0;
    end;


    var
        PostedIndentLine: Record "Posted Indent Line";
        rep: Report "Calculate Depreciation";
}