report 50100 "Indent Report New"
{
    Caption = 'Indent Report';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    RDLCLayout = '.\ReportLayout\indentReport.rdl';

    dataset
    {
        dataitem("Pre Indent Header"; "Pre Indent Header")
        {
            column(No_; "No.")
            {
            }
            column(Document_Date; "Document Date")
            {

            }
            column(Indent_Remarks; "Indent Remarks")
            {

            }
            column(Indent_Status; "Indent Status")
            {

            }

            dataitem("Pre Indent Line"; "Pre Indent Line")
            {
                DataItemLink = "Indent No." = FIELD("No.");

                column(Indent_No_; "Indent No.")
                {
                }
                column(itemNo_; "No.")
                {

                }

                column(Description; Description)
                {

                }
                column(Full_Description; "Full Description")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(UOM; UOM)
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Amount; Amount)
                {

                }


            }
        }
    }


}