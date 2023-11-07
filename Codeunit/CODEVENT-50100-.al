codeunit 50100 "Extend90"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnInsertReceiptLineOnAfterInitPurchRcptLine', '', false, false)]
    local procedure OnInsertReceiptLineOnAfterInitPurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; xPurchLine: Record "Purchase Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var CostBaseAmount: Decimal; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header"; WhseRcptHeader: Record "Warehouse Receipt Header"; var WhseRcptLine: Record "Warehouse Receipt Line")
    var

        PostedIndentLine: Record "Posted Indent Line";
    begin

        PostedIndentLine.Reset;
        PostedIndentLine.setrange("PO No", PurchLine."Document No.");
        if PostedIndentLine.FindSet then begin
            PostedIndentLine."MRN No" := PurchRcptLine."Document No.";
            PostedIndentLine.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"System Action Triggers", 'GetNotificationStatus', '', true, false)]
    procedure GetNotificationStatus(NotificationId: Guid; var IsEnabled: Boolean)
    begin
        WorkDate(Today);
    end;
}