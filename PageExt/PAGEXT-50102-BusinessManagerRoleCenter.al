pageextension 50102 BusinessManagerRoleCenter extends "Business Manager Role Center"
{
    actions
    {
        addafter(Action40)
        {
            group(Action100000000)
            {
                Caption = 'Indent Process';
                action("Indent List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Indent List";

                }
                action("Request to approve Indent list")
                {
                    ApplicationArea = All;
                    RunObject = Page "Request To Approve Indent";

                }
                action("Posted Indent List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Posted Indent List";
                }

            }
        }
    }
}
