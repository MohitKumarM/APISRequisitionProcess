page 50100 "Approval History Indent"
{
    PageType = List;
    SourceTable = "Approval Entry Indent";
    Editable = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Sent for approval"; Rec."Sent for approval")
                {
                    ApplicationArea = all;
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }

                field("Sender UserID"; Rec."Sender UserID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Approver UserID"; Rec."Approver UserID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Approval DateTime"; Rec."Approval DateTime")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Rejected UserID"; Rec."Rejected UserID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Rejected UserID field.';
                }

                field("Rejection DateTime"; Rec."Rejection DateTime")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field("Cancel UserID"; Rec."Cancel UserID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cancel UserID field.';
                }
                field("Cancel DateTime"; Rec."Cancel DateTime")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cancel DateTime field.';
                }
                field("Cancel Remarks"; Rec."Cancel Remarks")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cancel Remarks field.';
                }
                field("Reject Remarks"; Rec."Reject Remarks")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reject Remarks field.';
                }
            }
        }
    }
}