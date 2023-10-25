table 50102 E_Invoice_Log
{
    DataClassification = ToBeClassified;
    LookupPageId = "E-Invoice Log";

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Invoice,"Credit Memo";
        }
        field(3; "G_IRN Sent Request"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "G_IRN Output Response"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "QR Code"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(6; "IRN Hash"; text[64])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Acknowledge No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Acknowledge Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Current Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "IRN Status"; Enum "Irn Status")
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Irn Cancel Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Error Message"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "C_IRN Sent Request"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(15; "C_IRN Output Response"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(16; "E-Way Bill No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "E-Way Bill Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "G_E-Way bill Sent Request"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(19; "G_E-Way bill Output Response"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(20; "E-Way Bill Status"; Enum "E-Way Bill Status")
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Document Type", "No.", "Line No")
        {
            Clustered = true;
        }
    }
    procedure SendResponse(): Text
    var
        CR: Text[1];
        instr: InStream;
        Encoding: TextEncoding;
        ContentLine: Text;
        Content: Text;
    begin
        CALCFIELDS("G_IRN Sent Request");
        IF NOT "G_IRN Sent Request".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        Clear(Content);
        Clear(instr);
        "G_IRN Sent Request".CreateInStream(instr, TextEncoding::Windows);
        instr.READTEXT(Content);
        WHILE NOT instr.EOS DO BEGIN
            instr.READTEXT(ContentLine);
            Content += CR[1] + ContentLine;
        END;
        exit(Content);
    end;


    procedure GetAPIResponse(): Text
    var
        CR: Text[1];
        instr: InStream;
        Encoding: TextEncoding;
        ContentLine: Text;
        Content: Text;
    begin
        CALCFIELDS("G_IRN Output Response");
        IF NOT "G_IRN Output Response".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        Clear(Content);
        Clear(instr);
        "G_IRN Output Response".CreateInStream(instr, TextEncoding::Windows);
        instr.READTEXT(Content);
        WHILE NOT instr.EOS DO BEGIN
            instr.READTEXT(ContentLine);
            Content += CR[1] + ContentLine;
        END;
        exit(Content);
    end;

    procedure GenerateIRNSentResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("G_IRN Sent Request");
        "G_IRN Sent Request".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;

    procedure GenerateIRNOutPutResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("G_IRN Output Response");
        "G_IRN Output Response".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;

    procedure CancelIRNSentResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("C_IRN Sent Request");
        "C_IRN Sent Request".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;

    procedure CancelIRNOutPutResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("C_IRN Output Response");
        "C_IRN Output Response".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;

    procedure GenerateEWayBillSentResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("G_E-Way bill Sent Request");
        "G_E-Way bill Sent Request".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;

    procedure GenerateEWayBillOutPutResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("G_E-Way bill Output Response");
        "G_E-Way bill Output Response".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;


}