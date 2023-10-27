tableextension 50105 "Purch. Rcpt. Line Ext." extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50051; "Quote Comparison Entry No."; Integer)
        {
            DataClassification = CustomerContent;

        }

    }

    var
        myInt: Integer;
}