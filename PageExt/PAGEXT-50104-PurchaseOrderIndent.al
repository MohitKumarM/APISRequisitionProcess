pageextension 50104 GetIndentFromPO extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore(CopyDocument)
        {
            action(GetIndentLine)
            {
                ApplicationArea = Suite;
                Caption = 'Get Indent Lines';
                Ellipsis = true;
                Image = GetLines;

                trigger OnAction()
                begin
                    clear(IndentPage);
                    PostedIndentLine.reset;
                    PostedIndentLine.FilterGroup(2);
                    PostedIndentLine.SetRange("Purchase Created", false);
                    PostedIndentLine.SetFilter("Approved Qty", '>%1', 0);
                    PostedIndentLine.FilterGroup(0);
                    IndentPage.SetTableView(PostedIndentLine);
                    IndentPage.GetDocNo(Rec."No.");
                    IndentPage.LookupMode(true);
                    IndentPage.RunModal();
                end;

            }
            action(GetQuoteComparisonLines)
            {
                ApplicationArea = Suite;
                Caption = 'Get Quote Comparison Lines';
                Ellipsis = true;
                Image = GetLines;

                trigger OnAction()
                var
                    QuoteComparison_Loc: Record "Quote Comparison";
                    QuoteComparison_Loc1: Record "Quote Comparison";
                    ApprovedQuoteComparison_Page: page "Approved Quote Comparison";
                    PurchLine_Loc: Record "Purchase Line";
                    LastLineNo: Integer;
                begin
                    Rec.TestField("Buy-from Vendor No.");

                    QuoteComparison_Loc.Reset();
                    QuoteComparison_Loc.SetRange(Status, QuoteComparison_Loc.Status::Approved);
                    QuoteComparison_Loc.SetRange("Vendor Code", Rec."Buy-from Vendor No.");
                    IF QuoteComparison_Loc.FindSet() then begin
                        ApprovedQuoteComparison_Page.SetTableView(QuoteComparison_Loc);
                        ApprovedQuoteComparison_Page.LookupMode(true);
                        IF ApprovedQuoteComparison_Page.RunModal() = Action::LookupOK then begin
                            ApprovedQuoteComparison_Page.SetSelectionFilter(QuoteComparison_Loc1);
                            IF QuoteComparison_Loc1.FindSet() then begin
                                PurchLine_Loc.Reset();
                                PurchLine_Loc.SetRange("Document Type", Rec."Document Type");
                                PurchLine_Loc.SetRange("Document No.", Rec."No.");
                                IF PurchLine_Loc.FindLast() then
                                    LastLineNo := PurchLine_Loc."Line No.";

                                Clear(PurchLine_Loc);
                                repeat
                                    PurchLine_Loc.Init();
                                    PurchLine_Loc.Validate("Document Type", Rec."Document Type");
                                    PurchLine_Loc.Validate("Document No.", Rec."No.");
                                    LastLineNo += 10000;
                                    PurchLine_Loc."Line No." := LastLineNo;
                                    case QuoteComparison_Loc1.Type of
                                        QuoteComparison_Loc1.Type::Item:
                                            begin
                                                PurchLine_Loc.Type := PurchLine_Loc.Type::Item;
                                            end;
                                        QuoteComparison_Loc1.Type::"G/L Account":
                                            begin
                                                PurchLine_Loc.Type := PurchLine_Loc.Type::"G/L Account";
                                            end;
                                        QuoteComparison_Loc1.Type::"Fixed Asset":
                                            begin
                                                PurchLine_Loc.Type := PurchLine_Loc.Type::"Fixed Asset";
                                            end;
                                    end;
                                    PurchLine_Loc.validate("No.", QuoteComparison_Loc1.No);
                                    PurchLine_Loc.validate(Quantity, QuoteComparison_Loc1."PO Qty.");
                                    PurchLine_Loc.validate("Unit Cost", QuoteComparison_Loc1."Unit Cost");
                                    PurchLine_Loc."Indent No." := QuoteComparison_Loc1."Indent No.";
                                    PurchLine_Loc."Indent Line No." := QuoteComparison_Loc1."Indent Line No";
                                    PurchLine_Loc."Quote Comparison Entry No." := QuoteComparison_Loc1."Entry No.";
                                    PurchLine_Loc.Insert(true);

                                    QuoteComparison_Loc1."PO No." := PurchLine_Loc."Document No.";
                                    QuoteComparison_Loc1."PO Line No." := PurchLine_Loc."Line No.";
                                    QuoteComparison_Loc1.Status := QuoteComparison_Loc1.Status::"PO Created";
                                    QuoteComparison_Loc1.Modify();
                                until QuoteComparison_Loc1.Next() = 0;
                                Message('Purchase Lines has been inserted succesfully.');
                            end;
                        end;
                    end;
                end;
            }
        }


        // Add changes to page actions here
    }

    var
        PostedIndentLine: Record "Posted Indent Line";
        IndentPage: page "Posted Indent For PO";

}