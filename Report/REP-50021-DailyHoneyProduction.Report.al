report 50021 "Daily Honey Production Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\ReportLayout\DailyHoneyProductionReport.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            // DataItemTableView = sorting("No.") where("Planning Type" = filter('FG Honey'));
            RequestFilterFields = "No.";
            column(Type; Cust_Var."Customer Type")
            {

            }
            column(Customer; Cust_Var.Name)
            {

            }
            column(FG_Code; "No.")
            {

            }
            column(Item_Desc; Description)
            {

            }
            column(Brand; Brand)
            {

            }
            column(Wt; weight)
            {

            }
            column(Packing; Packing)
            {

            }
            column(Opening_Stock; '')
            {

            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                column(Location_Code; "Location Code")
                {

                }
                column(Filled; '')
                {

                }
                column(Packed; Quantity)
                {

                }
                trigger OnAfterGetRecord()
                begin

                end;

            }
            trigger OnAfterGetRecord()
            begin
                Cust_Var.Get(Item."Customer Code");
            end;
        }


    }

    /* requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(From_Date; From_Date)
                    {
                        ApplicationArea = All;

                    }
                    field(To_Date; To_Date)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    } */

    /* rendering
    {
        layout(LayoutName)
        {
            Type = Excel;
            LayoutFile = 'mySpreadsheet.xlsx';
        }
    } */

    var
        From_Date: Date;
        To_Date: Date;
        Var_Packing: Integer;
        Var_Filled: Decimal;
        Cust_Var: Record Customer;
        ILE_Var: Record "Item Ledger Entry";
}