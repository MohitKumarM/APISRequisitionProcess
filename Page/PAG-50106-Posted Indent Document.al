page 50106 "Posted Indent Document"
{
    PageType = Document;
    SourceTable = "Posted Indent Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("No.") where(Status = filter(Approved | Closed));
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = all;
                }
                field("Required Date"; Rec."Required Date")
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                    ApplicationArea = all;
                }
                field("Indent Status"; Rec."Indent Status")
                {
                    ApplicationArea = all;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                }
                field("Indent Remarks"; Rec."Indent Remarks")
                {
                    ApplicationArea = all;
                }

            }

            part("Requisition Subfrom"; "Posted Indent Subform")
            {
                SubPageLink = "Indent No." = field("No.");
                ApplicationArea = all;
            }


        }


    }
    actions
    {
        area(Processing)
        {
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
                    approvalEntryIndent.SetRange("Indent No.", Rec."No.");
                    if approvalEntryIndent.FindFirst then
                        Page.RunModal(Page::"Approval History Indent", approvalEntryIndent)
                end;

            }

            action("Indent Report")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Print;
                trigger OnAction()
                var
                    PostedindnetHeader: Record "Posted Indent Header";
                begin
                    PostedindnetHeader.Reset;
                    PostedindnetHeader.setrange("No.", rec."No.");
                    if PostedindnetHeader.FindFirst then
                        Report.RunModal(Report::"Posted Indent Report", true, true, PostedindnetHeader);

                end;
            }

        }

    }
    var
        approvalEntryIndent: Record "Approval Entry Indent";
}