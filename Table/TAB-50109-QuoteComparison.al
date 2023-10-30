table 50109 "Quote Comparison"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Priority No."; Code[5])
        {
            DataClassification = CustomerContent;
        }

        field(3; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"G/L Account",Item,"Fixed Asset";
        }
        field(4; "No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if (Type = filter("G/L Account")) "G/L Account"."No." else
            if (Type = filter(Item)) Item."No." else
            IF (Type = filter("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate()
            var
                Item_Loc: Record Item;
                GLAccount_Loc: Record "G/L Account";
                FixedAssets_Loc: Record "Fixed Asset";
            begin
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
            end;
        }
        field(5; "Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                Vendor_Loc: Record Vendor;
            begin
                IF Vendor_Loc.Get(Rec."Vendor Code") then
                    Rec."Vendor Name" := Vendor_Loc.Name
                else
                    Rec."Vendor Name" := '';

            end;
        }
        field(6; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Indent Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Indent Approved Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(10; "Total Indent Qty. Cost"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; Freight; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Delivery Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Payment Term"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms".Code;
        }
        field(15; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,"PO Created",Cancelled,Rejected,"Not Qualified";
        }
        field(16; "PO Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; Remarks; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Approver Remarks"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Outstanding Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Substrate Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(23; "Substrate Type"; Code[50])
        {
            TableRelation = "Substrate-Paper Quality Master".Code where(Type = filter(Substrate));
            DataClassification = ToBeClassified;
        }
        field(24; Length; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; Width; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Area (Sq Mtr)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
        }
        field(27; "Total PO Qty. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; "Select to Approve"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(29; "Sender UserID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Send DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Approver UserID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(32; "PO No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(33; "PO Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        Field(34; Pending; Boolean)
        {
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status, Select, "Indent No.", "Indent Line No", Type, No)
        {

        }
        key(key3; Status, Select)
        {

        }
        key(key4; "Indent No.", Type, No, "Unit Cost")
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if (Rec."Indent No." <> '') then
            Error(('Those line having Indent No. in Quote Comparision Lines can not be deleted'));

    end;

    trigger OnRename()
    begin

    end;

}