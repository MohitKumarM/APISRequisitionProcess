page 50119 "Carton Costing"
{
    ApplicationArea = All;
    Caption = 'Carton Costing';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "CZ Header";
    SourceTableView = where(Type = filter(Carton));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Product No."; Rec."Product No.")
                {
                    ToolTip = 'Specifies the value of the Product No. field.';
                    Editable = false;
                }

                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.';

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    TableRelation = Vendor.Name;
                    Editable = false;
                }
                field("Main Item Code"; Rec."Main Item Code")
                {
                    ToolTip = 'Specifies the value of the Main Item Code field.';

                }
                field("Main Item Name"; Rec."Main Item Name")
                {
                    ToolTip = 'Specifies the value of the Main Item Name field.';
                    Editable = false;
                }

                field("Length Inch"; Rec."Length Inch")
                {
                    ToolTip = 'Specifies the value of the Length Inch field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Length MM"; Rec."Length MM")
                {
                    ToolTip = 'Specifies the value of the Length MM field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Width Inch"; Rec."Width Inch")
                {
                    ToolTip = 'Specifies the value of the Width Inch field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Width MM"; Rec."Width MM")
                {
                    ToolTip = 'Specifies the value of the Width MM field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Height Inch"; Rec."Height Inch")
                {
                    ToolTip = 'Specifies the value of the Height Inch field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Height MM"; Rec."Height MM")
                {
                    ToolTip = 'Specifies the value of the Height MM field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Total Length"; Rec."Total Length")
                {
                    ToolTip = 'Specifies the value of the Total Length field.';
                    Editable = false;
                }
                field("Length Deviation"; Rec."Length Deviation")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Total Width"; Rec."Total Width")
                {
                    ToolTip = 'Specifies the value of the Total Width field.';
                    Editable = false;
                }
                field("Width Deviation"; Rec."Width Deviation")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field(Conversion; Rec.Conversion)
                {
                    ToolTip = 'Specifies the value of the Conversion field.';
                    trigger OnValidate()
                    begin
                        Rec.CalculateCartonCostingHeader();
                    end;
                }
                field("Conversion Price"; Rec."Conversion Price")
                {
                    Editable = false;
                }
                field(Printing; Rec.Printing)
                {
                    ToolTip = 'Specifies the value of the Printing field.';
                }

                field("Type Of Partitions"; TypeOfPartitions)
                {
                    Editable = false;

                    trigger OnDrillDown();
                    var
                        CZHeader_Loc: Record "CZ Header";
                        PartitionList: Page "Partition Costing List";
                    begin
                        CZHeader_Loc.Reset();
                        CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
                        CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Partition);
                        IF CZHeader_Loc.FindSet() then;
                        TotalPartitions := CZHeader_Loc.Count;
                        PartitionList.LookupMode(true);
                        PartitionList.RunModal();
                    end;
                }
                field("Total Partitions"; TotalPartitions)
                {
                    Editable = false;
                }
                field("Type Of Plates"; TypeOfPlates)
                {
                    Editable = false;

                    trigger OnDrillDown();
                    var
                        CZHeader_Loc: Record "CZ Header";
                        PlateList: Page "Plate Costing List";
                    begin
                        CZHeader_Loc.Reset();
                        CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
                        CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Plate);
                        IF CZHeader_Loc.FindSet() then;
                        TotalPartitions := CZHeader_Loc.Count;
                        PlateList.LookupMode(true);
                        PlateList.RunModal();
                    end;
                }
                field("Total Plates"; TotalPlates)
                {
                    Editable = false;
                }
                field("Rate Per Box/PCs"; Rec."Rate Per Box/PCs")
                {
                    ToolTip = 'Specifies the value of the Rate Per Box/PCs field.';
                    Editable = false;
                }
                field("Total Partition Cost"; TotalPartitionCost)
                {
                    Caption = 'Total Partition Cost';
                    Editable = false;
                }
                field("Total Plate Cost"; TotalPlateCost)
                {
                    Caption = 'TotalPlateCost';
                    Editable = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Editable = false;
                }
            }
            part(CartonLines; "Carton Lines")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Product No." = field("Product No."), Type = field(Type),
                "Type Line No." = field("Type Line No."), "Vendor Code" = field("Vendor Code"), "Main Item Code" = field("Main Item Code");
                UpdatePropagation = Both;
            }

        }

    }
    actions
    {
        area(navigation)
        {

            action(Partitions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Partitions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Statistics;
                RunObject = page "Partition Costing List";
                RunPageLink = "Product No." = field("Product No."), Type = filter(Partition), "Vendor Code" = field("Vendor Code");

            }
            action(Plates)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Plates';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Plate Costing List";
                RunPageLink = "Product No." = field("Product No."), Type = filter(Plate), "Vendor Code" = field("Vendor Code");

            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateTotalPartitionPlate();
        Rec.CalculateCartonCostingHeader();
    end;

    trigger OnAfterGetRecord()
    var
    begin
        UpdateTotalPartitionPlate();
        Rec.CalculateCartonCostingHeader();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTotalPartitionPlate();
        Rec.CalculateCartonCostingHeader();
    end;

    procedure UpdateTotalPartitionPlate()
    var
        CZHeader_Loc: Record "CZ Header";
    begin
        Clear(TotalPartitions);
        Clear(TotalPlates);
        Clear(TypeOfPartitions);
        Clear(TypeOfPlates);
        CZHeader_Loc.Reset();
        CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
        CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Partition);
        IF CZHeader_Loc.FindSet() then begin
            TypeOfPartitions := CZHeader_Loc.Count;
            Clear(TotalPartitionCost);
            repeat
                TotalPartitions += CZHeader_Loc."No. of Pcs";
                TotalPartitionCost += (CZHeader_Loc."Total Cost");
            until CZHeader_Loc.Next() = 0;
        end;
        CZHeader_Loc.Reset();
        CZHeader_Loc.SetRange("Product No.", Rec."Product No.");
        CZHeader_Loc.SetRange(Type, CZHeader_Loc.Type::Plate);
        IF CZHeader_Loc.FindSet() then begin
            TypeOfPlates := CZHeader_Loc.Count;
            Clear(TotalPlateCost);
            repeat
                TotalPlates += CZHeader_Loc."No. of Pcs";
                TotalPlateCost += (CZHeader_Loc."Total Cost");
            until CZHeader_Loc.Next() = 0;
        end;

    end;


    var

        TypeOfPartitions: Integer;
        TypeOfPlates: Integer;
        TotalPartitions: Integer;
        TotalPlates: Integer;
        TotalPartitionCost: Decimal;
        TotalPlateCost: Decimal;

}
