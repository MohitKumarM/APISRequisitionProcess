page 50105 "Indent Document"
{
    PageType = Document;
    SourceTable = "Pre Indent Header";
    //SourceTableView = sorting("No.") where(Status = filter(Open | "Sent for approval"));
    SourceTableView = sorting("No.");
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = PageEditable;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field("Required Date"; Rec."Required Date")
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field("Indent Status"; Rec."Indent Status")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = all;
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ShowCaption = true;
                    Caption = 'Department Code';
                    ShowMandatory = true;
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Remarks"; Rec."Indent Remarks")
                {
                    ApplicationArea = all;
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ApplicationArea = all;
                }


            }
            part("Indent Subfrom"; "Indent Subform")
            {
                SubPageLink = "Indent No." = field("No.");
                ApplicationArea = all;
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
                Visible = PageEditable;
                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
        }
        area(Processing)
        {
            action("Send For Approval")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Visible = PageEditable;
                trigger OnAction()
                var
                    Item_Loc: Record Item;
                begin

                    Rec.testfield("Shortcut Dimension 1 Code");
                    Rec.testfield("Shortcut Dimension 2 Code");
                    Rec.testfield(Status, Rec.Status::Open);
                    Rec.CalcFields(Amount);
                    IndentLine.Reset();
                    IndentLine.setrange("Indent No.", Rec."No.");
                    if IndentLine.FindFirst() then begin
                        IndentLine.TestField(Quantity);

                        IF (IndentLine.Type = IndentLine.Type::Item) and Item_Loc.Get(IndentLine."No.") then begin
                            if (Item_Loc."PM Item Type" <> Item_Loc."PM Item Type"::Blank) then
                                IndentLine.TestField("PM Item Type");

                            if (Item_Loc."PM Item Type" = Item_Loc."PM Item Type"::Label) then begin
                                IndentLine.TestField("PM Item Type", IndentLine."PM Item Type"::Label);
                                IndentLine.TestField(Length);
                                IndentLine.TestField(Width);
                                IndentLine.TestField("Substrate Type");
                            end;
                        end;
                    end;

                    IF NOT CONFIRM('Do you want to send for approval') THEN
                        EXIT;

                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    ApprovalEntryIndent.Init;
                    ApprovalEntryIndent."Entry No." := EntryNo + 1;
                    ApprovalEntryIndent."Indent No." := Rec."No.";
                    ApprovalEntryIndent."Sender UserID" := UserId;
                    usersetup.Get(UserId);
                    usersetup.TestField("Approver ID");
                    if usersetup1.get(usersetup."Approver ID") then begin
                        if rec.Amount <= usersetup1."Indent Approval Limit" then
                            ApprovalEntryIndent."Approver UserID" := usersetup1."User ID"
                        else
                            ApprovalEntryIndent."Approver UserID" := usersetup1."Approver ID";
                    end;


                    ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::"Sent for approval";
                    ApprovalEntryIndent."Sent for approval" := true;
                    ApprovalEntryIndent."Send DateTime" := CurrentDateTime;
                    ApprovalEntryIndent.Insert;
                    SendMail(Rec);
                    Rec.Status := Rec.Status::"Sent for approval";
                end;
            }

            action("Cancel Approval")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Visible = PageEditable;
                trigger OnAction()
                begin
                    Rec.testfield("Rejection Remarks");
                    IF NOT CONFIRM('Do you want to Cancel') THEN
                        EXIT;

                    Clear(EntryNo);
                    if AppEntryIndentEntryno.FindLast then
                        EntryNo := AppEntryIndentEntryno."Entry No.";

                    ApprovalEntryIndent.Init;
                    ApprovalEntryIndent."Entry No." := EntryNo + 1;
                    ApprovalEntryIndent."Indent No." := Rec."No.";
                    ApprovalEntryIndent."Cancel UserID" := UserId;
                    ApprovalEntryIndent."Cancel DateTime" := CurrentDateTime;
                    ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::Cancel;
                    ApprovalEntryIndent."Sent for approval" := false;
                    ApprovalEntryIndent.Insert;

                    AppEntryIndentEntryno.Reset();
                    AppEntryIndentEntryno.setrange("Indent No.", Rec."No.");
                    if AppEntryIndentEntryno.FindSet then
                        repeat
                            AppEntryIndentEntryno."Sent for approval" := false;
                            AppEntryIndentEntryno.Modify;
                        until AppEntryIndentEntryno.Next = 0;
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                end;
            }
            action("Cancel Indent")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Visible = PageEditable;
                trigger OnAction()
                var
                    PreIndentHeader_Loc: Record "Pre Indent Header";
                begin
                    Rec.testfield("Rejection Remarks");
                    IF NOT CONFIRM('Do you want to Cancel') THEN
                        EXIT;

                    IF PreIndentHeader_Loc.Get(Rec."No.") then begin
                        PreIndentHeader_Loc.Status := PreIndentHeader_Loc.Status::Cancel;
                        PreIndentHeader_Loc.Modify(true);
                        CurrPage.Update();
                    end;
                end;
            }

            action("Document History")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = History;
                Visible = PageEditable;
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
                Visible = PageEditable;
                trigger OnAction()
                var
                    indnetHeader: Record "Pre Indent Header";
                begin
                    indnetHeader.Reset;
                    indnetHeader.setrange("No.", rec."No.");
                    if indnetHeader.FindFirst then
                        Report.RunModal(Report::"Indent Report New", true, true, indnetHeader);
                end;
            }
        }
    }

    procedure SendMail(IndentHeader: Record "Pre Indent Header")
    var
        EmailObj: Codeunit Email;
        EmailMsg: Codeunit "Email Message";
        PreIndentLine: Record "Pre Indent Line";
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
        // IndentHeader.Reset;
        // IndentHeader.setrange(Status, IndentHeader.Status::Open);
        // if IndentHeader.FindFirst then begin
        if DimValue.Get('DEPARTMENT', IndentHeader."Shortcut Dimension 4 Code") then;
        // MailUserIdVar.Add('kailash.singh@teamcomputers.com');  //Commented
        // MailUserIdVar.Add('dipti.bisht@teamcomputers.com');
        // CCMailIdList.Add('gaurav.pandit@teamcomputers.com');
        // CCMailIdList.Add('gauravims8@gmail.com'); // Change it to approver ID.
        //BccMailIdList.Add('mohit.kumar@teamcomputers.com');
        MailUserid := UserId;
        VarUserSetup.Reset();
        VarUserSetup.SetRange("User ID", UserId);
        if VarUserSetup.FindFirst() then
            UserEmail := VarUserSetup."E-Mail";


        VarapproverSetup.Reset();
        VarapproverSetup.SetRange("User ID", VarUserSetup."Approver ID");
        //VarapproverSetup.SetRange("Approver ID", VarUserSetup."User ID");
        if VarapproverSetup.FindFirst() then begin
            approveremail := VarapproverSetup."E-Mail";
            MailUserIdVar.Add(approveremail);
        end;


        MailComapnyName := CompanyName;
        MailSubject := 'Indent No :- ' + IndentHeader."No." + ' ' + DimValue.Name + ' ' + CompanyName;


        BodyTxt := 'Dear Sir/Madam,';
        BodyTxt += '<br></br>';
        BodyTxt := 'Please find the below Indent for approval:';
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
        BodyTxt += '<TH>Amount</TH>';
        BodyTxt += '<TH>Remarks</TH>';
        BodyTxt += '<TH>Indent Status</TH>';
        BodyTxt += '</TR>';

        PreIndentLine.Reset;
        PreIndentLine.setrange("Indent No.", Rec."No.");
        if PreIndentLine.FindSet then
            repeat
                BodyTxt += '<TR>';
                BodyTxt += '<TD>' + Rec."No." + '</TD>';
                BodyTxt += '<TD>' + Format(Rec."Document Date") + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine."No." + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine.Description + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine."Full Description" + '</TD>';
                BodyTxt += '<TD>' + Format(PreIndentLine.Quantity) + '</TD>';
                BodyTxt += '<TD>' + Format(PreIndentLine.UOM) + '</TD>';
                BodyTxt += '<TD>' + Format(PreIndentLine."Unit Price") + '</TD>';
                BodyTxt += '<TD>' + format(PreIndentLine.Amount) + '</TD>';
                BodyTxt += '<TD>' + PreIndentLine.Reamrk + '</TD>';
                BodyTxt += '<TD>' + format(Rec."Indent Status") + '</TD>';


            until PreIndentLine.next = 0;
        BodyTxt += '</TR>';
        BodyTxt += '</table>';
        BodyTxt += '<br></br>';
        BodyTxt += 'Regards';
        BodyTxt += '<br></br>';
        BodyTxt += MailUserid;
        BodyTxt += '<br></br>';
        CompInfo.get();
        BodyTxt += CompInfo.Name;

        // end;
        EmailMsg.Create(MailUserIdVar, MailSubject, BodyTxt, true, CCMailIdList, BccMailIdList); //Here Receiver mail id specified
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




    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // TemplateIndent.TemplateSelectionForIndent(79902, Rec, JnlSelected, GenJnlTemplateCode);
        // IF NOT JnlSelected THEN
        //     ERROR('');
        // rec."Gen. Journal Template Code" := GenJnlTemplateCode;
        if usersetup.Get(UserId) then
            Rec."Shortcut Dimension 4 Code" := usersetup."Department Code";  //Gaurav
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if usersetup.Get(UserId) then
            Rec."Shortcut Dimension 4 Code" := usersetup."Department Code";
    end;

    trigger OnOpenPage()
    begin
        PageEditableFunction();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        PageEditableFunction();
    end;

    trigger OnAfterGetRecord()
    begin
        PageEditableFunction();
    end;

    procedure PageEditableFunction()
    begin
        IF (Rec.Status <> Rec.Status::Cancel) then
            PageEditable := true
        else
            PageEditable := false;
    end;

    var

        JnlSelected: Boolean;
        GenJnlTemplateCode: Code[10];
        usersetup1: Record "User Setup";
        PageEditable: Boolean;

}