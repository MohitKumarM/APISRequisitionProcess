tableextension 50104 "Purch. Inv. Line. Extens." extends "Purch. Inv. Line"
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