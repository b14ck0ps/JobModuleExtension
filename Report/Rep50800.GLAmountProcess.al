report 50800 "G/L Amount Process"
{
    ApplicationArea = All;
    Caption = 'G/L Amount Process';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Job Planning Line"; "Job Planning Line")
        {
            dataitem(GLEntry; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                trigger OnPreDataItem()
                begin
                    if FirstPostingDate <> 0D then
                        GLEntry.SETRANGE("Posting Date", FirstPostingDate, LastPostingDate);
                end;

                trigger OnAfterGetRecord()
                begin
                    TotalAmount += GLEntry.Amount;
                end;

                trigger OnPostDataItem()
                begin
                    TotalAmount := TotalAmount / Days;
                    "Job Planning Line".Validate("Unit Cost", TotalAmount);
                    "Job Planning Line".Modify(true);
                end;
            }

            trigger OnPreDataItem()

            begin
                Days := LastPostingDate - FirstPostingDate;
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter By Posting Date")
                {
                    field("First Posting Date"; FirstPostingDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Last Posting Date"; LastPostingDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        // TotalAmount := TotalAmount / Days;
    end;

    var
        TotalAmount: Decimal;
        Days: Integer;
        FirstPostingDate: Date;
        LastPostingDate: Date;

    procedure GetTotalAmount(): Decimal
    begin
        exit(TotalAmount);
    end;
}