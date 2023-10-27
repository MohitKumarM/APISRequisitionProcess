page 50101 "Request To Approve Indent"
{
    PageType = List;
    SourceTable = "Approval Entry Indent";
    UsageCategory = Administration;
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    SourceTableView = sorting("Entry No.") where("Sent for approval" = const(true), "Indent No." = filter(<> ''));
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
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                }
                field("Sender UserID"; Rec."Sender UserID")
                {
                    ApplicationArea = all;
                }
                field("Send DateTime"; Rec."Send DateTime")
                {
                    ApplicationArea = all;
                }
                field("Approver UserID"; Rec."Approver UserID")
                {
                    ApplicationArea = all;
                }
                field("Approval DateTime"; Rec."Approval DateTime")
                {
                    ApplicationArea = all;
                }
                field("Cancel UserID"; Rec."Cancel UserID")
                {
                    ApplicationArea = all;
                }
                field("Cancel DateTime"; Rec."Cancel DateTime")
                {
                    ApplicationArea = all;
                }
                field("Cancel Remarks"; Rec."Cancel Remarks")
                {
                    ApplicationArea = all;
                }
                field("Rejected UserID"; Rec."Rejected UserID")
                {
                    ApplicationArea = all;
                }
                field("Reject Remarks"; Rec."Reject Remarks")
                {
                    ApplicationArea = all;
                }
                field("Rejection DateTime"; Rec."Rejection DateTime")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }

            }


        }


    }

    actions
    {
        area(Processing)
        {
            action("Document")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Document;
                trigger OnAction()
                begin
                    indentHeader.Reset();
                    indentHeader.SetRange("No.", Rec."Indent No.");
                    if indentHeader.FindFirst then
                        Page.RunModal(Page::"Indent Approve/Reject", indentHeader)
                end;

            }

            action("Document History")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = History;
                trigger OnAction()
                begin
                    approvalEntryIndent.Reset();
                    approvalEntryIndent.SetRange("Indent No.", Rec."Indent No.");
                    if approvalEntryIndent.FindFirst then
                        Page.RunModal(Page::"Approval History Indent", approvalEntryIndent)
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.FILTERGROUP(2);

        rec.SETRANGE("Approver UserID", UserId);
        rec.FILTERGROUP(0);


    end;

    var
        indentHeader: Record "Pre Indent Header";
        approvalEntryIndent: Record "Approval Entry Indent";
        usersetup: Record "User Setup";
}
