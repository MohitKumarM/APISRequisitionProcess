table 50101 "Pre Indent Line"
{


    fields
    {
        field(1; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"G/L Account",Item,"Fixed Asset";
        }

        field(4; "No."; code[20])
        {

            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account" WHERE(Blocked = CONST(false), "Income/Balance" = const("Income Statement")) ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" where(Blocked = const(false));
            trigger OnValidate()
            begin
                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GlAccount.GET("No.");
                            GlAccount.TESTFIELD("Direct Posting", TRUE);
                            Description := GlAccount.Name;
                            "HSN/SAC Code" := GlAccount."HSN/SAC Code";
                        END;
                    Type::Item:
                        BEGIN
                            Item.Get("No.");
                            Item.TESTFIELD(Blocked, FALSE);
                            Item.TESTFIELD("Base Unit of Measure");
                            //Item.testfield("HSN/SAC Code");
                            Description := Item.Description;
                            UOM := Item."Base Unit of Measure";
                            "HSN/SAC Code" := Item."HSN/SAC Code";
                            "Full Description" := Item."Full Description";
                            "PM Item Type" := Item."PM Item Type";
                            Rec.Validate(Length, Item.Length);
                            Rec.Validate(Width, Item.Width);
                        END;
                    Type::"Fixed Asset":
                        begin
                            FIxedAsset.get("No.");
                            //FIxedAsset.testfield("HSN/SAC Code");
                            Description := FIxedAsset.Description;
                            "HSN/SAC Code" := FIxedAsset."HSN/SAC Code";

                        end;
                END;


            end;
        }
        field(5; "Description"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Remaining Quantity" := Quantity;
                Amount := Quantity * "Unit Price";
            end;
        }
        field(7; "Required Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Required Quantity" > "Remaining Quantity" then
                    error('Required quantity should not be more than remaining quantity');
            end;
        }
        field(8; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "UOM"; code[10])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Purchase Created"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(11; "PO No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "PO Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "MRN No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "MRN Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Approved Qty"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                // if "Approved Qty" > Quantity then
                //     Error('Approved Quantity must be less than quantity');

                IF (Rec."Approved Qty" <> Rec.Quantity) then
                    Rec.TestField(Reamrk);
            end;
        }

        field(16; "HSN/SAC Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Amount := "Unit Price" * Quantity;
            end;
        }
        field(18; "Full Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Reamrk; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            //TableRelation = "Dimension Set Entry";
        }
        field(26; "Shortcut Dimension 1 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(False));
        }
        field(27; "Shortcut Dimension 2 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), blocked = const(false));
        }
        field(28; "Shortcut Dimension 4 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), blocked = const(false));
            // Caption = 'Department Code';
        }
        field(29; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Sent for approval",Cancel,Approved,Closed;
        }
        field(30; "Substrate Type"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = if (type = filter(Item), "PM Item Type" = Filter(Label)) "Substrate-Paper Quality Master".Code where(Type = filter(Substrate));
        }

        field(31; "PM Item Type"; Option)
        {
            OptionMembers = Blank,Bottle,Cap,Label,Carton,Pouch;
            Editable = false;
        }
        field(32; Length; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF (Length <> 0) and (Width <> 0) then begin
                    IF (Rec.Type = Rec.Type::Item) and (Rec."PM Item Type" = Rec."PM Item Type"::Label) then
                        "Size of Label" := ((Length * Width) / 645);
                end else
                    "Size of Label" := 0;
            end;
        }
        field(33; Width; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF (Length <> 0) and (Width <> 0) then begin
                    IF (Rec.Type = Rec.Type::Item) and (Rec."PM Item Type" = Rec."PM Item Type"::Label) then
                        "Size of Label" := ((Length * Width) / 645);
                end else
                    "Size of Label" := 0;
            end;
        }
        field(34; "Size of Label"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "Location Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }


    }

    keys
    {
        key(key1; "Indent No.", "Line No")
        {
            Clustered = true;
        }
        key(key2; Type, "No.")
        {
            IncludedFields = Quantity;
        }
    }

    trigger OnDelete()
    begin
        IndentHeader.Reset();
        IndentHeader.setrange("No.", Rec."Indent No.");
        if IndentHeader.FindFirst then
            IndentHeader.TestField(Status, IndentHeader.Status::Open);
    end;

    trigger OnInsert()
    begin
        IndentHeader.Reset();
        IndentHeader.setrange("No.", Rec."Indent No.");
        if IndentHeader.FindFirst then begin
            IndentHeader.TestField(Status, IndentHeader.Status::Open);
            Rec."Location Code" := IndentHeader."Location Code";
        end;




    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
        DimMgt: Codeunit DimensionManagement;
    begin

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Indent No.", "Line No"));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    var
        Item: Record Item;
        FIxedAsset: Record "Fixed Asset";
        GlAccount: Record "G/L Account";
        IndentHeader: Record "Pre Indent Header";

}