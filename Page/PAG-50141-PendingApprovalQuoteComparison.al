page 50141 "Pending Appr. Quote Comparison"
{
    ApplicationArea = All;
    Caption = 'Pending Approval Quote Comparison';
    PageType = List;
    SourceTable = "Quote Comparison";
    SourceTableView = where(Status = filter("Not Qualified" | "Pending Approval"), Pending = Const(true));
    UsageCategory = History;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                Field(Select; Rec.Select)
                {

                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                }
                field("Indent Line No"; Rec."Indent Line No")
                {
                    ToolTip = 'Specifies the value of the Indent Line No field.';
                }
                field("Indent Approved Quantity"; Rec."Indent Approved Quantity")
                {
                    ToolTip = 'Specifies the value of the Indent Approved Quantity field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Total Indent Qty. Cost"; Rec."Total Indent Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field("Substrate Code"; Rec."Substrate Code")
                {
                    ToolTip = 'Specifies the value of the Substrate Code field.';
                }
                field("Substrate Type"; Rec."Substrate Type")
                {
                    ToolTip = 'Specifies the value of the Substrate Type field.';
                }
                field(Length; Rec.Length)
                {
                    ToolTip = 'Specifies the value of the Length field.';
                }
                field(Width; Rec.Width)
                {
                    ToolTip = 'Specifies the value of the Width field.';
                }
                field("Area (Sq Mtr)"; Rec."Area (Sq Mtr)")
                {
                    ToolTip = 'Specifies the value of the Area (Sq Mtr) field.';
                }
                field(Freight; Rec.Freight)
                {
                    ToolTip = 'Specifies the value of the Freight field.';
                }
                field("Delivery Days"; Rec."Delivery Days")
                {
                    ToolTip = 'Specifies the value of the Delivery Days field.';
                }
                field("Payment Term"; Rec."Payment Term")
                {
                    ToolTip = 'Specifies the value of the Payment Term field.';
                }
                field("Priority No."; Rec."Priority No.")
                {
                    ToolTip = 'Specifies the value of the Priority No. field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("PO Qty."; Rec."PO Qty.")
                {
                    ToolTip = 'Specifies the value of the PO Qty. field.';
                }
                field("Total PO Qty. Cost"; Rec."Total PO Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total PO Qty. Cost field.';
                }
                field("Outstanding Qty."; Rec."Outstanding Qty.")
                {
                    ToolTip = 'Specifies the value of the OutStanding Qty. field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Approver Remarks"; Rec."Approver Remarks")
                {
                    ToolTip = 'Specifies the value of the Approver Remarks field.';
                }
                field("Sender UserID"; Rec."Sender UserID")
                {
                    ToolTip = 'Specifies the value of the Sender UserID field.';
                }
                field("Send DateTime"; Rec."Send DateTime")
                {
                    ToolTip = 'Specifies the value of the Send DateTime field.';
                }
                field("Approver UserID"; Rec."Approver UserID")
                {
                    ToolTip = 'Specifies the value of the Approver UserID field.';
                }

            }
        }
    }


    Actions
    {
        Area(Processing)
        {
            action("Cancel Approval")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    EntryNo: Integer;
                    AppEntryIndentEntryno: Record "Approval Entry Indent";
                    ApprovalEntryIndent: Record "Approval Entry Indent";
                    QuoteComparision_Loc: Record "Quote Comparison";
                    IndentHeader_Temp: Record "Posted Indent Header" temporary;
                begin
                    IF Not Confirm('Do you want to cancel Pending Approval Lines') then
                        exit;

                    IF IndentHeader_Temp.IsTemporary then
                        IndentHeader_Temp.DeleteAll();

                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    QuoteComparision_Loc.Reset();
                    QuoteComparision_Loc.SetRange(Status, QuoteComparision_Loc.Status::"Pending Approval");
                    QuoteComparision_Loc.SetRange(Pending, true);
                    IF QuoteComparision_Loc.FindSet() then begin
                        repeat
                            IF (QuoteComparision_Loc."Indent No." <> '') then begin
                                IF not IndentHeader_Temp.Get(QuoteComparision_Loc."Indent No.") then begin
                                    IndentHeader_Temp.Init();
                                    IndentHeader_Temp."No." := QuoteComparision_Loc."Indent No.";
                                    IndentHeader_Temp.Insert();
                                end;
                            end else begin
                                IF not IndentHeader_Temp.Get('Blank') then begin
                                    IndentHeader_Temp.Init();
                                    IndentHeader_Temp."No." := 'Blank';
                                    IndentHeader_Temp.Insert();
                                end;
                            end;
                        until QuoteComparision_Loc.Next() = 0;
                    end else
                        Error('There are no lines selected');

                    Clear(QuoteComparision_Loc);
                    IndentHeader_Temp.Reset();
                    IF IndentHeader_Temp.FindSet() then begin
                        repeat
                            IF IndentHeader_Temp."No." = 'Blank' then begin
                                QuoteComparision_Loc.Reset();
                                QuoteComparision_Loc.SetFilter(Status, '%1|%2', QuoteComparision_Loc.Status::"Not Qualified", QuoteComparision_Loc.Status::"Pending Approval");
                                QuoteComparision_Loc.SetRange("Indent No.", 'Blank');
                                QuoteComparision_Loc.SetRange(Pending, true);
                                IF QuoteComparision_Loc.FindSet() then begin
                                    repeat
                                        IF QuoteComparision_Loc.Status = QuoteComparision_Loc.Status::"Pending Approval" then begin
                                            AppEntryIndentEntryno.Reset();
                                            AppEntryIndentEntryno.SetRange("Quote Comparison Entry No.", Rec."Entry No.");
                                            AppEntryIndentEntryno.SetRange("Sent for approval", true);
                                            if AppEntryIndentEntryno.Findfirst then
                                                repeat
                                                    AppEntryIndentEntryno."Sent for approval" := false;
                                                    AppEntryIndentEntryno.Modify;
                                                until AppEntryIndentEntryno.Next = 0;

                                            ApprovalEntryIndent.Init;
                                            EntryNo += 1;
                                            ApprovalEntryIndent."Entry No." := EntryNo;
                                            ApprovalEntryIndent."Quote Comparison Entry No." := Rec."Entry No.";
                                            ApprovalEntryIndent."Cancel UserID" := UserId;
                                            ApprovalEntryIndent."Cancel DateTime" := CurrentDateTime;
                                            ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Cancel;
                                            ApprovalEntryIndent."Sent for approval" := false;
                                            ApprovalEntryIndent.Insert;

                                        end;
                                        QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                        QuoteComparision_Loc.Pending := false;
                                        QuoteComparision_Loc.Modify();
                                    until QuoteComparision_Loc.Next() = 0;
                                end;

                            end else begin
                                QuoteComparision_Loc.Reset();
                                QuoteComparision_Loc.SetFilter(Status, '%1|%2', QuoteComparision_Loc.Status::"Not Qualified", QuoteComparision_Loc.Status::"Pending Approval");
                                QuoteComparision_Loc.SetRange("Indent No.", IndentHeader_Temp."No.");
                                QuoteComparision_Loc.SetRange(Pending, true);
                                IF QuoteComparision_Loc.FindSet() then begin
                                    repeat
                                        IF QuoteComparision_Loc.Status = QuoteComparision_Loc.Status::"Pending Approval" then begin
                                            AppEntryIndentEntryno.Reset();
                                            AppEntryIndentEntryno.SetRange("Quote Comparison Entry No.", Rec."Entry No.");
                                            AppEntryIndentEntryno.SetRange("Sent for approval", true);
                                            if AppEntryIndentEntryno.Findfirst then
                                                repeat
                                                    AppEntryIndentEntryno."Sent for approval" := false;
                                                    AppEntryIndentEntryno.Modify;
                                                until AppEntryIndentEntryno.Next = 0;

                                            ApprovalEntryIndent.Init;
                                            EntryNo += 1;
                                            ApprovalEntryIndent."Entry No." := EntryNo;
                                            ApprovalEntryIndent."Quote Comparison Entry No." := Rec."Entry No.";
                                            ApprovalEntryIndent."Cancel UserID" := UserId;
                                            ApprovalEntryIndent."Cancel DateTime" := CurrentDateTime;
                                            ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Cancel;
                                            ApprovalEntryIndent."Sent for approval" := false;
                                            ApprovalEntryIndent.Insert;

                                        end;
                                        QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                        QuoteComparision_Loc.Pending := false;
                                        QuoteComparision_Loc.Modify();
                                    until QuoteComparision_Loc.Next() = 0;
                                end;

                            end;
                        until IndentHeader_Temp.Next() = 0;
                        Message('Lines has been  cancelled for approval and reopened');
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }

}
