table 50102 E_Invoice_Log
{
    DataClassification = ToBeClassified;

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
        field(3; "Sent Response"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Output Response"; Blob)
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
        field(11; "IRN Generated"; Boolean)
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
        CALCFIELDS("Sent Response");
        IF NOT "Sent Response".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        Clear(Content);
        Clear(instr);
        "Sent Response".CreateInStream(instr, TextEncoding::Windows);
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
        CALCFIELDS("Output Response");
        IF NOT "Output Response".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        Clear(Content);
        Clear(instr);
        "Output Response".CreateInStream(instr, TextEncoding::Windows);
        instr.READTEXT(Content);
        WHILE NOT instr.EOS DO BEGIN
            instr.READTEXT(ContentLine);
            Content += CR[1] + ContentLine;
        END;
        exit(Content);
    end;

    procedure SentResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("Sent Response");
        "Sent Response".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;

    procedure OutPutResponseReadAsText(LineSeparator: Text; Encoding: TextEncoding) Content: Text
    var
        InStream: InStream;
        ContentLine: Text;
    begin
        CALCFIELDS("Output Response");
        "Output Response".CREATEINSTREAM(InStream, Encoding);

        InStream.READTEXT(Content);
        WHILE NOT InStream.EOS DO BEGIN
            InStream.READTEXT(ContentLine);
            Content += LineSeparator + ContentLine;
        END;
    end;


}