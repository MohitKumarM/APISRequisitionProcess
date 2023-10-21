codeunit 50151 "E-Way Bill Generartion"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    local procedure ReadActionDetails()
    var
        myInt: Integer;
    begin

    end;

    local procedure WriteActionDetails(var JActionDtls: JsonObject; Irn: Text; Distance: Decimal)
    var

    begin
        JActionDtls.Add('ACTION', 'EWAYBILL');
        JActionDtls.Add('IRN', Irn);
        JActionDtls.Add('Distance', ReturnStr(RoundAmt(Distance)))
    end;

    local procedure ReadTransDetails(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment";
        var JReadTransDtls: JsonObject)
    var
        Trans_SalesInvoiceHeader: Record "Sales Invoice Header";
        Trans_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Trans_TransferShipmentHeader: Record "Transfer Shipment Header";
        Trans_ShippingAgent: Record "Shipping Agent";
        TrnsMode: Text;
        TransID: Code[20];
        TransName: Text;
        TransDocDt: Text;
        TransDocNo: Code[20];
        TransVehNo: Text;
        TransVehType: Text;
    begin
        case
            DocumentType of
            DocumentType::Invoice:
                begin
                    if Trans_SalesInvoiceHeader.get(DocNo) then begin
                        if Trans_SalesInvoiceHeader."Transport Method" <> '' then
                            TrnsMode := TransportMethod(Trans_SalesInvoiceHeader."Transport Method")
                        else
                            TrnsMode := '';
                        if Trans_SalesInvoiceHeader."Vehicle No." = '' then begin
                            IF NOT (Trans_SalesInvoiceHeader."Transport Method" = '') then
                                TrnsMode := '';
                        end;
                        if Trans_ShippingAgent.Get(Trans_SalesInvoiceHeader."Shipping Agent Code") then begin
                            TransID := Trans_ShippingAgent."GST Registration No.";
                            TransName := Trans_ShippingAgent.Name;
                        end else begin
                            TransID := '';
                            TransName := '';
                        end;
                        if not (Trans_SalesInvoiceHeader."LR/RR Date" = 0D) then
                            TransDocDt := FORMAT(Trans_SalesInvoiceHeader."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>')
                        else
                            TransDocDt := '';
                        if not (Trans_SalesInvoiceHeader."LR/RR No." = '') then
                            TransDocNo := Trans_SalesInvoiceHeader."LR/RR No."
                        else
                            TransDocNo := '';
                        if not (Trans_SalesInvoiceHeader."Vehicle No." = '') then
                            TransVehNo := Trans_SalesInvoiceHeader."Vehicle No."
                        else
                            TransVehNo := '';
                        if (Trans_SalesInvoiceHeader."Vehicle Type" = Trans_SalesInvoiceHeader."Vehicle Type"::" ") then
                            TransVehType := ''
                        else
                            if (Trans_SalesInvoiceHeader."Vehicle Type" = Trans_SalesInvoiceHeader."Vehicle Type"::ODC) then
                                TransVehType := 'O'
                            else
                                if (Trans_SalesInvoiceHeader."Vehicle Type" = Trans_SalesInvoiceHeader."Vehicle Type"::Regular) then
                                    TransVehType := 'R';
                    end;
                end;
            DocumentType::"Credit Memo":
                begin
                    if Trans_SalesCrMemoHeader.get(DocNo) then begin
                        if Trans_SalesCrMemoHeader."Transport Method" <> '' then
                            TrnsMode := TransportMethod(Trans_SalesCrMemoHeader."Transport Method")
                        else
                            TrnsMode := '';
                        if Trans_SalesCrMemoHeader."Vehicle No." = '' then begin
                            if not (Trans_SalesCrMemoHeader."Transport Method" = '') then
                                TrnsMode := '';
                        end;
                        if Trans_ShippingAgent.Get(Trans_SalesCrMemoHeader."Shipping Agent Code") then begin
                            TransID := Trans_ShippingAgent."GST Registration No.";
                            TransName := Trans_ShippingAgent.Name;
                        end else begin
                            TransID := '';
                            TransName := '';
                        end;
                        if not (Trans_SalesCrMemoHeader."LR/RR Date" = 0D) then
                            TransDocDt := FORMAT(Trans_SalesCrMemoHeader."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>')
                        else
                            TransDocDt := '';
                        if not (Trans_SalesCrMemoHeader."LR/RR No." = '') then
                            TransDocNo := Trans_SalesCrMemoHeader."LR/RR No."
                        else
                            TransDocNo := '';
                        if not (Trans_SalesCrMemoHeader."Vehicle No." = '') then
                            TransVehNo := Trans_SalesCrMemoHeader."Vehicle No."
                        else
                            TransVehNo := '';
                        if (Trans_SalesCrMemoHeader."Vehicle Type" = Trans_SalesCrMemoHeader."Vehicle Type"::" ") then
                            TransVehType := ''
                        else
                            if (Trans_SalesCrMemoHeader."Vehicle Type" = Trans_SalesCrMemoHeader."Vehicle Type"::ODC) then
                                TransVehType := 'O'
                            else
                                if (Trans_SalesCrMemoHeader."Vehicle Type" = Trans_SalesCrMemoHeader."Vehicle Type"::Regular) then
                                    TransVehType := 'R';
                    end;
                end;
            DocumentType::"Transfer Shipment":
                begin
                    if Trans_TransferShipmentHeader.get(DocNo) then begin
                        if Trans_TransferShipmentHeader."Transport Method" <> '' then
                            TrnsMode := TransportMethod(Trans_TransferShipmentHeader."Transport Method")
                        else
                            TrnsMode := '';
                        if Trans_TransferShipmentHeader."Vehicle No." = '' then begin
                            if not (Trans_TransferShipmentHeader."Transport Method" = '') then
                                TrnsMode := '';
                        end;
                        if Trans_ShippingAgent.Get(Trans_TransferShipmentHeader."Shipping Agent Code") then begin
                            TransID := Trans_ShippingAgent."GST Registration No.";
                            TransName := Trans_ShippingAgent.Name;
                        end else begin
                            TransID := '';
                            TransName := '';
                        end;
                        if not (Trans_TransferShipmentHeader."LR/RR Date" = 0D) then
                            TransDocDt := FORMAT(Trans_TransferShipmentHeader."LR/RR Date", 0, '<Day,2>/<Month,2>/<Year4>')
                        else
                            TransDocDt := '';
                        if not (Trans_TransferShipmentHeader."LR/RR No." = '') then
                            TransDocNo := Trans_TransferShipmentHeader."LR/RR No."
                        else
                            TransDocNo := '';
                        if not (Trans_TransferShipmentHeader."Vehicle No." = '') then
                            TransVehNo := Trans_TransferShipmentHeader."Vehicle No."
                        else
                            TransVehNo := '';
                        if (Trans_TransferShipmentHeader."Vehicle Type" = Trans_TransferShipmentHeader."Vehicle Type"::" ") then
                            TransVehType := ''
                        else
                            if (Trans_TransferShipmentHeader."Vehicle Type" = Trans_TransferShipmentHeader."Vehicle Type"::ODC) then
                                TransVehType := 'O'
                            else
                                if (Trans_TransferShipmentHeader."Vehicle Type" = Trans_TransferShipmentHeader."Vehicle Type"::Regular) then
                                    TransVehType := 'R';
                    end;
                end;
        end;
        WriteTrnsDeatils(JReadTransDtls, TrnsMode, TransID, TransName, TransDocDt, TransDocNo, TransVehNo, TransVehType);
    end;

    local procedure WriteTrnsDeatils(var JWriteTransDetais: JsonObject; TransMode: Text; TransID: Code[20];
      TransName: Text; TransDocDt: Text; TransDocNo: Code[20]; TransVehNo: Text; TransVehType: Text)
    var
        JsonNull: JsonValue;
    begin
        JsonNull.SetValueToNull();
        if TransMode <> '' then
            JWriteTransDetais.Add('TransMode', TransMode)
        else
            JWriteTransDetais.Add('TransMode', JsonNull);
        if TransID <> '' then
            JWriteTransDetais.Add('TransId', TransID)
        else
            JWriteTransDetais.Add('TransId', JsonNull);
        if TransName <> '' then
            JWriteTransDetais.Add('TransName', TransName)
        else
            JWriteTransDetais.Add('TransName', JsonNull);
        if TransDocDt <> '' then
            JWriteTransDetais.Add('TransDocDt', TransDocDt)
        else
            JWriteTransDetais.Add('TransDocDt', JsonNull);
        if TransDocNo <> '' then
            JWriteTransDetais.Add('TransDocNo', TransDocNo)
        else
            JWriteTransDetais.Add('TransDocNo', JsonNull);
        if TransVehNo <> '' then
            JWriteTransDetais.Add('VehNo', TransVehNo)
        else
            JWriteTransDetais.Add('VehNo', JsonNull);
        if TransVehType <> '' then
            JWriteTransDetais.Add('VehType', TransVehType)
        else
            JWriteTransDetais.Add('VehType', JsonNull);
    end;

    local procedure ReturnStr(Amt: Decimal): Text
    begin
        EXIT(DELCHR(FORMAT(Amt), '=', ','));
    end;

    local procedure RoundAmt(Amt: Decimal): Decimal
    var
    begin
        exit(Round(Amt, 0.01, '='))
    end;

    local procedure TransportMethod(DocNo: Code[20]): text
    var
        TransMethod: Record "Transport Method";
    begin
        if TransMethod.get(DocNo) then begin
            if TransMethod."Transportation Mode" = TransMethod."Transportation Mode"::Road then
                exit('1')
            else
                if TransMethod."Transportation Mode" = TransMethod."Transportation Mode"::Rail then
                    exit('2')
                else
                    if TransMethod."Transportation Mode" = TransMethod."Transportation Mode"::Air then
                        exit('3')
                    else
                        if TransMethod."Transportation Mode" = TransMethod."Transportation Mode"::Ship then
                            exit('4');
        end;
    end;
}