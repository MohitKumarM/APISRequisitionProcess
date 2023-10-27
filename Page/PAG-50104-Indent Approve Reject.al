page 50104 "Indent Approve/Reject"
{
    PageType = Document;
    SourceTable = "Pre Indent Header";
    DeleteAllowed = false;
    InsertAllowed = false;

    SourceTableView = sorting("No.") where(Status = filter("Sent for approval"));
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
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = all;

                }
                field("Required Date"; Rec."Required Date")
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part("Indent Subfrom"; "Indent Subform Approve")
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
            action("Approve")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Approve;
                trigger OnAction()
                begin

                    IndentLine.Reset();
                    IndentLine.setrange("Indent No.", Rec."No.");
                    if IndentLine.FindSet then
                        repeat
                            IndentLine.TestField("Approved Qty");
                        until IndentLine.Next = 0;

                    IF NOT CONFIRM('Do you want to Approve') THEN
                        EXIT;
                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    ApprovalEntryIndent.Init;
                    ApprovalEntryIndent."Entry No." := EntryNo + 1;
                    ApprovalEntryIndent."Indent No." := Rec."No.";
                    ApprovalEntryIndent."Approver UserID" := UserId;
                    ApprovalEntryIndent."Approval DateTime" := CurrentDateTime;
                    ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Approved;
                    ApprovalEntryIndent."Sent for approval" := false;
                    ApprovalEntryIndent.Insert;

                    PostedHeader.Init();
                    PostedHeader.TransferFields(Rec);
                    PostedHeader.Status := PostedHeader.Status::Approved;
                    PostedHeader.Insert();



                    IndentLine.Reset();
                    IndentLine.SetRange("Indent No.", rec."No.");
                    IndentLine.SetFilter("Approved Qty", '>%1', 0);
                    if IndentLine.FindSet then
                        repeat
                            PostedLine.Init();
                            PostedLine."Indent No." := IndentLine."Indent No.";
                            PostedLine."Line No" := IndentLine."Line No";
                            PostedLine.Type := IndentLine.Type;
                            PostedLine."No." := IndentLine."No.";
                            PostedLine.Description := IndentLine.Description;
                            PostedLine.Quantity := IndentLine.Quantity;
                            PostedLine."Remaining Quantity" := IndentLine."Remaining Quantity";
                            PostedLine."Required Quantity" := IndentLine."Required Quantity";
                            PostedLine."Approved Qty" := IndentLine."Approved Qty";
                            PostedLine.UOM := IndentLine.UOM;
                            PostedLine."HSN/SAC Code" := IndentLine."HSN/SAC Code";
                            PostedLine."Full Description" := IndentLine."Full Description";
                            PostedLine.Amount := IndentLine.Amount;
                            PostedLine."Unit Price" := IndentLine."Unit Price";
                            PostedLine.Reamrk := IndentLine.Reamrk;
                            PostedLine."Shortcut Dimension 1 Code" := IndentLine."Shortcut Dimension 1 Code";
                            PostedLine."Shortcut Dimension 2 Code" := IndentLine."Shortcut Dimension 2 Code";
                            PostedLine."Shortcut Dimension 4 Code" := IndentLine."Shortcut Dimension 4 Code";
                            PostedLine."Dimension Set ID" := IndentLine."Dimension Set ID";
                            PostedLine."PM Item Type" := IndentLine."PM Item Type";
                            PostedLine.Length := IndentLine.Length;
                            PostedLine.Width := IndentLine.Width;
                            PostedLine."Size of Label" := IndentLine."Size of Label";
                            PostedLine."Substrate Type" := IndentLine."Substrate Type";
                            PostedLine.Insert();
                            IndentLine.Delete();
                        until IndentLine.Next = 0;
                    AppEntryIndentEntryno.Reset();
                    AppEntryIndentEntryno.setrange("Indent No.", Rec."No.");
                    if AppEntryIndentEntryno.FindSet then
                        repeat
                            AppEntryIndentEntryno."Sent for approval" := false;
                            AppEntryIndentEntryno.Modify;
                        until AppEntryIndentEntryno.Next = 0;
                    SendMail(rec);

                    rec.Delete();

                end;
            }

            action("Reject")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Reject;
                trigger OnAction()
                begin
                    Rec.testfield("Rejection Remarks");
                    IF NOT CONFIRM('Do you want to Reject') THEN
                        EXIT;
                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    ApprovalEntryIndent.Init;
                    ApprovalEntryIndent."Entry No." := EntryNo + 1;
                    ApprovalEntryIndent."Indent No." := Rec."No.";
                    ApprovalEntryIndent."Rejected UserID" := UserId;
                    ApprovalEntryIndent."Rejection DateTime" := CurrentDateTime;
                    ApprovalEntryIndent."Reject Remarks" := Rec."Rejection Remarks";
                    ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Rejected;
                    ApprovalEntryIndent.Insert;

                    AppEntryIndentEntryno.Reset();
                    AppEntryIndentEntryno.setrange("Indent No.", Rec."No.");
                    if AppEntryIndentEntryno.FindSet then
                        repeat
                            AppEntryIndentEntryno."Sent for approval" := false;
                            AppEntryIndentEntryno.Modify;
                        until AppEntryIndentEntryno.Next = 0;
                    Rec.Status := Rec.Status::Open;

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
                    approvalEntryIndent.SetRange("Indent No.", Rec."No.");
                    if approvalEntryIndent.FindFirst then
                        Page.RunModal(Page::"Approval History Indent", approvalEntryIndent)
                end;

            }



        }




    }


    procedure SendMail(IndentHeader: Record "Pre Indent Header")
    var
        EmailObj: Codeunit Email;
        EmailMsg: Codeunit "Email Message";
        PostIndentLine: Record "Posted Indent Line";
        CCMailIdList: List of [Text];
        BccMailIdList: List of [Text];
        BodyTxt: Text;
        MailUserIdVar: List of [Text];
        MailSubject: Text;
        MailUserid: Text;
        MailComapnyName: Text;
        DimValue: Record "Dimension Value";
        CompInfo: Record "Company Information";
        VarUserSetup: Record "User Setup"; //
        UserEmail: Text;
        VarapproverSetup: Record "User Setup";
        approveremail: Text;
    begin

        Clear(MailUserIdVar);
        Clear(BccMailIdList);
        Clear(CCMailIdList);
        //IndentHeader.Reset;
        // IndentHeader.setrange(Status, IndentHeader.Status::"Sent for approval");
        // if IndentHeader.FindFirst then begin
        // MailUserIdVar.Add('gaurav.pandit@teamcomputers.com');
        // MailUserIdVar.Add('gaurav.pandit@teamcomputers.com');
        MailUserid := UserId;
        VarUserSetup.Reset();
        VarUserSetup.SetRange("User ID", UserId);
        if VarUserSetup.FindFirst() then
            UserEmail := VarUserSetup."E-Mail";


        // VarapproverSetup.Reset();
        // VarapproverSetup.SetRange("Approver ID", VarUserSetup."User ID");
        // if VarapproverSetup.FindFirst() then begin
        //     approveremail := VarapproverSetup."E-Mail";
        MailUserIdVar.Add(UserEmail);
        // end;

        MailComapnyName := CompanyName;
        if DimValue.Get('DEPARTMENT', IndentHeader."Shortcut Dimension 4 Code") then;
        MailSubject := 'Indent Approved No :-' + IndentHeader."No." + ' ' + DimValue.Name + ' ' + CompanyName;


        BodyTxt := 'Dear Sir/Madam,';
        BodyTxt += '<br></br>';
        BodyTxt := 'Please find the approval of Indent raised,';
        BodyTxt += '<br></br>';
        BodyTxt += '<TABLE border = "2">';
        BodyTxt += '<TH>Indent No.</TH>';
        BodyTxt += '<TH>Indent Date</TH>';
        BodyTxt += '<TH>Item No.</TH>';
        BodyTxt += '<TH>Item Description</TH>';
        BodyTxt += '<TH>Full Description</TH>';
        BodyTxt += '<TH>Quantity</TH>';
        BodyTxt += '<TH>UOM</TH>';
        BodyTxt += '<TH>Unit Price</TH>';
        BodyTxt += '<TH>Approved Quantity</TH>';
        BodyTxt += '<TH>Amount</TH>';
        BodyTxt += '<TH>Remarks</TH>';
        BodyTxt += '<TH>Indent Status</TH>';
        BodyTxt += '</TR>';

        PostIndentLine.Reset;
        PostIndentLine.setrange("Indent No.", Rec."No.");
        if PostIndentLine.FindSet then
            repeat
                BodyTxt += '<TR>';
                BodyTxt += '<TD>' + Rec."No." + '</TD>';
                BodyTxt += '<TD>' + Format(Rec."Document Date") + '</TD>';
                BodyTxt += '<TD>' + PostIndentLine."No." + '</TD>';
                BodyTxt += '<TD>' + PostIndentLine.Description + '</TD>';
                BodyTxt += '<TD>' + PostIndentLine."Full Description" + '</TD>';
                BodyTxt += '<TD>' + Format(PostIndentLine.Quantity) + '</TD>';
                BodyTxt += '<TD>' + Format(PostIndentLine.UOM) + '</TD>';
                BodyTxt += '<TD>' + Format(PostIndentLine."Unit Price") + '</TD>';
                BodyTxt += '<TD>' + Format(PostIndentLine."Approved Qty") + '</TD>';
                BodyTxt += '<TD>' + format(PostIndentLine.Amount) + '</TD>';
                BodyTxt += '<TD>' + PostIndentLine.Reamrk + '</TD>';
                BodyTxt += '<TD>' + format(Rec."Indent Status") + '</TD>';
            until PostIndentLine.next = 0;
        BodyTxt += '</TR>';
        BodyTxt += '</table>';
        BodyTxt += '<br></br>';
        BodyTxt += 'Regards';
        BodyTxt += '<br></br>';
        BodyTxt += MailUserid;
        BodyTxt += '<br></br>';
        CompInfo.get();
        BodyTxt += CompInfo.Name;

        //end;
        EmailMsg.Create(MailUserIdVar, MailSubject, BodyTxt, true, CCMailIdList, BccMailIdList);
        EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);

    end;


    var
        ApprovalEntryIndent: Record "Approval Entry Indent";
        PostedHeader: Record "Posted Indent Header";
        PostedLine: Record "Posted Indent Line";
        IndentLine: Record "Pre Indent Line";
        EntryNo: Integer;
        usersetup: Record "User Setup";
        AppEntryIndentEntryno: Record "Approval Entry Indent";


}