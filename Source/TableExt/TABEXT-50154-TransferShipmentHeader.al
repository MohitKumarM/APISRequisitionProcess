tableextension 50154 EInvTransferShipmentHeader extends "Transfer Shipment Header"
{
    fields
    {
        field(50150; "QR Code"; Blob)
        {
            Subtype = Bitmap;
            DataClassification = ToBeClassified;
        }
        field(50151; "IRN Hash"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50152; "Acknowledgement No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50153; "Acknowledgement Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50154; "Cancel Remarks"; Enum "Cancel Remarks")
        {
            DataClassification = ToBeClassified;
        }
        field(50155; "Cancel Reason"; Enum "e-Invoice Cancel Reason")
        {
            DataClassification = ToBeClassified;
        }
        field(50156; "Irn Cancel DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}