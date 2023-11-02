tableextension 50155 EInvSalesInvoiceHeader extends "Sales Invoice Header"
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
        field(50152; "E-Way Bill Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50153; "E-Way Bill Cancel DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }
}