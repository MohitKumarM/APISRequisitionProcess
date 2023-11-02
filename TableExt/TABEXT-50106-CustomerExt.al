tableextension 50106 CustomerExtension extends Customer
{
    fields
    {
        field(50101; "Customer Type"; Option)
        {
            OptionMembers = B2B,B2C;
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