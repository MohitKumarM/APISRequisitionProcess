tableextension 50107 LocationExtension extends Location
{
    fields
    {
        field(50101; "Production Unit"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Reject Unit"; Boolean)
        {
            DataClassification = ToBeClassified;
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