pageextension 50107 Item extends "Item Card"
{
    layout
    {

        addafter(Description)
        {
            field("Full Description"; Rec."Full Description")
            {
                ApplicationArea = all;
            }
            field("Planning type"; Rec."Planning type")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    PMItemTypeEditable();
                    CurrPage.Update(true);
                end;
            }
            field("PM Item Type"; Rec."PM Item Type")
            {
                ApplicationArea = all;
                Editable = ItemTypeEditable;
            }
            field(Length; Rec.Length)
            {
                ApplicationArea = all;
                Editable = ItemTypeEditable;

            }
            field(Width; Rec.Width)
            {
                ApplicationArea = all;
                Editable = ItemTypeEditable;
            }
        }
    }

    actions
    {
        modify(SendApprovalRequest)
        {
            trigger onBeforeAction()
            var
            begin
                Rec.TestField("Planning type");
                IF (Rec."Planning type" = Rec."Planning type"::PM) then begin
                    Rec.TestField("PM Item Type");
                    Rec.TestField(Length);
                    Rec.TestField(Width);
                end;
            end;
        }

    }
    trigger OnOpenPage()
    begin
        PMItemTypeEditable();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        PMItemTypeEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        PMItemTypeEditable();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF (CloseAction = CloseAction::OK) or (CloseAction = CloseAction::LookupOK) then begin
            Rec.TestField("Planning type");
            IF (Rec."Planning type" = Rec."Planning type"::PM) then begin
                Rec.TestField("PM Item Type");
                Rec.TestField(Length);
                Rec.TestField(Width);
            end;

        end;
    end;

    var
        myInt: Integer;
        ItemTypeEditable: Boolean;

    procedure PMItemTypeEditable()
    begin
        begin
            IF (Rec."Planning type" = Rec."Planning type"::PM) then
                ItemTypeEditable := true
            else begin
                ItemTypeEditable := false;
                Rec."PM Item Type" := Rec."PM Item Type"::Blank;
                Rec.Length := 0;
                Rec.Width := 0;
            end;
        end;
    end;
}