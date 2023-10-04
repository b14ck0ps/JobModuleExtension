pageextension 50800 "Job Planning Lines Extension" extends "Job Planning Lines"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst(processing)
        {
            group(General)
            {
                action(Calculate)
                {
                    ApplicationArea = Reservation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = '&Calculate';
                    Ellipsis = true;
                    Image = Calculate;
                    ToolTip = 'Calculate the job planning lines';

                    trigger OnAction()
                    var
                        "G/L Entry": Record "G/L Entry";
                        GL_AmountProcess: Report "G/L Amount Process";
                    begin
                        "G/L Entry".SetRange("G/L Account No.", Rec."No.");
                        if "G/L Entry".FindFirst() then
                            GL_AmountProcess.SetTableView("G/L Entry");
                        GL_AmountProcess.RunModal();
                        TotalAmount := GL_AmountProcess.GetTotalAmount();

                        Rec."Unit Cost" := TotalAmount;

                    end;
                }
            }
        }
    }

    var
        TotalAmount: Decimal;
}

