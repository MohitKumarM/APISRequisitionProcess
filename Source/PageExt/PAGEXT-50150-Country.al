pageextension 50150 EInvCountry extends "Countries/Regions"
{
    layout
    {
        addafter("EU Country/Region Code")
        {
            field("Country Code for E Invoicing"; Rec."Country Code for E Invoicing")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}