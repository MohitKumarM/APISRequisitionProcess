table 50106 "Substrate-Paper Quality Master"
{
    Caption = 'Substrate-Paper Quality Maste';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Paper Quality";
    LookupPageId = "Paper Quality";

    fields
    {
        field(1; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Carton,Partition,Plate,Pouch,Substrate;
        }
        field(2; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Type, Code)
        {
            Clustered = true;
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

    end;

    trigger OnRename()
    begin

    end;

}