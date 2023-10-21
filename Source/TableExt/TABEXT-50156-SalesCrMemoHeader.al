tableextension 50156 EInvSalesCrMemoHeader extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50150; "Cancel Remarks"; Enum "Cancel Remarks")
        {
            DataClassification = ToBeClassified;
        }
        field(50151; "Irn Cancel DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50152; "LR/RR No."; code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50153; "LR/RR Date"; Date)
        {
            DataClassification = EndUserIdentifiableInformation;
        }
    }

    var
        myInt: Integer;
}