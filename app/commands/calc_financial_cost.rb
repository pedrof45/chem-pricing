class CalcFinancialCost < PowerTypes::Command.new(:payment_term)
  def perform
    # TODO validate payment term range ( > 0? )
    # TODO Handle Sys Var Unset
    return 0 if @payment_term.to_i == 0 # 0 or nil
    interest_sys_var = case @payment_term
                         when (0..30)
                           :interest_2_30
                         when (31..60)
                           :interest_31_60
                         else
                           :interest_more_60
                       end
    interest = SystemVariable.get interest_sys_var
    ((interest + 1.0)**(@payment_term/ 30.0)) -1.0
  end
end
