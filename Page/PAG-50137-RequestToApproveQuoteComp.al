page 50137 "Request To Approve Quote Comp"
{
    ApplicationArea = All;
    Caption = 'Request To Approve Quote Comp.';
    PageType = List;
    SourceTable = "Quote Comparison";
    SourceTableView = where(Status = filter("Pending Approval"), Pending = const(true));
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Select to Approve"; Rec."Select to Approve")
                {
                    ToolTip = 'Specifies the value of the Select to Approve field.';
                    trigger OnValidate()
                    var
                    begin
                    end;
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                    Editable = false;
                }
                field("Indent Line No"; Rec."Indent Line No")
                {
                    ToolTip = 'Specifies the value of the Indent Line No field.';
                    Editable = false;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Editable = false;
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = false;
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    Editable = false;
                }
                field("Indent Approved Quantity"; Rec."Indent Approved Quantity")
                {
                    ToolTip = 'Specifies the value of the Indent Approved Quantity field.';
                    Editable = false;
                }

                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                    Editable = false;
                }
                field("Total Indent Qty. Cost"; Rec."Total Indent Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';
                    Editable = false;
                }
                field(Freight; Rec.Freight)
                {
                    ToolTip = 'Specifies the value of the Freight field.';
                    Editable = false;
                }
                field("Delivery Days"; Rec."Delivery Days")
                {
                    ToolTip = 'Specifies the value of the Delivery Days field.';
                    Editable = false;
                }
                field("Payment Term"; Rec."Payment Term")
                {
                    ToolTip = 'Specifies the value of the Payment Term field.';
                    Editable = false;
                }
                field("Priority No."; Rec."Priority No.")
                {
                    ToolTip = 'Specifies the value of the Priority No. field.';
                    Editable = false;
                }
                field("PO Qty."; Rec."PO Qty.")
                {
                    ToolTip = 'Specifies the value of the PO Qty. field.';
                    Editable = false;
                }
                field("Total PO Qty. Cost"; Rec."Total PO Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total PO Qty. Cost field.';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = false;
                }
                field("Sender UserID"; Rec."Sender UserID")
                {
                    ToolTip = 'Specifies the value of the Sender UserID field.';
                    Editable = false;
                }
                field("Send DateTime"; Rec."Send DateTime")
                {
                    ToolTip = 'Specifies the value of the Send DateTime field.';
                    Editable = false;
                }
                field("Sender Remarks"; Rec.Remarks)
                {
                    Editable = false;
                }
                field("Approver/Rejecter Remarks"; Rec."Approver Remarks")
                {
                    ToolTip = 'Specifies the value of the Approver Remarks field.';
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action("Approve")
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
                    usersetup: Record "User Setup";
                    usersetup1: Record "User Setup";
                    //----------------->>
                    EmailObj: Codeunit Email;
                    EmailMsg: Codeunit "Email Message";
                    CCMailIdList: List of [Text];
                    BccMailIdList: List of [Text];
                    BodyTxt: Text;
                    MailUserIdVar: List of [Text];
                    MailSubject: Text;
                    MailUserid: Text;
                    MailComapnyName: Text;
                    CompInfo: Record "Company Information";
                    VarUserSetup: Record "User Setup";
                    UserEmail: Text;
                    VarapproverSetup: Record "User Setup";
                    approveremail: Text;
                    //<<--------------

                    QuoteComparision_Loc: Record "Quote Comparison";
                    QuoteComparision_Loc_1: Record "Quote Comparison";
                    QuoteComparision_Loc_2: Record "Quote Comparison";
                    QuoteComparision_Loc_Temp: Record "Quote Comparison" temporary;

                    PostedIndentLines_Loc: Record "Posted Indent Line";
                begin
                    IF NOT CONFIRM('Do you want to approve selected entries') THEN
                        EXIT;

                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    QuoteComparision_Loc.Reset();
                    QuoteComparision_Loc.SetRange(Status, QuoteComparision_Loc.Status::"Pending Approval");
                    QuoteComparision_Loc.SetRange("Select to Approve", true);
                    QuoteComparision_Loc.SetRange("Approver UserID", UserId);
                    QuoteComparision_Loc.SetRange(Pending, true);
                    IF QuoteComparision_Loc.FindSet() then begin

                        //>>Mail Header
                        Clear(MailUserIdVar);
                        Clear(BccMailIdList);
                        Clear(CCMailIdList);
                        MailUserid := UserId;
                        VarUserSetup.Reset();
                        VarUserSetup.SetRange("User ID", QuoteComparision_Loc."Sender UserID");
                        if VarUserSetup.FindFirst() then begin
                            approveremail := VarUserSetup."E-Mail";
                            MailUserIdVar.Add(approveremail);
                        end;

                        VarUserSetup.TestField("Quote Comp. Approver ID");
                        VarapproverSetup.Reset();
                        VarapproverSetup.SetRange("User ID", UserId);
                        if VarapproverSetup.FindFirst() then begin
                            UserEmail := VarapproverSetup."E-Mail";
                            MailUserIdVar.Add(approveremail);
                        end;

                        MailComapnyName := CompanyName;
                        MailSubject := 'Approved entries of Quote Comparision of date ' + Format(Today()) + ' ' + CompanyName;

                        BodyTxt := 'Dear Sir/Madam,';
                        BodyTxt += '<br></br>';
                        BodyTxt := 'Please find the below Approved entries of Quote Comparision:';
                        BodyTxt += '<br></br>';
                        BodyTxt += '<TABLE border = "2">';
                        BodyTxt += '<TH>Indent No.</TH>';
                        BodyTxt += '<TH>Indent Line No.</TH>';
                        BodyTxt += '<TH>Type</TH>';
                        BodyTxt += '<TH>Description</TH>';
                        BodyTxt += '<TH>Vendor Name</TH>';
                        BodyTxt += '<TH>Quantity</TH>';
                        BodyTxt += '<TH>Unit Cost</TH>';
                        BodyTxt += '<TH>Actual PO Qty.</TH>';
                        BodyTxt += '<TH>Actual PO Cost</TH>';
                        BodyTxt += '<TH>Entry No.</TH>';
                        BodyTxt += '<TH>Priority</TH>';
                        BodyTxt += '<TH>Status</TH>';
                        BodyTxt += '<TH>Remarks</TH>';
                        BodyTxt += '</TR>';
                        //<<Mail Header

                        repeat
                            ApprovalEntryIndent.Init;
                            EntryNo += 1;
                            ApprovalEntryIndent."Entry No." := EntryNo;
                            ApprovalEntryIndent."Quote Comparison Entry No." := QuoteComparision_Loc."Entry No.";
                            ApprovalEntryIndent."Approver UserID" := UserId;
                            ApprovalEntryIndent."Approval DateTime" := CurrentDateTime;
                            ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Approved;
                            ApprovalEntryIndent."Sent for approval" := false;
                            ApprovalEntryIndent.Insert;

                            QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Approved;
                            QuoteComparision_Loc.Pending := false;
                            QuoteComparision_Loc."Select to Approve" := false;
                            QuoteComparision_Loc.Modify();

                            //>Mail Body
                            BodyTxt += '<TR>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Indent No.") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Indent Line No") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc.Type) + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc.Description) + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Vendor Name") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Indent Approved Quantity") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Unit Cost") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."PO Qty.") + '</TD>';
                            BodyTxt += '<TD>' + format(Round(QuoteComparision_Loc."Total PO Qty. Cost", 0.01, '=')) + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Entry No.") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Priority No.") + '</TD>';
                            BodyTxt += '<TD>' + format(QuoteComparision_Loc.Status) + '</TD>';
                            BodyTxt += '<TD>' + QuoteComparision_Loc."Approver Remarks" + '</TD>';
                            BodyTxt += '</TR>';
                        //<<Mail Body                           

                        until QuoteComparision_Loc.Next() = 0;

                        //>>Mail Footer
                        BodyTxt += '</table>';
                        BodyTxt += '<br></br>';
                        BodyTxt += 'Regards';
                        BodyTxt += '<br></br>';
                        BodyTxt += MailUserid;
                        BodyTxt += '<br></br>';
                        CompInfo.get();
                        BodyTxt += CompInfo.Name;

                        EmailMsg.Create(MailUserIdVar, MailSubject, BodyTxt, true, CCMailIdList, BccMailIdList);
                        EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
                        //<<Mail Footer
                    end;
                    CurrPage.Update();
                end;

            }
            action("Reject")
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
                    usersetup: Record "User Setup";
                    usersetup1: Record "User Setup";
                    //----------------->>
                    EmailObj: Codeunit Email;
                    EmailMsg: Codeunit "Email Message";
                    CCMailIdList: List of [Text];
                    BccMailIdList: List of [Text];
                    BodyTxt: Text;
                    MailUserIdVar: List of [Text];
                    MailSubject: Text;
                    MailUserid: Text;
                    MailComapnyName: Text;
                    CompInfo: Record "Company Information";
                    VarUserSetup: Record "User Setup";
                    UserEmail: Text;
                    VarapproverSetup: Record "User Setup";
                    approveremail: Text;
                    //<<--------------

                    QuoteComparision_Loc: Record "Quote Comparison";
                    QuoteComparision_Loc_1: Record "Quote Comparison";
                    QuoteComparision_Loc_Temp: Record "Quote Comparison" temporary;

                    PostedIndentLines_Loc: Record "Posted Indent Line";
                begin
                    IF NOT CONFIRM('Do you want to reject selected entries') THEN
                        EXIT;

                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    QuoteComparision_Loc.Reset();
                    QuoteComparision_Loc.SetRange(Status, QuoteComparision_Loc.Status::"Pending Approval");
                    QuoteComparision_Loc.SetRange("Select to Approve", true);
                    QuoteComparision_Loc.SetRange("Approver UserID", UserId);
                    QuoteComparision_Loc.SetRange(Pending, true);
                    IF QuoteComparision_Loc.FindSet() then begin
                        repeat
                            IF (QuoteComparision_Loc."Approver Remarks" = '') then
                                Error(StrSubstNo('Approver/Rejecter Remarks must be filled in every line'));
                        until QuoteComparision_Loc.Next() = 0;
                    end;

                    QuoteComparision_Loc.Reset();
                    QuoteComparision_Loc.SetRange(Status, QuoteComparision_Loc.Status::"Pending Approval");
                    QuoteComparision_Loc.SetRange("Select to Approve", true);
                    QuoteComparision_Loc.SetRange("Approver UserID", UserId);
                    QuoteComparision_Loc.SetRange(Pending, true);
                    IF QuoteComparision_Loc.FindSet() then begin
                        //>>Mail Header
                        Clear(MailUserIdVar);
                        Clear(BccMailIdList);
                        Clear(CCMailIdList);

                        MailUserid := UserId;
                        VarUserSetup.Reset();
                        VarUserSetup.SetRange("User ID", QuoteComparision_Loc."Sender UserID");
                        if VarUserSetup.FindFirst() then begin
                            approveremail := VarUserSetup."E-Mail";
                            MailUserIdVar.Add(approveremail);
                        end;

                        VarUserSetup.TestField("Quote Comp. Approver ID");
                        VarapproverSetup.Reset();
                        VarapproverSetup.SetRange("User ID", UserId);
                        if VarapproverSetup.FindFirst() then begin
                            UserEmail := VarapproverSetup."E-Mail";
                            MailUserIdVar.Add(approveremail);
                        end;

                        MailComapnyName := CompanyName;
                        MailSubject := 'Rejected entries of Quote Comparision of date ' + Format(Today()) + ' ' + CompanyName;

                        BodyTxt := 'Dear Sir/Madam,';
                        BodyTxt += '<br></br>';
                        BodyTxt := 'Please find the below Rejected entries of Quote Comparision:';
                        BodyTxt += '<br></br>';
                        BodyTxt += '<TABLE border = "2">';
                        BodyTxt += '<TH>Indent No.</TH>';
                        BodyTxt += '<TH>Indent Line No.</TH>';
                        BodyTxt += '<TH>Type</TH>';
                        BodyTxt += '<TH>Description</TH>';
                        BodyTxt += '<TH>Vendor Name</TH>';
                        BodyTxt += '<TH>Quantity</TH>';
                        BodyTxt += '<TH>Unit Cost</TH>';
                        BodyTxt += '<TH>Actual PO Qty.</TH>';
                        BodyTxt += '<TH>Actual PO Cost</TH>';
                        BodyTxt += '<TH>Entry No.</TH>';
                        BodyTxt += '<TH>Priority</TH>';
                        BodyTxt += '<TH>Status</TH>';
                        BodyTxt += '<TH>Remarks</TH>';
                        BodyTxt += '</TR>';
                        //<<Mail Header
                        repeat
                            ApprovalEntryIndent.Init;
                            EntryNo += 1;
                            ApprovalEntryIndent."Entry No." := EntryNo;
                            ApprovalEntryIndent."Quote Comparison Entry No." := QuoteComparision_Loc."Entry No.";
                            ApprovalEntryIndent."Approver UserID" := UserId;
                            ApprovalEntryIndent."Approval DateTime" := CurrentDateTime;
                            ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Rejected;
                            ApprovalEntryIndent."Sent for approval" := false;
                            ApprovalEntryIndent.Insert;


                            QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Rejected;
                            QuoteComparision_Loc.Pending := false;
                            QuoteComparision_Loc."Select to Approve" := false;
                            QuoteComparision_Loc.Modify();

                            //>Mail Body
                            BodyTxt += '<TR>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Indent No.") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Indent Line No") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc.Type) + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc.Description) + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Vendor Name") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Indent Approved Quantity") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Unit Cost") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."PO Qty.") + '</TD>';
                            BodyTxt += '<TD>' + format(Round(QuoteComparision_Loc."Total PO Qty. Cost", 0.01, '=')) + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Entry No.") + '</TD>';
                            BodyTxt += '<TD>' + Format(QuoteComparision_Loc."Priority No.") + '</TD>';
                            BodyTxt += '<TD>' + format(QuoteComparision_Loc.Status) + '</TD>';
                            BodyTxt += '<TD>' + QuoteComparision_Loc."Approver Remarks" + '</TD>';
                            BodyTxt += '</TR>';
                        //<<Mail Body
                        until QuoteComparision_Loc.Next() = 0;
                        //>>Mail Footer
                        BodyTxt += '</table>';
                        BodyTxt += '<br></br>';
                        BodyTxt += 'Regards';
                        BodyTxt += '<br></br>';
                        BodyTxt += MailUserid;
                        BodyTxt += '<br></br>';
                        CompInfo.get();
                        BodyTxt += CompInfo.Name;

                        EmailMsg.Create(MailUserIdVar, MailSubject, BodyTxt, true, CCMailIdList, BccMailIdList);
                        EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
                        //<<Mail Footer
                    end;
                    CurrPage.Update();
                end;
            }
        }
    }



    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Approver UserID", UserId);
        Rec.FilterGroup(0);

    end;
}
