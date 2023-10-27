page 50107 "Indent List"
{
    PageType = List;
    SourceTable = "Pre Indent Header";
    UsageCategory = Administration;
    ApplicationArea = all;
    CardPageId = "Indent Document";

    SourceTableView = sorting("No.") where(Status = filter(Open | "Sent for approval"));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                    Editable = false;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }

        }

    }
    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Enabled = rec."No." <> '';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
        }
    }
    trigger OnOpenPage()


    begin
        usersetup.Get(UserId);
        IF usersetup."Department Code" <> '' THEN BEGIN
            rec.FILTERGROUP(2);
            rec.SETRANGE("Shortcut Dimension 4 Code", usersetup."Department Code");
            rec.FILTERGROUP(0);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if usersetup.Get(UserId) then
            Rec."Shortcut Dimension 4 Code" := usersetup."Department Code";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if usersetup.Get(UserId) then
            Rec."Shortcut Dimension 4 Code" := usersetup."Department Code";
    end;


    var
        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        usersetup: Record "User Setup";
        UserMgt: Codeunit "User Management";


}