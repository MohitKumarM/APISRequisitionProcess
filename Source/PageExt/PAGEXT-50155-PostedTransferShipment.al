pageextension 50155 EInvPostedTransferShipment extends "Posted Transfer Shipment"
{
    layout
    {
        modify("Transport Method")
        {
            Editable = true;
        }
        modify("Vehicle No.")
        {
            Editable = true;
        }
        modify("Vehicle Type")
        {
            Editable = true;
        }
        addafter("Foreign Trade")
        {
            group("E-Invoice Information")
            {
                field("IRN Hash"; Rec."IRN Hash")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Acknowledgement No."; Rec."Acknowledgement No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Acknowledgement Date"; Rec."Acknowledgement Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("QR Code"; Rec."QR Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Cancel Reason"; Rec."Cancel Reason")
                {
                    ApplicationArea = all;
                }
                field("Cancel Remarks"; Rec."Cancel Remarks")
                {
                    ApplicationArea = all;
                }
                field("Irn Cancel DateTime"; Rec."Irn Cancel DateTime")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("E-Way Bill No."; Rec."E-Way Bill No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("E-Way Bill Date Time"; Rec."E-Way Bill Date Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("E-Way Bill Cancel DateTime"; Rec."E-Way Bill Cancel DateTime")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter("Co&mments")
        {
            group("E-Invoice")
            {
                action("Create IRN No.")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    begin
                        if Confirm('Do you want to create IRN No.?', false) then begin
                            Clear(EInvoiceGeneration);
                            EInvoiceGeneration.GenerateIRN(Rec."No.", 3, true);
                        end
                    end;
                }
                action("Check Payload")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    begin
                        if Confirm('Do you want to create IRN No.?', false) then begin
                            Clear(EInvoiceGeneration);
                            EInvoiceGeneration.GenerateIRN(Rec."No.", 3, false);
                        end
                    end;
                }
                action("E-Invoice Log")
                {
                    ApplicationArea = All;
                    RunObject = page "E-Invoice Log";
                    RunPageLink = "Document Type" = filter('Invoice'),
                    "No." = field("No.");
                }
                action("Cancel Irn")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    begin
                        if Confirm('Do you want to Cancel Irn No.?', false) then begin
                            Rec.TestField("IRN Hash");
                            Rec.TestField("Irn Cancel DateTime", 0DT);
                            Clear(EInvoiceGeneration);
                            EInvoiceGeneration.CancelIRN(Rec."No.", 3);
                        end
                    end;
                }
            }
            group("E-Way Bill")
            {
                action("Generate E-Way Bill")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EWaybillGeneration: Codeunit "E-Way Bill Generartion";
                    begin
                        if Confirm('Do you want to Generate E-Way Bill No.?', false) then begin
                            Rec.TestField("IRN Hash");
                            Rec.TestField("Irn Cancel DateTime", 0DT);
                            Rec.TestField("E-Way Bill No.", '');
                            Clear(EWaybillGeneration);
                            EWaybillGeneration.GenerateEWayBillFromIRN(Rec."No.", 3);
                        end
                    end;
                }
                action("Cancel E-Way Bill")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        EWaybillGeneration: Codeunit "E-Way Bill Generartion";
                    begin
                        if Confirm('Do you want to Cancel E-Way Bill No.?', false) then begin
                            Rec.TestField("E-Way Bill Cancel DateTime", 0DT);
                            Rec.TestField("E-Way Bill No.");
                            Clear(EWaybillGeneration);
                            EWaybillGeneration.CancelEWayBill(Rec."No.", 3);
                        end
                    end;
                }
            }
        }
    }
}