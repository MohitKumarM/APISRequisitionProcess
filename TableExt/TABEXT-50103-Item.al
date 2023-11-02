tableextension 50103 Item extends Item
{
    fields
    {
        field(50016; "Full Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "PM Item Type"; Option)
        {
            OptionMembers = Blank,Bottle,Cap,Label,Carton,Pouch;
        }
        field(50018; Length; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; Width; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Planning type"; option)
        {
            OptionMembers = "FG-Honey","FG-Non Honey",PM,"RM-Honey","RM-NonHoney";
        }
    }

    var
        myInt: Integer;
}