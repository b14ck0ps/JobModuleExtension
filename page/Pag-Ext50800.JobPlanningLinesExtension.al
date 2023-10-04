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
                    Caption = '&Calculate Amount';
                    Image = Calculate;
                    ToolTip = 'Calculate the job planning lines';

                    trigger OnAction()
                    var
                        Jobline: Record "Job Planning Line";
                        GL_AmountProcess: Report "G/L Amount Process";
                    begin
                        Jobline.SetRange("Job No.", Rec."Job No.");
                        Jobline.SetRange("Job Task No.", Rec."Job Task No.");

                        if Jobline.FindFirst() then
                            GL_AmountProcess.SetTableView(Jobline);
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

