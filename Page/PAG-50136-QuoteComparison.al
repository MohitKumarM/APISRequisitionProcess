page 50136 "PAG-50136-QuoteComparison"
{
    ApplicationArea = All;
    Caption = 'Quote Comparison';
    PageType = List;
    SourceTable = "Quote Comparison";
    SourceTableView = where(Status = filter(Open | "Pending Approval" | Rejected));
    UsageCategory = Lists;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Select; Rec.Select)
                {
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Editable = IndenteditableBool;
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                    Editable = IndenteditableBool;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';
                    Editable = IndenteditableBool;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Priority No."; Rec."Priority No.")
                {
                    ToolTip = 'Specifies the value of the Priority No. field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = IndenteditableBool;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                    trigger OnValidate()
                    begin
                        Rec."Total Indent Qty. Cost" := Rec."Unit Cost" * Rec."Indent Approved Quantity";
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
                field("Substrate Code"; Rec."Substrate Code")
                {
                    Editable = IndenteditableBool;
                }
                field("Substrate Type"; Rec."Substrate Type")
                {
                    Editable = IndenteditableBool;
                }
                field(Length; Rec.Length)
                {
                    Editable = IndenteditableBool;
                }
                field(Width; Rec.Width)
                {
                    Editable = IndenteditableBool;
                }
                field("Area (Sq Mtr)"; Rec."Area (Sq Mtr)")
                {
                    Editable = IndenteditableBool;
                }
                field("Indent Approved Quantity"; Rec."Indent Approved Quantity")
                {
                    Editable = IndenteditableBool;
                    ToolTip = 'Specifies the value of the Indent Approved Quantity field.';
                    trigger OnValidate()
                    begin
                        Rec."Total Indent Qty. Cost" := Rec."Unit Cost" * Rec."Indent Approved Quantity";
                    end;
                }

                field("Total Indent Qty. Cost"; Rec."Total Indent Qty. Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';
                    Editable = false;
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

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = false;
                }
                field("PO Qty."; Rec."PO Qty.")
                {
                    ToolTip = 'Specifies the value of the PO Qty. field.';
                    Editable = POEditable;
                    trigger OnValidate()
                    var
                        QuoteComparision_Loc: Record "Quote Comparison";
                        TotalPOQty: Decimal;
                    begin
                        Clear(TotalPOQty);
                        QuoteComparision_Loc.Reset();
                        QuoteComparision_Loc.SetRange("Indent No.", Rec."Indent No.");
                        QuoteComparision_Loc.SetRange("Indent Line No", Rec."Indent Line No");
                        IF QuoteComparision_Loc.FindSet() then begin
                            repeat
                                TotalPOQty += QuoteComparision_Loc."PO Qty.";
                            until QuoteComparision_Loc.Next() = 0;

                            IF ((Rec."Indent Approved Quantity" - TotalPOQty - Rec."PO Qty.")) < 0 then
                                Error(StrSubstNo('PO Qty must be less than or equal to %1', Rec."Indent Approved Quantity" - TotalPOQty));
                            Rec."Outstanding Qty." := Rec."Indent Approved Quantity" - TotalPOQty - Rec."PO Qty.";
                        end;
                        Rec."Total PO Qty. Cost" := Rec."Unit Cost" * Rec."PO Qty.";
                        Rec.Modify();
                    end;
                }
                field("Total PO Qty. Cost"; Rec."Total PO Qty. Cost")
                {
                    Editable = false;
                }
                field("OutStanding Qty."; Rec."OutStanding Qty.")
                {
                    ToolTip = 'Specifies the value of the OutStanding Qty. field.';
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Approver Remarks"; Rec."Approver Remarks")
                {
                    ToolTip = 'Specifies the value of the Approver Remarks field.';
                    Editable = false;
                }


            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Re_Open)
            {
                action("ReOpen")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ReOpen';
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Image = Statistics;

                    trigger OnAction()
                    var
                    begin
                        Rec.SetRange(Select, true);
                        Rec.SetRange(Status, Rec.Status::Rejected);
                        IF Rec.FindSet() then begin
                            repeat
                                Rec.Status := Rec.Status::Open;
                                Rec.Select := false;
                                Rec.Modify();
                            until Rec.Next() = 0;
                            Message('Rejected entries has been ReOpened');
                            Rec.Reset();
                            Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                            CurrPage.Update(true);
                        end else
                            Message('Lines should be selected and status must be rejected to Reopen');
                    end;
                }

                // action("Test")
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Test';
                //     Promoted = true;
                //     PromotedCategory = New;
                //     PromotedIsBig = true;
                //     Image = Statistics;

                //     trigger OnAction()
                //     var
                //         PostedIndentHeader: Record "Posted Indent Header";
                //         PostedIndentLine: Record "Posted Indent Line";
                //     begin
                //         PostedIndentHeader.Reset();
                //         PostedIndentHeader.SetRange("No.", 'P-IND-123');
                //         IF PostedIndentHeader.FindFirst() then begin
                //             PostedIndentHeader.Status := PostedIndentHeader.Status::Approved;
                //             PostedIndentHeader.Modify();
                //             PostedIndentLine.Reset();
                //             PostedIndentLine.SetRange("Indent No.", PostedIndentHeader."No.");
                //             IF PostedIndentLine.FindSet() then
                //                 PostedIndentLine.ModifyAll(Status, PostedIndentLine.Status::Approved);

                //         end;
                //         Message('done');
                //     end;
                // }

                action("Cancellation")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancellation';
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    Image = Statistics;

                    trigger OnAction()
                    var
                    begin
                        IF NOT CONFIRM('Do you want to cancel selected Lines') THEN
                            EXIT;

                        Rec.SetRange(Select, true);
                        IF Rec.FindSet() then begin
                            repeat
                                Rec.Status := Rec.Status::Cancelled;
                                Rec.Select := false;
                                Rec.Modify();

                            until Rec.Next() = 0;
                            Rec.Reset();
                            Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                            CurrPage.Update(true);
                            Message('Selected Lines has been cancelled');
                        end else
                            Message('Lines must be selected before cancel');
                    end;
                }
            }
            group(Process)
            {
                action("Generate Quote Comparision Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Generate Quote Comparision Lines';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Statistics;

                    trigger OnAction()
                    var
                        IndnetHeader_Loc: Record "Posted Indent Header";
                        IndentLines_Loc: Record "Posted Indent Line";
                        QuoteComparision_Loc: Record "Quote Comparison";
                        BCLCostingMaster_loc: Record "BCL Costing Master";
                        CZHeader_Loc: Record "CZ Header";
                        QuoteComparision_Loc1: Record "Quote Comparison";
                        EntryNo_Loc: Integer;
                        IndentLinecreated: Boolean;

                    begin
                        Clear(EntryNo_Loc);
                        QuoteComparision_Loc.Reset();
                        QuoteComparision_Loc.SetCurrentKey("Entry No.");
                        QuoteComparision_Loc.SetFilter("Entry No.", '<>%1', 0);
                        IF QuoteComparision_Loc.FindLast() then begin
                            EntryNo_Loc := QuoteComparision_Loc."Entry No.";
                        end;

                        IndnetHeader_Loc.Reset();
                        IndnetHeader_Loc.SetRange(Status, IndnetHeader_Loc.Status::Approved);
                        if IndnetHeader_Loc.FindSet() then begin
                            repeat
                                IndentLines_Loc.Reset();
                                IndentLines_Loc.SetRange("Indent No.", IndnetHeader_Loc."No.");
                                IndentLines_Loc.SetFilter("Approved Qty", '>%1', 0);
                                if IndentLines_Loc.FindSet() then begin
                                    repeat
                                        Clear(IndentLinecreated);
                                        if (IndentLines_Loc."PM Item Type" <> IndentLines_Loc."PM Item Type"::Blank) then begin
                                            case IndentLines_Loc."PM Item Type" of
                                                IndentLines_Loc."PM Item Type"::Bottle:
                                                    begin
                                                        BCLCostingMaster_loc.Reset();
                                                        BCLCostingMaster_loc.SetRange(Type, BCLCostingMaster_loc.Type::Bottle);
                                                        BCLCostingMaster_loc.SetRange("Item Code", IndentLines_Loc."No.");
                                                        BCLCostingMaster_loc.SetFilter("Start Date", '<=%1', Today());
                                                        BCLCostingMaster_loc.SetFilter("End Date", '>=%1', Today());
                                                        IF BCLCostingMaster_loc.FindSet() then begin
                                                            repeat

                                                                QuoteComparision_Loc.Init();
                                                                EntryNo_Loc += 1;
                                                                QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                                                QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                                                QuoteComparision_Loc.Validate("Vendor Code", BCLCostingMaster_loc."Vendor Code");
                                                                QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                                                QuoteComparision_Loc."Unit Cost" := BCLCostingMaster_loc."Total Cost";
                                                                QuoteComparision_Loc."Total Indent Qty. Cost" := QuoteComparision_Loc."Indent Approved Quantity" * QuoteComparision_Loc."Unit Cost";
                                                                QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                                                QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Insert();
                                                                IndentLinecreated := true;
                                                                IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                                                IndentLines_Loc.Modify();
                                                            until BCLCostingMaster_loc.Next() = 0;
                                                        end;
                                                    end;
                                                IndentLines_Loc."PM Item Type"::Cap:
                                                    begin
                                                        BCLCostingMaster_loc.Reset();
                                                        BCLCostingMaster_loc.SetRange(Type, BCLCostingMaster_loc.Type::Cap);
                                                        BCLCostingMaster_loc.SetRange("Item Code", IndentLines_Loc."No.");
                                                        BCLCostingMaster_loc.SetFilter("Start Date", '<=%1', Today());
                                                        BCLCostingMaster_loc.SetFilter("End Date", '>=%1', Today());
                                                        IF BCLCostingMaster_loc.FindSet() then begin
                                                            repeat
                                                                QuoteComparision_Loc.Init();
                                                                EntryNo_Loc += 1;
                                                                QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                                                QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                                                QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                                                QuoteComparision_Loc.Validate("Vendor Code", BCLCostingMaster_loc."Vendor Code");
                                                                QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                                                QuoteComparision_Loc."Unit Cost" := BCLCostingMaster_loc."Total Cost";
                                                                QuoteComparision_Loc."Total Indent Qty. Cost" := QuoteComparision_Loc."Indent Approved Quantity" * QuoteComparision_Loc."Unit Cost";
                                                                QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                                                QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Insert();
                                                                IndentLinecreated := true;
                                                                IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                                                IndentLines_Loc.Modify();
                                                            until BCLCostingMaster_loc.Next() = 0;
                                                        end;

                                                    end;
                                                IndentLines_Loc."PM Item Type"::Label:
                                                    begin
                                                        BCLCostingMaster_loc.Reset();
                                                        BCLCostingMaster_loc.SetRange(Type, BCLCostingMaster_loc.Type::Label);
                                                        BCLCostingMaster_loc.SetRange("Substrate Type", IndentLines_Loc."Substrate Type");
                                                        BCLCostingMaster_loc.SetFilter("Qty From", '<=%1', IndentLines_Loc."Approved Qty");
                                                        BCLCostingMaster_loc.SetFilter("Qty To", '>=%1', IndentLines_Loc."Approved Qty");
                                                        BCLCostingMaster_loc.SetFilter("Start Date", '<=%1', Today());
                                                        BCLCostingMaster_loc.SetFilter("End Date", '>=%1', Today());
                                                        IF BCLCostingMaster_loc.FindSet() then begin
                                                            repeat
                                                                QuoteComparision_Loc.Init();
                                                                EntryNo_Loc += 1;
                                                                QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                                                QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                                                QuoteComparision_Loc.Validate("Vendor Code", BCLCostingMaster_loc."Vendor Code");
                                                                QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                                                QuoteComparision_Loc."Substrate Code" := BCLCostingMaster_loc."Substrate Code";
                                                                QuoteComparision_Loc."Substrate Type" := IndentLines_Loc."Substrate Type";
                                                                QuoteComparision_Loc.Length := IndentLines_Loc.Length;
                                                                QuoteComparision_Loc.Width := IndentLines_Loc.Width;
                                                                QuoteComparision_Loc."Area (Sq Mtr)" := (IndentLines_Loc.Length * IndentLines_Loc.Width) / 645;
                                                                QuoteComparision_Loc."Unit Cost" := (QuoteComparision_Loc."Area (Sq Mtr)" * BCLCostingMaster_loc."Sq.inch Rate");
                                                                QuoteComparision_Loc."Total Indent Qty. Cost" := QuoteComparision_Loc."Indent Approved Quantity" * QuoteComparision_Loc."Unit Cost";
                                                                QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                                                QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Insert();
                                                                IndentLinecreated := true;
                                                                IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                                                IndentLines_Loc.Modify();
                                                            until BCLCostingMaster_loc.Next() = 0;
                                                        end else begin
                                                            BCLCostingMaster_loc.Reset();
                                                            BCLCostingMaster_loc.SetRange(Type, BCLCostingMaster_loc.Type::Label);
                                                            BCLCostingMaster_loc.SetRange("Substrate Type", IndentLines_Loc."Substrate Type");
                                                            BCLCostingMaster_loc.SetFilter("Qty From", '<=%1', IndentLines_Loc."Approved Qty");
                                                            BCLCostingMaster_loc.SetRange("Qty To", 0);
                                                            BCLCostingMaster_loc.SetFilter("Start Date", '<=%1', Today());
                                                            BCLCostingMaster_loc.SetFilter("End Date", '>=%1', Today());
                                                            IF BCLCostingMaster_loc.FindSet() then begin
                                                                repeat
                                                                    QuoteComparision_Loc.Init();
                                                                    EntryNo_Loc += 1;
                                                                    QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                                                    QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                    QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                                                    QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                                                    QuoteComparision_Loc.Validate("Vendor Code", BCLCostingMaster_loc."Vendor Code");
                                                                    QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                                                    QuoteComparision_Loc."Substrate Code" := BCLCostingMaster_loc."Substrate Code";
                                                                    QuoteComparision_Loc."Substrate Type" := IndentLines_Loc."Substrate Type";
                                                                    QuoteComparision_Loc.Length := IndentLines_Loc.Length;
                                                                    QuoteComparision_Loc.Width := IndentLines_Loc.Width;
                                                                    QuoteComparision_Loc."Area (Sq Mtr)" := (IndentLines_Loc.Length * IndentLines_Loc.Width) / 645;
                                                                    QuoteComparision_Loc."Unit Cost" := Round((QuoteComparision_Loc."Area (Sq Mtr)" * BCLCostingMaster_loc."Sq.inch Rate"), 0.001, '=');
                                                                    QuoteComparision_Loc."Total Indent Qty. Cost" := ROund(QuoteComparision_Loc."Indent Approved Quantity" * QuoteComparision_Loc."Unit Cost", 0.01, '=');
                                                                    QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                                                    QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                                                    QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                    QuoteComparision_Loc.Insert();
                                                                    IndentLinecreated := true;
                                                                    IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                                                    IndentLines_Loc.Modify();
                                                                until BCLCostingMaster_loc.Next() = 0;
                                                            end;
                                                        end;


                                                    end;
                                                IndentLines_Loc."PM Item Type"::Carton:
                                                    begin
                                                        CZHeader_Loc.Reset();
                                                        CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Carton);
                                                        CZHeader_Loc.SetRange("Main Item Code", IndentLines_Loc."No.");
                                                        CZHeader_Loc.SetFilter("Start Date", '<=%1', Today());
                                                        CZHeader_Loc.SetFilter("End Date", '>=%1', Today());
                                                        IF CZHeader_Loc.FindSet() then begin
                                                            repeat
                                                                QuoteComparision_Loc.Init();
                                                                EntryNo_Loc += 1;
                                                                QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                                                QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                                                QuoteComparision_Loc.Validate("Vendor Code", CZHeader_Loc."Vendor Code");
                                                                QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                                                QuoteComparision_Loc."Unit Cost" := CZHeader_Loc."Total Cost";
                                                                QuoteComparision_Loc."Total Indent Qty. Cost" := QuoteComparision_Loc."Indent Approved Quantity" * QuoteComparision_Loc."Unit Cost";
                                                                QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                                                QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Insert();
                                                                IndentLinecreated := true;
                                                                IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                                                IndentLines_Loc.Modify();
                                                            until CZHeader_Loc.Next() = 0;
                                                        end;
                                                    end;
                                                IndentLines_Loc."PM Item Type"::Pouch:
                                                    begin
                                                        CZHeader_Loc.Reset();
                                                        CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Pouch);
                                                        CZHeader_Loc.SetRange("Main Item Code", IndentLines_Loc."No.");
                                                        CZHeader_Loc.SetFilter("Start Date", '<=%1', Today());
                                                        CZHeader_Loc.SetFilter("End Date", '>=%1', Today());
                                                        IF CZHeader_Loc.FindSet() then begin
                                                            repeat
                                                                QuoteComparision_Loc.Init();
                                                                EntryNo_Loc += 1;
                                                                QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                                                QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                                                QuoteComparision_Loc.Validate("Vendor Code", CZHeader_Loc."Vendor Code");
                                                                QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                                                QuoteComparision_Loc."Unit Cost" := CZHeader_Loc."Landed Price / Pouch";
                                                                QuoteComparision_Loc."Total Indent Qty. Cost" := QuoteComparision_Loc."Indent Approved Quantity" * QuoteComparision_Loc."Unit Cost";
                                                                QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                                                QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                                                QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                                                QuoteComparision_Loc.Insert();
                                                                IndentLinecreated := true;
                                                                IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                                                IndentLines_Loc.Modify();
                                                            until CZHeader_Loc.Next() = 0;
                                                        end;
                                                    end;
                                            end;
                                        end;

                                        IF not IndentLinecreated then begin
                                            QuoteComparision_Loc.Init();
                                            EntryNo_Loc += 1;
                                            QuoteComparision_Loc."Entry No." := EntryNo_Loc;
                                            QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                            QuoteComparision_Loc.Type := QuoteComparision_Loc.Type::Item;
                                            QuoteComparision_Loc.Validate(No, IndentLines_Loc."No.");
                                            QuoteComparision_Loc."Vendor Code" := '';
                                            QuoteComparision_Loc."Indent Approved Quantity" := IndentLines_Loc."Approved Qty";
                                            QuoteComparision_Loc."Unit Cost" := 0;
                                            QuoteComparision_Loc."Indent No." := IndentLines_Loc."Indent No.";
                                            QuoteComparision_Loc."Indent Line No" := IndentLines_Loc."Line No";
                                            QuoteComparision_Loc.Status := QuoteComparision_Loc.Status::Open;
                                            QuoteComparision_Loc.Insert();
                                            IndentLinecreated := true;
                                            IndentLines_Loc.Status := IndentLines_Loc.Status::Closed;
                                            IndentLines_Loc.Modify();
                                        end;
                                    until IndentLines_Loc.Next() = 0;
                                end;
                                Clear(IndentLines_Loc);
                                IndentLines_Loc.Reset();
                                IndentLines_Loc.SetRange("Indent No.", IndnetHeader_Loc."No.");
                                IndentLines_Loc.SetFilter("Approved Qty", '>%1', 0);
                                IndentLines_Loc.SetRange(Status, IndentLines_Loc.Status::Approved);
                                if not IndentLines_Loc.FindSet() then begin
                                    IndnetHeader_Loc.Status := IndnetHeader_Loc.Status::Closed;
                                    IndnetHeader_Loc.Modify(true);
                                end;
                            until IndnetHeader_Loc.Next() = 0;
                            Rec.Reset();
                            Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                            CurrPage.Update();
                            Message('Quote Comparison Lines has been generated');
                        end else
                            Message('there are no Indent approved lines to generate Quote Comparison Lines');
                    end;
                }
                action("Set Priority Cost Wise")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set Priority Cost Wise';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Statistics;

                    trigger OnAction()
                    var
                        QuoteComparison_Loc: Record "Quote Comparison";
                        ItemNo_Loc: Code[20];
                        PriorityOrder: Integer;
                    begin
                        IF NOT CONFIRM('Do you want to set prioroty order cost wise') THEN
                            EXIT;

                        Clear(ItemNo_Loc);
                        QuoteComparison_Loc.Reset();
                        QuoteComparison_Loc.SetCurrentKey(Type, No, "Unit Cost");
                        QuoteComparison_Loc.SetFilter(Status, '%1', QuoteComparison_Loc.Status::Open);
                        IF QuoteComparison_Loc.FindFirst() then begin
                            repeat
                                IF (ItemNo_Loc <> QuoteComparison_Loc.No) then begin
                                    Clear(PriorityOrder);
                                    ItemNo_Loc := QuoteComparison_Loc.No;
                                end;
                                PriorityOrder += 1;
                                QuoteComparison_Loc."Priority No." := 'L' + Format(PriorityOrder);
                                QuoteComparison_Loc.Modify();
                            until QuoteComparison_Loc.Next() = 0;
                            // Rec.Reset();
                            // Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                            // CurrPage.Update();
                            Message('Priority Order has been set');
                        end else
                            Message('There are no lines with Status - Open, to set priority orders');
                    end;
                }
            }

            group(Approvals)
            {
                action("Send For Approval")
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
                    begin
                        IF NOT CONFIRM('Do you want to send for approval') THEN
                            EXIT;

                        Clear(EntryNo);
                        if AppEntryIndentEntryno.FindLast then
                            EntryNo := AppEntryIndentEntryno."Entry No.";

                        Rec.Reset();
                        Rec.SetRange(Status, Rec.Status::Open);
                        Rec.SetRange(Select, true);
                        Rec.SetRange("Unit Cost", 0);
                        IF Rec.FindFirst() then
                            Error(StrSubstNo('Unit Cost must have a value in line with entry no %1', Rec."Entry No."));

                        Rec.Reset();
                        Rec.SetRange(Status, Rec.Status::Open);
                        Rec.SetRange(Select, true);
                        Rec.SetRange("PO Qty.", 0);
                        IF Rec.FindFirst() then
                            Error(StrSubstNo('Po Qty must have a value in line with entry no %1', Rec."Entry No."));

                        Rec.Reset();
                        Rec.SetRange(Status, Rec.Status::Open);
                        Rec.SetRange(Select, true);
                        Rec.SetRange(Rec.No, '');
                        IF Rec.FindFirst() then
                            Error(StrSubstNo('Item must have a value in line with entry no %1', Rec."Entry No."));


                        Rec.Reset();
                        Rec.SetRange(Status, Rec.Status::Open);
                        Rec.SetRange(Select, true);
                        Rec.SetRange(Rec."Vendor Code", '');
                        IF Rec.FindFirst() then
                            Error(StrSubstNo('Vendor must have a value in line with entry no %1', Rec."Entry No."));

                        Rec.Reset();
                        Rec.SetRange(Status, Rec.Status::Open);
                        Rec.SetRange(Select, true);
                        IF Rec.FindSet() then begin

                            //>>Mail Header
                            Clear(MailUserIdVar);
                            Clear(BccMailIdList);
                            Clear(CCMailIdList);
                            MailUserid := UserId;
                            VarUserSetup.Reset();
                            VarUserSetup.SetRange("User ID", UserId);
                            if VarUserSetup.FindFirst() then
                                UserEmail := VarUserSetup."E-Mail";

                            VarUserSetup.TestField("Quote Comp. Approver ID");
                            VarapproverSetup.Reset();
                            VarapproverSetup.SetRange("User ID", VarUserSetup."Quote Comp. Approver ID");
                            if VarapproverSetup.FindFirst() then begin
                                approveremail := VarapproverSetup."E-Mail";
                                MailUserIdVar.Add(approveremail);
                            end;

                            MailComapnyName := CompanyName;
                            MailSubject := 'Quote Comparision for date ' + Format(Today()) + ' ' + CompanyName;

                            BodyTxt := 'Dear Sir/Madam,';
                            BodyTxt += '<br></br>';
                            BodyTxt := 'Please find the below Quote Comparision for approval:';
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
                                ApprovalEntryIndent."Quote Comparison Entry No." := Rec."Entry No.";
                                ApprovalEntryIndent."Sender UserID" := UserId;
                                usersetup.Get(UserId);
                                usersetup.TestField("Quote Comp. Approver ID");
                                if usersetup1.get(usersetup."Quote Comp. Approver ID") then begin
                                    if (Rec."PO Qty." * Rec."Unit Cost") <= usersetup1."Quote Comp. Approval Limit" then
                                        ApprovalEntryIndent."Approver UserID" := usersetup1."User ID"
                                    else
                                        ApprovalEntryIndent."Approver UserID" := usersetup1."Approver ID";
                                end;
                                ApprovalEntryIndent.Status := ApprovalEntryIndent.Status::"Sent for approval";
                                ApprovalEntryIndent."Sent for approval" := true;
                                ApprovalEntryIndent."Send DateTime" := CurrentDateTime;
                                ApprovalEntryIndent.Insert;

                                Rec.Status := Rec.Status::"Pending Approval";
                                Rec."Approver UserID" := ApprovalEntryIndent."Approver UserID";
                                Rec.Select := false;
                                Rec."Sender UserID" := UserId;
                                Rec."Send DateTime" := CurrentDateTime;
                                Rec.Modify();

                                //>Mail Body
                                BodyTxt += '<TR>';
                                BodyTxt += '<TD>' + Format(Rec."Indent No.") + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."Indent Line No") + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec.Type) + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec.Description) + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."Vendor Name") + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."Indent Approved Quantity") + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."Unit Cost") + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."PO Qty.") + '</TD>';
                                BodyTxt += '<TD>' + format(Round(Rec."Total PO Qty. Cost", 0.01, '=')) + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."Entry No.") + '</TD>';
                                BodyTxt += '<TD>' + Format(Rec."Priority No.") + '</TD>';
                                BodyTxt += '<TD>' + format(Rec.Status) + '</TD>';
                                BodyTxt += '<TD>' + Rec.Remarks + '</TD>';
                                BodyTxt += '</TR>';
                            //<<Mail Body

                            until Rec.Next() = 0;

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

                            Rec.Reset();
                            Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                            CurrPage.Update();
                            Message('Quote Comparison Entries has been sent for approval successfully.');
                        end else
                            Message('There are no lines are selected');
                    end;
                }
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
                    begin
                        Rec.SetRange(Select, true);
                        Rec.SetRange(Status, Rec.Status::"Pending Approval");
                        Rec.SetRange(Remarks, '');
                        IF Rec.FindFirst() then
                            Error(StrSubstNo('Remarks must have a value for a line with Entry No. %1', Rec."Entry No."));

                        IF NOT CONFIRM('Do you want to Cancel - Pending Approval lines') THEN
                            EXIT;

                        Rec.Reset();
                        Rec.SetRange(Select, true);
                        Rec.SetRange(Status, Rec.Status::"Pending Approval");
                        IF Rec.FindSet() then begin
                            Clear(EntryNo);
                            if AppEntryIndentEntryno.FindLast then
                                EntryNo := AppEntryIndentEntryno."Entry No.";

                            repeat
                                AppEntryIndentEntryno.Reset();
                                AppEntryIndentEntryno.SetRange("Quote Comparison Entry No.", Rec."Entry No.");
                                if AppEntryIndentEntryno.FindSet then
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

                                Rec.Status := Rec.Status::Open;
                                Rec."Approver UserID" := '';
                                Rec."Sender UserID" := '';
                                Rec.Select := false;
                                Rec."Sender UserID" := '';
                                Rec."Send DateTime" := 0DT;
                                Rec.Modify();

                            until Rec.Next() = 0;

                            Rec.Reset();
                            Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                            CurrPage.Update();
                        end else
                            Message('There are no lines selected for cancel - pending Approval Lines');
                    end;
                }
            }

            group("Copy Lines & History")
            {
                Action("Copy from Approved Entries")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = New;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        EntryNo: Integer;
                        QuoteComparison_Loc: Record "Quote Comparison";
                        QuoteComparison_Loc1: Record "Quote Comparison";
                        ApprovedQuoteComparison_Page: page "Approved Quote Comparison";
                    begin
                        QuoteComparison_Loc1.Reset();
                        IF QuoteComparison_Loc1.FindLast() then
                            EntryNo := QuoteComparison_Loc1."Entry No.";

                        Clear(QuoteComparison_Loc1);
                        QuoteComparison_Loc.Reset();
                        QuoteComparison_Loc.SetRange(Status, QuoteComparison_Loc.Status::Approved);
                        IF QuoteComparison_Loc.FindSet() then begin
                            ApprovedQuoteComparison_Page.SetTableView(QuoteComparison_Loc);
                            ApprovedQuoteComparison_Page.LookupMode(true);
                            IF (ApprovedQuoteComparison_Page.RunModal() = Action::LookupOK) then begin
                                ApprovedQuoteComparison_Page.SetSelectionFilter(QuoteComparison_Loc);
                                IF QuoteComparison_Loc.FindSet() then begin
                                    repeat
                                        QuoteComparison_Loc1.Init();
                                        EntryNo += 1;
                                        QuoteComparison_Loc1."Entry No." := EntryNo;
                                        QuoteComparison_Loc1.Type := QuoteComparison_Loc.Type;
                                        QuoteComparison_Loc1.Validate(No, QuoteComparison_Loc.No);
                                        QuoteComparison_Loc1.Validate("Vendor Code", QuoteComparison_Loc."Vendor Code");
                                        QuoteComparison_Loc1."Unit Cost" := QuoteComparison_Loc."Unit Cost";
                                        QuoteComparison_Loc1.Freight := QuoteComparison_Loc.Freight;
                                        QuoteComparison_Loc1."Payment Term" := QuoteComparison_Loc."Payment Term";
                                        QuoteComparison_Loc1."Delivery Days" := QuoteComparison_Loc."Delivery Days";
                                        QuoteComparison_Loc1.Status := QuoteComparison_Loc1.Status::Open;
                                        QuoteComparison_Loc1.Insert();

                                    until QuoteComparison_Loc.Next() = 0;
                                    Message('Quote Comparison Lines has been created from Approved Quote Comparison Lines');
                                    Rec.Reset();
                                    Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                                    CurrPage.Update();
                                end;
                            end;
                        end else
                            Message('There are no Approved Quote Comparison Lines');
                    end;
                }
                Action("Copy from PO Created Entries")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = New;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        EntryNo: Integer;
                        QuoteComparison_Loc: Record "Quote Comparison";
                        QuoteComparison_Loc1: Record "Quote Comparison";
                        POCreatedQuoteComparison_Page: page "PO Created Quote Comparison";
                    begin
                        QuoteComparison_Loc1.Reset();
                        IF QuoteComparison_Loc1.FindLast() then
                            EntryNo := QuoteComparison_Loc1."Entry No.";
                        Clear(QuoteComparison_Loc1);

                        QuoteComparison_Loc.Reset();
                        QuoteComparison_Loc.SetRange(Status, QuoteComparison_Loc.Status::"PO Created");
                        IF QuoteComparison_Loc.FindSet() then begin
                            POCreatedQuoteComparison_Page.SetTableView(QuoteComparison_Loc);
                            POCreatedQuoteComparison_Page.LookupMode(true);
                            IF (POCreatedQuoteComparison_Page.RunModal() = Action::LookupOK) then begin
                                POCreatedQuoteComparison_Page.SetSelectionFilter(QuoteComparison_Loc);
                                IF QuoteComparison_Loc.FindSet() then begin
                                    repeat
                                        QuoteComparison_Loc1.Init();
                                        EntryNo += 1;
                                        QuoteComparison_Loc1."Entry No." := EntryNo;
                                        QuoteComparison_Loc1.Type := QuoteComparison_Loc.Type;
                                        QuoteComparison_Loc1.Validate(No, QuoteComparison_Loc.No);
                                        QuoteComparison_Loc1.Validate("Vendor Code", QuoteComparison_Loc."Vendor Code");
                                        QuoteComparison_Loc1."Unit Cost" := QuoteComparison_Loc."Unit Cost";
                                        QuoteComparison_Loc1.Freight := QuoteComparison_Loc.Freight;
                                        QuoteComparison_Loc1."Payment Term" := QuoteComparison_Loc."Payment Term";
                                        QuoteComparison_Loc1."Delivery Days" := QuoteComparison_Loc."Delivery Days";
                                        QuoteComparison_Loc1.Status := QuoteComparison_Loc1.Status::Open;
                                        QuoteComparison_Loc1.Insert();

                                    until QuoteComparison_Loc.Next() = 0;
                                    Message('Quote Comparison Lines has been created from PO created Quote Comparison Lines');
                                    Rec.Reset();
                                    Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                                    CurrPage.Update(true);
                                end;
                            end;
                        end else
                            Message('There are no PO Created Quote Comparison Lines');
                    end;
                }
                Action("Copy from Not Qualified Entries")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = New;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        EntryNo: Integer;
                        QuoteComparison_Loc: Record "Quote Comparison";
                        QuoteComparison_Loc1: Record "Quote Comparison";
                        POCreatedQuoteComparison_Page: page "Not Qualified Quote Comparison";
                    begin
                        QuoteComparison_Loc1.Reset();
                        IF QuoteComparison_Loc1.FindLast() then
                            EntryNo := QuoteComparison_Loc1."Entry No.";
                        Clear(QuoteComparison_Loc1);

                        QuoteComparison_Loc.Reset();
                        QuoteComparison_Loc.SetRange(Status, QuoteComparison_Loc.Status::"Not Qualified");
                        IF QuoteComparison_Loc.FindSet() then begin
                            POCreatedQuoteComparison_Page.SetTableView(QuoteComparison_Loc);
                            POCreatedQuoteComparison_Page.LookupMode(true);
                            IF (POCreatedQuoteComparison_Page.RunModal() = Action::LookupOK) then begin
                                POCreatedQuoteComparison_Page.SetSelectionFilter(QuoteComparison_Loc);
                                IF QuoteComparison_Loc.FindSet() then begin
                                    repeat
                                        QuoteComparison_Loc1.Init();
                                        EntryNo += 1;
                                        QuoteComparison_Loc1."Entry No." := EntryNo;
                                        QuoteComparison_Loc1.Type := QuoteComparison_Loc.Type;
                                        QuoteComparison_Loc1.Validate(No, QuoteComparison_Loc.No);
                                        QuoteComparison_Loc1.Validate("Vendor Code", QuoteComparison_Loc."Vendor Code");
                                        QuoteComparison_Loc1."Unit Cost" := QuoteComparison_Loc."Unit Cost";
                                        QuoteComparison_Loc1.Freight := QuoteComparison_Loc.Freight;
                                        QuoteComparison_Loc1."Payment Term" := QuoteComparison_Loc."Payment Term";
                                        QuoteComparison_Loc1."Delivery Days" := QuoteComparison_Loc."Delivery Days";
                                        QuoteComparison_Loc1.Status := QuoteComparison_Loc1.Status::Open;
                                        QuoteComparison_Loc1.Insert();

                                    until QuoteComparison_Loc.Next() = 0;
                                    Message('Quote Comparison Lines has been created from not Qualified Quote Comparison Lines');
                                    Rec.Reset();
                                    Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Open, Rec.Status::"Pending Approval", Rec.Status::Rejected);
                                    CurrPage.Update(true);
                                end;
                            end;
                        end else
                            Message('There are no PO Created Quote Comparison Lines');
                    end;
                }
            }
        }
    }
    var
        IndenteditableBool: Boolean;
        POEditable: Boolean;

    trigger OnOpenPage()
    begin
        CalculateOutstandingQty();
        IF (Rec."Indent No." <> '') then
            IndenteditableBool := false
        else
            IndenteditableBool := true;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateOutstandingQty();
        IF (Rec."Indent No." <> '') then
            IndenteditableBool := false
        else
            IndenteditableBool := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateOutstandingQty();
        IF (Rec."Indent No." <> '') then
            IndenteditableBool := false
        else
            IndenteditableBool := true;
    end;

    procedure CalculateOutstandingQty()
    var
        QuoteComparision_Loc: Record "Quote Comparison";
        TotalPOQty: Decimal;
        Item_Loc: Record Item;
        GLAccount_Loc: Record "G/L Account";
        FixedAssets_Loc: Record "Fixed Asset";
        Vendor_Loc: Record Vendor;
    begin

        if Rec.Status <> Rec.Status::Open then
            POEditable := false
        else
            POEditable := true;

        Clear(TotalPOQty);
        QuoteComparision_Loc.Reset();
        QuoteComparision_Loc.SetRange("Indent No.", Rec."Indent No.");
        QuoteComparision_Loc.SetRange("Indent Line No", Rec."Indent Line No");
        IF QuoteComparision_Loc.FindSet() then begin
            repeat
                TotalPOQty += QuoteComparision_Loc."PO Qty.";
            until QuoteComparision_Loc.Next() = 0;

            IF ((Rec."Indent Approved Quantity" - TotalPOQty)) < 0 then
                Error(StrSubstNo('PO Qty is increaded by %1 Qty', ABS(Rec."Indent Approved Quantity" - TotalPOQty)));
            Rec."Outstanding Qty." := Rec."Indent Approved Quantity" - TotalPOQty;
        end;

        Rec."Total Indent Qty. Cost" := Rec."Unit Cost" * Rec."Indent Approved Quantity";

        IF (Rec.Description = '') then
            IF (Rec.Type = Rec.Type::Item) then begin
                Item_Loc.Get(Rec.No);
                Rec.Description := Item_Loc.Description;
            end else
                IF (Rec.Type = Rec.Type::"G/L Account") then begin
                    GLAccount_Loc.Get(Rec.No);
                    Rec.Description := GLAccount_Loc.Name;
                end else
                    IF (Rec.Type = Rec.Type::"Fixed Asset") then begin
                        FixedAssets_Loc.Get(Rec.No);
                        Rec.Description := FixedAssets_Loc.Description;
                    end else
                        Rec.Description := '';
        IF (Rec."Vendor Name" = '') then
            IF Vendor_Loc.Get(Rec."Vendor Code") then
                Rec."Vendor Name" := Vendor_Loc.Name
            else
                Rec."Vendor Name" := '';
    end;

}
