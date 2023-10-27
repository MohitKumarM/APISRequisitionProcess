tableextension 50102 PurchasePayableSetup extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50051; "Carton No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50052; "Pouch No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

    }

    var
        myInt: Integer;
}