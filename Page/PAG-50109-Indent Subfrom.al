page 50109 "Indent Subform"
{
    PageType = ListPart;
    SourceTable = "Pre Indent Line";
    AutoSplitKey = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Requisition No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = all;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                    ShowMandatory = true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Editable = false;
                }
                field("Full Description"; Rec."Full Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ShowMandatory = true;
                }
                field("PM Item Type"; Rec."PM Item Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                }
                field("Size of Label"; Rec."Size of Label")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Substrate Type"; Rec."Substrate Type")
                {
                    ApplicationArea = All;
                }
                field(Reamrk; Rec.Reamrk)
                {
                    ApplicationArea = all;
                }
                field(UOM; Rec.UOM)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM field.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM field.';

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Enabled = rec."No." <> '';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                    CurrPage.SaveRecord();
                end;
            }
        }
    }
}