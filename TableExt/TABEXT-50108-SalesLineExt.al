tableextension 50108 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50101; "Customer Type"; Option)
        {
            OptionMembers = B2B,B2C;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Customer Type" where("No." = field("Sell-to Customer No.")));
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}