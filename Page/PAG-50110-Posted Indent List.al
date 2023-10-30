page 50110 "Posted Indent List"
{
    PageType = List;
    SourceTable = "Posted Indent Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    CardPageId = "Posted Indent Document";
    SourceTableView = sorting("No.") where(Status = filter(Approved | Closed));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        // usersetup.Get(UserId);
        // IF usersetup."Department Code" <> '' THEN BEGIN
        //     rec.FILTERGROUP(2);
        //     rec.SETRANGE("Shortcut Dimension 4 Code", usersetup."Department Code");
        //     rec.FILTERGROUP(0);
        // END;

    end;

    var
        usersetup: Record "User Setup";

}