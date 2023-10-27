tableextension 50101 "UsersetupExt" extends "User Setup"
{
    fields
    {
        field(50000; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(79901; "Indent Approval Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50050; "Quote Comp. Approval Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50051; "Quote Comp. Approver ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
        }

    }
}